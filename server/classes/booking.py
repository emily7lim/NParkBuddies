""" Module to represent a booking"""

from server.classes.park import Park
from server.classes.facility import Facility

class Booking:
    """ Class to represent a booking
    """
    def __init__(self):
        self.booker = None
        self.date = None
        self.time = None
        self.cancelled = False
        self.park = None
        self.facility = None

    def get_booker(self):
        """ Method to get the booker of the booking

        Returns:
            int: booker id of the booking
        """
        return self.booker

    def set_booker(self, booker_id):
        """ Method to set the booker of the booking

        Args:
            booker_id (string): booker of the booking
        """
        self.booker = booker_id


    def get_date(self):
        """ Method to get the date of the booking

        Returns:
            date: date of the booking
        """
        return self.date

    def set_date(self, date):
        """ Method to set the date of the booking

        Args:
            date (date): date of the booking
        """
        self.date = date

    def get_time(self):
        """ Method to get the time of the booking

        Returns:
            time: time of the booking
        """
        return self.time

    def set_time(self, time):
        """ Method to set the time of the booking

        Args:
            time (time): time of the booking
        """
        self.time = time

    def get_cancelled(self):
        """ Method to get the cancelled status of the booking

        Returns:
            bool: cancelled status of the booking
        """
        return self.cancelled

    def set_cancelled(self, cancelled):
        """ Method to set the cancelled status of the booking

        Args:
            cancelled (bool): cancelled status of the booking
        """
        self.cancelled = cancelled

    def get_park(self):
        """ Method to get the park of the booking

        Returns:
            park: park of the booking
        """
        return self.park

    def set_park(self, new_park):
        """ Method to set the park of the booking

        Args:
            new_park (Park): park of the booking

        Raises:
            ValueError: "Invalid park"
        """
        if isinstance(new_park, Park):
            self.park = new_park
        else:
            raise ValueError('Invalid park')

    def get_facility(self):
        """ Method to get the facility of the booking

        Returns:
            facility: facility of the booking
        """
        return self.facility

    def set_facility(self, new_facility):
        """ Method to set the facility of the booking

        Args:
            facility (Facility): facility of the booking

        Raises:
            ValueError: "Invalid facility"
        """
        if isinstance(new_facility, Facility):
            self.facility = new_facility
        else:
            raise ValueError('Invalid facility')
