{
  This unit gathers all the base objects
}
unit Base.Common;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, Contnrs
;

type
{ TSuit }
  TSuit = (suJoker1, suJoker2, suSpades, suHearts, suDiamonds, suClubs);

{ TRank }
  TRank = (raJoker, raAce, ra2, ra3, ra4, ra5, ra6, ra7, ra8, ra9, ra10, raJack, raQueen, raKing);

{ TBaseCard }
  TBaseCard = class(TObject)
  private
  protected
    function GetString: string; virtual; abstract;
  public
  published
  end;

{ TBaseDeck }
  TBaseDeck = class(TObject)
  private
    function GetCount: Integer;
  protected
    FCards: TFPObjectList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(ACard: TBaseCard);
    function Draw: TBaseCard;
    procedure Clear;

    property Count: Integer
      read GetCount;
  published
  end;

implementation

{ TBaseDeck }

function TBaseDeck.GetCount: Integer;
begin
  Result:= FCards.Count;
end;

constructor TBaseDeck.Create;
begin
  FCards:= TFPObjectList.Create(True);
end;

destructor TBaseDeck.Destroy;
begin
  FCards.Free;
  inherited Destroy;
end;

procedure TBaseDeck.Add(ACard: TBaseCard);
begin
  FCards.Add(ACard);
end;

function TBaseDeck.Draw: TBaseCard;
begin
  if FCards.Count = 0 then
    exit(nil);
  Result:= (FCards.Last as TBaseCard);
end;

procedure TBaseDeck.Clear;
begin
  FCards.Clear;
end;

end.

