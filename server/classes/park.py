""" Module to represent a park"""

from server.classes.facility import Facility

class Park:
    """ Class to represent a park
    """
    def __init__(self):
        self.name = None
        self.latitude = None
        self.longitude = None
        self.facilities = None

    def get_name(self):
        """ Method to get the name of the park

        Returns:
            string: name of the park
        """
        return self.name

    def set_name(self, name):
        """ Method to set the name of the park

        Args:
            name (string): name of the park
        """
        self.name = name

    def get_latitude(self):
        """ Method to get the latitude of the park

        Returns:
            float: latitude of the park
        """
        return self.latitude

    def set_latitude(self, latitude):
        """ Method to set the latitude of the park

        Args:
            latitude (float): latitude of the park
        """
        self.latitude = latitude

    def get_longitude(self):
        """ Method to get the longitude of the park

        Returns:
            float: longitude of the park
        """
        return self.longitude

    def set_longitude(self, longitude):
        """ Method to set the longitude of the park

        Args:
            longitude (float): longitude of the park
        """
        self.longitude = longitude

    def get_facilities(self):
        """ Method to get the facilities of the park

        Returns:
            list: facilities of the park
        """
        return self.facilities

    def set_facilities(self, *facilities):
        """ Method to set the facilities of the park

        Args:
            facilities (tuple): facilities of the park

        Raises:
            ValueError: Invalid facility
        """
        for facil in facilities:
            if isinstance(facil, Facility):
                self.facilities.append(facil)
            else:
                raise ValueError('Invalid facility')
