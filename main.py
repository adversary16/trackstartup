import select
from systemd import journal

j = journal.Reader()
j.log_level(journal.LOG_INFO)

# j.add_match(_SYSTEMD_UNIT="systemd-udevd.service")
j.seek_tail()
j.get_previous()
# j.get_next() # it seems this is not necessary.

p = select.poll()
p.register(j, j.get_events())

while p.poll():
    if j.process() != journal.APPEND:
        continue

    # Your example code has too many get_next() (i.e, "while j.get_next()" and "for event in j") which cause skipping entry.
    # Since each iteration of a journal.Reader() object is equal to "get_next()", just do simple iteration.
    for entry in j:
        if entry['MESSAGE'] != "":
            print(str(entry['__REALTIME_TIMESTAMP'] )+ ' ' + entry['MESSAGE'])