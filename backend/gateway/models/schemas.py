from pydantic import BaseModel 
from datetime import datetime
from typing import List, Optional

#Esquemas de Valiadação

class UserBase(BaseModel):
    id : int
    username : str
    
class UserCreate(UserBase):
    password : str
    
class User(UserBase):
    id: int
    
    class Config:
        orm_mode = True
        
class EventBase(BaseModel):
    id : int
    descrition : Optional[str]
    date : str

class EventResponse(EventBase):
    id : int
    organize_id : int
    
    class Config:
        from_atributtes = True
    
        
class ReservationBase(BaseModel):
    user_id : int
    event_id : int
    reservation_time : datetime
    
class Reservation(ReservationBase):
    id: int
    user_id : int
    class Config:
        orm_mode = True
    
    