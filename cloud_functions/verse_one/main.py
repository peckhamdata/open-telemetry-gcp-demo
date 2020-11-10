import sys
import logging

logger = logging.getLogger('verse_one')

logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler(sys.stdout))


def entry_point(event, context):
    logger.info("Don't you ever, don't you ever")