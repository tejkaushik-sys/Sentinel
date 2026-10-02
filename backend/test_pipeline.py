import requests

r = requests.get('http://127.0.0.1:8000/api/v1/events').json()
print(f"Total Live Ingested Events: {len(r)}")
for e in r:
    sources = ", ".join([s["name"] for s in e.get("sources", [])])
    print(f"• [{e['category'].upper()}] {e['title']} | Dist: {e.get('distance_km')}km | Conf: {int(e.get('confidence_score', 0)*100)}% | Sources: {sources}")
