var ochah,ochal:byte;
    ochax:integer;
    ochcx:integer;
    altax:word;
   a:byte;
begin


for a:=$0 to $09 do
                begin
		asm
		mov ax,000A0h
		mov ah,a;
                mov ochal,ah
                mov ochax,ax
                end;
                writeln (ochax,'  ',ochal);
		end;

asm


mov  ax,0180h
mov ochah,ah
mov ochal,al
mov ochax,ax
mov ochcx,cx
{mov altax,ax;}
end;
writeln;
writeln;
writeln('AL=',ochal,' AH=',ochah,' AX=',ochax);
writeln('cX=',ochcx);
writeln('ENTER');
readln;
end.