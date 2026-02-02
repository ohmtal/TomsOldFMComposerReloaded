Uses FMtpu,crt,utils;
var i,j:word;
    gd,gm:integer;
 songname:string;

begin
clrscr;
writeln;
writeln('------------------FM Songplayer von T.HÅhn (c) 1994 -----------------');
writeln;
If paramcount<>0 then begin
songname:=paramstr(1);
if FMdetect then 
Writeln('Adlib-kompatible Soundkarte gefunden.') else
begin Writeln('Adlib-kompatible Soundkarte nicht gefunden.');halt;end;
Reset_Adlib;
Writeln('Lade SoundDatei');
if loadsong(songname)=false then
begin beep;writeln('Sounddatei (',songname,') nicht gefunden oder Fehler im Soundfile !');halt;end;
Writeln('SoundDatei erfolgreich geladen');
writeln;
writeln('---------------------------------------------------------------------');
writeln;
writeln('                     >>>> Spiele Sounddatei <<<<           ');
startsong(true);
writeln;
writeln('-------------Beliebige Taste drÅcken um Programm zu beenden-----------');
writeln;
repeat until  keypressed ;
stopsong;
writeln('Songdemo beendet.');
end
else writeln('Sounddatei bitte als Parameter eingeben z.B. PLAY SOUNDDATEI.FMS ');


end.