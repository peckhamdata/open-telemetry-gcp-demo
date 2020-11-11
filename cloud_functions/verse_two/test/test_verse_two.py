import json
from os import environ
from mock import patch, MagicMock
from pytest import fixture
import main

metadata_endpoint = 'http://metadata/computeMetadata/v1/instance/service-accounts/default/identity?audience=https://here-my_project.cloudfunctions.net/chorus'
chorus_endpoint = 'https://here-my_project.cloudfunctions.net/chorus'

@fixture
def event():

    environ["COLLECTOR_ENDPOINT"] = "http://jaeger"
    environ["CHORUS_FUNCTION"] = "chorus"
    environ["LOCATION"] = "here"
    environ["GCP_PROJECT_ID"] = "my_project"

    event = {
        '@type': 'type.googleapis.com/google.pubsub.v1.PubsubMessage',
        'attributes': None,
        'data': json.dumps({'action': 'start'})
    }
    return event

@fixture
def context():
    context = MagicMock()
    context.event_id = 'some-id'
    context.event_type = 'gcs-event'
    return context

@patch('main.logger')
def test_verse_one(mock_logger, requests_mock, event, context):
    requests_mock.get(metadata_endpoint)
    requests_mock.get(chorus_endpoint)
    main.entry_point(event, context)
    assert len(requests_mock.request_history) == 2
    assert mock_logger.mock_calls[-1][0] == 'info'

@patch('main.logger')
def test_chorus_fail(mock_logger, requests_mock, event, context):
    requests_mock.get(metadata_endpoint)
    requests_mock.get(chorus_endpoint, status_code=500)
    main.entry_point(event, context)
    assert len(requests_mock.request_history) == 2
    assert mock_logger.mock_calls[-1][0] == 'error'