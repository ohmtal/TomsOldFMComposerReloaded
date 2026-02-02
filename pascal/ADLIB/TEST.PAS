Uses FMtpu,crt,graph,dos;
var i,j:word;
    gd,gm:integer;
Const songname='song07.fms';
      BGIPATH='E:\TP\BGI';

{----------------------------------------------------------------------------}
procedure writexy(x,y:word;text:string);
begin
gotoxy(x,y);
writeln(text);
end;
{----------------------------------------------------------------------------}
  PROCEDURE WaitForKey;
  {
  Hier wird auf einen Tastendruck gewartet, wobei zun„chst der Tastaturpuffer
  gel”scht wird. Das gedrckte Zeichen wird dabei aus dem Tastaturpuffer
  entfernt.
  }
  BEGIN
    delay(100);
    while  Keypressed do readkey;
    readKEY;
  END;

{----------------------------------------------------------------------------}
procedure Bremse(Hunderstel:longint);
VAR h,m,s,t:WORD;
    stop,zeit,sechzig:LONGINT;
begin
    sechzig:=60;
    GetTime(h,m,s,t);
    zeit:= ((h*sechzig+m)*sechzig+s)*100+t;
    stop:=zeit+hunderstel;
  REPEAT
    GetTime(h,m,s,t);
    zeit:= ((h*sechzig+m)*sechzig+s)*100+t;
  UNTIL zeit>stop;
end;
{----------------------------------------------------------------------------}


begin
clrscr;
if FMdetect then begin
Writeln('Adlib-kompatible Soundkarte gefunden.');
Reset_Adlib;
Writeln('Lade SoundFile');
if not loadsong(songname) then begin writeln('Sounddatei (',songname,') nicht gefunden oder Fehler im Soundfile !');halt;end;
writeln('Spiele Sounddatei - Beliebige Taste drcken -');
startsong(false);
repeat until songend or keypressed;
if keypressed then stopsong;

writeln('Songdemo beendet. - Beliebige Taste drcken -');
waitforkey;

gd:=cga;gm:=2;
initgraph(gd,gm,BGIPATH);
Randomize;
setcolor(blue);
line(10,50,264,50);
i:=0;
if not Loadins('sysn1.fmi',5) then halt;
setinstruments(5);
if not Loadins('basdrum1.fmi',6) then halt;
setinstruments(6);
if not Loadins('synt3.fmi',4) then halt;
setinstruments(4);

repeat
INC(i);
FMSound(i,6,5);
FMSound(random(36)+1,1,4);
if i mod 10 =0 then begin FMSound(i,1,6);end;
putpixel(i+10,60,white);
delay(30);
fmnosound(5);
delay(10);
until keypressed or (i>254);
playfm(4,5);bremse(200);
reset_adlib;

while  Keypressed do readkey;

repeat
setcolor(random(16));
outtextxy(5,100,'Is That Hot or what ? >>>>> Taste <<<<<');
until keypressed;
closegraph;
end
else
begin
writeln('Adlib-kompatible Soundkarte nicht gefunden !');
writeln('Falls Sie doch eine solche Karte besizten sollten schauen Sie im Handbuch nach');
end;
end.