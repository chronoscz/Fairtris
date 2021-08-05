unit Fairtris.Core;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Memory;


type
  TCore = class(TObject)
  private
    function CanPlacePiece(AX, AY, AID, AOrientation: Integer): Boolean;
    function CanDropPiece(AX, AY, AID, AOrientation: Integer): Boolean;
    function CanShiftPiece(AX, AY, AID, AOrientation, ADirection: Integer): Boolean;
    function CanRotatePiece(AX, AY, AID, AOrientation, ADirection: Integer): Boolean;
  private
    procedure PlacePiece(AX, AY, AID, AOrientation: Integer; var AStack: TGameStack);
    procedure DropPiece(var AY: Integer);
    procedure ShiftPiece(var AX: Integer; ADirection: Integer);
    procedure RotatePiece(var AOrientation: Integer; ADirection: Integer);
  public
    procedure Reset();
    procedure Update();
  end;


var
  Core: TCore;


implementation

uses
  Fairtris.Input,
  Fairtris.Generators,
  Fairtris.Utils,
  Fairtris.Arrays,
  Fairtris.Constants;


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

      if PIECE_LAYOUT[AID, AOrientation, LayoutY, LayoutX] <> BRICK_EMPTY then
        if Memory.Game.Stack[AX + LayoutX, AY + LayoutY] <> BRICK_EMPTY then
          Exit(False);
    end;
  end;

  Result := True;
end;


function TCore.CanDropPiece(AX, AY, AID, AOrientation: Integer): Boolean;
begin
  Result := AY < PIECE_DROP_Y_MAX[AID, AOrientation];

  if Result then
    Result := CanPlacePiece(AX, AY + 1, AID, AOrientation);
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

  Result := (AX >= PIECE_ROTATION_X_MIN[AID, AOrientation]) and
            (AX <= PIECE_ROTATION_X_MAX[AID, AOrientation]) and
            (AY <= PIECE_ROTATION_Y_MAX[AID, AOrientation]);

  if Result then
    Result := CanPlacePiece(AX, AY, AID, AOrientation);
end;


procedure TCore.PlacePiece(AX, AY, AID, AOrientation: Integer; var AStack: TGameStack);
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

      if PIECE_LAYOUT[AID, AOrientation, LayoutY, LayoutX] <> BRICK_EMPTY then
        AStack[AX + LayoutX, AY + LayoutY] := PIECE_LAYOUT[AID, AOrientation, LayoutY, LayoutX];
    end;
  end;
end;


procedure TCore.DropPiece(var AY: Integer);
begin
  AY += 1;
end;


procedure TCore.ShiftPiece(var AX: Integer; ADirection: Integer);
begin
  AX += ADirection;
end;


procedure TCore.RotatePiece(var AOrientation: Integer; ADirection: Integer);
begin
  AOrientation := WrapAround(AOrientation, PIECE_ORIENTATION_COUNT, ADirection);
end;


procedure TCore.Reset();
begin
  Memory.Game.Reset();

  Generators.Generator.Step();
  Memory.Game.PieceID := Generators.Generator.Pick();

  Generators.Generator.Step();
  Memory.Game.Next.Current := Generators.Generator.Pick();

  Memory.Game.Level.Current := Memory.Play.Level;
  Memory.Game.Stats[Memory.Game.PieceID] += 1;
end;


procedure TCore.Update();
begin
  // added only to test collision mechanism
  Generators.Generator.Step();

  if Input.Device.Left.JustPressed then
    if CanShiftPiece(Memory.Game.PieceX, Memory.Game.PieceY, Memory.Game.PieceID, Memory.Game.PieceOrientation, PIECE_SHIFT_LEFT) then
      ShiftPiece(Memory.Game.PieceX, PIECE_SHIFT_LEFT);

  if Input.Device.Right.JustPressed then
    if CanShiftPiece(Memory.Game.PieceX, Memory.Game.PieceY, Memory.Game.PieceID, Memory.Game.PieceOrientation, PIECE_SHIFT_RIGHT) then
      ShiftPiece(Memory.Game.PieceX, PIECE_SHIFT_RIGHT);

  if Input.Device.B.JustPressed then
    if CanRotatePiece(Memory.Game.PieceX, Memory.Game.PieceY, Memory.Game.PieceID, Memory.Game.PieceOrientation, PIECE_ROTATE_COUNTERCLOCKWISE) then
      RotatePiece(Memory.Game.PieceOrientation, PIECE_ROTATE_COUNTERCLOCKWISE);

  if Input.Device.A.JustPressed then
    if CanRotatePiece(Memory.Game.PieceX, Memory.Game.PieceY, Memory.Game.PieceID, Memory.Game.PieceOrientation, PIECE_ROTATE_CLOCKWISE) then
      RotatePiece(Memory.Game.PieceOrientation, PIECE_ROTATE_CLOCKWISE);

  if Input.Device.Down.JustPressed then
    if CanDropPiece(Memory.Game.PieceX, Memory.Game.PieceY, Memory.Game.PieceID, Memory.Game.PieceOrientation) then
      DropPiece(Memory.Game.PieceY)
    else
    begin
      PlacePiece(Memory.Game.PieceX, Memory.Game.PieceY, Memory.Game.PieceID, Memory.Game.PieceOrientation, Memory.Game.Stack);

      Memory.Game.PieceID := Memory.Game.Next.Current;
      Memory.Game.PieceOrientation := PIECE_ORIENTATION_SPAWN;

      Memory.Game.Next.Current := Generators.Generator.Pick();
      Memory.Game.Stats[Memory.Game.PieceID] += 1;

      Memory.Game.PieceX := PIECE_SPAWN_X;
      Memory.Game.PieceY := PIECE_SPAWN_Y;
    end;
  // remove after testing
end;


end.

