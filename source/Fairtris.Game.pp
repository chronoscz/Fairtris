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
    procedure UpdateQueue();
    procedure UpdateInput();
    procedure UpdateLogic();
    procedure UpdateBuffer();
    procedure UpdateWindow();
    procedure UpdateTaskBar();
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Run();
  end;


var
  Game: TGame;


implementation

uses
  SDL2,
  SDL2_Mixer,
  SysUtils,
  Fairtris.Window,
  Fairtris.Taskbar,
  Fairtris.Clock,
  Fairtris.Buffers,
  Fairtris.Input,
  Fairtris.Memory,
  Fairtris.Placement,
  Fairtris.Renderers,
  Fairtris.Sounds,
  Fairtris.Grounds,
  Fairtris.Sprites,
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
  if MIX_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, SOUND_CHANNELS_COUNT, 1024) < 0 then Halt();
end;


procedure TGame.CreateObjects();
begin
  Window := TWindow.Create();
  Taskbar := TTaskbar.Create();

  Clock := TClock.Create();
  Buffers := TBuffers.Create();
  Input := TInput.Create();
  Placement := TPlacement.Create();
  Renderers := TRenderers.Create();

  Sounds := TSounds.Create();
  Grounds := TGrounds.Create();
  Sprites := TSprites.Create();
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
  MIX_CloseAudio();
  SDL_Quit();
end;


procedure TGame.DestroyObjects();
begin
  Window.Free();
  Taskbar.Free();

  Clock.Free();
  Buffers.Free();
  Input.Free();
  Placement.Free();
  Renderers.Free();

  Sounds.Free();
  Grounds.Free();
  Sprites.Free();
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


procedure TGame.Initialize();
begin
  Sounds.Load();
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


procedure TGame.UpdateQueue();
var
  Event: TSDL_Event;
begin
  SDL_PumpEvents();

  while SDL_PollEvent(@Event) = 1 do
  case Event.Type_ of
    SDL_MOUSEWHEEL:
      if Memory.Options.Scroll = SCROLL_ENABLED then
      begin
        if Event.Wheel.Y < 0 then Placement.ReduceWindow();
        if Event.Wheel.Y > 0 then Placement.EnlargeWindow();
      end;
    SDL_JOYDEVICEADDED:   Input.Controller.Attach();
    SDL_JOYDEVICEREMOVED: Input.Controller.Detach();
    SDL_QUITEV:
      Logic.Stop();
  end;
end;


procedure TGame.UpdateInput();
begin
  if Window.Focused then
    Input.Update()
  else
    Input.Reset();
end;


procedure TGame.UpdateLogic();
begin
  Logic.Update();

  if Logic.Scene.Current = SCENE_STOP then
    Logic.Stop();
end;


procedure TGame.UpdateBuffer();
begin
  Renderers.Theme.RenderScene(Logic.Scene.Current);
end;


procedure TGame.UpdateWindow();
begin
  if Placement.VideoEnabled or (Placement.WindowSize < WINDOW_FULLSCREEN) then
    SDL_RenderCopy(Window.Renderer, Buffers.Native, nil, nil)
  else
    SDL_RenderCopy(Window.Renderer, Buffers.Native, nil, @Buffers.Client);

  SDL_RenderPresent(Window.Renderer);
end;


procedure TGame.UpdateTaskBar();
begin
  Taskbar.Update();
end;


procedure TGame.Run();
begin
  Initialize();

  repeat
    OpenFrame();
      UpdateQueue();
      UpdateInput();
      UpdateLogic();

      if not Logic.Scene.Changed and not Logic.Stopped then
      begin
        UpdateBuffer();
        UpdateWindow();
        UpdateTaskBar();
      end;
    CloseFrame();
  until Logic.Stopped;

  Finalize();
end;


end.

