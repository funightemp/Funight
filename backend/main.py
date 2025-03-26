from fastapi import FastAPI
import os
import uvicorn
from backend.gateway.routes import health

#uvicorn backend.main:app --reload --port 8000 


app = FastAPI(title="FastApi App")

app.include_router(health.router)

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app,"0.0.0.0", port=port)
