unit Fairtris.Core;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TCore = class(TObject)
  private
    function CanPlacePiece(APieceX, APieceY: Integer): Boolean;
  private
    function CanDropPiece(): Boolean;
    function CanShiftPiece(ADirection: Integer): Boolean;
    function CanRotatePiece(ADirection: Integer): Boolean;
  public
    procedure Reset();
    procedure Update();
  end;


var
  Core: TCore;


implementation

uses
  Fairtris.Memory,
  Fairtris.Arrays,
  Fairtris.Constants;


procedure TCore.Reset();
begin

end;


procedure TCore.Update();
begin

end;


function TCore.CanPlacePiece(APieceX, APieceY: Integer): Boolean;
var
  LayoutX, LayoutY: Integer;
begin
  for LayoutY := -2 to 2 do
  begin
    if APieceY + LayoutY < -2 then Continue;
    if APieceY + LayoutY > 19 then Continue;

    for LayoutX := -2 to 2 do
    begin
      if APieceX + LayoutX < 0 then Continue;
      if APieceX + LayoutX > 9 then Continue;

      if PIECE_LAYOUT[Memory.Game.PieceID, Memory.Game.PieceOrientation][LayoutY, LayoutX] <> BRICK_EMPTY then
        if Memory.Game.Stack[APieceX + LayoutX, APieceY + LayoutY] <> BRICK_EMPTY then
          Exit(False);
    end;
  end;

  Result := True;
end;


function TCore.CanDropPiece(): Boolean;
begin

end;


function TCore.CanShiftPiece(ADirection: Integer): Boolean;
begin

end;


function TCore.CanRotatePiece(ADirection: Integer): Boolean;
begin

end;


end.

