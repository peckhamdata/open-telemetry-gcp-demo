import ast
import base64
import sys
import logging
import json
from os import environ
from google.cloud import pubsub_v1
import requests
from barium_meal import BariumMeal

logger = logging.getLogger('verse_one')

logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler(sys.stdout))

collector_endpoint = environ['COLLECTOR_ENDPOINT']

bm = BariumMeal(jaeger_config={'collector_endpoint': collector_endpoint,
                               'service_name': 'verse two'},
                requests=True)

tracer = bm.get_tracer()


def get_auth_token(endpoint):
    metadata_server_url = 'http://metadata/computeMetadata/v1/instance/service-accounts/default/identity?audience='
    token_response = requests.get(f'{metadata_server_url}{endpoint}', headers={'Metadata-Flavor': 'Google'})
    jwt = token_response.text
    return jwt

def entry_point(event, context):

    event_data = ast.literal_eval(base64.b64decode(event['data']).decode('utf-8'))
    bm.get_context_from_event_data(event_data)

    with tracer.start_as_current_span(name="verse_two") as span:

        lyric = "Don't you ever, don't you ever"
        logger.info(lyric)
        span.add_event(lyric)

        with tracer.start_as_current_span(name="sing_chorus") as span:

            chorus_endpoint = f'https://{environ["LOCATION"]}-{environ["GCP_PROJECT_ID"]}.cloudfunctions.net/{environ["CHORUS_FUNCTION"]}'
            auth_token = get_auth_token(chorus_endpoint)
            function_headers = {'Authorization': f'bearer {auth_token}', 'content-type': 'application/json'}
            trace_headers = bm.get_traceparent_header(span)

            request = requests.get(chorus_endpoint,
                                   headers={**function_headers, **trace_headers})
            if request.status_code != 200:
                logger.error(f'{chorus_endpoint} returned:{request.status_code}')
                return

        publisher = pubsub_v1.PublisherClient()
        topic_path = publisher.topic_path(environ['GCP_PROJECT_ID'],
                                          environ['GCP_PUBSUB_VERSE_THREE'])
        message = bm.add_trace({}, span)
        message = json.dumps(message).encode("utf-8")
        result = publisher.publish(topic_path, data=message)
        logger.info(result)