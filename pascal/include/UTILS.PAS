UNIT UTILS;

INTERFACE
uses dos,crt,key,strntpu,cputype;


procedure Bremse(Hunderstel:longint);{ZeitabhÑniges Delay}
function  gettimer:longint;
procedure Beep ; {Erzeug einen Peep Ton}
procedure Errorbeep;
procedure short_Errorbeep;
procedure longbeep;
procedure wauw;
procedure zisch;

function ItoS(quelle:longint):string ; {Erzeug einen Peep Ton}
function StoI(quelle:String;Var Ziel:longint):boolean;
function StoI2(quelle:String):longint;
function StoBYTE(quelle:String;Var Ziel:byte):boolean;
function RToS(quelle: real;vorkomma,nachkomma:byte): string;
function StoR(input:string):real;
function BtoS(input:boolean):string;
Function Upper(Str:string):string;
function LeadingZero(w : Word) : String;

procedure clearkbd;

Function AKTDate:String;
Function AKTTIME:String;


procedure writexy(x,y:word;text:string);
PROCEDURE Cursor_an;
PROCEDURE Cursor_aus;
FUNCTION FileExists(name:STRING):BOOLEAN;
PROCEDURE WaitForKey;
Function Test286: Boolean;
Function whatcpu:string;

function getfilename(all:string):string;
function getpfad(all:string):string;
function getdrive(all:string):string;
function getext(all:string):string;
function getname(all:string):string;


var
      MaxCursor                     : BYTE;
      CursorTopRow, CursorBottomRow : BYTE;


IMPLEMENTATION

VAR   Regs                    : Registers; 
      CursorStart, CursorEnd  : Byte;      

{----------------------------------------------------------------------------}
function  gettimer:longint;
VAR hour,min,sec,thou:WORD;
const sechzig=60;
begin
    GetTime(hour,min,sec,thou);
    gettimer:= ((hour*sechzig+min)*sechzig+sec)*100+thou;
end;
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
procedure beep;
begin
sound(100);Delay(20);nosound;
end;

{----------------------------------------------------------------------------}
procedure short_Errorbeep;
var i:byte ;
begin
      FOR I:=1 TO 3 DO
        BEGIN
          SOUND(528); bremse(1);
          SOUND(1056); bremse(1);
        END;nosound;
end;
{----------------------------------------------------------------------------}
procedure Errorbeep;
var i:byte ;
begin
      FOR I:=1 TO 10 DO
        BEGIN
          SOUND(528); bremse(2);
          SOUND(1056); bremse(2);
        END;nosound;
end;

{----------------------------------------------------------------------------}
function IToS(quelle: Longint): string;
{ Convert any Integer type to a string }
var
  s: string[11];
begin
  Str(quelle, s);
  IToS := s;
end;
{----------------------------------------------------------------------------}
function StoI(quelle:String;Var Ziel:longint):boolean;
var dummy:integer;
begin
  Val(quelle,Ziel, dummy);
if dummy <>0 then stoI:=false else stoI:=true;
end;

{----------------------------------------------------------------------------}
function StoBYTE(quelle:String;Var Ziel:byte):boolean;
var dummy:integer;
begin
  Val(quelle,Ziel, dummy);
if dummy <>0 then stoBYTE:=false else stoBYTE:=true;
end;

{----------------------------------------------------------------------------}
function StoI2(quelle:String):longint;
var dummy2:string;
    dcount:byte;
    dummyint:longint;
    err:integer;
begin

dummy2:='';dcount:=1;
while quelle[dcount]<>' ' do begin dummy2:=dummy2+quelle[dcount]; inc(dcount);end;
val(DUMMY2,dummyint,ERR);

  Val(dummy2,dummyint, err);
if err<>0 then repeat beep; longbeep;writeln('INTEGER ERROR : *',dummy2,'*') until  keypressed;
Stoi2:=dummyint;
end;


{----------------------------------------------------------------------------}
function StoR(input:string):real;
var 
    dummyreal:real;
    err:integer;
begin
input:=Strip('B',' ',input);
val(input,dummyreal,ERR);
if err<>0 then repeat beep; longbeep;writeln('REAL ERROR : *',input,'*') until  keypressed;
StoR:=dummyreal;

end;
{----------------------------------------------------------------------------}
function RToS(quelle: real;vorkomma,nachkomma:byte): string;
{ Convert any Integer type to a string }
var
  s: string[11];
begin
  
  Str(quelle:vorkomma:nachkomma, s);
  RToS := s;
end;

{----------------------------------------------------------------------------}
function BtoS(input:boolean):string;
begin
if input=true then btos:='TRUE' else BTOS:='FALSE';
end;
{----------------------------------------------------------------------------}

Function Upper(Str:string):string;
var
  I : integer;
begin
    For I := 1 to length(Str) do
        Str[I] := Upcase(Str[I]);
    Upper := Str;
end;  {Func Upper}
{----------------------------------------------------------------------------}

function LeadingZero(w : Word) : String;
var
  s : String;
begin
  Str(w:0,s);
  if Length(s) = 1 then
    s := '0' + s;
  LeadingZero := s;
end;

{****************************************************************}
function getfilename(all:string):string;
begin
while Pos('\', all) > 0 do delete(all,1,1);
getfilename:=all;
end;
{****************************************************************}
function getpfad(all:string):string;
const
	tempstr:string='';
begin
while Pos('\', all) > 0 do begin tempstr:=tempstr+copy(all,1,1);delete(all,1,1);end;
getpfad:=tempstr;
end;
{****************************************************************}
function getdrive(all:string):string;
begin
delete(all,3,length(all)-2);
getdrive:=all;
end;
{****************************************************************}
function getext(all:string):string;
begin
delete(all,1,length(all)-3);
getext:=all;
end;
{****************************************************************}
function getname(all:string):string;
begin
while Pos('\', all) > 0 do delete(all,1,1);
delete(all,length(all)-3,length(all));

getname:=all;
end;
{----------------------------------------------------------------------------}
{----------------------------------------------------------------------------}
Function AKTDate:String;
const
  days : array [0..6] of String[10] =
    ('Sonntag','Montag','Dienstag',
     'Mittwoch','Donnerstag','Freitag',
     'Samstag');
var
  y, m, d, dow : Word;

begin
GetDate(y,m,d,dow);
AKTDATE:=days[dow]+', '+Itos(d)+'.'+Itos(m)+'.'+Itos(y);
end;
{----------------------------------------------------------------------------}
Function AKTTIME:String;
var
  h, m, s, hund : Word;
begin
GetTime(h,m,s,hund);
AKTTIME:=LeadingZero(h)+':'+LeadingZero(m)+':'+LeadingZero(s);

end;
{----------------------------------------------------------------------------}
{----------------------------------------------------------------------------}
procedure clearkbd;
var nirvana:char;
begin
delay(100);
while  Keypressed do nirvana:=readkey;
end;

{----------------------------------------------------------------------------}
procedure writexy(x,y:word;text:string);
begin
gotoxy(x,y);
writeln(text);
end;
{----------------------------------------------------------------------------}
PROCEDURE Cursor_aus;

VAR  min,max : BYTE;

BEGIN
  IF mem[$40:$49] IN [$7..$10] { ueberprueft ob der Videomodus zwischen 7    }
    THEN                       { und 10 hex liegt.                           }
      BEGIN
        min                   := 14;    { wenn ja .. }
        max                   := 14;
        MaxCursor             := 14;
      END
    ELSE
      BEGIN
        min                   := 8;     { wenn nein .. }
        max                   := 0;
        MaxCursor             := 8;
      END;
  CursorBottomRow := mem[$40:$61];      { holen der momentan gesetzten Werte }
  CursorTopRow := mem[$40:$60];
  Regs.ah  := 1;                        { setzen der Register                }
  Regs.ch  := min;
  Regs.cl  := max;
  INTR($10,Regs);                       { Aufruf des Interrupts 10 hex       }
END;

{----------------------------------------------------------------------------}
PROCEDURE Get_Default_Cursor;

BEGIN
  CursorStart  := mem[$40:$61]; { Greift auf die Low Memory Adresse $40:$61  }
                                { zu und holt den Wert fuer die untere Cursor}
                                { Scanline.                                  }
  CursorEnd    := mem[$40:$60]; { Greift auf die Low Memory Adresse $40:$60  }
                                { zu und holt den Wert fuer die obere Cursor }
                                { Scanline.                                  }
END;

{----------------------------------------------------------------------------}

PROCEDURE Cursor_an;

BEGIN
  Regs.ah := 1;                   { setzen der Register                      }
  Regs.ch := CursorBottomRow;
  Regs.cl := CursorTopRow;
  INTR($10,Regs);                 { Aufruf des Interrrupts 10 hex            }
END;

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
{----------------------------------------------------------------------------}
  PROCEDURE WaitForKey;
  {
  Hier wird auf einen Tastendruck gewartet, wobei zunÑchst der Tastaturpuffer
  gelîscht wird. Das gedrÅckte Zeichen wird dabei aus dem Tastaturpuffer
  entfernt.
  }
  VAR a:CHAR;
  BEGIN
    a:=#0;
    clearkbd;
     a:=getKEY;
  END;

{----------------------------------------------------------------------------}

procedure longbeep;
var i:word;
begin
for i:=500 downto 100 do
	begin
	sound(i);
	delay(2);
	nosound;
	end;
nosound;
end;
{****************************************************************************}
procedure wauw;
var i:word;
begin
for i:=500 downto 100 do
	begin
	sound(i);
	delay(2);
	nosound;
	end;
nosound;
end;
{****************************************************************************}
procedure zisch;
var i:word;
begin
for i:=100 to 200 do
	begin
	if i mod(10) =1 then sound(i);
	delay(1);
	end;
nosound;
end;

{----------------------------------------------------------------------------}
Function Test286:boolean;

function Is286Able: Boolean; assembler;
asm
        PUSHF
        POP     BX
        AND     BX,0FFFH
        PUSH    BX
        POPF
        PUSHF
        POP     BX
        AND     BX,0F000H
        CMP     BX,0F000H
        MOV     AX,0
        JZ      @@1
        MOV     AX,1
@@1:
end;
begin
test286:=Is286Able;
end;
{----------------------------------------------------------------------------}
Function whatcpu:string;
begin
whatcpu:=processor;
end;
{----------------------------------------------------------------------------}
begin
   Get_Default_Cursor;
End.