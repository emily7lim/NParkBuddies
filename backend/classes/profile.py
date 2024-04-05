""" Module to represent a user profile"""
class Profile:
    """ Class to represent a user profile
    """
    def __init__(self, id=None, username=None, email=None, password=None) -> None:
        self.set_id(id)
        self.set_username(username)
        self.set_email(email)
        self.bookings = []
        self.set_password(password)

    def get_id(self) -> int:
        """ Method to get the id of the profile

        Returns:
            int: id of the profile
        """
        return self.id

    def set_id(self, id_no) -> None:
        """ Method to set the id of the profile

        Args:
            id (int): id of the profile
        """
        self.id = id_no

    def get_username(self) -> str:
        """ Method to get the username of the profile

        Returns:
            string: username of the profile
        """
        return self.username

    def set_username(self, username) -> None:
        """ Method to set the username of the profile

        Args:
            username (string): username of the profile
        """
        self.username = username

    def get_email(self) -> str:
        """ Method to get the email of the profile

        Returns:
            string: email of the profile
        """
        return self.email

    def set_email(self, email) -> None:
        """ Method to set the email of the profile

        Args:
            email (string): email of the profile
        """
        self.email = email

    def get_bookings(self) -> list:
        """ Method to get the bookings of the profile

        Returns:
            list: bookings of the profile
        """
        return self.bookings

    def set_bookings(self, *new_booking) -> None:
        """ Method to set the bookings of the profile

        Args:
            *new_booking (tuple): tuple of bookings of the profile

        Raises:
            ValueError: "Invalid booking"
        """
        from classes.booking import Booking
        for booking_item in new_booking:
            if isinstance(booking_item, Booking):
                self.bookings.append(booking_item)
            else:
                raise ValueError('Invalid booking')

    def get_password(self) -> str:
        """ Method to get the password of the profile

        Returns:
            string: password of the profile
        """
        return self.password

    def set_password(self, password) -> None:
        """ Method to set the password of the profile

        Args:
            password (string): password of the profile
        """
        self.password = password

    def validate(self, username, password) -> bool:
        """ Method to validate the profile

        Args:
            username (string): username of the profile
            password (string): password of the profile

        Returns:
            bool: True if the profile is valid, False otherwise
        """
        if self.get_username() == username and self.get_password() == password:
            return True
        else:
            return False
