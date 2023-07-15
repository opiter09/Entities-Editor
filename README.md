This project is a GUI allowing for simple editing of the file Entities.ebp, from the NDS video game
LEGO Battles and its sequel. It runs using MurgaLua (RIP John Murga).

It also unpacks and repacks the DS ROM using the excelled Carbonizer, made by simonomi. If
you would like the see the source code, or use an updated version, it can be found at
https://github.com/simonomi/carbonizer

With the 3.0 rewrite, running this is ridiculously simple. Simply drag and drop your ROM onto
wrapper.exe. Then choose whether you want to edit the file, or create a new ROM (i.e. after
you've finished editing). The only small tricky thing to watch out for is that both when
first unpacking a ROM, and when rebuilding it, you will at one point see a dark grey, empty
window. You must close this out to complete the process.

Finally, please note that if you choose to run this via python CL instead of the exe, the
editor uses a much smaller font than normal for some strange reason.