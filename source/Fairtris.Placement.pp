unit Fairtris.Placement;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Types,
  Fairtris.Arrays;


type
  TPlacement = class(TObject)
  private
    FInitialized: Boolean;
  private
    FMonitor: TMonitor;
  private
    FWindowSize: Integer;
    FWindowBounds: TRect;
    FWindowClient: TRect;
  private
    FScroll: Integer;
    FFullScreen: Boolean;
  private
    procedure SetMonitorIndex(AIndex: Integer);
    procedure SetWindowSize(ASize: Integer);
    procedure SetWindowBounds(ABounds: TRect);
    procedure SetWindowClient(AClient: TRect);
  private
    procedure UpdateWindowBounds();
    procedure UpdateWindowClient();
    procedure UpdateWindowCursor();
    procedure UpdateWindowPlacement();
    procedure UpdateWindowProperties();
  private
    procedure UpdateMonitor();
    procedure UpdateWindow();
    procedure UpdateBuffer();
  public
    constructor Create();
  public
    procedure Initialize();
  public
    procedure Enlarge();
    procedure Reduce();
  public
    property Monitor: TMonitor read FMonitor;
    property MonitorIndex: Integer write SetMonitorIndex;
  public
    property WindowSize: Integer read FWindowSize write SetWindowSize;
    property WindowBounds: TRect read FWindowBounds write SetWindowBounds;
    property WindowClient: TRect read FWindowClient write SetWindowClient;
  public
    property Scroll: Integer read FScroll write FScroll;
    property FullScreen: Boolean read FFullScreen;
  end;


var
  Placement: TPlacement;


implementation

uses
  Math,
  Controls,
  Fairtris.Window,
  Fairtris.Buffers,
  Fairtris.Settings,
  Fairtris.Constants;


constructor TPlacement.Create();
begin
  FMonitor := Screen.PrimaryMonitor;
  FWindowSize := WINDOW_FULLSCREEN;

  UpdateWindowBounds();
  UpdateWindowClient();
end;


procedure TPlacement.Initialize();
begin
  FMonitor := Screen.Monitors[Settings.General.Monitor];
  FWindowSize := Settings.General.Window;
  FScroll := Settings.General.Scroll;

  if FWindowSize <> WINDOW_FULLSCREEN then
  begin
    FWindowBounds.Left := Settings.General.Left;
    FWindowBounds.Top := Settings.General.Top;
  end;

  UpdateWindow();
  UpdateBuffer();

  FInitialized := True;
end;


procedure TPlacement.SetMonitorIndex(AIndex: Integer);
begin
  FMonitor := Screen.Monitors[EnsureRange(AIndex, 0, Screen.MonitorCount - 1)];
  UpdateWindow();
end;


procedure TPlacement.SetWindowSize(ASize: Integer);
begin
  if FWindowSize <> ASize then
  begin
    FWindowSize := ASize;

    UpdateMonitor();
    UpdateWindow();
    UpdateBuffer();
  end;
end;


procedure TPlacement.SetWindowBounds(ABounds: TRect);
begin
  FWindowBounds := ABounds;
end;


procedure TPlacement.SetWindowClient(AClient: TRect);
begin
  FWindowClient := AClient;
end;


procedure TPlacement.UpdateWindowBounds();
var
  NewWidth, NewHeight: Integer;
begin
  case FWindowSize of
    WINDOW_NATIVE, WINDOW_ZOOM_2X, WINDOW_ZOOM_3X, WINDOW_ZOOM_4X:
    begin
      NewWidth := Ord(FWindowSize) * BUFFER_WIDTH + BUFFER_WIDTH;
      NewHeight := Ord(FWindowSize) * BUFFER_HEIGHT + BUFFER_HEIGHT;

      if FInitialized then
      begin
        FWindowBounds.Left := FMonitor.WorkareaRect.Left + (FMonitor.WorkareaRect.Width - NewWidth) div 2;
        FWindowBounds.Top := FMonitor.WorkareaRect.Top + (FMonitor.WorkareaRect.Height - NewHeight) div 2;
      end;

      FWindowBounds.Width := NewWidth;
      FWindowBounds.Height := NewHeight;
    end;
    WINDOW_FULLSCREEN:
      FWindowBounds := FMonitor.BoundsRect;
  end;
end;


procedure TPlacement.UpdateWindowClient();
var
  NewWidth, NewHeight: Integer;
begin
  case FWindowSize of
    WINDOW_NATIVE, WINDOW_ZOOM_2X, WINDOW_ZOOM_3X, WINDOW_ZOOM_4X:
      FWindowClient := Bounds(0, 0, FWindowBounds.Width, FWindowBounds.Height);
    WINDOW_FULLSCREEN:
    begin
      NewHeight := Round(FWindowBounds.Height * CLIENT_FILL_MULTIPLIER);
      NewWidth := Round(NewHeight * CLIENT_RATIO_LANDSCAPE);

      if NewWidth > FWindowBounds.Width then
      begin
        NewWidth := Round(FWindowBounds.Width * CLIENT_FILL_MULTIPLIER);
        NewHeight := Round(NewWidth * CLIENT_RATIO_PORTRAIT);
      end;

      FWindowClient.Left := (FWindowBounds.Width - NewWidth) div 2;
      FWindowClient.Top := (FWindowBounds.Height - NewHeight) div 2;

      FWindowClient.Width := NewWidth;
      FWindowClient.Height := NewHeight;
    end;
  end;
end;


procedure TPlacement.UpdateWindowCursor();
begin
  if FWindowSize = WINDOW_FULLSCREEN then
    Screen.Cursor := crNone
  else
    Screen.Cursor := crSizeAll;
end;


procedure TPlacement.UpdateWindowPlacement();
begin
  GameForm.BoundsRect := FWindowBounds;
end;


procedure TPlacement.UpdateWindowProperties();
begin
  FFullScreen := FWindowSize = WINDOW_FULLSCREEN;
end;


procedure TPlacement.UpdateMonitor();
begin
  FMonitor := Screen.MonitorFromPoint(GameForm.BoundsRect.CenterPoint);
end;


procedure TPlacement.UpdateWindow();
begin
  UpdateWindowBounds();
  UpdateWindowClient();
  UpdateWindowCursor();
  UpdateWindowPlacement();
  UpdateWindowProperties();
end;


procedure TPlacement.UpdateBuffer();
begin
  if FWindowSize = WINDOW_FULLSCREEN then
    Buffers.Client := FWindowClient;
end;


procedure TPlacement.Enlarge();
begin
  if FScroll = SCROLL_DISABLED then Exit;

  if FWindowSize < WINDOW_FULLSCREEN then
  begin
    FWindowSize += 1;

    UpdateMonitor();
    UpdateWindow();
    UpdateBuffer();
  end;
end;


procedure TPlacement.Reduce();
begin
  if FScroll = SCROLL_DISABLED then Exit;

  if FWindowSize > WINDOW_NATIVE then
  begin
    FWindowSize -= 1;

    UpdateMonitor();
    UpdateWindow();
  end;
end;


end.

