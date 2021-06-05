unit Fairtris.Input;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Interfaces,
  Fairtris.Keyboard,
  Fairtris.Controller;


type
  TInput = class(TObject)
  private
    FDevice: IControllable;
    FDeviceID: Integer;
  private
    FKeyboard: IControllable;
    FController: IControllable;
  private
    procedure SetDeviceID(ADeviceID: Integer);
    function GetDevices(ADeviceID: Integer): IControllable;
  private
    function GetKeyboard(): TKeyboard;
    function GetController(): TController;
  public
    constructor Create();
  public
    procedure Initialize();
  public
    procedure Reset();
    procedure Update();
  public
    procedure Validate();
    procedure Invalidate();
  public
    property Device: IControllable read FDevice;
    property Devices[ADeviceID: Integer]: IControllable read GetDevices;
    property DeviceID: Integer read FDeviceID write SetDeviceID;
  public
    property Keyboard: TKeyboard read GetKeyboard;
    property Controller: TController read GetController;
  end;


var
  Input: TInput;


implementation

uses
  Fairtris.Constants;


constructor TInput.Create();
begin
  FKeyboard := TKeyboard.Create();
  FController := TController.Create();

  FDevice := FKeyboard;
  FDeviceID := INPUT_KEYBOARD;
end;


procedure TInput.Initialize();
begin
  // ustawić domyślne urządzenie według danych z "Settings"
end;


procedure TInput.SetDeviceID(ADeviceID: Integer);
begin
  FDeviceID := ADeviceID;

  case FDeviceID of
    INPUT_KEYBOARD:   FDevice := FKeyboard;
    INPUT_CONTROLLER: FDevice := FController;
  end;
end;


function TInput.GetDevices(ADeviceID: Integer): IControllable;
begin
  case ADeviceID of
    INPUT_KEYBOARD:   Result := FKeyboard;
    INPUT_CONTROLLER: Result := FController;
  end;
end;


function TInput.GetKeyboard(): TKeyboard;
begin
  Result := FKeyboard as TKeyboard;
end;


function TInput.GetController(): TController;
begin
  Result := FController as TController;
end;


procedure TInput.Reset();
begin
  GetKeyboard().Reset();
  GetController().Reset();
end;


procedure TInput.Update();
begin
  GetKeyboard().Update();
  GetController().Update();
end;


procedure TInput.Validate();
begin
  GetKeyboard().Validate();
  GetController().Validate();
end;


procedure TInput.Invalidate();
begin
  GetKeyboard().Invalidate();
  GetController().Invalidate();
end;


end.

