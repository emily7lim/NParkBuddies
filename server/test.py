import requests
import json

# Format for JSON GET requests


def test():
    # Query server for parks
    response = requests.get('http://localhost:5000/parks')

    if response.status_code == 200:
        process_json(response.text)

    # Query server for facilities
    response = requests.get('http://localhost:5000/facilities')

    if response.status_code == 200:
        process_json(response.text)

    # Query server for profiles
    response = requests.get('http://localhost:5000/profiles')

    if response.status_code == 200:
        process_json(response.text)

    # Query server for bookings
    response = requests.get('http://localhost:5000/bookings')

    if response.status_code == 200:
        process_json(response.text)

    # Query server for reviews
    response = requests.get('http://localhost:5000/reviews')

    if response.status_code == 200:
        process_json(response.text)

def process_json(json_message):
    # Load the JSON message
    data = json.loads(json_message)

    # Iterate through each dictionary in the list
    for item in data:
        # Print each dictionary
        for key, value in item.items():
            print(f"{key}: {value}")

test()