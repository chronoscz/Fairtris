{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021-2022. All rights reversed.

  https://github.com/furious-programming/fairtris


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Taskbar;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

{$IFDEF WINDOWS}
uses
  ShlObj;
{$ENDIF}

type
  TTaskbar = class(TObject)
  private
    {$IFDEF WINDOWS}
    FButton: ITaskBarList3;
    {$ENDIF}
    FSupported: Boolean;
  public
    procedure Initialize();
    procedure Update();
  end;


var
  Taskbar: TTaskbar;


implementation

uses
  SDL2,
  {$IFDEF WINDOWS}ComObj,{$ENDIF}
  Math,
  SysUtils,
  Fairtris.Window,
  Fairtris.Clock;


procedure TTaskbar.Initialize();
var
  Instance: IInterface;
begin
  {$IFDEF WINDOWS}
  Instance := CreateComObject(CLSID_TASKBARLIST);
  FSupported := Supports(Instance, ITaskBarList3, FButton);
  {$ENDIF}
end;


procedure TTaskbar.Update();
var
  {$IFDEF WINDOWS}
  ButtonState: Integer = TBPF_ERROR;
  {$ENDIF}
  ButtonTotal: Integer = 100;
  ButtonValue: Integer;
begin
  if Clock.FrameRate.Changed then
    SDL_SetWindowTitle(Window.Window, PChar('Fairtris — %dfps'.Format([Clock.FrameRate.Current])));

  if FSupported and Clock.FrameLoad.Changed then
  begin
    ButtonValue := Max(1, Min(Clock.FrameLoad.Current, ButtonTotal));

    {$IFDEF WINDOWS}
    case ButtonValue of
      00 .. 60: ButtonState := TBPF_NORMAL;
      61 .. 85: ButtonState := TBPF_PAUSED;
    end;

    FButton.SetProgressState(Window.Handle, ButtonState);
    FButton.SetProgressValue(Window.Handle, ButtonValue, ButtonTotal);
    {$ENDIF}
  end;
end;


end.

