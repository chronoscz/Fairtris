unit Fairtris.Game;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TGame = class(TObject)
  private
    procedure CreateSystem();
    procedure CreateObjects();
  private
    procedure DestroySystem();
    procedure DestroyObjects();
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
  SDL2,
  SDL2_Mixer,
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
  Fairtris.Generators,
  Fairtris.Logic,
  Fairtris.Core,
  Fairtris.Converter,
  Fairtris.Constants;


procedure TGame.CreateSystem();
begin
  SDL_SetHint(SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS, '0');
  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');

  if SDL_Init(SDL_INIT_EVERYTHING) < 0 then Halt();
  if Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 1024) < 0 then Halt();
end;


procedure TGame.CreateObjects();
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

  Generators := TGenerators.Create();
  Logic := TLogic.Create();
  Core := TCore.Create();
  Memory := TMemory.Create();
  Converter := TConverter.Create();
end;


procedure TGame.DestroySystem();
begin
  Mix_CloseAudio();
  SDL_Quit();
end;


procedure TGame.DestroyObjects();
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

  Generators.Free();
  Logic.Free();
  Core.Free();
  Memory.Free();
  Converter.Free();
end;


constructor TGame.Create();
begin
  CreateSystem();
  CreateObjects();
end;


destructor TGame.Destroy();
begin
  DestroyObjects();
  DestroySystem();

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

  Generators.Initialize();
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

