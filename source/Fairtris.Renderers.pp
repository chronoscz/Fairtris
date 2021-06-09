unit Fairtris.Renderers;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Types,
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
  private
    procedure RenderSprite(ABuffer, ASprite: TBitmap; ABufferRect, ASpriteRect: TRect; AExcludeFuchsia: Boolean = True); inline;
    procedure RenderChar(ABuffer, ASprite: TBitmap; ABufferRect, ASpriteRect: TRect; AColor: TColor); inline;
  protected
    procedure RenderText(AX, AY: Integer; const AText: String; AColor: TColor = COLOR_WHITE; AAlign: Integer = ALIGN_LEFT);
    procedure RenderPiece(AX, AY, APiece, ALevel: Integer);
    procedure RenderBrick(AX, AY, ABrick, ALevel: Integer);
    procedure RenderMiniature(AX, AY, APiece, ALevel: Integer);
  protected
    procedure RenderGround(ASceneID: Integer);
  protected
    procedure RenderMenuSelection();
  protected
    procedure RenderPlaySelection();
    procedure RenderPlayItems();
    procedure RenderPlayParameters();
    procedure RenderPlayBestScores();
  protected
    procedure RenderPauseSelection();
    procedure RenderPauseItems();
  protected
    procedure RenderTopOutSelection();
    procedure RenderTopOutItems();
    procedure RenderTopOutResult();
  protected
    procedure RenderOptionsSelection();
    procedure RenderOptionsItems();
    procedure RenderOptionsParameters();
  protected
    procedure RenderKeyboardItemSelection();
    procedure RenderKeyboardItems();
    procedure RenderKeyboardKeySelection();
    procedure RenderKeyboardKeyScanCodes();
  protected
    procedure RenderControllerItemSelection();
    procedure RenderControllerItems();
    procedure RenderControllerButtonSelection();
    procedure RenderControllerButtonScanCodes();
  end;


type
  TModernRenderer = class(TRenderer, IRenderable)
  private
    procedure RenderButton(AX, AY, AButton: Integer);
  private
    procedure RenderGameInput(ADevice: IControllable);
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
    procedure RenderQuit();
  public
    procedure RenderScene(ASceneID: Integer);
  end;


type
  TClassicRenderer = class(TRenderer, IRenderable)
  private
    procedure RenderGameStats();
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
    procedure RenderQuit();
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
  SysUtils,
  StrUtils,
  Fairtris.Clock,
  Fairtris.Input,
  Fairtris.Buffers,
  Fairtris.Memory,
  Fairtris.Grounds,
  Fairtris.Sprites,
  Fairtris.Settings,
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


procedure TRenderer.RenderSprite(ABuffer, ASprite: TBitmap; ABufferRect, ASpriteRect: TRect; AExcludeFuchsia: Boolean);
var
  SpriteX, SpriteY, BufferX, BufferY: Integer;
  SpritePixels, BufferPixels: PPixels;
begin
  SpriteY := ASpriteRect.Top;
  BufferY := ABufferRect.Top;

  while SpriteY < ASpriteRect.Bottom do
  begin
    SpritePixels := ASprite.ScanLine[SpriteY];
    BufferPixels := ABuffer.ScanLine[BufferY];

    SpriteX := ASpriteRect.Left;
    BufferX := ABufferRect.Left;

    while SpriteX < ASpriteRect.Right do
    begin
      if (not AExcludeFuchsia) or (AExcludeFuchsia and (SpritePixels^[SpriteX].R <> 255)) then
      begin
        BufferPixels^[BufferX].R := SpritePixels^[SpriteX].R;
        BufferPixels^[BufferX].G := SpritePixels^[SpriteX].G;
        BufferPixels^[BufferX].B := SpritePixels^[SpriteX].B;
      end;

      SpriteX += 1;
      BufferX += 1;
    end;

    SpriteY += 1;
    BufferY += 1;
  end;
end;


procedure TRenderer.RenderChar(ABuffer, ASprite: TBitmap; ABufferRect, ASpriteRect: TRect; AColor: TColor);
var
  SpritePixels, BufferPixels: PPixels;
  SpriteX, SpriteY, BufferX, BufferY: Integer;
var
  R, G, B: UInt8;
begin
  RedGreenBlue(AColor, R, G, B);

  SpriteY := ASpriteRect.Top;
  BufferY := ABufferRect.Top;

  while SpriteY < ASpriteRect.Bottom do
  begin
    SpritePixels := ASprite.ScanLine[SpriteY];
    BufferPixels := ABuffer.ScanLine[BufferY];

    SpriteX := ASpriteRect.Left;
    BufferX := ABufferRect.Left;

    while SpriteX < ASpriteRect.Right do
    begin
      if SpritePixels^[SpriteX].R <> 255 then
      begin
        BufferPixels^[BufferX].R := R;
        BufferPixels^[BufferX].G := G;
        BufferPixels^[BufferX].B := B;
      end;

      SpriteX += 1;
      BufferX += 1;
    end;

    SpriteY += 1;
    BufferY += 1;
  end;
end;


procedure TRenderer.RenderText(AX, AY: Integer; const AText: String; AColor: TColor; AAlign: Integer);
var
  Character: Char;
  CharIndex: Integer;
var
  BufferRect, CharRect: TRect;
begin
  Buffers.Native.BeginUpdate();
  BufferRect := Bounds(AX, AY, CHAR_WIDTH, CHAR_HEIGHT);

  if AAlign = ALIGN_RIGHT then
    BufferRect.Offset(-(AText.Length * CHAR_WIDTH), 0);

  for Character in AText do
  begin
    CharIndex := CharToIndex(UpCase(Character));
    CharRect := Bounds(CharIndex * CHAR_WIDTH, 0, CHAR_WIDTH, CHAR_HEIGHT);

    RenderChar(Buffers.Native, Sprites.Charset, BufferRect, CharRect, AColor);
    BufferRect.Offset(CHAR_WIDTH, 0);
  end;

  Buffers.Native.EndUpdate();
end;


procedure TRenderer.RenderPiece(AX, AY, APiece, ALevel: Integer);
begin
  if APiece <> PIECE_UNKNOWN then
  begin
    Buffers.Native.BeginUpdate();

    RenderSprite(
      Buffers.Native,
      Sprites.Pieces,
      Bounds(
        AX,
        AY,
        PIECE_WIDTH,
        PIECE_HEIGHT
      ),
      Bounds(
        APiece * PIECE_WIDTH,
        ALevel * PIECE_HEIGHT,
        PIECE_WIDTH,
        PIECE_HEIGHT
      )
    );

    Buffers.Native.EndUpdate();
  end;
end;


procedure TRenderer.RenderBrick(AX, AY, ABrick, ALevel: Integer);
begin
  if ABrick = BRICK_EMPTY then Exit;
    RenderSprite(
      Buffers.Native,
      Sprites.Bricks,
      Bounds(
        AX,
        AY,
        BRICK_WIDTH,
        BRICK_HEIGHT
      ),
      Bounds(
        ABrick * BRICK_WIDTH,
        ALevel * BRICK_HEIGHT,
        BRICK_WIDTH,
        BRICK_HEIGHT
      ),
      False
    );
end;


procedure TRenderer.RenderMiniature(AX, AY, APiece, ALevel: Integer);
begin
  if APiece <> MINIATURE_UNKNOWN then
  begin
    Buffers.Native.BeginUpdate();

    RenderSprite(
      Buffers.Native,
      Sprites.Miniatures,
      Bounds(
        AX,
        AY,
        MINIATURE_WIDTH,
        MINIATURE_HEIGHT
      ),
      Bounds(
        APiece * MINIATURE_WIDTH,
        ALevel * MINIATURE_HEIGHT,
        MINIATURE_WIDTH,
        MINIATURE_HEIGHT
      )
    );

    Buffers.Native.EndUpdate();
  end;
end;


procedure TRenderer.RenderGround(ASceneID: Integer);
begin
  if ASceneID = SCENE_QUIT then
    Buffers.Native.Canvas.Draw(0, 0, Memory.Quit.Buffer)
  else
    Buffers.Native.Canvas.Draw(0, 0, Grounds[Memory.Options.Theme][ASceneID]);
end;


procedure TRenderer.RenderMenuSelection();
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


procedure TRenderer.RenderPlaySelection();
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


procedure TRenderer.RenderPlayItems();
begin
  RenderText(
    ITEM_X_PLAY_START,
    ITEM_Y_PLAY_START,
    ITEM_TEXT_PLAY_START,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Play.ItemIndex = ITEM_PLAY_START,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderPlayParameters();
begin
  RenderText(
    ITEM_X_PLAY_PARAM,
    ITEM_Y_PLAY_REGION,
    ITEM_TEXT_PLAY_REGION[Memory.Play.Region],
    IfThen(
      Memory.Play.ItemIndex = ITEM_PLAY_REGION,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_PLAY_PARAM,
    ITEM_Y_PLAY_RNG,
    ITEM_TEXT_PLAY_RNG[Memory.Play.RNG],
    IfThen(
      Memory.Play.ItemIndex = ITEM_PLAY_RNG,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_PLAY_PARAM,
    ITEM_Y_PLAY_LEVEL,
    Memory.Play.Level.ToString(),
    IfThen(
      Memory.Play.ItemIndex = ITEM_PLAY_LEVEL,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );
end;


procedure TRenderer.RenderPlayBestScores();
begin
  // wyrenderować trzy najlepsze wyniki
end;


procedure TRenderer.RenderPauseSelection();
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


procedure TRenderer.RenderPauseItems();
begin
  RenderText(
    ITEM_X_PAUSE_RESUME,
    ITEM_Y_PAUSE_RESUME,
    ITEM_TEXT_PAUSE_RESUME,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Pause.ItemIndex = ITEM_PAUSE_RESUME,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );

  RenderText(
    ITEM_X_PAUSE_RESTART,
    ITEM_Y_PAUSE_RESTART,
    ITEM_TEXT_PAUSE_RESTART,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Pause.ItemIndex = ITEM_PAUSE_RESTART,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderTopOutSelection();
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


procedure TRenderer.RenderTopOutItems();
begin
  RenderText(
    ITEM_X_TOP_OUT_PLAY,
    ITEM_Y_TOP_OUT_PLAY,
    ITEM_TEXT_TOP_OUT_PLAY,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderTopOutResult();
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


procedure TRenderer.RenderOptionsSelection();
begin
  RenderText(
    ITEM_X_OPTIONS[Memory.Options.ItemIndex],
    ITEM_Y_OPTIONS[Memory.Options.ItemIndex],
    ITEM_TEXT_OPTIONS[Memory.Options.ItemIndex],
    IfThen(
      Memory.Options.ItemIndex <> ITEM_OPTIONS_SET_UP,
      COLOR_WHITE,
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK)
    )
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


procedure TRenderer.RenderOptionsItems();
begin
  RenderText(
    ITEM_X_OPTIONS_SET_UP,
    ITEM_Y_OPTIONS_SET_UP,
    ITEM_TEXT_OPTIONS_SET_UP,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Options.ItemIndex = ITEM_OPTIONS_SET_UP,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );

  RenderText(
    ITEM_X_OPTIONS_BACK,
    ITEM_Y_OPTIONS_BACK,
    ITEM_TEXT_OPTIONS_BACK,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Options.ItemIndex = ITEM_OPTIONS_BACK,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderOptionsParameters();
begin
  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_INPUT,
    ITEM_TEXT_OPTIONS_INPUT[Memory.Options.Input],
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Options.ItemIndex = ITEM_OPTIONS_INPUT,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_WINDOW,
    ITEM_TEXT_OPTIONS_WINDOW[Memory.Options.Window],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_WINDOW,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_THEME,
    ITEM_TEXT_OPTIONS_THEME[Memory.Options.Theme],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_THEME,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_SOUNDS,
    ITEM_TEXT_OPTIONS_SOUNDS[Memory.Options.Sounds],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_SOUNDS,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_SCROLL,
    ITEM_TEXT_OPTIONS_SCROLL[Memory.Options.Scroll],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_SCROLL,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );
end;


procedure TRenderer.RenderKeyboardItemSelection();
begin
  RenderText(
    ITEM_X_KEYBOARD[Memory.Keyboard.ItemIndex],
    ITEM_Y_KEYBOARD[Memory.Keyboard.ItemIndex],
    ITEM_TEXT_KEYBOARD[Memory.Keyboard.ItemIndex]
  );

  RenderText(
    ITEM_X_KEYBOARD[Memory.Keyboard.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_KEYBOARD[Memory.Keyboard.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_SAVE,
      IfThen(Memory.Keyboard.MappedCorrectly(), COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderKeyboardItems();
begin
  RenderText(
    ITEM_X_KEYBOARD_SAVE,
    ITEM_Y_KEYBOARD_SAVE,
    ITEM_TEXT_KEYBOARD_SAVE,
    IfThen(
      Memory.Keyboard.MappedCorrectly(),
      IfThen(
        Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_SAVE,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderKeyboardKeySelection();
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


procedure TRenderer.RenderKeyboardKeyScanCodes();
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
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    );
end;


procedure TRenderer.RenderControllerItemSelection();
begin
  RenderText(
    ITEM_X_CONTROLLER[Memory.Controller.ItemIndex],
    ITEM_Y_CONTROLLER[Memory.Controller.ItemIndex],
    ITEM_TEXT_CONTROLLER[Memory.Controller.ItemIndex]
  );

  RenderText(
    ITEM_X_CONTROLLER[Memory.Controller.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_CONTROLLER[Memory.Controller.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Controller.ItemIndex = ITEM_CONTROLLER_SAVE,
      IfThen(Memory.Controller.MappedCorrectly(), COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderControllerItems();
begin
  RenderText(
    ITEM_X_CONTROLLER_SAVE,
    ITEM_Y_CONTROLLER_SAVE,
    ITEM_TEXT_CONTROLLER_SAVE,
    IfThen(
      Memory.Controller.MappedCorrectly(),
      IfThen(
        Memory.Controller.ItemIndex = ITEM_CONTROLLER_SAVE,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderControllerButtonSelection();
begin
  if not Memory.Controller.Changing then Exit;

  RenderText(
    ITEM_X_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_Y_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_TEXT_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    IfThen(
      Memory.Controller.SettingUp,
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    )
  );

  RenderText(
    ITEM_X_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex] - ITEM_X_MARKER,
    ITEM_Y_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Controller.SettingUp,
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderControllerButtonScanCodes();
var
  Index: Integer;
begin
  for Index := ITEM_KEYBOARD_SCANCODE_FIRST to ITEM_KEYBOARD_SCANCODE_LAST do
    RenderText(
      ITEM_X_CONTROLLER_SCANCODE,
      ITEM_Y_CONTROLLER_BUTTON[Index],
      ITEM_TEXT_CONTROLLER_SCANCODE[Memory.Controller.ScanCodes[Index]],
      IfThen(
        Memory.Controller.Changing,
        IfThen(
          Memory.Controller.ButtonIndex = Index,
          IfThen(
            Memory.Controller.SettingUp,
            IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
            COLOR_WHITE
          ),
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    );
end;


procedure TModernRenderer.RenderButton(AX, AY, AButton: Integer);
begin
  Buffers.Native.BeginUpdate();

  RenderSprite(
    Buffers.Native,
    Sprites.Controller,
    Bounds(
      AX,
      AY,
      THUMBNAIL_BUTTON_WIDTH[AButton],
      THUMBNAIL_BUTTON_HEIGHT[AButton]
    ),
    Bounds(
      THUMBNAIL_BUTTON_X[AButton],
      THUMBNAIL_BUTTON_Y[AButton],
      THUMBNAIL_BUTTON_WIDTH[AButton],
      THUMBNAIL_BUTTON_HEIGHT[AButton]
    ),
    False
  );

  Buffers.Native.EndUpdate();
end;


procedure TModernRenderer.RenderGameInput(ADevice: IControllable);
var
  Index: Integer;
begin
  for Index := DEVICE_FIRST to DEVICE_LAST do
    if ADevice.Switch[Index].Pressed then
      RenderButton(
        CONTROLLER_X + THUMBNAIL_BUTTON_X[Index],
        CONTROLLER_Y + THUMBNAIL_BUTTON_Y[Index],
        Index
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
  RenderGameInput(Input.Device);
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
  RenderKeyboardItems();
  RenderKeyboardKeySelection();
  RenderKeyboardKeyScanCodes();
end;


procedure TModernRenderer.RenderController();
begin
  RenderControllerItemSelection();
  RenderControllerItems();
  RenderControllerButtonSelection();
  RenderControllerButtonScanCodes();
end;


procedure TModernRenderer.RenderQuit();
begin

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
    SCENE_QUIT:        RenderQuit();
  end;
end;


procedure TClassicRenderer.RenderGameStats();
var
  Index: Integer;
begin
  for Index := PIECE_FIRST to PIECE_LAST do
  begin
    RenderMiniature(MINIATURE_X[Index], MINIATURE_Y[Index], Index, 9);
    RenderText(STATISTIC_X[Index], STATISTIC_Y[Index], '999', COLOR_RED);
  end;
end;


procedure TClassicRenderer.RenderLegal();
begin

end;


procedure TClassicRenderer.RenderMenu();
begin
  RenderMenuSelection();
end;


procedure TClassicRenderer.RenderPlay();
begin
  RenderPlaySelection();
  RenderPlayItems();
  RenderPlayParameters();
  RenderPlayBestScores();
end;


procedure TClassicRenderer.RenderGame();
begin
  RenderGameStats();
end;


procedure TClassicRenderer.RenderPause();
begin
  RenderPauseSelection();
  RenderPauseItems();
end;


procedure TClassicRenderer.RenderTopOut();
begin
  RenderTopOutSelection();
  RenderTopOutItems();
  RenderTopOutResult();
end;


procedure TClassicRenderer.RenderOptions();
begin
  RenderOptionsSelection();
  RenderOptionsItems();
  RenderOptionsParameters();
end;


procedure TClassicRenderer.RenderKeyboard();
begin
  RenderKeyboardItemSelection();
  RenderKeyboardItems();
  RenderKeyboardKeySelection();
  RenderKeyboardKeyScanCodes();
end;


procedure TClassicRenderer.RenderController();
begin
  RenderControllerItemSelection();
  RenderControllerItems();
  RenderControllerButtonSelection();
  RenderControllerButtonScanCodes();
end;


procedure TClassicRenderer.RenderQuit();
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
    SCENE_QUIT:        RenderQuit();
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
  SetThemeID(Settings.General.Theme);
end;


end.

