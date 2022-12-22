file = open("testD_F.bin", "rb").read()
names = open("namesF.txt", "rt").read()
import os
try:
    os.mkdir("factionFiles")
except OSError as error:
    pass
    
for i in range(len(names.split("\n"))):
    newFile = open("factionFiles/" + str(i + 1).zfill(3) + "_" + names.split("\n")[i] + ".bin", "wb")
    newFile.write(file[(8 + (64 * i)):(8 + (64 * (i + 1)))])
    newFile.close()
    
