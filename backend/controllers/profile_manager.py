# Description: This file contains the controller for profile management, including deleting, updating users and logout.

from flask import Flask, request, jsonify
import os, sys
#sys.path.insert(1, "/".join(os.path.realpath(__file__).split('/')[0:-2]))
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
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
    def change_username(old_username, new_username):
        """
        Changes the username for a user.
        """
        for profile in db.profiles:
            if profile.get_username() == new_username:
                return {'error': 'Username already taken'}

        for profile in db.profiles:
            if profile.get_username() == old_username:
                # Use the set_username method to update the username
                profile.set_username(new_username)

                # Update the existing ProfileDB instance with the updated username
                profileDB = db.session.query(ProfileDB).filter(ProfileDB.id == profile.id).first()
                profileDB.username = new_username
                db.session.commit()
                return {'message': 'Username changed successfully'}

        return {'error': 'Username does not exist'}

    @staticmethod
    def change_email(old_email, new_email):
        """
        Changes the email for a user.
        """
        for profile in db.profiles:
            if profile.get_email() == new_email:
                return {'error': 'Email already taken'}

        for profile in db.profiles:
            if profile.get_email() == old_email:
                # Use the set_email method to update the email
                profile.set_email(new_email)

                # Update the existing ProfileDB instance with the updated email
                profileDB = db.session.query(ProfileDB).filter(ProfileDB.id == profile.id).first()
                profileDB.email = new_email
                db.session.commit()
                return {'message': 'Email changed successfully'}

        return {'error': 'Email does not exist'}
