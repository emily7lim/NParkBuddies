from datetime import datetime as dt
from data_store import db
from classes.booking import Booking
from classes.review import Review
from database.database import Booking as BookingDB
from database.database import Review as ReviewDB

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

        if user_id is None:
            return {'error': 'User not found'}

        bookings = []
        for booking in db.bookings:
            if booking.get_booker() == user_id:
                bookings.append({'id': booking.get_id(),
                                'datetime': booking.get_datetime(),
                                'park': booking.get_park().get_name(),
                                'facility': booking.get_facility().get_name(),
                                'cancelled': booking.get_cancelled()
                                })
        # Sort bookings by datetime
        bookings = sorted(bookings, key=lambda x: x['datetime'], reverse=True)
        # Split bookings into past and current bookings
        past_bookings = [booking for booking in bookings if booking['datetime'] < dt.now() or booking['cancelled'] is True]
        current_bookings = [booking for booking in bookings if booking['datetime'] >= dt.now() and booking['cancelled'] is False]
        return {'past_bookings': past_bookings, 'current_bookings': current_bookings}

    @staticmethod
    def cancel_booking(username, park_name, facility_name, datetime) -> Booking:
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
        park = [park for park in db.parks if park.get_name() == park_name][0]
        facility = [facility for facility in park.get_facilities() if facility.get_name() == facility_name][0]

        if user_id is None:
            return {'error': 'User not found'}
        if park is None:
            return {'error': 'Park not found'}
        if facility is None:
            return {'error': 'Facility not found'}
        datetime = dt.strptime(datetime, '%a, %d %b %Y %H:%M:%S %Z')

        for booking in db.bookings:
            if booking.get_booker() == user_id and booking.get_park() == park and booking.get_facility() == facility and booking.get_datetime() == datetime:
                booking.set_cancelled(True)
                bookingDB = db.session.query(BookingDB).filter(BookingDB.id == booking.get_id()).first()
                bookingDB.cancelled = True
                db.session.merge(bookingDB)
                db.session.commit()
                return {'id': booking.get_id(),
                        'booker': booking.get_booker(),
                        'datetime': booking.get_datetime(),
                        'cancelled': booking.get_cancelled(),
                        'park': booking.get_park().get_name(),
                        'facility': booking.get_facility().get_name()}

        return {'error': 'Booking not found'}

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
        datetime = dt.strptime(datetime, '%a, %d %b %Y %H:%M:%S %Z')
        user_id = [profile.get_id() for profile in db.profiles if profile.get_username() == username][0]
        for booking in db.bookings:
            if booking.get_booker() == user_id and booking.get_park().get_name() == park and booking.get_facility().get_name() == facility and booking.get_datetime() == datetime:
                review = Review(id=booking.get_id(), rating=rating, comment=comment)
                booking.set_review(review)
                db.reviews.append(review)
                reviewDB = ReviewDB(id=review.get_id(), rating=rating, comment=comment)
                db.session.add(reviewDB)
                db.session.commit()
                return {'rating': review.get_rating(),
                        'comment': review.get_comment()}
        return {'error': 'Booking not found'}