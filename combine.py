import os

file = open("testD.bin", "rb").read()
names = open("names.txt", "rt").read()
if (os.path.exists("combined.bin") == True):
    os.remove("combined.bin")
combined = open("combined.bin", "ab")
combined.write(file[0:4])
for i in range(len(names.split("\n"))):
    newFile = open("unitFiles/" + str(i + 1).zfill(3) + "_" + names.split("\n")[i] + ".bin", "rb")
    combined.write(newFile.read())
    newFile.close()
combined.write(file[(4 + 124 * (len(names.split("\n")))):os.stat("testD.bin").st_size])