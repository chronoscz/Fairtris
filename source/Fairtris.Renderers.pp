unit Fairtris.Renderers;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Graphics,
  Fairtris.Interfaces,
  Fairtris.Constants;


type
  TRenderer = class(TInterfacedObject)
  private type
    PPixels = ^TPixels;
    TPixels = array [UInt16] of record B, G, R: UInt8 end;
  private
    function CharToIndex(AChar: Char): Integer;
  protected
    procedure RenderCharacter(AX, AY: Integer; AChar: Char; AColor: TColor);
    procedure RenderText(AX, AY: Integer; const AText: String; AColor: TColor = COLOR_WHITE; AAlign: Integer = ALIGN_LEFT);
  protected
    procedure RenderGround(ASceneID: Integer);
  end;


type
  TModernRenderer = class(TRenderer, IRenderable)
  private
    procedure RenderMenuSelection();
  private
    procedure RenderPlaySelection();
    procedure RenderPlayItems();
    procedure RenderPlayParameters();
    procedure RenderPlayBestScores();
  private
    procedure RenderPauseSelection();
    procedure RenderPauseItems();
  private
    procedure RenderTopOutSelection();
    procedure RenderTopOutItems();
    procedure RenderTopOutResult();
  private
    procedure RenderOptionsSelection();
    procedure RenderOptionsItems();
    procedure RenderOptionsParameters();
  private
    procedure RenderKeyboardItemSelection();
    procedure RenderKeyboardKeySelection();
    procedure RenderKeyboardKeyScanCodes();
  private
    procedure RenderControllerItemSelection();
    procedure RenderControllerButtonSelection();
    procedure RenderControllerButtonScanCodes();
  private
    procedure RenderLegal();
    procedure RenderMenu();
    procedure RenderPlay();
    procedure RenderGame();
    procedure RenderPause();
    procedure RenderTopOut();
    procedure RenderOptions();
    procedure RenderKeyboard();
    procedure RenderController();
  public
    procedure RenderScene(ASceneID: Integer);
  end;


type
  TClassicRenderer = class(TRenderer, IRenderable)
  private
    procedure RenderLegal();
    procedure RenderMenu();
    procedure RenderPlay();
    procedure RenderGame();
    procedure RenderPause();
    procedure RenderTopOut();
    procedure RenderOptions();
    procedure RenderKeyboard();
    procedure RenderController();
  public
    procedure RenderScene(ASceneID: Integer);
  end;


type
  TRenderers = class(TObject)
  private
    FTheme: IRenderable;
    FThemeID: Integer;
  private
    FModern: IRenderable;
    FClassic: IRenderable;
  private
    procedure SetThemeID(AThemeID: Integer);
  private
    function GetModern(): TModernRenderer;
    function GetClassic(): TClassicRenderer;
  public
    constructor Create();
  public
    procedure Initialize();
  public
    property Theme: IRenderable read FTheme;
    property ThemeID: Integer read FThemeID write SetThemeID;
  public
    property Modern: TModernRenderer read GetModern;
    property Classic: TClassicRenderer read GetClassic;
  end;


var
  Renderers: TRenderers;


implementation

uses
  Math,
  Types,
  SysUtils,
  StrUtils,
  Fairtris.Clock,
  Fairtris.Input,
  Fairtris.Buffers,
  Fairtris.Grounds,
  Fairtris.Sprites,
  Fairtris.Memory,
  Fairtris.Arrays;


function TRenderer.CharToIndex(AChar: Char): Integer;
begin
  case AChar of
    'A' .. 'Z': Result := Ord(AChar) - 64;
    '0' .. '9': Result := Ord(AChar) - 21;
    ',': Result := 37;
    '/': Result := 38;
    '(': Result := 39;
    ')': Result := 40;
    '"': Result := 41;
    '.': Result := 42;
    '-': Result := 43;
    '%': Result := 44;
    '>': Result := 45;
  otherwise
    Result := 0;
  end;
end;


procedure TRenderer.RenderCharacter(AX, AY: Integer; AChar: Char; AColor: TColor);
var
  CharIndex: Integer;
  CharRect: TRect;
var
  PixelsChar, PixelsBuffer: PPixels;
  CharX, CharY, BufferX, BufferY: Integer;
var
  R, G, B: UInt8;
begin
  CharIndex := CharToIndex(UpCase(AChar));
  CharRect := Bounds(CharIndex * CHAR_WIDTH, 0, CHAR_WIDTH, CHAR_HEIGHT);

  RedGreenBlue(AColor, R, G, B);

  CharY := CharRect.Top;
  BufferY := AY;

  while CharY < CharRect.Bottom do
  begin
    PixelsChar := Sprites.Charset.ScanLine[CharY];
    PixelsBuffer := Buffers.Native.ScanLine[BufferY];

    CharX := CharRect.Left;
    BufferX := AX;

    while CharX < CharRect.Right do
    begin
      if PixelsChar^[CharX].R <> 255 then
      begin
        PixelsBuffer^[BufferX].R := R;
        PixelsBuffer^[BufferX].G := G;
        PixelsBuffer^[BufferX].B := B;
      end;

      CharX += 1;
      BufferX += 1;
    end;

    CharY += 1;
    BufferY += 1;
  end;
end;


procedure TRenderer.RenderText(AX, AY: Integer; const AText: String; AColor: TColor; AAlign: Integer);
var
  Character: Char;
begin
  Buffers.Native.BeginUpdate();

  if AAlign = ALIGN_RIGHT then
    AX -= AText.Length * CHAR_WIDTH;

  for Character in AText do
  begin
    RenderCharacter(AX, AY, Character, AColor);
    AX += CHAR_WIDTH;
  end;

  Buffers.Native.EndUpdate();
end;


procedure TRenderer.RenderGround(ASceneID: Integer);
begin
  Buffers.Native.Canvas.Draw(0, 0, Grounds[THEME_MODERN][ASceneID]);
end;


procedure TModernRenderer.RenderMenuSelection();
begin
  RenderText(
    ITEM_X_MENU[Memory.Menu.ItemIndex],
    ITEM_Y_MENU[Memory.Menu.ItemIndex],
    ITEM_TEXT_MENU[Memory.Menu.ItemIndex]
  );

  RenderText(
    ITEM_X_MENU[Memory.Menu.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_MENU[Memory.Menu.ItemIndex],
    ITEM_TEXT_MARKER
  );
end;


procedure TModernRenderer.RenderPlaySelection();
begin
  RenderText(
    ITEM_X_PLAY[Memory.Play.ItemIndex],
    ITEM_Y_PLAY[Memory.Play.ItemIndex],
    ITEM_TEXT_PLAY[Memory.Play.ItemIndex]
  );

  RenderText(
    ITEM_X_PLAY[Memory.Play.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_PLAY[Memory.Play.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Play.ItemIndex = ITEM_PLAY_START,
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TModernRenderer.RenderPlayItems();
begin
  RenderText(
    ITEM_X_PLAY_START,
    ITEM_Y_PLAY_START,
    ITEM_TEXT_PLAY_START,
    IfThen(Input.Device.Connected, IfThen(Memory.Play.ItemIndex = ITEM_PLAY_START, COLOR_WHITE, COLOR_GRAY), COLOR_DARK)
  );
end;


procedure TModernRenderer.RenderPlayParameters();
begin
  RenderText(
    ITEM_X_PLAY_PARAM,
    ITEM_Y_PLAY_REGION,
    ITEM_TEXT_PLAY_REGION[Memory.Play.Region],
    IfThen(Memory.Play.ItemIndex = ITEM_PLAY_REGION, COLOR_WHITE, COLOR_GRAY)
  );

  RenderText(
    ITEM_X_PLAY_PARAM,
    ITEM_Y_PLAY_RNG,
    ITEM_TEXT_PLAY_RNG[Memory.Play.RNG],
    IfThen(Memory.Play.ItemIndex = ITEM_PLAY_RNG, COLOR_WHITE, COLOR_GRAY)
  );

  RenderText(
    ITEM_X_PLAY_PARAM,
    ITEM_Y_PLAY_LEVEL,
    Memory.Play.Level.ToString(),
    IfThen(Memory.Play.ItemIndex = ITEM_PLAY_LEVEL, COLOR_WHITE, COLOR_GRAY)
  );
end;


procedure TModernRenderer.RenderPlayBestScores();
begin
  // wyrenderować trzy najlepsze wyniki
end;


procedure TModernRenderer.RenderPauseSelection();
begin
  RenderText(
    ITEM_X_PAUSE[Memory.Pause.ItemIndex],
    ITEM_Y_PAUSE[Memory.Pause.ItemIndex],
    ITEM_TEXT_PAUSE[Memory.Pause.ItemIndex]
  );

  RenderText(
    ITEM_X_PAUSE[Memory.Pause.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_PAUSE[Memory.Pause.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Pause.ItemIndex in [ITEM_PAUSE_RESUME, ITEM_PAUSE_RESTART],
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TModernRenderer.RenderPauseItems();
begin
  RenderText(
    ITEM_X_PAUSE_RESUME,
    ITEM_Y_PAUSE_RESUME,
    ITEM_TEXT_PAUSE_RESUME,
    IfThen(Input.Device.Connected, IfThen(Memory.Pause.ItemIndex = ITEM_PAUSE_RESUME, COLOR_WHITE, COLOR_GRAY), COLOR_DARK)
  );

  RenderText(
    ITEM_X_PAUSE_RESTART,
    ITEM_Y_PAUSE_RESTART,
    ITEM_TEXT_PAUSE_RESTART,
    IfThen(Input.Device.Connected, IfThen(Memory.Pause.ItemIndex = ITEM_PAUSE_RESTART, COLOR_WHITE, COLOR_GRAY), COLOR_DARK)
  );
end;


procedure TModernRenderer.RenderTopOutSelection();
begin
  RenderText(
    ITEM_X_TOP_OUT[Memory.TopOut.ItemIndex],
    ITEM_Y_TOP_OUT[Memory.TopOut.ItemIndex],
    ITEM_TEXT_TOP_OUT[Memory.TopOut.ItemIndex]
  );

  RenderText(
    ITEM_X_TOP_OUT[Memory.TopOut.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_TOP_OUT[Memory.TopOut.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY,
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TModernRenderer.RenderTopOutItems();
begin
  RenderText(
    ITEM_X_TOP_OUT_PLAY,
    ITEM_Y_TOP_OUT_PLAY,
    ITEM_TEXT_TOP_OUT_PLAY,
    IfThen(Input.Device.Connected, IfThen(Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY, COLOR_WHITE, COLOR_GRAY), COLOR_DARK)
  );
end;


procedure TModernRenderer.RenderTopOutResult();
begin
  RenderText(
    ITEM_X_TOP_OUT_RESULT_TOTAL_SCORE,
    ITEM_Y_TOP_OUT_RESULT_TOTAL_SCORE,
    Memory.TopOut.TotalScore.ToString(),
    COLOR_WHITE,
    ALIGN_RIGHT
  );

  RenderText(
    ITEM_X_TOP_OUT_RESULT_TRANSITION,
    ITEM_Y_TOP_OUT_RESULT_TRANSITION,
    Memory.TopOut.Transition.ToString(),
    COLOR_WHITE,
    ALIGN_RIGHT
  );

  RenderText(
    ITEM_X_TOP_OUT_RESULT_LINES_CLEARED,
    ITEM_Y_TOP_OUT_RESULT_LINES_CLEARED,
    Memory.TopOut.LinesCleared.ToString(),
    COLOR_WHITE,
    ALIGN_RIGHT
  );

  RenderText(
    ITEM_X_TOP_OUT_RESULT_LINES_BURNED,
    ITEM_Y_TOP_OUT_RESULT_LINES_BURNED,
    Memory.TopOut.LinesBurned.ToString(),
    COLOR_WHITE,
    ALIGN_RIGHT
  );

  RenderText(
    ITEM_X_TOP_OUT_RESULT_TETRIS_RATE,
    ITEM_Y_TOP_OUT_RESULT_TETRIS_RATE,
    Memory.TopOut.TetrisRate.ToString() + '%',
    COLOR_WHITE,
    ALIGN_RIGHT
  );
end;


procedure TModernRenderer.RenderOptionsSelection();
begin
  RenderText(
    ITEM_X_OPTIONS[Memory.Options.ItemIndex],
    ITEM_Y_OPTIONS[Memory.Options.ItemIndex],
    ITEM_TEXT_OPTIONS[Memory.Options.ItemIndex],
    IfThen(Memory.Options.ItemIndex <> ITEM_OPTIONS_SET_UP, COLOR_WHITE, IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK))
  );

  RenderText(
    ITEM_X_OPTIONS[Memory.Options.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_OPTIONS[Memory.Options.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Options.ItemIndex in [ITEM_OPTIONS_SET_UP, ITEM_OPTIONS_BACK],
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TModernRenderer.RenderOptionsItems();
begin
  RenderText(
    ITEM_X_OPTIONS_SET_UP,
    ITEM_Y_OPTIONS_SET_UP,
    ITEM_TEXT_OPTIONS_SET_UP,
    IfThen(Input.Device.Connected, IfThen(Memory.Options.ItemIndex = ITEM_OPTIONS_SET_UP, COLOR_WHITE, COLOR_GRAY), COLOR_DARK)
  );

  RenderText(
    ITEM_X_OPTIONS_BACK,
    ITEM_Y_OPTIONS_BACK,
    ITEM_TEXT_OPTIONS_BACK,
    IfThen(Input.Device.Connected, IfThen(Memory.Options.ItemIndex = ITEM_OPTIONS_BACK, COLOR_WHITE, COLOR_GRAY), COLOR_DARK)
  );
end;


procedure TModernRenderer.RenderOptionsParameters();
begin
  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_INPUT,
    ITEM_TEXT_OPTIONS_INPUT[Memory.Options.Input],
    IfThen(Input.Device.Connected, IfThen(Memory.Options.ItemIndex = ITEM_OPTIONS_INPUT, COLOR_WHITE, COLOR_GRAY), COLOR_DARK)
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_WINDOW,
    ITEM_TEXT_OPTIONS_WINDOW[Memory.Options.Window],
    IfThen(Memory.Options.ItemIndex = ITEM_OPTIONS_WINDOW, COLOR_WHITE, COLOR_GRAY)
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_THEME,
    ITEM_TEXT_OPTIONS_THEME[Memory.Options.Theme],
    IfThen(Memory.Options.ItemIndex = ITEM_OPTIONS_THEME, COLOR_WHITE, COLOR_GRAY)
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_SOUNDS,
    ITEM_TEXT_OPTIONS_SOUNDS[Memory.Options.Sounds],
    IfThen(Memory.Options.ItemIndex = ITEM_OPTIONS_SOUNDS, COLOR_WHITE, COLOR_GRAY)
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_SCROLL,
    ITEM_TEXT_OPTIONS_SCROLL[Memory.Options.Scroll],
    IfThen(Memory.Options.ItemIndex = ITEM_OPTIONS_SCROLL, COLOR_WHITE, COLOR_GRAY)
  );
end;


procedure TModernRenderer.RenderKeyboardItemSelection();
begin
  RenderText(
    ITEM_X_KEYBOARD[Memory.Keyboard.ItemIndex],
    ITEM_Y_KEYBOARD[Memory.Keyboard.ItemIndex],
    ITEM_TEXT_KEYBOARD[Memory.Keyboard.ItemIndex]
  );

  RenderText(
    ITEM_X_KEYBOARD[Memory.Keyboard.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_KEYBOARD[Memory.Keyboard.ItemIndex],
    ITEM_TEXT_MARKER
  );
end;


procedure TModernRenderer.RenderKeyboardKeySelection();
begin
  if not Memory.Keyboard.Changing then Exit;

  RenderText(
    ITEM_X_KEYBOARD_KEY[Memory.Keyboard.KeyIndex],
    ITEM_Y_KEYBOARD_KEY[Memory.Keyboard.KeyIndex],
    ITEM_TEXT_KEYBOARD_KEY[Memory.Keyboard.KeyIndex],
    IfThen(
      Memory.Keyboard.SettingUp,
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    )
  );

  RenderText(
    ITEM_X_KEYBOARD_KEY[Memory.Keyboard.KeyIndex] - ITEM_X_MARKER,
    ITEM_Y_KEYBOARD_KEY[Memory.Keyboard.KeyIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Keyboard.SettingUp,
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    )
  );
end;


procedure TModernRenderer.RenderKeyboardKeyScanCodes();
var
  Index: Integer;
begin
  for Index := ITEM_KEYBOARD_SCANCODE_FIRST to ITEM_KEYBOARD_SCANCODE_LAST do
    RenderText(
      ITEM_X_KEYBOARD_SCANCODE,
      ITEM_Y_KEYBOARD_KEY[Index],
      ITEM_TEXT_KEYBOARD_SCANCODE[Memory.Keyboard.ScanCodes[Index]],
      IfThen(
        Memory.Keyboard.Changing,
        IfThen(
          Memory.Keyboard.KeyIndex = Index,
          IfThen(
            Memory.Keyboard.SettingUp,
            IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
            COLOR_WHITE
          ),
          COLOR_GRAY
        ),
        COLOR_GRAY
      )
    );
end;


procedure TModernRenderer.RenderControllerItemSelection();
begin
  RenderText(
    ITEM_X_CONTROLLER[Memory.Controller.ItemIndex],
    ITEM_Y_CONTROLLER[Memory.Controller.ItemIndex],
    ITEM_TEXT_CONTROLLER[Memory.Controller.ItemIndex]
  );

  RenderText(
    ITEM_X_CONTROLLER[Memory.Controller.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_CONTROLLER[Memory.Controller.ItemIndex],
    ITEM_TEXT_MARKER
  );
end;


procedure TModernRenderer.RenderControllerButtonSelection();
begin
  if not Memory.Controller.Changing then Exit;

  RenderText(
    ITEM_X_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_Y_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_TEXT_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    IfThen(Memory.Controller.SettingUp, COLOR_ORANGE, COLOR_WHITE)
  );

  RenderText(
    ITEM_X_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex] - ITEM_X_MARKER,
    ITEM_Y_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_TEXT_MARKER,
    IfThen(Memory.Controller.SettingUp, COLOR_ORANGE, COLOR_WHITE)
  );
end;


procedure TModernRenderer.RenderControllerButtonScanCodes();
var
  Index: Integer;
begin
  for Index := ITEM_KEYBOARD_SCANCODE_FIRST to ITEM_KEYBOARD_SCANCODE_LAST do
    RenderText(
      ITEM_X_CONTROLLER_SCANCODE,
      ITEM_Y_CONTROLLER_BUTTON[Index],
      ITEM_TEXT_CONTROLLER_SCANCODE[Input.Controller.ScanCode[Index]],
      IfThen(
        Memory.Controller.Changing,
        IfThen(
          Memory.Controller.ButtonIndex = Index,
          IfThen(Memory.Controller.SettingUp, COLOR_ORANGE, COLOR_WHITE),
          COLOR_GRAY
        ),
        COLOR_GRAY
      )
    );
end;


procedure TModernRenderer.RenderLegal();
begin

end;


procedure TModernRenderer.RenderMenu();
begin
  RenderMenuSelection();
end;


procedure TModernRenderer.RenderPlay();
begin
  RenderPlaySelection();
  RenderPlayItems();
  RenderPlayParameters();
  RenderPlayBestScores();
end;


procedure TModernRenderer.RenderGame();
begin

end;


procedure TModernRenderer.RenderPause();
begin
  RenderPauseSelection();
  RenderPauseItems();
end;


procedure TModernRenderer.RenderTopOut();
begin
  RenderTopOutSelection();
  RenderTopOutItems();
  RenderTopOutResult();
end;


procedure TModernRenderer.RenderOptions();
begin
  RenderOptionsSelection();
  RenderOptionsItems();
  RenderOptionsParameters();
end;


procedure TModernRenderer.RenderKeyboard();
begin
  RenderKeyboardItemSelection();
  RenderKeyboardKeySelection();
  RenderKeyboardKeyScanCodes();
end;


procedure TModernRenderer.RenderController();
begin
  RenderControllerItemSelection();
  RenderControllerButtonSelection();
  RenderControllerButtonScanCodes();
end;


procedure TModernRenderer.RenderScene(ASceneID: Integer);
begin
  RenderGround(ASceneID);

  case ASceneID of
    SCENE_LEGAL:       RenderLegal();
    SCENE_MENU:        RenderMenu();
    SCENE_PLAY:        RenderPlay();
    SCENE_GAME_NORMAL: RenderGame();
    SCENE_GAME_FLASH:  RenderGame();
    SCENE_PAUSE:       RenderPause();
    SCENE_TOP_OUT:     RenderTopOut();
    SCENE_OPTIONS:     RenderOptions();
    SCENE_KEYBOARD:    RenderKeyboard();
    SCENE_CONTROLLER:  RenderController();
  end;
end;


procedure TClassicRenderer.RenderLegal();
begin

end;


procedure TClassicRenderer.RenderMenu();
begin

end;


procedure TClassicRenderer.RenderPlay();
begin

end;


procedure TClassicRenderer.RenderGame();
begin

end;


procedure TClassicRenderer.RenderPause();
begin

end;


procedure TClassicRenderer.RenderTopOut();
begin

end;


procedure TClassicRenderer.RenderOptions();
begin

end;


procedure TClassicRenderer.RenderKeyboard();
begin

end;


procedure TClassicRenderer.RenderController();
begin

end;


procedure TClassicRenderer.RenderScene(ASceneID: Integer);
begin
  RenderGround(ASceneID);

  case ASceneID of
    SCENE_LEGAL:       RenderLegal();
    SCENE_MENU:        RenderMenu();
    SCENE_PLAY:        RenderPlay();
    SCENE_GAME_NORMAL: RenderGame();
    SCENE_GAME_FLASH:  RenderGame();
    SCENE_PAUSE:       RenderPause();
    SCENE_TOP_OUT:     RenderTopOut();
    SCENE_OPTIONS:     RenderOptions();
    SCENE_KEYBOARD:    RenderKeyboard();
    SCENE_CONTROLLER:  RenderController();
  end;
end;


constructor TRenderers.Create();
begin
  FModern := TModernRenderer.Create();
  FClassic := TClassicRenderer.Create();

  FTheme := FModern;
  FThemeID := THEME_MODERN;
end;


procedure TRenderers.SetThemeID(AThemeID: Integer);
begin
  FThemeID := AThemeID;

  case FThemeID of
    THEME_MODERN:  FTheme := FModern;
    THEME_CLASSIC: FTheme := FClassic;
  end;
end;


function TRenderers.GetModern(): TModernRenderer;
begin
  Result := FModern as TModernRenderer;
end;


function TRenderers.GetClassic(): TClassicRenderer;
begin
  Result := FClassic as TClassicRenderer;
end;


procedure TRenderers.Initialize();
begin
  // ustawić odpowiedni renderer według danych z "Settings"
end;


end.

