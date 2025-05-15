from sqlite3 import OperationalError
from sqlalchemy import create_engine, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError

database_url = "postgresql://postgres:123@172.18.153.122:5051/postgres"

engine = create_engine(database_url)
session_local = sessionmaker(autocommit = False, autoflush=False, bind = engine)
base = declarative_base()

def test_connection():
    
    try:
        with engine.connect() as connection:  # Usa conexão direta para teste
            result = connection.execute(text('SELECT 1'))
            print("Conexão bem-sucedida! Resultado:", result.fetchone())
    except OperationalError as e:
        print(f"Erro operacional no banco de dados: {str(e)}")
    except SQLAlchemyError as e:
        print(f"Erro geral do SQLAlchemy: {str(e)}")
    except Exception as e:
        print(f"Erro inesperado: {str(e)}")

# Testando a conexão
test_connection()
