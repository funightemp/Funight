from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Microserviço de Pagamentos está funcionando!"}