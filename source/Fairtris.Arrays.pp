unit Fairtris.Arrays;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Constants;


const
  CLOCK_FRAMERATE_LIMIT: array [REGION_FIRST .. REGION_LAST] of Integer = (
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL
  );


const
  GROUND_NAME: array [SCENE_FIRST .. SCENE_LAST] of String = (
    'legal.bmp',
    'menu.bmp',
    'play.bmp',
    'game normal.bmp',
    'game flash.bmp',
    'pause.bmp',
    'top out.bmp',
    'options.bmp',
    'keyboard.bmp',
    'controller.bmp'
  );

const
  GROUND_PATH: array [THEME_FIRST .. THEME_LAST] of String = (
    'grounds\modern\',
    'grounds\classic\'
  );


const
  SPRITE_NAME: array [SPRITE_FIRST .. SPRITE_LAST] of String = (
    'charset.bmp',
    'bricks.bmp',
    'pieces.bmp',
    'miniatures.bmp',
    'controller.bmp'
  );

const
  SPRITE_PATH = 'sprites\';


const
  SOUND_NAME: array [SOUND_FIRST .. SOUND_LAST] of WideString = (
    '',
    'blip.wav',
    'start.wav',
    'shift.wav',
    'spin.wav',
    'drop.wav',
    'burn.wav',
    'tetris.wav',
    'transition.wav',
    'top out.wav',
    'pause.wav'
  );

const
  SOUND_PATH: array [REGION_FIRST .. REGION_LAST] of WideString = (
    'sounds\ntsc\',
    'sounds\ntsc\',
    'sounds\pal\',
    'sounds\pal\',
    'sounds\pal\',
    'sounds\pal\'
  );


const
  SOUND_LENGTH_NTSC: array [SOUND_FIRST .. SOUND_LAST] of Integer = (0, 170 ,190, 110, 280, 210, 770, 960, 1040, 1100, 330);
  SOUND_LENGTH_PAL:  array [SOUND_FIRST .. SOUND_LAST] of Integer = (0, 160, 210, 100, 320, 250, 760, 950, 1070, 1280, 380);
  SOUND_LENGTH_EUR:  array [SOUND_FIRST .. SOUND_LAST] of Integer = (0, 160, 210, 100, 320, 250, 760, 950, 1070, 1280, 380);


const
  LEVEL_FIRST: array [REGION_FIRST .. REGION_LAST] of Integer = (
    LEVEL_FIRST_NTSC,
    LEVEL_FIRST_NTSC,
    LEVEL_FIRST_PAL,
    LEVEL_FIRST_PAL,
    LEVEL_FIRST_PAL,
    LEVEL_FIRST_PAL
  );

const
  LEVEL_LAST: array [REGION_FIRST .. REGION_LAST] of Integer = (
    LEVEL_LAST_NTSC,
    LEVEL_LAST_NTSC,
    LEVEL_LAST_PAL,
    LEVEL_LAST_PAL,
    LEVEL_LAST_PAL,
    LEVEL_LAST_PAL
  );


const
  ITEM_X_MENU: array [ITEM_MENU_FIRST .. ITEM_MENU_LAST] of Integer = (
    ITEM_X_MENU_PLAY,
    ITEM_X_MENU_OPTIONS,
    ITEM_X_MENU_HELP,
    ITEM_X_MENU_QUIT
  );

const
  ITEM_X_PLAY: array [ITEM_PLAY_FIRST .. ITEM_PLAY_LAST] of Integer = (
    ITEM_X_PLAY_REGION,
    ITEM_X_PLAY_RNG,
    ITEM_X_PLAY_LEVEL,
    ITEM_X_PLAY_START,
    ITEM_X_PLAY_BACK
  );

const
  ITEM_X_PAUSE: array [ITEM_PAUSE_FIRST .. ITEM_PAUSE_LAST] of Integer = (
    ITEM_X_PAUSE_RESUME,
    ITEM_X_PAUSE_RESTART,
    ITEM_X_PAUSE_OPTIONS,
    ITEM_X_PAUSE_BACK
  );

const
  ITEM_X_TOP_OUT: array [ITEM_TOP_OUT_FIRST .. ITEM_TOP_OUT_LAST] of Integer = (
    ITEM_X_TOP_OUT_PLAY,
    ITEM_X_TOP_OUT_BACK
  );

  ITEM_X_TOP_OUT_RESULT: array [ITEM_TOP_OUT_RESULT_FIRST .. ITEM_TOP_OUT_RESULT_LAST] of Integer = (
    ITEM_X_TOP_OUT_RESULT_TOTAL_SCORE,
    ITEM_X_TOP_OUT_RESULT_TRANSITION,
    ITEM_X_TOP_OUT_RESULT_LINES_CLEARED,
    ITEM_X_TOP_OUT_RESULT_LINES_BURNED,
    ITEM_X_TOP_OUT_RESULT_TETRIS_RATE
  );

const
  ITEM_X_OPTIONS: array [ITEM_OPTIONS_FIRST .. ITEM_OPTIONS_LAST] of Integer = (
    ITEM_X_OPTIONS_INPUT,
    ITEM_X_OPTIONS_SET_UP,
    ITEM_X_OPTIONS_WINDOW,
    ITEM_X_OPTIONS_THEME,
    ITEM_X_OPTIONS_SOUNDS,
    ITEM_X_OPTIONS_SCROLL,
    ITEM_X_OPTIONS_BACK
  );

const
  ITEM_X_KEYBOARD: array [ITEM_KEYBOARD_FIRST .. ITEM_KEYBOARD_LAST] of Integer = (
    ITEM_X_KEYBOARD_CHANGE,
    ITEM_X_KEYBOARD_RESTORE,
    ITEM_X_KEYBOARD_SAVE,
    ITEM_X_KEYBOARD_CANCEL
  );

  ITEM_X_KEYBOARD_KEY: array [ITEM_KEYBOARD_KEY_FIRST .. ITEM_KEYBOARD_KEY_LAST] of Integer = (
    ITEM_X_KEYBOARD_KEY_UP,
    ITEM_X_KEYBOARD_KEY_DOWN,
    ITEM_X_KEYBOARD_KEY_LEFT,
    ITEM_X_KEYBOARD_KEY_RIGHT,
    ITEM_X_KEYBOARD_KEY_SELECT,
    ITEM_X_KEYBOARD_KEY_START,
    ITEM_X_KEYBOARD_KEY_B,
    ITEM_X_KEYBOARD_KEY_A,
    ITEM_X_KEYBOARD_KEY_BACK
  );

const
  ITEM_X_CONTROLLER: array [ITEM_CONTROLLER_FIRST .. ITEM_CONTROLLER_LAST] of Integer = (
    ITEM_X_CONTROLLER_CHANGE,
    ITEM_X_CONTROLLER_RESTORE,
    ITEM_X_CONTROLLER_SAVE,
    ITEM_X_CONTROLLER_CANCEL
  );

  ITEM_X_CONTROLLER_BUTTON: array [ITEM_CONTROLLER_BUTTON_FIRST .. ITEM_CONTROLLER_BUTTON_LAST] of Integer = (
    ITEM_X_CONTROLLER_BUTTON_UP,
    ITEM_X_CONTROLLER_BUTTON_DOWN,
    ITEM_X_CONTROLLER_BUTTON_LEFT,
    ITEM_X_CONTROLLER_BUTTON_RIGHT,
    ITEM_X_CONTROLLER_BUTTON_SELECT,
    ITEM_X_CONTROLLER_BUTTON_START,
    ITEM_X_CONTROLLER_BUTTON_B,
    ITEM_X_CONTROLLER_BUTTON_A,
    ITEM_X_CONTROLLER_BUTTON_BACK
  );


const
  ITEM_Y_MENU: array [ITEM_MENU_FIRST .. ITEM_MENU_LAST] of Integer = (
    ITEM_Y_MENU_PLAY,
    ITEM_Y_MENU_OPTIONS,
    ITEM_Y_MENU_HELP,
    ITEM_Y_MENU_QUIT
  );

const
  ITEM_Y_PLAY: array [ITEM_PLAY_FIRST .. ITEM_PLAY_LAST] of Integer = (
    ITEM_Y_PLAY_REGION,
    ITEM_Y_PLAY_RNG,
    ITEM_Y_PLAY_LEVEL,
    ITEM_Y_PLAY_START,
    ITEM_Y_PLAY_BACK
  );

const
  ITEM_Y_PAUSE: array [ITEM_PAUSE_FIRST .. ITEM_PAUSE_LAST] of Integer = (
    ITEM_Y_PAUSE_RESUME,
    ITEM_Y_PAUSE_RESTART,
    ITEM_Y_PAUSE_OPTIONS,
    ITEM_Y_PAUSE_BACK
  );

const
  ITEM_Y_TOP_OUT: array [ITEM_TOP_OUT_FIRST .. ITEM_TOP_OUT_LAST] of Integer = (
    ITEM_Y_TOP_OUT_PLAY,
    ITEM_Y_TOP_OUT_BACK
  );

  ITEM_Y_TOP_OUT_RESULT: array [ITEM_TOP_OUT_RESULT_FIRST .. ITEM_TOP_OUT_RESULT_LAST] of Integer = (
    ITEM_Y_TOP_OUT_RESULT_TOTAL_SCORE,
    ITEM_Y_TOP_OUT_RESULT_TRANSITION,
    ITEM_Y_TOP_OUT_RESULT_LINES_CLEARED,
    ITEM_Y_TOP_OUT_RESULT_LINES_BURNED,
    ITEM_Y_TOP_OUT_RESULT_TETRIS_RATE
  );

const
  ITEM_Y_OPTIONS: array [ITEM_OPTIONS_FIRST .. ITEM_OPTIONS_LAST] of Integer = (
    ITEM_Y_OPTIONS_INPUT,
    ITEM_Y_OPTIONS_SET_UP,
    ITEM_Y_OPTIONS_WINDOW,
    ITEM_Y_OPTIONS_THEME,
    ITEM_Y_OPTIONS_SOUNDS,
    ITEM_Y_OPTIONS_SCROLL,
    ITEM_Y_OPTIONS_BACK
  );

const
  ITEM_Y_KEYBOARD: array [ITEM_KEYBOARD_FIRST .. ITEM_KEYBOARD_LAST] of Integer = (
    ITEM_Y_KEYBOARD_CHANGE,
    ITEM_Y_KEYBOARD_RESTORE,
    ITEM_Y_KEYBOARD_SAVE,
    ITEM_Y_KEYBOARD_CANCEL
  );

  ITEM_Y_KEYBOARD_KEY: array [ITEM_KEYBOARD_KEY_FIRST .. ITEM_KEYBOARD_KEY_LAST] of Integer = (
    ITEM_Y_KEYBOARD_KEY_UP,
    ITEM_Y_KEYBOARD_KEY_DOWN,
    ITEM_Y_KEYBOARD_KEY_LEFT,
    ITEM_Y_KEYBOARD_KEY_RIGHT,
    ITEM_Y_KEYBOARD_KEY_SELECT,
    ITEM_Y_KEYBOARD_KEY_START,
    ITEM_Y_KEYBOARD_KEY_B,
    ITEM_Y_KEYBOARD_KEY_A,
    ITEM_Y_KEYBOARD_KEY_BACK
  );

const
  ITEM_Y_CONTROLLER: array [ITEM_CONTROLLER_FIRST .. ITEM_CONTROLLER_LAST] of Integer = (
    ITEM_Y_CONTROLLER_CHANGE,
    ITEM_Y_CONTROLLER_RESTORE,
    ITEM_Y_CONTROLLER_SAVE,
    ITEM_Y_CONTROLLER_CANCEL
  );

  ITEM_Y_CONTROLLER_BUTTON: array [ITEM_CONTROLLER_BUTTON_FIRST .. ITEM_CONTROLLER_BUTTON_LAST] of Integer = (
    ITEM_Y_CONTROLLER_BUTTON_UP,
    ITEM_Y_CONTROLLER_BUTTON_DOWN,
    ITEM_Y_CONTROLLER_BUTTON_LEFT,
    ITEM_Y_CONTROLLER_BUTTON_RIGHT,
    ITEM_Y_CONTROLLER_BUTTON_SELECT,
    ITEM_Y_CONTROLLER_BUTTON_START,
    ITEM_Y_CONTROLLER_BUTTON_B,
    ITEM_Y_CONTROLLER_BUTTON_A,
    ITEM_Y_CONTROLLER_BUTTON_BACK
  );


const
  ITEM_TEXT_MENU: array [ITEM_MENU_FIRST .. ITEM_MENU_LAST] of String = (
    ITEM_TEXT_MENU_PLAY,
    ITEM_TEXT_MENU_OPTIONS,
    ITEM_TEXT_MENU_HELP,
    ITEM_TEXT_MENU_QUIT
  );

const
  ITEM_TEXT_PLAY: array [ITEM_PLAY_FIRST .. ITEM_PLAY_LAST] of String = (
    ITEM_TEXT_PLAY_REGION,
    ITEM_TEXT_PLAY_RNG,
    ITEM_TEXT_PLAY_LEVEL,
    ITEM_TEXT_PLAY_START,
    ITEM_TEXT_PLAY_BACK
  );

  ITEM_TEXT_PLAY_REGION: array [REGION_FIRST .. REGION_LAST] of String = (
    ITEM_TEXT_PLAY_REGION_NTSC,
    ITEM_TEXT_PLAY_REGION_NTSC_EXTENDED,
    ITEM_TEXT_PLAY_REGION_PAL,
    ITEM_TEXT_PLAY_REGION_PAL_EXTENDED,
    ITEM_TEXT_PLAY_REGION_EUR,
    ITEM_TEXT_PLAY_REGION_EUR_EXTENDED
  );

  ITEM_TEXT_PLAY_RNG: array [RNG_FIRST .. RNG_LAST] of String = (
    ITEM_TEXT_PLAY_RNG_7_BAG,
    ITEM_TEXT_PLAY_RNG_FAIR,
    ITEM_TEXT_PLAY_RNG_CLASSIC,
    ITEM_TEXT_PLAY_RNG_RANDOM
  );

const
  ITEM_TEXT_PAUSE: array [ITEM_PAUSE_FIRST .. ITEM_PAUSE_LAST] of String = (
    ITEM_TEXT_PAUSE_RESUME,
    ITEM_TEXT_PAUSE_RESTART,
    ITEM_TEXT_PAUSE_OPTIONS,
    ITEM_TEXT_PAUSE_BACK
  );

const
  ITEM_TEXT_TOP_OUT: array [ITEM_TOP_OUT_FIRST .. ITEM_TOP_OUT_LAST] of String = (
    ITEM_TEXT_TOP_OUT_PLAY,
    ITEM_TEXT_TOP_OUT_BACK
  );

const
  ITEM_TEXT_OPTIONS: array [ITEM_OPTIONS_FIRST .. ITEM_OPTIONS_LAST] of String = (
    ITEM_TEXT_OPTIONS_INPUT,
    ITEM_TEXT_OPTIONS_SET_UP,
    ITEM_TEXT_OPTIONS_WINDOW,
    ITEM_TEXT_OPTIONS_THEME,
    ITEM_TEXT_OPTIONS_SOUNDS,
    ITEM_TEXT_OPTIONS_SCROLL,
    ITEM_TEXT_OPTIONS_BACK
  );

  ITEM_TEXT_OPTIONS_INPUT: array [INPUT_FIRST .. INPUT_LAST] of String = (
    ITEM_TEXT_OPTIONS_INPUT_KEYBOARD,
    ITEM_TEXT_OPTIONS_INPUT_CONTROLLER
  );

  ITEM_TEXT_OPTIONS_WINDOW: array [WINDOW_FIRST .. WINDOW_LAST] of String = (
    ITEM_TEXT_OPTIONS_WINDOW_NATIVE,
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_2X,
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_3X,
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_4X,
    ITEM_TEXT_OPTIONS_WINDOW_FULLSCREEN
  );

  ITEM_TEXT_OPTIONS_THEME: array [THEME_FIRST .. THEME_LAST] of String = (
    ITEM_TEXT_OPTIONS_THEME_MODERN,
    ITEM_TEXT_OPTIONS_THEME_CLASSIC
  );

  ITEM_TEXT_OPTIONS_SOUNDS: array [SOUNDS_FIRST .. SOUNDS_LAST] of String = (
    ITEM_TEXT_OPTIONS_SOUNDS_ENABLED,
    ITEM_TEXT_OPTIONS_SOUNDS_DISABLED
  );

  ITEM_TEXT_OPTIONS_SCROLL: array [SCROLL_FIRST .. SCROLL_LAST] of String = (
    ITEM_TEXT_OPTIONS_SCROLL_ENABLED,
    ITEM_TEXT_OPTIONS_SCROLL_DISABLED
  );

const
  ITEM_TEXT_KEYBOARD: array [ITEM_KEYBOARD_FIRST .. ITEM_KEYBOARD_LAST] of String = (
    ITEM_TEXT_KEYBOARD_CHANGE,
    ITEM_TEXT_KEYBOARD_RESTORE,
    ITEM_TEXT_KEYBOARD_SAVE,
    ITEM_TEXT_KEYBOARD_CANCEL
  );

  ITEM_TEXT_KEYBOARD_KEY: array [ITEM_KEYBOARD_KEY_FIRST .. ITEM_KEYBOARD_KEY_LAST] of String = (
    ITEM_TEXT_KEYBOARD_KEY_UP,
    ITEM_TEXT_KEYBOARD_KEY_DOWN,
    ITEM_TEXT_KEYBOARD_KEY_LEFT,
    ITEM_TEXT_KEYBOARD_KEY_RIGHT,
    ITEM_TEXT_KEYBOARD_KEY_SELECT,
    ITEM_TEXT_KEYBOARD_KEY_START,
    ITEM_TEXT_KEYBOARD_KEY_B,
    ITEM_TEXT_KEYBOARD_KEY_A,
    ITEM_TEXT_KEYBOARD_KEY_BACK
  );

  ITEM_TEXT_KEYBOARD_SCANCODE: array [KEYBOARD_SCANCODE_KEY_FIRST .. KEYBOARD_SCANCODE_KEY_LAST] of String = (
    'NONE'   , 'L BTN'  , 'R BTN'  , 'CANCEL' , 'M BTN'  , 'X BTN1' , 'X BTN2' , '?'      ,
    'BACK'   , 'TAB'    , '?'      , '?'      , 'CLEAR'  , 'RETURN' , '?'      , '?'      ,
    'SHIFT'  , 'CTRL'   , 'MENU'   , 'PAUSE'  , 'CAP'    , 'KANA'   , '?'      , 'JUNJA'  ,
    'FINAL'  , 'HANJA'  , '?'      , 'ESCAPE' , 'CONV'   , 'NOCONV' , 'ACCEPT' , 'MODCHG' ,
    'SPACE'  , 'PRIOR'  , 'NEXT'   , 'END'    , 'HOME'   , 'LEFT'   , 'UP'     , 'RIGHT'  ,
    'DOWN'   , 'SELECT' , 'PRINT'  , 'EXEC'   , 'SNPSHT' , 'INSERT' , 'DELETE' , 'HELP'   ,
    '0'      , '1'      , '2'      , '3'      , '4'      , '5'      , '6'      , '7'      ,
    '8'      , '9'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      ,
    '?'      , 'A'      , 'B'      , 'C'      , 'D'      , 'E'      , 'F'      , 'G'      ,
    'H'      , 'I'      , 'J'      , 'K'      , 'L'      , 'M'      , 'N'      , 'O'      ,
    'P'      , 'Q'      , 'R'      , 'S'      , 'T'      , 'U'      , 'V'      , 'W'      ,
    'X'      , 'Y'      , 'Z'      , 'L WIN'  , 'R WIN'  , 'APPS'   , '?'      , 'SLEEP'  ,
    'NUM 0'  , 'NUM 1'  , 'NUM 2'  , 'NUM 3'  , 'NUM 4'  , 'NUM 5'  , 'NUM 6'  , 'NUM 7'  ,
    'NUM 8'  , 'NUM 9'  , 'MUL'    , 'ADD'    , 'SEP'    , 'SUB'    , 'DEC'    , 'DIV'    ,
    'F1'     , 'F2'     , 'F3'     , 'F4'     , 'F5'     , 'F6'     , 'F7'     , 'F8'     ,
    'F9'     , 'F10'    , 'F11'    , 'F12'    , 'F13'    , 'F14'    , 'F15'    , 'F16'    ,
    'F17'    , 'F18'    , 'F19'    , 'F20'    , 'F21'    , 'F22'    , 'F23'    , 'F24'    ,
    '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      ,
    'NUMLCK' , 'SCROLL' , 'OEM JI' , 'OEM MA' , 'OEM TO' , 'OEM LO' , 'OEM RO' , '?'      ,
    '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      ,
    'L SHIFT', 'R SHIFT', 'L CTRL' , 'R CTRL' , 'L MENU' , 'R MENU' , 'BR BACK', 'BR FORW',
    'BR REFR', 'BR STOP', 'BR SRCH', 'BR FAV' , 'BR HOME', 'VO MUTE', 'VO DOWN', 'VO UP'  ,
    'MD NEXT', 'MD PREV', 'MD STOP', 'MD PLAY', 'LN MAIL', 'LN MED' , 'LN APP1', 'LN APP2',
    '?'      , '?'      , 'OEM 1'  , 'OEM PLS', 'OEM COM', 'OEM MIN', 'OEM PER', 'OEM 2'  ,
    'OEM 3'  , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      ,
    '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      ,
    '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      , '?'      ,
    '?'      , '?'      , '?'      , 'OEM 4'  , 'OEM 5'  , 'OEM 6'  , 'OEM 7'  , 'OEM 8'  ,
    '?'      , 'OEM AX' , 'OEM 102', 'ICO HLP', 'ICO 00' , 'PROCKEY', 'ICO CLR', 'PACKET' ,
    '?'      , 'OEM RST', 'OEM JMP', 'OEM PA1', 'OEM PA2', 'OEM PA3', 'OEM WSC', 'OEM CSL',
    'OEM ATN', 'OEM FIN', 'OEM CPY', 'OEM AUT', 'OEM ENL', 'OEM BTB', 'ATTN'   , 'CRSEL'  ,
    'EXSEL'  , 'EREOF'  , 'PLAY'   , 'ZOOM'   , 'NONAME' , 'PA1'    , 'OEM CLR', '?'
  );

const
  ITEM_TEXT_CONTROLLER: array [ITEM_CONTROLLER_FIRST .. ITEM_CONTROLLER_LAST] of String = (
    ITEM_TEXT_CONTROLLER_CHANGE,
    ITEM_TEXT_CONTROLLER_RESTORE,
    ITEM_TEXT_CONTROLLER_SAVE,
    ITEM_TEXT_CONTROLLER_CANCEL
  );

  ITEM_TEXT_CONTROLLER_BUTTON: array [ITEM_CONTROLLER_BUTTON_FIRST .. ITEM_CONTROLLER_BUTTON_LAST] of String = (
    ITEM_TEXT_CONTROLLER_BUTTON_UP,
    ITEM_TEXT_CONTROLLER_BUTTON_DOWN,
    ITEM_TEXT_CONTROLLER_BUTTON_LEFT,
    ITEM_TEXT_CONTROLLER_BUTTON_RIGHT,
    ITEM_TEXT_CONTROLLER_BUTTON_SELECT,
    ITEM_TEXT_CONTROLLER_BUTTON_START,
    ITEM_TEXT_CONTROLLER_BUTTON_B,
    ITEM_TEXT_CONTROLLER_BUTTON_A,
    ITEM_TEXT_CONTROLLER_BUTTON_BACK
  );

  ITEM_TEXT_CONTROLLER_SCANCODE: array [CONTROLLER_SCANCODE_FIRST .. CONTROLLER_SCANCODE_LAST] of String = (
    'BTN 0' , 'BTN 1' , 'BTN 2' , 'BTN 3' , 'BTN 4' , 'BTN 5' , 'BTN 6' , 'BTN 7' ,
    'BTN 8' , 'BTN 9' , 'BTN 10', 'BTN 11', 'BTN 12', 'BTN 13', 'BTN 14', 'BTN 15',
    'BTN 16', 'BTN 17', 'BTN 18', 'BTN 19', 'BTN 20', 'BTN 21', 'BTN 22', 'BTN 23',
    'BTN 24', 'BTN 25', 'BTN 26', 'BTN 27', 'BTN 28', 'BTN 29', 'BTN 30', 'BTN 31'
  );


implementation

end.

