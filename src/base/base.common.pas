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
    FVisible: Boolean;
    function GetString: string; virtual; abstract;
  public
    //function Clone: TBaseCard; virtual; abstract;

    property Visible: Boolean
      read FVisible
      write FVisible;
    property ToString: String
      read GetString;
  published
  end;

{ TBaseDeck }
  TBaseDeck = class(TObject)
  private
    function GetCard(AIndex: Integer): TBaseCard;
    function GetCount: Integer;
    function GetFirstCard: TbaseCard;
    function GetLastCard: TBaseCard;
  protected
    FCards: TFPObjectList;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Add(ACard: TBaseCard);
    function Draw: TBaseCard;
    procedure Clear;

    property Cards[AIndex: Integer]: TBaseCard
      read GetCard; default;
    //property BottomCard: TbaseCard
    //  read GetFirstCard;
    property TopCard: TBaseCard
      read GetLastCard;

    property Count: Integer
      read GetCount;
  published
  end;

const
  cSuitNames: array[TSuit] of string =
    ('1','2','♠', '♥', '♦', '♣');
  cRankNames: array[TRank] of string =
    ('J', 'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K');

implementation

{ TBaseDeck }

constructor TBaseDeck.Create;
begin
  // The Deck will always own the cards, hence it will free them
  FCards:= TFPObjectList.Create(False);
end;

destructor TBaseDeck.Destroy;
var index: Integer;
begin
  for index:= 0 to Pred(FCards.Count) do
    FCards[index].Free;
  FCards.Free;
  inherited Destroy;
end;

function TBaseDeck.GetCard(AIndex: Integer): TBaseCard;
begin
  Result:= (FCards[AIndex] as TBaseCard);
end;

function TBaseDeck.GetCount: Integer;
begin
  Result:= FCards.Count;
end;

function TBaseDeck.GetFirstCard: TbaseCard;
begin
  Result:= (FCards.First as TBaseCard)
end;

function TBaseDeck.GetLastCard: TBaseCard;
begin
  Result:= (FCards.Last as TBaseCard);
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
  FCards.Delete(Pred(FCards.Count));
end;

procedure TBaseDeck.Clear;
begin
  FCards.Clear;
end;

end.

