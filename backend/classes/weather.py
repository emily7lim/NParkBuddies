""" Module to represent weather class"""

import requests 
from datetime import datetime

class Weather():
    """ Class to represent weather
    """
    def __init__(self):
        self.temperature = None
        self.humidity = None
        self.wind_speed = None
        self.weather = None

    def get_temperature(self):
        """ Method to get the temperature of the weather
        Returns:
            float: temperature of the weather
        """
        # Define the URL
        url = 'https://api.data.gov.sg/v1/environment/air-temperature'

        # Make the GET request
        response = requests.get(url)

        # Check the status code
        if response.status_code == 200:
            data = response.json()
            temperature = 0  # Initialize temperature
            #print(data['metadata']['stations'])
            #for aItem in data['metadata']['stations']: # 1 station at woodlands 1 at pulau ubin, ignore pulau ubin
            #    if aItem['id']=='S104':
            #       break
            #print(data['items'][0]['readings'])
            for aItem2 in data['items'][0]['readings']: #each item has station_id(same as id above), temperature in deg celcius(value), e.g {'station_id': 'S104', 'value': 29}
                #if aItem2['station_id']==aSid:
                temperature=aItem2['value']+ temperature #sum up all the temperatures
            
            temperature=temperature/len(data['items'][0]['readings']) #average temperature
            self.temperature=temperature
            print("Temperature: ", self.temperature)

        else:
            print("Error retrieving data")

        if temperature==-69.6:
            print("Something went wrong with the API")

        return self.temperature
    
    #find the region a location belongs in
    def getRegion(self, lat, lng):
        if lat>1.472 or lat<1.158 or lng<103.600 or lng>104.090: #outside bounds of Singapore
            region='Not in Singapore'
            return region
        else:
            if lng>=103.897:
                region='East' #Use tampines forecast, ignoring pulau ubin as not connected to mainland
            elif lng<=103.762:
                if lat<=1.366:
                    region='West' #Use jurong west forecast
                else: #lat>1.366:
                    region='UluWest' #Use tengah forecast
            elif lng>103.762 and lng<103.897:
                if lat>=1.393:
                    region='North' #Use Mandai
                elif lat<=1.260:
                    region='Sentosa' #Use Sentosa
                elif lat>1.260 and lat<=1.338:
                    region='South' #Use Tanglin 
                else: #lat>1.338 and lat<1.393
                    region='Central' #Use Bishan 
            else:
                print(lat,lng)
                region='Error'
        return region
    
    #forecast for 2 hour on same day 
    def getForecast(self, region):
        url = 'https://api.data.gov.sg/v1/environment/2-hour-weather-forecast'
        response = requests.get(url)

        location=''
        weather='Error'
        if region=='Error' or region=='Not in Singapore':
            print("Invalid region")
            return weather
        if response.status_code == 200:
            data = response.json()
            if 'forecasts' in data['items'][0]:
                if region=='North':
                    location='Mandai'
                elif region=='UluWest':
                    location='Tengah'
                elif region=='West':
                    location='Jurong West'
                elif region=='Central':
                    location='Bishan'
                elif region=='South':
                    location='Tanglin'
                elif region=='East':
                    location='Tampines'
                elif region=='Sentosa':
                    location='Sentosa'
                for fItem in data['items'][0]['forecasts']:
                    if fItem['area']==location:
                        weather=fItem['forecast']
                        break
                if weather=='Error':
                    print("Weather not found despite valid location, something went wrong with the API")
            else:
                # 'forecasts' key does not exist in the response dictionary
                print("No forecasts found")
                return "Error with API"
            
        else:
            print("Error retrieving data")
        
        self.weather=weather
        return weather
    
    #forecast for 4 days from today
    def getForecast4Days(self):
        url = 'https://api.data.gov.sg/v1/environment/4-day-weather-forecast'
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()
            forecasts = data['items'][0]['forecasts']
            forecast_list = []  # Initialize list to store forecast data
            for forecast in forecasts:
                temperature = forecast['temperature']
                avg_temperature = (temperature['high'] + temperature['low']) / 2
                date = forecast['date']
                forecast_text = forecast['forecast']
                relative_humidity = forecast['relative_humidity']
                wind = forecast['wind']

                # Create a dictionary for the day's forecast
                day_forecast = {
                    'date': date,
                    'average_temperature': avg_temperature,
                    'forecast': forecast_text,
                    'relative_humidity': relative_humidity,
                    'wind': wind
                }

                # Append the day's forecast to the list
                forecast_list.append(day_forecast)

            # Store the list in the instance variable
            self.forecast_list = forecast_list

            return forecast_list  # Return the list

        else:
            print("Error retrieving data")
        


    def set_temperature(self, temperature):
        """ Method to set the temperature of the weather

        Args:
            temperature (float): temperature of the weather
        """
        self.temperature = temperature

    def get_humidity(self):
        """ Method to get the humidity of the weather

        Returns:
            float: humidity of the weather
        """
        return self.humidity

    def set_humidity(self, humidity):
        """ Method to set the humidity of the weather

        Args:
            humidity (float): humidity of the weather
        """
        self.humidity = humidity

    def get_wind_speed(self):
        """ Method to get the wind speed of the weather

        Returns:
            float: wind speed of the weather
        """
        return self.wind_speed

    def set_wind_speed(self, wind_speed):
        """ Method to set the wind speed of the weather

        Args:
            wind_speed (float): wind speed of the weather
        """
        self.wind_speed = wind_speed

    def get_weather(self):
        """ Method to get the weather of the weather

        Returns:
            string: weather of the weather
        """
        return self.weather

    def set_weather(self, weather):
        """ Method to set the weather of the weather

        Args:
            weather (string): weather of the weather
        """
        self.weather = weather

    


# Create an instance of the Weather class

weather = Weather()
#weather.get_temperature()
#region = weather.getRegion(1.362582, 103.671071)  # Get the region
#forecast = weather.getForecast(region)  # Get the forecast for the region
#print(forecast)  # Print the forecast
forecast4days = weather.getForecast4Days()  # Get the 4-day forecast
print(forecast4days)  # Print the 4-day forecast

