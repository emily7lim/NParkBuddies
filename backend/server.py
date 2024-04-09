""" Main module for the server. """
# Install required packages manually
# Run the following command in the terminal:
# pip install -r requirements.txt

from flask import Flask, request, jsonify, Response
import requests
import time
import threading
import signal
import sys
from functools import wraps
from geopy.geocoders import Nominatim
from ip2geotools.databases.noncommercial import DbIpCity
from data_store import db
from classes.facility import convert_to_enum
from classes.weather import Weather
from controllers.login_manager import LoginManager
from controllers.home_manager import HomeManager
from controllers.bookings_manager import BookingsManager
from controllers.facility_manager import FacilityManager
from controllers.profile_manager import ProfileManager
from controllers.weather_manager import WeatherManager
from logger import prepare_logger

app = Flask(__name__)

logger = prepare_logger()

# Log all requests
@app.after_request
def log_requests(f):
    """ Method to log all requests

    Args:
        f: function to decorate

    Returns:
        decorated_function: Method to decorate the function
    """
    @wraps(f)
    def decorated_function(*args, **kwargs):
        """ Method to decorate the function

        Returns:
            f: decorated function
        """
        ip_address = request.headers.get('X-Forwarded-For', request.remote_addr).split(',')[0].strip()
        logger.info('Request: %s %s - Remote Address: %s - User Agent: %s', request.method, request.path, ip_address, request.user_agent)
        return f(*args, **kwargs)
    return decorated_function

# Log all responses
@app.after_request
def log_responses(response):
    """ Method to log all responses

    Args:
        response: response object

    Returns:
        response: response object
    """
    logger.info('Response: %s - Status Code: %s', request.method, response.status_code)
    return response

# Root route

@app.route('/')
def hello():
    """ Method to say hello

    Returns:
        string: This is the server for NParkBuddy
    """
    return 'This is the server for NParkBuddy'

# Login routes

@app.route('/profiles/create', methods=['POST'])
def create_account() -> Response:
    """ Method to create a profile

    Args:
        username (string): The username of the profile
        email (string): The email of the profile
        password (string): The password of the profile

    Returns:
        Response: JSON response with status of the profile creation
    """
    # Extract data from request payload
    payload = request.json
    username = payload.get('username')
    email = payload.get('email')
    password = payload.get('password')

    print("username email password", username, email, password)

    # Check if all required fields are present
    if username is None or email is None or password is None:
        return jsonify({'error': 'Missing required fields'}), 400

    profile = LoginManager.create_account(username, email, password)
    if 'error' in profile:
        return jsonify({'error': profile['error']}), 400
    else:
        return jsonify({'message': 'Profile created successfully', 'profile': profile}), 200

@app.route('/profiles/login', methods=['POST'])
def login() -> Response:
    """ Method to login

    Args:
        user_identifer (string): The username or email of the profile
        password (string): The password of the profile

    Returns:
        Response: JSON response with status of the login
    """
    # Extract data from request payload
    payload = request.json
    user_identifier = payload.get('user_identifier')
    password = payload.get('password')

    # Check if all required fields are present
    if user_identifier is None or password is None:
        return jsonify({'error': 'Missing required fields'}), 400

    login = LoginManager.login(user_identifier, password)
    if 'error' in login:
        return jsonify({'error': login['error']}), 400
    else:
        return jsonify(login), 200

@app.route('/profiles/<string:user_identifier>/change_password', methods=['POST'])
def change_password(user_identifier) -> Response:
    """Method to change a user's password

    Args:
        user_identifier (string): The username or email of the profile
        new_password (string): The new password of the profile

    Returns:
        Response: JSON response with status of the password change
    """
    # Extract data from request payload
    payload = request.json
    user_identifier = payload.get('user_identifier')
    new_password = payload.get('new_password')

    # Check if all required fields are present
    if user_identifier is None or new_password is None:
        return jsonify({'error': 'Missing required fields'}), 400

    result = LoginManager.change_password(user_identifier, new_password)
    if 'error' in result:
        return jsonify({'error': result['error']}), 400
    else:
        return jsonify(result), 200

# Home routes

@app.route('/parks', methods=['GET'])
def get_parks() -> Response:
    """ Method to get all parks

    Returns:
        Response: JSON response containing all parks
    """
    parks = HomeManager.view_parks()
    return jsonify(parks)

@app.route('/parks/<string:park_name>', methods=['GET'])
def get_park(park_name) -> Response:
    """ Method to get a park by name

    Args:
        park_name (string): name of the park

    Returns:
        Response: JSON response containing the park
    """
    park_name = park_name.replace('_', ' ').title()
    park = HomeManager.select_park(park_name)
    if park:
        return jsonify(park)
    else:
        return jsonify({'error': 'Park not found'})

@app.route('/bookings', methods=['POST'])
def create_booking() -> Response:
    """ Method to create a booking

    Args:
        user_id (int): The id of the user
        park_id (int): The id of the park
        facility_id (int): The id of the facility
        datetime (datetime): The date and time of the booking

    Returns:
        Response: JSON response with status of the booking
    """
    # Extract data from request payload
    payload = request.json
    user_id = payload.get('user_id')
    park_id = payload.get('park_id')
    facility_id = payload.get('facility_id')
    datetime = payload.get('datetime')

    logger.info('Request to create booking: %s %s %s %s', user_id, park_id, facility_id, datetime)

    # Check if all required fields are present
    if user_id is None or park_id is None or facility_id is None or datetime is None:
        return jsonify({'error': 'Missing required fields'}), 400

    booking = HomeManager.create_booking(user_id, park_id, facility_id, datetime)
    if 'error' in booking:
        logger.error(booking['error'])
        return jsonify({'error': booking['error']}), 400
    else:
        logger.info('Booking created successfully: %s', booking['id'])
        return jsonify({'message': 'Booking created successfully', 'booking': booking}), 200

@app.route('/weather', methods=['GET'])
def get_weather_warning() -> Response:
    """ Method to get weather warning

    Returns:
        Response: JSON response with weather warning
    """
    lat = request.args.get('lat')
    lng = request.args.get('lng')

    try:
        user_lat = float(lat)
        user_lng = float(lng)
    except (ValueError, TypeError):
        user_location = get_user_location()
        user_lat = user_location['latitude']
        user_lng = user_location['longitude']

    global weather_instance
    weather_manager = WeatherManager(weather_instance)
    region = get_region(user_lat, user_lng)
    if region is None:
        weather_warning = weather_manager.send_weather_warning('central')
    else:
        weather_warning = weather_manager.send_weather_warning(region)

    # Return when no error warning
    if weather_warning is None:
        return jsonify({'message': 'No weather warning'}), 200
    else:
        return jsonify({'message': weather_warning}), 200

def get_region(lat, lng) -> str:
    """ Method to get the region based on the latitude and longitude

    Args:
        lat (float): Latitude
        lng (float): Longitude

    Returns:
        str: The region based on the latitude and longitude
    """
    # Check if the coordinates are outside the bounds of Singapore
    if not (1.158 <= lat <= 1.472 and 103.600 <= lng <= 104.090):
        return None

    # Determine the region based on longitude
    if lng <= 103.762:
        return 'west' if lat <= 1.366 else 'None'
    elif lng <= 103.897:
        # In this range, the region depends on latitude
        if lat < 1.260:
            return None
        elif lat <= 1.338:
            return 'south'
        elif lat <= 1.393:
            return 'central'
        else:
            return 'north'
    else:
        return 'east'

# Bookings routes

@app.route('/profiles/<string:username>/bookings', methods=['GET'])
def get_bookings(username) -> Response:
    """ Method to get all bookings by profile

    Args:
        username (string): username of the profile

    Returns:
        Response: JSON response containing all bookings
    """
    bookings = BookingsManager.view_bookings(username)
    return jsonify(bookings)

@app.route('/bookings/cancel', methods=['POST'])
def cancel_booking():
    """ Method to cancel a booking

    Returns:
        Response: JSON response with status of the booking
    """
    # Extract data from request payload
    payload = request.json
    username = payload.get('username')
    park = payload.get('park')
    facility = payload.get('facility')
    datetime = payload.get('datetime')

    # Check if all required fields are present
    if username is None or park is None or facility is None or datetime is None:
        return jsonify({'error': 'Missing required fields'}), 400

    booking = BookingsManager.cancel_booking(username, park, facility, datetime)
    if booking:
        return jsonify({'message': 'Booking cancelled', 'booking': booking}), 200
    else:
        return jsonify({'error': 'Booking not found'}), 404

@app.route('/reviews', methods=['POST'])
def review_booking():
    """ Method to review a booking

    Returns:
        Response: JSON response with status of the review
    """
    # Extract data from request payload
    payload = request.json
    username = payload.get('username')
    park = payload.get('park')
    facility = payload.get('facility')
    datetime = payload.get('datetime')
    rating = payload.get('rating')
    comment = payload.get('comment')

    # Check if all required fields are present
    if username is None or park is None or facility is None or datetime is None or rating is None:
        return jsonify({'error': 'Missing required fields'}), 400

    review = BookingsManager.review_booking(username, park, facility, datetime, rating, comment)
    if review:
        return jsonify({'message': 'Review submitted', 'review': review}), 200
    else:
        return jsonify({'error': 'Booking not found'}), 404

# Facility routes

@app.route('/facilities', methods=['GET'])
def view_facilities():
    """ Method to view all facilities

    Returns:
        json: list of facilities
    """
    lat = request.args.get('lat')
    lon = request.args.get('lon')

    try:
        user_lat = float(lat)
        user_lon = float(lon)
    except (ValueError, TypeError):
        user_lat = None
        user_lon = None

    if user_lat is None or user_lon is None:
        user_location = get_user_location()
        user_lat = user_location['latitude']
        user_lon = user_location['longitude']

    facilities = FacilityManager.view_facilities(user_lat, user_lon)
    return jsonify(facilities)

def get_user_location():
    """ Method to get user location

    Returns:
        location: user location
    """
    geolocator = Nominatim(user_agent="nparkbuddy")
    try:
        ip_address = request.headers.get('X-Forwarded-For', request.remote_addr)
        # Client IP address will be the first in the list
        client_ip = ip_address.split(',')[0].strip()
        logger.info('Client IP address: %s', client_ip)
        location = DbIpCity.get(client_ip, api_key='free')
    except:
        logger.error("Error getting user location using IP address, defaulting to Singapore")
        location = geolocator.geocode('singapore')

    logger.info('User location: %s, %s', location.latitude, location.longitude)

    return {
        'latitude': location.latitude,
        'longitude': location.longitude
    }

@app.route('/facilities/filter', methods=['GET'])
def filter_facilities():
    """ Method to filter facilities

    Returns:
        json: list of facilities
    """
    type = request.args.get('type')

    try:
        facility_type = convert_to_enum(type)
    except Exception:
        return jsonify({'error': 'Invalid facility type'}), 400

    lat = request.args.get('lat')
    lon = request.args.get('lon')

    try:
        user_lat = float(lat)
        user_lon = float(lon)
    except (ValueError, TypeError):
        user_lat = None
        user_lon = None

    if user_lat is None or user_lon is None:
        user_location = get_user_location()
        user_lat = user_location['latitude']
        user_lon = user_location['longitude']

    facilities = FacilityManager.filter_facilities(facility_type, user_lat, user_lon)
    return jsonify(facilities)

@app.route('/reviews/<string:park_name>/<string:facility_name>', methods=['GET'])
def view_reviews(park_name, facility_name):
    """ Method to view reviews

    Returns:
        json: list of reviews
    """
    # Convert park name and facility name to title case from underscore case
    park_name = park_name.replace('_', ' ').title()
    facility_name = facility_name.replace('_', ' ').title().replace('Bbq', 'BBQ')
    reviews = FacilityManager.view_reviews(park_name, facility_name)
    return jsonify(reviews)

# Profile routes

@app.route('/profiles/<string:username>/change_username', methods=['POST'])
def change_username(username) -> Response:
    """Method to change a user's username

    Args:
        old_username (string): The username of the profile
        new_username (string): The new username of the profile

    Returns:
        Response: JSON response with status of the username change
    """
    # Extract data from request payload
    payload = request.json
    old_username = payload.get('old_username')
    new_username = payload.get('new_username')

    # Check if all required fields are present
    if old_username is None or new_username is None:
        return jsonify({'error': 'Missing required fields'}), 400

    result = ProfileManager.change_username(old_username, new_username)
    if 'error' in result:
        return jsonify({'error': result['error']}), 400
    else:
        return jsonify({'message': 'Username changed successfully', 'profile': result}), 200

@app.route('/profiles/<string:username>/change_email', methods=['POST'])
def change_email(username) -> Response:
    """Method to change a user's email

    Args:
        old_email (string): The email of the profile
        new_email (string): The new email of the profile

    Returns:
        Response: JSON response with status of the email change
    """
    # Extract data from request payload
    payload = request.json

    old_email = payload.get('old_email')
    new_email = payload.get('new_email')

    # Check if all required fields are present
    if old_email is None or new_email is None:
        return jsonify({'error': 'Missing required fields'}), 400

    result = ProfileManager.change_email(old_email, new_email)
    if 'error' in result:
        return jsonify({'error': result['error']}), 400
    else:
        return jsonify({'message': 'Email changed successfully', 'profile': result}), 200

@staticmethod
@app.route('/profiles/<string:user_identifier>/delete_account', methods=['POST'])
def delete_account(user_identifier) -> Response:
    """Method to delete a user's account

    Args:
        user_identifier (string): The username or email of the profile

    Returns:
        Response: JSON response with status of the account deletion
    """
    # Extract data from request payload
    #payload = request.json
    #user_identifier = payload.get('user_identifier')

    # Check if all required fields are present
    if user_identifier is None:
        return jsonify({'error': 'Missing required fields'}), 400

    result = ProfileManager.delete_account(user_identifier)
    if 'error' in result:
        return jsonify({'error': result['error']}), 400
    else:
        return jsonify({'message': 'Account deleted successfully'}), 200

# Admin routes

@app.route('/parks/<string:park_name>/facilities', methods=['GET'])
def get_facilities_by_park(park_name):
    """ Method to get all facilities by park

    Args:
        park_name (string): name of the park

    Returns:
        json: list of facilities
    """
    park = next((park for park in db.parks if park.get_name() == park_name), None)
    if park:
        facilities = []
        for facility in park.get_facilities():
            facilities.append({'id': facility.get_id(),
                            'name': facility.get_name(),
                            'park': facility.get_park().get_name(),
                            'type': facility.get_type().value,
                            'avg_rating': facility.get_avg_rating(),
                            'num_ratings': facility.get_num_ratings(),
                            'reviews': [review.get_rating() for review in facility.get_reviews()]
                            })
        return jsonify(facilities)
    else:
        return jsonify({'error': 'Park not found'})

@app.route('/parks/<string:park_name>/facility/<string:facility_name>', methods=['GET'])
def get_facility_by_name(park_name, facility_name):
    """ Method to get a facility by name

    Args:
        park_name (string): name of the park
        facility_name (string): name of the facility

    Returns:
        json: facility details
    """
    park = next((park for park in db.parks if park.get_name() == park_name), None)
    if park:
        facility = next((facility for facility in park.get_facilities() if facility.get_name() == facility_name), None)
        if facility:
            return jsonify({'id': facility.get_id(),
                            'name': facility.get_name(),
                            'park': facility.get_park().get_name(),
                            'type': facility.get_type().value,
                            'avg_rating': facility.get_avg_rating(),
                            'num_ratings': facility.get_num_ratings(),
                            'reviews': [review.get_rating() for review in facility.get_reviews()]
                            })
        else:
            return jsonify({'error': 'Facility not found'})
    else:
        return jsonify({'error': 'Park not found'})

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
                        'email': profile.get_email(),
                        'bookings': [booking.get_id() for booking in profile.get_bookings()] if profile.get_bookings() else 'No bookings available'
                        })
    return jsonify(profiles)

@app.route('/profiles/<string:username>', methods=['GET'])
def get_profile(username):
    """ Method to get a profile by username

    Args:
        username (string): username of the profile

    Returns:
        json: profile details
    """
    profile = next((profile for profile in db.profiles if profile.get_username() == username), None)
    if profile:
        return jsonify({'id': profile.get_id(),
                        'username': profile.get_username(),
                        'email': profile.get_email(),
                        'bookings': [booking.get_id() for booking in profile.get_bookings()] if profile.get_bookings() else 'No bookings available'
                        })
    else:
        return jsonify({'error': 'Profile not found'})

@app.route('/profiles/<string:username>/bookings/<int:booking_id>', methods=['GET'])
def get_booking_by_profile(username, booking_id):
    """ Method to get a booking by profile

    Args:
        username (string): username of the profile
        booking_id (int): id of the booking

    Returns:
        json: booking object
    """
    profile = next((profile for profile in db.profiles if profile.get_username() == username), None)
    if profile:
        booking = next((booking for booking in profile.get_bookings() if booking.get_id() == booking_id), None)
        if booking:
            return jsonify({'id': booking.get_id(),
                            'datetime': booking.get_datetime(),
                            'cancelled': booking.get_cancelled(),
                            'park': booking.get_park().get_name(),
                            'facility': booking.get_facility().get_name(),
                            'reviews': booking.get_review().get_id() if booking.get_review() else 'No reviews available'
                            })
        else:
            return jsonify({'error': 'Booking not found'})
    else:
        return jsonify({'error': 'Profile not found'})

@app.route('/profiles/<string:username>/bookings/<int:booking_id>/reviews', methods=['GET'])
def get_review_by_profile(username, booking_id):
    """ Method to get review by profile

    Args:
        username (string): username of the profile
        booking_id (int): id of the booking

    Returns:
        json: review object
    """
    profile = next((profile for profile in db.profiles if profile.get_username() == username), None)
    if profile:
        booking = next((booking for booking in profile.get_bookings() if booking.get_id() == booking_id), None)
        if booking:
            review = next((review for review in db.reviews if review.get_id() == booking_id), None)
            if review:
                return jsonify({'rating': review.get_rating(),
                                'comment': review.get_comment()
                                })
            else:
                return jsonify({'error': 'Review not found'})
        else:
            return jsonify({'error': 'Booking not found'})
    else:
        return jsonify({'error': 'Profile not found'})

@app.route('/bookings', methods=['GET'])
def view_bookings():
    """ Method to get all bookings

    Returns:
        json: list of bookings
    """
    bookings = []
    for booking in db.bookings:
        print(booking.get_id(), booking.get_booker(), booking.get_datetime(), booking.get_cancelled(), booking.get_park().get_name(), booking.get_facility().get_name(), booking.get_review().get_id() if booking.get_review() else 'No reviews available')
        bookings.append({'id': booking.get_id(),
                        'booker': booking.get_booker(),
                        'datetime': booking.get_datetime(),
                        'cancelled': booking.get_cancelled(),
                        'park': booking.get_park().get_name(),
                        'facility': booking.get_facility().get_name(),
                        'reviews': booking.get_review().get_id() if booking.get_review() else 'No reviews available'
                        })
    return jsonify(bookings)

@app.route('/bookings/<int:booking_id>', methods=['GET'])
def get_booking(booking_id):
    """ Method to get a booking by id

    Args:
        booking_id (int): id of the booking

    Returns:
        json: booking details
    """
    booking = next((booking for booking in db.bookings if booking.get_id() == booking_id), None)
    if booking:
        return jsonify({'id': booking.get_id(),
                        'booker': booking.get_booker(),
                        'datetime': booking.get_datetime(),
                        'cancelled': booking.get_cancelled(),
                        'park': booking.get_park().get_name(),
                        'facility': booking.get_facility().get_name(),
                        'reviews': booking.get_review().get_id() if booking.get_review() else 'No reviews available'
                        })
    else:
        return jsonify({'error': 'Booking not found'})

@app.route('/bookings/<int:booking_id>/reviews', methods=['GET'])
def get_review_by_booking(booking_id):
    """ Method to get review by booking

    Args:
        booking_id (int): id of the booking

    Returns:
        json: review object
    """
    booking = next((booking for booking in db.bookings if booking.get_id() == booking_id), None)
    if booking:
        review = next((review for review in db.reviews if review.get_id() == booking_id), None)
        if review:
            return jsonify({'rating': review.get_rating(),
                            'comment': review.get_comment()
                            })
        else:
            return jsonify({'error': 'Review not found'})
    else:
        return jsonify({'error': 'Booking not found'})

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

@app.route('/reviews/<int:review_id>', methods=['GET'])
def get_review(review_id):
    """ Method to get a review by id

    Args:
        review_id (int): id of the review

    Returns:
        json: review details
    """
    review = next((review for review in db.reviews if review.get_id() == review_id), None)
    if review:
        return jsonify({'rating': review.get_rating(),
                        'comment': review.get_comment()})
    else:
        return jsonify({'error': 'Review not found'})

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

@app.route('/shutdown', methods=['POST'])
def shutdown():
    shutdown_signal_handler(signal.SIGINT, None)
    global server_shutdown
    server_shutdown = True
    return 'Server shutting down...'

def init_db_in_thread():
    """ Method to initialize the database in a separate thread
    """
    db.init_db()

weather_instance = Weather()

def main():
    """ Main function for the server
    """
    # Register signal handler for SIGINT (Ctrl+C) and SIGTERM in main thread
    signal.signal(signal.SIGINT, shutdown_signal_handler)
    signal.signal(signal.SIGTERM, shutdown_signal_handler)

    # Initialize the database
    db_thread = threading.Thread(target=init_db_in_thread)
    db_thread.start()

    # Initialize and start weather polling
    global weather_instance
    weather_thread = threading.Thread(target=weather_instance.start_polling)
    weather_thread.daemon = True
    weather_thread.start()

    # Wait for database initialization to complete
    db_thread.join()

    # Start the server
    app.run(host='127.0.0.1', port=5000, debug=True)

if __name__ == '__main__':
    main()
