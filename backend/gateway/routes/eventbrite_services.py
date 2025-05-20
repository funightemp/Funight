from fastapi import APIRouter, HTTPException, Query
import requests

router = APIRouter()

EVENTBRITE_KEY = "JPTLVGFZRSQKLH4BPA6I"

@router.get("/external-events/")
def get_events_from_eventbrite(location: str = Query("Porto", description="Cidade para pesquisar eventos")):
    url = "https://www.eventbriteapi.com/v3/events/search/"


    headers = {"Authorization": f"Bearer {EVENTBRITE_KEY}"}
    params = {
        "location.address": location,
        "expand": "venue"
    }
    response = requests.get(url, headers=headers, params=params)
    if response.status_code == 200:
        return {"location": location, "events": response.json().get("events", [])}
    else:
        raise HTTPException(status_code=response.status_code, detail=response.text)
