from fastapi import APIRouter, Query, Depends, HTTPException
from sqlalchemy.orm import Session
from database import connection
from ..models.models import Reservation, Event, User
from ..models.schemas import EventBase, EventResponse
from auth import get_user
from main import get_db
from typing import List
from services.eventbrite_services import get_events_local

router = APIRouter()

@router.get("/events")

def list_events(location : str = Query(..., description="Local")):
    events = get_events_local(location)
    return {"evets" : events}


#Listar todos os eventos
@router.get("/events", response_model= List[EventResponse])
def get_event(event_id : int, db: Session = Depends(get_db)):
    event = db.query(Event).filter(Event.id == event_id).first()
    if not event:
        raise HTTPException(status_code=404, detail = "Evento não encontrado")
    return event
        
 
