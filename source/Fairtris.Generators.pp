{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Generators;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  FGL,
  Fairtris.Interfaces,
  Fairtris.Constants;


type
  TShiftRegister = class(TObject)
  private
    FSeed: UInt16;
  public
    procedure Initialize();
    procedure Step();
  public
    property Seed: UInt16 read FSeed;
  end;


type
  TBag = class(TObject)
  private type
    TItems = specialize TFPGList<Integer>;
  private
    FItems: TItems;
  private
    function GetItem(AIndex: Integer): Integer;
    function GetSize(): Integer;
  public
    constructor Create(const ACount: Integer);
    constructor Create(const AItems: array of Integer);
    destructor Destroy(); override;
  public
    procedure Swap(ASeed: UInt16);
    procedure SwapFirst();
  public
    property Item[AIndex: Integer]: Integer read GetItem; default;
    property Size: Integer read GetSize;
  end;


type
  TPool = class(TBag)
  private
    procedure SetItem(AIndex, AItem: Integer);
    function GetEmpty(): Boolean;
  public
    procedure Append(AItem: Integer);
    procedure Remove(AItem: Integer);
    procedure Push(AItem: Integer);
    procedure Clear();
  public
    function Contains(AItem: Integer): Boolean;
  public
    property Item[AIndex: Integer]: Integer read GetItem write SetItem; default;
    property Empty: Boolean read GetEmpty;
  end;


type
  TCustomGenerator = class(TInterfacedObject, IGenerable)
  protected
    FRegister: TShiftRegister;
  public
    constructor Create(); virtual;
    destructor Destroy(); override;
  public
    procedure Initialize(); virtual;
    procedure Prepare(); virtual;
  public
    procedure Shuffle(); virtual; abstract;
    procedure Step(); virtual; abstract;
  public
    function Pick(): Integer; virtual; abstract;
  end;


type
  T7BagGenerator = class(TCustomGenerator)
  private
    FBags: array [0 .. 1] of TBag;
  private
    FBagPick: Integer;
    FBagSwap: Integer;
    FBagPiece: Integer;
  public
    constructor Create(); override;
    destructor Destroy(); override;
  public
    procedure Initialize(); override;
    procedure Prepare(); override;
  public
    procedure Shuffle(); override;
    procedure Step(); override;
  public
    function Pick(): Integer; override;
  end;


type
  TMultiBagGenerator = class(TCustomGenerator)
  private
    FIndexBags: array [0 .. 1] of TBag;
    FPieceBags: array [MULTIBAG_BAG_FIRST .. MULTIBAG_BAG_LAST] of TBag;
  private
    FIndexPick: Integer;
  private
    FBagPick: Integer;
    FBagSwap: Integer;
    FBagPiece: Integer;
  public
    constructor Create(); override;
    destructor Destroy(); override;
  public
    procedure Initialize(); override;
    procedure Prepare(); override;
  public
    procedure Shuffle(); override;
    procedure Step(); override;
  public
    function Pick(): Integer; override;
  end;


type
  TClassicGenerator = class(TCustomGenerator)
  private
    FSpawnID: UInt8;
    FSpawnCount: UInt8;
  private
    function IndexToSpawnID(AIndex: UInt8): UInt8;
    function SpawnIDToPieceID(ASpawnID: UInt8): Integer;
  public
    procedure Shuffle(); override;
    procedure Step(); override;
  public
    function Pick(): Integer; override;
  end;


type
  TBalancedGenerator = class(TCustomGenerator)
  public
    procedure Shuffle(); override;
    procedure Step(); override;
  public
    function Pick(): Integer; override;
  end;


type
  TTGMGenerator = class(TCustomGenerator)
  private
    FPieces: TPool;
    FSpecial: TPool;
    FHistory: TPool;
  public
    constructor Create(); override;
    destructor Destroy(); override;
  public
    procedure Prepare(); override;
  public
    procedure Shuffle(); override;
    procedure Step(); override;
  public
    function Pick(): Integer; override;
  end;


type
  TTGM3Generator = class(TCustomGenerator)
  private
    FPieces: TPool;
    FSpecial: TPool;
  private
    FPool: TPool;
    FOrder: TPool;
    FHistory: TPool;
  public
    constructor Create(); override;
    destructor Destroy(); override;
  public
    procedure Prepare(); override;
  public
    procedure Shuffle(); override;
    procedure Step(); override;
  public
    function Pick(): Integer; override;
  end;


type
  TUnfairGenerator = class(TCustomGenerator)
  public
    procedure Shuffle(); override;
    procedure Step(); override;
  public
    function Pick(): Integer; override;
  end;


type
  TGenerators = class(TObject)
  private
    FGenerator: IGenerable;
    FGeneratorID: Integer;
  private
    FGenerators: array [GENERATOR_FIRST .. GENERATOR_LAST] of IGenerable;
  private
    function GetGenerator(AGeneratorID: Integer): IGenerable;
    procedure SetGeneratorID(AGeneratorID: Integer);
  public
    constructor Create();
  public
    procedure Initialize();
    procedure Shuffle();
  public
    property Generator: IGenerable read FGenerator;
    property Generators[AGeneratorID: Integer]: IGenerable read GetGenerator; default;
    property GeneratorID: Integer read FGeneratorID write SetGeneratorID;
  end;


var
  Generators: TGenerators;


implementation

uses
  Fairtris.Clock,
  Fairtris.Settings,
  Fairtris.Arrays;


procedure TShiftRegister.Initialize();
begin
  FSeed := $8988;
end;


procedure TShiftRegister.Step();
begin
  FSeed := ((((FSeed shr 9) and 1) xor ((FSeed shr 1) and 1)) shl 15) or (FSeed shr 1);
end;


constructor TBag.Create(const ACount: Integer);
var
  Index: Integer;
begin
  FItems := TItems.Create();

  for Index := 0 to ACount - 1 do
    FItems.Add(Index);
end;


constructor TBag.Create(const AItems: array of Integer);
var
  Index: Integer;
begin
  FItems := TItems.Create();

  for Index := 0 to High(AItems) do
    FItems.Add(AItems[Index]);
end;


destructor TBag.Destroy();
begin
  FItems.Free();
  inherited Destroy();
end;


function TBag.GetItem(AIndex: Integer): Integer;
begin
  Result := FItems[AIndex];
end;


function TBag.GetSize(): Integer;
begin
  Result := FItems.Count;
end;


procedure TBag.Swap(ASeed: UInt16);
var
  IndexA, IndexB: Integer;
begin
  IndexA := Hi(ASeed) mod FItems.Count;
  IndexB := Lo(ASeed) mod FItems.Count;

  if IndexA <> IndexB then
    FItems.Exchange(IndexA, IndexB);
end;


procedure TBag.SwapFirst();
begin
  FItems.Exchange(0, 1);
end;


procedure TPool.SetItem(AIndex, AItem: Integer);
begin
  FItems[AIndex] := AItem;
end;


function TPool.GetEmpty(): Boolean;
begin
  Result := FItems.Count = 0;
end;


procedure TPool.Append(AItem: Integer);
begin
  FItems.Add(AItem);
end;


procedure TPool.Remove(AItem: Integer);
begin
  FItems.Remove(AItem);
end;


procedure TPool.Push(AItem: Integer);
begin
  FItems.Delete(0);
  FItems.Add(AItem);
end;


procedure TPool.Clear();
begin
  FItems.Clear();
end;


function TPool.Contains(AItem: Integer): Boolean;
begin
  Result := FItems.IndexOf(AItem) <> -1;
end;


constructor TCustomGenerator.Create();
begin
  FRegister := TShiftRegister.Create();
end;


destructor TCustomGenerator.Destroy();
begin
  FRegister.Free();
  inherited Destroy();
end;


procedure TCustomGenerator.Initialize();
begin
  FRegister.Initialize();
end;


procedure TCustomGenerator.Prepare();
begin

end;


constructor T7BagGenerator.Create();
begin
  inherited Create();

  FBags[0] := TBag.Create([PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L, PIECE_I]);
  FBags[1] := TBag.Create([PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L, PIECE_I]);
end;


destructor T7BagGenerator.Destroy();
begin
  FBags[0].Free();
  FBags[1].Free();

  inherited Destroy();
end;


procedure T7BagGenerator.Initialize();
begin
  inherited Initialize();

  FBagPick := 0;
  FBagSwap := 1;

  FBagPiece := 0;
end;


procedure T7BagGenerator.Prepare();
begin
  inherited Prepare();
  FBagPiece := 0;
end;


procedure T7BagGenerator.Shuffle();
begin
  FRegister.Step();
  FBags[0].Swap(FRegister.Seed);

  FRegister.Step();
  FBags[1].Swap(FRegister.Seed);

  FBagPick := FBagPick xor 1;
  FBagSwap := FBagSwap xor 1;

  FBagPiece := (FBagPiece + 1) mod FBags[0].Size;
end;


procedure T7BagGenerator.Step();
begin
  FRegister.Step();
  FBags[FBagSwap].Swap(FRegister.Seed);
end;


function T7BagGenerator.Pick(): Integer;
begin
  Result := FBags[FBagPick][FBagPiece];
  FBagPiece := (FBagPiece + 1) mod FBags[FBagPick].Size;

  if FBagPiece = 0 then
  begin
    FBagPick := FBagPick xor 1;
    FBagSwap := FBagSwap xor 1;
  end;
end;


constructor TMultiBagGenerator.Create();
var
  Index: Integer;
begin
  inherited Create();

  for Index := Low(FIndexBags) to High(FIndexBags) do
    FIndexBags[Index] := TBag.Create(MULTIBAG_BAGS_COUNT);

  for Index := Low(FPieceBags) to High(FPieceBags) do
    FPieceBags[Index] := TBag.Create(MULTIBAG_BAGS[Index]);
end;


destructor TMultiBagGenerator.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FIndexBags) to High(FIndexBags) do
    FIndexBags[Index].Free();

  for Index := Low(FPieceBags) to High(FPieceBags) do
    FPieceBags[Index].Free();

  inherited Destroy();
end;


procedure TMultiBagGenerator.Initialize();
begin
  inherited Initialize();

  FIndexPick := 0;

  FBagPick := MULTIBAG_BAG_FIRST;
  FBagSwap := MULTIBAG_BAG_FIRST + 1;

  FBagPiece := MULTIBAG_PIECE_FIRST;
end;


procedure TMultiBagGenerator.Prepare();
begin
  inherited Prepare();

  FIndexPick := 0;

  FBagPick := FBagPick xor 1;
  FBagSwap := FBagSwap xor 1;
end;


procedure TMultiBagGenerator.Shuffle();
var
  Index: Integer;
begin
  if Clock.FrameIndex mod 4 = 0 then
    for Index := Low(FIndexBags) to High(FIndexBags) do
    begin
      FRegister.Step();
      FIndexBags[Index].Swap(FRegister.Seed);
    end
  else
    for Index := Low(FPieceBags) to High(FPieceBags) do
    begin
      FRegister.Step();
      FPieceBags[Index].Swap(FRegister.Seed);
    end;

  FIndexPick := (FIndexPick + 1) mod FIndexBags[0].Size;

  FBagPick := FBagPick xor 1;
  FBagSwap := FBagSwap xor 1;

  FBagPiece := (FBagPiece + 1) mod FPieceBags[0].Size;
end;


procedure TMultiBagGenerator.Step();
var
  Index: Integer;
begin
  FRegister.Step();
  FIndexBags[FBagSwap].Swap(FRegister.Seed);

  for Index := MULTIBAG_BAG_FIRST to MULTIBAG_BAG_LAST do
    if Index <> FIndexBags[FBagPick][FIndexPick] then
    begin
      FRegister.Step();
      FPieceBags[Index].Swap(FRegister.Seed);
    end;
end;


function TMultiBagGenerator.Pick(): Integer;
begin
  Result := FPieceBags[FIndexBags[FBagPick][FIndexPick]][FBagPiece];
  FBagPiece := (FBagPiece + 1) mod FPieceBags[0].Size;

  if FBagPiece = 0 then
  begin
    FIndexPick := (FIndexPick + 1) mod FIndexBags[0].Size;

    if FIndexPick = 0 then
    begin
      if FIndexBags[FBagPick][FIndexBags[FBagPick].Size - 1] = FIndexBags[FBagSwap][0] then
        FIndexBags[FBagSwap].SwapFirst();

      FBagPick := FBagPick xor 1;
      FBagSwap := FBagSwap xor 1;
    end;
  end;
end;


function TClassicGenerator.IndexToSpawnID(AIndex: UInt8): UInt8;
begin
  case AIndex of
    0: Result := $02;
    1: Result := $07;
    2: Result := $08;
    3: Result := $0A;
    4: Result := $0B;
    5: Result := $0E;
    6: Result := $12;
    7: Result := $02;
  otherwise
    Result := $02;
  end;
end;


function TClassicGenerator.SpawnIDToPieceID(ASpawnID: UInt8): Integer;
begin
  case ASpawnID of
    $02: Result := PIECE_T;
    $07: Result := PIECE_J;
    $08: Result := PIECE_Z;
    $0A: Result := PIECE_O;
    $0B: Result := PIECE_S;
    $0E: Result := PIECE_L;
    $12: Result := PIECE_I;
  otherwise
    Result := PIECE_T;
  end;
end;


procedure TClassicGenerator.Shuffle();
begin
  FRegister.Step();
end;


procedure TClassicGenerator.Step();
begin
  FRegister.Step();
end;


function TClassicGenerator.Pick(): Integer;
var
  Index: UInt8;
begin
  {$PUSH}{$RANGECHECKS OFF}
  FSpawnCount += 1;
  Index := (Hi(FRegister.Seed) + FSpawnCount) and %111;
  {$POP}

  if (Index = 7) or (IndexToSpawnID(Index) = FSpawnID) then
  begin
    FRegister.Step();
    Index := ((Hi(FRegister.Seed) and %111) + FSpawnID) mod 7;
  end;

  FSpawnID := IndexToSpawnID(Index);
  Result := SpawnIDToPieceID(FSpawnID);
end;


procedure TBalancedGenerator.Shuffle();
begin

end;


procedure TBalancedGenerator.Step();
begin

end;


function TBalancedGenerator.Pick(): Integer;
begin

end;


constructor TTGMGenerator.Create();
begin
  inherited Create();

  FPieces := TPool.Create(TGM_POOL_PIECES);
  FSpecial := TPool.Create(TGM_POOL_SPECIAL);
  FHistory := TPool.Create(TGM_POOL_HISTORY);
end;


destructor TTGMGenerator.Destroy();
begin
  FPieces.Free();
  FSpecial.Free();
  FHistory.Free();

  inherited Destroy();
end;


procedure TTGMGenerator.Prepare();
begin
  inherited Prepare();

  FHistory.Free();
  FHistory := TPool.Create(TGM_POOL_HISTORY);
end;


procedure TTGMGenerator.Shuffle();
begin
  FRegister.Step();
end;


procedure TTGMGenerator.Step();
begin
  FRegister.Step();
end;


function TTGMGenerator.Pick(): Integer;
var
  Roll: Integer;
begin
  if FHistory.Size = TGM_POOL_HISTORY_COUNT then
  begin
    Result := FSpecial[Hi(FRegister.Seed) mod FSpecial.Size];
    FHistory.Append(Result);
  end
  else
  begin
    for Roll := 0 to 3 do
    begin
      FRegister.Step();
      Result := FPieces[Hi(FRegister.Seed) mod FPieces.Size];

      if not FHistory.Contains(Result) then Break;
    end;

    FHistory.Push(Result);
  end;
end;


constructor TTGM3Generator.Create();
begin
  inherited Create();

  FPieces := TPool.Create(TGM3_POOL_PIECES);
  FSpecial := TPool.Create(TGM3_POOL_SPECIAL);

  FPool := TPool.Create(TGM3_POOL_POOL);
  FHistory := TPool.Create(TGM3_POOL_HISTORY);

  FOrder := TPool.Create([]);
end;


destructor TTGM3Generator.Destroy();
begin
  FPieces.Free();
  FSpecial.Free();
  FPool.Free();
  FHistory.Free();
  FOrder.Free();

  inherited Destroy();
end;


procedure TTGM3Generator.Prepare();
begin
  inherited Prepare();

  FPool.Free();
  FPool := TPool.Create(TGM3_POOL_POOL);

  FHistory.Free();
  FHistory := TPool.Create(TGM3_POOL_HISTORY);

  FOrder.Clear();
end;


procedure TTGM3Generator.Shuffle();
begin
  FRegister.Step();
end;


procedure TTGM3Generator.Step();
begin
  FRegister.Step();
end;


function TTGM3Generator.Pick(): Integer;
var
  Roll, Index: Integer;
begin
  if FHistory.Size = TGM3_POOL_HISTORY_COUNT then
  begin
    Result := FSpecial[Hi(FRegister.Seed) mod FSpecial.Size];
    FHistory.Append(Result);
  end
  else
  begin
    for Roll := 0 to 5 do
    begin
      FRegister.Step();

      Index := Hi(FRegister.Seed) mod FPool.Size;
      Result := FPool[Index];

      if (not FHistory.Contains(Result)) or (Roll = 5) then Break;

      if not FOrder.Empty then
        FPool[Index] := FOrder[0];
    end;

    FOrder.Remove(Result);
    FOrder.Append(Result);

    FPool[Index] := FOrder[0];
    FHistory.Push(Result);
  end;
end;


procedure TUnfairGenerator.Shuffle();
begin
  FRegister.Step();
end;


procedure TUnfairGenerator.Step();
begin
  FRegister.Step();
end;


function TUnfairGenerator.Pick(): Integer;
begin
  Result := Hi(FRegister.Seed) mod PIECE_LAST + PIECE_FIRST;
end;


constructor TGenerators.Create();
begin
  FGenerators[GENERATOR_7_BAG]    := T7BagGenerator.Create();
  FGenerators[GENERATOR_MULTIBAG] := TMultiBagGenerator.Create();
  FGenerators[GENERATOR_CLASSIC]  := TClassicGenerator.Create();
  FGenerators[GENERATOR_TGM]      := TTGMGenerator.Create();
  FGenerators[GENERATOR_TGM3]     := TTGM3Generator.Create();
  FGenerators[GENERATOR_UNFAIR]   := TUnfairGenerator.Create();
end;


function TGenerators.GetGenerator(AGeneratorID: Integer): IGenerable;
begin
  Result := FGenerators[AGeneratorID];
end;


procedure TGenerators.SetGeneratorID(AGeneratorID: Integer);
begin
  FGeneratorID := AGeneratorID;
  FGenerator := FGenerators[FGeneratorID];
end;


procedure TGenerators.Initialize();
var
  Index: Integer;
begin
  SetGeneratorID(Settings.General.Generator);

  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index].Initialize();
end;


procedure TGenerators.Shuffle();
var
  Index: Integer;
begin
  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index].Shuffle();
end;


end.

