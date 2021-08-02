unit Fairtris.Core;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TCore = class(TObject)
  private
    function CanPlacePiece(AX, AY, AID, AOrientation: Integer): Boolean;
  private
    function CanShiftPiece(AX, AY, AID, AOrientation, ADirection: Integer): Boolean;
    function CanRotatePiece(AX, AY, AID, AOrientation, ADirection: Integer): Boolean;
    function CanDropPiece(AX, AY, AID, AOrientation: Integer): Boolean;
  private
    procedure PerformShift(var AX: Integer; ADirection: Integer);
    procedure PerformRotation(var AOrientation: Integer; ADirection: Integer);
    procedure PerformDrop(var AY: Integer);
  public
    procedure Reset();
    procedure Update();
  end;


var
  Core: TCore;


implementation

uses
  Fairtris.Memory,
  Fairtris.Utils,
  Fairtris.Arrays,
  Fairtris.Constants;


procedure TCore.Reset();
begin

end;


procedure TCore.Update();
begin

end;


function TCore.CanPlacePiece(AX, AY, AID, AOrientation: Integer): Boolean;
var
  LayoutX, LayoutY: Integer;
begin
  for LayoutY := -2 to 2 do
  begin
    if AY + LayoutY < -2 then Continue;
    if AY + LayoutY > 19 then Continue;

    for LayoutX := -2 to 2 do
    begin
      if AX + LayoutX < 0 then Continue;
      if AX + LayoutX > 9 then Continue;

      if PIECE_LAYOUT[AID, AOrientation][LayoutY, LayoutX] <> BRICK_EMPTY then
        if Memory.Game.Stack[AX + LayoutX, AY + LayoutY] <> BRICK_EMPTY then
          Exit(False);
    end;
  end;

  Result := True;
end;


function TCore.CanShiftPiece(AX, AY, AID, AOrientation, ADirection: Integer): Boolean;
begin
  case ADirection of
    PIECE_SHIFT_LEFT:  Result := AX > PIECE_SHIFT_X_MIN[AID, AOrientation];
    PIECE_SHIFT_RIGHT: Result := AX < PIECE_SHIFT_X_MAX[AID, AOrientation];
  end;

  if Result then
    Result := CanPlacePiece(AX + ADirection, AY, AID, AOrientation);
end;


function TCore.CanRotatePiece(AX, AY, AID, AOrientation, ADirection: Integer): Boolean;
begin
  AOrientation := WrapAround(AOrientation, PIECE_ORIENTATION_COUNT, ADirection);

  Result := (AX > PIECE_ROTATION_X_MIN[AID, AOrientation]) and
            (AX < PIECE_ROTATION_X_MAX[AID, AOrientation]) and
            (AY < PIECE_ROTATION_Y_MAX[AID, AOrientation]);

  if Result then
    Result := CanPlacePiece(AX, AY, AID, AOrientation);
end;


function TCore.CanDropPiece(AX, AY, AID, AOrientation: Integer): Boolean;
begin
  Result := AY < PIECE_DROP_Y_MAX[AID, AOrientation];

  if Result then
    Result := CanPlacePiece(AX, AY + 1, AID, AOrientation);
end;


procedure TCore.PerformShift(var AX: Integer; ADirection: Integer);
begin
  AX += ADirection;
end;


procedure TCore.PerformRotation(var AOrientation: Integer; ADirection: Integer);
begin
  AOrientation := WrapAround(AOrientation, PIECE_ORIENTATION_COUNT, ADirection);
end;


procedure TCore.PerformDrop(var AY: Integer);
begin
  AY += 1;
end;


end.

