import requests
import json
import datetime
from geopy.geocoders import Nominatim

from ip2geotools.databases.noncommercial import DbIpCity

def get_location(ip):
    res = DbIpCity.get(ip, api_key='free')
    print(res.latitude, res.longitude)

# Format for JSON GET requests

def test():
    _ = ['parks', 'facilities', 'profiles', 'bookings', 'reviews']
    for item in _:
        response = requests.get(f'http://localhost:5000/{item}')
        if response.status_code == 200:
            process_json(response.text)
        else:
            print(f"Error: {response.status_code}")

def test2():
    response = requests.get('http://localhost:5000/parks/East Coast Park')
    if response.status_code == 200:
        process_json(response.text)
    else:
        print(f"Error: {response.status_code}")
    response = requests.get('http://localhost:5000/parks/East Coast Park/facilities')
    if response.status_code == 200:
        process_json(response.text)
    else:
        print(f"Error: {response.status_code}")

def test_booking():
    url = 'http://localhost:5000/bookings'

    user_id = 2
    park_id = 4
    facility_id = 15
    booking_datetime = datetime.datetime(2024, 11, 26, 12, 0, 0)

    payload = {
        'user_id': user_id,
        'park_id': park_id,
        'facility_id': facility_id,
        'datetime': booking_datetime.isoformat()
    }

    response = requests.post(url, json=payload)

    if response.status_code == 200:
        booking_info = json.loads(response.text)
        print(booking_info)
    else:
        print(f"Error: {response.status_code}")

def process_json(json_message):
    # Load the JSON message
    data = json.loads(json_message)

    # Iterate through each dictionary in the list
    for item in data:
        # Print each dictionary
        if isinstance(item, dict):
            for key, value in item.items():
                print(f"{key}: {value}")
        elif isinstance(item, list):
            for i in item:
                for key, value in i.items():
                    print(f"{key}: {value}")

def test3():
    url = 'http://localhost:5000/profiles/create'

    username = 'kkhoo'
    password = 'kkhoo'
    email = 'kkhoo.com'

    print(f"Creating account with username: {username}, email: {email}, password: {password}")

    payload = {
        'username': username,
        'email': email,
        'password': password,
    }

    response = requests.post(url, json=payload)

    print(response.text)

    if response.status_code == 200:
        profile_info = json.loads(response.text)
        print(profile_info)
    else:
        print(f"Error: {response.status_code}")


def testlogin():
    url = 'http://localhost:5000/profiles/login'

    user_identifier = 'kkhoo123'
    password = 'kkhoo123'

    print(f"Logging in with username: {user_identifier}, password: {password}")

    payload = {
        'user_identifier': user_identifier,
        'password': password,
    }

    response = requests.post(url, json=payload)

    print(response.text)

    if response.status_code == 200:
        login_info = json.loads(response.text)
        print(login_info)
    else:
        print(f"Error: {response.status_code}")

def testpw():
    url = 'http://localhost:5000/profiles/kkhoo/change_password'

    user_identifier = 'kkhoo'
    new_password = 'kkhoo123'

    print(f"Changing password for user with username: {user_identifier}, new password: {new_password}")

    payload = {
        'user_identifier': user_identifier,
        'new_password': new_password,
    }

    response = requests.post(url, json=payload)

    print(response.text)

    if response.status_code == 200:
        pw_info = json.loads(response.text)
        print(pw_info)
    else:
        print(f"Error: {response.status_code}")

def testchangeusername():
    url = 'http://localhost:5000/profiles/kkhoo/change_username'

    old_username = 'kkhoo'
    new_username = 'kkhoo123'

    print(f"Changing username for user with username: {old_username}, new username: {new_username}")

    payload = {
        'old_username': old_username,
        'new_username': new_username,
    }

    response = requests.post(url, json=payload)

    print(response.text)

    if response.status_code == 200:
        username_info = json.loads(response.text)
        print(username_info)
    else:
        print(f"Error: {response.status_code}")

def testchangeemail():
    url = 'http://localhost:5000/profiles/kkhoo/change_email'

    old_email = 'kkhoo.com'
    new_email = 'kkhoo123.com'

    print(f"Changing email for user with email: {old_email}, new email: {new_email}")

    payload = {
        'old_email': old_email,
        'new_email': new_email,
    }

    response = requests.post(url, json=payload)

    print(response.text)

    if response.status_code == 200:
        email_info = json.loads(response.text)
        print(email_info)
    else:
        print(f"Error: {response.status_code}")

def testdeleteaccount():
    url = 'http://localhost:5000/profiles/kkhoo123/delete_account'

    user_identifier = 'kkhoo123'

    print(f"Deleting account for user with username: {user_identifier}")

    payload = {
        'user_identifier': user_identifier,
    }

    response = requests.post(url, json=payload)

    print(response.text)

    if response.status_code == 200:
        delete_info = json.loads(response.text)
        print(delete_info)
    else:
        print(f"Error: {response.status_code}")

def get_user_location():
    """ Method to get user location

    Returns:
        location: user location
    """
    geolocator = Nominatim(user_agent="nparkbuddy")
    ip_address = '192.168.0.0'
    try:
        location = geolocator.geocode(ip_address)
    except:
        location = geolocator.geocode("Singapore")

    return {
        'latitude': location.latitude,
        'longitude': location.longitude
    }

#test2()
#test3()
#testlogin()
#testpw()
#testchangeusername()
#testchangeemail()
#testdeleteaccount()
#test_booking()
#location = get_user_location()
#print(location['latitude'], location['longitude'])

get_location('155.69.180.5')