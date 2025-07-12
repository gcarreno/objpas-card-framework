unit Decks.French;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, Base.Common
, Cards.French
;

type
{ TFrenchDeck }
  TFrenchDeck = class(TBaseDeck)
  private
  protected
  public
    procedure PopulateFrenchDeck;
    procedure Shuffle;
  published
  end;

implementation

{ TFrenchDeck }

procedure TFrenchDeck.PopulateFrenchDeck;
var
  s: TSuit;
  r: TRank;
begin
  Clear;
  for s := suSpades to High(TSuit) do
    for r := raAce to High(TRank) do
      Add(TFrenchCard.Create(s, r));
end;

procedure TFrenchDeck.Shuffle;
var
  index, position: Integer;
begin
  Randomize;
  for index := Pred(FCards.Count) downto 1 do
  begin
    position := Random(index + 1);
    FCards.Exchange(index, position);
  end;
end;

end.

