from sqlalchemy import create_engine, inspect, Column, Integer, String, Float, DateTime, Boolean, ForeignKey
from sqlalchemy.orm import sessionmaker, declarative_base, relationship
from server.classes.park import Park
from server.classes.facility import Facility, FacilityType
from server.classes.review import Review
from server.classes.booking import Booking
from server.classes.profile import Profile

# Create SQLAlchemy engine
engine = create_engine('sqlite:///server/database/nparkbuddy.db', echo=True)

base = declarative_base()

class Park(base):
    """ Class to represent a park

    Args:
        base (declarative_base): Base class for declarative class definitions
    """
    __tablename__ = 'parks'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    latitude = Column(Float)
    longitude = Column(Float)
    facilities = relationship('Facility', backref='park')

    def __repr__(self):
        return f'<Park {self.id} {self.name} {self.latitude} {self.longitude} {self.facilities}>'

class Facility(base):
    """ Class to represent a facility

    Args:
        base (declarative_base): Base class for declarative class definitions
    """
    __tablename__ = 'facilities'

    id = Column(Integer, primary_key=True)
    park_id = Column(Integer, ForeignKey('parks.id'))
    park = relationship('Park', backref='facilities')
    type = Column(String)
    avg_rating = Column(Float)
    num_ratings = Column(Integer)
    review_id = Column(Integer, ForeignKey('reviews.id'))
    reviews = relationship('Review', backref='facility')

    def __repr__(self):
        return f'<Facility {self.id} {self.park} {self.type} {self.avg_rating} {self.num_ratings} {self.reviews}>'

class Booking(base):
    """ Class to represent a booking

    Args:
        base (declarative_base): Base class for declarative class definitions
    """
    __tablename__ = 'bookings'

    id = Column(Integer, primary_key=True)
    booker_id = Column(Integer, ForeignKey('profiles.id'))
    booker = relationship('Profile', backref='bookings')
    date = Column(DateTime)
    time = Column(DateTime)
    cancelled = Column(Boolean)
    park = Column(Integer, ForeignKey('parks.id'))
    facility = Column(Integer, ForeignKey('facilities.id'))

    def __repr__(self):
        return f'<Booking {self.id} {self.booker} {self.date} {self.time} {self.cancelled} {self.park} {self.facility}>'

class Review(base):
    """ Class to represent a review

    Args:
        base (declarative_base): Base class for declarative class definitions
    """
    __tablename__ = 'reviews'

    id = Column(Integer, primary_key=True)
    rating = Column(Integer)
    comment = Column(String)
    booking_id = Column(Integer, ForeignKey('bookings.id'))
    facility = relationship('Facility', backref='reviews')

    def __repr__(self):
        return f'<Review {self.id} {self.rating} {self.comment} {self.booking}>'

class Profile(base):
    """ Class to represent a profile

    Args:
        base (declarative_base): Base class for declarative class definitions
    """
    __tablename__ = 'profiles'

    id = Column(Integer, primary_key=True)
    username = Column(String)
    email = Column(String)
    bookings = relationship('Booking', backref='profile')
    password = Column(String)

    def __repr__(self):
        return f'<Profile {self.id} {self.username} {self.email} {self.bookings} {self.password}>'

if __name__ == "__main__":
    while True:
        option = input("Select option:"
                   "\n1. Create tables"
                   "\n2. Drop tables"
                   "\n3. Check tables"
                   "\n4. Exit\n")
        if option == '1':
            base.metadata.create_all(engine)
        elif option == '2':
            base.metadata.drop_all(engine)
        elif option == '3':
            inspector = inspect(engine)
            for table in inspector.get_table_names():
                print(f'Table: {table}')
                for column in inspector.get_columns(table):
                    print(f'Column: {column["name"]}')
                print()
        elif option == '4':
            exit()
        else:
            print("Invalid option")
