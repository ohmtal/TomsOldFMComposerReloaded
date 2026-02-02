Program FM_demo;
{****************************************************************************
                               FM DEMO
                               ¯¯¯¯¯¯¯
     Hier werden die Funktionen von der FMTPU fÅr TurboPascal demonstriert.

****************************************************************************}


uses FMTPU,crt;

var i:byte;

{----------------------------------------------------------------------------}
function IToS(quelle: Longint): string;
{ Integer to String (fuer die writexy-procedure }
var
  s: string[11];
begin
  Str(quelle, s);
  IToS := s;
end;
{----------------------------------------------------------------------------}
procedure writexy(x,y:word;text:string);
begin
gotoxy(x,y);
writeln(text);
end;
{----------------------------------------------------------------------------}
  PROCEDURE WaitForKey;
  {
  Hier wird auf einen Tastendruck gewartet, wobei zunÑchst der Tastaturpuffer
  gelîscht wird. Das gedrÅckte Zeichen wird dabei aus dem Tastaturpuffer
  entfernt.
  }
  BEGIN
    textcolor(lightred+blink);
    Writexy (1,22,'>Taste<');
    delay(100);
    while  Keypressed do readkey;
    readKEY;
    textcolor(lightgray);
    Writexy (1,22,'       ');
  END;

{----------------------------------------------------------------------------}
{----------------------------------------------------------------------------}


begin


IF FMDETECT then {FMDETECT prueft ob ein FM Music Chip vorhanden ist}

	begin
{**********}
	clrscr;
	writexy (1,1,'   FMTPU DEMO ');
	writexy (1,2,'   ¯¯¯¯¯¯¯¯¯¯ ');
	writexy (1,4,'1. FM Chip erkennen...');
	writexy (1,5,'---------------------------------------------------------');
	writexy (1,7,'FM Music Chip gefunden');
	writexy (1,9,'Tolle Sache oder ?');
        waitforkey;
{**********}

	clrscr;
	writexy (1,1,'   FMTPU DEMO ');
	writexy (1,2,'   ¯¯¯¯¯¯¯¯¯¯ ');
	writexy (1,4,'2. Einzelne Instrumente laden und Tîne abspielen...');
	writexy (1,5,'---------------------------------------------------------');

	loadins('DEFAULT.FMI',1);
	writexy (1,6,'Die Instumentendatei DEFAULT.FMI wird auf Channel 1 geladen');
	writexy (1,7,'Es kînnen maximal 1-9 Channels belegt werden');

        PlayFM(60,1);
	writexy (1,9,'Ein C in Oktave 6 wird Åber Channel 1 ausgegeben');
        waitforkey;

        PlayFM(24,1);
	writexy(1,12,'Ein C in Oktave 3 wird Åber Channel 1 ausgegeben');
        waitforkey;
{**********}
	clrscr;
	writexy (1,1,'   FMTPU DEMO ');
	writexy (1,2,'   ¯¯¯¯¯¯¯¯¯¯ ');
	writexy (1,4,'3. Mit einer Schleife eine Frequenzausgabe ...');
	writexy (1,5,'---------------------------------------------------------');


        for i:=1 to 200 do
		begin
		FMSound(i,2,1);
	        writexy(1,11,'Soundausgabe in der Frequenz: '+itos(i)+', der Oktave 2 und Channel 1');
		delay(10);
		end;
        FMNoSound(1);
	writexy(1,12,'Ausgabe auf Channel 1 wird gestoppt');
        waitforkey;
{**********}

	clrscr;
	writexy (1,1,'   FMTPU DEMO ');
	writexy (1,2,'   ¯¯¯¯¯¯¯¯¯¯ ');
	writexy (1,4,'4. Ein mit dem Composer erstelltes Song laden und spielen ...');
	writexy (1,5,'--------------------------------------------------------------');
	LoadSong('TEST.FMS');
	writexy(1,7,'Jetzt wird die Songdatei TEST.FMS geladen');
        Startsong(TRUE);  {Er wird durch das TRUE auf wiederholen gesetzt}
	writexy(1,8,'Der Song wird im Hintergrund wiederholend abgespielt');
        waitforkey;
        Stopsong;
	writexy(1,10,'Jetzt wird der Song unterbrochen');
        waitforkey;
{**********}
	clrscr;
	writexy (1,1,'   FMTPU DEMO ');
	writexy (1,2,'   ¯¯¯¯¯¯¯¯¯¯ ');
	writexy (1,4,'5. Spielereien mit dem geladenen Song ');
	writexy (1,5,'--------------------------------------------------------------');

	loadins('SCHUSS2.FMI',9);
		{Die Instumentendatei SCHUSS2.FMI wird auf Channel 1 geladen}
		{Es kînnen maximal 1-9 Channels belegt werden}


        Startsong(FALSE); {Er wird durch das False nicht wiederholt}
	writexy(1,7,'Der Song wird neu gestartet. Er lÑuft solange bis er zu ende ist.');
	writexy(1,9,'Zwischendurch geben wir einen extra Ton auf Channel 9 ab.');
	writexy(1,11,'Ab der HÑlfte des Songs wird die Abspielgeschwindigkeit erhîht.');


        repeat
        {UND jetzt ein Trick in dem man andere Tîne auf durch den
         Song unbelegten Channels ausgeben kann}
        if songcounter mod 5 =1 then
                begin
		playton(24,9);
		writexy(1,22,'Ein C in Oktave 3 wird Åber Channel 9 ausgegeben');
        	end
		else
                begin
		writexy(1,22,'                                                ');
		FMNOSound(9);
                end;
        if Songcounter>= Songlaenge DIV 2 then Songspeed:=10;
	{Ab der HÑlfte des Songs wird die Abspielgeschwindigkeit erhîht.}

        writexy(1,21,'Position:'+itos(Songcounter)+' Gesammt :'+itos(SONGLAENGE)+' Speed:'+itos(songspeed));
	until songend or (keypressed and (readkey=#27));
	 {Ist die Variable Songend=TRUE oder es wird ESC gedrÅckt,
	  dann ist der Song beendet.}
{**********}
        Stopsong;
        Reset_FM; {Setzt den FM-Chip zurÅck}
{**********}
	clrscr;
        textcolor(lightblue+blink);
	writexy(22,12,'IS THAT HOT OR WHAT ?!');
        waitforkey
        end
        else
        writeln('FM Music Chip nicht gefunden');

end.