program klondike;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes,
  { you can add units after this }
  uGame;

var
  Game: TKlondikeGame;

begin
  Game:= TKlondikeGame.Create;
  try
    Game.Run;
  finally
    Game.Free;
  end;
end.

