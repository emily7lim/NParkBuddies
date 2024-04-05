from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
import logging
from classes.booking import Booking
from classes.facility import Facility, convert_to_enum
from classes.park import Park
from classes.profile import Profile
from classes.review import Review

# Configure SQLAlchemy to use the same logger as the rest of the application
sql_logger = logging.getLogger('sqlalchemy.engine')
sql_logger.setLevel(logging.INFO)
sql_logger.addHandler(logging.StreamHandler())
sql_logger.addHandler(logging.FileHandler('server.log'))

# Create a SQLAlchemy engine
engine = create_engine('sqlite:///database/nparkbuddy.db', echo=True)

class Database:
    """ Class to represent the database
    """
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Database, cls).__new__(cls)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'initialized'):
            self.initialized = True
            self.Session = sessionmaker(bind=engine)
            self.session = self.Session()
            self.parks = []
            self.facilities = []
            self.bookings = []
            self.reviews = []
            self.profiles = []

    def init_db(self):
        """ Method to create all objects
        """
        from server import logger # Import logger here to prevent circular import
        # Query parks table from the database and create a list of Park objects
        sql = text('SELECT * FROM parks')
        result = self.session.execute(sql)
        for row in result:
            park = Park(id=row[0], name=row[1], latitude=row[2], longitude=row[3])
            self.parks.append(park)

        sql = text('SELECT * FROM facilities')
        result = self.session.execute(sql)
        for row in result:
            park_id = row[2]
            park = next((park for park in self.parks if park.get_id() == park_id), None)
            if park:
                facility = Facility(id=row[0], name=row[1], park=park, type=convert_to_enum(row[3]), avg_rating=row[4], num_ratings=row[5])
                park.set_facilities(facility)
                self.facilities.append(facility)
            else:
                logger.error(f'Park with id {park_id} not found')

        sql = text('SELECT * FROM profiles')
        result = self.session.execute(sql)
        for row in result:
            profile = Profile(id=row[0], username=row[1], email=row[2], password=row[3])
            self.profiles.append(profile)

        sql = text('SELECT * FROM bookings')
        result = self.session.execute(sql)
        for row in result:
            booker_id = row[1]
            booker = next((profile for profile in self.profiles if profile.get_id() == booker_id), None)
            cancelled = bool(row[3]) and row[3] != b'\x00'
            park_id = row[4]
            park = next((park for park in self.parks if park.get_id() == park_id), None)
            facility_id = row[5]
            facility = next((facility for facility in self.facilities if facility.get_id() == facility_id), None)
            booking = Booking(id=row[0], booker=booker, datetime=row[2], cancelled=cancelled, park=park, facility=facility)
            booker.set_bookings(booking)
            self.bookings.append(booking)

        sql = text('SELECT * FROM reviews')
        result = self.session.execute(sql)
        for row in result:
            booking_id = row[3]
            booking = next((booking for booking in self.bookings if booking.get_id() == booking_id), None)
            facility_id = row[4]
            facility = next((facility for facility in self.facilities if facility.get_id() == facility_id), None)
            review = Review(id=booking_id, rating=row[1], comment=row[2])
            booking.set_review(review)
            facility.set_reviews(review)
            self.reviews.append(review)

        logger.info('Database initialized in data_store.py')

    def get_park_by_id(self, park_id) -> Park:
        """ Method to get a park by id
        Args:
            park_id (int): id of the park
        Returns:
            Park: park object
        """
        return next((park for park in self.parks if park.get_id() == park_id), None)

    def get_facility_by_id(self, facility_id) -> Facility:
        """ Method to get a facility by id
        Args:
            facility_id (int): id of the facility
        Returns:
            Facility: facility object
        """
        return next((facility for facility in self.facilities if facility.get_id() == facility_id), None)

    def get_user_by_id(self, user_id) -> Profile:
        """ Method to get a user by id
        Args:
            user_id (int): id of the user
        Returns:
            Profile: user object
        """
        return next((profile for profile in self.profiles if profile.get_id() == user_id), None)

    def get_booking_by_id(self, booking_id) -> Booking:
        """ Method to get a booking by id
        Args:
            booking_id (int): id of the booking
        Returns:
            Booking: booking object
        """
        return next((booking for booking in self.bookings if booking.get_id() == booking_id), None)

    def get_review_by_id(self, review_id) -> Review:
        """ Method to get a review by id
        Args:
            review_id (int): id of the review
        Returns:
            Review: review object
        """
        return next((review for review in self.reviews if review.get_id() == review_id), None)

    def write_to_db(self, obj):
        """ Method to write an object to the database
        Args:
            obj (object): object to write
        """
        from database.helper import Park, Facility, Profile, Booking, Review
        self.session.add(obj)
        self.session.commit()


db = Database()