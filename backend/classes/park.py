""" Module to represent a park"""
class Park:
    """ Class to represent a park
    """
    def __init__(self, id=None, name=None, latitude=None, longitude=None) -> None:
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.facilities = []

    def get_id(self) -> int:
        """ Method to get the id of the park

        Returns:
            int: id of the park
        """
        return self.id

    def set_id(self, id) -> None:
        """ Method to set the id of the park

        Args:
            id (int): id of the park
        """
        self.id = id

    def get_name(self) -> str:
        """ Method to get the name of the park

        Returns:
            string: name of the park
        """
        return self.name

    def set_name(self, name) -> None:
        """ Method to set the name of the park

        Args:
            name (string): name of the park
        """
        self.name = name

    def get_latitude(self) -> float:
        """ Method to get the latitude of the park

        Returns:
            float: latitude of the park
        """
        return self.latitude

    def set_latitude(self, latitude) -> None:
        """ Method to set the latitude of the park

        Args:
            latitude (float): latitude of the park
        """
        self.latitude = latitude

    def get_longitude(self) -> float:
        """ Method to get the longitude of the park

        Returns:
            float: longitude of the park
        """
        return self.longitude

    def set_longitude(self, longitude) -> None:
        """ Method to set the longitude of the park

        Args:
            longitude (float): longitude of the park
        """
        self.longitude = longitude

    def get_facilities(self) -> list:
        """ Method to get the facilities of the park

        Returns:
            list: facilities of the park
        """
        return self.facilities

    def set_facilities(self, *facilities) -> None:
        """ Method to set the facilities of the park

        Args:
            facilities (tuple): facilities of the park

        Raises:
            ValueError: Invalid facility
        """
        from classes.facility import Facility
        for facil in facilities:
            if isinstance(facil, Facility):
                self.facilities.append(facil)
            else:
                raise ValueError('Invalid facility')
