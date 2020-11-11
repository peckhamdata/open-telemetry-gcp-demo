import sys
import logging
from os import environ
from flask import jsonify
from barium_meal import BariumMeal

logger = logging.getLogger('chorus')

logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler(sys.stdout))

collector_endpoint = environ['COLLECTOR_ENDPOINT']

bm = BariumMeal(jaeger_config={'collector_endpoint': collector_endpoint,
                               'service_name': 'chorus'})

tracer = bm.get_tracer()

def entry_point(request):

    if 'traceparent' in request.headers:
        bm.get_context_from_headers(request.headers)

    with tracer.start_as_current_span(name="chorus") as span:

        lyrics = ["Prince Charming",
                  "Prince Charming",
                  "Ridicule is nothing to be scared of",
                  "Don't you ever, don't you ever",
                  "Stop being dandy, showing me you're handsome"]

        for lyric in lyrics:
            with tracer.start_as_current_span(name=lyric):

                logger.info(lyric)
                span.add_event(lyric)

    return jsonify({})