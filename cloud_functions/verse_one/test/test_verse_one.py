import json
from mock import patch, MagicMock
from pytest import fixture
import main

@fixture
def event():
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
def test_get_data_from_pubsub(mock_logger, event, context):

    main.entry_point(event, context)

    assert mock_logger.mock_calls[-1][0] == 'info'