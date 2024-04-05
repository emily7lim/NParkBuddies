import requests
import json
import datetime

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

    user_id = 1
    park_id = 1
    facility_id = 1
    booking_datetime = datetime.datetime(2024, 12, 25, 12, 0, 0)

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

#def test3():
#    url = 'http://localhost:5000/profiles/create'

#    username = 'testuser'
#    password = 'testpassword'
#    email = 'testemail'

#    payload = {
#        'username': username,
#        'email': email,
#        'password': password,
#    }

#    response = requests.post(url, json=payload)

#    if response.status_code == 200:
#        profile_info = json.loads(response.text)
#        print(profile_info)
#    else:
#        print(f"Error: {response.status_code}")

test_booking()
#test3()
