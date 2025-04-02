from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

class UserBase(BaseModel):
    username : str
    
class UserCreate(UserBase):
    password : str
    
class User(UserBase):
    id: int
    
    class Config:
        orm_mode = True
        
class EventBase(EventBase):
    id : int
    
    class Config:
        orm_mode = True
        
class ReservationBase(BaseModel):
    user_id : int
    event_id : int
    reservation_time : datetime
    
class Reservation(ReservationBase):
    id: int
    class Config:
        orm_mode = True
    
    