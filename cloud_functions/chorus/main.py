import sys
import logging
from os import environ
from flask import jsonify
from barium_meal import BariumMeal

logger = logging.getLogger('chorus')

logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler(sys.stdout))

def entry_point(request):

    collector_endpoint = environ['COLLECTOR_ENDPOINT']

    bm = BariumMeal(jaeger_config={'collector_endpoint': collector_endpoint,
                                   'service_name': 'chorus'})

    tracer = bm.get_tracer()

    with tracer.start_as_current_span(name="chorus") as span:

        lyric = "Ridicule is nothing to be scared of"
        logger.info(lyric)
        span.add_event(lyric)

    return jsonify({})