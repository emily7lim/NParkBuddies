""" Module to represent a facility """

from enum import Enum

class FacilityType(Enum):
    """ Enum to represent the type of facility

    Args:
        Enum ([type]): [description]
    """
    BBQ_PIT = 'BBQ Pit'
    CAMPSITE = 'Campsite'
    VENUES = 'Venues'

class Facility:
    """ Class to represent a facility
    """
    def __init__(self):
        self.id = None
        self.park = None
        self.type = None
        self.avg_rating = None
        self.num_ratings = None
        self.reviews = None

    def get_id(self):
        """ Method to get the id of the facility

        Returns:
            int: id of the facility
        """
        return self.id

    def set_id(self, id):
        """ Method to set the id of the facility

        Args:
            id (int): id of the facility
        """
        self.id = id

    def get_park(self):
        """ Method to get the park of the facility

        Returns:
            Park: park of the facility
        """
        return self.park

    def set_park(self, park):
        """ Method to set the park of the facility

        Args:
            park (Park): park of the facility

        Raises:
            ValueError: [description]
        """
        if isinstance(park, park.Park):
            self.park = park
        else:
            raise ValueError('Invalid park')

    def get_type(self):
        """ Method to get the type of the facility

        Returns:
            FacilityType: type of the facility
        """
        return self.type

    def set_type(self, park_type):
        """ Method to set the type of the facility

        Args:
            park_type (FacilityType): type of the facility

        Raises:
            ValueError: [description]
        """
        if isinstance(park_type, FacilityType):
            self.type = park_type
        else:
            raise ValueError('Invalid park type')

    def get_avg_rating(self):
        """ Method to get the average rating of the facility

        Returns:
            float: average rating of the facility
        """
        return self.avg_rating

    def set_avg_rating(self, avg_rating):
        """ Method to set the average rating of the facility

        Args:
            avg_rating (float): average rating of the facility
        """
        self.avg_rating = avg_rating

    def get_num_ratings(self):
        """ Method to get the number of ratings of the facility

        Returns:
            int: number of ratings of the facility
        """
        return self.num_ratings

    def set_num_ratings(self, num_ratings):
        """ Method to set the number of ratings of the facility

        Args:
            num_ratings (int): number of ratings of the facility
        """
        self.num_ratings = num_ratings

    def get_reviews(self):
        """ Method to get the reviews of the facility

        Returns:
            string: reviews of the facility
        """
        return self.reviews

    def set_reviews(self, reviews):
        """ Method to set the reviews of the facility

        Args:
            reviews (string): reviews of the facility
        """
        self.reviews = reviews
