from fastapi import FastAPI
from FastApi.routes import health

app = FastAPI(title="FastApi App")

app.include_router(health.router)

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}
