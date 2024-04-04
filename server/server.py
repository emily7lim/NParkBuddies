""" Main module for the server. """
# Install required packages manually
# Run the following command in the terminal:
# pip install -r requirements.txt

from flask import Flask, request, jsonify
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, relationship
from classes.park import Park
from classes.facility import Facility, FacilityType
from classes.profile import Profile
from classes.booking import Booking
from classes.review import Review
from logger import prepare_logger
import requests
import time
#import threading
import signal
import sys
from functools import wraps

app = Flask(__name__)

logger = prepare_logger()

# Create a SQLAlchemy engine
engine = create_engine('sqlite:///database/nparkbuddy.db', echo=True)

class Database:
    """ Class to represent the database
    """
    def __init__(self):
        """ Method to initialize the database
        """
        self.Session = sessionmaker(bind=engine)
        self.session = self.Session()
        self.parks = []
        self.facilities = []
        self.bookings = []
        self.reviews = []
        self.profiles = []

    def init_db(self):
        """ Method to create all objects
        """
        # Query parks table from the database and create a list of Park objects
        sql = text('SELECT * FROM parks')
        result = self.session.execute(sql)
        for row in result:
            park = Park(id=row[0], name=row[1], latitude=row[2], longitude=row[3])
            self.parks.append(park)

        sql = text('SELECT * FROM facilities')
        result = self.session.execute(sql)
        for row in result:
            park_id = row[2]
            park = next((park for park in self.parks if park.get_id() == park_id), None)
            if park:
                facility = Facility(id=row[0], name=row[1], park=park, type=convert_to_enum(row[3]), avg_rating=row[4], num_ratings=row[5])
                park.set_facilities(facility)
                self.facilities.append(facility)
            else:
                logger.error(f'Park with id {park_id} not found')

        sql = text('SELECT * FROM profiles')
        result = self.session.execute(sql)
        for row in result:
            profile = Profile(id=row[0], username=row[1], email=row[2], password=row[3])
            self.profiles.append(profile)

        sql = text('SELECT * FROM bookings')
        result = self.session.execute(sql)
        for row in result:
            booker_id = row[1]
            booker = next((profile for profile in self.profiles if profile.get_id() == booker_id), None)
            park_id = row[4]
            park = next((park for park in self.parks if park.get_id() == park_id), None)
            facility_id = row[5]
            facility = next((facility for facility in self.facilities if facility.get_id() == facility_id), None)
            booking = Booking(id=row[0], booker=booker, datetime=row[2], cancelled=bool(row[3]), park=park, facility=facility)
            booker.set_bookings(booking)
            self.bookings.append(booking)

        sql = text('SELECT * FROM reviews')
        result = self.session.execute(sql)
        for row in result:
            booking_id = row[3]
            booking = next((booking for booking in self.bookings if booking.get_id() == booking_id), None)
            review = Review(rating=row[1], comment=row[2])
            booking.set_reviews(review)
            facility.set_reviews(review)
            self.reviews.append(review)

        logger.info('Database initialized')

def convert_to_enum(value) -> FacilityType:
    """ Method to convert a string to an enum
    Args:
        value (string): string to convert
    Returns:
        FacilityType: enum value
    """
    if value == 'BBQ Pit':
        return FacilityType.BBQ_PIT
    elif value == 'Campsite':
        return FacilityType.CAMPSITE
    elif value == 'Venues':
        return FacilityType.VENUES

# Log all requests
@app.after_request
def log_requests(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        logger.info('Request: %s %s - Remote Address: %s - User Agent: %s', request.method, request.path, request.remote_addr, request.user_agent)
        return f(*args, **kwargs)
    return decorated_function

@app.route('/')
def hello():
    """ Method to say hello

    Returns:
        string: This is the server for NParkBuddy
    """
    return 'This is the server for NParkBuddy'

@app.route('/parks', methods=['GET'])
def get_parks():
    """ Method to get all parks

    Returns:
        json: list of parks
    """
    parks = []
    for park in db.parks:
        parks.append({'id': park.get_id(),
                      'name': park.get_name(),
                      'latitude': park.get_latitude(),
                      'longitude': park.get_longitude()})
    return jsonify(parks)

@app.route('/facilities', methods=['GET'])
def get_facilities():
    """ Method to get all facilities

    Returns:
        json: list of facilities
    """
    facilities = []
    for facility in db.facilities:
        facilities.append({'id': facility.get_id(),
                           'name': facility.get_name(),
                           'park': facility.get_park().get_name(),
                           'type': facility.get_type().value,
                           'avg_rating': facility.get_avg_rating(),
                           'num_ratings': facility.get_num_ratings()})
    return jsonify(facilities)

@app.route('/profiles', methods=['GET'])
def get_profiles():
    """ Method to get all profiles

    Returns:
        json: list of profiles
    """
    profiles = []
    for profile in db.profiles:
        profiles.append({'id': profile.get_id(),
                         'username': profile.get_username(),
                         'email': profile.get_email()})
    return jsonify(profiles)

@app.route('/bookings', methods=['GET'])
def get_bookings():
    """ Method to get all bookings

    Returns:
        json: list of bookings
    """
    bookings = []
    for booking in db.bookings:
        bookings.append({'id': booking.get_id(),
                         'booker': booking.get_booker().get_username(),
                         'datetime': booking.get_datetime(),
                         'cancelled': booking.get_cancelled(),
                         'park': booking.get_park().get_name(),
                         'facility': booking.get_facility().get_name()})
    return jsonify(bookings)

@app.route('/reviews', methods=['GET'])
def get_reviews():
    """ Method to get all reviews

    Returns:
        json: list of reviews
    """
    reviews = []
    for review in db.reviews:
        reviews.append({'rating': review.get_rating(),
                        'comment': review.get_comment()})
    return jsonify(reviews)

# Flag to check if the server has been initialized
server_initialized = False

# Flag to check if the server has been shutdown
server_shutdown = False

#@app.before_request
#def init_server(db):
#    """ Method to initialize the server
#    """
#    global server_initialized
#    if not server_initialized:
#        logger.info('Initializing server...')
#
#        server_initialized = True
#        logger.info('Server initialized')

def trigger_request():
    """ Method to trigger a request to the server
    """
    try:
        logger.info('Triggering request to server...')
        time.sleep(1)
        response = requests.get('http://127.0.0.1:5000/')
        if response.status_code == 200:
            logger.info('Server is running')
        else:
            logger.error('Server is not running')
    except requests.exceptions.ConnectionError:
        logger.error('Error connecting to server')

# Function to handle shutdown signal
def shutdown_signal_handler(signal, frame):
    logger.info('Shutting down server...')

# Register signal handler for SIGINT (Ctrl+C) and SIGTERM
signal.signal(signal.SIGINT, shutdown_signal_handler)
signal.signal(signal.SIGTERM, shutdown_signal_handler)

@app.route('/shutdown', methods=['POST'])
def shutdown():
    shutdown_signal_handler(signal.SIGINT, None)
    global server_shutdown
    server_shutdown = True
    return 'Server shutting down...'

if __name__ == '__main__':
    db = Database()
    ##flask_thread = threading.Thread(target=app.run, kwargs={'host': '127.0.0.1', 'port' : 5000, 'debug': True, 'use_reloader': False})
    ##flask_thread.start()
    #
    db.init_db()
    app.run(host='127.0.0.1', port=5000, debug=True)
    #trigger_request()

    #flask_thread.join()

    if server_shutdown:
        logger.info('Server shutdown complete')
        sys.exit(0)
