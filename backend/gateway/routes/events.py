from fastapi import APIRouter, Query, Depends, HTTPException
from sqlalchemy.orm import Session
from database import connection
from ..models.models import Reservation, Event, User
from ..models.schemas import EventBase, EventResponse
from backend.gateway.routes.auth import get_user
from backend.dependencies import get_db
from typing import List
from backend.gateway.services.eventbrite_services import get_events_local

router = APIRouter()


@router.get("/events")
def list_events(location : str = Query(..., description="Local")):
    events = get_events_local(location)
    return {"evets" : events}

        
 
