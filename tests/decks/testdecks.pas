unit TestDecks;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Base.Common
, Decks.French
;

type
{ TFrameworkDecks }
  TFrameworkDecks= class(TTestCase)
  private
    FFrenchDeck: TFrenchDeck;
  protected
  public
  published
    procedure TestFrenchDeckCreat;
  end;

implementation

procedure TFrameworkDecks.TestFrenchDeckCreat;
begin
  FFrenchDeck := TFrenchDeck.Create;
  try

  finally
    FFrenchDeck.Free;
  end;

end;



initialization

  RegisterTest(TFrameworkDecks);
end.

