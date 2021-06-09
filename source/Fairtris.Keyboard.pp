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
    function GetKey(AKeyID: UInt8): TSwitch;
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
    property Key[AKeyID: UInt8]: TSwitch read GetKey; default;
    property Connected: Boolean read FConnected;
  end;


type
  TKeyboard = class(TInterfacedObject, IControllable)
  private type
    TScanCodes = array [KEYBOARD_KEY_FIRST .. KEYBOARD_KEY_LAST] of UInt8;
  private
    FDevice: TDevice;
  private
    FScanCodesDefault: TScanCodes;
    FScanCodesUsed: TScanCodes;
  private
    procedure InitDevice();
    procedure InitScanCodesDefault();
    procedure InitScanCodesUsed();
  private
    procedure DoneDevice();
  private
    function GetSwitch(AKeyID: Integer): TSwitch;
    function GetScanCode(AKeyID: Integer): UInt8;
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
    procedure Introduce();
  public
    procedure Validate();
    procedure Invalidate();
  public
    function CatchedOneKey(out AScanCode: UInt8): Boolean;
  public
    property Device: TDevice read FDevice;
    property Connected: Boolean read GetConnected;
  public
    property Switch[AKeyID: Integer]: TSwitch read GetSwitch;
    property ScanCode[AKeyID: Integer]: UInt8 read GetScanCode;
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
  Windows,
  Fairtris.Memory,
  Fairtris.Settings,
  Fairtris.Arrays;


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


function TDevice.GetKey(AKeyID: UInt8): TSwitch;
begin
  if AKeyID in KEYBOARD_KEY_LOCKED then
    Result := FKeys[0]
  else
    Result := FKeys[AKeyID];
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
  InitScanCodesDefault();
  InitScanCodesUsed();
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


procedure TKeyboard.InitScanCodesDefault();
begin
  FScanCodesDefault[KEYBOARD_KEY_UP]     := VK_UP;
  FScanCodesDefault[KEYBOARD_KEY_DOWN]   := VK_DOWN;
  FScanCodesDefault[KEYBOARD_KEY_LEFT]   := VK_LEFT;
  FScanCodesDefault[KEYBOARD_KEY_RIGHT]  := VK_RIGHT;
  FScanCodesDefault[KEYBOARD_KEY_SELECT] := VK_A;
  FScanCodesDefault[KEYBOARD_KEY_START]  := VK_S;
  FScanCodesDefault[KEYBOARD_KEY_B]      := VK_Z;
  FScanCodesDefault[KEYBOARD_KEY_A]      := VK_X;
end;


procedure TKeyboard.InitScanCodesUsed();
begin
  Restore();
end;


procedure TKeyboard.DoneDevice();
begin
  FDevice.Free();
end;


function TKeyboard.GetSwitch(AKeyID: Integer): TSwitch;
begin
  Result := FDevice.Key[FScanCodesUsed[AKeyID]];
end;


function TKeyboard.GetScanCode(AKeyID: Integer): UInt8;
begin
  Result := FScanCodesUsed[AKeyID];
end;


function TKeyboard.GetConnected(): Boolean;
begin
  Result := FDevice.Connected;
end;


procedure TKeyboard.Initialize();
begin
  FScanCodesUsed := Settings.Keyboard.ScanCodes;
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
  FScanCodesUsed := FScanCodesDefault;
end;


procedure TKeyboard.Introduce();
begin
  FScanCodesUsed := Memory.Keyboard.ScanCodes;
end;


procedure TKeyboard.Validate();
begin
  FDevice.Validate();
end;


procedure TKeyboard.Invalidate();
begin
  FDevice.Invalidate();
end;


function TKeyboard.CatchedOneKey(out AScanCode: UInt8): Boolean;
var
  Index, CatchedScanCode: Integer;
  Catched: Boolean = False;
begin
  Result := False;

  for Index := KEYBOARD_SCANCODE_KEY_FIRST to KEYBOARD_SCANCODE_KEY_LAST do
    if FDevice.Key[Index].JustPressed then
      if not Catched then
      begin
        Catched := True;
        CatchedScanCode := Index;
      end
      else
        Exit;

  if Catched then
  begin
    Result := True;
    AScanCode := CatchedScanCode;
  end;
end;


end.

