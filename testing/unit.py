file = open("testD_U.bin", "rb").read()
names = open("namesU.txt", "rt").read()
import os
try:
    os.mkdir("unitFiles")
except OSError as error:
    pass
    
for i in range(len(names.split("\n"))):
    newFile = open("unitFiles/" + str(i + 1).zfill(3) + "_" + names.split("\n")[i] + ".bin", "wb")
    newFile.write(file[(4 + (124 * i)):(4 + (124 * (i + 1)))])
    newFile.close()
    
