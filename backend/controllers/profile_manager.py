# Description: This file contains the controller for profile management, including deleting, updating users and logout.

from flask import Flask, request, jsonify
import os, sys
#sys.path.insert(1, "/".join(os.path.realpath(__file__).split('/')[0:-2]))
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import profile
from flask_sqlalchemy import SQLAlchemy
import re
from data_store import db
from classes.profile import Profile
from classes.booking import Booking
from classes.park import Park
from classes.facility import Facility
from controllers.bookings_manager import BookingsManager
from database.database import Profile as ProfileDB
from database.database import Booking as BookingDB

class ProfileManager:
    """ Class for managing profile data

    Returns:
        ProfileManager: A class to manage profile data
    """
    @staticmethod
    def changeUsername(old_username, new_username):
        """
        Changes the username for a user.
        """
        for profile in db.profiles:
           if profile.username == old_username:
              # Use the set_username method to update the username
              profile.set_username(new_username)
            
              # Update the existing ProfileDB instance with the updated username
              profileDB = db.session.query(ProfileDB).filter(ProfileDB.id == profile.id).first()
              profileDB.username = new_username
              db.session.commit()
              return {'message': 'Username changed successfully'}

        return {'error': 'Username does not exist'}

    @staticmethod
    def changeEmail(old_email, new_email):
        """
        Changes the email for a user.
        """
        for profile in db.profiles:
           if profile.email == old_email:
              # Update the existing ProfileDB instance with the updated email
              profileDB = db.session.query(ProfileDB).filter(ProfileDB.id == profile.id).first()
              profileDB.email = new_email
              db.session.commit()
              return {'message': 'Email changed successfully'}

        return {'error': 'Email does not exist'}

    @staticmethod
    def deleteAccount(user_identifier):
        """
        Deletes a user's account with username or email, and all their bookings.
        """
        # Query the user's profile
        profileDB = db.session.query(ProfileDB).filter((ProfileDB.username == user_identifier) | (ProfileDB.email == user_identifier)).first()

        if profileDB:
           # Query all bookings made by the user
           bookings = db.session.query(BookingDB).filter(BookingDB.booker_id == profileDB.id).all()

           # Cancel all bookings made by the user
           for booking in bookings:
               db.session.delete(booking)

           # Delete the user's profile
           db.session.delete(profileDB)
           db.session.commit()
           return {'message': 'Account and all associated bookings deleted successfully'}

        return {'error': 'Username or email does not exist'}




