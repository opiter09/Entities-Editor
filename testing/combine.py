import os
import subprocess

file = open("testD_U.bin", "rb").read()
names = open("namesU.txt", "rt").read()
if (os.path.exists("combined.bin") == True):
    os.remove("combined.bin")
combined = open("combined.bin", "ab")
combined.write(file[0:4])
for i in range(len(names.split("\n"))):
    newFile = open("unitFiles/" + str(i + 1).zfill(3) + "_" + names.split("\n")[i] + ".bin", "rb")
    combined.write(newFile.read())
    newFile.close()
combined.write(file[(4 + 124 * (len(names.split("\n")))):os.stat("testD_U.bin").st_size])
combined.close()

subprocess.run([ "HackedNitroPaint.exe", "combined.bin" ])
if (os.path.exists("./LEGO BATTLES/data/BP/Entities.ebp") == True):
    os.remove("./LEGO BATTLES/data/BP/Entities.ebp")
os.rename("./testC.bin", "./LEGO BATTLES/data/BP/Entities.ebp")


file = open("testD_F.bin", "rb").read()
names = open("namesF.txt", "rt").read()
if (os.path.exists("combined.bin") == True):
    os.remove("combined.bin")
combined = open("combined.bin", "ab")
combined.write(file[0:4])
for i in range(len(names.split("\n"))):
    newFile = open("factionFiles/" + str(i + 1).zfill(3) + "_" + names.split("\n")[i] + ".bin", "rb")
    combined.write(newFile.read())
    newFile.close()
combined.write(file[(4 + 64 * (len(names.split("\n")))):os.stat("testD_F.bin").st_size])
combined.close()

subprocess.run([ "HackedNitroPaint.exe", "combined.bin" ])
if (os.path.exists("./LEGO BATTLES/data/BP/Factions.fbp") == True):
    os.remove("./LEGO BATTLES/data/BP/Factions.fbp")
os.rename("./testC.bin", "./LEGO BATTLES/data/BP/Factions.fbp")