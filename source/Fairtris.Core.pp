unit Fairtris.Core;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Memory;


type
  TCore = class(TObject)
  private
    function CanPlacePiece(): Boolean;
    function CanDropPiece(): Boolean;
    function CanShiftPiece(ADirection: Integer): Boolean;
    function CanRotatePiece(ADirection: Integer): Boolean;
  private
    procedure PlacePiece();
    procedure DropPiece();
    procedure ShiftPiece(ADirection: Integer);
    procedure RotatePiece(ADirection: Integer);
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


function TCore.CanPlacePiece(): Boolean;
var
  LayoutX, LayoutY: Integer;
begin
  for LayoutY := -2 to 2 do
  begin
    if Memory.Game.PieceY + LayoutY < -2 then Continue;
    if Memory.Game.PieceY + LayoutY > 19 then Continue;

    for LayoutX := -2 to 2 do
    begin
      if Memory.Game.PieceX + LayoutX < 0 then Continue;
      if Memory.Game.PieceX + LayoutX > 9 then Continue;

      if PIECE_LAYOUT[Memory.Game.PieceID, Memory.Game.PieceOrientation, LayoutY, LayoutX] <> BRICK_EMPTY then
        if Memory.Game.Stack[Memory.Game.PieceX + LayoutX, Memory.Game.PieceY + LayoutY] <> BRICK_EMPTY then
          Exit(False);
    end;
  end;

  Result := True;
end;


function TCore.CanDropPiece(): Boolean;
begin
  Result := Memory.Game.PieceY < PIECE_DROP_Y_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation];

  if Result then
  begin
    Memory.Game.PieceY += 1;
    Result := CanPlacePiece();
    Memory.Game.PieceY -= 1;
  end;
end;


function TCore.CanShiftPiece(ADirection: Integer): Boolean;
begin
  case ADirection of
    PIECE_SHIFT_LEFT:  Result := Memory.Game.PieceX > PIECE_SHIFT_X_MIN[Memory.Game.PieceID, Memory.Game.PieceOrientation];
    PIECE_SHIFT_RIGHT: Result := Memory.Game.PieceX < PIECE_SHIFT_X_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation];
  end;

  if Result then
  begin
    Memory.Game.PieceX += ADirection;
    Result := CanPlacePiece();
    Memory.Game.PieceX -= ADirection;
  end;
end;


function TCore.CanRotatePiece(ADirection: Integer): Boolean;
var
  OldOrientation: Integer;
begin
  OldOrientation := Memory.Game.PieceOrientation;
  Memory.Game.PieceOrientation := WrapAround(Memory.Game.PieceOrientation, PIECE_ORIENTATION_COUNT, ADirection);

  Result := (Memory.Game.PieceX >= PIECE_ROTATION_X_MIN[Memory.Game.PieceID, Memory.Game.PieceOrientation]) and
            (Memory.Game.PieceX <= PIECE_ROTATION_X_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation]) and
            (Memory.Game.PieceY <= PIECE_ROTATION_Y_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation]);

  if Result then
    Result := CanPlacePiece();

  Memory.Game.PieceOrientation := OldOrientation;
end;


procedure TCore.PlacePiece();
var
  LayoutX, LayoutY: Integer;
begin
  for LayoutY := -2 to 2 do
  begin
    if Memory.Game.PieceY + LayoutY < -2 then Continue;
    if Memory.Game.PieceY + LayoutY > 19 then Continue;

    for LayoutX := -2 to 2 do
    begin
      if Memory.Game.PieceX + LayoutX < 0 then Continue;
      if Memory.Game.PieceX + LayoutX > 9 then Continue;

      if PIECE_LAYOUT[Memory.Game.PieceID, Memory.Game.PieceOrientation, LayoutY, LayoutX] <> BRICK_EMPTY then
        Memory.Game.Stack[
          Memory.Game.PieceX + LayoutX,
          Memory.Game.PieceY + LayoutY
        ] := PIECE_LAYOUT[
          Memory.Game.PieceID,
          Memory.Game.PieceOrientation,
          LayoutY,
          LayoutX
        ];
    end;
  end;
end;


procedure TCore.DropPiece();
begin
  Memory.Game.PieceY += 1;
end;


procedure TCore.ShiftPiece(ADirection: Integer);
begin
  Memory.Game.PieceX += ADirection;
end;


procedure TCore.RotatePiece(ADirection: Integer);
begin
  Memory.Game.PieceOrientation := WrapAround(Memory.Game.PieceOrientation, PIECE_ORIENTATION_COUNT, ADirection);
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
    if CanShiftPiece(PIECE_SHIFT_LEFT) then
      ShiftPiece(PIECE_SHIFT_LEFT);

  if Input.Device.Right.JustPressed then
    if CanShiftPiece(PIECE_SHIFT_RIGHT) then
      ShiftPiece(PIECE_SHIFT_RIGHT);

  if Input.Device.B.JustPressed then
    if CanRotatePiece(PIECE_ROTATE_COUNTERCLOCKWISE) then
      RotatePiece(PIECE_ROTATE_COUNTERCLOCKWISE);

  if Input.Device.A.JustPressed then
    if CanRotatePiece(PIECE_ROTATE_CLOCKWISE) then
      RotatePiece(PIECE_ROTATE_CLOCKWISE);

  if Input.Device.Down.JustPressed then
    if CanDropPiece() then
      DropPiece()
    else
    begin
      PlacePiece();

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

