from fastapi import FastAPI
from backend.gateway.routes import health

#uvicorn backend.main:app --reload --port 8001   


app = FastAPI(title="FastApi App")

app.include_router(health.router)

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}
