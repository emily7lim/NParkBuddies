import os, sys
sys.path.insert(1, "/".join(os.path.realpath(__file__).split('/')[0:-2]))
import profile
from sqlalchemy import create_engine, Column, Integer, String, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text

# Create a SQLAlchemy engine
engine = create_engine('sqlite:///server/database/user.db')

base = declarative_base()

class Profile(base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(String)
    email = Column(String)
    password = Column(String)

# Create tables in database
base.metadata.create_all(engine)

def test():
    Session = sessionmaker(bind=engine)
    session = Session()

    sql = text('INSERT into users (id, username, email, password) VALUES (:id, :username, :email, :password)')
    session.execute(sql, {'id': 1, 'username': "Admin", 'email': "test@email.com", 'password': "password123!"})
    session.commit()
    session.close()

def display_users():
    Session = sessionmaker(bind=engine)
    session = Session()

    sql = text('SELECT * FROM users')
    result = session.execute(sql)

    # Print results by users
    for row in result:
        print(row)

    session.close()

def delete_users():
    Session = sessionmaker(bind=engine)
    session = Session()

    sql = text('DELETE FROM users')
    session.execute(sql)

    session.commit()
    session.close()

if __name__ == '__main__':
    test()
    display_users()