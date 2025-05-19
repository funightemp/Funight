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

    class Config:
        orm_mode = True


class EventCreate(BaseModel):
    titulo: str
    descricao: Optional[str]
    data_inicio: datetime
    data_fim: Optional[datetime]
    url_imagem: Optional[str]
    url_ingressos: Optional[str]
