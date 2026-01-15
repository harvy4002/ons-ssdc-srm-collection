from unittest.mock import patch, Mock

from requests import HTTPError

RH_SERVICE_GET_PATH = 'rh_ui.controllers.rh_service.requests.get'

EN_START_ROUTE = '/en/start/'
CY_START_ROUTE = '/cy/start/'


def test_en_start_endpoint_success(test_client):
    response = test_client.get(EN_START_ROUTE, follow_redirects=True)

    assert response.status_code == 200
    assert 'ONS Surveys' in response.text
    assert 'Enter your 16-character access code' in response.text


def test_cy_start_endpoint_success(test_client):
    response = test_client.get(CY_START_ROUTE, follow_redirects=True)

    assert response.status_code == 200
    assert "Arolygon SYG" in response.text
    assert "Rhowch eich cod mynediad sy'n cynnwys 16 o nodau" in response.text


def test_en_enter_uac_success(test_client):
    with patch(RH_SERVICE_GET_PATH) as mock_get:
        mock_get.return_value.text = 'MOCKEQTOKEN'
        response = test_client.post(EN_START_ROUTE, data={"uac": "1234567890123456"})

    assert response.status_code == 302
    assert response.location == 'http://localhost:5000/session?token=MOCKEQTOKEN'


def test_en_enter_uac_blank(test_client):
    response = test_client.post(EN_START_ROUTE, data={"uac": ""}, follow_redirects=True)

    assert response.status_code == 401
    assert 'Enter an access code' in response.text


def test_en_enter_uac_invalid_length(test_client):
    response = test_client.post(EN_START_ROUTE, data={"uac": "testing"}, follow_redirects=True)

    assert response.status_code == 401
    assert 'Enter a 16-character access code' in response.text


def test_uac_pattern_match_failure(test_client):
    # When we try to hash a UAC that is an invalid format, then it raises the error
    response = test_client.post(EN_START_ROUTE, data={"uac": 'testing_uac_err-'}, follow_redirects=True)

    assert response.status_code == 401
    assert 'Access code not recognised. Enter the code again.' in response.text


def test_en_enter_uac_inactive(test_client):
    mock_inactive_uac_response = Mock()
    mock_inactive_uac_response.text = 'UAC_INACTIVE'
    mock_inactive_uac_response.status_code = 400
    mock_inactive_uac_response.raise_for_status.side_effect = HTTPError(response=mock_inactive_uac_response)

    with patch(RH_SERVICE_GET_PATH) as mock_get:
        mock_get.return_value = mock_inactive_uac_response
        response = test_client.post(EN_START_ROUTE, data={"uac": "1234123412341234"})

    assert response.status_code == 200
    assert 'This questionnaire has now closed' in response.text


def test_en_enter_uac_receipted(test_client):
    mock_receipted_uac_response = Mock()
    mock_receipted_uac_response.text = 'UAC_RECEIPTED'
    mock_receipted_uac_response.status_code = 400
    mock_receipted_uac_response.raise_for_status.side_effect = HTTPError(response=mock_receipted_uac_response)

    with (patch(RH_SERVICE_GET_PATH) as mock_get):
        mock_get.return_value = mock_receipted_uac_response
        response = test_client.post(EN_START_ROUTE, data={"uac": "1234567890123456"})

    assert response.status_code == 200
    assert 'This access code has already been used' in response.text


def test_en_enter_uac_not_found(test_client):
    mock_invalid_uac_response = Mock()
    mock_invalid_uac_response.status_code = 404
    mock_invalid_uac_response.raise_for_status.side_effect = HTTPError(response=mock_invalid_uac_response)

    with patch(RH_SERVICE_GET_PATH) as mock_get:
        mock_get.return_value = mock_invalid_uac_response
        response = test_client.post(EN_START_ROUTE, data={"uac": "1234567890123456"}, follow_redirects=True)

    assert response.status_code == 401
    assert 'Access code not recognised. Enter the code again.' in response.text
