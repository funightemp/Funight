from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from gateway.models.models import User
from gateway.models import get_db
from .schemas import UserCreate
from passlib.context import CryptContext