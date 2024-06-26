import logging
import sys

# Clean logfile
open('logfile.log', 'w').close()

# Create log format
log_format = logging.Formatter('%(asctime)s - %(name)-25s - %(levelname)s - %(message)s')

# Create console handler
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
console_handler.setFormatter(log_format)

# Create file handler
file_handler = logging.FileHandler('logfile.log')
file_handler.setLevel(logging.INFO)
file_handler.setFormatter(log_format)

# Configure logger
def prepare_logger():
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)

    if not logger.hasHandlers():

        # Add handlers to logger
        logger.addHandler(console_handler)
        logger.addHandler(file_handler)

    return logger