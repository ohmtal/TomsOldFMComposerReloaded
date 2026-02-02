
uses key;
var ch:char;
begin
repeat
                Ch := GetKey;
         Writeln((Ord(Ch)));

until ch= #13;
end.