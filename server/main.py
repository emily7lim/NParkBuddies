""" Main module for the server. """
# Install required packages manually
# Run the following command in the terminal:
# pip install -r requirements.txt

import logging
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from classes.facility import FacilityType
from logger import prepare_logger

app = Flask(__name__)
logger = prepare_logger()

# Configure database URL
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///parks.db'
app.config['SQLALCHEMY_BINDS'] = {'facilities' : 'sqlite:///facilities.db'}

park_db = SQLAlchemy(app)

""" Module to define the database models for the parks and facilities"""
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

    logger.info('Facility db ready')

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

    logger.info('Park db ready')

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

if __name__ == '__main__':
    logger.info('Starting server...')

    app.run(host='127.0.0.1', port=5000, debug=True)