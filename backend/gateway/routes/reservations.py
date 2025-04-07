from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import connection
from ..models.models import Reservation, Event, User
from ..models.schemas import ReservationBase, Reservation
from auth import get_user
from typing import List
from main import get_db

router = APIRouter()

#reservar ticke de um evento
@router.post("/reservation", response_model= Reservation )

def create_reservation(reservation : ReservationBase, db : Session = Depends(get_db), user : User = Depends(get_user)):
    event = db.query(Event).filter(Event.id == reservation.event_id).first()
    
    if not event:
        raise HTTPException(status_code=404, detail = "Evento não encontrado")
    
    new_reservation = Reservation(user_id = user.id, event_id=reservation.event_id)
    db.add(new_reservation)
    db.commit()
    db.refresh(new_reservation)
    return new_reservation

@router.get("/my-reservation", response_model = List[Reservation])
def get_user_reservations(db: Session = Depends(get_db), user : User = Depends(get_user)):
    return db.query(Reservation).filter(Reservation.user_id == user.id).all() 

