""" This file reads geojson data from the database and returns it as a JSON response
"""
import os
import sys
import json
import datetime
import pandas as pd
import numpy as np
import random
from faker import Faker
from openai import OpenAI
from dotenv import dotenv_values
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text
from fuzzywuzzy import process

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from classes.facility import FacilityType

# OpenAI API key
current_directory = os.getcwd()
server_directory = os.path.abspath(os.path.join(current_directory, os.pardir))

# Load environment variables from .env file
config = dotenv_values(os.path.join(server_directory, ".env"))
api_key = config.get("OPENAI_API_KEY")

client = OpenAI(api_key=api_key)
model_name = "gpt-4"

# Create a SQLAlchemy engine
engine = create_engine('sqlite:///nparkbuddy.db')

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
def insert_parks(data):
    '''Parses GEOjson data and stores it in the database

    Args:
        data (dict): The data to parse and store

    Raises:
        ValueError: If the park name is not found
    '''
    Session = sessionmaker(bind=engine)
    session = Session()

    id = 1

    processed_parks = set() # Set to store processed park names

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
                       'Dhoby Ghaut Green',
                       'Kallang Riverside Park',
                       'one-north Park']

    for entry in data['features']:
        name = extract_park_name(entry)

        # Check if park name is close to any of the available parks and not a duplicate
        match, score = process.extractOne(name, available_parks)
        if score > 90 and match not in processed_parks:
            print(f'Park name found: {name}')
            longitude = entry['geometry']['coordinates'][0]
            latitude = entry['geometry']['coordinates'][1]
            #name = name.title().replace('Pk', 'Park').replace('And Chek Jawa', '').replace('(River Plains)', '')
            if match == 'Pulau Ubin and Chek Jawa':
                match = 'Pulau Ubin'
            elif match == 'Bishan-Ang Mo Kio Park (River Plains)':
                match = 'Bishan-Ang Mo Kio Park'
            processed_parks.add(match)
            name = match

            # Insert ID value along with other data into the 'parks' table
            sql = text('INSERT INTO parks (id, name, latitude, longitude) VALUES (:id, :name, :longitude, :latitude)')
            session.execute(sql, {'id': id, 'name': name, 'longitude': longitude, 'latitude': latitude})
            if name == "Changi Beach Park":
                for i in range(0, 20):
                    insert_facilities("BBQ Pit " + str(i + 1), id, FacilityType.BBQ_PIT, session)
            elif name == "East Coast Park":
                for i in range(0, 80):
                    insert_facilities("BBQ Pit " + str(i + 1), id, FacilityType.BBQ_PIT, session)
                insert_facilities("Camping Area D", id, FacilityType.CAMPSITE, session)
                insert_facilities("Camping Area G", id, FacilityType.CAMPSITE, session)
                insert_facilities("Angsana Green", id, FacilityType.VENUES, session)
                insert_facilities("Causarina Green", id, FacilityType.VENUES, session)
            elif name == "Labrador Nature Reserve":
                for i in range(0, 7):
                    insert_facilities("BBQ Pit " + str(i + 1), id, FacilityType.BBQ_PIT, session)
                insert_facilities("Berlayar Shade", id, FacilityType.VENUES, session)
                insert_facilities("Tanjong Berlayer", id, FacilityType.VENUES, session)
            elif name == "Pasir Ris Park":
                for i in range(0, 65):
                    insert_facilities("BBQ Pit " + str(i + 1), id, FacilityType.BBQ_PIT, session)
                insert_facilities("Camping Area 1", id, FacilityType.CAMPSITE, session)
                insert_facilities("Camping Area 3", id, FacilityType.CAMPSITE, session)
                insert_facilities("Costa Lawn", id, FacilityType.VENUES, session)
                insert_facilities("Native Lawn", id, FacilityType.VENUES, session)
            elif name == "Sembawang Park":
                for i in range(0, 10):
                    insert_facilities("BBQ Pit " + str(i + 1), id, FacilityType.BBQ_PIT, session)
            elif name == "West Coast Park":
                for i in range(0, 9):
                    insert_facilities("BBQ Pit " + str(i + 1), id, FacilityType.BBQ_PIT, session)
                insert_facilities("Camping Area 3", id, FacilityType.CAMPSITE, session)
            elif name == "Pulau Ubin":
                insert_facilities("Endut Senin Campsite", id, FacilityType.CAMPSITE, session)
                insert_facilities("Mamam Campsite", id, FacilityType.CAMPSITE, session)
                insert_facilities("Jelutong Campsite 1", id, FacilityType.CAMPSITE, session)
                insert_facilities("Jelutong Campsite 2", id, FacilityType.CAMPSITE, session)
                insert_facilities("Assembly Area (Meeting Point 1)", id, FacilityType.VENUES, session)
                insert_facilities("Ubin Living Lab - Dormitory (Tengar)", id, FacilityType.VENUES, session)
                insert_facilities("Ubin Living Lab - Dormitory (Tumu)", id, FacilityType.VENUES, session)
                insert_facilities("Ubin Living Lab - Hall Block (Front)", id, FacilityType.VENUES, session)
                insert_facilities("Ubin Living Lab - Hall Block (Middle)", id, FacilityType.VENUES, session)
                insert_facilities("Ubin Living Lab - Seminar Room (Ipil)", id, FacilityType.VENUES, session)
                insert_facilities("Ubin Living Lab - Seminar Room (Ketapang)", id, FacilityType.VENUES, session)
                insert_facilities("Ubin Volunteer Hub - Seminar Room", id, FacilityType.VENUES, session)
            elif name == "Bedok Reservoir Park":
                insert_facilities("Reservoir Lawn", id, FacilityType.VENUES, session)
            elif name == "Bishan-Ang Mo Kio Park":
                insert_facilities("Activity Lawn", id, FacilityType.VENUES, session)
                insert_facilities("Ficus Green", id, FacilityType.VENUES, session)
                insert_facilities("Mempat Green", id, FacilityType.VENUES, session)
                insert_facilities("Promenade", id, FacilityType.VENUES, session)
                insert_facilities("Tecoma Green", id, FacilityType.VENUES, session)
            elif name == "Dhoby Ghaut Green":
                insert_facilities("Dhoby Ghaut Amphitheatre", id, FacilityType.VENUES, session)
                insert_facilities("Dhoby Ghaut Lawn", id, FacilityType.VENUES, session)
            elif name == "Kallang Riverside Park":
                insert_facilities("Promenade", id, FacilityType.VENUES, session)
            elif name == "one-north Park":
                insert_facilities("one-north Park: Mediapolis (The Oval)", id, FacilityType.VENUES, session)
            id += 1

    session.commit()
    session.close()

facil_id = 1

def insert_facilities(name, park_id, facility_type, session):
    """ Method to insert facilities into the database

    Args:
        name (str): The name of the facility
        park_id (int): The id of the park
        type (FacilityType): The type of the facility
        session (Session): The session to use for the database

    Returns:
        _type_: _description_
    """

    global facil_id
    id = facil_id
    facil_id += 1
    name = name
    type = facility_type.value
    avg_rating = 0
    num_ratings = 0
    sql = text('INSERT INTO facilities (id, name, park_id, type, avg_rating, num_ratings) VALUES (:id, :name, :park_id, :type, :avg_rating, :num_ratings)')
    session.execute(sql, {'id': id, 'name': name, 'park_id': park_id, 'type': type, 'avg_rating': avg_rating, 'num_ratings': num_ratings})

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

def create_geosjon_from_db():
    ''' Creates a GEOjson file from the database
    '''

    #format { "type": "Feature", "properties": { "Name": "kml_1", "Description": "<center><table><tr><th colspan='2' align='center'><em>Attributes<\/em><\/th><\/tr><tr bgcolor=\"#E3E3F3\"> <th>NAME<\/th> <td>MOUNT SINAI PLAIN PG<\/td> <\/tr><tr bgcolor=\"\"> <th>INC_CRC<\/th> <td>76B3737B12B84D59<\/td> <\/tr><tr bgcolor=\"#E3E3F3\"> <th>FMEL_UPD_D<\/th> <td>20220927161442<\/td> <\/tr><\/table><\/center>" }, "geometry": { "type": "Point", "coordinates": [ 103.781178037401006, 1.31567328963979, 0.0 ] } }

    Session = sessionmaker(bind=engine)
    session = Session()

    sql = text('SELECT * FROM parks')
    result = session.execute(sql)

    with open('selected_parks.geojson', 'a') as file:  # Open the file in append mode
        # write as string literal
        file.write('{"type": "FeatureCollection",\n"crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } },\n\n"features": [\n')
        row_count = 0
        for row in result:
            if row_count > 0:
                file.write(',\n')
            feature = {
                "type": "Feature",
                "properties": {
                    "Name": row[1],
                    "Description": "<center><table><tr><th colspan='2' align='center'><em>Attributes<\/em><\/th><\/tr><tr bgcolor=\"#E3E3F3\"> <th>NAME<\/th> <td>" + row[1] + "<\/td> <\/tr><tr bgcolor=\"\"> <th>INC_CRC<\/th> <td>" + str(row[0]) + "<\/td> <\/tr><tr bgcolor=\"#E3E3F3\"> <th>FMEL_UPD_D<\/th> <td>20220927161442<\/td> <\/tr><\/table><\/center>"
                },
                "geometry": {
                    "type": "Point",
                    "coordinates": [row[3], row[2], 0.0]
                }
            }
            # Write the feature to the file
            json.dump(feature, file)
            row_count += 1
        file.write('\n]\n}')

    session.close()

    session.close()

def display_parks():
    ''' Displays all parks in the database
    '''

    Session = sessionmaker(bind=engine)
    session = Session()

    sql = text('SELECT * FROM parks')
    result = session.execute(sql)

    # Print results by park
    for row in result:
        print('Id:', row[0], 'Park:', row[1], 'Latitude:', row[2], 'Longitude:', row[3])
        sql = text('SELECT * FROM facilities WHERE park_id = :id')
        print('Facilities:')
        facilities = session.execute(sql, {'id': row[0]})
        for facility in facilities:
            print('Id:', facility[0], 'Name:', facility[1], 'Type:', facility[3], 'Avg Rating:', facility[4], 'Num Ratings:', facility[5])
        print()

    # Export parks to CSV
    sql = text('SELECT * FROM parks')
    results = session.execute(sql)
    parks = []
    for park in results:
        parks.append(park)
    parks_df = pd.DataFrame(parks, columns=['id', 'name', 'latitude', 'longitude'])
    parks_df.to_csv('parks.csv', index=False)

    # Export facilities to CSV
    sql = text('SELECT * FROM facilities')
    results = session.execute(sql)
    facilities = []
    for facility in results:
        facilities.append(facility)
    facilities_df = pd.DataFrame(facilities, columns=['id', 'name', 'park_id', 'type', 'avg_rating', 'num_ratings'])
    facilities_df.to_csv('facilities.csv', index=False)

    session.close()

def delete_parks():
    ''' Deletes all parks from the database
    '''
    Session = sessionmaker(bind=engine)
    session = Session()

    sql = text('DELETE FROM parks')
    session.execute(sql)

    sql = text('DELETE FROM facilities')
    session.execute(sql)

    session.commit()
    session.close()

def insert_profiles(profiles):
    """ Method to insert profiles into the database

    Args:
        profiles (DataFrame): The profiles to insert into the database
    """
    Session = sessionmaker(bind=engine)
    session = Session()

    profiles.reset_index(drop=True, inplace=True)
    profiles.index += 1

    # Store profile dataframe into SQL database
    ##Table: profiles
    ##Column: id, Type: INTEGER
    ##Column: username, Type: VARCHAR
    ##Column: email, Type: VARCHAR
    ##Column: password, Type: VARCHAR

    for index, row in profiles.iterrows():
        id = index
        username = row['Username']
        email = row['Email']
        password = row['Password']
        sql = text('INSERT INTO profiles (id, username, email, password) VALUES (:id, :username, :email, :password)')
        session.execute(sql, {'id': id, 'username': username, 'email': email, 'password': password})
        num_bookings = random.randint(0,10)
        for i in range(num_bookings):
            insert_bookings(id, session)

    # Export bookings to CSV
    sql = text('SELECT * FROM bookings')
    results = session.execute(sql)
    bookings = []
    for booking in results:
        bookings.append(booking)
    bookings_df = pd.DataFrame(bookings, columns=['id', 'booker_id', 'datetime', 'cancelled', 'park', 'facility'])
    bookings_df.to_csv('bookings.csv', index=False)

    sql = text('SELECT * FROM reviews')
    results = session.execute(sql)
    reviews = []
    for review in results:
        reviews.append(review)
    reviews_df = pd.DataFrame(reviews, columns=['id', 'rating', 'comment', 'booking_id', 'facility_id'])
    reviews_df.to_csv('reviews.csv', index=False)

    session.commit()
    session.close()

booking_id = 1

def insert_bookings(booker, session):
    """ Method to insert bookings into the database

    Args:
        booker (int): The booker id
        session (Session): The session to use for the database
    """
    global booking_id
    id = booking_id
    booking_id += 1
    booker_id = booker
    datetime = random_date()
    cancelled = np.random.choice([True, False], p=[0.1, 0.9])
    sql = text('SELECT p.id, COUNT(f.id) FROM parks p LEFT JOIN facilities f ON p.id = f.park_id GROUP BY p.id')
    results = session.execute(sql)
    parks_with_facilities = [(row[0], row[1]) for row in results]
    parks_with_facilities.sort(key=lambda x: x[1], reverse=True)

    total_facilities = sum(count for _, count in parks_with_facilities)
    park_probabilities = [count / total_facilities for _, count in parks_with_facilities]
    chosen_park_id = np.random.choice(len(parks_with_facilities), p=park_probabilities)
    park_id = parks_with_facilities[chosen_park_id][0]
    sql = text('SELECT * FROM facilities WHERE park_id = :park')
    results = session.execute(sql, {'park': park_id}) # Get all facilities in the park
    facilities = [facility for facility in results]

    facility_type_prob = {
        FacilityType.BBQ_PIT.value: 0.5,
        FacilityType.CAMPSITE.value: 0.3,
        FacilityType.VENUES.value: 0.2
    }
    facility_types = list(facility_type_prob.keys())
    probabilities = list(facility_type_prob.values())

    chosen_facility_type = np.random.choice(facility_types, p=probabilities)[0]

    filtered_facilities = [facility for facility in facilities if facility.type == chosen_facility_type]

    if not filtered_facilities:
        filtered_facilities = facilities

    chosen_facility = random.choice(filtered_facilities)
    facility_id = chosen_facility.id

    sql = text('INSERT INTO bookings (id, booker_id, datetime, cancelled, park_id, facility_id) VALUES (:id, :booker_id, :datetime, :cancelled, :park_id, :facility_id)')
    session.execute(sql, {'id': id, 'booker_id': booker_id, 'datetime': datetime, 'cancelled': cancelled, 'park_id': park_id, 'facility_id': facility_id})
    review_rate = np.random.choice([True, False], p=[0.4, 0.6])
    if not cancelled and review_rate:
        insert_reviews(id, park_id, facility_id, session)

def insert_reviews(booking, park_id, facility_id, session):
    """ Method to insert reviews into the database

    Args:
        booking (int): The booking id
        park (int): The park id
        facility (int): The facility id
        session (Session): The session to use for the database
    """
    id = booking
    rating = int(np.random.choice([1, 2, 3, 4, 5], p=[0.05, 0.1, 0.2, 0.35, 0.3]))
    sql = text('SELECT name FROM parks WHERE id = :park_id')
    result = session.execute(sql, {'park_id': park_id})
    park = result.fetchone()[0]
    sql = text('SELECT name, avg_rating, num_ratings FROM facilities WHERE id = :facility_id')
    result = session.execute(sql, {'facility_id': facility_id})
    row = result.fetchone()
    facility = row[0]
    avg_rating = row[1]
    num_ratings = row[2]

    # Make request to OpenAI API to generate review
    user_msg = "Generate a review for this. The park is " + str(park) + " and the facility is " + str(facility) + ". The rating is " + str(rating) + "."
    print(user_msg)
    response = client.chat.completions.create(
        model=model_name,
        messages=[
            {"role": "system",
             "content": "Generate short reviews for park facilities for a booking app for the National Parks Board. You may use Singlish terms and grammar structures and avoid long paragraphs. You may use other languages. Usage of emojis is disallowed.. Avoid long paragraphs."},
            {"role": "user",
             "content": user_msg},
            ])
    comment = response.choices[0].message.content
    print(comment)
    sql = text('INSERT INTO reviews (id, rating, comment, booking_id, facility_id) VALUES (:id, :rating, :comment, :booking_id, :facility_id)')
    session.execute(sql, {'id': id, 'rating': rating, 'comment': comment, 'booking_id': booking, 'facility_id': facility_id})

    # Update facility average rating and number of ratings
    avg_rating = (avg_rating * num_ratings + rating) / (num_ratings + 1)
    num_ratings += 1
    sql = text('UPDATE facilities SET avg_rating = :avg_rating, num_ratings = :num_ratings WHERE id = :facility_id')
    session.execute(sql, {'avg_rating': avg_rating, 'num_ratings': num_ratings, 'facility_id': facility_id})

def random_date(start_date=datetime.datetime(2024, 1, 1), end_date = datetime.datetime(2025, 12, 31)):
    faker = Faker()
    delta = end_date - start_date
    random_days = random.randrange(delta.days)
    random_seconds = random.randrange(48 * 60 * 30) # 30 minute intervals
    generated_date = start_date + datetime.timedelta(days=random_days, minutes=random_seconds)
    rounded_date = generated_date.replace(second=0, microsecond=0, minute=(generated_date.minute // 30) * 30)
    return rounded_date

def display_profiles():
    """ Method to display profiles from the database
    """
    Session = sessionmaker(bind=engine)
    session = Session()
    sql = text('SELECT * FROM profiles')
    result = session.execute(sql)
    for row in result:
        print('Id:', row[0], 'Username:', row[1], 'Email:', row[2], 'Password:', row[3])
        sql = text('SELECT * FROM bookings WHERE booker_id = :id')
        bookings = session.execute(sql, {'id': row[0]})
        for booking in bookings:
            print('Booking Id:', booking[0], 'Booker Id:', booking[1], 'Datetime:', booking[2], 'Cancelled:', booking[3], 'Park:', booking[4], 'Facility:', booking[5])
            sql = text('SELECT * FROM reviews WHERE booking_id = :id')
            reviews = session.execute(sql, {'id': booking[0]})
            for review in reviews:
                print('Review Id:', review[0], 'Rating:', review[1], 'Comment:', review[2], 'Booking Id:', review[3], 'Facility Id:', review[4])
    session.close()

def display_bookings():
    """ Method to display bookings from the database
    """
    Session = sessionmaker(bind=engine)
    session = Session()
    sql = text('SELECT * FROM bookings')
    result = session.execute(sql)
    for row in result:
        print('Id:', row[0], 'Booker Id:', row[1], 'Datetime:', row[2], 'Cancelled:', row[3], 'Park:', row[4], 'Facility:', row[5])

def delete_profiles():
    """ Method to delete profiles from the database
    """
    Session = sessionmaker(bind=engine)
    session = Session()
    sql = text('DELETE FROM profiles')
    session.execute(sql)
    sql = text('DELETE FROM bookings')
    session.execute(sql)
    sql = text('DELETE FROM reviews')
    session.execute(sql)
    sql = text('UPDATE facilities SET avg_rating = 0, num_ratings = 0')
    session.execute(sql)
    session.commit()
    session.close()

def insert_profiles_from_csv(profiles, bookings, reviews):
    """ Method to insert profiles from a CSV file

    Args:
        profiles (DataFrame): The profiles to insert into the database
        bookings (DataFrame): The bookings to insert into the database
        reviews (DataFrame): The reviews to insert into the database
    """
    Session = sessionmaker(bind=engine)
    session = Session()

    profiles.reset_index(drop=True, inplace=True)
    profiles.index += 1

    for index, row in profiles.iterrows():
        id = index
        username = row['Username']
        email = row['Email']
        password = row['Password']
        sql = text('INSERT INTO profiles (id, username, email, password) VALUES (:id, :username, :email, :password)')
        session.execute(sql, {'id': id, 'username': username, 'email': email, 'password': password})

    for index, row in bookings.iterrows():
        id = row['id']
        booker_id = row['booker_id']
        datetime = row['datetime']
        cancelled = row['cancelled']
        park_id = row['park']
        facility_id = row['facility']
        sql = text('INSERT INTO bookings (id, booker_id, datetime, cancelled, park_id, facility_id) VALUES (:id, :booker_id, :datetime, :cancelled, :park_id, :facility_id)')
        session.execute(sql, {'id': id, 'booker_id': booker_id, 'datetime': datetime, 'cancelled': cancelled, 'park_id': park_id, 'facility_id': facility_id})

    for index, row in reviews.iterrows():
        id = row['id']
        rating = row['rating']
        comment = row['comment']
        booking_id = row['booking_id']
        facility_id = row['facility_id']
        sql = text('INSERT INTO reviews (id, rating, comment, booking_id, facility_id) VALUES (:id, :rating, :comment, :booking_id, :facility_id)')
        session.execute(sql, {'id': id, 'rating': rating, 'comment': comment, 'booking_id': booking_id, 'facility_id': facility_id})

    session.commit()
    session.close()

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, 'Parks.geojson')
    parks = read_geojson(file_path)

    profiles = pd.read_csv('profiles.csv', delimiter=',')
    bookings = pd.read_csv('bookings.csv', delimiter=',')
    reviews = pd.read_csv('reviews.csv', delimiter=',')

    while True:
        option = input("Enter the function to run"
                        "\n1. Insert parks"
                       "\n2. Display parks"
                       "\n3. Delete parks"
                       "\n4. Insert profiles"
                       "\n5. Display profiles"
                       "\n6. Delete profiles"
                       "\n7. Display bookings"
                       "\n8. Reload all data"
                       "\n0. Exit\n")
        if option == '1':
            insert_parks(parks)
        elif option == '2':
            display_parks()
        elif option == '3':
            delete_parks()
        elif option == '4':
            insert_profiles(profiles)
        elif option == '5':
            display_profiles()
        elif option == '6':
            delete_profiles()
        elif option == '7':
            display_bookings()
        elif option == '8':
            delete_parks()
            insert_parks(parks)
            delete_profiles()
            insert_profiles_from_csv(profiles, bookings, reviews)
            create_geosjon_from_db()
        elif option == '0':
            exit()
        else:
            print('Invalid option')
