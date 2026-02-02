{$V-}  {turn of string checking}

Uses crt,dos,FastTTT5, Key,
     utils,readtpu,dirtPU;

var
  ENDFLAG:boolean;
  filename:string[12];
  Errcode:integer;

  Ins_set:array[0..23] of byte;


const
ChannelSet:byte=1;

Ins_set_pos:byte=0;

set_y:array[0..1]of byte=(10,40);

Ins_set_max:array[0..23] of byte=($F,$F,$40,$40,$F,$F,$F,$F,$F,$F,
				  $F,$F,$3,$3,
				  $1,$1, $1,$1, $1,$1, $7,$1,$3,$3);
Ins_set_text:array[0..23] of string=
	('Modulator Frequency','Carrier Frequency   ',
	 'Modulator Output   ','Carrier Output      ',
	 'Modulator Attack   ','Carrier Attack      ',
	 'Modulator Decay    ','Carrier Decay       ',
	 'Modulator Sustain  ','Carrier Sustain     ',
	 'Modulator Release  ','Carrier Release     ',
	 'Modulator Waveform ','Carrier Waveform    ',
         'Modulator EG Typ   ','Carrier EG Typ      ',
         'Modulator Vibrato  ','Carrier Vibrato     ',
         'Modulator Amp Mod  ','Carrier Amp Mod     ',
	 'Feedback           ','Modulation Mode     ',
	 'Modulator Scaling  ','Carrier Scaling     ');

{Adr_add:array[1..9] of byte=($00,$01,$02,$08,$09,$0A,$10,$11,$12);}


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
procedure setintruments(channel:byte);
const
FM_adresses:array[1..8]of byte=($A0,$B0,$20,$40,$60,$80,$E0,$C0);
Adr_add:array[1..9] of byte=($00,$01,$02,$08,$09,$0A,$10,$11,$12);


var setter:byte;
    Msets,Csets:array[3..8] of byte;

begin

Msets[3]:=Ins_set[0]+Ins_set[14]*32+Ins_set[16]*64+Ins_set[18]*128;
Csets[3]:=Ins_set[1]+Ins_set[15]*32+Ins_set[17]*64+Ins_set[19]*128;

Msets[4]:=Ins_set[2]+32*Ins_set[22];
Csets[4]:=Ins_set[3]+32*Ins_set[23];

Msets[5]:=Ins_set[6]+16*Ins_set[4];
Csets[5]:=Ins_set[7]+16*Ins_set[5];

Msets[6]:=Ins_set[10]+16*Ins_set[8];
Csets[6]:=Ins_set[11]+16*Ins_set[9];

Msets[7]:=Ins_set[12];
Csets[7]:=Ins_set[13];

Msets[8]:=ins_set[21]+2*Ins_set[20];

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
procedure playFM(welchen:integer;channel:byte);

const FM_adresses:array[1..8]of byte=($A0,$B0,$20,$40,$60,$80,$E0,$C0);

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
{*****+************************************************************}

procedure InitMenu;

begin   
clrscr;
ENDFLAG:=false;
FBox(1,1,80,3,lightblue,red,2);
writecenter(2,black,lightgray,'Tom`s FM-Instrumenten Generator (c) 1994');
FBox(1,4,79,6,cyan,blue,1);
writeat(2,5,yellow,blue,'  F1 Laden      F2 Speichern   F4 Test     F9 ZurÅcksetzen     F10 Ende');
Rttt.BegCursor :=true;
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

end;
{*****+************************************************************}
Procedure defaultins;
begin
  filename:='default.FMI';


  ins_set[0]:=$01;
  ins_set[1]:=$01;
  ins_set[2]:=$10;
  ins_set[3]:=$00;
  ins_set[4]:=$F;
  ins_set[5]:=$F;
  ins_set[6]:=$0;
  ins_set[7]:=$0;
  ins_set[8]:=$7;
  ins_set[9]:=$7;
  ins_set[10]:=$7;
  ins_set[11]:=$7;
  ins_set[12]:=$00;
  ins_set[13]:=$00;
  ins_set[14]:=$00;
  ins_set[15]:=$00;
  ins_set[16]:=$00;
  ins_set[17]:=$00;
  ins_set[18]:=$00;
  ins_set[19]:=$00;
  ins_set[20]:=$00;
  ins_set[21]:=$00;
  ins_set[22]:=$00;
  ins_set[23]:=$00;


end;
{*****+************************************************************}
procedure setdisplay;
var i:word;
begin

FBox(8,10,66,12,blue,lightgray,1);
writecenter(11,black,lightgray,'Instrument in Buffer = '+filename);

FBox(8,12,66,25,blue,red,1);
i:=0;
while  i<24 do begin
WriteAT(set_y[i mod 2],i div 2 +13,lightgray,red,Ins_set_text[i]+'  '+ItoS(Ins_set[i]));
inc(i) ;
end;
setintruments(ChannelSet);
end;
{*****+************************************************************}
procedure saveins;
var
    datei: file;
    j:byte;
begin
  Assign(datei,filename);
  Rewrite(datei,1);
  For j:=0 to 23 do
  blockwrite(datei,Ins_Set[j],sizeof(Ins_set[j]));
  close(datei);


end;
{*****+************************************************************}
procedure loadins;
var
    datei: file;
    j:byte;
begin
  Assign(datei,filename);
  Reset(datei,1);
  For j:=0 to 23 do
  blockread(datei,Ins_Set[j],sizeof(Ins_set[j]));

  close(datei);
end;
{*****+************************************************************}
procedure Testins;
var
        dummy:char;
	ch:word;
	okt:word;
begin
	okt:=36;
	ch:=0;

FBox(1,7,79,9,red,black,1);
writecenter(7,blue,white,'INSTRUMENTEN TEST');
writecenter(8,white,black,'Tastaturreihe (y-m)=spielen , +/- = Oktave Ñndern, Esc=fertig');

repeat
ch:=port[$60];
dummy:=#0;
if keypressed THEN dummy:=readKEY;
case dummy of
	#45:if okt >11 then dec (okt,12);
	#43:if okt <61 then inc (okt,12);
	end;
if (ch>43) and (ch<51) then
        begin
      	playfm(okt+ch-44,ChannelSet);
        writecenter(9,yellow,blue,' Oktave ='+ItoS(okt div 12+1)+' TonNr:= '+ItoS(okt+ch-44)+' ');
	end
	else
        begin
	playfm(-1,ChannelSet);
        writecenter(9,yellow,blue,' Oktave ='+ItoS(okt div 12+1)+' TonNr:= -- ');
        end;

until ch=1;
FBox(0,7,79,9,black,black,0);
end;
{*****+************************************************************}
Procedure Menuread;
var   dummyname: PathStr;
      dummystr : DirStr;
      FName    : NameStr;
      FExt     : ExtStr;



begin


read_byte(set_y[(Ins_Set_pos) mod 2],Ins_set_pos div 2 +13,2,Ins_set_text[Ins_Set_pos]+'  ',0,
		Ins_set[Ins_Set_pos],$0,ins_set_max[ins_set_pos]);


case R_char of
         #200 :begin if (Ins_Set_pos>0)then  dec (Ins_Set_pos)
          			else Ins_Set_pos:=23;
	 	setdisplay;end;
	  #13,
	  #208 :begin if Ins_Set_pos<23 then inc (Ins_Set_pos)
          			else Ins_Set_pos:=0;

	  		setdisplay ;end;




	#188:		begin
                          Read_String_Upper(8,8,12,'Filename to Save',2,filename);
                            FBox(0,7,79,9,black,black,0);

                          if R_Char <> #027 then begin saveins;setdisplay;end;

                          end;
	#187:
                   begin
        	   dummyname := Display_Directory('*.FMI',Errcode);
                   if errcode=0 then begin
                   FSplit(dummyname, dummystr, FName, FExt);
		   filename:=FName+FExt;
		   loadins;
        	 	setdisplay;
		   end;
                   end;

	#190:begin
                          setintruments(ChannelSet);
                          testins;
                        end;


        #195:begin defaultins;	setdisplay;end;



	#196:begin beep;ENDFLAG:=true;end;
        end;

end;
{*****+************************************************************}
{*****+************************************************************}
{*****+************************************************************}

begin
reset_adlib;
INITmenu;
Defaultins;
Setdisplay;
repeat
menuread;
until endflag;
clrscr;
reset_adlib;
end.
