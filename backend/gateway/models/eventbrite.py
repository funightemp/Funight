import requests
from backend.gateway.models.schemas import UserCreate, UserOut, EventCreate
from typing import List
from datetime import datetime

# Coloca aqui o teu token privado do Eventbrite
EVENTBRITE_TOKEN = "3R6ETKFJBUG7Z5IDW6VI"

def fetch_eventbrite_events(keyword: str = "music", location: str = "Porto") -> List[EventCreate]:
    headers = {
        "Authorization": f"Bearer {EVENTBRITE_TOKEN}"
    }

    params = {
        "q": keyword,
        "location.address": location,
        "expand": "venue"
    }

    response = requests.get("https://www.eventbriteapi.com/v3", headers=headers, params=params)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
    if response.status_code != 200:
        raise Exception(f"Erro ao buscar eventos do Eventbrite: {response.status_code} - {response.text}")

    events_data = response.json().get("events", [])
    events = []

    for e in events_data:
        try:
            event = EventCreate(
                titulo=e["name"]["text"] or "Sem título",
                descricao=e["description"]["text"] if e["description"] else None,
                data_inicio=datetime.fromisoformat(e["start"]["utc"].replace("Z", "+00:00")),
                data_fim=datetime.fromisoformat(e["end"]["utc"].replace("Z", "+00:00")),
                url_imagem=e["logo"]["url"] if e.get("logo") else None,
                url_ingressos=e["url"]
            )
            events.append(event)
        except Exception:
            continue
    
    return events
