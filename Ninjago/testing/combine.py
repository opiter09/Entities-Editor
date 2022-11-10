import os

new = open("output_testD.bin", "wb")
new.close()
new = open("output_testD.bin", "ab")

new.write((0x42504E5A).to_bytes(4, "big"))

sortL = []
for root, dirs, files in os.walk("./units"):
    sortL = files
sortL.sort()
for f in sortL:
    o = open("./units/" + f, "rb")
    new.write(o.read())
    o.close()

old = open("testD.bin", "rb")
new.write(old.read()[19716:])
old.close()
