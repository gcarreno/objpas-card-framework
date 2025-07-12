unit TestPiles;

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
, Piles.Pile
;

type

  { TFrameworkPiles }

  TFrameworkPiles= class(TTestCase)
  private
    FPile: TPile;
  protected
  public
  published
    procedure TestPileCreate;
    procedure TestPileAddRemoveFrenchCard;
    procedure TestMovementPushPop;
  end;

implementation

procedure TFrameworkPiles.TestPileCreate;
begin
  FPile:= TPile.Create;
  try
    AssertEquals('Pile count', 0, FPile.Count);
  finally
    FPile.Free;
  end;
end;

procedure TFrameworkPiles.TestPileAddRemoveFrenchCard;
var
  card: TFrenchCard;
  want: String;
begin
  FPile := TPile.Create;
  card := TFrenchCard.Create(suHearts, raQueen, True);
  want:= Format('%s%s', [cRankNames[raQueen], cSuitNames[suHearts]]);
  try
    FPile.AddCard(card);
    AssertEquals('Pile count', 1, FPile.Count);
    AssertEquals('Pile Card to string', want, FPile.RemoveTopCard.ToString);
    AssertEquals('Pile count', 0, FPile.Count);
  finally
    FPile.Free;
  end;
end;

procedure TFrameworkPiles.TestMovementPushPop;
var
  stack: TMovementStack;
  move: TMovement;
  retrieved: TMovement;
  fromPile, toPile: TPile;
  want: String;
begin
  stack := TMovementStack.Create;
  fromPile := TPile.Create;
  toPile := TPile.Create;
  try
    move.Card := TFrenchCard.Create(suClubs, raKing, True);
    move.FromPile := fromPile;
    move.ToPile := toPile;
    stack.Push(move);

    AssertTrue('Stack popped', stack.Pop(retrieved));
    want:= Format('%s%s', [cRankNames[raKing], cSuitNames[suClubs]]);
    AssertEquals('King of clubs', want, retrieved.Card.ToString);
  finally
    retrieved.Card.Free;
    fromPile.Free;
    toPile.Free;
    stack.Free;
  end;
end;



initialization

  RegisterTest(TFrameworkPiles);
end.

