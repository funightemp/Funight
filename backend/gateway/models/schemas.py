from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class UserCreate(BaseModel):
    nome: str
    email: str
    senha_hash: str

class UserOut(BaseModel):
    id: int
    nome: str
    email: str


class EventBase(BaseModel):
    titulo: str
    descricao: Optional[str] = None
    data_inicio: Optional[datetime] = None
    data_fim: Optional[datetime] = None
    url_imagem: Optional[str] = None
    url_ingressos: Optional[str] = None
    
    class Config:
        orm_mode = True

class EventCreate(EventBase):
    pass

class EventSchema(EventBase):
    id: int
    criado_em: datetime

    class Config:
        from_attributes = True