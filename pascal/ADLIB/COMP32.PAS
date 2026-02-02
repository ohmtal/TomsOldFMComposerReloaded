{$V-}  {turn of string checking}

Uses crt,dos,FastTTT5,utils,readtpu,dirtPU,menuttt5,fmtpu;

const
default_ins:array[1..9] of string=('SYSN1.FMI','SYNT2.FMI','BANJO01.FMI',
				   'PACMAN01.FMI','BELL.FMI','LANGSAM1.FMI',
                                   'SCHUSS2.FMI','HIHAT.FMI','BASDRUM2.FMI');

VERSION='0.31';

type v_B_rec=record
	     von,
             bis:word;
             end;

var
seqcounter,aktspur:word;

Liedname:string[12];


{**********************************************************************}
Procedure playtest;

label ende;
var

von,bis,i,j:word;
stop,zeit,sechzig:LONGINT;
h,m,s,t:WORD;

begin
if seqcounter>songlaenge then songlaenge:=seqcounter;
bis:=songlaenge;
repeat
von:=0;
Read_word(1,24,3,'Song spielen von =',0,von,1,999);
if R_char=#27 then goto ende;
Read_word(1,24,3,'Song spielen bis =',0,bis,1,999);
if R_char=#27 then goto ende;

if von>bis then begin

	writeAt (1,24,red,black,' Fehler : Von>Bis !! ');
        errorbeep;
        end;
until von<=bis;
Read_byte(32,24,2,'Abspiegeschwindigkeit (hundstel Sec)=',0,songspeed,10,99);
HorizLine(1,79,24,black,black,2);
if R_char=#27 then goto ende;

for i:=von to bis do
     begin

writecenter(24,lightred,black,'Song l„uft ! Aktuelle Sequenze ='+itos(i));
if keypressed and (readkey=#27) then goto ende;

 for j:=1 to 9 do
    playfm(song[i,j],j);

    sechzig:=60;
    GetTime(h,m,s,t);
    zeit:= ((h*sechzig+m)*sechzig+s)*100+t;
    stop:=zeit+songspeed;
  REPEAT
    GetTime(h,m,s,t);
    zeit:= ((h*sechzig+m)*sechzig+s)*100+t;
    UNTIL zeit>stop;
  end;


ende:
 for j:=1 to 9 do
		    playfm(-1,j);
		HorizLine(1,79,24,black,black,2);

end;
{*****+************************************************************}
procedure schreibneu;
var i,j:integer;
    anfangsseq:word;
    outcolor:byte;
begin

if seqcounter<10 then FBox(1,4,79,4+10,black,black,0);

if (seqcounter) mod 8 = 1 then  FBox(1,13,79,13,black,cyan,0) else
			        FBox(1,13,79,13,black,red,0);
if seqcounter<10 then
        begin
                anfangsseq:=1;
	for i:=4+10-seqcounter to 22 do
        begin
        writeat(1,i,lightblue,black,itos(anfangsseq)+' ');
	for j:=1 to 9 do
        begin
        case song[anfangsseq,j] of
        -1:outcolor:=magenta;
         0:outcolor:=lightblue;
	  else outcolor:=yellow;
        end;
	writeat(j*8,i,outcolor,black,
		'S'+itos(j)+'='+itos(song[anfangsseq,j])+' ');
        end;
        inc(anfangsseq);
        end;
	end

        else
        begin
	anfangsseq:=seqcounter-9;
	for i:=4 to 22 do
        begin
        writeat(1,i,lightblue,black,itos(anfangsseq)+' ');
	for j:=1 to 9 do
        begin
        case song[anfangsseq,j] of
        -1:outcolor:=magenta;
         0:outcolor:=lightblue;
	  else outcolor:=yellow;
        end;
	writeat(j*8,i,outcolor,black,
		'S'+itos(j)+'='+itos(song[anfangsseq,j])+' ');
        end;
        inc(anfangsseq);
        end;
	end;
end;
{*****+************************************************************}
Procedure Reset;
var i:byte;
begin
seqcounter:=1;
aktspur:=1;
schreibneu;
for i:=1 to 9 do setinstruments(i);
end;
{*****+************************************************************}
procedure changeins;
const choice:integer=1;

var      M : menu_record;
var   dummyname: PathStr;
      dummystr : DirStr;
      FName    : NameStr;
      FExt     : ExtStr;
      Errcode:integer;
      Retcode : integer;
      i:word;
begin
    Menu_Set(M);
    With M do
    begin
        Heading1 := 'Instrumenten Setup';
        Heading2 := 'ESC = keine Žnderung';
    for i:=1 to 9 do
        Topic[i]  := ' '+Default_ins[i];
        TotalPicks := 9;
    end;
    DisplayMenu(M,true,Choice,Retcode);
    If Retcode = 0 then begin
           dummyname := Display_Directory('*.FMI',Errcode);
            if errcode=0 then begin
                   FSplit(dummyname, dummystr, FName, FExt);
                   Default_ins[choice]:=Fname+Fext;
                   loadins(Default_ins[choice],choice);
		   setinstruments(choice);
            end;
	    end;

end;
{*****+************************************************************}
procedure set_all_zero;
var i,j:word;
begin
songlaenge:=0;
songspeed:=15;
	for i:=1 to 1000 do
		for j:=1 to 9 do
                song[i,j]:=0;
end;
{*****+************************************************************}
Procedure Init_programm;
var i:byte;
begin
clrscr;
writeln('Initialiesierung - Bitte warten');
Set_all_zero;



Rttt.BegCursor:=true;
     with dttt do
    begin
    initsort:=3;
        ShowDetails:=false;
        DisplayInfo := false;
        AllowHelp := false;
        allowtoggle:=false;
        AllowSort := true;
        AllowInput := True;

    end;


Reset_adlib;

for i:=1 to 9 do loadins(Default_ins[i],i);


clrscr;
HorizLine(1,79,3,red,black,2);
liedname:='NoName.FMS';
writecenter(3,blue,lightgray,' '+liedname+' ');

HorizLine(1,79,23,red,black,2);
HorizLine(1,79,1,red,black,2);
writecenter(1,red,lightgray,'Tom`s Composer '+version+' for FM Developer Kit');
writeat(1,2,yellow,black,'F1 Laden      F2 Speichern     F3 Instrumente     F4 Spielen       F10 Ende');

reset;


end;
{*****+************************************************************}
Procedure Programm_steuerung;

var   dummyname: PathStr;
      dummystr : DirStr;
      FName    : NameStr;
      FExt     : ExtStr;
      Errcode:integer;


begin
repeat
Read_Int(aktspur*8,13,2,'S'+itos(aktspur)+'='
    		,0,song[seqcounter,aktspur],-1,84);

case R_char of
  #201 :if (seqcounter>9)then begin dec (seqcounter,9);schreibneu;end;
  #209 :if seqcounter<1000 then begin inc (seqcounter,9);schreibneu ;end;
  #200 :if (seqcounter>1)then begin dec (seqcounter);schreibneu;end;
  #13,
  #208 :begin inc (seqcounter);schreibneu ;end;
  #009 :if aktspur<9 then begin inc (aktspur);schreibneu;end;
  #143 :if aktspur>1 then begin dec (aktspur);schreibneu ;end;
  #187 : Begin
            dummyname := Display_Directory('*.FMS',Errcode);
            if errcode=0 then begin
                   FSplit(dummyname, dummystr, FName, FExt);
                   liedname:=Fname+Fext;
                   set_all_zero;
                   loadsong(Liedname);
		   HorizLine(1,79,3,red,black,2);
                   writecenter(3,blue,lightgray,' '+liedname+' ');
                   reset;
	  	 end;
        end;
  #188:
       begin
       if seqcounter>songlaenge then songlaenge:=seqcounter;

       Read_word(1,24,4,'Song geht bis Sequenz=',0,songlaenge,1,1000);
       if r_char<>#27 then
       Read_String(30,24,12,'Name der Songdatei =',0,liedname);
       if r_char<>#27 then

       savesong(liedname);
       HorizLine(1,79,3,red,black,2);
       writecenter(3,blue,lightgray,' '+liedname+' ');
       HorizLine(1,79,24,black,black,2);

       end;

  #189:changeins;

  #190: playtest;

  end;
until R_char=#196;

end;

{*****+************************************************************}
{*****+************************************************************}
Procedure End_programm;
begin
Reset_adlib;
Textbackground(black);textcolor(lightgray);
clrscr;
end;
{*****+************************************************************}
begin

Init_programm;
Programm_steuerung;

End_programm;
end.
