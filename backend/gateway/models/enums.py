from sqlalchemy import Column, Integer, String, Text, ForeignKey, Numeric, Enum, TIMESTAMP, func
from sqlalchemy.orm import relationship
from database.connection import base
import enum


#Enums: tipos para uma dada categoria
class tipeUser(str, enum.Enum):
    admin = "admin"
    cliente = "cliente"
    
class StatusReserva(str, enum.Enum):
    pendente = "pendente"
    confirmada = "confirmada"
    cancelada = "Cancelada"
    
class Pagamento(str, enum.Enum):
    cartao = "cartao"
    MbWay = "MbWay"
    
class Pagamento_Enum(str,enum.Enum):
    pendente = "pendente"
    aprovado = "aprovado"
    recusado = "recusado"
