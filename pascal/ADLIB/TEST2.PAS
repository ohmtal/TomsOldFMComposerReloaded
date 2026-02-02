Uses FMtpu,crt,utils,graph;
var i,j:word;
    gd,gm:integer;
Const songname='song07.fms';
begin
clrscr;
Reset_Adlib;
i:=0;
if not Loadins('blubr.fmi',5) then halt;
setinstruments(5);

repeat
if keypressed then begin playfm(36,5);bremse(50);end else playfm(-1,5);
until keypressed and (readkey=#27);
reset_adlib;
end.