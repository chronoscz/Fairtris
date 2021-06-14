unit Fairtris.Game;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TGame = class(TObject)
  private
    procedure Initialize();
    procedure Finalize();
  private
    procedure OpenFrame();
    procedure CloseFrame();
  private
    procedure UpdateInput();
    procedure UpdateLogic();
    procedure UpdateSounds();
    procedure UpdateBuffer();
    procedure UpdateWindow();
    procedure UpdateTaskBar();
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Run();
    procedure Start();
    procedure Stop();
  end;


var
  Game: TGame;


implementation

uses
  Windows,
  Forms,
  SysUtils,
  Fairtris.Window,
  Fairtris.Taskbar,
  Fairtris.Clock,
  Fairtris.Buffers,
  Fairtris.Input,
  Fairtris.Memory,
  Fairtris.Placement,
  Fairtris.Renderers,
  Fairtris.Grounds,
  Fairtris.Sprites,
  Fairtris.Sounds,
  Fairtris.Settings,
  Fairtris.BestScores,
  Fairtris.Logic,
  Fairtris.Converter,
  Fairtris.Constants;


constructor TGame.Create();
begin
  Taskbar := TTaskbar.Create();

  Clock := TClock.Create();
  Buffers := TBuffers.Create();
  Input := TInput.Create();
  Placement := TPlacement.Create();
  Renderers := TRenderers.Create();

  Grounds := TGrounds.Create();
  Sprites := TSprites.Create();
  Sounds := TSounds.Create();
  Settings := TSettings.Create();
  BestScores := TBestScores.Create();

  Logic := TLogic.Create();
  Memory := TMemory.Create();
  Converter := TConverter.Create();
end;


destructor TGame.Destroy();
begin
  Taskbar.Free();

  Clock.Free();
  Buffers.Free();
  Input.Free();
  Placement.Free();
  Renderers.Free();

  Grounds.Free();
  Sprites.Free();
  Sounds.Free();
  Settings.Free();
  BestScores.Free();

  Logic.Free();
  Memory.Free();
  Converter.Free();

  inherited Destroy();
end;


procedure TGame.Run();
begin
  RequireDerivedFormResource := True;

  Application.Initialize();
  Application.CreateForm(TGameForm, GameForm);
  Application.Run();
end;


procedure TGame.Initialize();
begin
  Grounds.Load();
  Sprites.Load();
  Settings.Load();
  BestScores.Load();

  Clock.Initialize();
  Input.Initialize();
  Memory.Initialize();
  Placement.Initialize();
  Renderers.Initialize();
  Sounds.Initilize();

  Taskbar.Initialize();
end;


procedure TGame.Finalize();
begin
  Settings.Save();
  BestScores.Save();

  GameForm.Close();
end;


procedure TGame.OpenFrame();
begin
  Clock.UpdateFrameBegin();
end;


procedure TGame.CloseFrame();
begin
  Clock.UpdateFrameEnd();
  Clock.UpdateFrameAlign();
end;


procedure TGame.UpdateInput();
begin
  Input.Controller.Update();

  if (GetForegroundWindow() = GameForm.Handle) and (GetActiveWindow() = GameForm.Handle) then
    Input.Keyboard.Update()
  else
    Input.Keyboard.Reset();
end;


procedure TGame.UpdateLogic();
begin
  Logic.Update();

  if Logic.Scene.Current = SCENE_STOP then
    Stop();
end;


procedure TGame.UpdateSounds();
begin
  Sounds.Update();
end;


procedure TGame.UpdateBuffer();
begin
  if not Logic.Stopped then
    Renderers.Theme.RenderScene(Logic.Scene.Current);
end;


procedure TGame.UpdateWindow();
begin
  if not Logic.Stopped then
  begin
    GameForm.Invalidate();
    Application.ProcessMessages();
  end;
end;


procedure TGame.UpdateTaskBar();
begin
  if not Logic.Stopped then
    Taskbar.Update();
end;


procedure TGame.Start();
begin
  Initialize();

  repeat
    OpenFrame();
      UpdateInput();
      UpdateLogic();
      UpdateSounds();

      if not Logic.Scene.Changed then
      begin
        UpdateBuffer();
        UpdateWindow();
        UpdateTaskBar();
      end;
    CloseFrame();
  until Logic.Stopped;

  Finalize();
end;


procedure TGame.Stop();
begin
  Logic.Stop();
end;


end.

