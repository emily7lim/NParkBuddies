""" Module to represent a review of a booking"""
class Review():
    """ Class to represent a review of a booking
    """
    def __init__(self, rating=None, comment=None) -> None:
        self.set_rating(rating)
        self.set_comment(comment)

    def get_rating(self) -> int:
        """ Method to get the rating of the review

        Returns:
            int: rating of the review
        """
        return self.rating

    def set_rating(self, rating) -> None:
        """ Method to set the rating of the review

        Args:
            rating (int): rating of the review
        """
        self.rating = rating

    def get_comment(self) -> str:
        """ Method to get the comment of the review

        Returns:
            string: comment of the review
        """
        return self.comment

    def set_comment(self, comment) -> None:
        """ Method to set the comment of the review

        Args:
            comment (string): comment of the review
        """
        self.comment = comment