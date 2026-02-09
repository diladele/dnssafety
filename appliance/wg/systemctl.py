from pydbus import SystemBus

bus = SystemBus()
systemd = bus.get(".systemd1")

# Start a service
systemd.StartUnit("nginx.service", "replace")

# Get unit state
unit = bus.get(".systemd1", "/org/freedesktop/systemd1/unit/nginx_2eservice")
print(unit.ActiveState)
