from sqlalchemy import Column, Integer, String, DateTime, Text, func
from database.connection import Base

class Event(Base):
    __tablename__ = "eventos"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    titulo = Column(String(150), nullable=False)
    descricao = Column(Text)
    data_inicio = Column(DateTime)
    data_fim = Column(DateTime)
    localizacao = Column(String(255))
    latitude = Column(String(100))
    longitude = Column(String(100))
    url_imagem = Column(Text)
    preco = Column(String(50))
    criado_em = Column(DateTime, default=func.now())