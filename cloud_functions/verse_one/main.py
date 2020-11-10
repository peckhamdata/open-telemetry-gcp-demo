import sys
import logging
from os import environ
from barium_meal import BariumMeal

logger = logging.getLogger('verse_one')

logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler(sys.stdout))


def entry_point(event, context):

    collector_endpoint = environ['COLLECTOR_ENDPOINT']

    bm = BariumMeal(jaeger_config={'collector_endpoint': collector_endpoint,
                                   'service_name': 'verse one'})

    tracer = bm.get_tracer()

    with tracer.start_as_current_span(name="verse_one") as span:

        lyric = "Don't you ever, don't you ever"
        logger.info(lyric)
        span.add_event(lyric)
