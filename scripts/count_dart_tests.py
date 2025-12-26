import json
path = '.dart_test.json'
count = 0

def handle_event(ev):
    global count
    if not isinstance(ev, dict):
        return
    t = ev.get('type') or ev.get('event')
    if t == 'testDone':
        # Match `flutter test` console summary: exclude hidden "loading ..." tests
        # and exclude skipped tests from the +passed count.
        if ev.get('hidden', False):
            return
        if ev.get('skipped', False):
            return
        count += 1

with open(path, 'rb') as f:
    for raw in f:
        try:
            line = raw.decode('utf-8', errors='replace').strip()
        except:
            continue
        if not line:
            continue
        # Some machine outputs may be a JSON array spanning a line
        try:
            ev = json.loads(line)
        except:
            # Try to trim trailing commas and brackets and parse again
            cleaned = line.rstrip(',')
            try:
                ev = json.loads(cleaned)
            except:
                continue
        if isinstance(ev, list):
            for item in ev:
                handle_event(item)
        else:
            handle_event(ev)

print(count)
