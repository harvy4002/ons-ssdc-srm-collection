from unittest.mock import patch, Mock

from requests import HTTPError


def test_404_handled(test_client):
    response = test_client.get('/non-existent-endpoint')

    assert response.status_code == 404
    assert 'If you entered a web address, check it is correct' in response.text


def test_404_cy_handled(test_client):
    response = test_client.get('/cy/non-existent-endpoint')

    assert response.status_code == 404
    assert "Heb ddod o hyd i'r dudalen" in response.text


def test_500_handled(test_client):
    mock_inactive_uac_response = Mock()
    mock_inactive_uac_response.status_code = 500
    mock_inactive_uac_response.raise_for_status.side_effect = HTTPError(response=mock_inactive_uac_response)

    with patch('rh_ui.controllers.rh_service.requests.get') as mock_get:
        mock_get.return_value = mock_inactive_uac_response
        response = test_client.post('/en/start', data={"access-code": "1234123412341234"}, follow_redirects=True)

    assert response.status_code == 500
    assert 'Sorry, something went wrong' in response.text


def test_500_cy_handled(test_client):
    mock_inactive_uac_response = Mock()
    mock_inactive_uac_response.status_code = 500
    mock_inactive_uac_response.raise_for_status.side_effect = HTTPError(response=mock_inactive_uac_response)

    with patch('rh_ui.controllers.rh_service.requests.get') as mock_get:
        mock_get.return_value = mock_inactive_uac_response
        response = test_client.post('/cy/start', data={"access-code": "1234123412341234"}, follow_redirects=True)

    assert response.status_code == 500
    assert 'Mae’n ddrwg gennym, aeth rhywbeth o’i le' in response.text
