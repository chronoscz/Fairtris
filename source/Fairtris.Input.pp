{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

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
    property Devices[ADeviceID: Integer]: IControllable read GetDevices; default;
    property DeviceID: Integer read FDeviceID write SetDeviceID;
  public
    property Keyboard: TKeyboard read GetKeyboard;
    property Controller: TController read GetController;
  end;


var
  Input: TInput;


implementation

uses
  Fairtris.Settings,
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
  SetDeviceID(Settings.General.Input);

  GetKeyboard().Initialize();
  GetController().Initialize();
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

