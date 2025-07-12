{
  This unit contains the definitions of cards for some common games
}
unit Cards.French;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
{$IFDEF WINDOWS}
, Windows
{$ENDIF}
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
  protected
    function GetString: String;override;
  public
    constructor Create(ASuit: TSuit; ARank: TRank; AVisible: Boolean);
    destructor Destroy; override;

    procedure LoadImageFromResources(AImageName: String);

    function Clone: TFrenchCard; override;

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
  published
  end;

implementation

{ TFrenchCard }

constructor TFrenchCard.Create(ASuit: TSuit; ARank: TRank; AVisible: Boolean);
begin
  FSuit:= ASuit;
  FRank:= ARank;
  FVisible:= AVisible;
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
begin
  Result:= '--';
  if FVisible then
    exit(Format('%s%s', [cRankNames[FRank], cSuitNames[FSuit]]));
end;

procedure TFrenchCard.LoadImageFromResources(AImageName: String);
var
  resStream: TResourceStream;
begin
  if FImageLoaded then // already loaded
    exit;

  try
    resStream := TResourceStream.Create(HInstance, AImageName, RT_RCDATA);
    FImageStream := TMemoryStream.Create;
    FImageStream.CopyFrom(resStream, resStream.Size);
    FImageStream.Position := 0;
  finally
    FImageName:= AImageName;
    FImageLoaded:= True;
    resStream.Free;
  end;
end;

function TFrenchCard.Clone: TFrenchCard;
begin
  Result:= TFrenchCard.Create(FSuit, FRank, FVisible);
  if Result.ContainsImage then
    Result.LoadImageFromResources(Result.ImageName);
end;

end.

