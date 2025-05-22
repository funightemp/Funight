from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database.connection import engine, Base, get_db
from backend.gateway.models.schemas import EventSchema, EventCreate
from backend.gateway.models.models import Event
from backend.gateway.models.crud import create_event
from typing import List


# Criação das tabelas
Base.metadata.create_all(bind=engine)

app = FastAPI(title="FastAPI com MySQL")

@app.post("/eventos/", response_model=EventSchema)
def add_event(event: EventCreate, db: Session = Depends(get_db)):
    return create_event(db, event)

@app.get("/eventos/", response_model=List[EventSchema])
def read_events(db: Session = Depends(get_db)):
    events = db.query(Event).all()
    return events  

@app.get("/eventos/{event_id}", response_model=EventSchema)
def read_event(event_id: int, db: Session = Depends(get_db)):
    event = db.query(Event).filter(Event.id == event_id).first()
    if event is None:
        raise HTTPException(status_code=404, detail="Evento não encontrado")
    return event