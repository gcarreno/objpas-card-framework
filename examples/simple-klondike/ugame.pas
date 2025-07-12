unit uGame;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, DateUtils
, Crt
, Base.Common
, Piles.Pile
, Decks.French
, Cards.French
;

type
{ TKlondikeGame }
  TKlondikeGame = class(TObject)
  private
    FExit: Boolean;
    FDeck: TFrenchDeck;
    FStock, FWaste: TPile;
    FFoundations: array[0..3] of TPile;
    FTableau: array[0..6] of TPile;
    FStartTime: TDateTime;
    FScore: Integer;
    procedure InitGame;
    //procedure DealCards;
    procedure PrintGame;
    procedure ExecuteCommand(const S: string);
    procedure Help;
    function MoveCard(const Src, Dest: string): Boolean;
    function ParsePile(const S: string): TPile;
    function FoundationsContains(APile: TPile): Boolean;
    function TableauContains(ATableau: TPile): Boolean;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run;
  published
  end;

implementation

{ TKlondikeGame }

constructor TKlondikeGame.Create;
var
  index: Integer;
begin
  FExit:= False;
  FDeck:= TFrenchDeck.Create;
  FDeck.Populate;
  FDeck.Shuffle;
  FStock:= TPile.Create;
  FWaste:= TPile.Create;
  for index:= 0 to 3 do
    FFoundations[index]:= TPile.Create;
  for index:= 0 to 6 do
    FTableau[index]:= TPile.Create;
  FStartTime:= Now;
  FScore:= 0;
  InitGame;
end;

destructor TKlondikeGame.Destroy;
var
  index: Integer;
begin
  FWaste.Free;
  FStock.Free;
  FDeck.Free;
  for index:= 0 to 3 do
    FFoundations[index].Free;
  for index:= 0 to 6 do
    FTableau[index].Free;
  inherited Destroy;
end;

procedure TKlondikeGame.InitGame;
var
  i, j: Integer;
begin
  for i:= 6 downto 0 do
  begin
    for j:= 0 to i do
    begin
      FTableau[i].AddCard(TFrenchCard(FDeck.Draw));
      FTableau[i].TopCard.Visible:= False;
    end;
    FTableau[i].TopCard.Visible:= True;
  end;

  while FDeck.Count > 0 do
  begin
    FStock.AddCard(TFrenchCard(FDeck.Draw));
  end;
end;

//procedure TKlondikeGame.DealCards;
//begin
//
//end;

procedure TKlondikeGame.PrintGame;
var
  index, j: Integer;
begin
  ClrScr;
  WriteLn('== KLONDIKE SOLITAIRE ==');
  WriteLn('Elapsed time: ', SecondsBetween(Now, FStartTime), 's');
  WriteLn('Score: ', FScore);
  WriteLn;
  if FWaste.Count > 0 then
    WriteLn('Stock: ', FStock.Count, ' | Waste: ', FWaste.Count, ' [', FWaste.TopCard.ToString:5, ']')
  else
    WriteLn('Stock: ', FStock.Count, ' | Waste: ', FWaste.Count, ' [---]');

  Write('Foundations: ');
  for index:= 0 to 3 do
  begin
    if FFoundations[index].Count > 0 then
      Write(' [', FFoundations[index].TopCard.ToString:5, ']')
    else
      Write(' [---] ');
  end;
  WriteLn;

  WriteLn;
  WriteLn('Tableau:');
  for index:= 0 to 6 do
  begin
    Write('T', index+1, ': ');
    for j:= 0 to Pred(FTableau[index].Count) do
      Write('[', FTableau[index][j].ToString:5 ,'] ');
    WriteLn;
  end;
end;

procedure TKlondikeGame.ExecuteCommand(const S: string);
var
  Parts: TStringArray;
begin
  Parts := S.Split(' ');
  if Length(Parts) = 0 then Exit;

  case LowerCase(Parts[0]) of
    'd', 'draw':
      begin
        if FStock.Count > 0 then
        begin
          FWaste.AddCard(FStock.RemoveTopCard);
          Inc(FScore, 5);
        end;
        PrintGame;
      end;
    'm', 'move':
      begin
        if Length(Parts) <> 3 then
          WriteLn('Usage: move <source> <destination>')
        else if not MoveCard(Parts[1], Parts[2]) then
          WriteLn('Invalid move.');
        PrintGame;
      end;
    'h', 'help':
      begin
        PrintGame;
        Help;
      end;
    'q', 'quit': FExit:= True;
    else
    begin
      PrintGame;
      WriteLn;
      WriteLn('Unknown command. Type "help" for instructions.');
    end;
  end;
end;

procedure TKlondikeGame.Help;
begin
  WriteLn;
  WriteLn('Available commands:');
  WriteLn(' [d]raw             - Draw a card from stock to waste');
  WriteLn(' [m]ove <src> <dst> - Move card from src to dst (e.g., W F1 or T3 F2)');
  WriteLn(' [h]elp             - Show this help');
  WriteLn(' [q]uit             - Quit the game');
end;

function TKlondikeGame.MoveCard(const Src, Dest: string): Boolean;
var
  FromPile, ToPile: TPile;
  Card: TFrenchCard;
  TopDest: TFrenchCard;
begin
  Result := False;
  FromPile := ParsePile(Src);
  ToPile := ParsePile(Dest);
  if (FromPile = nil) or (ToPile = nil) or (FromPile.Count = 0) then Exit;

  Card := (FromPile.RemoveTopCard as TFrenchCard);

  if (ToPile = FWaste) or (ToPile = FStock) then
  begin
    FromPile.AddCard(Card);
    exit;
  end;

  // Foundation rules
  if (FoundationsContains(ToPile)) then
  begin
    if (Card.Rank = raAce) and (ToPile.Count = 0) then
    begin
      if Assigned(FromPile.TopCard) then
        FromPile.TopCard.Visible:= True;
      ToPile.AddCard(Card);
      Inc(FScore, 10);
      Exit(True);
    end
    else if (ToPile.Count > 0) then
    begin
      TopDest := (ToPile.RemoveTopCard as TFrenchCard);
      if (Card.Suit = TopDest.Suit) and (Ord(Card.Rank) = Ord(TopDest.Rank) + 1) then
      begin
        if Assigned(FromPile.TopCard) then
          FromPile.TopCard.Visible:= True;
        ToPile.AddCard(TopDest);
        ToPile.AddCard(Card);
        Inc(FScore, 10);
        Exit(True);
      end
      else
        ToPile.AddCard(TopDest);
    end;
  end
  // Tableau rules (simple rule: stack descending regardless of suit)
  else if (TableauContains(ToPile)) then
  begin
    if (ToPile.Count = 0) then
    begin
      if Card.Rank = raKing then
      begin
        if Assigned(FromPile.TopCard) then
          FromPile.TopCard.Visible:= True;
        ToPile.AddCard(Card);
        Inc(FScore, 5);
        Exit(True);
      end;
    end
    else
    begin
      TopDest := (ToPile.RemoveTopCard as TFrenchCard);
      if not Assigned(TopDest) then
      begin
        raise Exception.Create('Tableau: TopDest is nil');
      end;
      if Ord(Card.Rank) = Ord(TopDest.Rank) - 1 then
      begin
        if Assigned(FromPile.TopCard) then
          FromPile.TopCard.Visible:= True;
        ToPile.AddCard(TopDest);
        ToPile.AddCard(Card);
        Inc(FScore, 5);
        Exit(True);
      end
      else
        ToPile.AddCard(TopDest);
    end;
  end;

  // If move is invalid, return card
  FromPile.AddCard(Card);
end;

function TKlondikeGame.ParsePile(const S: string): TPile;
begin
  Result := nil;
  if LowerCase(S) = 'w' then
    exit(FWaste);
  if Length(S) = 2 then
  begin
    if LowerCase(S[1]) = 'f' then
      exit(FFoundations[Ord(S[2]) - Ord('1')]);
    if LowerCase(S[1]) = 't' then
      exit(FTableau[Ord(S[2]) - Ord('1')]);
  end;
end;

function TKlondikeGame.FoundationsContains(APile: TPile): Boolean;
var
  index: Integer;
begin
  Result:= False;
  for index:= Low(FFoundations)  to High(FFoundations) do
  begin
    if APile = FFoundations[index] then
      exit(true);
  end;
end;

function TKlondikeGame.TableauContains(ATableau: TPile): Boolean;
var
  index: Integer;
begin
  Result:= False;
  for index:= Low(FTableau)  to High(FTableau) do
  begin
    if ATableau = FTableau[index] then
      exit(true);
  end;
end;

procedure TKlondikeGame.Run;
var
  Cmd: string;
begin
  PrintGame;
  repeat
    WriteLn;
    Write('Command > ');
    ReadLn(Cmd);
    ExecuteCommand(Cmd);
  until FExit;
end;

end.

