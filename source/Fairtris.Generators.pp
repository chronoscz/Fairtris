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
    FGenerators: array [RNG_FIRST .. RNG_LAST] of IGenerable;
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
    property Generators[AGeneratorID: Integer]: IGenerable read GetGenerator;
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
  FGenerators[RNG_7_BAG]    := T7BagGenerator.Create();
  FGenerators[RNG_MULTIBAG] := TMultiBagGenerator.Create();
  FGenerators[RNG_CLASSIC]  := TClassicGenerator.Create();
  FGenerators[RNG_UNFAIR]   := TUnfairGenerator.Create();
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
  SetGeneratorID(Settings.General.RNG);

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

