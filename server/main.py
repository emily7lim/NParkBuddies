""" Main module for the server. """
# Install required packages manually
# Run the following command in the terminal:
# pip install -r requirements.txt

from flask import Flask, request, jsonify
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, relationship
from classes.park import Park
from classes.facility import Facility, FacilityType
from logger import prepare_logger
import requests
import time
import threading
import signal
import sys

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
            print(row)
            park_id = row[2]
            type = convert_to_enum(row[3])
            #print(type.value)
            park = next((park for park in self.parks if park.get_id() == park_id), None)
            if park:
                facility = Facility(id=row[0], name=row[1], park=park, type=type, avg_rating=row[4], num_ratings=row[5])
                park.set_facilities(facility)
                self.facilities.append(facility)
            else:
                logger.error(f'Park with id {park_id} not found')

        for park in self.parks:
            print(park.get_name())
            for facility in park.get_facilities():
                print(facility.get_name())

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


""" Module to define the database models for the parks and facilities"""
'''
class Facility(park_db.Model):
    """ Class to represent a facility

    Args:
        park_db (_type_): _description_

    Returns:
        _type_: _description_
    """
    __bind_key__ = 'facilities'
    __tablename__ = 'facilities'

    id = park_db.Column(park_db.Integer, primary_key=True)
    park_id = park_db.Column(park_db.Integer, park_db.ForeignKey('parks.id'))
    type = park_db.Column(park_db.Enum(FacilityType))
    avg_rating = park_db.Column(park_db.Float)
    num_ratings = park_db.Column(park_db.Integer)
    reviews = park_db.Column(park_db.String)

    #logger.info('Facility db ready')

    def __repr__(self):
        return f'<Facility {self.id}>'

class Park(park_db.Model):
    """ Class to represent a park

    Args:
        park_db (_type_): _description_

    Returns:
        _type_: _description_
    """
    __tablename__ = 'parks'

    id = park_db.Column(park_db.Integer, primary_key=True)
    name = park_db.Column(park_db.String)
    longitude = park_db.Column(park_db.Float)
    latitude = park_db.Column(park_db.Float)
    facilities = park_db.relationship('Facility', backref='park', lazy=True)

    #logger.info('Park db ready')

    # Display header rows for the database
    def __str__(self):
        return f'<Park {self.id} {self.name} {self.latitude} {self.longitude}>'

    def __repr__(self):
        return f'<Park {self.id}>'
'''

@app.route('/')
def hello():
    """ Method to say hello

    Returns:
        string: This is the server for NParkBuddy
    """
    return 'This is the server for NParkBuddy'

'''
@app.route('/api/parks', methods=['GET'])
def get_parks():
    """ API endpoint to get all parks
    Returns:
        json: JSON representation of all parks
    """
    parks_data = Park.query.all() # Fetch all parks from the database
    return jsonify(parks_data)

@app.route('/api/parks/<int:park_id>', methods=['GET'])
def get_park(park_id):
    """ API endpoint to get a park by id

    Args:
        park_id (int): id of the park to get

    Returns:
        json: JSON representation of the park
    """
    park_data = Park.query.get(park_id) # Fetch the park from the database
    return jsonify(park_data)

@app.route('/api/parks', methods=['POST'])
def create_park():
    """ API endpoint to create a park

    Returns:
        json: JSON representation of the created park
    """
    park_data = request.json
    park = Park(name=park_data['name'], latitude=park_data['latitude'], longitude=park_data['longitude'])
    park_db.session.add(park)
    park_db.session.commit()
    return jsonify(park)

@app.route('/api/parks/<int:park_id>', methods=['PUT'])
def update_park(park_id):
    """ API endpoint to update a park by id

    Args:
        park_id (int): id of the park to update

    Returns:
        json: JSON representation of the updated park
    """
    park_data = request.json
    park = Park.query.get(park_id)
    park.name = park_data['name']
    park.latitude = park_data['latitude']
    park.longitude = park_data['longitude']
    park_db.session.commit()
    return jsonify(park)

@app.route('/api/parks/<int:park_id>', methods=['DELETE'])
def delete_park(park_id):
    """ API endpoint to delete a park by id

    Args:
        park_id (int): id of the park to delete

    Returns:
        json: JSON representation of the deleted park
    """
    park = Park.query.get(park_id)
    park_db.session.delete(park)
    park_db.session.commit()
    return jsonify(park)

@app.route('/api/parks/<int:park_id>/facilities', methods=['GET'])
def get_facilities(park_id):
    """ API endpoint to get all facilities of a park

    Args:
        park_id (int): id of the park to get facilities for

    Returns:
        json: JSON representation of all facilities of the park
    """
    facilities_data = Facility.query.filter_by(park_id=park_id).all() # Fetch all facilities of the park from the database
    return jsonify(facilities_data)

@app.route('/api/parks/<int:park_id>/facilities', methods=['POST'])
def create_facility(park_id):
    """ API endpoint to create a facility for a park

    Args:
        park_id (int): id of the park to create a facility for

    Returns:
        json: JSON representation of the created facility
    """
    facility_data = request.json
    facility = Facility(park_id=park_id, type=facility_data['type'], avg_rating=facility_data['avg_rating'], num_ratings=facility_data['num_ratings'], reviews=facility_data['reviews'])
    park_db.session.add(facility)
    park_db.session.commit()
    return jsonify(facility)

@app.route('/api/parks/<int:park_id>/facilities/<int:facility_id>', methods=['PUT'])
def update_facility(park_id, facility_id):
    """ API endpoint to update a facility by id

    Args:
        park_id (int): id of the park the facility belongs to
        facility_id (int): id of the facility to update

    Returns:
        json: JSON representation of the updated facility
    """
    facility_data = request.json
    facility = Facility.query.get(facility_id)
    facility.type = facility_data['type']
    facility.avg_rating = facility_data['avg_rating']
    facility.num_ratings = facility_data['num_ratings']
    facility.reviews = facility_data['reviews']
    park_db.session.commit()
    return jsonify(facility)

@app.route('/api/parks/<int:park_id>/facilities/<int:facility_id>', methods=['DELETE'])
def delete_facility(park_id, facility_id):
    """ API endpoint to delete a facility by id

    Args:
        park_id (int): id of the park the facility belongs to
        facility_id (int): id of the facility to delete

    Returns:
        json: JSON representation of the deleted facility
    """
    facility = Facility.query.get(facility_id)
    park_db.session.delete(facility)
    park_db.session.commit()
    return jsonify(facility)
'''

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
    #app.run(host='127.0.0.1', port=5000, debug=True)
    db.init_db()
    print(db.parks)
    #trigger_request()

    #flask_thread.join()

    if server_shutdown:
        logger.info('Server shutdown complete')
        sys.exit(0)
