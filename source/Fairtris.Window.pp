unit Fairtris.Window;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Forms,
  Classes,
  Controls;


type
  TGameForm = class(TForm)
    procedure FormShow(ASender: TObject);
    procedure FormPaint(ASender: TObject);
    procedure FormClose(ASender: TObject; var ACloseAction: TCloseAction);
    procedure FormMouseDown(ASender: TObject; AButton: TMouseButton; AShift: TShiftState; AX, AY: Integer);
    procedure FormMouseWheelUp(ASender: TObject; AShift: TShiftState; AMousePos: TPoint; var AHandled: Boolean);
    procedure FormMouseWheelDown(ASender: TObject; AShift: TShiftState; AMousePos: TPoint; var AHandled: Boolean);
  private
    FScrollCount: Integer;
  end;


var
  GameForm: TGameForm;


implementation

{$RESOURCE Fairtris.Window.lfm}

uses
  Windows,
  Messages,
  Graphics,
  Fairtris.Game,
  Fairtris.Buffers,
  Fairtris.Placement,
  Fairtris.Arrays,
  Fairtris.Constants;


procedure TGameForm.FormShow(ASender: TObject);
begin
  ShowWindow(Handle, SW_SHOWNORMAL);
  Game.Start();
end;


procedure TGameForm.FormPaint(ASender: TObject);
begin
  case Placement.WindowSize of
    WINDOW_NATIVE:
      Canvas.Draw(0, 0, Buffers.Native);
    WINDOW_ZOOM_2X, WINDOW_ZOOM_3X, WINDOW_ZOOM_4X:
      Canvas.StretchDraw(ClientRect, Buffers.Native);
    WINDOW_FULLSCREEN:
      Canvas.StretchDraw(Buffers.Client, Buffers.Native);
  end;
end;


procedure TGameForm.FormClose(ASender: TObject; var ACloseAction: TCloseAction);
begin
  Game.Stop();
  Sleep(SOUND_LENGTH_NTSC[SOUND_TOP_OUT]);
end;


procedure TGameForm.FormMouseDown(ASender: TObject; AButton: TMouseButton; AShift: TShiftState; AX, AY: Integer);
begin
  if (AShift = [ssLeft]) and not Placement.FullScreen then
  begin
    ReleaseCapture();
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;


procedure TGameForm.FormMouseWheelUp(ASender: TObject; AShift: TShiftState; AMousePos: TPoint; var AHandled: Boolean);
begin
  if AShift = [] then
  begin
    FScrollCount += 1;

    if Odd(FScrollCount) then
      Placement.Enlarge();
  end;

  AHandled := True;
end;


procedure TGameForm.FormMouseWheelDown(ASender: TObject; AShift: TShiftState; AMousePos: TPoint; var AHandled: Boolean);
begin
  if AShift = [] then
  begin
    FScrollCount += 1;

    if Odd(FScrollCount) then
      Placement.Reduce();
  end;

  AHandled := True;
end;


end.

