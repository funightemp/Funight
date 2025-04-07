from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2AuthorizationCodeBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from typing import Optional
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from ..models.models import User
from database import connection
from ..models.schemas import UserCreate, UserBase
from passlib.context import CryptContext
from main import get_db

router = APIRouter()

#Configuração do JWT
SECRET_KEY = "CHAVE_ENCRIPTADA"
ALGORITHM = "HS256"
ACESS_TOKEN_EXPIRE_MINUTES = 30 

#Configuração para o hash senha
pwd_context = CryptContext(schemes=["bcrypt"], deprecated = "auto")

#OAuth2 para a autenticação
oauth2_scheme = OAuth2AuthorizationCodeBearer(tokenUrl="login")


#Função que queria o hash para a senha
def hash_password(password: str) ->str:
    return pwd_context.hash(password)

#Função que verifica a senha
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password,hashed_password)

#Função que cria o tkien JWt
def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode,SECRET_KEY, algorithm=ALGORITHM)


#Endpoint para registo de Utilizador novo 
@router.post("/register", response_model = UserBase)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.username == user.username).first()
    if db_user:
        raise HTTPException(status_code=400, detail = "O Utilizador já Existe")
    
    new_user = User(username = user.username, password = hash_password(user.password))
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


#Endpoint para login e para a criação do Token
@router.post("/login")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == form_data.username).first()
    if not user or not verify_password(form_data.password, user.password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail = "Credenciais Inválidas")
    
    acess_token = create_access_token(data = {"sub": user.username})
    return {"acess_token" :acess_token, "token_type":"bearer" }

#Função qque obtém o utlizador autenticado
def get_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username : str = payload.get("sub")
        if username is None:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail = "Token Inválido")
    except JWTError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail = "Token Inválido")

    user = db.query(User).filter(User.username == username).first()
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail = "Utilizador não encontrado")

    return user

#Endpoint que obtém as informações do Utilizador logado na app
@router.get("/me", response_model=UserBase)
def get_me(current_user : User = Depends(get_db)):
    return current_user