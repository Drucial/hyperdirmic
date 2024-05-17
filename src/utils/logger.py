# src/utils/logger.py

import logging
import os

def setup_logging(log_level=logging.INFO):
    log_file = "/tmp/hyperdirmic.log"
    log_dir = os.path.dirname(log_file)

    # Ensure the log directory exists
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    # Configure logging
    logging.basicConfig(
        filename=log_file,
        level=log_level,
        format="%(asctime)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    # Create a console handler for logging to the console
    console_handler = logging.StreamHandler()
    console_handler.setLevel(log_level)
    console_handler.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(message)s"))

    # Get the root logger and add the console handler to it
    logger = logging.getLogger()
    logger.addHandler(console_handler)
