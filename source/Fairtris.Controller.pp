unit Fairtris.Controller;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  MMSystem,
  Classes,
  Fairtris.Interfaces,
  Fairtris.Classes,
  Fairtris.Constants;


type
  TDeviceUpdater = class(TThread)
  private
    FDeviceStatus: PJOYINFOEX;
    FDeviceConnected: PBoolean;
  private
    FLocalStatus: JOYINFOEX;
    FLocalConnected: Boolean;
  private
    procedure UpdateDevice();
  public
    constructor Create(AStatus: PJOYINFOEX; AConnected: PBoolean);
  public
    procedure Execute(); override;
  end;


type
  TDevice = class(TObject)
  private type
    TButtons = array [0 .. CONTROLLER_BUTTONS_COUNT + CONTROLLER_ARROWS_COUNT - 1] of TSwitch;
  private
    FUpdater: TDeviceUpdater;
  private
    FStatus: JOYINFOEX;
    FConnected: Boolean;
  private
    FButtons: TButtons;
  private
    procedure InitButtons();
    procedure InitUpdater();
  private
    procedure DoneUpdater();
    procedure DoneButtons();
  private
    procedure UpdateButtons();
  private
    function GetButton(AIndex: Integer): TSwitch;
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
    property Button[AIndex: Integer]: TSwitch read GetButton;
    property Connected: Boolean read FConnected;
  end;


type
  TController = class(TInterfacedObject, IControllable)
  private type
    TScanCodes = array [CONTROLLER_BUTTON_FIRST .. CONTROLLER_BUTTON_LAST] of UInt8;
  private
    FDevice: TDevice;
    FScanCodesUsed: TScanCodes;
    FScanCodesDefault: TScanCodes;
  private
    procedure InitDevice();
    procedure InitScanCodesDefault();
    procedure InitScanCodesUsed();
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
    procedure Introduce();
  public
    procedure Validate();
    procedure Invalidate();
  public
    property Device: TDevice read FDevice;
  public
    property Connected: Boolean read GetConnected;
    property ScanCode[AIndex: Integer]: UInt8 read GetScanCode;
  public
    property Up: TSwitch index CONTROLLER_BUTTON_UP read GetSwitch;
    property Down: TSwitch index CONTROLLER_BUTTON_DOWN read GetSwitch;
    property Left: TSwitch index CONTROLLER_BUTTON_LEFT read GetSwitch;
    property Right: TSwitch index CONTROLLER_BUTTON_RIGHT read GetSwitch;
    property Select: TSwitch index CONTROLLER_BUTTON_SELECT read GetSwitch;
    property Start: TSwitch index CONTROLLER_BUTTON_START read GetSwitch;
    property B: TSwitch index CONTROLLER_BUTTON_B read GetSwitch;
    property A: TSwitch index CONTROLLER_BUTTON_A read GetSwitch;
  end;


implementation

uses
  Fairtris.Memory;


constructor TDeviceUpdater.Create(AStatus: PJOYINFOEX; AConnected: PBoolean);
begin
  inherited Create(False);

  FDeviceStatus := AStatus;
  FDeviceConnected := AConnected;
end;


procedure TDeviceUpdater.UpdateDevice();
begin
  FDeviceStatus^ := FLocalStatus;
  FDeviceConnected^ := FLocalConnected;
end;


procedure TDeviceUpdater.Execute();
begin
  while not Terminated do
  begin
    FLocalStatus := Default(JOYINFOEX);
    FLocalStatus.dwSize := SizeOf(JOYINFOEX);
    FLocalStatus.dwFlags := JOY_RETURNX or JOY_RETURNY or JOY_RETURNBUTTONS;

    FLocalConnected := joyGetPosEx(JOYSTICKID1, @FLocalStatus) = JOYERR_NOERROR;

    Synchronize(@UpdateDevice);
    Sleep(10);
  end;
end;


constructor TDevice.Create();
begin
  InitButtons();
  InitUpdater();
end;


destructor TDevice.Destroy();
begin
  DoneUpdater();
  DoneButtons();

  inherited Destroy();
end;


procedure TDevice.InitButtons();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index] := TSwitch.Create(False);
end;


procedure TDevice.InitUpdater();
begin
  FUpdater := TDeviceUpdater.Create(@FStatus, @FConnected);
  FUpdater.FreeOnTerminate := True;
end;


procedure TDevice.DoneUpdater();
begin
  FUpdater.Terminate();
  FUpdater.WaitFor();
end;


procedure TDevice.DoneButtons();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Free();
end;


procedure TDevice.UpdateButtons();
var
  Index: Integer;
  Mask: Integer = JOY_BUTTON1;
begin
  for Index := Low(FButtons) to CONTROLLER_BUTTONS_COUNT - 1 do
  begin
    FButtons[Index].Pressed := FStatus.wButtons and Mask <> 0;
    Mask := Mask shl 1;
  end;

  FButtons[CONTROLLER_ARROWS_OFFSET + CONTROLLER_BUTTON_UP].Pressed    := FStatus.wYpos = $0000;
  FButtons[CONTROLLER_ARROWS_OFFSET + CONTROLLER_BUTTON_DOWN].Pressed  := FStatus.wYpos = $FFFF;
  FButtons[CONTROLLER_ARROWS_OFFSET + CONTROLLER_BUTTON_LEFT].Pressed  := FStatus.wXpos = $0000;
  FButtons[CONTROLLER_ARROWS_OFFSET + CONTROLLER_BUTTON_RIGHT].Pressed := FStatus.wXpos = $FFFF;
end;


function TDevice.GetButton(AIndex: Integer): TSwitch;
begin
  Result := FButtons[AIndex];
end;


procedure TDevice.Reset();
var
  Index: Integer;
begin
  FStatus := Default(JOYINFOEX);

  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Reset();
end;


procedure TDevice.Update();
begin
  if FConnected then
    UpdateButtons()
  else
    Reset();
end;


procedure TDevice.Validate();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Validate();
end;


procedure TDevice.Invalidate();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Invalidate();
end;


constructor TController.Create();
begin
  InitDevice();
  InitScanCodesDefault();
  InitScanCodesUsed();
end;


destructor TController.Destroy();
begin
  DoneDevice();
  inherited Destroy();
end;


procedure TController.InitDevice();
begin
  FDevice := TDevice.Create();
end;


procedure TController.InitScanCodesDefault();
begin
  FScanCodesDefault[CONTROLLER_BUTTON_UP]     := CONTROLLER_SCANCODE_ARROW_UP;
  FScanCodesDefault[CONTROLLER_BUTTON_DOWN]   := CONTROLLER_SCANCODE_ARROW_DOWN;
  FScanCodesDefault[CONTROLLER_BUTTON_LEFT]   := CONTROLLER_SCANCODE_ARROW_LEFT;
  FScanCodesDefault[CONTROLLER_BUTTON_RIGHT]  := CONTROLLER_SCANCODE_ARROW_RIGHT;

  FScanCodesDefault[CONTROLLER_BUTTON_SELECT] := CONTROLLER_SCANCODE_BUTTON_0;
  FScanCodesDefault[CONTROLLER_BUTTON_START]  := CONTROLLER_SCANCODE_BUTTON_1;
  FScanCodesDefault[CONTROLLER_BUTTON_B]      := CONTROLLER_SCANCODE_BUTTON_2;
  FScanCodesDefault[CONTROLLER_BUTTON_A]      := CONTROLLER_SCANCODE_BUTTON_3;
end;


procedure TController.InitScanCodesUsed();
begin
  Restore();
end;


procedure TController.DoneDevice();
begin
  FDevice.Free();
end;


function TController.GetSwitch(AIndex: Integer): TSwitch;
begin
  Result := FDevice.Button[FScanCodesUsed[AIndex]];
end;


function TController.GetScanCode(AIndex: Integer): UInt8;
begin
  Result := FScanCodesUsed[AIndex];
end;


function TController.GetConnected(): Boolean;
begin
  Result := FDevice.Connected;
end;


procedure TController.Initialize();
begin
  // załadować kody przycisków z "Settings" i wpisać je do FScanCodesUsed
end;


procedure TController.Reset();
begin
  FDevice.Reset();
end;


procedure TController.Update();
begin
  FDevice.Update();
end;


procedure TController.Restore();
begin
  FScanCodesUsed := FScanCodesDefault;
end;


procedure TController.Introduce();
begin
  FScanCodesUsed := Memory.Controller.ScanCodes;
end;


procedure TController.Validate();
begin
  FDevice.Validate();
end;


procedure TController.Invalidate();
begin
  FDevice.Invalidate();
end;


end.

