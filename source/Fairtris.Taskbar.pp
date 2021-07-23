unit Fairtris.Taskbar;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  ShlObj;


type
  TTaskbar = class(TObject)
  private
    FList: ITaskBarList3;
    FSupported: Boolean;
  public
    procedure Initialize();
    procedure Update();
  end;


var
  Taskbar: TTaskbar;


implementation

uses
  ComObj,
  Math,
  Forms,
  SysUtils,
  Fairtris.Clock;


procedure TTaskbar.Initialize();
var
  Instance: IInterface;
begin
  Instance := CreateComObject(CLSID_TASKBARLIST);
  FSupported := Supports(Instance, ITaskBarList3, FList);

  if not FSupported then
    FList := nil;
end;


procedure TTaskbar.Update();
var
  ButtonState: Integer = TBPF_ERROR;
  ButtonTotal: Integer = 100;
  ButtonValue: Integer;
begin
  if not FSupported then Exit;

  if Clock.FrameRate.Changed then
    Application.Title := 'Fairtris — %dfps'.Format([Clock.FrameRate.Current]);

  if Clock.FrameLoad.Changed then
  begin
    ButtonValue := Min(Clock.FrameLoad.Current, ButtonTotal);

    case ButtonValue of
      00 .. 60: ButtonState := TBPF_NORMAL;
      61 .. 85: ButtonState := TBPF_PAUSED;
    end;

    FList.SetProgressState(Application.Handle, ButtonState);
    FList.SetProgressValue(Application.Handle, ButtonValue, ButtonTotal);
  end;
end;


end.

