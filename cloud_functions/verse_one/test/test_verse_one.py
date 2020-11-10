import json
from mock import patch, MagicMock
from pytest import fixture
from os import environ
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

def test_get_data_from_pubsub(event, context):

    main.entry_point(event, context)