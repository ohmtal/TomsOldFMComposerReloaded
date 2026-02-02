{$V-}  {turn of string checking}

Uses crt,dos,FastTTT5,utils,readtpu,dirtPU,menuttt5;

const
FM_adresses:array[1..8]of byte=($A0,$B0,$20,$40,$60,$80,$E0,$C0);
Adr_add:array[1..9] of byte=($00,$01,$02,$08,$09,$0A,$10,$11,$12);


tonleiter:array[1..84,1..2] of byte= (
                                      {fehlt}
                                      ($21,$81),
                                      ($21,$b0),
                                      ($21,$ca),
                                      ($22,$02),
                                      ($22,$41),
                                      ($22,$87),
                                      ($21,$6B),
                                      ($21,$98),
                                      ($21,$e5),
                                      ($22,$20),
                                      ($22,$63),

                                      ($22,$AE),
                                      ($25,$81),
                                      ($25,$b0),
                                      ($25,$ca),
                                      ($26,$02),
                                      ($26,$41),
                                      ($26,$87),
                                      ($25,$6B),
                                      ($25,$98),
                                      ($25,$e5),
                                      ($26,$20),
                                      ($26,$63),


                                      ($26,$AE),
                                      ($29,$81),
                                      ($29,$b0),
                                      ($29,$ca),
                                      ($2a,$02),
                                      ($2a,$41),
                                      ($2a,$87),
                                      ($29,$6B),
                                      ($29,$98),
                                      ($29,$e5),
                                      ($2a,$20),
                                      ($2a,$63),

                                      ($2a,$AE),
                                      ($2d,$81),
                                      ($2d,$b0),
                                      ($2d,$ca),
                                      ($2e,$02),
                                      ($2e,$41),
                                      ($2e,$87),
                                      ($2d,$6B),
                                      ($2d,$98),
                                      ($2d,$e5),
                                      ($2e,$20),
                                      ($2e,$63),

                                      ($2e,$AE),
                                      ($31,$81),
                                      ($31,$b0),
                                      ($31,$ca),
                                      ($32,$02),
                                      ($32,$41),
                                      ($32,$87),
                                      ($31,$6B),
                                      ($31,$98),
                                      ($31,$e5),
                                      ($32,$20),
                                      ($32,$63),

                                      ($32,$AE),
                                      ($35,$81),
                                      ($35,$b0),
                                      ($35,$ca),
                                      ($36,$02),
                                      ($36,$41),
                                      ($36,$87),
                                      ($35,$6B),
                                      ($35,$98),
                                      ($35,$e5),
                                      ($36,$20),
                                      ($36,$63),

                                      ($36,$AE),
                                      ($39,$81),
                                      ($39,$b0),
                                      ($39,$ca),
                                      ($3a,$02),
                                      ($3a,$41),
                                      ($3a,$87),
                                      ($39,$6B),
                                      ($39,$98),
                                      ($39,$e5),
                                      ($3a,$20),
                                      ($3a,$63),

                                      ($3a,$Ae)
				      );



default_ins:array[1..9] of string=('SYSN1.FMI','SYNT2.FMI','BANJO01.FMI',
				   'PACMAN01.FMI','BELL.FMI','LANGSAM1.FMI',
                                   'SCHUSS2.FMI','HIHAT.FMI','BASDRUM2.FMI');



type v_B_rec=record
	     von,
             bis:word;
             end;

var
song:array[1..1000,1..9] of integer;
songlaenge:word;
songspeed:byte;
seqcounter,aktspur:word;

Liedname:string[12];

Ins_set:array[1..9,0..23] of byte;


{**********************************************************************}
{*****+************************************************************}
procedure SendData(Registers,Value:byte);ASSEMBLER;

Asm
 MOV DX, 0388h   {address port = 388h.. single OPL2/mono}
 MOV AL, registers
 OUT DX, AL      {send register info to address port}

 MOV AH, 0       {set counter to 0}
@Delay1:         {delay 3.3ms (6 port reads)}
 IN  AL,  DX     {read address port}
 INC AH          {increment counter}
 CMP AH, 6       {there yet?}
 JNE @Delay1     {no.. read port again}

 MOV DX, 0389h   {data port = 389h.. single OPL2/mono}
 MOV AL, Value
 OUT DX, AL      {send register value to data port}

 MOV AH, 0       {set counter to 0}
 MOV DX, 0388h   {set address port for delay}
@Delay2:         {delay 23ms (35 port reads)}
 IN  AL,  DX     {read address port}
 INC AH          {increment counter}
 CMP AH, 35      {done yet?}
 JNE @Delay2     {no.. read port again}
 {ready for next port write}
End;
{**********************************************************************}
procedure reset_adlib;
var a:BYTE;
begin
for a:=$01 to $F5 do SendData(a,$00);
end;

{**********************************************************************}
procedure setinstruments(channel:byte);

var setah,carrier_al,modulator_al,setter:byte;
    Msets,Csets:array[3..8] of byte;
begin
Msets[3]:=Ins_set[channel,0]+Ins_set[channel,14]*32+Ins_set[channel,16]*64+Ins_set[channel,18]*128;
Csets[3]:=Ins_set[channel,1]+Ins_set[channel,15]*32+Ins_set[channel,17]*64+Ins_set[channel,19]*128;

Msets[4]:=Ins_set[channel,2]+32*Ins_set[channel,22];
Csets[4]:=Ins_set[Channel,3]+32*Ins_set[Channel,23];

Msets[5]:=Ins_set[channel,6]+16*Ins_set[channel,4];
Csets[5]:=Ins_set[channel,7]+16*Ins_set[channel,5];

Msets[6]:=Ins_set[channel,10]+16*Ins_set[channel,8];
Csets[6]:=Ins_set[channel,11]+16*Ins_set[channel,9];

Msets[7]:=Ins_set[channel,12];
Csets[7]:=Ins_set[channel,13];

Msets[8]:=ins_set[Channel,21]+2*Ins_set[Channel,20];


        {NORMAL SETTINGS}
        SendData($01,$20);
	SendData($BD,$C0);

        {Instruments SETTINGS}
for setter:=3 to 7 do
begin
SendData(FM_adresses[setter]+Adr_add[Channel],Msets[setter]);
SendData(FM_adresses[setter]+Adr_add[Channel]+3,Csets[setter]);
end;
SendData(FM_adresses[8]+Adr_add[Channel],Msets[8]);

end;

{**********************************************************************}
procedure loadins(filename:string;channel:byte);
var
    datei: file;
    j:byte;
begin
  Assign(datei,filename);
  Reset(datei,1);
  For j:=0 to 23 do
  blockread(datei,Ins_Set[Channel,j],sizeof(Ins_set[Channel,j]));
  close(datei);
end;
{**********************************************************************}
procedure playFM(welchen:integer;channel:byte);
begin
if welchen>0 then
 begin
 SendData(FM_adresses[2]+channel-1,$00);
 SendData(FM_adresses[1]+channel-1,tonleiter[welchen,2]);
 SendData(FM_adresses[2]+channel-1,tonleiter[welchen,1]);
 end;

if welchen=-1 then
 begin
 SendData(FM_adresses[2]+channel-1,$00);
 end;
end;



{**********************************************************************}
Procedure playsong;

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
{**********************************************************************}
{**********************************************************************}
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
{**********************************************************************}
procedure loadsong(filename:string);
var
    datei: file;
    i,j:word;
    channel:byte;
begin
  Assign(datei,filename);
  Reset(datei,1);
For channel:=1 to 9 do
  begin

  blockread(datei,default_ins[channel],sizeof(Default_ins[channel]));

  For j:=0 to 23 do
  blockread(datei,Ins_Set[channel,j],sizeof(Ins_set[channel,j]));
  end;

  blockread(datei,songspeed,sizeof(songspeed));
  blockread(datei,songlaenge,sizeof(songlaenge));
  for i:=1 to songlaenge do
   for j:=1 to 9 do
      blockread(datei,song[i,j],sizeof(song[i,j]));

  close(datei);
end;
{*****+************************************************************}
procedure save(filename:string);
var
    datei: file;
    channel,i,j:word;
begin

  Assign(datei,filename);
  Rewrite(datei,1);

For channel:=1 to 9 do
  begin

  blockwrite(datei,default_ins[channel],sizeof(Default_ins[channel]));

  For j:=0 to 23 do
  blockwrite(datei,Ins_Set[channel,j],sizeof(Ins_set[channel,j]));
  end;


  blockwrite(datei,songspeed,sizeof(songspeed));
  blockwrite(datei,songlaenge,sizeof(songlaenge));


  for i:=1 to songlaenge do
   for j:=1 to 9 do
      blockwrite(datei,song[i,j],sizeof(song[i,j]));

  close(datei);
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
writecenter(1,red,lightgray,'Tom`s Composer for FM Developer Kit');
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

       save(liedname);
       HorizLine(1,79,3,red,black,2);
       writecenter(3,blue,lightgray,' '+liedname+' ');
       HorizLine(1,79,24,black,black,2);

       end;

  #189:changeins;

  #190: playsong;

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
