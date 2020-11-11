from os import environ
from flask import Flask, Request
from mock import patch

environ["COLLECTOR_ENDPOINT"] = "jaeger"

import main

class StubRequest():

    def __init__(self, headers):
        self.headers = headers

@patch('main.logger')
def test_chorus(mock_logger):
    app = Flask(__name__)
    with app.app_context():
        request = StubRequest({'traceparent': '00-0000000000000000000000000000000f-000000000000000a-00'})
        response = main.entry_point(request)
        assert response.status_code == 200
        assert mock_logger.mock_calls[-1][0] == 'info'