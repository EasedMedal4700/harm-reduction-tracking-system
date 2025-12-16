import os
from datetime import datetime, timedelta
from supabase import create_client, Client
from dotenv import load_dotenv

# Load environment variables from .env file in parent directory
script_dir = os.path.dirname(os.path.abspath(__file__))
env_path = os.path.join(script_dir, '..', '.env')
load_dotenv(env_path)

# Supabase credentials (set as environment variables for security)
SUPABASE_URL = os.getenv('SUPABASE_URL', 'your_supabase_url_here')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY') or os.getenv('SUPABASE_ANON_KEY', 'your_supabase_anon_key_here')

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def convert_time_to_utc(time_str: str, offset_hours: int = 2) -> str:
    """
    Convert a time string from local time to UTC by adding the offset.
    If input is HH:MM or HH:MM:SS, combines with today's date.
    If input is full timestamp, adjusts the time.
    """
    try:
        # Try to parse as full datetime first
        try:
            dt = datetime.fromisoformat(time_str.replace('Z', '+00:00'))
        except ValueError:
            # Assume it's time only, combine with today's date
            try:
                time_obj = datetime.strptime(time_str, '%H:%M:%S').time()
            except ValueError:
                time_obj = datetime.strptime(time_str, '%H:%M').time()
            dt = datetime.combine(datetime.today(), time_obj)
        # Add offset to get UTC
        utc_dt = dt + timedelta(hours=offset_hours)
        # Return as ISO string for timestamp column
        return utc_dt.isoformat()
    except ValueError:
        # If parsing fails, return original
        return time_str

def update_craving_times():
    """
    Fetch all cravings, convert time to UTC, and update the table.
    Assumes local timezone is UTC+1; adjust offset_hours if needed.
    """
    # Fetch all rows
    response = supabase.table('cravings').select('*').execute()
    cravings = response.data

    for craving in cravings:
        craving_id = craving['craving_id']
        time_str = craving.get('time')
        if time_str and isinstance(time_str, str):
            # Convert time
            corrected_time = convert_time_to_utc(time_str, offset_hours=2)
            # Update the row
            supabase.table('cravings').update({'time': corrected_time}).eq('craving_id', craving_id).execute()
            print(f"Updated craving {craving_id}: {time_str} -> {corrected_time}")
        else:
            print(f"Skipped craving {craving_id}: invalid time '{time_str}'")

if __name__ == '__main__':
    update_craving_times()