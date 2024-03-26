""" Main module for the server. """
from flask import Flask, request, jsonify
from database.database import park_db, Park, Facility, init_db

app = Flask(__name__)

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

if __name__ == '__main__':
    init_db()
    app.run(host='127.0.0.1', port=5000, debug=True)
