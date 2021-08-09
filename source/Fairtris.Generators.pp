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
  public
    procedure Shuffle(); virtual; abstract;
    procedure Step(); virtual; abstract;
  public
    function Pick(): Integer; virtual; abstract;
  end;


type
  TBag = class(TObject)
  private
    FPieces: array of Integer;
    FSize: Integer;
  private
    function GetPiece(AIndex: Integer): Integer;
  public
    constructor Create(const APieces: array of Integer);
  public
    function Shuffle(ASeed: UInt16): Boolean;
  public
    property Piece[AIndex: Integer]: Integer read GetPiece; default;
    property Size: Integer read FSize;
  end;


type
  T7BagGenerator = class(TCustomGenerator)
  public
    procedure Initialize(); override;
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
  public
    procedure Initialize(); override;
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
  Math,
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


constructor TBag.Create(const APieces: array of Integer);
var
  Index: Integer;
begin
  FSize := Length(APieces);
  SetLength(FPieces, FSize);

  for Index := 0 to FSize - 1 do
    FPieces[Index] := APieces[Index];
end;


function TBag.Shuffle(ASeed: UInt16): Boolean;
var
  IndexA, IndexB, TempPiece: Integer;
begin
  IndexA := Hi(ASeed) mod FSize;
  IndexB := Lo(ASeed) mod FSize;

  Result := IndexA <> IndexB;

  if Result then
  begin
    TempPiece := FPieces[IndexA];
    FPieces[IndexA] := FPieces[IndexB];
    FPieces[IndexB] := TempPiece;
  end;
end;


function TBag.GetPiece(AIndex: Integer): Integer;
begin
  Result := FPieces[AIndex];
end;


procedure T7BagGenerator.Initialize();
begin
  inherited Initialize();
end;


procedure T7BagGenerator.Shuffle();
begin

end;


procedure T7BagGenerator.Step();
begin

end;


function T7BagGenerator.Pick(): Integer;
begin

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


procedure TClassicGenerator.Initialize();
begin
  inherited Initialize();
end;


procedure TClassicGenerator.Shuffle();
begin

end;


procedure TClassicGenerator.Step();
begin

end;


function TClassicGenerator.Pick(): Integer;
begin

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
  Result := FGenerators[FGeneratorID];
end;


procedure TGenerators.SetGeneratorID(AGeneratorID: Integer);
begin
  FGeneratorID := AGeneratorID;
  FGenerator := FGenerators[FGeneratorID];

  // added only for testing game core logic
  FGeneratorID := RNG_UNFAIR;
  FGenerator := FGenerators[RNG_UNFAIR];
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

