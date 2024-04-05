from data_store import db

class FacilityManager:
    """ Class to manage facility page

    Returns:
        FacilityManager: A class to manage facility page
    """

    @staticmethod
    def view_facilities() -> list:
        """ Method to view all facilities

        Returns:
            list: A list of all facilities
        """
        facilities = []
        for facility in db.facilities:
            facilities.append({'id': facility.get_id(),
                               'name': facility.get_name(),
                               'park': facility.get_park().get_name(),
                               'type': facility.get_type().value,
                               'avg_rating': facility.get_avg_rating(),
                               'num_ratings': facility.get_num_ratings()
                               })
        return facilities

    @staticmethod
    def filter_facilities(facility_type) -> list:
        """ Method to filter facilities by type

        Args:
            type (string): The type of the facility

        Returns:
            list: A list of all facilities of the given type
        """
        facilities = []
        for facility in db.facilities:
            if facility.get_type() == type:
                facilities.append({'id': facility.get_id(),
                                   'name': facility.get_name(),
                                   'park': facility.get_park().get_name(),
                                   'type': facility.get_type(),
                                   'avg_rating': facility.get_avg_rating(),
                                   'num_ratings': facility.get_num_ratings()
                                   })
        return facilities

    @staticmethod
    def view_reviews(park_name, facility_name) -> list:
        """ Method to view reviews of a facility

        Args:
            park_name (string): The name of the park
            facility_name (string): The name of the facility

        Returns:
            list: A list of reviews of the facility
        """
        reviews = []
        # Reviews does not have park and facility infomation, need to query booking first
        for booking in db.bookings:
            if booking.get_park().get_name() == park_name and booking.get_facility().get_name() == facility_name:
                booking_id = booking.get_id()
                for review in db.reviews:
                    if review.get_id() == booking_id:
                        reviews.append({'rating': review.get_rating(),
                                        'comment': review.get_comment()
                                        })
        return reviews