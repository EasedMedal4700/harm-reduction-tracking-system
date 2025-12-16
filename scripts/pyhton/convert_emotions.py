import supabase
import os
from dotenv import load_dotenv

# Load environment variables from .env file in parent directory
script_dir = os.path.dirname(os.path.abspath(__file__))
env_path = os.path.join(script_dir, '..', '.env')
load_dotenv(env_path)

def convert_emotions():
    url = os.environ.get('SUPABASE_URL')
    key = os.environ.get('SUPABASE_ANON_KEY')
    
    if not url or not key:
        print("SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env")
        return
    
    client = supabase.create_client(url, key)
    
    # Fetch all entries with emotions, body_signals, triggers, people
    response = client.table('drug_use').select('use_id, primary_emotions, secondary_emotions, body_signals, triggers, people').execute()
    data = response.data

    for entry in data:
        use_id = entry['use_id']
        
        # Process primary_emotions
        raw_primary = entry.get('primary_emotions', '')
        if isinstance(raw_primary, str):
            if raw_primary:
                primary_list = list(set(e.strip() for e in raw_primary.split(';') if e.strip()))
            else:
                primary_list = []
        elif isinstance(raw_primary, list):
            primary_list = raw_primary
        else:
            primary_list = []
        
        # Process secondary_emotions
        raw_secondary = entry.get('secondary_emotions', '')
        if isinstance(raw_secondary, str):
            if raw_secondary:
                secondary_list = list(set(e.strip() for e in raw_secondary.split(';') if e.strip()))
            else:
                secondary_list = []
        elif isinstance(raw_secondary, list):
            secondary_list = raw_secondary
        else:
            secondary_list = []
        
        # Process body_signals
        raw_body = entry.get('body_signals', '')
        if isinstance(raw_body, str):
            if raw_body:
                body_list = [e.strip() for e in raw_body.split(';') if e.strip()]
            else:
                body_list = []
        elif isinstance(raw_body, list):
            body_list = raw_body
        else:
            body_list = []
        
        # Process triggers
        raw_triggers = entry.get('triggers', '')
        if isinstance(raw_triggers, str):
            if raw_triggers:
                triggers_list = [e.strip() for e in raw_triggers.split(';') if e.strip()]
            else:
                triggers_list = []
        elif isinstance(raw_triggers, list):
            triggers_list = raw_triggers
        else:
            triggers_list = []
        
        # Process people
        raw_people = entry.get('people', '')
        if isinstance(raw_people, str):
            if raw_people:
                people_list = [e.strip() for e in raw_people.split() if e.strip()]  # Split by space for names
            else:
                people_list = []
        elif isinstance(raw_people, list):
            people_list = raw_people
        else:
            people_list = []

        # Update the row with the JSON arrays
        client.table('drug_use').update({
            'primary_emotions': primary_list,
            'secondary_emotions': secondary_list,
            'body_signals': body_list,
            'triggers': triggers_list,
            'people': people_list
        }).eq('use_id', use_id).execute()
        print(f"Updated use_id {use_id}: Primary: {primary_list}, Secondary: {secondary_list}, Body: {body_list}, Triggers: {triggers_list}, People: {people_list}")

if __name__ == "__main__":
    convert_emotions()