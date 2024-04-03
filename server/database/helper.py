from sqlalchemy import create_engine, inspect, Column, Integer, String, Float, DateTime, Boolean, ForeignKey
from sqlalchemy.orm import declarative_base, relationship

# Create SQLAlchemy engine
engine = create_engine('sqlite:///nparkbuddy.db')

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
    name = Column(String)
    park_id = Column(Integer, ForeignKey('parks.id'))
    park = relationship('Park', backref='facilities')
    type = Column(String)
    avg_rating = Column(Float)
    num_ratings = Column(Integer)
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
    datetime = Column(DateTime)
    cancelled = Column(Boolean)
    park_id = Column(Integer, ForeignKey('parks.id'))
    park = relationship('Park', backref='bookings')
    facility_id = Column(Integer, ForeignKey('facilities.id'))
    facility = relationship('Facility', backref='bookings')

    def __repr__(self):
        return f'<Booking {self.id} {self.booker} {self.datetime} {self.cancelled} {self.park_id} {self.facility_id}>'

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
    booking = relationship('Booking', backref='reviews')
    facility_id = Column(Integer, ForeignKey('facilities.id'))
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
                    print(f'Column: {column["name"]}, Type: {column["type"]}')
                keys = inspector.get_foreign_keys(table)
                for key in keys:
                    print(f'Foreign key: {key["referred_table"]}.{key["referred_columns"][0]}')
                print()
        elif option == '4':
            exit()
        else:
            print("Invalid option")
