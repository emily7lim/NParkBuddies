from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, declarative_base
import logging
from datetime import datetime as dt
from classes.booking import Booking
from classes.facility import Facility, convert_to_enum
from classes.park import Park
from classes.profile import Profile
from classes.review import Review
from database.database import Park as ParkDB
from database.database import Facility as FacilityDB
from database.database import Profile as ProfileDB
from database.database import Booking as BookingDB
from database.database import Review as ReviewDB
from logger import console_handler, file_handler

# Configure SQLAlchemy to use the same logger as the rest of the application
sql_logger = logging.getLogger('sqlalchemy.engine')
sql_logger.setLevel(logging.INFO)
sql_logger.addHandler(console_handler)
sql_logger.addHandler(file_handler)

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
                raise ValueError('Park not found for facility')

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
            datetime_str = row[2].split('.')[0]  # Split at dot and take only the part before the dot
            datetime = dt.strptime(datetime_str, '%Y-%m-%d %H:%M:%S')
            if row[3] == "b'\\x01'":
                cancelled = True
            else:
                cancelled = False
            park_id = row[4]
            park = next((park for park in self.parks if park.get_id() == park_id), None)
            facility_id = row[5]
            facility = next((facility for facility in self.facilities if facility.get_id() == facility_id), None)
            booking = Booking(id=row[0], booker=booker_id, datetime=datetime, cancelled=cancelled, park=park, facility=facility)
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

        self.session.commit()
        #self.write_to_db()

        sql_logger.info('Database initialized')

    def get_park_by_id(self, park_id):
        """ Method to get park by id

        Args:
            park_id (int): The id of the park

        Returns:
            Park: The park object
        """
        return self.session.query(ParkDB).filter(ParkDB.id == park_id).first()

    def get_facility_by_id(self, facility_id):
        """ Method to get facility by id

        Args:
            facility_id (int): The id of the facility

        Returns:
            Facility: The facility object
        """
        return self.session.query(FacilityDB).filter(FacilityDB.id == facility_id).first()

    def get_user_by_id(self, user_id):
        """ Method to get user by id

        Args:
            user_id (int): The id of the user

        Returns:
            Profile: The user object
        """
        return self.session.query(ProfileDB).filter(ProfileDB.id == user_id).first()

    def get_booking_by_id(self, booking_id):
        """ Method to get booking by id

        Args:
            booking_id (int): The id of the booking

        Returns:
            Booking: The booking object
        """
        return self.session.query(BookingDB).filter(BookingDB.id == booking_id).first()

    def get_review_by_id(self, review_id):
        """ Method to get review by id

        Args:
            review_id (int): The id of the review

        Returns:
            Review: The review object
        """
        return self.session.query(ReviewDB).filter(ReviewDB.id == review_id).first()

    def create_booking(self, bookingDB):
        """ Method to store booking into DB

        Args:
            bookingDB (BookingDB): booking object
        """
        print(bookingDB.id, bookingDB.booker, bookingDB.datetime, bookingDB.cancelled, bookingDB.park_id, bookingDB.facility_id)
        self.session.add(bookingDB)
        self.session.commit()

    def create_profile(self, profileDB):
        """ Method to store profile into DB

        Args:
            profileDB (ProfileDB): profile object
        """
        self.session.add(profileDB)
        self.session.commit()

    def write_to_db(self):
        """ Method to write all objects to the database"""
        for park_obj in self.parks:
            park_model = ParkDB(id=park_obj.id, name=park_obj.name, latitude=park_obj.latitude, longitude=park_obj.longitude)
            self.session.merge(park_model)

        for facility_obj in self.facilities:
            park_id = facility_obj.park.get_id() if facility_obj.park else None
            facility_model = FacilityDB(id=facility_obj.id, name=facility_obj.name, park_id=park_id, type=facility_obj.type.value, avg_rating=facility_obj.avg_rating, num_ratings=facility_obj.num_ratings)
            self.session.merge(facility_model)

        for profile_obj in self.profiles:
            profile_model = ProfileDB(id=profile_obj.id, username=profile_obj.username, email=profile_obj.email, password=profile_obj.password)
            self.session.merge(profile_model)

        for booking_obj in self.bookings:
            booker_id = booking_obj.booker.get_id() if booking_obj.booker else None
            park_id = booking_obj.park.get_id() if booking_obj.park else None
            facility_id = booking_obj.facility.get_id() if booking_obj.facility else None
            booking_model = BookingDB(id=booking_obj.id, booker_id=booker_id, datetime=booking_obj.datetime, cancelled=booking_obj.cancelled, park_id=park_id, facility_id=facility_id)
            self.session.merge(booking_model)

        for review_obj in self.reviews:
            booking_id = review_obj.id
            # Get facility id from booking
            facility_id = next((booking.facility.get_id() for booking in self.bookings if booking.get_id() == booking_id), None)
            review_model = ReviewDB(id=review_obj.id, rating=review_obj.rating, comment=review_obj.comment, booking_id=booking_id, facility_id=facility_id)
            self.session.merge(review_model)

        self.session.commit()

db = Database()