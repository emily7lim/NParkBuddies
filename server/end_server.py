# End Flask app by sending POST request to /shutdown
import requests

if __name__ == "__main__":
    url = 'http://127.0.0.1:5000/shutdown'  # URL to send POST request to
    response = requests.post(url)  # Send POST request
    if response.status_code == 200:
        print('Server shutting down...')