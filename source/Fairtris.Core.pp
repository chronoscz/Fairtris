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
    procedure SpawnPiece();
    procedure PlacePiece();
    procedure DropPiece();
    procedure ShiftPiece(ADirection: Integer);
    procedure RotatePiece(ADirection: Integer);
  private
    procedure UpdatePieceControlShift();
    procedure UpdatePieceControlRotate();
    procedure UpdatePieceControlDrop();
  private
    procedure UpdatePieceControl();
    procedure UpdatePieceLock();
    procedure UpdatePieceSpawn();
    procedure UpdateRowsCheck();
    procedure UpdateRowsClear();
    procedure UpdateCounters();
    procedure UpdateTopOut();
  public
    procedure Reset();
    procedure Update();
  end;


var
  Core: TCore;


implementation

uses
  Fairtris.Input,
  Fairtris.Sounds,
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
  if Memory.Game.PieceID = PIECE_O then Exit(False);

  OldOrientation := Memory.Game.PieceOrientation;
  Memory.Game.PieceOrientation := WrapAround(Memory.Game.PieceOrientation, PIECE_ORIENTATION_COUNT, ADirection);

  Result := (Memory.Game.PieceX >= PIECE_ROTATION_X_MIN[Memory.Game.PieceID, Memory.Game.PieceOrientation]) and
            (Memory.Game.PieceX <= PIECE_ROTATION_X_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation]) and
            (Memory.Game.PieceY <= PIECE_ROTATION_Y_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation]);

  if Result then
    Result := CanPlacePiece();

  Memory.Game.PieceOrientation := OldOrientation;
end;


procedure TCore.SpawnPiece();
begin
  Memory.Game.PieceID := Memory.Game.Next.Current;
  Memory.Game.PieceOrientation := PIECE_ORIENTATION_SPAWN;

  Memory.Game.Next.Current := Generators.Generator.Pick();
  Memory.Game.Stats[Memory.Game.PieceID] += 1;

  Memory.Game.PieceX := PIECE_SPAWN_X;
  Memory.Game.PieceY := PIECE_SPAWN_Y;
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


procedure TCore.UpdatePieceControlShift();
begin
  if Input.Device.Down.Pressed then Exit;

  if Input.Device.Left.Pressed and Input.Device.Right.Pressed then Exit;
  if not Input.Device.Left.Pressed and not Input.Device.Right.Pressed then Exit;

  if Input.Device.Left.JustPressed or Input.Device.Right.JustPressed then
    Memory.Game.AutorepeatX := 0
  else
  begin
    Memory.Game.AutorepeatX += 1;

    if Memory.Game.AutorepeatX < AUTOSHIFT_FRAMES_CHARGE[Memory.Play.Region] then
      Exit
    else
      Memory.Game.AutorepeatX := AUTOSHIFT_FRAMES_PRECHARGE[Memory.Play.Region];
  end;

  if Input.Device.Left.Pressed then
    if CanShiftPiece(PIECE_SHIFT_LEFT) then
    begin
      ShiftPiece(PIECE_SHIFT_LEFT);
      Sounds.PlaySound(SOUND_SHIFT);
    end
    else
      Memory.Game.AutorepeatX := AUTOSHIFT_FRAMES_CHARGE[Memory.Play.Region];

  if Input.Device.Right.Pressed then
    if CanShiftPiece(PIECE_SHIFT_RIGHT) then
    begin
      ShiftPiece(PIECE_SHIFT_RIGHT);
      Sounds.PlaySound(SOUND_SHIFT);
    end
    else
      Memory.Game.AutorepeatX := AUTOSHIFT_FRAMES_CHARGE[Memory.Play.Region];
end;


procedure TCore.UpdatePieceControlRotate();
begin
  if Input.Device.B.JustPressed then
    if CanRotatePiece(PIECE_ROTATE_COUNTERCLOCKWISE) then
    begin
      RotatePiece(PIECE_ROTATE_COUNTERCLOCKWISE);
      Sounds.PlaySound(SOUND_SPIN);

      Exit;
    end;

  if Input.Device.A.JustPressed then
    if CanRotatePiece(PIECE_ROTATE_CLOCKWISE) then
    begin
      RotatePiece(PIECE_ROTATE_CLOCKWISE);
      Sounds.PlaySound(SOUND_SPIN);
    end;
end;


procedure TCore.UpdatePieceControlDrop();
label
  Playing, Autorepeating, DownPressed, Drop, LookupDropSpeed, NoTableLookup, IncrementAutorepeatY;
var
  TempSpeed, DropSpeed: Integer;
begin
  if Memory.Game.AutorepeatY > 0 then goto Autorepeating;
  if Memory.Game.AutorepeatY = 0 then goto Playing;

  if not Input.Device.Down.JustPressed then
    goto IncrementAutorepeatY;

  Memory.Game.AutorepeatY := 0;

Playing:
  if Input.Device.Left.Pressed or Input.Device.Right.Pressed then
    goto LookupDropSpeed;

  if Input.Device.Down.JustPressed then
    if Input.Device.Up.Pressed or Input.Device.Left.Pressed or Input.Device.Right.Pressed then
      goto LookupDropSpeed;

  Memory.Game.AutorepeatY := 1;
  goto LookupDropSpeed;

Autorepeating:
  if Input.Device.Down.Pressed then
    if not Input.Device.Left.Pressed and not Input.Device.Right.Pressed then
      goto DownPressed;

  Memory.Game.AutorepeatY := 0;
  Memory.Game.FallPoints := 0;

  goto LookupDropSpeed;

DownPressed:
  Memory.Game.AutorepeatY += 1;

  if Memory.Game.AutorepeatY < 3 then
    goto LookupDropSpeed;

  Memory.Game.AutorepeatY := 1;
  Memory.Game.FallPoints += 1;

Drop:
  Memory.Game.FallTimer := 0;

  if CanDropPiece() then
    DropPiece()
  else
  begin
    PlacePiece();
    Memory.Game.State := STATE_PIECE_LOCK;
  end;

  Exit;

LookupDropSpeed:
  Memory.Game.FallTimer += 1;

  if Memory.Game.Level.Current < LEVEL_LAST then
    DropSpeed := GRAVITY_FRAMES[Memory.Play.Region, Memory.Game.Level.Current]
  else
  begin
    DropSpeed := 1;
    goto NoTableLookup;
  end;

NoTableLookup:
  if Memory.Game.FallTimer >= DropSpeed then
    goto Drop;

  Exit;

IncrementAutorepeatY:
  Memory.Game.AutorepeatY += 1;
end;


procedure TCore.UpdatePieceControl();
begin
  UpdatePieceControlShift();
  UpdatePieceControlRotate();
  UpdatePieceControlDrop();
end;


procedure TCore.UpdatePieceLock();
begin
  PlacePiece();
  Sounds.PlaySound(SOUND_DROP);

  Memory.Game.State := STATE_ROWS_CHECK;
end;


procedure TCore.UpdatePieceSpawn();
begin
  SpawnPiece();

  if CanPlacePiece() then
    Memory.Game.State := STATE_PIECE_CONTROL
  else
  begin
    Memory.Game.State := STATE_UPDATE_TOP_OUT;
    Memory.Game.TopOutTimer := TOP_OUT_FRAMES[Memory.Play.Region];

    Sounds.PlaySound(SOUND_TOP_OUT);
  end;
end;


procedure TCore.UpdateRowsCheck();
begin
  Memory.Game.State := STATE_UPDATE_COUNTERS;
end;


procedure TCore.UpdateRowsClear();
begin

end;


procedure TCore.UpdateCounters();
begin
  Memory.Game.State := STATE_PIECE_SPAWN;
end;


procedure TCore.UpdateTopOut();
begin
  if Memory.Game.TopOutTimer > 0 then
    Memory.Game.TopOutTimer -= 1
  else
    if Input.Device.Start.JustPressed then
    begin
      Memory.Game.Ended := True;
      Sounds.PlaySound(SOUND_START);
    end;
end;


procedure TCore.Reset();
begin
  Memory.Game.Reset();
  Memory.Game.Started := True;
  Memory.Game.AutorepeatY := PIECE_FRAMES_HANG[Memory.Play.Region];

  Generators.Generator.Prepare();
  Memory.Game.PieceID := Generators.Generator.Pick();

  Generators.Generator.Step();
  Memory.Game.Next.Current := Generators.Generator.Pick();

  Memory.Game.Level.Current := Memory.Play.Level;
  Memory.Game.Stats[Memory.Game.PieceID] += 1;
end;


procedure TCore.Update();
begin
  Generators.Generator.Step();

  case Memory.Game.State of
    STATE_PIECE_CONTROL:   UpdatePieceControl();
    STATE_PIECE_LOCK:      UpdatePieceLock();
    STATE_PIECE_SPAWN:     UpdatePieceSpawn();
    STATE_ROWS_CHECK:      UpdateRowsCheck();
    STATE_ROWS_CLEAR:      UpdateRowsClear();
    STATE_UPDATE_COUNTERS: UpdateCounters();
    STATE_UPDATE_TOP_OUT:  UpdateTopOut();
  end;
end;


end.

