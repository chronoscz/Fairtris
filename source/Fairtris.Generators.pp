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
  TRandomGenerator = class(TCustomGenerator)
  public
    procedure Initialize(); override;
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


procedure TRandomGenerator.Initialize();
begin
  inherited Initialize();
end;


procedure TRandomGenerator.Shuffle();
begin
  FRegister.Update();
end;


procedure TRandomGenerator.Step();
begin
  FRegister.Update();
end;


function TRandomGenerator.Pick(): Integer;
begin
  Result := Hi(FRegister.Seed) mod PIECE_LAST + PIECE_FIRST;
end;


constructor TGenerators.Create();
begin
  FGenerators[RNG_7_BAG]   := T7BagGenerator.Create();
  FGenerators[RNG_FAIR]    := TFairGenerator.Create();
  FGenerators[RNG_CLASSIC] := TClassicGenerator.Create();
  FGenerators[RNG_RANDOM]  := TRandomGenerator.Create();
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
  FGeneratorID := RNG_RANDOM;
  FGenerator := FGenerators[RNG_RANDOM];
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


end.

