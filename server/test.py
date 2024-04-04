import requests
import json

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

test2()