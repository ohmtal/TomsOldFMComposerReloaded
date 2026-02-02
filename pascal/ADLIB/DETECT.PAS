uses dos,utils;
var  Step3,step7:byte;

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
{**********************************************************************}
Function Detect:boolean;
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

if (step3=0) and (step7=$C0) then Detect:=true else Detect:=false;
end;
{**********************************************************************}
begin
writeln(step3,'  ',step7);
writeln(detect);readln;
end.