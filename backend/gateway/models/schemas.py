from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class EventBase(BaseModel):
    titulo: str
    descricao: Optional[str] = None
    data_inicio: Optional[datetime] = None
    data_fim: Optional[datetime] = None
    localizacao: Optional[str] = None
    latitude: Optional[str] = None
    longitude: Optional[str] = None
    url_imagem: Optional[str] = None
    preco: Optional[str] = None

    class Config:
        orm_mode = True

class EventCreate(EventBase):
    pass

class EventSchema(EventBase):
    id: int
    criado_em: datetime

    class Config:
        from_attributes = True  # para FastAPI >=0.95; se usares versão antiga, mantém orm_mode = True