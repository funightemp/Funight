import requests

EVENTBRITE_KEY = "L6C6LYQGEA34BZIM4V"
                  

def get_events_local(location: str):
    url = "https://www.eventbriteapi.com/v3/events/search/"
    
    headers = {
        "Authorization" : f"Bearer {EVENTBRITE_KEY}"
    }
    
    params = {
        "location.address" : location,
        "expand" : "venue"
    }
    
    response = requests.get(url, headers=headers, params = params)
    
    if response.status_code == 200:
        return response.json().get("events", [])
    else:
        print(f"Erro: {response.status_code}, {response.text}")
        return []
    
#Exemplo de uso:
location = "Porto"
events = get_events_local(location)
for event in events:
    print(event["name"]["text"])