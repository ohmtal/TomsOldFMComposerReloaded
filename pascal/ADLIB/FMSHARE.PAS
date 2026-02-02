UNIT FMTPU;

INTERFACE

USES DOS;

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




     stop:longint=0;
     Sechzig:longint=60;
     SongCounter:word=0; {ZAHLVARIABLE BEI PLAYSONG}

     timer_int = $1C;



var

alt_int,neuer_int:Pointer; {Pointer fuer Playsonginterrupt}
Actual_ins:array[1..9] of string; {String VARIABLE FUER SONGINSTRUMENTE}
Ins_set:array[1..9,0..23] of byte;{BYTE VARIABLE FUER SONGINSTRUMENTE}
song:array[1..1000,1..9] of integer;{MAXIMALE SONGLAENGE = 1000 Schritte}

songlaenge:word; {Enthaelt die Laenge des geladenen Songs}
songspeed:byte;  {Enthaelt die Abspielgeschw. des geladenen Songs}

Time:LONGINT;h,m,s,t:WORD; {INTERNE ZEITVARIABLEN BEIM PLAYSONG}

ChannelCounter:word; {INTERNE ZAEHLVARIABLE}

songend,loop:boolean;{MERKER FUR LOOP und SONGende}

{*******************************}
Function  FMDetect:boolean; {Erkennt ob ein kompatibler FM - Chip enthalten
			     ist}
procedure reset_FM;   {Setzt den Chip in den Anfangszustand}

Function  loadsong(filename:string):boolean; {Laedt einen Song}
procedure startsong(loopit:boolean);  {Spielt einen Song ab.}
procedure stopsong; {Stopt die Songausgabe}

procedure playFM(welchen:integer;channel:byte); {Spielt einen Ton und
					         setzt in bei Neuaufruf
						 zurck}

procedure playton(welchen:integer;channel:byte);{Spielt einen Ton und
					         setzt in bei Neuaufruf
						 nicht zurck}

procedure FMSound(freq,oktave:byte;channel:byte);
		{Spielt einen Ton mit Angabe der Frequenz,Oktave und Channel}

procedure FMNoSound(channel:byte);{Setzt einen Channel zurck}

Function  loadins(filename:string;channel:byte):boolean;
	{Laedt eine Instrumentendatei auf einen Channel}

{INTERN bzw ALT}
procedure setinstruments(channel:byte);
{procedure playton(welchen:integer;channel:byte);}
procedure reset_adlib;
Function  saveins(Filename:String;Channel:byte):boolean;
function  saveSong(filename:string):boolean;





IMPLEMENTATION
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
  FUNCTION FileExists(name:STRING):BOOLEAN;
  VAR f:FILE OF WORD;
  BEGIN
    ASSIGN(f,name);
    {$I-}
    RESET(f);
    {$I+}
    IF IORESULT=0
      THEN BEGIN
        Close(f);
        FileExists:=TRUE;
      END ELSE FileExists:=FALSE;
  END;

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
function loadins(filename:string;channel:byte):boolean;
var
    datei: file;
    j:byte;
begin
{$I-}
  Assign(datei,filename);
  Reset(datei,1);
  For j:=0 to 23 do
  blockread(datei,Ins_Set[Channel,j],sizeof(Ins_set[Channel,j]));
  close(datei);
{$I+}
IF IORESULT=0 then begin loadins:=true ;setinstruments(channel);end else loadins:=false;
end;
{*****+************************************************************}
function saveins(Filename:String;channel:byte):boolean;
var
    datei: file;
    j:byte;
begin
{$I-}
  Assign(datei,filename);
  Rewrite(datei,1);
  For j:=0 to 23 do
  blockwrite(datei,Ins_Set[Channel,j],sizeof(Ins_set[Channel,j]));
  close(datei);
{$I+}
IF IORESULT=0 then saveins:=true else saveins:=false;

end;
{**********************************************************************}
Function loadsong(filename:string):boolean;
var
    datei: file;
    i,j:word;
    channel:byte;
begin
IF not FileExists(Filename) then begin loadsong:=false;exit;end;
  reset_adlib;

{$I-}
  Assign(datei,filename);
  Reset(datei,1);
For channel:=1 to 9 do
  begin

  blockread(datei,Actual_ins[channel],sizeof(Actual_ins[channel]));

  For j:=0 to 23 do
  blockread(datei,Ins_Set[channel,j],sizeof(Ins_set[channel,j]));
  end;

  blockread(datei,songspeed,sizeof(songspeed));
  blockread(datei,songlaenge,sizeof(songlaenge));
  for i:=1 to songlaenge do
   for j:=1 to 9 do
      blockread(datei,song[i,j],sizeof(song[i,j]));
  close(datei);
{$I+}
IF IORESULT=0 then loadsong:=true else loadsong:=false;

for i:=1 to 9 do setinstruments(i);

end;
{*****+************************************************************}
function saveSong(filename:string):boolean;
var
    datei: file;
    channel,i,j:word;
begin

{$I-}
  Assign(datei,filename);
  Rewrite(datei,1);

For channel:=1 to 9 do
  begin

  blockwrite(datei,Actual_ins[channel],sizeof(Actual_ins[channel]));

  For j:=0 to 23 do
  blockwrite(datei,Ins_Set[channel,j],sizeof(Ins_set[channel,j]));
  end;


  blockwrite(datei,songspeed,sizeof(songspeed));
  blockwrite(datei,songlaenge,sizeof(songlaenge));


  for i:=1 to songlaenge do
   for j:=1 to 9 do
      blockwrite(datei,song[i,j],sizeof(song[i,j]));

  close(datei);
IF IORESULT=0 then savesong:=true else savesong:=false;

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
procedure playton(welchen:integer;channel:byte);
begin
if welchen>0 then
 begin
 SendData(FM_adresses[1]+channel-1,tonleiter[welchen,2]);
 SendData(FM_adresses[2]+channel-1,tonleiter[welchen,1]);
 end;

if welchen=-1 then
 begin
 SendData(FM_adresses[2]+channel-1,$00);
 end;
end;
{**********************************************************************}
procedure FMSound(freq,oktave:byte;channel:byte);
var oktadr:byte;
const oktern:array[1..6] of byte=(37,38,41,42,49,50);
begin
 if oktave>6 then oktave:=6;
 oktadr:=oktern[oktave];
 SendData(FM_adresses[2]+channel-1,$00);
 SendData(FM_adresses[1]+channel-1,freq);
 SendData(FM_adresses[2]+channel-1,Oktadr);
end;
{**********************************************************************}
procedure FMNoSound(channel:byte);
begin
 SendData(FM_adresses[2]+channel-1,$00);
end;
{**********************************************************************}
procedure stopsong;
         begin
         songend:=true;
	 songcounter:=0;
	 for ChannelCounter:=1 to 9 do
	    playfm(-1,ChannelCounter);
         SetIntVec(timer_int,alt_int);
         end;
{**********************************************************************}
procedure playsong;interrupt;
begin


    GetTime(h,m,s,t);
    Time:= ((h*sechzig+m)*sechzig+s)*100+t;

If (Time>stop) and (Songcounter<=songlaenge) then  begin
	    stop:=Time+songspeed;
		INC(Songcounter);
		if ( Songcounter >= songlaenge) then
          		if loop then Songcounter:=1 else stopsong;
		 for ChannelCounter:=1 to 9 do
		    playfm(song[Songcounter,ChannelCounter],ChannelCounter);
  end;
end;
{**********************************************************************}
procedure startsong(loopit:boolean);
begin

         songend:=false;
         if loopit then loop:=true else loop:=false;
         songcounter:=0;
	 GetIntVec(timer_int,alt_int);
         neuer_int:= @Playsong;
         SetIntVec(timer_int,neuer_int);
end;

{**********************************************************************}
procedure reset_adlib;
var a:BYTE;
begin
for a:=$01 to $F5 do SendData(a,$00);
end;
{**********************************************************************}
procedure reset_FM;
var a:BYTE;
begin
for a:=$01 to $F5 do SendData(a,$00);
end;

{**********************************************************************}
Function FMDetect:boolean;
var Step3,step7:byte;
begin
step3:=0;
step7:=0;

Reset_adlib;
SendData($04,$60);
SendData($04,$80);
SendData($04,$60);
step3:=Port[$388];
SendData($02,$FF);
SendData($04,$21);
bremse(1);
step7:=port[$388];

step3:=step3+$Fa;
step7:=step7+$Fa;

if ((step3=0) and (step7=192)) or ((step3=250) and (step7=186)) then FMDetect:=true else FMDetect:=false;
end;
{**********************************************************************}
{**********************************************************************}

begin
writeln;writeln;writeln;writeln;writeln;writeln;writeln;
Write('SHAREWARE VERSION von FM-Developer Kit (c)1994 Fun Time Games');
write ('.');beep;bremse(100);
write ('.');beep;bremse(100);
write ('.');beep;bremse(100);
write ('.');beep;bremse(100);
write ('.');beep;bremse(100);
write ('.');beep;bremse(100);
end.