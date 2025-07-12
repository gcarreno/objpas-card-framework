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
var
  want: String;
begin
  FFrenchCard:= TFrenchCard.Create(suSpades, raAce, True);
  want:= Format('%s%s', [cRankNames[raAce], cSuitNames[suSpades]]);
  try
    AssertEquals('The Ace of Spades', want, FFrenchCard.ToString);
    AssertTrue('Visibility', FFrenchCard.Visible);
    AssertEquals('Image Name', EmptyStr, FFrenchCard.ImageName);
    AssertNull('Image Data', FFrenchCard.ImageData);
    AssertFalse('Contains Image', FFrenchCard.ContainsImage);
  finally
    FFrenchCard.Free;
  end;
end;



initialization

  RegisterTest(TFrameworkCards);
end.

