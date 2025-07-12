{
  This unit contains the definitions of cards for some common games
}
unit Cards.French;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, Base.Common
;

type
{ TFrenchCard }
  TFrenchCard = class(TBaseCard)
  private
    FSuit: TSuit;
    FRank: TRank;
    FImageLoaded: Boolean;
    FImageName: String;
    FImageStream: TMemoryStream;

    function GetString: String;override;
  protected
  public
    constructor Create(ASuit: TSuit; ARank: TRank);
    destructor Destroy; override;

    procedure LoadImageFromResources(AImageName: String);

    property Suit: TSuit
      read FSuit;
    property Rank: TRank
      read FRank;

    property ImageName: String
      read FImageName;
    property ImageData: TMemoryStream
      read FImageStream;
    property ContainsImage: Boolean
      read FImageLoaded;

    property ToString: String
      read GetString;
  published
  end;

implementation

{ TFrenchCard }

constructor TFrenchCard.Create(ASuit: TSuit; ARank: TRank);
begin
  FSuit:= ASuit;
  FRank:= ARank;
  FImageLoaded:= False;
  FImageName:= EmptyStr;
  FImageStream:= nil;
end;

destructor TFrenchCard.Destroy;
begin
  if FImageLoaded then
    FImageStream.Free;
  inherited Destroy;
end;

function TFrenchCard.GetString: String;
const
  SuitNames: array[TSuit] of string =
    ('1','2','♠', '♥', '♦', '♣');
  RankNames: array[TRank] of string =
    ('J', 'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K');
begin
  Result := Format('%s%s', [RankNames[FRank], SuitNames[FSuit]]);
end;

procedure TFrenchCard.LoadImageFromResources(AImageName: String);
var
  stream: TResourceStream;
begin
  if FImageStream <> nil then
    exit; // already loaded

  try
    stream := TResourceStream.Create(HInstance, AImageName, RT_RCDATA);
    FImageStream := TMemoryStream.Create;
    FImageStream.CopyFrom(stream, stream.Size);
    FImageStream.Position := 0;
  finally
    FImageName:= AImageName;
    FImageLoaded:= True;
    stream.Free;
  end;
end;

end.

