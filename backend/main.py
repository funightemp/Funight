from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database.connection import engine, Base, get_db
from backend.gateway.models.schemas import UserCreate, UserOut
from backend.gateway.models.crud import create_user, get_users
from typing import List

# Criação das tabelas
Base.metadata.create_all(bind=engine)

app = FastAPI(title="FastAPI com MySQL")

@app.post("/users/", response_model=UserOut)
def add_user(user: UserCreate, db: Session = Depends(get_db)):
    return create_user(db, user)

@app.get("/users/", response_model=List[UserOut])
def list_users(db: Session = Depends(get_db)):
    return get_users(db)
