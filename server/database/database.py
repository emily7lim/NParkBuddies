""" Module to define the database models for the parks and facilities"""
from flask_sqlalchemy import SQLAlchemy
from flask import Flask
from model.facility import FacilityType

# Create Flask application instance
app = Flask(__name__)

# Configure databases
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///parks.db'
park_db = SQLAlchemy(app)

app.config['SQLALCHEMY_BINDS'] = {'facilities' : 'sqlite:///facilities.db'}

class Facility(park_db.Model):
    """ Class to represent a facility

    Args:
        park_db (_type_): _description_

    Returns:
        _type_: _description_
    """
    __bind_key__ = 'facilities'
    __tablename__ = 'facilities'

    id = park_db.Column(park_db.Integer, primary_key=True)
    park_id = park_db.Column(park_db.Integer, park_db.ForeignKey('parks.id'))
    type = park_db.Column(park_db.Enum(FacilityType))
    avg_rating = park_db.Column(park_db.Float)
    num_ratings = park_db.Column(park_db.Integer)
    reviews = park_db.Column(park_db.String)

    def __repr__(self):
        return f'<Facility {self.id}>'

class Park(park_db.Model):
    """ Class to represent a park

    Args:
        park_db (_type_): _description_

    Returns:
        _type_: _description_
    """
    __tablename__ = 'parks'

    id = park_db.Column(park_db.Integer, primary_key=True)
    name = park_db.Column(park_db.String)
    latitude = park_db.Column(park_db.Float)
    longitude = park_db.Column(park_db.Float)
    facilities = park_db.relationship('Facility', backref='park', lazy=True)

    def __repr__(self):
        return f'<Park {self.id}>'

def init_db():
    """ Function to initialize the database"""
    park_db.create_all()
