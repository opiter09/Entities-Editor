import os
import FreeSimpleGUI as psg
import shutil
import subprocess
import sys

rom = open(sys.argv[1], "rb")
header = rom.read()[5]
rom.close()
x = 0
if (header == 0x42):
    game = "battles"
elif (header == 0x4E):
    game = "ninjago"
else:
    game = ""
    psg.popup("This is not a valid ROM file!", font = "-size 12")
    x = 1
folder = sys.argv[1].split("\\")[-1][0:-4]

result = " "
while (result != "") and (x == 0):
    result = ""
    layout = [[ psg.Button("Edit Entities") ], [ psg.Button("Rebuild ROM") ]]
    window = psg.Window("", layout, grab_anywhere = True, font = "-size 12")
    while True:
        event, values = window.read()
        # See if user wants to quit or window was closed
        if (event == psg.WINDOW_CLOSED) or (event == "Quit"):
            break
        elif (event == "Edit Entities"):
            result = "edit"
            break
        elif (event == "Rebuild ROM"):
            result = "build"
            break
    window.close()

    if (result == "edit"):
        if (os.path.exists(folder + "2") == False):
            subprocess.run([ "dslazy.bat", "UNPACK", sys.argv[1] ])
            if (os.path.exists("./NDS_UNPACK/data/Data/banner.bnr") == True):
                ePath = "/data/Data/BP/Entities.ebp"
            else:
                ePath = "/data/BP/Entities.ebp"
            os.rename("NDS_UNPACK", folder + "2")
            if (ePath == "/data/BP/Entities.ebp"):
                subprocess.run([ "HackedNitroPaint.exe", folder + "2" + ePath ])
                os.rename("testD.bin", folder + ".bin")
            else:
                os.rename(folder + "2" + ePath, folder + ".bin")
        if (game == "battles"):
            subprocess.run([ "murgaLua.exe", "EntitiesEditor.lua", folder + ".bin" ])
        else:
            subprocess.run([ "murgaLua.exe", "EntitiesEditor_N.lua", folder + ".bin" ])
    elif (result == "build"):
        result = ""
        if (os.path.exists(folder + "2") == False):
            psg.popup("There is no folder to build from!", font = "-size 12")
        else:
            if (os.path.exists(folder + "2" + "/data/Data/banner.bnr") == True):
                ePath = "/data/Data/BP/Entities.ebp"
            else:
                ePath = "/data/BP/Entities.ebp"
            if (ePath == "/data/BP/Entities.ebp"):
                layout = [[ psg.Text("Please drag and drop " + folder + ".bin onto HackedNitroPaint.exe.\n\
Press OK if prompted, then close the grey window, then close this.") ]]
                window = psg.Window("", layout, grab_anywhere = True, font = "-size 12")
                while True:
                    event, values = window.read()
                    if (event == psg.WINDOW_CLOSED) or (event == "Quit"):
                        break
                window.close()
                try:
                    os.remove(folder + "2" + ePath)
                except FileNotFoundError:
                    pass
                os.rename("testC.bin", folder + "2" + ePath)
            else:
                shutil.copyfile(folder + ".bin", folder + "2" + ePath)
            os.rename(folder + "2", "NDS_UNPACK")
            subprocess.run([ "dslazy.bat", "PACK", folder + "2" + ".nds" ])
            os.rename("NDS_UNPACK", folder + "2")
            subprocess.run([ "xdelta3-3.0.11-x86_64.exe", "-e", "-f", "-s", folder + ".nds", folder + "2" + ".nds",
                folder + "2" + ".xdelta" ])
            psg.popup("You can now play " + folder + "2" + ".nds!", title = "", font = "-size 12")
        
    
