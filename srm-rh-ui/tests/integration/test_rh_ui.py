from tests.integration.utilities import populate_firestore_with_active_uac, populate_firestore_with_inactive_uac


def test_get_rh_ui_en(test_client):
    # When
    response = test_client.get("/en/start/")

    # Then
    assert response.status_code == 200


def test_submit_invalid_uac(test_client):
    # When
    response = test_client.post("/en/start/", data={
        "uac": "1234567812345678"
    })

    # Then
    assert response.status_code == 401
    assert "Access code not recognised. Enter the code again." in response.text


def test_submit_active_uac(test_client):
    # Given
    populate_firestore_with_active_uac()

    # When
    response = test_client.post("/en/start/", data={
        "uac": "K5LXF24K6HHNT2XX"
    })

    # Then
    assert response.status_code == 302
    assert "session?token=" in response.location


def test_submit_inactive_uac(test_client):
    # Given
    populate_firestore_with_inactive_uac()

    # When
    response = test_client.post("/en/start/", data={
        "uac": "KJNQVGC573QLTGR8"
    })

    # Then
    assert response.status_code == 200
    assert "This access code has already been used" in response.text
