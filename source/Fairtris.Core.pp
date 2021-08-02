unit Fairtris.Core;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TCore = class(TObject)
  private
    function CanPlacePiece(AX, AY: Integer): Boolean;
  private
    function CanDropPiece(): Boolean;
    function CanShiftPiece(ADirection: Intger): Boolean;
    function CanRotatePiece(ADirection: Integer): Boolean;
  public
    procedure Reset();
    procedure Update();
  end;


var
  Core: TCore;


implementation


procedure TCore.Reset();
begin

end;


procedure TCore.Update();
begin

end;


function TCore.CanPlacePiece(AX, AY: Integer): Boolean;
begin

end;


function TCore.CanDropPiece(): Boolean;
begin

end;


function TCore.CanShiftPiece(ADirection: Intger): Boolean;
begin

end;


function TCore.CanRotatePiece(ADirection: Integer): Boolean;
begin

end;


end.

