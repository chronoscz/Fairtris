unit Fairtris.Arrays;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


const
  CLOCK_FRAMERATE_LIMIT: array [REGION_FIRST .. REGION_LAST] of Integer = (
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL
  );


const
  KEYBOARD_KEY_LOCKED: set of UInt8 = [
    KEYBOARD_SCANCODE_KEY_HELP_UNDERSTAND,
    KEYBOARD_SCANCODE_KEY_HELP_CONTROL,
    KEYBOARD_SCANCODE_KEY_TOGGLE_CLIP,
    KEYBOARD_SCANCODE_KEY_TOGGLE_VIDEO
  ];


const
  GROUND_FILENAME: array [SCENE_FIRST .. SCENE_LAST] of String = (
    'legal.bmp',
    'menu.bmp',
    'play.bmp',
    'game normal.bmp',
    'game flash.bmp',
    'pause.bmp',
    'top out.bmp',
    'options.bmp',
    'keyboard.bmp',
    'controller.bmp',
    'quit.bmp'
  );

const
  GROUND_PATH: array [THEME_FIRST .. THEME_LAST] of String = (
    'grounds\modern\',
    'grounds\classic\'
  );


const
  SPRITE_FILENAME: array [SPRITE_FIRST .. SPRITE_LAST] of String = (
    'charset.bmp',
    'bricks.bmp',
    'pieces.bmp',
    'miniatures.bmp',
    'controller.bmp'
  );

const
  SPRITE_PATH = 'sprites\';


const
  SOUND_FILENAME: array [SOUND_FIRST .. SOUND_LAST] of String = (
    'blip.wav',
    'start.wav',
    'shift.wav',
    'spin.wav',
    'drop.wav',
    'burn.wav',
    'tetris.wav',
    'transition.wav',
    'top out.wav',
    'pause.wav',
    'glass.wav'
  );

const
  SOUND_PATH: array [SOUND_REGION_FIRST .. SOUND_REGION_LAST] of String = (
    'sounds\ntsc\',
    'sounds\pal\'
  );

const
  SOUND_REGION: array [REGION_FIRST .. REGION_LAST] of Integer = (
    SOUND_REGION_NTSC,
    SOUND_REGION_NTSC,
    SOUND_REGION_NTSC,
    SOUND_REGION_NTSC,
    SOUND_REGION_PAL,
    SOUND_REGION_PAL,
    SOUND_REGION_PAL,
    SOUND_REGION_PAL
  );

const
  SOUND_CHANNEL: array [SOUND_FIRST .. SOUND_LAST] of Integer = (5, 0, 2, 3, 4, 0, 0, 1, 0, 0, 0);


const
  BEST_SCORES_FILENAME: array [RNG_FIRST .. RNG_LAST] of String = (
    '7-bag.ini',
    'fair.ini',
    'classic.ini',
    'unfair.ini'
  );

const
  BEST_SCORES_PATH: array [REGION_FIRST .. REGION_LAST] of String = (
    'scores\ntsc\',
    'scores\ntsc extended\',
    'scores\jpn\',
    'scores\jpn extended\',
    'scores\pal\',
    'scores\pal extended\',
    'scores\eur\',
    'scores\eur extended\'
  );


const
  LEVEL_SMALLEST: array [REGION_FIRST .. REGION_LAST] of Integer = (
    LEVEL_FIRST_NTSC,
    LEVEL_FIRST_NTSC,
    LEVEL_FIRST_NTSC,
    LEVEL_FIRST_NTSC,
    LEVEL_FIRST_PAL,
    LEVEL_FIRST_PAL,
    LEVEL_FIRST_PAL,
    LEVEL_FIRST_PAL
  );

const
  LEVEL_KILLSCREEN: array [REGION_FIRST .. REGION_LAST] of Integer = (
    LEVEL_LAST_NTSC,
    LEVEL_LAST_NTSC,
    LEVEL_LAST_NTSC,
    LEVEL_LAST_NTSC,
    LEVEL_LAST_PAL,
    LEVEL_LAST_PAL,
    LEVEL_LAST_PAL,
    LEVEL_LAST_PAL
  );

const
  LEVEL_COUNT: array [REGION_FIRST .. REGION_LAST] of Integer = (
    LEVEL_COUNT_NTSC,
    LEVEL_COUNT_NTSC,
    LEVEL_COUNT_NTSC,
    LEVEL_COUNT_NTSC,
    LEVEL_COUNT_PAL,
    LEVEL_COUNT_PAL,
    LEVEL_COUNT_PAL,
    LEVEL_COUNT_PAL
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

  ITEM_Y_PLAY_BEST_SCORES: array [THEME_FIRST .. THEME_LAST] of Integer = (
    ITEM_Y_PLAY_BEST_SCORES_MODERN,
    ITEM_Y_PLAY_BEST_SCORES_CLASSIC
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
    ITEM_TEXT_PLAY_REGION_TITLE,
    ITEM_TEXT_PLAY_RNG_TITLE,
    ITEM_TEXT_PLAY_LEVEL,
    ITEM_TEXT_PLAY_START,
    ITEM_TEXT_PLAY_BACK
  );

  ITEM_TEXT_PLAY_REGION: array [REGION_FIRST .. REGION_LAST] of String = (
    ITEM_TEXT_PLAY_REGION_NTSC,
    ITEM_TEXT_PLAY_REGION_NTSC_EXTENDED,
    ITEM_TEXT_PLAY_REGION_JPN,
    ITEM_TEXT_PLAY_REGION_JPN_EXTENDED,
    ITEM_TEXT_PLAY_REGION_PAL,
    ITEM_TEXT_PLAY_REGION_PAL_EXTENDED,
    ITEM_TEXT_PLAY_REGION_EUR,
    ITEM_TEXT_PLAY_REGION_EUR_EXTENDED
  );

  ITEM_TEXT_PLAY_RNG: array [RNG_FIRST .. RNG_LAST] of String = (
    ITEM_TEXT_PLAY_RNG_7_BAG,
    ITEM_TEXT_PLAY_RNG_FAIR,
    ITEM_TEXT_PLAY_RNG_CLASSIC,
    ITEM_TEXT_PLAY_RNG_UNFAIR
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
    ITEM_TEXT_OPTIONS_INPUT_TITLE,
    ITEM_TEXT_OPTIONS_SET_UP,
    ITEM_TEXT_OPTIONS_WINDOW_TITLE,
    ITEM_TEXT_OPTIONS_THEME_TITLE,
    ITEM_TEXT_OPTIONS_SOUNDS_TITLE,
    ITEM_TEXT_OPTIONS_SCROLL_TITLE,
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
    ''       , ''       , ''       , ''       , 'A'      , 'B'      , 'C'      , 'D'      ,
    'E'      , 'F'      , 'G'      , 'H'      , 'I'      , 'J'      , 'K'      , 'L'      ,
    'M'      , 'N'      , 'O'      , 'P'      , 'Q'      , 'R'      , 'S'      , 'T'      ,
    'U'      , 'V'      , 'W'      , 'X'      , 'Y'      , 'Z'      , '1'      , '2'      ,
    '3'      , '4'      , '5'      , '6'      , '7'      , '8'      , '9'      , '0'      ,
    'ENTER'  , 'ESCAPE' , 'BACKSP' , 'TAB'    , 'SPACE'  , 'MINUS'  , 'EQUALS' , 'L BRACK',
    'R BRACK', 'BSLASH' , 'NUSHASH', 'SCOLON' , 'QUOTE'  , 'TILDE'  , 'COMMA'  , 'PERIOD' ,
    'SLASH'  , 'CPSLOCK', 'F1'     , 'F2'     , 'F3'     , 'F4'     , 'F5'     , 'F6'     ,
    'F7'     , 'F8'     , 'F9'     , 'F10'    , 'F11'    , 'F12'    , 'PRTSCRN', 'SCRLOCK',
    'PAUSE'  , 'INSERT' , 'HOME'   , 'PAGE UP', 'DELETE' , 'END'    , 'PAGE DW', 'RIGHT'  ,
    'LEFT'   , 'DOWN'   , 'UP'     , 'NUMLOCK', 'NUM DIV', 'NUM MUL', 'NUM MIN', 'NUM PLS',
    'NUM ENT', 'NUM 1'  , 'NUM 2'  , 'NUM 3'  , 'NUM 4'  , 'NUM 5'  , 'NUM 6'  , 'NUM 7'  ,
    'NUM 8'  , 'NUM 9'  , 'NUM 0'  , 'NUM PER', 'NUSBLSH', 'APPS'   , 'POWER'  , 'NUM EQL',
    'F13'    , 'F14'    , 'F15'    , 'F16'    , 'F17'    , 'F18'    , 'F19'    , 'F20'    ,
    'F21'    , 'F22'    , 'F23'    , 'F24'    , 'EXECUTE', 'HELP'   , 'MENU'   , 'SELECT' ,
    'STOP'   , 'AGAIN'  , 'UNDO'   , 'CUT'    , 'COPY'   , 'PASTE'  , 'FIND'   , 'VOLMUTE',
    'VOLUP'  , 'VOLDOWN', ''       , ''       , ''       , 'NUM COM', 'NUM EA4', 'INTER 1',
    'INTER 2', 'INTER 3', 'INTER 4', 'INTER 5', 'INTER 6', 'INTER 7', 'INTER 8', 'INTER 9',
    'LANG 1' , 'LANG 2' , 'LANG 3' , 'LANG 4' , 'LANG 5' , 'LANG 6' , 'LANG 7' , 'LANG 8' ,
    'LANG 9' , 'ALT ERS', 'SYS REQ', 'CANCEL' , 'CLEAR'  , 'PRIOR'  , 'RETURN2', 'SEP'    ,
    'OUT'    , 'OPER'   , 'CLR AGN', 'CR SEL' , 'EX SEL' , ''       , ''       , ''       ,
    ''       , ''       , ''       , ''       , ''       , ''       , ''       , ''       ,
    'NUM 00' , 'NUM 000', 'THO SEP', 'DEC SEP', 'CUR UNI', 'CURSUNI', 'NUM LPR', 'NUM RPR',
    'NUM LBR', 'NUM RBR', 'NUM TAB', 'NUM BKS', 'NUM A'  , 'NUM B'  , 'NUM C'  , 'NUM D'  ,
    'NUM E'  , 'NUM F'  , 'NUM XOR', 'NUM POW', 'NUM PCT', 'NUM LES', 'NUM GRT', 'NUM AMP',
    'NUM DLA', 'NUM VBR', 'NUM DVB', 'NUM COL', 'NUM HSH', 'NUM SPC', 'NUM AT' , 'NUM EXC',
    'NUM MST', 'NUM MRE', 'NUM MCL', 'NUM MAD', 'NUM MSB', 'NUM MML', 'NUM MDV', 'NUM PM' ,
    'NUM CLR', 'NUM CLE', 'NUM BIN', 'NUM OCT', 'NUM DEC', 'NUM HEX', ''       , ''       ,
    'L CTRL' , 'L SHIFT', 'L ALT'  , 'L WIN'  , 'R CTRL' , 'R SHIFT', 'R ALT'  , 'R WIN'  ,
    ''       , ''       , ''       , ''       , ''       , ''       , ''       , ''       ,
    ''       , ''       , ''       , ''       , ''       , ''       , ''       , ''       ,
    ''       , ''       , ''       , ''       , ''       , ''       , ''       , ''
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

  ITEM_TEXT_CONTROLLER_SCANCODE: array [CONTROLLER_SCANCODE_BUTTON_FIRST .. CONTROLLER_SCANCODE_BUTTON_LAST + 1] of String = (
    'BTN 1' , 'BTN 2' , 'BTN 3' , 'BTN 4' , 'BTN 5' , 'BTN 6' , 'BTN 7' , 'BTN 8' ,
    'BTN 9' , 'BTN 10', 'BTN 11', 'BTN 12', 'BTN 13', 'BTN 14', 'BTN 15', 'BTN 16',
    'BTN 17', 'BTN 18', 'BTN 19', 'BTN 20', 'BTN 21', 'BTN 22', 'BTN 23', 'BTN 24',
    'BTN 25', 'BTN 26', 'BTN 27', 'BTN 28', 'BTN 29', 'BTN 30', 'BTN 31', 'BTN_32',
    'UP'    , 'DOWN'  , 'LEFT'  , 'RIGHT', ''
  );


const
  MINIATURE_X: array [PIECE_FIRST .. PIECE_LAST] of Integer = (
    MINIATURE_X_T,
    MINIATURE_X_J,
    MINIATURE_X_Z,
    MINIATURE_X_O,
    MINIATURE_X_S,
    MINIATURE_X_L,
    MINIATURE_X_I
  );

  MINIATURE_Y: array [PIECE_FIRST .. PIECE_LAST] of Integer = (
    MINIATURE_Y_T,
    MINIATURE_Y_J,
    MINIATURE_Y_Z,
    MINIATURE_Y_O,
    MINIATURE_Y_S,
    MINIATURE_Y_L,
    MINIATURE_Y_I
  );


const
  STATISTIC_X: array [PIECE_FIRST .. PIECE_LAST] of Integer = (
    STATISTIC_X_T,
    STATISTIC_X_J,
    STATISTIC_X_Z,
    STATISTIC_X_O,
    STATISTIC_X_S,
    STATISTIC_X_L,
    STATISTIC_X_I
  );

  STATISTIC_Y: array [PIECE_FIRST .. PIECE_LAST] of Integer = (
    STATISTIC_Y_T,
    STATISTIC_Y_J,
    STATISTIC_Y_Z,
    STATISTIC_Y_O,
    STATISTIC_Y_S,
    STATISTIC_Y_L,
    STATISTIC_Y_I
  );


const
  THUMBNAIL_BUTTON_X: array [DEVICE_FIRST .. DEVICE_LAST] of Integer = (5, 5,  1, 12, 22, 29, 42, 49);
  THUMBNAIL_BUTTON_Y: array [DEVICE_FIRST .. DEVICE_LAST] of Integer = (4, 15, 8, 8,  14, 14, 13, 13);

  THUMBNAIL_BUTTON_WIDTH:  array [DEVICE_FIRST .. DEVICE_LAST] of Integer = (7, 7, 4, 4, 6, 6, 6, 6);
  THUMBNAIL_BUTTON_HEIGHT: array [DEVICE_FIRST .. DEVICE_LAST] of Integer = (4, 4, 7, 7, 4, 4, 6, 6);


const
  TOP_X: array [THEME_FIRST .. THEME_LAST] of Integer = (16, 192);
  TOP_Y: array [THEME_FIRST .. THEME_LAST] of Integer = (50, 40);


const
  SCORES_X: array [THEME_FIRST .. THEME_LAST] of Integer = (184, 192);
  SCORES_Y: array [THEME_FIRST .. THEME_LAST] of Integer = (50,  64);


const
  LINES_X: array [THEME_FIRST .. THEME_LAST] of Integer = (184, 152);
  LINES_Y: array [THEME_FIRST .. THEME_LAST] of Integer = (82,  24);


const
  LEVEL_X: array [THEME_FIRST .. THEME_LAST] of Integer = (184, 208);
  LEVEL_Y: array [THEME_FIRST .. THEME_LAST] of Integer = (106, 168);


const
  NEXT_X: array [THEME_FIRST .. THEME_LAST] of Integer = (184, 192);
  NEXT_Y: array [THEME_FIRST .. THEME_LAST] of Integer = (144, 120);


const
  STACK_X: array [THEME_FIRST .. THEME_LAST] of Integer = (88, 96);
  STACK_Y: array [THEME_FIRST .. THEME_LAST] of Integer = (40, 48);


const
  PIECE_LAYOUT: array [PIECE_FIRST .. PIECE_LAST, PIECE_ORIENTATION_FIRST .. PIECE_ORIENTATION_LAST] of array [-2 .. 2, -2 .. 2] of Integer = (
    (
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_A    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_A    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      )
    ),
    (
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_B    , BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      )
    ),
    (
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      )
    ),
    (
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_A    , BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      )
    ),
    (
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_B    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      )
    ),
    (
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_C    , BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_C    , BRICK_C    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      )
    ),
    (
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_A    , BRICK_A    , BRICK_A    , BRICK_A    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_A    , BRICK_A    , BRICK_A    , BRICK_A    , BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      ),
      (
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_A    , BRICK_EMPTY, BRICK_EMPTY),
        (BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY, BRICK_EMPTY)
      )
    )
  );


const
  PIECE_SHIFT_X_MIN: array [PIECE_FIRST .. PIECE_LAST, PIECE_ORIENTATION_FIRST .. PIECE_ORIENTATION_LAST] of Integer = (
    (1, 1, 1, 0),
    (1, 1, 1, 0),
    (1, 0, 1, 0),
    (1, 1, 1, 1),
    (1, 0, 1, 0),
    (1, 1, 1, 0),
    (2, 0, 2, 0)
  );

  PIECE_SHIFT_X_MAX: array [PIECE_FIRST .. PIECE_LAST, PIECE_ORIENTATION_FIRST .. PIECE_ORIENTATION_LAST] of Integer = (
    (8, 9, 8, 8),
    (8, 9, 8, 8),
    (8, 8, 8, 8),
    (9, 9, 9, 9),
    (8, 8, 8, 8),
    (8, 9, 8, 8),
    (8, 9, 8, 9)
  );


const
  PIECE_ROTATION_X_MIN: array [PIECE_FIRST .. PIECE_LAST, PIECE_ORIENTATION_FIRST .. PIECE_ORIENTATION_LAST] of Integer = (
    (1, 1, 1, 1),
    (1, 1, 1, 1),
    (1, 1, 1, 1),
    (1, 1, 1, 1),
    (1, 1, 1, 1),
    (1, 1, 1, 1),
    (2, 2, 2, 2)
  );

  PIECE_ROTATION_X_MAX: array [PIECE_FIRST .. PIECE_LAST, PIECE_ORIENTATION_FIRST .. PIECE_ORIENTATION_LAST] of Integer = (
    (8, 8, 8, 8),
    (8, 8, 8, 8),
    (8, 8, 8, 8),
    (8, 8, 8, 8),
    (8, 8, 8, 8),
    (8, 8, 8, 8),
    (8, 8, 8, 8)
  );


const
  PIECE_ROTATION_Y_MAX: array [PIECE_FIRST .. PIECE_LAST, PIECE_ORIENTATION_FIRST .. PIECE_ORIENTATION_LAST] of Integer = (
    (18, 18, 18, 18),
    (18, 18, 18, 18),
    (18, 18, 18, 18),
    (18, 18, 18, 18),
    (18, 18, 18, 18),
    (18, 18, 18, 18),
    (18, 18, 18, 18)
  );


const
  PIECE_DROP_Y_MAX: array [PIECE_FIRST .. PIECE_LAST, PIECE_ORIENTATION_FIRST .. PIECE_ORIENTATION_LAST] of Integer = (
    (18, 18, 19, 18),
    (18, 18, 19, 18),
    (18, 18, 18, 18),
    (18, 18, 18, 18),
    (18, 18, 18, 18),
    (18, 18, 19, 18),
    (19, 18, 19, 18)
  );


const
  PIECE_FRAMES_HANG: array [REGION_FIRST .. REGION_LAST] of Integer = (
    -Round(CLOCK_FRAMERATE_NTSC * 1.6),
    -Round(CLOCK_FRAMERATE_NTSC * 1.6),
    -Round(CLOCK_FRAMERATE_NTSC * 1.6),
    -Round(CLOCK_FRAMERATE_NTSC * 1.6),
    -Round(CLOCK_FRAMERATE_PAL * 1.6),
    -Round(CLOCK_FRAMERATE_PAL * 1.6),
    -Round(CLOCK_FRAMERATE_PAL * 1.6),
    -Round(CLOCK_FRAMERATE_PAL * 1.6)
  );


const
  PIECE_FRAMES_LOCK_DELAY: array [0 .. 19] of Integer = (
    12, 12, 12, 12, 12, 12,
    10, 10, 10, 10,
    08, 08, 08, 08,
    06, 06, 06, 06,
    04, 04
  );


const
  AUTOSHIFT_FRAMES_PRECHARGE: array [REGION_FIRST .. REGION_LAST] of Integer = (10, 10, 10, 10, 08, 08, 08, 08);
  AUTOSHIFT_FRAMES_CHARGE:    array [REGION_FIRST .. REGION_LAST] of Integer = (16, 16, 15, 15, 12, 12, 12, 12);


const
  AUTOFALL_FRAMES: array [REGION_FIRST .. REGION_LAST, LEVEL_FIRST .. LEVEL_LAST] of Integer = (
    (48, 43, 38, 33, 28, 23, 18, 13, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
    (48, 43, 38, 33, 28, 23, 18, 13, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
    (48, 43, 38, 33, 28, 23, 18, 13, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
    (48, 43, 38, 33, 28, 23, 18, 13, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
    (36, 32, 29, 25, 22, 18, 15, 11, 7, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    (36, 32, 29, 25, 22, 18, 15, 11, 7, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    (38, 34, 30, 26, 22, 18, 14, 10, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
    (38, 34, 30, 26, 22, 18, 14, 10, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1)
  );


const
  TRANSITION_LINES: array [REGION_FIRST .. REGION_LAST, LEVEL_FIRST .. LEVEL_LAST] of Integer = (
    (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 100, 100, 100, 100, 100, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240),
    (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300),
    (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 100, 100, 100, 100, 100, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240),
    (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300),
    (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 100, 100, 100, 100, 100, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240),
    (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300),
    (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 100, 100, 100, 100, 100, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240),
    (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300)
  );

  KILLSCREEN_LINES: array [REGION_FIRST .. REGION_LAST, LEVEL_FIRST .. LEVEL_LAST] of Integer = (
    (290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 280, 270, 260, 250, 240, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230),
    (290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290),
    (290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 280, 270, 260, 250, 240, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230),
    (290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290),
    (290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 280, 270, 260, 250, 240, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230),
    (290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290),
    (290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 280, 270, 260, 250, 240, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230, 230),
    (290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290, 290)
  );


const
  LINECLEAR_VALUE: array [LINES_UNKNOWN .. LINES_LAST] of Integer = (0, 40, 100, 300, 1200);


const
  TOP_OUT_FRAMES: array [REGION_FIRST .. REGION_LAST] of Integer = (
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_NTSC,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL,
    CLOCK_FRAMERATE_PAL
  );


const
  FAIR_BAGS: array [FAIR_BAGS_FIRST .. FAIR_BAGS_LAST] of array [FAIR_BAGS_PIECE_FIRST .. FAIR_BAGS_PIECE_LAST] of Integer = (
    (PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L,  PIECE_I,  PIECE_T),
    (PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L,  PIECE_I,  PIECE_J),
    (PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L,  PIECE_I,  PIECE_Z),
    (PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L,  PIECE_I,  PIECE_O),
    (PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L,  PIECE_I,  PIECE_S),
    (PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L,  PIECE_I,  PIECE_L),
    (PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L,  PIECE_I,  PIECE_I)
  );


const
  SETTINGS_KEY_MAPPING: array [DEVICE_FIRST .. DEVICE_LAST] of String = (
    SETTINGS_KEY_MAPPING_UP,
    SETTINGS_KEY_MAPPING_DOWN,
    SETTINGS_KEY_MAPPING_LEFT,
    SETTINGS_KEY_MAPPING_RIGHT,
    SETTINGS_KEY_MAPPING_SELECT,
    SETTINGS_KEY_MAPPING_START,
    SETTINGS_KEY_MAPPING_B,
    SETTINGS_KEY_MAPPING_A
  );


const
  MESSAGE_ERROR: array [ERROR_FIRST .. ERROR_LAST] of String = (
    'SDL system failed to initialize',
    'SDL audio subsystem failed to initialize',
    'Unable to create SDL window',
    'Unable to create SDL window renderer',
    'Unable to get the SDL version and thus the window handle',
    'Unable to create back buffer texture',
    'Unable to create quit buffer texture',
    'Unable to load sprite %s',
    'Unable to load background %s',
    'Unable to load sound %s'
  );


implementation

end.

