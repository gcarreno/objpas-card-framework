unit TestPiles;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Piles.Pile
;

type

  TFrameworkPiles= class(TTestCase)
  private
    FPile: TPile;
  protected
  public
  published
    procedure TestPileCreate;
  end;

implementation

procedure TFrameworkPiles.TestPileCreate;
begin
  FPile := TPile.Create;
  try
    //
  finally
    FPile.Free;
  end;
end;



initialization

  RegisterTest(TFrameworkPiles);
end.

