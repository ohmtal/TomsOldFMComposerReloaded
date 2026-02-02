{$M 16000,0,240000}

uses bgifont,bgidriv,graph,mouse,dos,crt,utils,fmtpu;


const
     hochx:array[1..10]of word=(380,320,260,200,140,140,195,275,505,445);
     hochy:array[1..10]of  word=(150,150,150,145,125,70,30,23,150,150);
     Multi:array[1..8]of word=(0,1,2,4,8,16,32,64);

    c1=1;d1=2;e1=3;f1=4;g1=5;h1=6;c2=7;
    ton :array[1..8] of word= (131,147,165,175,196,220,247,262);
    fmton:array[1..8] of word=(36,37,38,39,40,41,42,48);
     xhalten:array[1..6] of word= (45,125,205,285,365,445);
     yhalten=325;

     filename:string[12]='full.ins';

var
    error,xm,ym:integer;
    p:pointer;
    hochdamit,maus_da,leftbutton,rightbutton:boolean;
   state:regs;
fmtrue:boolean;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure maus;
var
    size:word;
const
  hand : array[1..11] of PointType =
         ((x:400;y:300),
          (x:400;y:300+13),
          (x:400-3;y:300+13),
          (x:400-3;y:300+8),
          (x:400-5;y:300+8),
          (x:400-5;y:300+18),
          (x:400+12;y:300+18),
          (x:400+12;y:300+7),
          (x:400+3; y:300+7),
          (x:400+3; y:300),
          (x:400;y:300));


begin
 xm:=400;ym:=300;
 setcolor(blue);
 setfillstyle(solidfill,white);
  FillPoly(SizeOf(hand) div
            SizeOf(PointType), hand);

 line(xm+6,ym+7,xm+6,ym+12);
 line(xm+9,ym+7,xm+9,ym+12);
 line(xm+3,ym+7,xm+3,ym+12);


  Size := ImageSize(xm-5,ym,xm+15,ym+18);
  GetMem(P, Size); { Get memory from heap }
  GetImage(xm-5,ym,xm+15,ym+18,P^);

end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure stopsound(welchen:word);
var i:integer;
begin
if not fmtrue then nosound else playfm(-1,welchen);

end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure lesemaus;
var
i:byte;
middlebutton:boolean;
key:char;
xold,yold:integer;
ok:boolean;
begin
   PutImage(xm, ym, P^, xorput);
   xold:=xm;
   yold:=ym;

repeat;

leftbutton:=false;
if    keypressed then begin
                    key:=readkey;
                    case key of
                    #75: xm:=xm-19;
                    #77: xm:=xm+19;
                    #72: ym:=ym-19;
                    #80: ym:=ym+19;
                 #13,#32: leftbutton:=true;
                    #27: begin
                                            closegraph;
                                            clrscr;
                                            writeln('Ene mene mu und raus bist du .');
                                            writeln('Bis zum n„chsen mal !');

                                            stopsound(0);
                                            reset_adlib;
                                            halt(1);
                                            end;
                    end;
                    end
                    else
       if maus_da=true then  ReadMouse(xm,ym,leftbutton,rightbutton,middlebutton);
until (leftbutton=true) or (xm<>xold) or (ym<>yold) or (hochdamit=true) or (rightbutton=true);


   PutImage(xold, yold, P^, xorput);

end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }

procedure drueckenknoepfe(leuchten,beide:boolean);
var color:word;
begin
if leuchten=true then
                       color:=lightred
                       else
                       color:=red;

setcolor(darkgray);
    setfillstyle(solidfill,color);
    fillellipse(hochx[10],hochy[10],25,20);
    settextstyle( smallFont,0,4);
setcolor(yellow);
    outtextxy(hochx[10]-20,hochy[10]-6,'Drcken');


    end;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure hochknoepfe(var i:integer;leuchten:boolean);

var anz:string;
    color,position:word;
begin
if leuchten=true then
                       color:=lightgreen
                       else
                       color:=lightblue;

setfillstyle(solidfill,color);
    setcolor(darkgray);
    fillellipse(hochx[i],hochy[i],25,20);
    str(multi[i],anz);
    anz:=anz+('x');
    settextstyle( GothicFont,0,1);
    position:=hochx[i]+20-TextWidth(anz);
    outtextxy(position,hochy[i]-12,anz);
    end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure geschaftsound;
     begin

       stopsound(9);
       bremse(30);
       if not fmtrue then sound (80) else playfm(36,9);
       bremse (25);
       stopsound(9);

       bremse (1);
       if not fmtrue then sound (120) else playfm(38,9);
       bremse (10);
       stopsound(9);

       bremse (1);
       if not fmtrue then sound (100) else playfm(37,9);
       bremse (15) ;
       stopsound(9);

       bremse (1);
       if not fmtrue then sound (160) else playfm(40,9);
       bremse (30) ;
       stopsound(9);

       bremse (1);
       if not fmtrue then sound (180) else playfm(41,9);
       bremse (20) ;
       stopsound(9)       ;

       bremse (1);
       if not fmtrue then sound (160) else playfm(40,9);
       bremse (35) ;
       stopsound(9);

       bremse (1);
       if not fmtrue then sound (200) else playfm(42,9);
       bremse (40) ;
       stopsound(9);

       bremse (1);
       if not fmtrue then sound (210) else playfm(48,9);
       bremse (40) ;
       stopsound(9);
    end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure loosersound;
begin
                               stopsound(9);
                               bremse(30);
                               if not fmtrue then sound (80) else playfm(30,9);
                               bremse (30);
                               stopsound(9);

                               bremse (1);
                               if not fmtrue then sound (60) else playfm(33,9);
                               bremse (30);
                               stopsound(9);

                               bremse (1);
                               if not fmtrue then sound (35) else playfm(31,9);
                               bremse (50) ;
                               stopsound(9);
                               end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure hochdruecken;

var i,j,k:integer;
    treffer,verdrueckt:boolean;
    h,m,s,t:WORD;
    zeit,stop,sechzig:LONGINT;
    leitersound:array[1..8] of pointer;

begin
verdrueckt:=false;
hochdamit:=true;

treffer:=false;
j:=2;k:=1;
hochknoepfe(j,true);
drueckenknoepfe(true,false);

i:=2;

repeat
{****  Erste Fase ***}
hochknoepfe(i,false);

    sechzig:=60;
    GetTime(h,m,s,t);
    zeit:= ((h*sechzig+m)*sechzig+s)*100+t;
    stop:=zeit+i+random(30);


  hochknoepfe(k,true);
  if treffer=true then begin stop:=stop+(5+random(30));treffer:=false;end;

  REPEAT
if not fmtrue then sound(ton[i-1]) else
 playton(FMton[i-1],9 );

lesemaus;

         if leftbutton=true then
                            if (xm>hochx[10]-25) and (xm<hochx[10]+25) and (ym>hochy[10]-25) and (ym<hochy[10]+25)
                               then begin verdrueckt:=true;loosersound;end;





    GetTime(h,m,s,t);
    zeit:= ((h*sechzig+m)*sechzig+s)*100+t;
UNTIL zeit>stop;
   stopsound(9);


if (verdrueckt=false) then
   begin

{****  Zweite Fase ***}
   hochknoepfe(k,false);
   hochknoepfe(i,true);

    sechzig:=60;
    GetTime(h,m,s,t);
    zeit:= ((h*sechzig+m)*sechzig+s)*100+t;
    stop:=zeit+24-i-(random(7))+2;


  REPEAT
if not fmtrue then sound(ton[i]) else  playton(FMton[i],9);


lesemaus;

         if leftbutton=true then
                            begin
                            if (xm>hochx[10]-25) and (xm<hochx[10]+25) and (ym>hochy[10]-25) and (ym<hochy[10]+25)
                               then begin
                                    i:=i+1;
                                    bremse(30);
                                    treffer:=true;
                                    end;
                            end;

    GetTime(h,m,s,t);
    zeit:= ((h*sechzig+m)*sechzig+s)*100+t;

    UNTIL zeit>stop;
   stopsound(9);

  end;
until (verdrueckt=true) or (i=9) ;

if i=9 then geschaftsound;








if verdrueckt=false then
                 begin
                   end;


for j:=1 to 8 do hochknoepfe(j,false);
drueckenknoepfe(false,false);
hochdamit:=false;


end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }


var i,gd,gm:integer;
begin

  DetectGraph(GD, GM);

  if   (gd<>vga) and (gd<> ega) then
                               begin
                               clrscr;
                               writeln('Sorry , dieses Spiel ben”tigt EGA oder VGA Graphikkarte !');
                               halt(1);
                               end;
  gd:=ega;gm:=egahi;
  resetmouse(state);
  if state.ax=0 then maus_da := false else maus_da:=true;

  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then writeln;
  if RegisterBGIfont(@GothicFontProc) < 0 then  writeln;
  if RegisterBGIfont(@SmallFontProc) < 0 then   writeln;

  InitGraph(gd, Gm, '');
  if GraphResult <> grOk then halt(1);
  SetWriteMode(0);

fmtrue:=fmdetect;
Reset_adlib;
if fmtrue then begin if not loadsong('cbreak.fms') then halt;

		     end;
startsong(false);
repeat until songend;
stopsong;
maus;
cleardevice;
DefineVerticalRange(0,340);
DefineHorizontalRange(0,630);

Randomize;
for i:=1 to 8 do hochknoepfe(i,false);
repeat
               setcursorlocation(hochx[10]-20,hochy[10]-6);

hochdruecken;
until i=999;
closegraph;
Reset_adlib;
end.
