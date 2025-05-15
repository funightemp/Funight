# backend/dependencies.py
from database.connection import session_local

def get_db():
    db = session_local()
    try:
        yield db
    finally:
        db.close()
