""" This file reads geojson data from the database and returns it as a JSON response
"""
import json
from sqlalchemy import create_engine, Column, Integer, String, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text

# Create a SQLAlchemy engine
engine = create_engine('sqlite:///parks.db')

base = declarative_base()

class GeoData(base):
    """ Summary of the class

    Args:
        base (_type_): _description_
    """
    __tablename__ = 'parks'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    latitude = Column(Float)
    longitude = Column(Float)

# Create tables in database
base.metadata.create_all(engine)

# Read GEOjson file
def read_geojson(filename):
    '''Reads a GEOjson file and returns the data as a dictionary

    Args:
        filename (str): The name of the file to read

    Returns:
        data (dict): The data read from the file
    '''
    with open(filename, 'r') as file:
        data = json.load(file)
    return data

# Parse GEOjson data and store in database
def parse_and_store(data):
    '''Parses GEOjson data and stores it in the database

    Args:
        data (dict): The data to parse and store

    Raises:
        ValueError: If the park name is not found
    '''
    Session = sessionmaker(bind=engine)
    session = Session()

    for index, entry in enumerate(data['features']):
        id = index+1
        name = extract_park_name(entry)
        if name:
            longitude = entry['geometry']['coordinates'][0]
            latitude = entry['geometry']['coordinates'][1]

            # Insert ID value along with other data into the 'parks' table
            sql = text('INSERT INTO parks (id, name, latitude, longitude) VALUES (:id, :name, :longitude, :latitude)')
            session.execute(sql, {'id': id, 'name': name, 'longitude': longitude, 'latitude': latitude})
        else:
            raise ValueError('Park name not found')

    session.commit()
    session.close()

# Parse GeoJSON data and extract the park name
def extract_park_name(geojson_entry):
    ''' Extracts the park name from a GEOjson entry

    Args:
        geojson_entry (dict): The GEOjson entry to extract the park name from

    Returns:
        name_tag (str): The park name
    '''
    properties = geojson_entry.get('properties', {})
    description = properties.get('Description', '')
    start = description.find('NAME')
    description = description[start+14:]
    end = description.find('<')
    name_tag = description[:end]
    if name_tag:
        return name_tag
    else:
        return None

def display_parks():
    ''' Displays all parks in the database
    '''

    Session = sessionmaker(bind=engine)
    session = Session()

    sql = text('SELECT * FROM parks')
    result = session.execute(sql)

    # Print results by park
    for row in result:
        print(row)

    session.close()

def delete_parks():
    ''' Deletes all parks from the database
    '''
    Session = sessionmaker(bind=engine)
    session = Session()

    sql = text('DELETE FROM parks')
    session.execute(sql)

    session.commit()
    session.close()

if __name__ == '__main__':
    data = read_geojson('Parks.geojson')

    function = input('Enter the function to run'
                     '\n1: Parse and store data'
                     '\n2: Display parks'
                     '\n3: Delete parks\n')

    if function == '1':
        parse_and_store(data)
    elif function == '3':
        delete_parks()

    display_parks()
