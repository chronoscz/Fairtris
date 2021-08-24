unit Fairtris.Controller;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Interfaces,
  Fairtris.Classes,
  Fairtris.Constants;


type
  TDevice = class(TObject)
  private type
    TButtons = array [0 .. CONTROLLER_BUTTONS_COUNT + CONTROLLER_ARROWS_COUNT] of TSwitch;
  private
    FJoystick: PSDL_Joystick;
  private
    FButtons: TButtons;
    FConnected: Boolean;
  private
    procedure UpdateButtons();
  private
    function GetButton(AButtonID: Integer): TSwitch;
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
    procedure Attach();
    procedure Detach();
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
    function GetSwitch(AButtonID: Integer): TSwitch;
    function GetScanCode(AButtonID: Integer): UInt8;
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
    procedure Attach();
    procedure Detach();
  public
    function CatchedOneButton(out AScanCode: UInt8): Boolean;
  public
    property Device: TDevice read FDevice;
    property Connected: Boolean read GetConnected;
  public
    property Switch[AButtonID: Integer]: TSwitch read GetSwitch;
    property ScanCode[AButtonID: Integer]: UInt8 read GetScanCode;
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
  Fairtris.Memory,
  Fairtris.Settings;


constructor TDevice.Create();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index] := TSwitch.Create(False);
end;


destructor TDevice.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Free();

  inherited Destroy();
end;


procedure TDevice.UpdateButtons();
const
  JOYSTICK_AXIS_X = 0;
  JOYSTICK_AXIS_Y = 1;
const
  JOYSTICK_AXIS_DEADZONE = 9999;
var
  AxisX, AxisY, Index: Integer;
begin
  for Index := Low(FButtons) to CONTROLLER_BUTTONS_COUNT - 1 do
    FButtons[Index].Pressed := SDL_JoystickGetButton(FJoystick, Index) = 1;

  AxisX := SDL_JoystickGetAxis(FJoystick, JOYSTICK_AXIS_X);
  AxisY := SDL_JoystickGetAxis(FJoystick, JOYSTICK_AXIS_Y);

  FButtons[CONTROLLER_ARROWS_OFFSET + CONTROLLER_BUTTON_UP].Pressed    := AxisY < -JOYSTICK_AXIS_DEADZONE;
  FButtons[CONTROLLER_ARROWS_OFFSET + CONTROLLER_BUTTON_DOWN].Pressed  := AxisY > +JOYSTICK_AXIS_DEADZONE;
  FButtons[CONTROLLER_ARROWS_OFFSET + CONTROLLER_BUTTON_LEFT].Pressed  := AxisX < -JOYSTICK_AXIS_DEADZONE;
  FButtons[CONTROLLER_ARROWS_OFFSET + CONTROLLER_BUTTON_RIGHT].Pressed := AxisX > +JOYSTICK_AXIS_DEADZONE;
end;


function TDevice.GetButton(AButtonID: Integer): TSwitch;
begin
  Result := FButtons[AButtonID];
end;


procedure TDevice.Reset();
var
  Index: Integer;
begin
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


procedure TDevice.Attach();
begin
  if not FConnected then
  begin
    FJoystick := SDL_JoystickOpen(0);
    FConnected := True;
  end;
end;


procedure TDevice.Detach();
begin
  if FConnected then
  begin
    SDL_JoystickClose(FJoystick);
    FConnected := False;
  end;
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

  FScanCodesDefault[CONTROLLER_BUTTON_SELECT] := CONTROLLER_SCANCODE_BUTTON_8;
  FScanCodesDefault[CONTROLLER_BUTTON_START]  := CONTROLLER_SCANCODE_BUTTON_9;
  FScanCodesDefault[CONTROLLER_BUTTON_B]      := CONTROLLER_SCANCODE_BUTTON_0;
  FScanCodesDefault[CONTROLLER_BUTTON_A]      := CONTROLLER_SCANCODE_BUTTON_1;
end;


procedure TController.InitScanCodesUsed();
begin
  Restore();
end;


procedure TController.DoneDevice();
begin
  FDevice.Free();
end;


function TController.GetSwitch(AButtonID: Integer): TSwitch;
begin
  Result := FDevice.Button[FScanCodesUsed[AButtonID]];
end;


function TController.GetScanCode(AButtonID: Integer): UInt8;
begin
  Result := FScanCodesUsed[AButtonID];
end;


function TController.GetConnected(): Boolean;
begin
  Result := FDevice.Connected;
end;


procedure TController.Initialize();
begin
  FScanCodesUsed := Settings.Controller.ScanCodes;
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


procedure TController.Attach();
begin
  FDevice.Attach();
end;


procedure TController.Detach();
begin
  FDevice.Detach();
end;


function TController.CatchedOneButton(out AScanCode: UInt8): Boolean;
var
  Index, CatchedScanCode: Integer;
  Catched: Boolean = False;
begin
  Result := False;

  for Index := CONTROLLER_SCANCODE_BUTTON_FIRST to CONTROLLER_SCANCODE_BUTTON_LAST do
    if FDevice.Button[Index].JustPressed then
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

