{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Memory;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


type
  TLegalMemory = class(TObject)
  public
    procedure Initialize();
  public
    HangTimer: Integer;
  end;


type
  TMenuMemory = class(TObject)
  public             
    procedure Initialize();
  public
    ItemIndex: Integer;
  end;


type
  TModesMemory = class(TObject)
  public
    procedure Initialize();
  public
    ItemIndex: Integer;
  end;


type
  TPlayMemory = class(TObject)
  public      
    procedure Initialize();
  public
    ItemIndex: Integer;
    Autorepeat: Integer;
  public
    Region: Integer;
    Generator: Integer;
    Level: Integer;
  end;


type
  TGameMemory = class(TObject)
  private type
    TStack = array [0 .. 9, -2 .. 19] of Integer;
    TStats = array [PIECE_FIRST .. PIECE_LAST] of Integer;
  private type
    TLineClears = array [LINES_FIRST .. LINES_LAST] of Integer;
    TLineClearPermits = array [-2 .. 1] of Boolean;
    TLineClearIndexes = array [-2 .. 1] of Integer;
  public
    constructor Create();
  public
    procedure Reset();
  public
    Started: Boolean;
    Ended: Boolean;
  public
    State: Integer;
  public
    PieceID: Integer;
    PieceOrientation: Integer;
    PieceX: Integer;
    PieceY: Integer;
  public
    AutorepeatX: Integer;
    AutorepeatY: Integer;
  public
    AutospinCharged: Boolean;
    AutospinRotation: Integer;
  public
    FallTimer: Integer;
    FallSpeed: Integer;
    FallPoints: Integer;
    FallSkipped: Boolean;
  public
    LockRow: Integer;
    LockTimer: Integer;
  public
    ClearCount: Integer;
    ClearTimer: Integer;
    ClearColumn: Integer;
    ClearPermits: TLineClearPermits;
    ClearIndexes: TLineClearIndexes;
  public
    AfterTransition: Boolean;
    AfterKillScreen: Boolean;
  public
    LowerTimer: Integer;
    TopOutTimer: Integer;
  public
    Flashing: Boolean;
  public
    Stack: TStack;
    Stats: TStats;
    LineClears: TLineClears;
  public
    Best: Integer;
    Score: Integer;
    Transition: Integer;
    Lines: Integer;
    LinesCleared: Integer;
    LinesBurned: Integer;
    Level: Integer;
    Next: Integer;
    NextVisible: Boolean;
    Burned: Integer;
    TetrisRate: Integer;
    Gain: Integer;
    GainTimer: Integer;
  end;


type
  TPauseMemory = class(TObject)
  public           
    procedure Initialize();
  public
    ItemIndex: Integer;
    FromScene: Integer;
  end;


type
  TTopOutMemory = class(TObject)
  public
    ItemIndex: Integer;
  public
    TotalScore: Integer;
    Transition: Integer;
  public
    LinesCleared: Integer;
    LinesBurned: Integer;
  public
    TetrisRate: Integer;
  end;


type
  TOptionsMemory = class(TObject)
  public          
    procedure Initialize();
  public
    ItemIndex: Integer;
    FromScene: Integer;
  public
    Input: Integer;
    Size: Integer;
    Theme: Integer;
    Sounds: Integer;
    Scroll: Integer;
  end;


type
  TKeyboardMemory = class(TObject)
  private type
    TScanCodes = array [KEYBOARD_KEY_FIRST .. KEYBOARD_KEY_LAST] of UInt8;
  public      
    procedure Initialize();
  public
    function MappedCorrectly(): Boolean;
    procedure RemoveDuplicates(AScanCode: UInt8; AProtectedKey: Integer);
  public
    ItemIndex: Integer;
    KeyIndex: Integer;
  public
    Changing: Boolean;
    Mapping: Boolean;
  public
    ScanCodes: TScanCodes;
  end;


type
  TControllerMemory = class(TObject)
  private type
    TScanCodes = array [CONTROLLER_BUTTON_FIRST .. CONTROLLER_BUTTON_LAST] of UInt8;
  public             
    procedure Initialize();
  public
    function MappedCorrectly(): Boolean;
    procedure RemoveDuplicates(AScanCode: UInt8; AProtectedButton: Integer);
  public
    ItemIndex: Integer;
    ButtonIndex: Integer;
  public
    Changing: Boolean;
    Mapping: Boolean;
  public
    ScanCodes: TScanCodes;
  end;


type
  TQuitMemory = class(TObject)
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Initialize();
  public
    HangTimer: Integer;
    Buffer: PSDL_Texture;
  end;


type
  TMemory = class(TObject)
  private
    FLegal: TLegalMemory;
    FMenu: TMenuMemory;
    FPlay: TPlayMemory;
    FGame: TGameMemory;
    FPause: TPauseMemory;
    FTopOut: TTopOutMemory;
    FOptions: TOptionsMemory;
    FKeyboard: TKeyboardMemory;
    FController: TControllerMemory;
    FQuit: TQuitMemory;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Initialize();
  public
    property Legal: TLegalMemory read FLegal;
    property Menu: TMenuMemory read FMenu;
    property Play: TPlayMemory read FPlay;
    property Game: TGameMemory read FGame;
    property Pause: TPauseMemory read FPause;
    property TopOut: TTopOutMemory read FTopOut;
    property Options: TOptionsMemory read FOptions;
    property Keyboard: TKeyboardMemory read FKeyboard;
    property Controller: TControllerMemory read FController;
    property Quit: TQuitMemory read FQuit;
  end;


var
  Memory: TMemory;


implementation

uses
  SysUtils,
  Fairtris.Window,
  Fairtris.Settings,
  Fairtris.Classes,
  Fairtris.Arrays;


procedure TLegalMemory.Initialize();
begin
  HangTimer := 0;
end;


procedure TMenuMemory.Initialize();
begin
  ItemIndex := ITEM_MENU_FIRST;
end;


procedure TModesMemory.Initialize();
begin
  ItemIndex := ITEM_MODES_FIRST;
end;


procedure TPlayMemory.Initialize();
begin
  ItemIndex := ITEM_PLAY_FIRST;
  Autorepeat := 0;

  Region := Settings.General.Region;
  Generator := Settings.General.Generator;
  Level := Settings.General.Level;
end;


constructor TGameMemory.Create();
begin
  NextVisible := True;
end;


procedure TGameMemory.Reset();
begin
  Started := False;
  Ended := False;

  State := STATE_PIECE_CONTROL;

  PieceID := PIECE_UNKNOWN;
  PieceOrientation := PIECE_ORIENTATION_SPAWN;

  PieceX := PIECE_SPAWN_X;
  PieceY := PIECE_SPAWN_Y;

  AutorepeatX := 0;
  AutorepeatY := 0;
  AutospinCharged := False;

  FallTimer := 0;
  FallSpeed := 0;
  FallPoints := 0;
  FallSkipped := False;

  LockRow := 0;
  LockTimer := 0;

  ClearCount := 0;
  ClearTimer := 0;
  ClearColumn := 0;
  ClearPermits := Default(TLineClearPermits);
  ClearIndexes := Default(TLineClearIndexes);

  AfterTransition := False;
  AfterKillScreen := False;

  LowerTimer := 0;
  TopOutTimer := 0;

  Flashing := False;

  Stack := Default(TStack);
  Stats := Default(TStats);
  LineClears := Default(TLineClears);

  Best := 0;
  Score := 0;
  Transition := 0;

  Lines := 0;
  LinesCleared := 0;
  LinesBurned := 0;

  Level := 0;
  Next  := 0;
  Burned := 0;
  TetrisRate := 0;

  Gain := 0;
  GainTimer := 0;
end;


procedure TPauseMemory.Initialize();
begin
  ItemIndex := ITEM_PAUSE_FIRST;
end;


procedure TOptionsMemory.Initialize();
begin
  ItemIndex := ITEM_OPTIONS_FIRST;
  FromScene := SCENE_MENU;

  Input := Settings.General.Input;
  Size := Settings.General.Size;
  Theme := Settings.General.Theme;
  Sounds := Settings.General.Sounds;
  Scroll := Settings.General.Scroll;
end;


procedure TKeyboardMemory.Initialize();
begin
  ItemIndex := ITEM_KEYBOARD_FIRST;
  KeyIndex := ITEM_KEYBOARD_KEY_FIRST;

  ScanCodes := Settings.Keyboard.ScanCodes;
end;


function TKeyboardMemory.MappedCorrectly(): Boolean;
begin
  Result := (ScanCodes[KEYBOARD_KEY_UP]    <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED) and
            (ScanCodes[KEYBOARD_KEY_DOWN]  <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED) and
            (ScanCodes[KEYBOARD_KEY_LEFT]  <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED) and
            (ScanCodes[KEYBOARD_KEY_RIGHT] <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED) and
            (ScanCodes[KEYBOARD_KEY_START] <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED) and
            (ScanCodes[KEYBOARD_KEY_B]     <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED) and
            (ScanCodes[KEYBOARD_KEY_A]     <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED);
end;


procedure TKeyboardMemory.RemoveDuplicates(AScanCode: UInt8; AProtectedKey: Integer);
var
  Index: Integer;
begin
  for Index := Low(ScanCodes) to High(ScanCodes) do
    if (Index <> AProtectedKey) and (ScanCodes[Index] = AScanCode) then
      ScanCodes[Index] := KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
end;


procedure TControllerMemory.Initialize();
begin
  ItemIndex := ITEM_CONTROLLER_FIRST;
  ButtonIndex := ITEM_CONTROLLER_BUTTON_FIRST;

  ScanCodes := Settings.Controller.ScanCodes;
end;


function TControllerMemory.MappedCorrectly(): Boolean;
begin
  Result := (ScanCodes[CONTROLLER_BUTTON_LEFT]  <> CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED) and
            (ScanCodes[CONTROLLER_BUTTON_RIGHT] <> CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED) and
            (ScanCodes[CONTROLLER_BUTTON_START] <> CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED) and
            (ScanCodes[CONTROLLER_BUTTON_B]     <> CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED) and
            (ScanCodes[CONTROLLER_BUTTON_A]     <> CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED);
end;


procedure TControllerMemory.RemoveDuplicates(AScanCode: UInt8; AProtectedButton: Integer);
var
  Index: Integer;
begin
  for Index := Low(ScanCodes) to High(ScanCodes) do
    if (Index <> AProtectedButton) and (ScanCodes[Index] = AScanCode) then
      ScanCodes[Index] := CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED;
end;


constructor TQuitMemory.Create();
begin
  Buffer := SDL_CreateTexture(Window.Renderer, SDL_PIXELFORMAT_BGR24, SDL_TEXTUREACCESS_TARGET, BUFFER_WIDTH, BUFFER_HEIGHT);

  if Buffer = nil then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_CREATE_QUIT_BUFFER], SDL_GetError()]);
end;


destructor TQuitMemory.Destroy();
begin
  SDL_DestroyTexture(Buffer);
  inherited Destroy();
end;


procedure TQuitMemory.Initialize();
begin
  HangTimer := 0;
end;


constructor TMemory.Create();
begin
  FLegal := TLegalMemory.Create();
  FMenu := TMenuMemory.Create();
  FPlay := TPlayMemory.Create();
  FGame := TGameMemory.Create();
  FPause := TPauseMemory.Create();
  FTopOut := TTopOutMemory.Create();
  FOptions := TOptionsMemory.Create();
  FKeyboard := TKeyboardMemory.Create();
  FController := TControllerMemory.Create();
  FQuit := TQuitMemory.Create();
end;


destructor TMemory.Destroy();
begin
  FLegal.Free();
  FMenu.Free();
  FPlay.Free();
  FGame.Free();
  FPause.Free();
  FTopOut.Free();
  FOptions.Free();
  FKeyboard.Free();
  FController.Free();
  FQuit.Free();

  inherited Destroy();
end;


procedure TMemory.Initialize();
begin
  FLegal.Initialize();
  FMenu.Initialize();
  FPlay.Initialize();
  FPause.Initialize();
  FOptions.Initialize();
  FKeyboard.Initialize();
  FController.Initialize();
  FQuit.Initialize();
end;


end.

