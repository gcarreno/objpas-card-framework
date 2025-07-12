unit Piles.Pile;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, Contnrs
, Base.Common
;

type
{ TPile }
  TPile = class(TObject)
  private
    FCards: TFPObjectList;
    function GetCard(AIndex: Integer): TBaseCard;
    function GetCount: Integer;
    function GetFirstCard: TbaseCard;
    function GetLastCard: TBaseCard;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddCard(ACard: TBaseCard);
    function RemoveTopCard: TBaseCard;

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

{ TMovement }
  TMovement = record
    FromPile: TPile;
    ToPile: TPile;
    Card: TBaseCard;
  end;

{ TMovementStack — undo-able movement stack }
  TMovementStack = class(Tobject)
  private
    FStack: array of TMovement;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure Push(AMove: TMovement);
    function Pop(out AMove: TMovement): Boolean;
  published
  end;


implementation

{ TPile }

constructor TPile.Create;
begin
  // Since we are clonning the cards, we can own them
  FCards:= TFPObjectList.Create(True);
end;

destructor TPile.Destroy;
begin
  FCards.Free;
  inherited Destroy;
end;

function TPile.GetCount: Integer;
begin
  Result:= FCards.Count;
end;

function TPile.GetFirstCard: TbaseCard;
begin
  Result:= (FCards.First as TBaseCard)
end;

function TPile.GetLastCard: TBaseCard;
begin
  Result:= (FCards.Last as TBaseCard)
end;

function TPile.GetCard(AIndex: Integer): TBaseCard;
begin
  Result:= (FCards[AIndex] as TBaseCard);
end;

procedure TPile.AddCard(ACard: TBaseCard);
begin
  FCards.Add(ACard);
end;

function TPile.RemoveTopCard: TBaseCard;
begin
  if FCards.Count = 0 then
    exit(nil);
  // Since we own the cards, we need to clone the card because the next
  // line would cause an AV elsewhere
  Result := (FCards.Last as TBaseCard).Clone;
  FCards.Delete(Pred(FCards.Count));
end;

{ TMovementStack }

constructor TMovementStack.Create;
begin
  SetLength(FStack, 0);
end;

destructor TMovementStack.Destroy;
begin
  SetLength(FStack, 0);
  inherited Destroy;
end;

procedure TMovementStack.Push(AMove: TMovement);
begin
  SetLength(FStack, Length(FStack) + 1);
  FStack[High(FStack)] := AMove;
end;

function TMovementStack.Pop(out AMove: TMovement): Boolean;
var
  len: Integer;
begin
  len := Length(FStack);
  Result := len > 0;
  if not Result then
    exit;
  AMove := FStack[len - 1];
  SetLength(FStack, len - 1);
end;

end.

