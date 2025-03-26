from fastapi import FastAPI
import firebase_admin
from firebase_admin import credentials, messaging

app = FastAPI()

# Inicializar o Firebase
cred = credentials.Certificate("firebase_credentials.json")
firebase_admin.initialize_app(cred)

@app.get("/")
def read_root():
    return {"message": "Microserviço de Notificações está funcionando!"}

@app.post("/send-notification/")
def send_notification(token: str, title: str, body: str):
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        token=token,
    )
    response = messaging.send(message)
    return {"message": "Notificação enviada!", "response": response}
