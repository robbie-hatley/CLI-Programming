touch tempdesc.txt
for %%F in (descrip*.ion) do copy tempdesc.txt + %%F tempdesc.txt
erase descrip*.ion
ren tempdesc.txt descript.ion
