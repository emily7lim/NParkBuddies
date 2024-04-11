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
    def create_booking(user_id, park_id, facility_id, datetime) -> dict:
        """ Method to create a booking

        Args:
            user_id (int): The id of the user
            park_id (int): The id of the park
            facility_id (int): The id of the facility
            datetime (datetime): The date and time of the booking

        Returns:
            dict: A dictionary of the booking
        """
        id = len(db.bookings) + 1
        # Check if user is in db.profiles
        user = [user for user in db.profiles if user.get_id() == user_id][0]
        # Get park from db.parks using park_id
        park = [park for park in db.parks if park.get_id() == park_id][0]
        # Get facility from park using facility_id
        facility = [facility for facility in park.get_facilities() if facility.get_id() == facility_id][0]

        # Check if the user, park and facility exist
        if user is None:
            return {'error': 'User not found'}
        if park is None:
            return {'error': 'Park not found'}
        if facility is None:
            return {'error': 'Facility not found'}

        datetime = dt.strptime(datetime, '%Y-%m-%dT%H:%M:%S')
        if datetime < dt.now():
            return {'error': 'Invalid datetime'}

        # Check if the park and facility are available at the given datetime
        for booking in db.bookings:
            if booking.get_park() == park and booking.get_facility() == facility and booking.get_datetime() == datetime and not booking.get_cancelled():
                print(booking.get_id())
                return {'error': 'Time slot not available'}

        booking = Booking(id=id, booker=user_id, datetime=datetime, cancelled=False, park=park, facility=facility)
        user.set_bookings(booking)
        db.bookings.append(booking)
        #profileDB = db.get_user_by_id(user_id)
        #parkDB = db.get_park_by_id(park_id)
        #facilityDB = db.get_facility_by_id(facility_id)
        bookingDB = BookingDB(id=booking.get_id(), booker_id=user_id, datetime=datetime, cancelled=False, park_id=park_id, facility_id=facility_id)
        db.create_booking(bookingDB)

        return {'id': booking.get_id(),
                'booker': booking.get_booker(),
                'datetime': booking.get_datetime(),
                'cancelled': booking.get_cancelled(),
                'park': booking.get_park().get_name(),
                'facility': booking.get_facility().get_name()
                }

    @staticmethod
    def get_booked_timeslots(park_name, facility_name) -> dict:
        """ Method to get booked timeslots

        Args:
            park_id (int): The id of the park
            facility_id (int): The

        Returns:
            dict: A dictionary of the booked timeslots
        """
        print(park_name, facility_name)
        park = [park for park in db.parks if park.get_name() == park_name][0]
        if park is None:
            return {'error': 'Park not found'}
        facility = [facility for facility in park.get_facilities() if facility.get_name() == facility_name][0]
        timeslots = []
        for booking in db.bookings:
            if booking.get_park().get_id() == park.get_id() and booking.get_facility().get_id() == facility.get_id():
                timeslots.append(booking.get_datetime())

        if len(timeslots) == 0:
            return {'info': 'No bookings'}
        return {'timeslots': timeslots}


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