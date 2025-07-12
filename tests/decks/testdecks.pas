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
, Cards.French
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
    procedure TestFrenchDeckCreate;
    procedure TestFrenchDeckPopulate;
    procedure TestFrenchDeckShuffleRandomness;
  end;

implementation

procedure TFrameworkDecks.TestFrenchDeckCreate;
begin
  FFrenchDeck:= TFrenchDeck.Create;
  try
    AssertEquals('Deck count', 0, FFrenchDeck.Count);
  finally
    FFrenchDeck.Free;
  end;
end;

procedure TFrameworkDecks.TestFrenchDeckPopulate;
begin
  FFrenchDeck:= TFrenchDeck.Create;
  try
    FFrenchDeck.Populate;
    AssertEquals('Deck populated count', 52, FFrenchDeck.Count);
  finally
    FFrenchDeck.Free;
  end;
end;

procedure TFrameworkDecks.TestFrenchDeckShuffleRandomness;
var
  deck1, deck2: TFrenchDeck;
  index, diff: Integer;
begin
  deck1:= TFrenchDeck.Create;
  deck2:= TFrenchDeck.Create;
  try
    deck1.Populate;
    deck2.Populate;
    deck2.Shuffle;

    diff:= 0;
    for index:= 0 to Pred(deck1.Count) do
      if TFrenchCard(deck1[index]).ToString <> TFrenchCard(deck2[index]).ToString then
        Inc(diff);

    // Highly likely to differ after shuffle
    AssertTrue('Shuffle random', diff > 10);
  finally
    deck1.Free;
    deck2.Free;
  end;
end;



initialization

  RegisterTest(TFrameworkDecks);
end.

