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
    function GetCount: Integer;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddCard(ACard: TBaseCard);
    function RemoveTopCard: TBaseCard;

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
    procedure Push(Move: TMovement);
    function Pop(out Move: TMovement): Boolean;
  published
  end;


implementation

{ TPile }

constructor TPile.Create;
begin
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

procedure TPile.AddCard(ACard: TBaseCard);
begin
  FCards.Add(ACard);
end;

function TPile.RemoveTopCard: TBaseCard;
begin
  if FCards.Count = 0 then
  exit(nil);
  Result := (FCards.Last as TBaseCard);
  FCards.Delete(FCards.Count - 1);
end;

{ TMovementStack }

procedure TMovementStack.Push(Move: TMovement);
begin
  SetLength(FStack, Length(FStack) + 1);
  FStack[High(FStack)] := Move;
end;

function TMovementStack.Pop(out Move: TMovement): Boolean;
var
  len: Integer;
begin
  len := Length(FStack);
  Result := len > 0;
  if not Result then Exit;
  Move := FStack[len - 1];
  SetLength(FStack, len - 1);
end;

end.

