import json


def test_get_healthcheck_endpoint(test_client):
    expected_response = {
        'name': 'respondent-home-ui',
    }
    response = test_client.get('/info/')

    assert expected_response == json.loads(response.text)
