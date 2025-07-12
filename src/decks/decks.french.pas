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
    FBackImageLoaded: Boolean;
    FBackImageName: String;
    FBackImageStream: TMemoryStream;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Populate;
    procedure Shuffle;

    procedure LoadImageFromResources(AImageName: String);

    property BackImageName: String
      read FBackImageName;
    property BackImageData: TMemoryStream
      read FBAckImageStream;
    property ContainsBackImage: Boolean
      read FBAckImageLoaded;
  published
  end;

implementation

{ TFrenchDeck }

constructor TFrenchDeck.Create;
begin
  inherited Create;
  FBackImageLoaded:= False;
  FBackImageName:= EmptyStr;
  FBackImageStream:= nil;
end;

destructor TFrenchDeck.Destroy;
begin
  if FBackImageLoaded then
    FBackImageStream.Free;
  inherited Destroy;
end;

procedure TFrenchDeck.Populate;
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

procedure TFrenchDeck.LoadImageFromResources(AImageName: String);
var
  resStream: TResourceStream;
begin
  if FBackImageLoaded then // already loaded
    exit;

  try
    resStream := TResourceStream.Create(HInstance, AImageName, RT_RCDATA);
    FBackImageStream := TMemoryStream.Create;
    FBackImageStream.CopyFrom(resStream, resStream.Size);
    FBackImageStream.Position := 0;
  finally
    FBackImageName:= AImageName;
    FBackImageLoaded:= True;
    resStream.Free;
  end;
end;

end.

