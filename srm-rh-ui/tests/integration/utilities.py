import requests


def populate_firestore_with_active_uac():
    populate_firestore_collection_exercise()

    headers = {
        'Content-Type': 'application/json',
    }

    active_uac_json_data = {
        'fields': {
            'uacHash': {
                'stringValue': '18530d537eb87bca7338c3a2ee206c9b3dd4cde29cb0302706eb6549ee7adb57'
            },
            'qid': {
                'stringValue': '0130000000000100'
            },
            'receiptReceived': {
                'booleanValue': False
            },
            'caseId': {
                'stringValue': '26a0c774-f8ec-46ee-a8aa-170da8ccf142'
            },
            'active': {
                'booleanValue': True
            },
            'collectionExerciseId': {
                'stringValue': '7101b1ce-8034-4bce-bce1-9a1aef67d5cb'
            },
            'surveyId': {
                'stringValue': 'a4239acc-5c35-46f1-a5d6-b763a959b233'
            }
        },
    }

    requests.post(
        'http://localhost:9542/v1/projects/rh-ui-project/databases/(default)/ \
        documents/uac?documentId=18530d537eb87bca7338c3a2ee206c9b3dd4cde29cb0302706eb6549ee7adb57',
        headers=headers,
        json=active_uac_json_data,
    )

    active_case_json_data = {
        'fields': {
            "collectionExerciseId": {
                "stringValue": "7101b1ce-8034-4bce-bce1-9a1aef67d5cb"
            },
            "caseId": {
                "stringValue": "26a0c774-f8ec-46ee-a8aa-170da8ccf142"
            },
            "invalid": {
                "booleanValue": False
            },
            "refusalReceived": {
                "stringValue": ""
            },
            "sample": {
                "mapValue": {
                    "fields": {
                        "BLOOD_TEST_BARCODE": {
                            "stringValue": ""
                        }
                    }
                }
            }
        }
    }
    requests.post(
        'http://localhost:9542/v1/projects/rh-ui-project/databases/(default)/ \
        documents/case?documentId=26a0c774-f8ec-46ee-a8aa-170da8ccf142',
        headers=headers,
        json=active_case_json_data,
    )


def populate_firestore_with_inactive_uac():
    populate_firestore_collection_exercise()

    headers = {
        'Content-Type': 'application/json',
    }

    inactive_uac_json_data = {
        'fields': {
            'uacHash': {
                'stringValue': '64449321ef96e9c2d0dbb3cd4b14fecd1c21928b08d41507001fe8c55215f733'
            },
            'qid': {
                'stringValue': '0130000000000200'
            },
            'receiptReceived': {
                'booleanValue': True
            },
            'caseId': {
                'stringValue': 'cea2a121-1df2-4c44-9851-ec161c3f4810'
            },
            'active': {
                'booleanValue': False
            },
            'collectionExerciseId': {
                'stringValue': '7101b1ce-8034-4bce-bce1-9a1aef67d5cb'
            },
            'surveyId': {
                'stringValue': 'a4239acc-5c35-46f1-a5d6-b763a959b233'
            }
        },
    }

    requests.post(
        'http://localhost:9542/v1/projects/rh-ui-project/databases/(default)/ \
        documents/uac?documentId=64449321ef96e9c2d0dbb3cd4b14fecd1c21928b08d41507001fe8c55215f733',
        headers=headers,
        json=inactive_uac_json_data,
    )

    inactive_case_json_data = {
        'fields': {
            "collectionExerciseId": {
                "stringValue": "7101b1ce-8034-4bce-bce1-9a1aef67d5cb"
            },
            "caseId": {
                "stringValue": "cea2a121-1df2-4c44-9851-ec161c3f4810"
            },
            "invalid": {
                "booleanValue": False
            },
            "refusalReceived": {
                "stringValue": ""
            },
            "sample": {
                "mapValue": {
                    "fields": {
                        "BLOOD_TEST_BARCODE": {
                            "stringValue": ""
                        }
                    }
                }
            }
        }
    }
    requests.post(
        'http://localhost:9542/v1/projects/rh-ui-project/databases/(default)/ \
        documents/case?documentId=cea2a121-1df2-4c44-9851-ec161c3f4810',
        headers=headers,
        json=inactive_case_json_data,
    )


def populate_firestore_collection_exercise():
    headers = {
        'Content-Type': 'application/json',
    }

    collection_exercise_json_data = {
        "fields": {
            "reference": {
                "stringValue": "MVP012021"
            },
            "metadata": {
                "mapValue": {
                    "fields": {
                        "test": {
                            "stringValue": "passed"
                        }
                    }
                }
            },
            "surveyId": {
                "stringValue": "a4239acc-5c35-46f1-a5d6-b763a959b233"
            },
            "collectionExerciseId": {
                "stringValue": "7101b1ce-8034-4bce-bce1-9a1aef67d5cb"
            },
            "endDate": {
                "timestampValue": "2030-09-13T12:18:42.952Z"
            },
            "collectionInstrumentRules": {
                "arrayValue": {
                    "values": [{
                        "mapValue": {
                            "fields": {
                                "eqLaunchSettings": {
                                    "arrayValue": {
                                    }
                                },
                                "collectionInstrumentUrl": {
                                    "stringValue": "http://test-eq.com/test-schema"
                                }
                            }
                        }
                    }]
                }
            },
            "name": {
                "stringValue": "test collex 09/11/2023, 13:18:42"
            },
            "startDate": {
                "timestampValue": "2023-09-11T12:18:42.952Z"
            }
        }
    }

    requests.post(
        'http://localhost:9542/v1/projects/rh-ui-project/databases/(default)/ \
        documents/collection-exercise?documentId=7101b1ce-8034-4bce-bce1-9a1aef67d5cb',
        headers=headers,
        json=collection_exercise_json_data,
    )
