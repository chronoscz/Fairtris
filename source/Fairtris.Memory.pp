unit Fairtris.Memory;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Constants;


type
  TLegalMemory = class(TObject)
  public
    procedure Initialize();
  public
    FrameIndex: Integer;
  end;


type
  TMenuMemory = class(TObject)
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
  public
    Region: Integer;
    RNG: Integer;
    Level: Integer;
  end;


type
  TGameMemory = class(TObject)
  public     
    procedure Initialize();
    procedure Reset();
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
    procedure Initialize();
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
    Window: Integer;
    Theme: Integer;
    Sounds: Integer;
    Scroll: Integer;
  end;


type
  TKeyboardMemory = class(TObject)
  public      
    procedure Initialize();
  public
    ItemIndex: Integer;
    KeyIndex: Integer;
  public
    Changing: Boolean;
    SettingUp: Boolean;
  public
    ScanCodes: array [KEYBOARD_KEY_FIRST .. KEYBOARD_KEY_LAST] of UInt8;
  end;


type
  TControllerMemory = class(TObject)
  public             
    procedure Initialize();
  public
    ItemIndex: Integer;
    ButtonIndex: Integer;
  public
    Changing: Boolean;
    SettingUp: Boolean;
  public
    ScanCodes: array [CONTROLLER_BUTTON_FIRST .. CONTROLLER_BUTTON_LAST] of UInt8;
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
  end;


var
  Memory: TMemory;


implementation


procedure TLegalMemory.Initialize();
begin
  FrameIndex := 0;
end;


procedure TMenuMemory.Initialize();
begin
  ItemIndex := ITEM_MENU_FIRST;
end;


procedure TPlayMemory.Initialize();
begin
  ItemIndex := ITEM_PLAY_FIRST;

  // uzupełnić w dane pobrane z "Settings"
end;


procedure TGameMemory.Initialize();
begin

end;


procedure TGameMemory.Reset();
begin

end;


procedure TPauseMemory.Initialize();
begin
  ItemIndex := ITEM_PAUSE_FIRST;
end;


procedure TTopOutMemory.Initialize();
begin
  // tylko do testu SCENE_TOP_OUT
  //
  {} TotalScore := 9999999;
  {} Transition := 999999;
  {}
  {} LinesCleared := 999;
  {} LinesBurned := 999;
  {}
  {} TetrisRate := 100;
  //
  // później wywalić
end;


procedure TOptionsMemory.Initialize();
begin
  ItemIndex := ITEM_OPTIONS_FIRST;
  FromScene := SCENE_MENU;

  // uzupełnić w dane pobrane z "Settings"
  Window := WINDOW_FULLSCREEN; // a to wywalić
end;


procedure TKeyboardMemory.Initialize();
begin
  ItemIndex := ITEM_KEYBOARD_FIRST;
  KeyIndex := ITEM_KEYBOARD_KEY_FIRST;

  // uzupełnić w dane pobrane z "Settings"
end;


procedure TControllerMemory.Initialize();
begin
  ItemIndex := ITEM_CONTROLLER_FIRST;
  ButtonIndex := ITEM_CONTROLLER_BUTTON_FIRST;

  // uzupełnić w dane pobrane z "Settings"
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

  inherited Destroy();
end;


procedure TMemory.Initialize();
begin
  FLegal.Initialize();
  FMenu.Initialize();
  FPlay.Initialize();
  FGame.Initialize();
  FPause.Initialize();
  FTopOut.Initialize();
  FOptions.Initialize();
  FKeyboard.Initialize();
  FController.Initialize();
end;


end.

