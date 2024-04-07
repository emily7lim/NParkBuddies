import requests
import time
import threading

class Weather:
    """ Class to get the 24-hour weather forecast for a region
    """
    def __init__(self) -> None:
        self.weather = {}
        self.lock = threading.Lock() # Lock to synchronize access to weather data
        self.poll_interval = 3600  # Poll every hour (3600 seconds)
        self.stop_polling = False # Flag to stop polling
        self.data_fetched = False # Flag to indicate if data has been fetched

    def set_weather(self) -> None:
        """ Method to get the 24-hour weather forecast for a region from the data.gov.sg API
        """
        response = requests.get("https://api.data.gov.sg/v1/environment/24-hour-weather-forecast")
        data = response.json()
        forecasts = data['items'][0]['periods']

        # Acquire lock before updating weather data
        with self.lock:
            self.weather = forecasts
            if response.status_code == 200:
                self.data_fetched = True # Set flag to indicate data has been fetched
            else:
                self.data_fetched = False # Set flag to indicate data has not been fetched

    def get_weather(self):
        """ Method to get the 24-hour weather forecast for a region

        Returns:
            dict: 24-hour weather forecast for a region
        """
        # Acquire lock before accessing weather data
        with self.lock:
            if not self.data_fetched:
                return {'error': 'Data not fetched'}
            forecasts = self.weather
        return {'forecast': forecasts}

    def start_polling(self):
        """ Method to start polling the API every hour
        """
        while not self.stop_polling:
            self.set_weather()
            time.sleep(self.poll_interval)

    def stop(self):
        """ Method to stop polling the API
        """
        self.stop_polling = True
