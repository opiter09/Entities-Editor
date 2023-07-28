This project is a GUI allowing for simple editing of the file Entities.ebp, from the NDS video game
LEGO Battles and its sequel. It runs using MurgaLua (RIP John Murga).

To download this, please press the green "Code" button, then select "Download ZIP" from the
drop-down menu.

It also unpacks and repacks the DS ROM using the version of ndstool and batch file from DSLazy,
which can be found at https://www.romhacking.net/utilities/793/. This utility comes without
a license, however if you wish to see the source code for (a later version of) ndstool, it can be
found at https://github.com/devkitPro/ndstool.

With the 3.0 rewrite, running this is ridiculously simple. Simply move your ROM into the same
folder as wrapper.exe, then drag and drop the former onto the latter. Then choose whether you want
to edit the file, or create a new ROM (i.e. after you've finished editing). The only small tricky
thing to watch out for is that both when first unpacking a ROM, and when rebuilding it, you will
at one point see a dark grey, empty window. You must close this out to complete the process.

Also, along with the new ROM, rebuilding conveniently generates an xdelta patch file for you,
using the original CL version of xdelta found here: https://www.romhacking.net/utilities/928/.

Finally, please note that if you choose to run this via python CL instead of the exe, the
editor uses a much smaller font than normal for some strange reason.