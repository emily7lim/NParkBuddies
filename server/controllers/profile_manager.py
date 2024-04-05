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
                profile.username = new_username
                profile.set_username(new_username)
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
                profile.email = new_email
                profile.set_email(new_email)
                db.session.commit()
                return jsonify({'message': 'Email changed successfully'})

        return {'error': 'Email does not exist'}

    @staticmethod
    def deleteAccount(user_identifier):
        """
        Deletes a user's account with username or email, and all their bookings.
        """
        for profile in db.profiles:
            if profile.username == user_identifier or profile.email == user_identifier:
                # Delete all bookings made by the user
                for booking in db.bookings:
                    if booking.get_booker().get_username() == user_identifier:
                        BookingsManager.cancel_booking(user_identifier, booking.get_park().get_name(), booking.get_facility().get_name(), booking.get_datetime())

                # Delete the user's profile
                db.session.delete(profile)
                db.session.commit()
                return {'message': 'Account and all associated bookings deleted successfully'}

        return {'error': 'Username or email does not exist'}





