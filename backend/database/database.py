from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, Boolean, ForeignKey
from sqlalchemy.orm import declarative_base, relationship

# Create SQLAlchemy engine
engine = create_engine('sqlite:///nparkbuddy.db')

Base = declarative_base()

class Park(Base):
    """ Class to represent a park """
    __tablename__ = 'parks'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    latitude = Column(Float)
    longitude = Column(Float)
    facilities = relationship('Facility', cascade='all, delete-orphan', back_populates='park')

    def __repr__(self):
        return f'<Park {self.id} {self.name} {self.latitude} {self.longitude} {self.facilities}>'

class Facility(Base):
    """ Class to represent a facility """
    __tablename__ = 'facilities'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    park_id = Column(Integer, ForeignKey('parks.id'))
    park = relationship('Park', back_populates='facilities')
    type = Column(String)
    avg_rating = Column(Float)
    num_ratings = Column(Integer)
    reviews = relationship('Review', cascade='all, delete-orphan', back_populates='facility')

    def __repr__(self):
        return f'<Facility {self.id} {self.park} {self.type} {self.avg_rating} {self.num_ratings} {self.reviews}>'

class Booking(Base):
    """ Class to represent a booking """
    __tablename__ = 'bookings'
    id = Column(Integer, primary_key=True)
    booker_id = Column(Integer, ForeignKey('profiles.id'))
    booker = relationship('Profile', back_populates='bookings')
    datetime = Column(DateTime)
    cancelled = Column(Boolean)
    park_id = Column(Integer, ForeignKey('parks.id'))
    park = relationship('Park')
    facility_id = Column(Integer, ForeignKey('facilities.id'))
    facility = relationship('Facility')

    def __repr__(self):
        return f'<Booking {self.id} {self.booker} {self.datetime} {self.cancelled} {self.park_id} {self.facility_id}>'

class Review(Base):
    """ Class to represent a review """
    __tablename__ = 'reviews'
    id = Column(Integer, primary_key=True)
    rating = Column(Integer)
    comment = Column(String)
    booking_id = Column(Integer, ForeignKey('bookings.id'))
    booking = relationship('Booking')
    facility_id = Column(Integer, ForeignKey('facilities.id'))
    facility = relationship('Facility', back_populates='reviews')

    def __repr__(self):
        return f'<Review {self.id} {self.rating} {self.comment} {self.booking}>'

class Profile(Base):
    """ Class to represent a profile """
    __tablename__ = 'profiles'
    id = Column(Integer, primary_key=True)
    username = Column(String)
    email = Column(String)
    bookings = relationship('Booking', cascade='all, delete-orphan', back_populates='booker')
    password = Column(String)

    def __repr__(self):
        return f'<Profile {self.id} {self.username} {self.email} {self.bookings} {self.password}>'

# Create all tables in the database
Base.metadata.create_all(engine)


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
