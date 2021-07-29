unit Fairtris.Generators;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TShiftRegister = class(TObject)
  private
    FSeed: UInt16;
  public
    procedure Initialize();
  public
    procedure Reset();
    procedure Update();
  public
    property Seed: UInt16 read FSeed;
  end;


type
  TCustomGenerator = class(TInterfacedObject)
  protected
    FRegister: TShiftRegister;
  public
    constructor Create(); virtual;
    destructor Destroy(); override;
  public
    procedure Initialize(); virtual;
  public
    procedure Reset(); virtual; abstract;
    procedure Update(); virtual; abstract;
  end;


implementation


procedure TShiftRegister.Initialize();
begin
  Reset();
end;


procedure TShiftRegister.Reset();
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


end.

