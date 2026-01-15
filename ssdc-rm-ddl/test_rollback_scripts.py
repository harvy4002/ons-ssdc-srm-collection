import psycopg2
import pytest

from config import Config
from patch_database import get_current_database_version_tag
from rollback_database import ROLLBACK_PATCHES_DIRECTORY, fetch_applied_patch_numbers_reverse_order, rollback_database


def test_rollbacks(db_connection_and_cursor):
    """
    This test will attempt to roll back any patches which have been run into the target database
    (except the ground zero patch record)
    """

    # Given
    db_connection, db_cursor = db_connection_and_cursor
    patches_to_rollback = fetch_applied_patch_numbers_reverse_order(db_cursor=db_cursor)

    if not patches_to_rollback:
        print('NO PATCHES FOUND IN DATABASE TO ROLL BACK')
        return

    number_to_rollback = len(patches_to_rollback)
    rollback_version = 'v0.0.1-rollback.1'

    # When
    rollback_database(number_to_rollback, rollback_version, rollbacks_directory=ROLLBACK_PATCHES_DIRECTORY,
                      db_cursor=db_cursor, db_connection=db_connection)

    # Then
    version_after_rollback = get_version_after_rollback(db_cursor=db_cursor)
    assert version_after_rollback == rollback_version, ('Database version after running the rollback should '
                                                        'match the expected rollback version')


def get_version_after_rollback(db_cursor=None) -> str:
    version_after_rollback = get_current_database_version_tag(db_cursor=db_cursor)
    return version_after_rollback


@pytest.fixture
def db_connection_and_cursor():
    with psycopg2.connect(f"dbname='{Config.DB_NAME}' "
                          f"user='{Config.DB_USERNAME}' "
                          f"host='{Config.DB_HOST}' "
                          f"password='{Config.DB_PASSWORD}' "
                          f"port='{Config.DB_PORT}"
                          f"'{Config.DB_USESSL}") as db_connection:
        db_connection.set_session(autocommit=False)

        with db_connection.cursor() as db_cursor:
            yield db_connection, db_cursor
