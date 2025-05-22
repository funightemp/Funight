from sqlalchemy.orm import Session
from backend.gateway.models.models import Event
from backend.gateway.models.schemas import EventCreate

def create_event(db: Session, event: EventCreate):
    db_event = Event(**event.dict())
    db.add(db_event)
    db.commit()
    db.refresh(db_event)
    return db_event
