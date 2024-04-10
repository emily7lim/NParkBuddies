from datetime import datetime as dt
from data_store import db
from classes.booking import Booking
from classes.review import Review

class BookingsManager:
    """ Class to manage booking page"

    Returns:
        BookingsManager: A class to manage booking page
    """

    @staticmethod
    def view_bookings(username) -> dict:
        """ Method to view all bookings of a user

        Args:
            username (string): The username of the user

        Returns:
            dict: A dictionary containing the past and current bookings of the user
            past_bookings (list): A list of dictionaries containing the past bookings of the user
            current_bookings (list): A list of dictionaries containing the current bookings of the user
        """
        user_id = [profile.get_id() for profile in db.profiles if profile.get_username() == username][0]

        bookings = []
        for booking in db.bookings:
            if booking.get_booker() == user_id:
                bookings.append({'id': booking.get_id(),
                                'datetime': booking.get_datetime(),
                                'park': booking.get_park().get_name(),
                                'facility': booking.get_facility().get_name(),
                                'cancelled': booking.get_cancelled()
                                })
        past_bookings = [booking for booking in bookings if booking['datetime'] < dt.now()]
        current_bookings = [booking for booking in bookings if booking['datetime'] >= dt.now()]
        return {'past_bookings': past_bookings, 'current_bookings': current_bookings}

    @staticmethod
    def cancel_booking(username, park, facility, datetime) -> Booking:
        """ Method to cancel a booking

        Args:
            username (string): The username of the user
            park (string): The name of the park
            facility (string): The name of the facility
            datetime (datetime): The datetime of the booking

        Returns:
            Booking: The booking that was cancelled
        """
        user_id = [profile.get_id() for profile in db.profiles if profile.get_username() == username][0]
        for booking in db.bookings:
            if booking.get_booker() == user_id and booking.get_park().get_name() == park and booking.get_facility().get_name() == facility and booking.get_datetime() == datetime:
                booking.set_cancelled(True)
                return booking
        return None

    @staticmethod
    def review_booking(username, park, facility, datetime, rating, comment) -> Review:
        """ Method to review a booking

        Args:
            username (string): The username of the user
            park (string): The name of the park
            facility (string): The name of the facility
            datetime (datetime): The datetime of the booking
            rating (int): The rating of the review
            comment (string): The comment of the review

        Returns:
            Review: The review that was added
        """
        user_id = [profile.get_id() for profile in db.profiles if profile.get_username() == username][0]
        for booking in db.bookings:
            if booking.get_booker().get_id() == user_id and booking.get_park().get_name() == park and booking.get_facility().get_name() == facility and booking.get_datetime() == datetime:
                review = Review(id=booking.get_id(), rating=rating, comment=comment)
                booking.set_reviews(review)
                return review
        return None