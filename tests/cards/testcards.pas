unit TestCards;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Base.Common
, Cards.French
;

type
{ TFrameworkCards }
  TFrameworkCards= class(TTestCase)
  private
    FFrenchCard: TFrenchCard;
  protected
  public
  published
    procedure TestFrenchCardCreate;
  end;

implementation

procedure TFrameworkCards.TestFrenchCardCreate;
begin
  FFrenchCard:= TFrenchCard.Create(suSpades, raAce);
  try
    AssertEquals('The Ace of Spades', 'A♠', FFrenchCard.ToString);
  finally
    FFrenchCard.Free;
  end;
end;



initialization

  RegisterTest(TFrameworkCards);
end.

