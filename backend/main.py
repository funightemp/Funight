from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database.connection import engine, Base, get_db
from backend.gateway.models.schemas import UserCreate, UserOut
from backend.gateway.models.crud import create_user, get_users
from typing import List
from crud import create_event
from eventbrite import fetch_eventbrite_events
from typing import List
from schemas import EventCreate
from models import Event

# Criação das tabelas
Base.metadata.create_all(bind=engine)

app = FastAPI(title="FastAPI com MySQL")

@app.post("/users/", response_model=UserOut)
def add_user(user: UserCreate, db: Session = Depends(get_db)):
    return create_user(db, user)

@app.get("/users/", response_model=List[UserOut])
def list_users(db: Session = Depends(get_db)):
    return get_users(db)

@app.post("/eventbrite/import", response_model=List[EventCreate])
def import_eventbrite_events(db: Session = Depends(get_db)):
    events = fetch_eventbrite_events()
    saved_events = []
    for event in events:
        saved = create_event(db, event)
        saved_events.append(saved)
    return saved_events

@app.get("/eventos/")
def get_events(db: Session = Depends(get_db)):
    return db.query(Event).all()