""" This file reads geojson data from the database and returns it as a JSON response
"""
import json
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text
from fuzzywuzzy import process
from server.classes.facility import FacilityType

# Create a SQLAlchemy engine
engine = create_engine('sqlite:///nparkbuddy.db', echo=True)

# Create a sessionmaker bound to engine
Session = sessionmaker(bind=engine)
session = Session()

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

    id = 1

    for entry in data['features']:
        name = extract_park_name(entry)

        # Check if park name is part of list
        available_parks = ['Pasir Ris Park',
                           'Sembawang Park',
                           'Changi Beach Park',
                           'Labrador Nature Reserve',
                           'West Coast Park',
                           'East Coast Park',
                           'Pulau Ubin and Chek Jawa',
                           'Bedok Reservoir Park',
                           'Bishan-Ang Mo Kio Park (River Plains)',
                           'Dhouby Ghaut Green',
                           'Kallang Riverside Park',
                           'one-north Park']

        # Check if park name is close to any of the available parks
        if name and process.extractOne(name, available_parks)[1] > 90:
            print(f'Park name found: {name}')
            longitude = entry['geometry']['coordinates'][0]
            latitude = entry['geometry']['coordinates'][1]
            name = name.title().replace('Pk', 'Park').replace('And Chek Jawa', '').replace('(River Plains)', '')

            # Insert ID value along with other data into the 'parks' table
            sql = text('INSERT INTO parks (id, name, latitude, longitude) VALUES (:id, :name, :longitude, :latitude)')
            session.execute(sql, {'id': id, 'name': name, 'longitude': longitude, 'latitude': latitude})
            id += 1

    session.commit()
    session.close()

def insert_facilities():
    """_summary_

    Returns:
        _type_: _description_
    """

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

    while True:
        option = input("Enter the function to run"
                        "\n1. Parse and store data"
                       "\n2. Display parks"
                       "\n3. Delete parks"
                       "\n4. Exit\n")

        if option == '1':
            parse_and_store(data)
        elif option == '2':
            display_parks()
        elif option == '3':
            delete_parks()
        elif option == '4':
            exit()
        else:
            print('Invalid option')
