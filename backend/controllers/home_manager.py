from datetime import datetime as dt
from data_store import db
from classes.booking import Booking
from database.database import Booking as BookingDB
from controllers.weather_manager import WeatherManager

class HomeManager:
    """ Class for managing home page data

    Returns:
        HomeManager: A class to manage home page data
    """
    @staticmethod
    def view_parks() -> list:
        """ Method to view all parks

        Returns:
            list: A list of all parks
        """
        parks = []
        for park in db.parks:
            parks.append({'id': park.get_id(),
                        'name': park.get_name(),
                        'latitude': park.get_latitude(),
                        'longitude': park.get_longitude(),
                        'facilities': [facility.get_name() for facility in park.get_facilities()]
                        })
        return parks

    @staticmethod
    def create_booking(username, park_name, facility_name, datetime) -> dict:
        """ Method to create a booking

        Args:
            username (string): The username of the user
            park (string): The name of the park
            facility (string): The name of the facility
            datetime (datetime): The date and time of the booking

        Returns:
            dict: A dictionary of the booking
        """
        id = len(db.bookings) + 1
        # Check if user is in db.profiles
        user = [user for user in db.profiles if user.get_username() == username][0]
        # Get park from db.parks using park_name
        park = [park for park in db.parks if park.get_name() == park_name][0]
        # Get facility from park using facility_name
        facility = [facility for facility in park.get_facilities() if facility.get_name() == facility_name][0]

        # Check if the user, park and facility exist
        if user is None:
            return {'error': 'User not found'}
        if park is None:
            return {'error': 'Park not found'}
        if facility is None:
            return {'error': 'Facility not found'}

        datetime = dt.strptime(datetime, '%a, %d %b %Y %H:%M:%S %Z')
        if datetime < dt.now():
            return {'error': 'Invalid datetime'}

        # Check if the park and facility are available at the given datetime
        for booking in db.bookings:
            if booking.get_park() == park and booking.get_facility() == facility and booking.get_datetime() == datetime and not booking.get_cancelled():
                return {'error': 'Time slot not available'}

        booking = Booking(id=id, booker=user.get_id(), datetime=datetime, cancelled=False, park=park, facility=facility)
        user.set_bookings(booking)
        db.bookings.append(booking)
        bookingDB = BookingDB(id=booking.get_id(), booker_id=user.get_id(), datetime=datetime, cancelled=False, park_id=park.get_id(), facility_id=facility.get_id())
        db.session.add(bookingDB)
        db.session.commit()

        return {'id': booking.get_id(),
                'booker': booking.get_booker(),
                'datetime': booking.get_datetime(),
                'cancelled': booking.get_cancelled(),
                'park': booking.get_park().get_name(),
                'facility': booking.get_facility().get_name()
                }

    @staticmethod
    def get_available_timeslots(park_name, facility_name, date) -> dict:
        """ Method to get available timeslots

        Args:
            park_name (string): The name of the park
            facility_name (string): The name of the facility
            date (datetime): The date of the booking

        Returns:
            dict: A dictionary of the available timeslots
        """
        park = [park for park in db.parks if park.get_name() == park_name][0]
        if park is None:
            return {'error': 'Park not found'}
        facility = [facility for facility in park.get_facilities() if facility.get_name() == facility_name][0]
        if facility is None:
            return {'error': 'Facility not found'}
        date = dt.strptime(date, '%d-%b-%Y')
        # Create timeslots from 08:00 to 19:00
        timeslots = []
        for i in range(9, 20):
            timeslots.append(dt(date.year, date.month, date.day, i, 0, 0))

        booked_timeslots = []
        for booking in db.bookings:
            if booking.get_park().get_id() == park.get_id() and booking.get_facility().get_id() == facility.get_id():
                booked_timeslots.append(booking.get_datetime())
        # Check if timeslot is available by removing booked timeslots
        available_timeslots = [timeslot for timeslot in timeslots if timeslot not in booked_timeslots]
        return {'available_timeslots': available_timeslots}

    @staticmethod
    def select_park(park_name) -> dict:
        """ Method to select a park

        Args:
            park_name (string): The name of the park

        Returns:
            dict: A dictionary of the park
        """
        for park in db.parks:
            if park.get_name() == park_name:
                return {'id': park.get_id(),
                        'name': park.get_name(),
                        'latitude': park.get_latitude(),
                        'longitude': park.get_longitude(),
                        'facilities': [facility.get_name() for facility in park.get_facilities()]
                        }
        return None