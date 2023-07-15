import os
import PySimpleGUI as psg
import subprocess
import sys

rom = open(sys.argv[1], "rb")
header = rom.read()[5]
rom.close()
if (header == 0x42):
    game = "battles"
elif (header == 0x4E):
    game == "ninjago"
else:
    game = ""
    psg.popup("This is not a valid ROM file!")
    x == 2 # psgcompiler-friendly quit
folder = sys.argv[1].split("\\")[-1][0:-4]

result = ""
layout = [ [ psg.Button("Edit Entities") ], [ psg.Button("Rebuild ROM") ] ]
window = psg.Window("", layout, grab_anywhere = True)
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
        subprocess.run([ "carbonizer/carbonizer.exe", sys.argv[1] ])
        os.rename(folder, folder + "2")
        subprocess.run([ "HackedNitroPaint.exe", folder + "2" + "/data/BP/Entities.ebp" ])
        os.rename("testD.bin", folder + ".bin")
    if (game == "battles"):
        subprocess.run([ "murgaLua.exe", "EntitiesEditor.lua", folder + ".bin" ])
    else:
        subprocess.run([ "murgaLua.exe", "EntitiesEditor_N.lua", folder + ".bin" ])
elif (result == "build"):
    if (os.path.exists(folder + "2") == False):
        psg.popup("There is no folder to build from!")
    else:
        layout = [[psg.Text("Please drag and drop " + folder + ".bin onto HackedNitroPaint.exe.\n\
Press OK, then close the resulting window, then close this.")]]
        window = psg.Window("", layout, grab_anywhere = True, font = "-size 12")
        while True:
            event, values = window.read()
            if (event == psg.WINDOW_CLOSED) or (event == "Quit"):
                break
        window.close()
        try:
            os.remove(folder + "2" + "/data/BP/Entities.ebp")
        except FileNotFoundError:
            pass
        os.rename("testC.bin", folder + "2" + "/data/BP/Entities.ebp")
        subprocess.run([ "carbonizer/carbonizer.exe", folder + "2" ])
        
    