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
    def __init__(self, id=None, name=None, park=None, type=None, avg_rating=None, num_ratings=None) -> None:
        self.set_id(id)
        self.set_name(name)
        self.set_park(park)
        self.set_type(type)
        self.set_avg_rating(avg_rating)
        self.set_num_ratings(num_ratings)
        self.reviews = []

    def get_id(self) -> int:
        """ Method to get the id of the facility

        Returns:
            int: id of the facility
        """
        return self.id

    def set_id(self, id) -> None:
        """ Method to set the id of the facility

        Args:
            id (int): id of the facility
        """
        self.id = id

    def get_name(self) -> str:
        """ Method to get the name of the facility

        Returns:
            string: name of the facility
        """
        return self.name

    def set_name(self, name) -> None:
        """ Method to set the name of the facility

        Args:
            name (string): name of the facility
        """
        self.name = name

    from classes.park import Park
    def get_park(self) -> Park:
        """ Method to get the park of the facility

        Returns:
            Park: park of the facility
        """
        return self.park

    def set_park(self, park) -> None:
        """ Method to set the park of the facility

        Args:
            park (Park): park of the facility

        Raises:
            ValueError: [description]
        """
        from classes.park import Park
        if isinstance(park, Park):
            self.park = park
        else:
            raise ValueError('Invalid park')

    def get_type(self) -> FacilityType:
        """ Method to get the type of the facility

        Returns:
            FacilityType: type of the facility
        """
        return self.type

    def set_type(self, park_type) -> None:
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

    def get_avg_rating(self) -> float:
        """ Method to get the average rating of the facility

        Returns:
            float: average rating of the facility
        """
        return self.avg_rating

    def set_avg_rating(self, avg_rating) -> None:
        """ Method to set the average rating of the facility

        Args:
            avg_rating (float): average rating of the facility
        """
        self.avg_rating = avg_rating

    def get_num_ratings(self) -> int:
        """ Method to get the number of ratings of the facility

        Returns:
            int: number of ratings of the facility
        """
        return self.num_ratings

    def set_num_ratings(self, num_ratings) -> None:
        """ Method to set the number of ratings of the facility

        Args:
            num_ratings (int): number of ratings of the facility
        """
        self.num_ratings = num_ratings

    def get_reviews(self) -> list:
        """ Method to get the reviews of the facility

        Returns:
            Review: reviews of the facility
        """

        return self.reviews

    def set_reviews(self, *reviews) -> None:
        """ Method to set the reviews of the facility

        Args:
            reviews (Reviews): reviews of the facility
        """
        from classes.review import Review
        for review in reviews:
            if isinstance(review, Review):
                self.reviews.append(review)
            else:
                raise ValueError('Invalid reviews')

def convert_to_enum(value) -> FacilityType:
    """ Method to convert a string to an enum
    Args:
        value (string): string to convert
    Returns:
        FacilityType: enum value
    """
    if value == 'BBQ Pit':
        return FacilityType.BBQ_PIT
    elif value == 'Campsite':
        return FacilityType.CAMPSITE
    elif value == 'Venues':
        return FacilityType.VENUES
