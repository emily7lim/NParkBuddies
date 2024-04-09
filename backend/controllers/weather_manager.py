import time
import datetime

class WeatherManager:
    """ Class to manage weather data
    """
    def __init__(self, weather_instance) -> None:
        """ Method to initialize the WeatherManager class with an instance of the Weather class

        Args:
            weather_instance (Weather): An instance of the Weather class
        """
        self.weather_instance = weather_instance

    def query_weather(self) -> dict:
        """ Method to query the weather data

        Returns:
            dict: The weather forecast
        """
        while True:
            result = self.weather_instance.get_weather()
            if result.get('error'):
                time.sleep(1)
            else:
                weather = result.get('forecast')
                return weather

    def send_weather_warning(self, region='central') -> str:
        """ Method to send a weather warning message for a specific region

        Args:
            region (str, optional): Region to check the weather for. Defaults to 'central'.

        Returns:
            str: The weather warning message
        """
        weather = self.query_weather()
        forecasts = {}

        # Initialize labels for the parts of the day
        time_labels = {"Morning": "this morning", "Afternoon": "this afternoon", "Night": "tonight"}

        # Determine the first time slot to adjust the labels accordingly
        first_period = weather[0] if weather else None
        if first_period:
            first_time_component = datetime.datetime.strptime(first_period['time']['start'], '%Y-%m-%dT%H:%M:%S%z').strftime('%H:%M')
            if first_time_component == '06:00':  # If the day starts in the morning
                time_labels = {"Morning": "this morning", "Afternoon": "this afternoon", "Night": "tonight"}
            elif first_time_component == '12:00':  # Starts in the afternoon
                time_labels = {"Morning": "tomorrow morning", "Afternoon": "this afternoon", "Night": "tonight"}
            elif first_time_component == '18:00':  # Starts at night
                time_labels = {"Morning": "tomorrow morning", "Afternoon": "tomorrow afternoon", "Night": "tonight"}

        # Extract the forecast for the specified region
        for period in weather:
            time_start = period.get('time').get('start')
            # Extract time component from time_start
            time_component = datetime.datetime.strptime(time_start, '%Y-%m-%dT%H:%M:%S%z').strftime('%H:%M')
            time_of_day = "Morning" if time_component == '06:00' else "Afternoon" if time_component == '12:00' else "Night"
            forecasts[time_of_day] = period.get("regions").get(region)

        message = None
        # Generate the weather warning message
        for time, forecast in forecasts.items():
            label = time_labels.get(time)
            if "Showers" in forecast:
                message = f"Warning! Expect showers {label}!"
                break

        return message