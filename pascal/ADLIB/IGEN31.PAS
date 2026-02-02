{$V-}  {turn of string checking}

Uses crt,dos,FastTTT5, Key,
     utils,readtpu,dirtPU,fmtpu;

var
  ENDFLAG:boolean;
  filename:string[12];
  Errcode:integer;



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


  ins_set[ChannelSet,0]:=$01;
  ins_set[ChannelSet,1]:=$01;
  ins_set[ChannelSet,2]:=$10;
  ins_set[ChannelSet,3]:=$00;
  ins_set[ChannelSet,4]:=$F;
  ins_set[ChannelSet,5]:=$F;
  ins_set[ChannelSet,6]:=$0;
  ins_set[ChannelSet,7]:=$0;
  ins_set[ChannelSet,8]:=$7;
  ins_set[ChannelSet,9]:=$7;
  ins_set[ChannelSet,10]:=$7;
  ins_set[ChannelSet,11]:=$7;
  ins_set[ChannelSet,12]:=$00;
  ins_set[ChannelSet,13]:=$00;
  ins_set[ChannelSet,14]:=$00;
  ins_set[ChannelSet,15]:=$00;
  ins_set[ChannelSet,16]:=$00;
  ins_set[ChannelSet,17]:=$00;
  ins_set[ChannelSet,18]:=$00;
  ins_set[ChannelSet,19]:=$00;
  ins_set[ChannelSet,20]:=$00;
  ins_set[ChannelSet,21]:=$00;
  ins_set[ChannelSet,22]:=$00;
  ins_set[ChannelSet,23]:=$00;


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
WriteAT(set_y[i mod 2],i div 2 +13,lightgray,red,Ins_set_text[i]+'  '+ItoS(Ins_set[ChannelSet,i]));
inc(i) ;
end;
setinstruments(channelSET);
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
      	playton(okt+ch-44,channelset);
        writecenter(9,yellow,blue,' Oktave ='+ItoS(okt div 12+1)+' TonNr:= '+ItoS(okt+ch-44)+' ');
	end
	else
        begin
	playton(-1,ChannelSet);
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
		Ins_set[ChannelSet,Ins_Set_pos],$0,ins_set_max[ins_set_pos]);

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

                          if R_Char <> #027 then begin saveins(Filename,ChannelSet);setdisplay;end;

                          end;
	#187:
                   begin
        	   dummyname := Display_Directory('*.FMI',Errcode);
                   if errcode=0 then begin
                   FSplit(dummyname, dummystr, FName, FExt);
		   filename:=FName+FExt;
		   loadins(Filename,Channelset);
        	 	setdisplay;
		   end;
                   end;

	#190:begin
	setinstruments(channelSET);
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
