from systemd import journal

j = journal.Reader()
j.this_boot()
j.add_match(_SYSTEMD_UNIT="nginx.service")

for entry in j:
    print(entry["MESSAGE"])
