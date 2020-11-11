from os import environ
from flask import Flask
import main

def test_chorus():
    app = Flask(__name__)
    with app.app_context():
        request = {}
        environ["COLLECTOR_ENDPOINT"] = "jaeger"
        response = main.entry_point(request)
        assert response.status_code == 200