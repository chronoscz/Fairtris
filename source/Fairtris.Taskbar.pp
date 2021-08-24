unit Fairtris.Taskbar;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  ShlObj;


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
  Fairtris.Clock,
  Fairtris.Window;


procedure TTaskbar.Initialize();
var
  Instance: IInterface;
begin
  Instance := CreateComObject(CLSID_TASKBARLIST);
  FSupported := Supports(Instance, ITaskBarList3, FButton);
end;


procedure TTaskbar.Update();
var
  ButtonState: Integer = TBPF_ERROR;
  ButtonTotal: Integer = 100;
  ButtonValue: Integer;
begin
  if not FSupported then Exit;

  if Clock.FrameRate.Changed then
    SDL_SetWindowTitle(Window.Window, PChar('Fairtris — %dfps'.Format([Clock.FrameRate.Current])));

  if Clock.FrameLoad.Changed then
  begin
    ButtonValue := Min(Clock.FrameLoad.Current, ButtonTotal);

    case ButtonValue of
      00 .. 60: ButtonState := TBPF_NORMAL;
      61 .. 85: ButtonState := TBPF_PAUSED;
    end;

    FButton.SetProgressState(Window.Handle, ButtonState);
    FButton.SetProgressValue(Window.Handle, ButtonValue, ButtonTotal);
  end;
end;


end.

