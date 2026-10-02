from typing import List
from app.models.schemas import VerifyRecord, VerifyResponse
from app.data.seed_data import PUBLIC_RECORDS

class VerifyEngine:
    def __init__(self):
        self.records: List[VerifyRecord] = list(PUBLIC_RECORDS)
    
    def search(self, query: str, query_type: str = "Person") -> VerifyResponse:
        q_lower = query.strip().lower()
        matched = []
        for r in self.records:
            # Match type if specified
            if query_type and query_type.lower() != "all":
                if r.record_type.lower() != query_type.lower():
                    continue
            
            # Match query against title, case_number, court, party_role, subtitle
            text_corpus = f"{r.title} {r.case_number or ''} {r.court_or_authority or ''} {r.party_role or ''} {r.subtitle or ''}".lower()
            if not q_lower or q_lower in text_corpus:
                matched.append(r)
        
        # If no strict query, return all records of that type or sample records
        if not matched and not q_lower:
            matched = [r for r in self.records if query_type.lower() in ("all", r.record_type.lower())]
            
        return VerifyResponse(
            query=query,
            query_type=query_type,
            total_found=len(matched),
            records=matched,
            disclaimer="A name match is not proof of identity. Verify the original record and identity."
        )

verify_engine_instance = VerifyEngine()
