{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This unit is part of the "Fairtris" video game source code. Contains
  the top-level abstraction class responsible for performing the game
  logic code for all game scenes. The core game logic is separated into
  a separate class, located in the "Fairtris.Core.pp" unit.


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Logic;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Classes;


type
  TScene = specialize TCustomState<Integer>;


type
  TLogic = class(TObject)
  private
    FScene: TScene;
    FStopped: Boolean;
  private
    procedure UpdateItemIndex(var AItemIndex: Integer; ACount, AStep: Integer);
  private
    function InputMenuSetPrev(): Boolean;
    function InputMenuSetNext(): Boolean;
    function InputMenuAccepted(): Boolean;
    function InputMenuRejected(): Boolean;
  private
    function InputOptionSetPrev(): Boolean;
    function InputOptionSetNext(): Boolean;
  private
    procedure HelpUnderstand();
    procedure HelpControl();
  private
    procedure PreparePlaySelection();
  private
    procedure PrepareGameScene();
  private
    procedure PreparePauseSelection();
    procedure PreparePauseScene();
  private
    procedure PrepareTopOutSelection();
    procedure PrepareTopOutResult();
    procedure PrepareTopOutBestScore();
  private
    procedure PrepareOptionsSelection();
    procedure PrepareOptionsScene();
  private
    procedure PrepareKeyboardSelection();
    procedure PrepareKeyboardScanCodes();
  private
    procedure PrepareControllerSelection();
    procedure PrepareControllerScanCodes();
  private
    procedure PreparePlay();
    procedure PreparePause();
    procedure PrepareTopOut();
    procedure PreapreOptions();
    procedure PrepareKeyboard();
    procedure PrepareController();
    procedure PrepareQuit();
  private
    procedure UpdateLegalHang();
    procedure UpdateLegalScene();
  private
    procedure UpdateMenuSelection();
    procedure UpdateMenuScene();
  private
    procedure UpdatePlaySelection();
    procedure UpdatePlayRegion();
    procedure UpdatePlayRNG();
    procedure UpdatePlayLevel();
    procedure UpdatePlayScene();
  private
    procedure UpdateGameState();
    procedure UpdateGameScene();
  private
    procedure UpdatePauseCommon();
    procedure UpdatePauseSelection();
    procedure UpdatePauseScene();
  private
    procedure UpdateTopOutSelection();
    procedure UpdateTopOutScene();
  private
    procedure UpdateOptionsSelection();
    procedure UpdateOptionsInput();
    procedure UpdateOptionsWindow();
    procedure UpdateOptionsTheme();
    procedure UpdateOptionsSounds();
    procedure UpdateOptionsScroll();
    procedure UpdateOptionsScene();
  private
    procedure UpdateKeyboardItemSelection();
    procedure UpdateKeyboardKeySelection();
    procedure UpdateKeyboardKeyScanCode();
    procedure UpdateKeyboardScene();
  private
    procedure UpdateControllerItemSelection();
    procedure UpdateControllerButtonSelection();
    procedure UpdateControllerButtonScanCode();
    procedure UpdateControllerScene();
  private
    procedure UpdateQuitHang();
    procedure UpdateQuitScene();
  private
    procedure UpdateCommon();
    procedure UpdateLegal();
    procedure UpdateMenu();
    procedure UpdatePlay();
    procedure UpdateGame();
    procedure UpdatePause();
    procedure UpdateTopOut();
    procedure UpdateOptions();
    procedure UpdateKeyboard();
    procedure UpdateController();
    procedure UpdateQuit();
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Update();
    procedure Reset();
    procedure Stop();
  public
    property Scene: TScene read FScene;
    property Stopped: Boolean read FStopped;
  end;


var
  Logic: TLogic;


implementation

uses
  SDL2,
  Windows,
  Math,
  Fairtris.Window,
  Fairtris.Clock,
  Fairtris.Buffers,
  Fairtris.Input,
  Fairtris.Memory,
  Fairtris.Placement,
  Fairtris.Renderers,
  Fairtris.Grounds,
  Fairtris.Sounds,
  Fairtris.BestScores,
  Fairtris.Generators,
  Fairtris.Core,
  Fairtris.Utils,
  Fairtris.Arrays,
  Fairtris.Constants;


constructor TLogic.Create();
begin
  FScene := TScene.Create({$IFDEF MODE_DEBUG} SCENE_MENU {$ELSE} SCENE_LEGAL {$ENDIF});
end;


destructor TLogic.Destroy();
begin
  FScene.Free();
  inherited Destroy();
end;


procedure TLogic.UpdateItemIndex(var AItemIndex: Integer; ACount, AStep: Integer);
begin
  AItemIndex := WrapAround(AItemIndex, ACount, AStep);
end;


function TLogic.InputMenuSetPrev(): Boolean;
begin
  Result := Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed;
end;


function TLogic.InputMenuSetNext(): Boolean;
begin
  Result := Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed;
end;


function TLogic.InputMenuAccepted(): Boolean;
begin
  Result := Input.Device.Start.JustPressed or Input.Device.A.JustPressed or
            Input.Keyboard.Start.JustPressed or Input.Keyboard.A.JustPressed;
end;


function TLogic.InputMenuRejected(): Boolean;
begin
  Result := Input.Device.B.JustPressed or Input.Keyboard.B.JustPressed;
end;


function TLogic.InputOptionSetPrev(): Boolean;
begin
  Result := Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed;
end;


function TLogic.InputOptionSetNext(): Boolean;
begin
  Result := Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed;
end;


procedure TLogic.HelpUnderstand();
begin
  Sounds.PlaySound(SOUND_START);

  ShellExecute(0, 'open', 'https://github.com/furious-programming/fairtris', nil, nil, SW_SHOWNORMAL);
  SDL_MinimizeWindow(Window.Window);
end;


procedure TLogic.HelpControl();
begin
  Input.Keyboard.Restore();
  Input.DeviceID := INPUT_KEYBOARD;

  Memory.Options.Input := INPUT_KEYBOARD;

  PrepareKeyboardScanCodes();
  Sounds.PlaySound(SOUND_TRANSITION, True);
end;


procedure TLogic.PreparePlaySelection();
begin
  Memory.Play.ItemIndex := ITEM_PLAY_START;
end;


procedure TLogic.PrepareGameScene();
begin
  if not (FScene.Previous in [SCENE_GAME_NORMAL, SCENE_GAME_FLASH, SCENE_PAUSE]) then
    Core.Reset();
end;


procedure TLogic.PreparePauseSelection();
begin
  Memory.Pause.ItemIndex := IfThen(Input.Device.Connected, ITEM_PAUSE_FIRST, ITEM_PAUSE_OPTIONS);
end;


procedure TLogic.PreparePauseScene();
begin
  if FScene.Previous in [SCENE_GAME_NORMAL, SCENE_GAME_FLASH] then
    Memory.Pause.FromScene := FScene.Previous;
end;


procedure TLogic.PrepareTopOutSelection();
begin
  Memory.TopOut.ItemIndex := ITEM_TOP_OUT_FIRST;
end;


procedure TLogic.PrepareTopOutResult();
begin
  Memory.TopOut.TotalScore := Memory.Game.Score;
  Memory.TopOut.Transition := Memory.Game.Transition;

  Memory.TopOut.LinesCleared := Memory.Game.LinesCleared;
  Memory.TopOut.LinesBurned := Memory.Game.LinesBurned;

  Memory.TopOut.TetrisRate := Memory.Game.TetrisRate;
end;


procedure TLogic.PrepareTopOutBestScore();
var
  Entry: TScoreEntry;
begin
  Entry := TScoreEntry.Create(Memory.Play.Region, True);

  Entry.LinesCleared := Memory.Game.LinesCleared;
  Entry.LevelBegin := Memory.Play.Level;
  Entry.LevelEnd := Memory.Game.Level;
  Entry.TetrisRate := Memory.Game.TetrisRate;
  Entry.TotalScore := Memory.Game.Score;

  BestScores[Memory.Play.Region][Memory.Play.RNG].Add(Entry);
end;


procedure TLogic.PrepareOptionsSelection();
begin
  Memory.Options.ItemIndex := ITEM_OPTIONS_FIRST;
end;


procedure TLogic.PrepareOptionsScene();
begin
  if FScene.Previous in [SCENE_MENU, SCENE_PAUSE] then
    Memory.Options.FromScene := FScene.Previous;
end;


procedure TLogic.PrepareKeyboardSelection();
begin
  Memory.Keyboard.ItemIndex := ITEM_KEYBOARD_FIRST;
  Memory.Keyboard.KeyIndex := ITEM_KEYBOARD_KEY_FIRST;
end;


procedure TLogic.PrepareKeyboardScanCodes();
var
  Index: Integer;
begin
  for Index := Low(Memory.Keyboard.ScanCodes) to High(Memory.Keyboard.ScanCodes) do
    Memory.Keyboard.ScanCodes[Index] := Input.Keyboard.ScanCode[Index];
end;


procedure TLogic.PrepareControllerSelection();
begin
  Memory.Controller.ItemIndex := ITEM_CONTROLLER_FIRST;
  Memory.Controller.ButtonIndex := ITEM_CONTROLLER_BUTTON_FIRST;
end;


procedure TLogic.PrepareControllerScanCodes();
var
  Index: Integer;
begin
  for Index := Low(Memory.Controller.ScanCodes) to High(Memory.Controller.ScanCodes) do
    Memory.Controller.ScanCodes[Index] := Input.Controller.ScanCode[Index];
end;


procedure TLogic.PreparePlay();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MENU then
    PreparePlaySelection();

  Memory.Game.Started := False;
end;


procedure TLogic.PreparePause();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous <> SCENE_OPTIONS then
  begin
    PreparePauseSelection();
    PreparePauseScene();
  end;
end;


procedure TLogic.PrepareTopOut();
begin
  if FScene.Changed then
  begin
    PrepareTopOutSelection();
    PrepareTopOutResult();
    PrepareTopOutBestScore();

    Memory.Game.Started := False;
  end;
end;


procedure TLogic.PreapreOptions();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous in [SCENE_MENU, SCENE_PAUSE] then
  begin
    PrepareOptionsSelection();
    PrepareOptionsScene();
  end;
end;


procedure TLogic.PrepareKeyboard();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_OPTIONS then
  begin
    PrepareKeyboardSelection();
    PrepareKeyboardScanCodes();
  end;
end;


procedure TLogic.PrepareController();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_OPTIONS then
  begin
    PrepareControllerSelection();
    PrepareControllerScanCodes();
  end;
end;


procedure TLogic.PrepareQuit();
var
  OldTarget: PSDL_Texture;
begin
  if not FScene.Changed then Exit;

  OldTarget := SDL_GetRenderTarget(Window.Renderer);
  SDL_SetRenderTarget(Window.Renderer, Memory.Quit.Buffer);

  SDL_RenderCopy(Window.Renderer, Buffers.Native, nil, nil);
  SDL_RenderCopy(Window.Renderer, Grounds[Memory.Options.Theme][SCENE_QUIT], nil, nil);

  SDL_SetRenderTarget(Window.Renderer, OldTarget);
end;


procedure TLogic.UpdateLegalHang();
begin
  Memory.Legal.FrameIndex += 1;
end;


procedure TLogic.UpdateLegalScene();
begin
  FScene.Validate();

  if Memory.Legal.FrameIndex = DURATION_HANG_LEGAL * Clock.FrameRateLimit then
    FScene.Current := SCENE_MENU;
end;


procedure TLogic.UpdateMenuSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Menu.ItemIndex, ITEM_MENU_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Menu.ItemIndex, ITEM_MENU_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateMenuScene();
begin
  FScene.Validate();

  if InputMenuAccepted() then
  begin
    case Memory.Menu.ItemIndex of
      ITEM_MENU_PLAY:    FScene.Current := SCENE_PLAY;
      ITEM_MENU_OPTIONS: FScene.Current := SCENE_OPTIONS;
      ITEM_MENU_QUIT:    FScene.Current := SCENE_QUIT;
    end;

    if Memory.Menu.ItemIndex <> ITEM_MENU_QUIT then
      Sounds.PlaySound(SOUND_START)
    else
      Sounds.PlaySound(SOUND_GLASS, True);

    if Memory.Menu.ItemIndex = ITEM_MENU_HELP then
      HelpUnderstand();
  end;
end;


procedure TLogic.UpdatePlaySelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Play.ItemIndex, ITEM_PLAY_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Play.ItemIndex, ITEM_PLAY_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdatePlayRegion();
begin
  if Memory.Play.ItemIndex <> ITEM_PLAY_REGION then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Play.Region, REGION_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Play.Region, REGION_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Clock.FrameRateLimit := CLOCK_FRAMERATE_LIMIT[Memory.Play.Region];

  if Memory.Play.Region in [REGION_PAL .. REGION_PAL_EXTENDED] then
    Memory.Play.Level := Min(Memory.Play.Level, LEVEL_LAST_PAL);
end;


procedure TLogic.UpdatePlayRNG();
begin
  if Memory.Play.ItemIndex <> ITEM_PLAY_RNG then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Play.RNG, RNG_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Play.RNG, RNG_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Generators.GeneratorID := Memory.Play.RNG;
end;


procedure TLogic.UpdatePlayLevel();
begin
  if Memory.Play.ItemIndex <> ITEM_PLAY_LEVEL then Exit;

  if InputOptionSetPrev() then
  begin
    Memory.Play.Autorepeat := 0;

    UpdateItemIndex(Memory.Play.Level, LEVEL_COUNT[Memory.Play.Region], ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end
  else
    if Input.Device.Left.Pressed or Input.Keyboard.Left.Pressed then
    begin
      Memory.Play.Autorepeat += 1;

      if Memory.Play.Autorepeat = AUTOSHIFT_FRAMES_CHARGE[Memory.Play.Region] then
      begin
        Memory.Play.Autorepeat := AUTOSHIFT_FRAMES_PRECHARGE[Memory.Play.Region];

        UpdateItemIndex(Memory.Play.Level, LEVEL_COUNT[Memory.Play.Region], ITEM_PREV);
        Sounds.PlaySound(SOUND_SHIFT);
      end;
    end;

  if InputOptionSetNext() then
  begin
    Memory.Play.Autorepeat := 0;

    UpdateItemIndex(Memory.Play.Level, LEVEL_COUNT[Memory.Play.Region], ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end
  else
    if Input.Device.Right.Pressed or Input.Keyboard.Right.Pressed then
    begin
      Memory.Play.Autorepeat += 1;

      if Memory.Play.Autorepeat = AUTOSHIFT_FRAMES_CHARGE[Memory.Play.Region] then
      begin
        Memory.Play.Autorepeat := AUTOSHIFT_FRAMES_PRECHARGE[Memory.Play.Region];

        UpdateItemIndex(Memory.Play.Level, LEVEL_COUNT[Memory.Play.Region], ITEM_NEXT);
        Sounds.PlaySound(SOUND_SHIFT);
      end;
    end;
end;


procedure TLogic.UpdatePlayScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
    if Memory.Play.ItemIndex = ITEM_PLAY_START then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_DROP);

      Exit;
    end;

  if InputMenuRejected() then
  begin
    FScene.Current := SCENE_MENU;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() then
  case Memory.Play.ItemIndex of
    ITEM_PLAY_START:
    begin
      FScene.Current := SCENE_GAME_NORMAL;
      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_PLAY_BACK:
    begin
      FScene.Current := SCENE_MENU;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateGameState();
begin
  if FScene.Changed then
    PrepareGameScene();

  Core.Update();
end;


procedure TLogic.UpdateGameScene();
begin
  FScene.Current := IfThen(Memory.Game.Flashing, SCENE_GAME_FLASH, SCENE_GAME_NORMAL);
  FScene.Validate();

  if Memory.Game.State = STATE_UPDATE_TOP_OUT then
  begin
    if Memory.Game.Ended then
      FScene.Current := SCENE_TOP_OUT;
  end
  else
    if not Input.Device.Connected or Input.Device.Start.JustPressed then
    begin
      FScene.Current := SCENE_PAUSE;
      Sounds.PlaySound(SOUND_PAUSE, True);
    end;
end;


procedure TLogic.UpdatePauseCommon();
begin
  Generators.Generator.Step();
end;


procedure TLogic.UpdatePauseSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Pause.ItemIndex, ITEM_PAUSE_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Pause.ItemIndex, ITEM_PAUSE_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdatePauseScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
    if Memory.Pause.ItemIndex in [ITEM_PAUSE_RESUME, ITEM_PAUSE_RESTART] then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_DROP);

      Exit;
    end;

  if Memory.Pause.ItemIndex = ITEM_PAUSE_RESUME then
    if Input.Device.Start.JustPressed or Input.Keyboard.Start.JustPressed then
      FScene.Current := Memory.Pause.FromScene;

  if InputMenuAccepted() then
  case Memory.Pause.ItemIndex of
    ITEM_PAUSE_RESUME:
      FScene.Current := Memory.Pause.FromScene;
    ITEM_PAUSE_RESTART:
    begin
      FScene.Current := SCENE_PLAY;
      FScene.Current := SCENE_GAME_NORMAL;
      Sounds.PlaySound(SOUND_START);
    end;
  end;

  if InputMenuAccepted() then
  case Memory.Pause.ItemIndex of
    ITEM_PAUSE_OPTIONS:
    begin
      FScene.Current := SCENE_OPTIONS;
      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_PAUSE_BACK:
    begin
      FScene.Current := SCENE_PLAY;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateTopOutSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.TopOut.ItemIndex, ITEM_TOP_OUT_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.TopOut.ItemIndex, ITEM_TOP_OUT_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateTopOutScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
    if Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_DROP);

      Exit;
    end;

  case Memory.TopOut.ItemIndex of
    ITEM_TOP_OUT_PLAY:
      if InputMenuAccepted() then
      begin
        Memory.Game.Reset();

        FScene.Current := SCENE_GAME_NORMAL;
        Sounds.PlaySound(SOUND_START);
      end;
    ITEM_TOP_OUT_BACK:
      if InputMenuAccepted() then
      begin
        FScene.Current := SCENE_PLAY;
        Sounds.PlaySound(SOUND_DROP);
      end;
  end;
end;


procedure TLogic.UpdateOptionsSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.ItemIndex, ITEM_OPTIONS_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Options.ItemIndex, ITEM_OPTIONS_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateOptionsInput();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_INPUT then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.Input, INPUT_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Options.Input, INPUT_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Input.DeviceID := Memory.Options.Input;
end;


procedure TLogic.UpdateOptionsWindow();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_SIZE then Exit;

  Memory.Options.Size := Placement.WindowSize;

  if InputOptionSetPrev() then
    if not Placement.VideoEnabled then
    begin
      UpdateItemIndex(Memory.Options.Size, SIZE_COUNT, ITEM_PREV);
      Sounds.PlaySound(SOUND_SHIFT);
    end
    else
      Sounds.PlaySound(SOUND_DROP);

  if InputOptionSetNext() then
    if not Placement.VideoEnabled then
    begin
      UpdateItemIndex(Memory.Options.Size, SIZE_COUNT, ITEM_NEXT);
      Sounds.PlaySound(SOUND_SHIFT);
    end
    else
      Sounds.PlaySound(SOUND_DROP);

  Placement.WindowSize := Memory.Options.Size;
end;


procedure TLogic.UpdateOptionsTheme();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_THEME then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.Theme, THEME_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Options.Theme, THEME_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Renderers.ThemeID := Memory.Options.Theme;
end;


procedure TLogic.UpdateOptionsSounds();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_SOUNDS then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.Sounds, SOUNDS_COUNT, ITEM_PREV);

    Sounds.Enabled := Memory.Options.Sounds;
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Options.Sounds, SOUNDS_COUNT, ITEM_NEXT);

    Sounds.Enabled := Memory.Options.Sounds;
    Sounds.PlaySound(SOUND_SHIFT);
  end;
end;


procedure TLogic.UpdateOptionsScroll();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_SCROLL then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.Scroll, SCROLL_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Options.Scroll, SCROLL_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;
end;


procedure TLogic.UpdateOptionsScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
  begin
    if InputMenuRejected() then
      Sounds.PlaySound(SOUND_DROP);

    if Memory.Options.ItemIndex in [ITEM_OPTIONS_SET_UP, ITEM_OPTIONS_BACK] then
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_DROP);

    Exit;
  end;

  if InputMenuRejected() then
  begin
    FScene.Current := Memory.Options.FromScene;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() then
  case Memory.Options.ItemIndex of
    ITEM_OPTIONS_SET_UP:
    case Memory.Options.Input of
      INPUT_KEYBOARD:
        if Input.Keyboard.Device.Connected then
        begin
          FScene.Current := SCENE_KEYBOARD;
          Sounds.PlaySound(SOUND_START);
        end;
      INPUT_CONTROLLER:
        if Input.Controller.Device.Connected then
        begin
          FScene.Current := SCENE_CONTROLLER;
          Sounds.PlaySound(SOUND_START);
        end;
      end;
    ITEM_OPTIONS_BACK:
    begin
      FScene.Current := Memory.Options.FromScene;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateKeyboardItemSelection();
begin
  if Memory.Keyboard.Changing or Memory.Keyboard.SettingUp then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Keyboard.ItemIndex, ITEM_KEYBOARD_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Keyboard.ItemIndex, ITEM_KEYBOARD_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  case Memory.Keyboard.ItemIndex of
    ITEM_KEYBOARD_CHANGE:
    if InputMenuAccepted() then
    begin
      Input.Validate();

      Memory.Keyboard.KeyIndex := ITEM_KEYBOARD_KEY_FIRST;
      Memory.Keyboard.Changing := True;

      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_KEYBOARD_RESTORE:
    if InputMenuAccepted() then
    begin
      Input.Keyboard.Restore();
      PrepareKeyboardScanCodes();

      Sounds.PlaySound(SOUND_TOP_OUT, True);
    end;
  end;
end;


procedure TLogic.UpdateKeyboardKeySelection();
begin
  if not Memory.Keyboard.Changing or Memory.Keyboard.SettingUp then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Keyboard.KeyIndex, ITEM_KEYBOARD_KEY_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Keyboard.KeyIndex, ITEM_KEYBOARD_KEY_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if Memory.Keyboard.KeyIndex < ITEM_KEYBOARD_KEY_LAST then
    if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_CLEAR_MAPPING].JustPressed then
      if Memory.Keyboard.ScanCodes[Memory.Keyboard.KeyIndex] <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED then
      begin
        Memory.Keyboard.ScanCodes[Memory.Keyboard.KeyIndex] := KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
        Sounds.PlaySound(SOUND_BURN);
      end
      else
        Sounds.PlaySound(SOUND_DROP);

  if Memory.Keyboard.KeyIndex in [ITEM_KEYBOARD_SCANCODE_FIRST .. ITEM_KEYBOARD_SCANCODE_LAST] then
    if InputMenuAccepted() then
    begin
      Memory.Keyboard.SettingUp := True;

      Input.Keyboard.Validate();
      Sounds.PlaySound(SOUND_START);
    end;

  if Memory.Keyboard.KeyIndex = ITEM_KEYBOARD_KEY_BACK then
    if InputMenuAccepted() then
    begin
      Memory.Keyboard.Changing := False;
      Sounds.PlaySound(SOUND_DROP);
    end;

  if not Memory.Keyboard.SettingUp then
    if InputMenuRejected() then
    begin
      Input.Device.B.Validate();
      Input.Keyboard.B.Validate();

      Memory.Keyboard.Changing := False;
      Sounds.PlaySound(SOUND_DROP);
    end;
end;


procedure TLogic.UpdateKeyboardKeyScanCode();
var
  ScanCode: UInt8 = KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
begin
  if not Memory.Keyboard.SettingUp then Exit;

  if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_CANCEL_MAPPING].JustPressed then
  begin
    Memory.Keyboard.SettingUp := False;
    Sounds.PlaySound(SOUND_DROP);

    Exit;
  end;

  if Input.Keyboard.CatchedOneKey(ScanCode) then
  begin
    Memory.Keyboard.ScanCodes[Memory.Keyboard.KeyIndex] := ScanCode;
    Memory.Keyboard.SettingUp := False;
    Memory.Keyboard.RemoveDuplicates(ScanCode, Memory.Keyboard.KeyIndex);

    Sounds.PlaySound(SOUND_START);
  end;
end;


procedure TLogic.UpdateKeyboardScene();
begin
  FScene.Validate();

  if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_HELP_CONTROL].JustPressed then
  begin
    Memory.Keyboard.Changing := False;
    Memory.Keyboard.SettingUp := False;

    FScene.Current := SCENE_OPTIONS;
    Exit;
  end;

  if not Memory.Keyboard.Changing then
  begin
    if InputMenuRejected() then
    begin
      if Memory.Keyboard.MappedCorrectly() then
        FScene.Current := SCENE_OPTIONS;

      Sounds.PlaySound(SOUND_DROP);
    end;

    if Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_SAVE then
      if InputMenuAccepted() then
        if Memory.Keyboard.MappedCorrectly() then
        begin
          Input.Keyboard.Introduce();

          FScene.Current := SCENE_OPTIONS;
          Sounds.PlaySound(SOUND_TETRIS, True);
        end
        else
          Sounds.PlaySound(SOUND_DROP);

    if Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_CANCEL then
      if InputMenuAccepted() then
      begin
        FScene.Current := SCENE_OPTIONS;
        Sounds.PlaySound(SOUND_DROP);
      end;
  end;
end;


procedure TLogic.UpdateControllerItemSelection();
begin
  if Memory.Controller.Changing or Memory.Controller.SettingUp then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Controller.ItemIndex, ITEM_CONTROLLER_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Controller.ItemIndex, ITEM_CONTROLLER_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  case Memory.Controller.ItemIndex of
    ITEM_CONTROLLER_CHANGE:
    if InputMenuAccepted() then
    begin
      Input.Validate();

      Memory.Controller.ButtonIndex := ITEM_CONTROLLER_BUTTON_FIRST;
      Memory.Controller.Changing := True;

      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_CONTROLLER_RESTORE:
    if InputMenuAccepted() then
    begin
      Input.Controller.Restore();
      PrepareControllerScanCodes();

      Sounds.PlaySound(SOUND_TOP_OUT, True);
    end;
  end;
end;


procedure TLogic.UpdateControllerButtonSelection();
begin
  if not Memory.Controller.Changing or Memory.Controller.SettingUp then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Controller.ButtonIndex, ITEM_CONTROLLER_BUTTON_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Controller.ButtonIndex, ITEM_CONTROLLER_BUTTON_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if Memory.Controller.ButtonIndex < ITEM_CONTROLLER_BUTTON_LAST then
    if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_CLEAR_MAPPING].JustPressed then
      if Memory.Controller.ScanCodes[Memory.Controller.ButtonIndex] <> CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED then
      begin
        Memory.Controller.ScanCodes[Memory.Controller.ButtonIndex] := CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED;
        Sounds.PlaySound(SOUND_BURN);
      end
      else
        Sounds.PlaySound(SOUND_DROP);

  if Memory.Controller.ButtonIndex in [ITEM_CONTROLLER_SCANCODE_FIRST .. ITEM_CONTROLLER_SCANCODE_LAST] then
    if InputMenuAccepted() then
    begin
      Memory.Controller.SettingUp := True;

      Input.Controller.Validate();
      Sounds.PlaySound(SOUND_START);
    end;

  if Memory.Controller.ButtonIndex = ITEM_CONTROLLER_BUTTON_BACK then
    if InputMenuAccepted() then
    begin
      Memory.Controller.Changing := False;
      Sounds.PlaySound(SOUND_DROP);
    end;

  if not Memory.Controller.SettingUp then
    if InputMenuRejected() then
    begin
      Input.Device.B.Validate();
      Input.Keyboard.B.Validate();

      Memory.Controller.Changing := False;
      Sounds.PlaySound(SOUND_DROP);
    end;
end;


procedure TLogic.UpdateControllerButtonScanCode();
var
  ScanCode: UInt8 = CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED;
begin
  if not Memory.Controller.SettingUp then Exit;

  if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_CANCEL_MAPPING].JustPressed then
  begin
    Memory.Controller.SettingUp := False;
    Sounds.PlaySound(SOUND_DROP);

    Exit;
  end;

  if Input.Controller.CatchedOneButton(ScanCode) then
  begin
    Memory.Controller.ScanCodes[Memory.Controller.ButtonIndex] := ScanCode;
    Memory.Controller.SettingUp := False;
    Memory.Controller.RemoveDuplicates(ScanCode, Memory.Controller.ButtonIndex);

    Sounds.PlaySound(SOUND_START);
  end;
end;


procedure TLogic.UpdateControllerScene();
begin
  FScene.Validate();

  if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_HELP_CONTROL].JustPressed then
  begin
    Memory.Keyboard.Changing := False;
    Memory.Keyboard.SettingUp := False;

    FScene.Current := SCENE_OPTIONS;
    Exit;
  end;

  if not Input.Controller.Connected then
  begin
    FScene.Current := SCENE_OPTIONS;

    Memory.Controller.Changing := False;
    Memory.Controller.SettingUp := False;

    Sounds.PlaySound(SOUND_TOP_OUT, True);
    Exit;
  end;

  if not Memory.Controller.Changing then
  begin
    if InputMenuRejected() then
    begin
      if Memory.Controller.MappedCorrectly() then
        FScene.Current := SCENE_OPTIONS;

      Sounds.PlaySound(SOUND_DROP);
    end;

    if Memory.Controller.ItemIndex = ITEM_CONTROLLER_SAVE then
      if InputMenuAccepted() then
        if Memory.Controller.MappedCorrectly() then
        begin
          Input.Controller.Introduce();

          FScene.Current := SCENE_OPTIONS;
          Sounds.PlaySound(SOUND_TETRIS, True);
        end
        else
          Sounds.PlaySound(SOUND_DROP);

    if Memory.Controller.ItemIndex = ITEM_CONTROLLER_CANCEL then
      if InputMenuAccepted() then
      begin
        FScene.Current := SCENE_OPTIONS;
        Sounds.PlaySound(SOUND_DROP);
      end;
  end;
end;


procedure TLogic.UpdateQuitHang();
begin
  Memory.Quit.FrameIndex += 1;
end;


procedure TLogic.UpdateQuitScene();
begin
  FScene.Validate();

  if Memory.Quit.FrameIndex = DURATION_HANG_QUIT * Clock.FrameRateLimit then
    FStopped := True;
end;


procedure TLogic.UpdateCommon();
begin
  if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_HELP_UNDERSTAND].JustPressed then
    HelpUnderstand();

  if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_HELP_CONTROL].JustPressed then
    HelpControl();

  if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_TOGGLE_CLIP].JustPressed then
    Renderers.ClipFrame := not Renderers.ClipFrame;

  if Input.Keyboard.Device[KEYBOARD_SCANCODE_KEY_TOGGLE_VIDEO].JustPressed then
    Placement.ToggleVideoMode();

  if not Memory.Game.Started then
    Generators.Shuffle();
end;


procedure TLogic.UpdateLegal();
begin
  UpdateLegalHang();
  UpdateLegalScene();
end;


procedure TLogic.UpdateMenu();
begin
  UpdateMenuSelection();
  UpdateMenuScene();
end;


procedure TLogic.UpdatePlay();
begin
  PreparePlay();

  UpdatePlaySelection();
  UpdatePlayRegion();
  UpdatePlayRNG();
  UpdatePlayLevel();
  UpdatePlayScene();
end;


procedure TLogic.UpdateGame();
begin
  UpdateGameState();
  UpdateGameScene();
end;


procedure TLogic.UpdatePause();
begin
  PreparePause();

  UpdatePauseCommon();
  UpdatePauseSelection();
  UpdatePauseScene();
end;


procedure TLogic.UpdateTopOut();
begin
  PrepareTopOut();

  UpdateTopOutSelection();
  UpdateTopOutScene();
end;


procedure TLogic.UpdateOptions();
begin
  PreapreOptions();

  UpdateOptionsSelection();
  UpdateOptionsInput();
  UpdateOptionsWindow();
  UpdateOptionsTheme();
  UpdateOptionsSounds();
  UpdateOptionsScroll();
  UpdateOptionsScene();
end;


procedure TLogic.UpdateKeyboard();
begin
  PrepareKeyboard();

  UpdateKeyboardItemSelection();
  UpdateKeyboardKeySelection();
  UpdateKeyboardKeyScanCode();
  UpdateKeyboardScene();
end;


procedure TLogic.UpdateController();
begin
  PrepareController();

  UpdateControllerItemSelection();
  UpdateControllerButtonSelection();
  UpdateControllerButtonScanCode();
  UpdateControllerScene();
end;


procedure TLogic.UpdateQuit();
begin
  PrepareQuit();

  UpdateQuitHang();
  UpdateQuitScene();
end;


procedure TLogic.Update();
begin
  UpdateCommon();

  case FScene.Current of
    SCENE_LEGAL:       UpdateLegal();
    SCENE_MENU:        UpdateMenu();
    SCENE_PLAY:        UpdatePlay();
    SCENE_GAME_NORMAL: UpdateGame();
    SCENE_GAME_FLASH:  UpdateGame();
    SCENE_PAUSE:       UpdatePause();
    SCENE_TOP_OUT:     UpdateTopOut();
    SCENE_OPTIONS:     UpdateOptions();
    SCENE_KEYBOARD:    UpdateKeyboard();
    SCENE_CONTROLLER:  UpdateController();
    SCENE_QUIT:        UpdateQuit();
  end;
end;


procedure TLogic.Reset();
begin
  FScene.Reset();
end;


procedure TLogic.Stop();
begin
  if FScene.Current <> SCENE_QUIT then
  begin
    FScene.Current := SCENE_QUIT;
    Sounds.PlaySound(SOUND_GLASS, True);
  end;
end;


end.

