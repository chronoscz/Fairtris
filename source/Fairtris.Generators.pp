unit Fairtris.Generators;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Interfaces,
  Fairtris.Constants;


type
  TShiftRegister = class(TObject)
  private
    FSeed: UInt16;
  public
    procedure Initialize();
    procedure Update();
  public
    property Seed: UInt16 read FSeed;
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
  TBag = class(TObject)
  private
    FItems: array of Integer;
    FSize: Integer;
  private
    function GetItem(AIndex: Integer): Integer;
  public
    constructor Create(const AItems: array of Integer);
  public
    function Swap(ASeed: UInt16): Boolean;
  public
    property Item[AIndex: Integer]: Integer read GetItem; default;
    property Size: Integer read FSize;
  end;


type
  T7BagGenerator = class(TCustomGenerator)
  private
    FBags: array [0 .. 1] of TBag;
  private
    FIndexBagPick: Integer;
    FIndexBagSwap: Integer;
    FIndexPiece: Integer;
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
  TFairGenerator = class(TCustomGenerator)
  public
    procedure Initialize(); override;
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
  Fairtris.Settings;


procedure TShiftRegister.Initialize();
begin
  FSeed := $8988;
end;


procedure TShiftRegister.Update();
begin
  FSeed := ((((FSeed shr 9) and 1) xor ((FSeed shr 1) and 1)) shl 15) or (FSeed shr 1);
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


constructor TBag.Create(const AItems: array of Integer);
var
  Index: Integer;
begin
  FSize := Length(AItems);
  SetLength(FItems, FSize);

  for Index := 0 to FSize - 1 do
    FItems[Index] := AItems[Index];
end;


function TBag.Swap(ASeed: UInt16): Boolean;
var
  IndexA, IndexB, TempPiece: Integer;
begin
  IndexA := Hi(ASeed) mod FSize;
  IndexB := Lo(ASeed) mod FSize;

  Result := IndexA <> IndexB;

  if Result then
  begin
    TempPiece := FItems[IndexA];
    FItems[IndexA] := FItems[IndexB];
    FItems[IndexB] := TempPiece;
  end;
end;


function TBag.GetItem(AIndex: Integer): Integer;
begin
  Result := FItems[AIndex];
end;


constructor T7BagGenerator.Create();
begin
  inherited Create();

  FBags[0] := TBag.Create([PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L, PIECE_I]);
  FBags[1] := TBag.Create([PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L, PIECE_I]);

  FIndexBagPick := 0;
  FIndexBagSwap := 1;

  FIndexPiece := 0;
end;


destructor T7BagGenerator.Destroy();
begin
  FBags[0].Free();
  FBags[1].Free();

  inherited Destroy();
end;


procedure T7BagGenerator.Prepare();
begin
  inherited Prepare();
  FIndexPiece := 0;
end;


procedure T7BagGenerator.Shuffle();
begin
  repeat FRegister.Update() until FBags[0].Swap(FRegister.Seed);
  repeat FRegister.Update() until FBags[1].Swap(FRegister.Seed);

  FIndexBagPick := FIndexBagPick xor 1;
  FIndexBagSwap := FIndexBagSwap xor 1;

  FIndexPiece := (FIndexPiece + 1) mod FBags[0].Size;
end;


procedure T7BagGenerator.Step();
begin
  repeat FRegister.Update() until FBags[FIndexBagSwap].Swap(FRegister.Seed);
end;


function T7BagGenerator.Pick(): Integer;
begin
  Result := FBags[FIndexBagPick][FIndexPiece];
  FIndexPiece := (FIndexPiece + 1) mod FBags[FIndexBagPick].Size;

  if FIndexPiece = 0 then
  begin
    FIndexBagPick := FIndexBagPick xor 1;
    FIndexBagSwap := FIndexBagSwap xor 1;
  end;
end;


procedure TFairGenerator.Initialize();
begin
  inherited Initialize();
end;


procedure TFairGenerator.Shuffle();
begin

end;


procedure TFairGenerator.Step();
begin

end;


function TFairGenerator.Pick(): Integer;
begin

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
  FRegister.Update();
end;


procedure TClassicGenerator.Step();
begin
  FRegister.Update();
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
    FRegister.Update();
    Index := ((Hi(FRegister.Seed) and %111) + FSpawnID) mod 7;
  end;

  FSpawnID := IndexToSpawnID(Index);
  Result := SpawnIDToPieceID(FSpawnID);
end;


procedure TUnfairGenerator.Shuffle();
begin
  FRegister.Update();
end;


procedure TUnfairGenerator.Step();
begin
  FRegister.Update();
end;


function TUnfairGenerator.Pick(): Integer;
begin
  Result := Hi(FRegister.Seed) mod PIECE_LAST + PIECE_FIRST;
end;


constructor TGenerators.Create();
begin
  FGenerators[RNG_7_BAG]   := T7BagGenerator.Create();
  FGenerators[RNG_FAIR]    := TFairGenerator.Create();
  FGenerators[RNG_CLASSIC] := TClassicGenerator.Create();
  FGenerators[RNG_UNFAIR]  := TUnfairGenerator.Create();
end;


function TGenerators.GetGenerator(AGeneratorID: Integer): IGenerable;
begin
  Result := FGenerators[AGeneratorID];
end;


procedure TGenerators.SetGeneratorID(AGeneratorID: Integer);
begin
  FGeneratorID := AGeneratorID;
  FGenerator := FGenerators[FGeneratorID];

  // added only for testing game core logic
  if AGeneratorID = RNG_FAIR then
  begin
    FGeneratorID := RNG_UNFAIR;
    FGenerator := FGenerators[RNG_UNFAIR];
  end;
  // remove after testing
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

