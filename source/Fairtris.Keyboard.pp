unit Fairtris.Keyboard;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Interfaces,
  Fairtris.Classes,
  Fairtris.Constants;


type
  TDevice = class(TObject)
  private type
    TKeys = array [UInt8] of TSwitch;
    TStatus = array [UInt8] of UInt8;
  private
    FStatus: TStatus;
    FConnected: Boolean;
  private
    FKeys: TKeys;
  private
    procedure InitKeys();
    procedure DoneKeys();
  private
    procedure UpdateKeys();
  private
    function GetKey(AIndex: UInt8): TSwitch;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Reset();
    procedure Update();
  public
    procedure Validate();
    procedure Invalidate();
  public
    property Key[AIndex: UInt8]: TSwitch read GetKey; default;
  public
    property Connected: Boolean read FConnected;
  end;


type
  TKeyboard = class(TInterfacedObject, IControllable)
  private type
    TScanCodes = array [0 .. 7] of UInt8;
  private
    FDevice: TDevice;
    FScanCodes: TScanCodes;
  private
    procedure InitDevice();
    procedure InitScanCodes();
  private
    procedure DoneDevice();
  private
    function GetSwitch(AIndex: Integer): TSwitch;
    function GetScanCode(AIndex: Integer): UInt8;
    function GetConnected(): Boolean;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Initialize();
  public
    procedure Reset();
    procedure Update();
    procedure Restore();
  public
    procedure Validate();
    procedure Invalidate();
  public
    property Device: TDevice read FDevice;
  public
    property Connected: Boolean read GetConnected;
    property ScanCode[AIndex: Integer]: UInt8 read GetScanCode;
  public
    property Up: TSwitch index KEYBOARD_KEY_UP read GetSwitch;
    property Down: TSwitch index KEYBOARD_KEY_DOWN read GetSwitch;
    property Left: TSwitch index KEYBOARD_KEY_LEFT read GetSwitch;
    property Right: TSwitch index KEYBOARD_KEY_RIGHT read GetSwitch;
    property Select: TSwitch index KEYBOARD_KEY_SELECT read GetSwitch;
    property Start: TSwitch index KEYBOARD_KEY_START read GetSwitch;
    property B: TSwitch index KEYBOARD_KEY_B read GetSwitch;
    property A: TSwitch index KEYBOARD_KEY_A read GetSwitch;
  end;


implementation

uses
  Windows;


constructor TDevice.Create();
begin
  InitKeys();
end;


destructor TDevice.Destroy();
begin
  DoneKeys();
  inherited Destroy();
end;


procedure TDevice.InitKeys();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index] := TSwitch.Create(False);
end;


procedure TDevice.DoneKeys();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Free();
end;


procedure TDevice.UpdateKeys();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Pressed := FStatus[Index] and %10000000 <> 0;
end;


function TDevice.GetKey(AIndex: UInt8): TSwitch;
begin
  Result := FKeys[AIndex];
end;


procedure TDevice.Reset();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Reset();
end;


procedure TDevice.Update();
begin
  FillChar(FStatus, Length(FStatus), 0);
  FConnected := GetKeyboardState(@FStatus);

  if FConnected then
    UpdateKeys()
  else
    Reset();
end;


procedure TDevice.Validate();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Validate();
end;


procedure TDevice.Invalidate();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Invalidate();
end;


constructor TKeyboard.Create();
begin
  InitDevice();
  InitScanCodes();
end;


destructor TKeyboard.Destroy();
begin
  DoneDevice();
  inherited Destroy();
end;


procedure TKeyboard.InitDevice();
begin
  FDevice := TDevice.Create();
end;


procedure TKeyboard.InitScanCodes();
begin
  Restore();
end;


procedure TKeyboard.DoneDevice();
begin
  FDevice.Free();
end;


function TKeyboard.GetSwitch(AIndex: Integer): TSwitch;
begin
  Result := FDevice.Key[FScanCodes[AIndex]];
end;


function TKeyboard.GetScanCode(AIndex: Integer): UInt8;
begin
  Result := FScanCodes[AIndex];
end;


function TKeyboard.GetConnected(): Boolean;
begin
  Result := FDevice.Connected;
end;


procedure TKeyboard.Initialize();
begin
  // załadować kody klawiszy z "Settings" i wpisać je do FScanCodes
end;


procedure TKeyboard.Reset();
begin
  FDevice.Reset();
end;


procedure TKeyboard.Update();
begin
  FDevice.Update();
end;


procedure TKeyboard.Restore();
begin
  FScanCodes[KEYBOARD_KEY_UP]     := VK_UP;
  FScanCodes[KEYBOARD_KEY_DOWN]   := VK_DOWN;
  FScanCodes[KEYBOARD_KEY_LEFT]   := VK_LEFT;
  FScanCodes[KEYBOARD_KEY_RIGHT]  := VK_RIGHT;
  FScanCodes[KEYBOARD_KEY_SELECT] := VK_A;
  FScanCodes[KEYBOARD_KEY_START]  := VK_S;
  FScanCodes[KEYBOARD_KEY_B]      := VK_Z;
  FScanCodes[KEYBOARD_KEY_A]      := VK_X;
end;


procedure TKeyboard.Validate();
begin
  FDevice.Validate();
end;


procedure TKeyboard.Invalidate();
begin
  FDevice.Invalidate();
end;


end.

