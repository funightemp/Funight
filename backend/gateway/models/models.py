from sqlalchemy import Column, Integer, String, DateTime, func
from database.connection import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    senha_hash = Column(String(255), nullable=False)
    criado_em = Column(DateTime, default=func.now())

class Event(Base):
    __tablename__ = "eventos"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    titulo = Column(String(150), nullable=False)
    descricao = Column(Text)
    data_inicio = Column(DateTime)
    data_fim = Column(DateTime)
    url_imagem = Column(Text)
    url_ingressos = Column(Text)
    criado_em = Column(DateTime, default=func.now())