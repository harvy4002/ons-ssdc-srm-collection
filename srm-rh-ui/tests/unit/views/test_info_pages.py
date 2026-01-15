def test_cookies_endpoint_success(test_client):
    response = test_client.get('/en/cookies', follow_redirects=True)

    assert response.status_code == 200
    assert 'Cookies on start.surveys.ons.gov.uk' in response.text


def test_cy_cookies_endpoint_success(test_client):
    response = test_client.get('/cy/cookies', follow_redirects=True)

    assert response.status_code == 200
    assert "Cwcis ar start" in response.text


def test_privacy_and_data_protection_endpoint_success(test_client):
    response = test_client.get('/en/privacy-and-data-protection', follow_redirects=True)

    assert response.status_code == 200
    assert '<h1 class="ons-u-fs-xl">Privacy and data protection</h1>' in response.text
