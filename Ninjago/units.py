file = open("testD.bin", "rb")
reading = file.read()
file.close()
text = open("internal.txt", "at")

import os
try:
    os.mkdir("units")
except OSError as error:
    pass

count = -2
for i in range(4, 19589, 128):
    count = count + 2
    new = open("./units/" + str(count // 2).zfill(3) + "_" + reading[0xB0D8:0xBDAE].split(bytes(1))[count].decode("UTF-8") + ".bin", "wb")
    new.write(reading[i:(i + 128)])
    new.close()
    text.write(reading[0xB0D8:0xBDAE].split(bytes(1))[count].decode("UTF-8") + "\n")