import logging
import sys

# Configure logger
def prepare_logger():
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)

    # Create file handler
    file_handler = logging.FileHandler('server.log')
    # Clear the file before writing to it
    open('server.log', 'w').close()
    file_handler.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    # Create console handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    return logger