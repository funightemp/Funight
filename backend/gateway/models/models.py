from sqlalchemy import Column, Integer, DateTime, String, Text, ForeignKey, Numeric, Enum, TIMESTAMP, func
from sqlalchemy.orm import relationship
from database.connection import base
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer,primary_key=True, index = True )
    username = Column(String, unique=True, index=True)
    password = Column(String)
    
class Event(Base):
    __tablename__ = 'events'
    
    id = Column(Integer, primary_key=True, index = True)
    name = Column(String, index=True)
    description = Column(String)
    start_time = Column(DateTime)
    end_time = Column(DateTime)
    
class Reservation(Base):
    __tablename__ = 'reservations'
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    event_id = Column(Integer, ForeignKey('event.id'))
    reservation_time = Column(DateTime)
    
    user = relationship('User', back_populates='reservations')
    event = relationship('Event', back_populates='reservations') 
    
    
    


