from datetime import datetime, timezone
from pathlib import Path
from unittest.mock import Mock, patch

import pytest

import rollback_database

TEST_ROLLBACKS_DIR = Path(__file__).parent.joinpath('patches', 'rollbacks')


def test_rollback_database():
    # Given
    mock_db_connection = Mock()
    mock_db_cursor = Mock()
    rollback_version = "v0.0.0-rollback.1"

    # Mock the results of the query to fetch applied database patch numbers
    mock_db_cursor.fetchall.return_value = [(2, datetime.now(timezone.utc).replace(tzinfo=None)),
                                            (1, datetime.now(timezone.utc).replace(tzinfo=None)),
                                            (0, datetime.now(timezone.utc).replace(tzinfo=None))]

    # When
    # Try to rollback the last 2 patches
    rollback_database.rollback_database(2,
                                        rollback_version,
                                        TEST_ROLLBACKS_DIR,
                                        db_cursor=mock_db_cursor,
                                        db_connection=mock_db_connection)

    # Then
    cursor_execute_calls = mock_db_cursor.execute.call_args_list
    assert len(cursor_execute_calls) == 6

    # The applied patch numbers should be fetched first
    assert cursor_execute_calls[0][0][0] == ('SELECT patch_number, applied_timestamp FROM ddl_version.patches'
                                             ' ORDER BY applied_timestamp DESC')

    # Then the queries to run the rollback patches and update the patches table for each
    delete_patch_number_query_template = ('DELETE FROM ddl_version.patches WHERE patch_number = %(patch_number)s')
    assert cursor_execute_calls[1][0][0] == delete_patch_number_query_template
    assert cursor_execute_calls[1][0][1]['patch_number'] == 2
    assert cursor_execute_calls[2][0][0] == '2 TEST ROLLBACK'

    assert cursor_execute_calls[3][0][0] == delete_patch_number_query_template
    assert cursor_execute_calls[3][0][1]['patch_number'] == 1
    assert cursor_execute_calls[4][0][0] == '1 TEST ROLLBACK'

    # Then the query to update the DDL version record
    assert cursor_execute_calls[5][0][0] == ("INSERT INTO ddl_version.version (version_tag, updated_timestamp)"
                                             " VALUES (%(rollback_version)s, %(updated_timestamp)s)")
    assert cursor_execute_calls[5][0][1]['rollback_version'] == rollback_version

    # And the updates should be committed once, when everything has run successfully
    mock_db_connection.commit.assert_called_once()


def test_rollback_database_bad_number_of_patches():
    # Given
    mock_db_connection = Mock()
    mock_db_cursor = Mock()
    rollback_version = "v0.0.0-rollback.1"

    # Mock the results of the query to fetch applied database patch numbers, only the ground zero patch
    mock_db_cursor.fetchall.return_value = [(0,)]

    # When, then raises
    with pytest.raises(ValueError) as value_error:
        # Try to roll back when no (non ground zero) patches are recorded
        rollback_database.rollback_database(1,
                                            rollback_version,
                                            TEST_ROLLBACKS_DIR,
                                            db_cursor=mock_db_cursor,
                                            db_connection=mock_db_connection)

    assert str(value_error.value) == ('Could not roll back 1 patch(es) for this database, '
                                      'the recorded applied patch numbers available to roll back are ()'), (
        'The error message should match the expected')
    mock_db_connection.commit.assert_not_called()


def test_rollback_missing_rollback_patch():
    # Given
    mock_db_connection = Mock()
    mock_db_cursor = Mock()
    rollback_version = "v0.0.0-rollback.1"

    # Mock the results of the query to fetch applied database patch numbers,
    # with a patch number we don't have a rollback patch script for
    mock_db_cursor.fetchall.return_value = [(3000, datetime.now(timezone.utc).replace(tzinfo=None)),
                                            (0, datetime.now(timezone.utc).replace(tzinfo=None))]

    # When, then raises
    with pytest.raises(ValueError) as value_error:
        # Try to roll back when no (non ground zero) patches are recorded
        rollback_database.rollback_database(1,
                                            rollback_version,
                                            TEST_ROLLBACKS_DIR,
                                            db_cursor=mock_db_cursor,
                                            db_connection=mock_db_connection)

    assert str(value_error.value) == ('Bad patch number: 3000. No or multiple rollback scripts found for this patch, '
                                      'is this running the in correct DDL version?'), (
        'The error message should match the expected')
    mock_db_connection.commit.assert_not_called()


def test_patch_database_fails_gracefully():
    # Given
    mock_db_connection = Mock()
    mock_db_cursor = Mock()
    rollback_version = "v0.0.0-rollback.1"

    # Mock the results of the query to fetch applied database patch numbers
    mock_db_cursor.fetchall.return_value = [(2, datetime.now(timezone.utc).replace(tzinfo=None)),
                                            (1, datetime.now(timezone.utc).replace(tzinfo=None)),
                                            (0, datetime.now(timezone.utc).replace(tzinfo=None))]

    execute_call_count = 0
    test_exception_message = 'exception raised by test side effect'

    def run_once_then_raise(*_1, **_2):
        nonlocal execute_call_count
        if execute_call_count >= 1:
            raise Exception(test_exception_message)
        execute_call_count += 1

    # Raise an exception on the second call to execute
    mock_db_cursor.execute.side_effect = run_once_then_raise

    # When
    with pytest.raises(Exception) as ex:
        rollback_database.rollback_database(1,
                                            rollback_version,
                                            TEST_ROLLBACKS_DIR,
                                            db_cursor=mock_db_cursor,
                                            db_connection=mock_db_connection)

    # Then
    # First call is to check the applied patches, it should raise the exception on the second
    cursor_execute_calls = mock_db_cursor.execute.call_args_list
    assert len(cursor_execute_calls) == 2

    assert ex.value.args[0] == test_exception_message
    mock_db_connection.commit.assert_not_called()
    mock_db_connection.rollback.assert_called_once()


@patch('rollback_database.input')
def test_user_confirmation(mock_input):
    # Given
    mock_db_connection = Mock()
    mock_db_cursor = Mock()
    rollback_version = "v0.0.0-rollback.1"
    mock_input.return_value = 'yes'

    # Mock the results of the query to fetch applied database patch numbers
    mock_db_cursor.fetchall.return_value = [(1, datetime.now(timezone.utc).replace(tzinfo=None)),
                                            (0, datetime.now(timezone.utc).replace(tzinfo=None))]

    # When
    # Try to rollback the last 1 patches with user confirmation switched on
    rollback_database.rollback_database(1,
                                        rollback_version,
                                        TEST_ROLLBACKS_DIR,
                                        db_cursor=mock_db_cursor,
                                        db_connection=mock_db_connection,
                                        user_confirm=True)

    # Then
    # Check the input was called
    mock_input.assert_called_once()

    # Check it did execute the rollback
    cursor_execute_calls = mock_db_cursor.execute.call_args_list
    assert len(cursor_execute_calls) == 4
    assert cursor_execute_calls[3][0][0] == ("INSERT INTO ddl_version.version (version_tag, updated_timestamp)"
                                             " VALUES (%(rollback_version)s, %(updated_timestamp)s)")
    assert cursor_execute_calls[3][0][1]['rollback_version'] == rollback_version

    # And the updates should be committed once, when everything has run successfully
    mock_db_connection.commit.assert_called_once()


@patch('rollback_database.input')
def test_user_confirmation_abort(mock_input):
    # Given
    mock_db_connection = Mock()
    mock_db_cursor = Mock()
    rollback_version = "v0.0.0-rollback.1"
    mock_input.return_value = 'no'

    # Mock the results of the query to fetch applied database patch numbers
    mock_db_cursor.fetchall.return_value = [(1, datetime.now(timezone.utc).replace(tzinfo=None)),
                                            (0, datetime.now(timezone.utc).replace(tzinfo=None))]

    # When
    # Try to rollback the last 1 patches with user confirmation switched on, but the mock response is now "no"
    with pytest.raises(ValueError) as value_error:
        rollback_database.rollback_database(1,
                                            rollback_version,
                                            TEST_ROLLBACKS_DIR,
                                            db_cursor=mock_db_cursor,
                                            db_connection=mock_db_connection,
                                            user_confirm=True)

    # Then
    # Check the input was called
    mock_input.assert_called_once()
    assert str(value_error.value) == 'Responded "no" instead of "yes", aborting...', (
        'The abort error message should match excepted')

    # Check nothing was committed
    mock_db_connection.commit.assert_not_called()


@pytest.mark.parametrize('version', [
    'v0.0.0-rollback.0',
    'v123.456.789-rollback.1234567890',
    'v1.1.1-rollback.1000000000000',
])
def test_check_rollback_version_valid(version):
    # When, then no exception
    rollback_database.check_rollback_version_format(version)


@pytest.mark.parametrize('version', [
    'foo',
    'v1.1.1',
    'rollback.1',
    'va.b.c-rollback.1',
    'v1.1.1-rollback.a',
])
def test_check_rollback_version_invalid(version):
    # When, then raises
    with pytest.raises(ValueError) as value_error:
        rollback_database.check_rollback_version_format(version)

    assert str(value_error.value) == f'Rollback version must be in the format v*.*.*-rollback.*, got: {version}'
