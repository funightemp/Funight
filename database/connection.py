from sqlalchemy import create_engine, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError

database_url = "postgresql://postgres:123@localhost:5051/postgres"

engine = create_engine(database_url)
session_local = sessionmaker(autocommit = False, autoflush=False, bind = engine)
base = declarative_base()

def test_connection():
    try:
        # Criar uma sessão
        session = session_local()

        # Realizar uma consulta simples (por exemplo, verificar se há tabelas no banco)
        result = session.execute(text('SELECT 1')) # Executando uma consulta simples
        print("Conexão bem-sucedida!")
        
        # Fechar a sessão após a verificação
        session.close()
    except SQLAlchemyError as e:
        print(f"Erro na conexão: {str(e)}")

# Testando a conexão
test_connection()
