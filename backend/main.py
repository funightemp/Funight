from typing import List
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session, sessionmaker
from .gateway.models.models import User,Event, Reservation, Base
from backend.gateway.models.schemas import UserCreate, EventBase, EventResponse, ReservationBase, User, Reservation
from sqlalchemy import create_engine 
import os
import uvicorn
from backend.gateway.routes import health, auth, events,reservations

#uvicorn backend.main:app --reload --port 9999 
#post - cria novo ...
#get - lista tudo o que está na base de dados correspondente

#falta testar com a api, quando estuver conectado com o postgree

SQLALMECHY_URL = "postgresql://username:password@localhost/dbname"

engine = create_engine(SQLALMECHY_URL)
session_local = sessionmaker(autocommit = False, autoflush=False, bind = engine)

Base.metadata.create_all(bind = engine)

app = FastAPI(title="FastApi App")

app.include_router(health.router)
app.include_router(auth.router, tags = ["Utilizadores"])
app.include_router(events.router, tags = ["Eventos"])
app.include_router(reservations.router, tags = ["Reservas"])




@app.get("/")
def read_root():
    return {"message": "Hello, World!"}


#Obter acesso a base de dados
def get_db():
    db = session_local()
    try:
        yield db
    finally:
        db.close()
        
#Endpoints para utilizadores

@app.post("/users/", response_model=User)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.username == user.username).first()    
    if db_user:
        raise HTTPException(status_code=400, detail = "Username already registered")
    new_user = User(username = user.username, password = user.password) #podemos adicionar hash da senha
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.get("/users/", response_model=List[User]) 
def get_users(db: Session = Depends(get_db)):
    return db.query(User).all()

#Endpoints para Eventos
@app.post("/events/", response_model=Event)
def create_event(event: EventBase, db: Session = Depends(get_db)):
    new_event = Event(**event.dict())
    db.add(new_event)
    db.commit()
    db.refresh(new_event)
    return new_event

@app.get("/users/", response_model=List[Event]) 
def get_users(db: Session = Depends(get_db)):
    return db.query(Event).all()

#Endpoints para Reservas

@app.post("/reservations/", response_model=Reservation)
def create_event(reservation: ReservationBase, db: Session = Depends(get_db)):
    new_reservation = Event(**reservation.dict())
    db.add(new_reservation)
    db.commit()
    db.refresh(new_reservation)
    return new_reservation

@app.get("/reservations/", response_model=List[Reservation]) 
def get_users(db: Session = Depends(get_db)):
    return db.query(Reservation).all()


if __name__ == "__main__":
    port = int(os.getenv("PORT", 9999))
    uvicorn.run(app,"0.0.0.0", port=port)
