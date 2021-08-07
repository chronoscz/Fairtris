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
    function CanClearLine(AIndex: Integer): Boolean;
    function CanLowerStack(AIndex: Integer): Boolean;
  private
    procedure SpawnPiece();
    procedure PlacePiece();
    procedure DropPiece();
    procedure ShiftPiece(ADirection: Integer);
    procedure RotatePiece(ADirection: Integer);
  private
    procedure ClearLine(AIndex: Integer);
    procedure LowerStack(AIndex: Integer);
  private
    procedure UpdatePieceControlShift();
    procedure UpdatePieceControlRotate();
    procedure UpdatePieceControlDrop();
  private
    procedure UpdateCommon();
    procedure UpdatePieceControl();
    procedure UpdatePieceLock();
    procedure UpdatePieceSpawn();
    procedure UpdateLinesCheck();
    procedure UpdateLinesClear();
    procedure UpdateStackLower();
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
  Fairtris.Clock,
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


function TCore.CanClearLine(AIndex: Integer): Boolean;
var
  BrickX: Integer;
begin
  if AIndex < 0 then Exit(False);
  if AIndex > 19 then Exit(False);

  for BrickX := 0 to 9 do
    if Memory.Game.Stack[BrickX, AIndex] = BRICK_EMPTY then
      Exit(False);

  Result := True;
end;


function TCore.CanLowerStack(AIndex: Integer): Boolean;
begin
  Result := Memory.Game.ClearPermits[AIndex];
end;


procedure TCore.SpawnPiece();
begin
  Memory.Game.PieceID := Memory.Game.Next;
  Memory.Game.PieceOrientation := PIECE_ORIENTATION_SPAWN;

  Memory.Game.Next := Generators.Generator.Pick();
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


procedure TCore.ClearLine(AIndex: Integer);
begin
  Memory.Game.Stack[Memory.Game.ClearColumn, AIndex] := BRICK_EMPTY;
  Memory.Game.Stack[9 - Memory.Game.ClearColumn, AIndex] := BRICK_EMPTY;
end;


procedure TCore.LowerStack(AIndex: Integer);
var
  BrickX, BrickY, LineIndex: Integer;
begin
  for BrickY := AIndex - 1 downto 0 do
    for BrickX := 0 to 9 do
      Memory.Game.Stack[BrickX, BrickY + 1] := Memory.Game.Stack[BrickX, BrickY];

  for BrickY := -2 to 0 do
    for BrickX := 0 to 9 do
      Memory.Game.Stack[BrickX, BrickY] := BRICK_EMPTY;

  for LineIndex := Memory.Game.LowerTimer - 1 downto -2 do
    if Memory.Game.ClearPermits[LineIndex] then
      Memory.Game.ClearIndexes[LineIndex] += 1;
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
  DropSpeed: Integer;
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

    Memory.Game.State := STATE_LINES_CHECK;

    Memory.Game.ClearCount := 0;
    Memory.Game.ClearTimer := 0;
    Memory.Game.ClearColumn := 4;
  end;

  Exit;

LookupDropSpeed:
  Memory.Game.FallTimer += 1;

  if Memory.Game.Level < LEVEL_LAST then
    DropSpeed := GRAVITY_FRAMES[Memory.Play.Region, Memory.Game.Level]
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


procedure TCore.UpdateCommon();
begin
  Generators.Generator.Step();

  if Memory.Game.GainTimer > 0 then
    Memory.Game.GainTimer -= 1;

  if Input.Device.Select.JustPressed then
    Memory.Game.NextVisible := not Memory.Game.NextVisible;
end;


procedure TCore.UpdatePieceControl();
begin
  UpdatePieceControlShift();
  UpdatePieceControlRotate();
  UpdatePieceControlDrop();
end;


procedure TCore.UpdatePieceLock();
begin
  Memory.Game.LockTimer -= 1;

  if Memory.Game.LockTimer = PIECE_FRAMES_LOCK_SOUND[Memory.Game.LockRow] then
    Sounds.PlaySound(SOUND_DROP);

  if Memory.Game.LockTimer = 0 then
  begin
    Memory.Game.State := STATE_UPDATE_COUNTERS;
    Memory.Game.ClearCount := 0;
    Memory.Game.ClearTimer := 0;
  end;
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


procedure TCore.UpdateLinesCheck();
var
  Index: Integer;
begin
  for Index := -2 to 1 do
  begin
    Memory.Game.ClearPermits[Index] := CanClearLine(Memory.Game.PieceY + Index);

    if Memory.Game.ClearPermits[Index] then
    begin
      Memory.Game.ClearIndexes[Index] := Memory.Game.PieceY + Index;
      Memory.Game.ClearCount += 1;
    end;
  end;

  if Memory.Game.ClearCount > 0 then
  begin
    Memory.Game.State := STATE_LINES_CLEAR;
    Memory.Game.PieceID := PIECE_UNKNOWN;
  end
  else
  begin
    Memory.Game.State := STATE_PIECE_LOCK;
    Memory.Game.LockRow := Memory.Game.PieceY;
    Memory.Game.LockTimer := PIECE_FRAMES_LOCK_DELAY[Memory.Game.LockRow];
  end;
end;


procedure TCore.UpdateLinesClear();
var
  Index: Integer;
begin
  Memory.Game.ClearTimer += 1;

  if Memory.Game.ClearTimer = 8 then
    if Memory.Game.ClearCount = 4 then
      Sounds.PlaySound(SOUND_TETRIS)
    else
      Sounds.PlaySound(SOUND_BURN);

  if Memory.Game.ClearCount = 4 then
    Memory.Game.Flashing := Memory.Game.ClearTimer mod 4 < 2;

  if Memory.Game.ClearTimer mod 4 = 0 then
  begin
    for Index := -2 to 1 do
      if Memory.Game.ClearPermits[Index] then
        ClearLine(Memory.Game.ClearIndexes[Index]);

    Memory.Game.ClearColumn -= 1;

    if Memory.Game.ClearColumn < 0 then
    begin
      Memory.Game.State := STATE_UPDATE_COUNTERS;
      Memory.Game.Flashing := False;
    end;
  end;
end;


procedure TCore.UpdateStackLower();
begin
  if Memory.Game.LowerTimer >= -2 then
  begin
    if Memory.Game.ClearCount > 0 then
      if CanLowerStack(Memory.Game.LowerTimer) then
        LowerStack(Memory.Game.ClearIndexes[Memory.Game.LowerTimer]);

    Memory.Game.LowerTimer -= 1;
  end
  else
    Memory.Game.State := STATE_PIECE_SPAWN;
end;


procedure TCore.UpdateCounters();
var
  Gain: Integer;
var
  HappenedKillScreen: Boolean = False;
  HappenedAnyTransition: Boolean = False;
  HappenedFirstTransition: Boolean = False;
begin
  if Memory.Game.ClearCount > 0 then
  begin
    if not Memory.Game.AfterTransition then
      if Memory.Game.Lines + Memory.Game.ClearCount >= TRANSITION_LINES[Memory.Play.Region, Memory.Play.Level] then
        HappenedFirstTransition := True;

    if Memory.Game.AfterTransition then
    begin
      if (Memory.Game.Lines div 10) <> ((Memory.Game.Lines + Memory.Game.ClearCount) div 10) then
        HappenedAnyTransition := True;

      if HappenedAnyTransition then
        if Memory.Game.Lines + Memory.Game.ClearCount >= KILLSCREEN_LINES[Memory.Play.Region, Memory.Play.Level] then
          HappenedKillScreen := True;
    end;

    if HappenedFirstTransition then
      Memory.Game.AfterTransition := True;

    if HappenedFirstTransition or HappenedAnyTransition then
    begin
      Memory.Game.Level += 1;
      Sounds.PlaySound(SOUND_TRANSITION);
    end;

    Memory.Game.Lines += Memory.Game.ClearCount;
    Memory.Game.LinesCleared := Memory.Game.Lines;
    Memory.Game.LineClears[Memory.Game.ClearCount] += 1;

    if HappenedKillScreen then
      Memory.Game.AfterKillScreen := True;

    if Memory.Game.ClearCount = 4 then
      Memory.Game.Burned := 0
    else
    begin
      Memory.Game.Burned += Memory.Game.ClearCount;
      Memory.Game.LinesBurned += Memory.Game.ClearCount;
    end;

    if not Memory.Game.AfterKillScreen then
      Memory.Game.TetrisRate := Round((Memory.Game.LinesCleared - Memory.Game.LinesBurned) / Memory.Game.Lines * 100);
  end;

  Gain := Memory.Game.FallPoints;
  Gain += (Memory.Game.Level + 1) * LINECLEAR_VALUE[Memory.Game.ClearCount];

  Memory.Game.Score += Gain;

  if Gain > 0 then
  begin
    Memory.Game.Gain := Gain;
    Memory.Game.GainTimer := GAIN_SECONDS_VISIBLE * Clock.FrameRateLimit;
  end;

  if HappenedFirstTransition or HappenedAnyTransition then
  begin
    if (Memory.Play.Level < 19) and (Memory.Game.Level = 19) then Memory.Game.Transition := Memory.Game.Score;
    if (Memory.Play.Level = 19) and (Memory.Game.Level = 20) then Memory.Game.Transition := Memory.Game.Score;
  end;

  Memory.Game.State := STATE_STACK_LOWER;
  Memory.Game.LowerTimer := 1;
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
  Memory.Game.Next := Generators.Generator.Pick();

  Memory.Game.Level := Memory.Play.Level;
  Memory.Game.Stats[Memory.Game.PieceID] += 1;
end;


procedure TCore.Update();
begin
  UpdateCommon();

  case Memory.Game.State of
    STATE_PIECE_CONTROL:   UpdatePieceControl();
    STATE_PIECE_LOCK:      UpdatePieceLock();
    STATE_PIECE_SPAWN:     UpdatePieceSpawn();
    STATE_LINES_CHECK:     UpdateLinesCheck();
    STATE_LINES_CLEAR:     UpdateLinesClear();
    STATE_STACK_LOWER:     UpdateStackLower();
    STATE_UPDATE_COUNTERS: UpdateCounters();
    STATE_UPDATE_TOP_OUT:  UpdateTopOut();
  end;
end;


end.

