""" Module to represent a review of a booking"""

from server.classes.booking import Booking

class Review():
    """ Class to represent a review of a booking
    """
    def __init__(self):
        self.rating = None
        self.comment = None
        self.booking = None

    def get_rating(self):
        """ Method to get the rating of the review

        Returns:
            int: rating of the review
        """
        return self.rating

    def set_rating(self, rating):
        """ Method to set the rating of the review

        Args:
            rating (int): rating of the review
        """
        self.rating = rating

    def get_comment(self):
        """ Method to get the comment of the review

        Returns:
            string: comment of the review
        """
        return self.comment

    def set_comment(self, comment):
        """ Method to set the comment of the review

        Args:
            comment (string): comment of the review
        """
        self.comment = comment

    def get_booking(self):
        """ Method to get the booking of the review

        Returns:
            Booking: booking of the review
        """
        return self.booking

    def set_booking(self, new_booking):
        """ Method to set the booking of the review

        Args:
            booking (Booking): booking of the review

        Raises:
            ValueError: [description]
        """
        if isinstance(new_booking, Booking):
            self.booking = new_booking
        else:
            raise ValueError('Invalid booking')
