from pydantic import BaseModel

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
