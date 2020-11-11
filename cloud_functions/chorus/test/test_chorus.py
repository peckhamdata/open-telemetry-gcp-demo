from os import environ
from flask import Flask
from mock import patch
import main

@patch('main.logger')
def test_chorus(mock_logger):
    app = Flask(__name__)
    with app.app_context():
        request = {}
        environ["COLLECTOR_ENDPOINT"] = "jaeger"
        response = main.entry_point(request)
        assert response.status_code == 200
        assert mock_logger.mock_calls[-1][0] == 'info'