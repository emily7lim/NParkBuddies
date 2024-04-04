""" Module to represent a booking"""

from datetime import datetime

class Booking:
    """ Class to represent a booking
    """
    def __init__(self, id=None, booker=None, datetime=None, cancelled=None, park=None, facility=None) -> None:
        self.set_id(id)
        self.set_booker(booker)
        self.set_datetime(datetime)
        self.set_cancelled(cancelled)
        self.set_park(park)
        self.set_facility(facility)
        self.reviews = []

    def get_id(self) -> int:
        """ Method to get the id of the booking

        Returns:
            int: id of the booking
        """
        return self.id

    def set_id(self, id_no) -> None:
        """ Method to set the id of the booking

        Args:
            id_no (int): id of the booking
        """
        self.id = id_no

    def get_booker(self) -> int:
        """ Method to get the booker of the booking

        Returns:
            int: booker id of the booking
        """
        return self.booker

    def set_booker(self, booker_id) -> None:
        """ Method to set the booker of the booking

        Args:
            booker_id (string): booker of the booking
        """
        self.booker = booker_id

    def get_datetime(self) -> datetime:
        """ Method to get the datetime of the booking

        Returns:
            datetime: datetime of the booking
        """
        return self.datetime

    def set_datetime(self, datetime) -> None:
        """ Method to set the datetime of the booking

        Args:
            datetime (datetime): datetime of the booking
        """
        self.datetime = datetime

    def get_cancelled(self) -> bool:
        """ Method to get the cancelled status of the booking

        Returns:
            bool: cancelled status of the booking
        """
        return self.cancelled

    def set_cancelled(self, cancelled) -> None:
        """ Method to set the cancelled status of the booking

        Args:
            cancelled (bool): cancelled status of the booking
        """
        if isinstance(cancelled, bool):
            self.cancelled = cancelled
        else:
            raise ValueError('Invalid cancelled status')

    from classes.park import Park
    def get_park(self) -> Park:
        """ Method to get the park of the booking

        Returns:
            park: park of the booking
        """
        return self.park

    def set_park(self, new_park) -> None:
        """ Method to set the park of the booking

        Args:
            new_park (Park): park of the booking

        Raises:
            ValueError: "Invalid park"
        """
        from classes.park import Park
        if isinstance(new_park, Park):
            self.park = new_park
        else:
            raise ValueError('Invalid park')

    from classes.facility import Facility
    def get_facility(self) -> Facility:
        """ Method to get the facility of the booking

        Returns:
            facility: facility of the booking
        """
        return self.facility

    def set_facility(self, new_facility) -> None:
        """ Method to set the facility of the booking

        Args:
            facility (Facility): facility of the booking

        Raises:
            ValueError: "Invalid facility"
        """
        from classes.facility import Facility
        if isinstance(new_facility, Facility):
            self.facility = new_facility
        else:
            raise ValueError('Invalid facility')

    def get_reviews(self) -> list:
        """ Method to get the reviews of the booking

        Returns:
            list: reviews of the booking
        """
        return self.reviews

    def set_reviews(self, *reviews) -> None:
        """ Method to add a review to the booking

        Args:
            *reviews (tuple): tuple of reviews of the booking"""
        from classes.review import Review
        for review in reviews:
            if isinstance(review, Review):
                self.reviews.append(review)
            else:
                raise ValueError('Invalid review')
