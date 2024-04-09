# Description: This file contains the controller for login management, including creating, login, and change user password

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
from database.database import Profile as ProfileDB
from sqlalchemy import or_

#class LoginManager(db.Model):

class LoginManager:
    """ Class for managing login page data

    Returns:
       LoginManager: A class to manage login page data
    """

    @staticmethod
    def create_account(username, email, password):
        """
        Creates a new user profile with username, email, password.

        """
        print("username email password", username, email, password)


        for profile in db.profiles:
            # Check if user has signed up before with same email
            if profile.get_email() == email:
                return {'error': 'You already have an account. Please proceed to login.'}
            elif profile.get_username() == username:
                return {'error': 'Username already taken'}

        # Create user_profile object and save it
        id = len(db.profiles) + 1
        new_profile = Profile(id=id,username=username, email=email, password=password)
        db.profiles.append(new_profile)
        profileDB = ProfileDB(id=id, username=username, email=email, password=password)
        db.session.add(profileDB)
        db.session.commit()

        return {'id': new_profile.get_id(),
                'username': new_profile.get_username(),
                'email': new_profile.get_email(),
                'password': new_profile.get_password(),
                }

    @staticmethod
    def login(user_identifier, password):
        """
        Logs in a user with username or email, password.
        """
        for profile in db.profiles:
            if profile.get_username() == user_identifier or profile.get_email() == user_identifier:
                if profile.get_password() == password:
                    return {'message': 'Login successful'}
                else:
                    return {'error': 'Invalid credentials. Please try again'}

        return {'error': 'Invalid credentials. Please try again'}

    @staticmethod
    def change_password(user_identifier, new_password):
        """
        Changes the password for a user with username or email.
        """
        for profile in db.profiles:
            if profile.get_username() == user_identifier or profile.get_email() == user_identifier:
               # Use the set_password method to update the password
               profile.set_password(new_password)

               # Update the existing ProfileDB instance with the updated password
               profileDB = db.session.query(ProfileDB).filter(ProfileDB.id == profile.id).first()
               profileDB.password = new_password
               db.session.merge(profileDB)
               db.session.commit()
               return {'message': 'Password changed successfully'}

        return {'error': 'Username or email not registered'}

