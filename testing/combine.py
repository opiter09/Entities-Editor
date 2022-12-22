import os
import subprocess

if (os.path.isdir("./unitFiles") == True):
    file = open("testD_U.bin", "rb").read()
    names = open("namesU.txt", "rt").read()
    if (os.path.exists("combined_U.bin") == True):
        os.remove("combined_U.bin")
    combined = open("combined_U.bin", "ab")
    combined.write(file[0:4])
    for i in range(len(names.split("\n"))):
        newFile = open("unitFiles/" + str(i + 1).zfill(3) + "_" + names.split("\n")[i] + ".bin", "rb")
        combined.write(newFile.read())
        newFile.close()
    combined.write(file[(4 + 124 * (len(names.split("\n")))):os.stat("testD_U.bin").st_size])
    combined.close()

    if (os.path.exists("HackedNitroPaint.exe") == True):
        subprocess.run([ "HackedNitroPaint.exe", "combined_U.bin" ])
        if (os.path.exists("./LEGO BATTLES/data/BP/Entities.ebp") == True):
            os.remove("./LEGO BATTLES/data/BP/Entities.ebp")
        os.rename("./testC.bin", "./LEGO BATTLES/data/BP/Entities.ebp")

if (os.path.isdir("./factionFiles") == True):
    file = open("testD_F.bin", "rb").read()
    names = open("namesF.txt", "rt").read()
    if (os.path.exists("combined_F.bin") == True):
        os.remove("combined_F.bin")
    combined = open("combined_F.bin", "ab")
    combined.write(file[0:8])
    for i in range(len(names.split("\n"))):
        newFile = open("factionFiles/" + str(i + 1).zfill(3) + "_" + names.split("\n")[i] + ".bin", "rb")
        combined.write(newFile.read())
        newFile.close()
    combined.write(file[(8 + 64 * (len(names.split("\n")))):os.stat("testD_F.bin").st_size])
    combined.close()

    if (os.path.exists("HackedNitroPaint.exe") == True):
        subprocess.run([ "HackedNitroPaint.exe", "combined_F.bin" ])
        if (os.path.exists("./LEGO BATTLES/data/BP/Factions.fbp") == True):
            os.remove("./LEGO BATTLES/data/BP/Factions.fbp")
        os.rename("./testC.bin", "./LEGO BATTLES/data/BP/Factions.fbp")