{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This unit is part of the "Fairtris" video game source code. Contains
  the class of handling the button on the taskbar, displaying the name
  of the game, the framerate and the CPU load.


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

uses
  ShlObj;


{
  The class is designed to store data about the systray button, and is also responsible for updating the data and
  status of that button. The content and operation of this class is platform specific.
}
type
  TTaskbar = class(TObject)
  private
    FButton: ITaskBarList3;
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
  ComObj,
  Math,
  SysUtils,
  Fairtris.Window,
  Fairtris.Clock;


{
  It is used to check whether the current platform supports the "ITaskBarList3" interface, and thus the ability to set
  the colored progress bar on the taskbar button. If possible, it sets the "FSupported" flag on and allows the button
  data to be updated in the "Update" method.

  This method is called in the "TGame.Initialize" method.
}
procedure TTaskbar.Initialize();
var
  Instance: IInterface;
begin
  Instance := CreateComObject(CLSID_TASKBARLIST);
  FSupported := Supports(Instance, ITaskBarList3, FButton);
end;


{
  A method for updating the status of the contents of a systray button. If the framerate has changed, it updates the
  button content. If the progress bar is available on the current platform and the CPU load counter has changed
  content, it sets the appropriate progress and button color.

  This method is called in each iteration of the main game loop (see "TGame.Run" and "TGame.UpdateTaskbar" methods).
}
procedure TTaskbar.Update();
var
  ButtonState: Integer = TBPF_ERROR;
  ButtonTotal: Integer = 100;
  ButtonValue: Integer;
begin
  if Clock.FrameRate.Changed then
    SDL_SetWindowTitle(Window.Window, PChar('Fairtris — %dfps'.Format([Clock.FrameRate.Current])));

  if FSupported and Clock.FrameLoad.Changed then
  begin
    ButtonValue := Max(1, Min(Clock.FrameLoad.Current, ButtonTotal));

    case ButtonValue of
      00 .. 60: ButtonState := TBPF_NORMAL;
      61 .. 85: ButtonState := TBPF_PAUSED;
    end;

    FButton.SetProgressState(Window.Handle, ButtonState);
    FButton.SetProgressValue(Window.Handle, ButtonValue, ButtonTotal);
  end;
end;


end.

