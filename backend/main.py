from typing import List
from fastapi import FastAPI, Depends, HTTPException, Query
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy import create_engine
import os
import uvicorn
from backend.gateway.routes.eventbrite_services import router as eventbrite_router
from backend.gateway.models.models import User as UserModel, Event, Reservation, Base
from backend.gateway.models.schemas import UserCreate, EventBase, EventResponse, ReservationBase, User as UserSchema, Reservation as ReservationSchema
from backend.gateway.routes import health, auth, events, reservations

# Database connection
SQLALMECHY_URL = "postgresql://postgres:123@172.18.153.122/postgres"
engine = create_engine(SQLALMECHY_URL)
session_local = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base.metadata.create_all(bind=engine)

app = FastAPI(title="FastApi App")

# Include routers
app.include_router(health.router)
app.include_router(auth.router, tags=["Utilizadores"])
app.include_router(events.router, tags=["Eventos"])
app.include_router(reservations.router, tags=["Reservas"])
app.include_router(eventbrite_router)

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

# DB Dependency
def get_db():
    db = session_local()
    try:
        yield db
    finally:
        db.close()

# Users
@app.post("/users/", response_model=UserSchema)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(UserModel).filter(UserModel.username == user.username).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    new_user = UserModel(username=user.username, password=user.password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.get("/users/", response_model=List[UserSchema])
def list_users(db: Session = Depends(get_db)):
    return db.query(UserModel).all()

# Events
@app.post("/events/", response_model=EventResponse)
def create_event(event: EventBase, db: Session = Depends(get_db)):
    new_event = Event(**event.dict())
    db.add(new_event)
    db.commit()
    db.refresh(new_event)
    return new_event

@app.get("/events/", response_model=List[EventResponse])
def list_events(db: Session = Depends(get_db)):
    return db.query(Event).all()

# Reservations
@app.post("/reservations/", response_model=ReservationSchema)
def create_reservation(reservation: ReservationBase, db: Session = Depends(get_db)):
    new_reservation = Reservation(**reservation.dict())
    db.add(new_reservation)
    db.commit()
    db.refresh(new_reservation)
    return new_reservation

@app.get("/reservations/", response_model=List[ReservationSchema])
def list_reservations(db: Session = Depends(get_db)):
    return db.query(Reservation).all()

# Run the app
if __name__ == "__main__":
    port = int(os.getenv("PORT", 9999))
    uvicorn.run(app, host="0.0.0.0", port=port)
