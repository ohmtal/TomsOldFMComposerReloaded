{$V-}  {turn of string checking}

Uses crt,dos,FastTTT5,utils,readtpu,dirtPU,menuttt5,fmtpu;

const
VERSION='0.33';

norm_ins:array[1..9] of string=('SYSN1.FMI','SYNT2.FMI','BANJO01.FMI',
				   'PACMAN01.FMI','BELL.FMI','LANGSAM1.FMI',
                                   'SCHUSS2.FMI','HIHAT.FMI','BASDRUM2.FMI');


type v_B_rec=record
	     von,
             bis:word;
             end;

var
seqcounter,aktspur:word;

Liedname:string[12];
Buffer:array[1..100,1..9] of integer;
Bufferlaenge:byte;

{**********************************************************************}
Procedure playtest;

label ende;
var

von,bis,i,j:word;
stop,zeit,sechzig:LONGINT;
h,m,s,t:WORD;

begin
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

if seqcounter>songlaenge then songlaenge:=seqcounter;
HorizLine(1,79,23,red,black,2);
writecenter(23,red,lightgray,'Aktuelle Songl„nge = '+itos(songlaenge));

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
        Topic[i]  := ' '+Actual_ins[i];
        TotalPicks := 9;
    end;
    DisplayMenu(M,true,Choice,Retcode);
    If Retcode = 0 then begin
           dummyname := Display_Directory('*.FMI',Errcode);
            if errcode=0 then begin
                   FSplit(dummyname, dummystr, FName, FExt);
                   Actual_ins[choice]:=Fname+Fext;
                   loadins(Actual_ins[choice],choice);
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
Bufferlaenge:=0;



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

for i:=1 to 9 do
begin
Actual_ins[i]:=norm_ins[i];
loadins(Actual_ins[i],i);
end;

clrscr;
HorizLine(1,79,3,red,black,2);
liedname:='NoName.FMS';
writecenter(3,blue,lightgray,' '+liedname+' ');

HorizLine(1,79,23,red,black,2);
HorizLine(1,79,1,red,black,2);
writecenter(1,red,lightgray,'Tom`s Composer '+version+' for FM Developer Kit');
writeat(1,2,yellow,black,'F1-Laden   F2-Speichern   F3-Instrumente   F4-Spielen   F5-Žndern   F10-Ende');


reset;


end;
{*****+************************************************************}
Procedure Modify;
const choice:integer=1;
var    M : menu_record;
       Retcode : integer;
       bufferon:string;
       weg,i,ic,j,von,bis,bei:word;
       ok,abbruch:boolean;

begin
abbruch:=false;
if bufferlaenge>0 then bufferon:='Puffer belegt' else bufferon:='Puffer frei';
    Menu_Set(M);
    With M do
    begin
        Heading1 := 'Žnderungs Men -'+bufferon;
        Heading2 := 'ESC = keine Žnderung';
        Topic[1]  := '      Kopieren in Puffer      ';
        Topic[2]  := '      L”schen                 ';
        Topic[3]  := '      Entfernen               ';
        Topic[4]  := '      šberschreiben von Puffer';
        Topic[5]  := '      Einfgen  von Puffer    ';

        TotalPicks := 5;
    end;
    DisplayMenu(M,true,Choice,Retcode);
    If Retcode = 0 then begin
            case choice of
    {Kopieren in Puffer}
            1:begin
              von:=seqcounter;bis:=seqcounter+1;
              repeat
              Read_word(1,24,3,'Puffer fllen von =',0,von,1,999);
	      Read_word(30,24,3,'Puffer fllen bis =',0,bis,1,999);
          	if von>bis then begin
			writeAt (1,24,red,black,' Fehler : Von>Bis !! ');
		        errorbeep;end;
          	if bis-von>100 then begin
			writeAt (1,24,red,black,' Fehler : Puffer faát Maximal 100 Reihen !! ');
		        errorbeep;end;

              until (von<=bis) and (bis-von<100);
              HorizLine(1,79,24,black,black,2);
              bufferlaenge:=bis-von+1;
              ic:=0;
              for i:=von to bis do
              begin
              inc(ic);
	      for j:=1 to 9 do
	      buffer[ic,j]:=song[i,j];
	      end;end;
    {L”schen}
            2: begin
	      von:=seqcounter;bis:=seqcounter+1;
              repeat
              Read_word(1,24,3, 'Daten l”schen von =',0,von,1,999);
              if r_char=#27 then abbruch:=true;
              if not abbruch then
	      Read_word(30,24,3,'Daten l”schen bis =',0,bis,1,999);
          	if von>bis then begin
			writeAt (1,24,red,black,' Fehler : Von>Bis !! ');
		        errorbeep;end;

              until (von<=bis) or abbruch;
              HorizLine(1,79,24,black,black,2);
              if not abbruch then
              begin
              for i:=von to bis do
	      for j:=1 to 9 do
	      song[i,j]:=0;
              schreibneu;
              end;
	      end;
    {Entfernen}
            3: begin
	      von:=seqcounter;bis:=seqcounter+1;
              repeat
              ok:=true;
              Read_word(1,24,3, 'Daten entfernen von =',0,von,1,999);
              if r_char=#27 then abbruch:=true;
              if not abbruch then
	      Read_word(30,24,3,'Daten entfernen bis =',0,bis,1,999);
          	if von>bis then begin
			writeAt (1,24,red,black,' Fehler : Von>Bis !! ');
		        errorbeep;ok:=false;end;
          	if bis>songlaenge then begin
			writeAt (1,24,red,black,' Fehler : Bis>Songl„nge !! ');
		        errorbeep;ok:=false;end;

              until ok or abbruch;
              HorizLine(1,79,24,black,black,2);
              if not abbruch then
              begin
              weg:=bis-von+1;
              for i:=von to songlaenge do
	      for j:=1 to 9 do
	      song[i,j]:=song[i+weg,j];
              end;
              schreibneu;
              dec (songlaenge,weg);
              schreibneu;
	      end;
    {šberschreiben von Puffer}
            4:
	      If  bufferlaenge>0 then
	      begin
	      bei:=seqcounter;
              Read_word(1,24,3, 'Daten berschrweiben von Puffer bei=',0,bei,1,999);
              HorizLine(1,79,24,black,black,2);
              if not abbruch then
              begin
              ic:=0;
              for i:=bei to bei+bufferlaenge-1 do
              begin
              inc(ic);
              if i>songlaenge then inc (songlaenge);
	      for j:=1 to 9 do
	      song[i,j]:=buffer[ic,j];
              end;
              schreibneu;
              end;
	      end
              else
                        begin
			writeAt (1,24,red,lightgray,' Fehler : Puffer leer ! ');
		        errorbeep;
                        HorizLine(1,79,24,black,black,2);
			end;

    {Einfgen von Puffer}
            5:
	      if bufferlaenge>0 then
	      begin
	      bei:=seqcounter;
              Read_word(1,24,3, 'Daten einfgen von Puffer bei=',0,bei,1,999);
              HorizLine(1,79,24,black,black,2);
              if not abbruch then
              begin
              songlaenge:=songlaenge+bufferlaenge-1;
              for i:=songlaenge downto bei do
                      begin
		      for j:=1 to 9 do
		      song[i+bufferlaenge,j]:=song[i,j];
                      end;

              ic:=0;
              for i:=bei to bei+bufferlaenge-1 do
              begin
              inc(ic);
	      for j:=1 to 9 do
	      song[i,j]:=buffer[ic,j];
              end;

              schreibneu;
              end;
	      end
                            else
                        begin
			writeAt (1,24,red,lightgray,' Fehler : Puffer leer !! ');
		        errorbeep;
                        HorizLine(1,79,24,black,black,2);
			end;


	    end;
    end;


end;
{*****+************************************************************}
Procedure Programm_steuerung;

var   dummyname: PathStr;
      dummystr : DirStr;
      FName    : NameStr;
      FExt     : ExtStr;
      Errcode:integer;

const      ueberschreib:boolean=true;

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
       Read_word(1,24,4,'Song geht bis Sequenz=',0,songlaenge,1,1000);
       if r_char<>#27 then
       Read_String(30,24,12,'Name der Songdatei =',0,liedname);
       HorizLine(1,79,24,black,black,2);

       if r_char<>#27 then
                          if FileExists(liedname) then
                          Read_jn(8,24,'Datei existiert bereits. šberschreiben (J/N) ?',0,ueberschreib);
                          if ueberschreib then
		   	       savesong(liedname);
       HorizLine(1,79,3,red,black,2);
       writecenter(3,blue,lightgray,' '+liedname+' ');
       HorizLine(1,79,24,black,black,2);

       end;

  #189:changeins;

  #190: playtest;

  #191:modify;
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
