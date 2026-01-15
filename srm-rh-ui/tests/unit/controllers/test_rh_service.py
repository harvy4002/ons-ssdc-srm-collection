from unittest.mock import patch, Mock

from rh_ui.controllers.rh_service import get_eq_token


def test_get_eq_token(test_client):
    mock_response = Mock()
    mock_response.text = 'MOCK_EQ_TOKEN_RESPONSE'
    with patch('rh_ui.controllers.rh_service.requests.get') as mock_get:
        mock_get.return_value = mock_response
        response = get_eq_token('ABCD1234ABCD1234', 'en')

    assert response.text == mock_response.text, 'Expect the response text to the returned'
