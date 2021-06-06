unit Fairtris.Constants;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Windows;


const
  CLOCK_FRAMERATE_NTSC = 60;
  CLOCK_FRAMERATE_PAL  = 50;


const
  BUFFER_WIDTH  = 256;
  BUFFER_HEIGHT = 240;


const
  CLIENT_RATIO_LANDSCAPE = 4 / 3;
  CLIENT_RATIO_PORTRAIT  = 3 / 4;

  CLIENT_FILL_MULTIPLIER = 0.95;


const
  SCENE_LEGAL       = 0;
  SCENE_MENU        = 1;
  SCENE_PLAY        = 2;
  SCENE_GAME_NORMAL = 3;
  SCENE_GAME_FLASH  = 4;
  SCENE_PAUSE       = 5;
  SCENE_TOP_OUT     = 6;
  SCENE_OPTIONS     = 7;
  SCENE_KEYBOARD    = 8;
  SCENE_CONTROLLER  = 9;
  SCENE_QUIT        = 10;

  SCENE_FIRST = SCENE_LEGAL;
  SCENE_LAST  = SCENE_CONTROLLER;


const
  SPRITE_CHARSET    = 0;
  SPRITE_BRICKS     = 1;
  SPRITE_PIECES     = 2;
  SPRITE_MINIATURES = 3;
  SPRITE_CONTROLLER = 4;

  SPRITE_FIRST = SPRITE_CHARSET;
  SPRITE_LAST  = SPRITE_CONTROLLER;


const
  CHAR_WIDTH  = 8;
  CHAR_HEIGHT = 8;


const
  SOUND_UNKNOWN    = 0;
  SOUND_BLIP       = 1;
  SOUND_START      = 2;
  SOUND_SHIFT      = 3;
  SOUND_SPIN       = 4;
  SOUND_DROP       = 5;
  SOUND_BURN       = 6;
  SOUND_TETRIS     = 7;
  SOUND_TRANSITION = 8;
  SOUND_TOP_OUT    = 9;
  SOUND_PAUSE      = 10;

  SOUND_FIRST = SOUND_UNKNOWN;
  SOUND_LAST  = SOUND_PAUSE;


const
  ITEM_MENU_PLAY    = 0;
  ITEM_MENU_OPTIONS = 1;
  ITEM_MENU_HELP    = 2;
  ITEM_MENU_QUIT    = 3;

  ITEM_MENU_FIRST = ITEM_MENU_PLAY;
  ITEM_MENU_LAST  = ITEM_MENU_QUIT;

const
  ITEM_PLAY_REGION = 0;
  ITEM_PLAY_RNG    = 1;
  ITEM_PLAY_LEVEL  = 2;
  ITEM_PLAY_START  = 3;
  ITEM_PLAY_BACK   = 4;

  ITEM_PLAY_FIRST = ITEM_PLAY_REGION;
  ITEM_PLAY_LAST  = ITEM_PLAY_BACK;

const
  ITEM_PAUSE_RESUME  = 0;
  ITEM_PAUSE_RESTART = 1;
  ITEM_PAUSE_OPTIONS = 2;
  ITEM_PAUSE_BACK    = 3;

  ITEM_PAUSE_FIRST = ITEM_PAUSE_RESUME;
  ITEM_PAUSE_LAST  = ITEM_PAUSE_BACK;

const
  ITEM_TOP_OUT_PLAY = 0;
  ITEM_TOP_OUT_BACK = 1;

  ITEM_TOP_OUT_FIRST = ITEM_TOP_OUT_PLAY;
  ITEM_TOP_OUT_LAST  = ITEM_TOP_OUT_BACK;

  ITEM_TOP_OUT_RESULT_TOTAL_SCORE   = 0;
  ITEM_TOP_OUT_RESULT_TRANSITION    = 1;
  ITEM_TOP_OUT_RESULT_LINES_CLEARED = 2;
  ITEM_TOP_OUT_RESULT_LINES_BURNED  = 3;
  ITEM_TOP_OUT_RESULT_TETRIS_RATE   = 4;

  ITEM_TOP_OUT_RESULT_FIRST = ITEM_TOP_OUT_RESULT_TOTAL_SCORE;
  ITEM_TOP_OUT_RESULT_LAST  = ITEM_TOP_OUT_RESULT_TETRIS_RATE;

const
  ITEM_OPTIONS_INPUT  = 0;
  ITEM_OPTIONS_SET_UP = 1;
  ITEM_OPTIONS_WINDOW = 2;
  ITEM_OPTIONS_THEME  = 3;
  ITEM_OPTIONS_SOUNDS = 4;
  ITEM_OPTIONS_SCROLL = 5;
  ITEM_OPTIONS_BACK   = 6;

  ITEM_OPTIONS_FIRST = ITEM_OPTIONS_INPUT;
  ITEM_OPTIONS_LAST  = ITEM_OPTIONS_BACK;

const
  ITEM_KEYBOARD_CHANGE  = 0;
  ITEM_KEYBOARD_RESTORE = 1;
  ITEM_KEYBOARD_SAVE    = 2;
  ITEM_KEYBOARD_CANCEL  = 3;

  ITEM_KEYBOARD_FIRST = ITEM_KEYBOARD_CHANGE;
  ITEM_KEYBOARD_LAST  = ITEM_KEYBOARD_CANCEL;

const
  ITEM_KEYBOARD_KEY_UP     = 0;
  ITEM_KEYBOARD_KEY_DOWN   = 1;
  ITEM_KEYBOARD_KEY_LEFT   = 2;
  ITEM_KEYBOARD_KEY_RIGHT  = 3;
  ITEM_KEYBOARD_KEY_SELECT = 4;
  ITEM_KEYBOARD_KEY_START  = 5;
  ITEM_KEYBOARD_KEY_B      = 6;
  ITEM_KEYBOARD_KEY_A      = 7;
  ITEM_KEYBOARD_KEY_BACK   = 8;

  ITEM_KEYBOARD_KEY_FIRST = ITEM_KEYBOARD_KEY_UP;
  ITEM_KEYBOARD_KEY_LAST  = ITEM_KEYBOARD_KEY_BACK;

const
  ITEM_KEYBOARD_SCANCODE_FIRST = ITEM_KEYBOARD_KEY_UP;
  ITEM_KEYBOARD_SCANCODE_LAST  = ITEM_KEYBOARD_KEY_A;

const
  ITEM_CONTROLLER_CHANGE  = 0;
  ITEM_CONTROLLER_RESTORE = 1;
  ITEM_CONTROLLER_SAVE    = 2;
  ITEM_CONTROLLER_CANCEL  = 3;

  ITEM_CONTROLLER_FIRST = ITEM_CONTROLLER_CHANGE;
  ITEM_CONTROLLER_LAST  = ITEM_CONTROLLER_CANCEL;

const
  ITEM_CONTROLLER_BUTTON_UP     = 0;
  ITEM_CONTROLLER_BUTTON_DOWN   = 1;
  ITEM_CONTROLLER_BUTTON_LEFT   = 2;
  ITEM_CONTROLLER_BUTTON_RIGHT  = 3;
  ITEM_CONTROLLER_BUTTON_SELECT = 4;
  ITEM_CONTROLLER_BUTTON_START  = 5;
  ITEM_CONTROLLER_BUTTON_B      = 6;
  ITEM_CONTROLLER_BUTTON_A      = 7;
  ITEM_CONTROLLER_BUTTON_BACK   = 8;

  ITEM_CONTROLLER_BUTTON_FIRST = ITEM_CONTROLLER_BUTTON_UP;
  ITEM_CONTROLLER_BUTTON_LAST  = ITEM_CONTROLLER_BUTTON_BACK;

const
  ITEM_CONTROLLER_SCANCODE_FIRST = ITEM_CONTROLLER_BUTTON_UP;
  ITEM_CONTROLLER_SCANCODE_LAST  = ITEM_CONTROLLER_BUTTON_A;


const
  ITEM_X_MARKER = 12;

const
  ITEM_X_MENU_PLAY    = 104;
  ITEM_X_MENU_OPTIONS = 104;
  ITEM_X_MENU_HELP    = 104;
  ITEM_X_MENU_QUIT    = 104;

  ITEM_X_PLAY_REGION = 32;
  ITEM_X_PLAY_RNG    = 32;
  ITEM_X_PLAY_LEVEL  = 32;
  ITEM_X_PLAY_START  = 32;
  ITEM_X_PLAY_BACK   = 32;
  ITEM_X_PLAY_PARAM  = 120;

  ITEM_X_PAUSE_RESUME  = 80;
  ITEM_X_PAUSE_RESTART = 80;
  ITEM_X_PAUSE_OPTIONS = 80;
  ITEM_X_PAUSE_BACK    = 80;

  ITEM_X_TOP_OUT_PLAY = 80;
  ITEM_X_TOP_OUT_BACK = 80;

  ITEM_X_TOP_OUT_RESULT_TOTAL_SCORE   = 216;
  ITEM_X_TOP_OUT_RESULT_TRANSITION    = 216;
  ITEM_X_TOP_OUT_RESULT_LINES_CLEARED = 216;
  ITEM_X_TOP_OUT_RESULT_LINES_BURNED  = 216;
  ITEM_X_TOP_OUT_RESULT_TETRIS_RATE   = 216;

  ITEM_X_OPTIONS_INPUT  = 48;
  ITEM_X_OPTIONS_SET_UP = 48;
  ITEM_X_OPTIONS_WINDOW = 48;
  ITEM_X_OPTIONS_THEME  = 48;
  ITEM_X_OPTIONS_SOUNDS = 48;
  ITEM_X_OPTIONS_SCROLL = 48;
  ITEM_X_OPTIONS_BACK   = 48;
  ITEM_X_OPTIONS_PARAM  = 128;

  ITEM_X_KEYBOARD_CHANGE  = 32;
  ITEM_X_KEYBOARD_RESTORE = 32;
  ITEM_X_KEYBOARD_SAVE    = 32;
  ITEM_X_KEYBOARD_CANCEL  = 32;

  ITEM_X_KEYBOARD_KEY_UP     = 120;
  ITEM_X_KEYBOARD_KEY_DOWN   = 120;
  ITEM_X_KEYBOARD_KEY_LEFT   = 120;
  ITEM_X_KEYBOARD_KEY_RIGHT  = 120;
  ITEM_X_KEYBOARD_KEY_SELECT = 120;
  ITEM_X_KEYBOARD_KEY_START  = 120;
  ITEM_X_KEYBOARD_KEY_B      = 120;
  ITEM_X_KEYBOARD_KEY_A      = 120;
  ITEM_X_KEYBOARD_KEY_BACK   = 120;

  ITEM_X_KEYBOARD_SCANCODE = 184;

  ITEM_X_CONTROLLER_CHANGE  = 32;
  ITEM_X_CONTROLLER_RESTORE = 32;
  ITEM_X_CONTROLLER_SAVE    = 32;
  ITEM_X_CONTROLLER_CANCEL  = 32;

  ITEM_X_CONTROLLER_BUTTON_UP     = 120;
  ITEM_X_CONTROLLER_BUTTON_DOWN   = 120;
  ITEM_X_CONTROLLER_BUTTON_LEFT   = 120;
  ITEM_X_CONTROLLER_BUTTON_RIGHT  = 120;
  ITEM_X_CONTROLLER_BUTTON_SELECT = 120;
  ITEM_X_CONTROLLER_BUTTON_START  = 120;
  ITEM_X_CONTROLLER_BUTTON_B      = 120;
  ITEM_X_CONTROLLER_BUTTON_A      = 120;
  ITEM_X_CONTROLLER_BUTTON_BACK   = 120;

  ITEM_X_CONTROLLER_SCANCODE = 184;


const
  ITEM_Y_MENU_PLAY    = 88;
  ITEM_Y_MENU_OPTIONS = 100;
  ITEM_Y_MENU_HELP    = 120;
  ITEM_Y_MENU_QUIT    = 132;

  ITEM_Y_PLAY_REGION = 56;
  ITEM_Y_PLAY_RNG    = 68;
  ITEM_Y_PLAY_LEVEL  = 80;
  ITEM_Y_PLAY_START  = 100;
  ITEM_Y_PLAY_BACK   = 112;

  ITEM_Y_PAUSE_RESUME  = 88;
  ITEM_Y_PAUSE_RESTART = 100;
  ITEM_Y_PAUSE_OPTIONS = 120;
  ITEM_Y_PAUSE_BACK    = 132;

  ITEM_Y_TOP_OUT_PLAY = 152;
  ITEM_Y_TOP_OUT_BACK = 164;

  ITEM_Y_TOP_OUT_RESULT_TOTAL_SCORE   = 56;
  ITEM_Y_TOP_OUT_RESULT_TRANSITION    = 68;
  ITEM_Y_TOP_OUT_RESULT_LINES_CLEARED = 88;
  ITEM_Y_TOP_OUT_RESULT_LINES_BURNED  = 100;
  ITEM_Y_TOP_OUT_RESULT_TETRIS_RATE   = 120;

  ITEM_Y_OPTIONS_INPUT  = 56;
  ITEM_Y_OPTIONS_SET_UP = 68;
  ITEM_Y_OPTIONS_WINDOW = 88;
  ITEM_Y_OPTIONS_THEME  = 100;
  ITEM_Y_OPTIONS_SOUNDS = 120;
  ITEM_Y_OPTIONS_SCROLL = 132;
  ITEM_Y_OPTIONS_BACK   = 152;

  ITEM_Y_KEYBOARD_CHANGE  = 48;
  ITEM_Y_KEYBOARD_RESTORE = 60;
  ITEM_Y_KEYBOARD_SAVE    = 80;
  ITEM_Y_KEYBOARD_CANCEL  = 92;

  ITEM_Y_KEYBOARD_KEY_UP     = 48;
  ITEM_Y_KEYBOARD_KEY_DOWN   = 60;
  ITEM_Y_KEYBOARD_KEY_LEFT   = 72;
  ITEM_Y_KEYBOARD_KEY_RIGHT  = 84;
  ITEM_Y_KEYBOARD_KEY_SELECT = 104;
  ITEM_Y_KEYBOARD_KEY_START  = 116;
  ITEM_Y_KEYBOARD_KEY_B      = 136;
  ITEM_Y_KEYBOARD_KEY_A      = 148;
  ITEM_Y_KEYBOARD_KEY_BACK   = 168;

  ITEM_Y_CONTROLLER_CHANGE  = 48;
  ITEM_Y_CONTROLLER_RESTORE = 60;
  ITEM_Y_CONTROLLER_SAVE    = 80;
  ITEM_Y_CONTROLLER_CANCEL  = 92;

  ITEM_Y_CONTROLLER_BUTTON_UP     = 48;
  ITEM_Y_CONTROLLER_BUTTON_DOWN   = 60;
  ITEM_Y_CONTROLLER_BUTTON_LEFT   = 72;
  ITEM_Y_CONTROLLER_BUTTON_RIGHT  = 84;
  ITEM_Y_CONTROLLER_BUTTON_SELECT = 104;
  ITEM_Y_CONTROLLER_BUTTON_START  = 116;
  ITEM_Y_CONTROLLER_BUTTON_B      = 136;
  ITEM_Y_CONTROLLER_BUTTON_A      = 148;
  ITEM_Y_CONTROLLER_BUTTON_BACK   = 168;


const
  ITEM_TEXT_MARKER = '>';

const
  ITEM_TEXT_MENU_PLAY    = 'PLAY';
  ITEM_TEXT_MENU_OPTIONS = 'OPTIONS';
  ITEM_TEXT_MENU_HELP    = 'HELP';
  ITEM_TEXT_MENU_QUIT    = 'QUIT';

  ITEM_TEXT_PLAY_REGION = 'REGION';
    ITEM_TEXT_PLAY_REGION_NTSC          = 'NTSC';
    ITEM_TEXT_PLAY_REGION_NTSC_EXTENDED = 'NTSC EXTENDED';
    ITEM_TEXT_PLAY_REGION_PAL           = 'PAL';
    ITEM_TEXT_PLAY_REGION_PAL_EXTENDED  = 'PAL EXTENDED ';
    ITEM_TEXT_PLAY_REGION_EUR           = 'EUR';
    ITEM_TEXT_PLAY_REGION_EUR_EXTENDED  = 'EUR EXTENDED ';
  ITEM_TEXT_PLAY_RNG = 'RNG TYPE';
    ITEM_TEXT_PLAY_RNG_7_BAG   = '7-BAG';
    ITEM_TEXT_PLAY_RNG_FAIR    = 'FAIR';
    ITEM_TEXT_PLAY_RNG_CLASSIC = 'CLASSIC';
    ITEM_TEXT_PLAY_RNG_RANDOM  = 'RANDOM';
  ITEM_TEXT_PLAY_LEVEL = 'LEVEL';
  ITEM_TEXT_PLAY_START = 'START';
  ITEM_TEXT_PLAY_BACK  = 'BACK';

  ITEM_TEXT_PAUSE_RESUME  = 'RESUME';
  ITEM_TEXT_PAUSE_RESTART = 'RESTART';
  ITEM_TEXT_PAUSE_OPTIONS = 'OPTIONS';
  ITEM_TEXT_PAUSE_BACK    = 'BACK TO MENU';

  ITEM_TEXT_TOP_OUT_PLAY = 'PLAY AGAIN';
  ITEM_TEXT_TOP_OUT_BACK = 'BACK TO MENU';

  ITEM_TEXT_OPTIONS_INPUT = 'INPUT';
    ITEM_TEXT_OPTIONS_INPUT_KEYBOARD   = 'KEYBOARD';
    ITEM_TEXT_OPTIONS_INPUT_CONTROLLER = 'CONTROLLER';
  ITEM_TEXT_OPTIONS_SET_UP = 'SET UP';
  ITEM_TEXT_OPTIONS_WINDOW = 'WINDOW';
    ITEM_TEXT_OPTIONS_WINDOW_NATIVE     = 'NATIVE';
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_2X    = 'ZOOM 2X';
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_3X    = 'ZOOM 3X';
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_4X    = 'ZOOM 4X';
    ITEM_TEXT_OPTIONS_WINDOW_FULLSCREEN = 'FULLSCREEN';
  ITEM_TEXT_OPTIONS_THEME = 'THEME';
    ITEM_TEXT_OPTIONS_THEME_MODERN  = 'MODERN';
    ITEM_TEXT_OPTIONS_THEME_CLASSIC = 'CLASSIC';
  ITEM_TEXT_OPTIONS_SOUNDS = 'SOUNDS';
    ITEM_TEXT_OPTIONS_SOUNDS_ENABLED  = 'ENABLED';
    ITEM_TEXT_OPTIONS_SOUNDS_DISABLED = 'DISABLED';
  ITEM_TEXT_OPTIONS_SCROLL = 'SCROLL';
    ITEM_TEXT_OPTIONS_SCROLL_ENABLED  = 'ENABLED';
    ITEM_TEXT_OPTIONS_SCROLL_DISABLED = 'DISABLED';
  ITEM_TEXT_OPTIONS_BACK = 'BACK';

  ITEM_TEXT_KEYBOARD_CHANGE = 'CHANGE';
    ITEM_TEXT_KEYBOARD_KEY_UP     = 'UP';
    ITEM_TEXT_KEYBOARD_KEY_DOWN   = 'DOWN';
    ITEM_TEXT_KEYBOARD_KEY_LEFT   = 'LEFT';
    ITEM_TEXT_KEYBOARD_KEY_RIGHT  = 'RIGHT';
    ITEM_TEXT_KEYBOARD_KEY_SELECT = 'SELECT';
    ITEM_TEXT_KEYBOARD_KEY_START  = 'START';
    ITEM_TEXT_KEYBOARD_KEY_B      = 'B';
    ITEM_TEXT_KEYBOARD_KEY_A      = 'A';
    ITEM_TEXT_KEYBOARD_KEY_BACK   = 'BACK';
  ITEM_TEXT_KEYBOARD_RESTORE = 'RESTORE';
  ITEM_TEXT_KEYBOARD_SAVE    = 'SAVE';
  ITEM_TEXT_KEYBOARD_CANCEL  = 'CANCEL';

  ITEM_TEXT_CONTROLLER_CHANGE = 'CHANGE';
    ITEM_TEXT_CONTROLLER_BUTTON_UP     = 'UP';
    ITEM_TEXT_CONTROLLER_BUTTON_DOWN   = 'DOWN';
    ITEM_TEXT_CONTROLLER_BUTTON_LEFT   = 'LEFT';
    ITEM_TEXT_CONTROLLER_BUTTON_RIGHT  = 'RIGHT';
    ITEM_TEXT_CONTROLLER_BUTTON_SELECT = 'SELECT';
    ITEM_TEXT_CONTROLLER_BUTTON_START  = 'START';
    ITEM_TEXT_CONTROLLER_BUTTON_B      = 'B';
    ITEM_TEXT_CONTROLLER_BUTTON_A      = 'A';
    ITEM_TEXT_CONTROLLER_BUTTON_BACK   = 'BACK';
  ITEM_TEXT_CONTROLLER_RESTORE = 'RESTORE';
  ITEM_TEXT_CONTROLLER_SAVE    = 'SAVE';
  ITEM_TEXT_CONTROLLER_CANCEL  = 'CANCEL';


const
  REGION_NTSC          = 0;
  REGION_NTSC_EXTENDED = 1;
  REGION_PAL           = 2;
  REGION_PAL_EXTENDED  = 3;
  REGION_EUR           = 4;
  REGION_EUR_EXTENDED  = 5;

  REGION_FIRST = REGION_NTSC;
  REGION_LAST  = REGION_EUR_EXTENDED;


const
  RNG_7_BAG   = 0;
  RNG_FAIR    = 1;
  RNG_CLASSIC = 2;
  RNG_RANDOM  = 3;

  RNG_FIRST = RNG_7_BAG;
  RNG_LAST  = RNG_RANDOM;


const
  LEVEL_FIRST_NTSC = 0;
  LEVEL_FIRST_PAL  = 0;

const
  LEVEL_LAST_NTSC = 29;
  LEVEL_LAST_PAL  = 19;


const
  INPUT_KEYBOARD   = 0;
  INPUT_CONTROLLER = 1;

  INPUT_FIRST = INPUT_KEYBOARD;
  INPUT_LAST  = INPUT_CONTROLLER;


const
  DEVICE_UP     = 0;
  DEVICE_DOWN   = 1;
  DEVICE_LEFT   = 2;
  DEVICE_RIGHT  = 3;
  DEVICE_SELECT = 4;
  DEVICE_START  = 5;
  DEVICE_B      = 6;
  DEVICE_A      = 7;


const
  KEYBOARD_KEY_UP     = DEVICE_UP;
  KEYBOARD_KEY_DOWN   = DEVICE_DOWN;
  KEYBOARD_KEY_LEFT   = DEVICE_LEFT;
  KEYBOARD_KEY_RIGHT  = DEVICE_RIGHT;
  KEYBOARD_KEY_SELECT = DEVICE_SELECT;
  KEYBOARD_KEY_START  = DEVICE_START;
  KEYBOARD_KEY_B      = DEVICE_B;
  KEYBOARD_KEY_A      = DEVICE_A;

  KEYBOARD_KEY_FIRST = KEYBOARD_KEY_UP;
  KEYBOARD_KEY_LAST  = KEYBOARD_KEY_A;

  KEYBOARD_KEY_SCANCODE_NOT_ASSIGNED    = 0;
  KEYBOARD_KEY_SCANCODE_HELP_UNDERSTAND = VK_F1;
  KEYBOARD_KEY_SCANCODE_HELP_CONTROL    = VK_F2;
  KEYBOARD_KEY_SCANCODE_CLEAR_MAPPING   = VK_BACK;


const
  CONTROLLER_ARROWS_COUNT  = 4;
  CONTROLLER_BUTTONS_COUNT = 32;

  CONTROLLER_ARROWS_OFFSET = CONTROLLER_BUTTONS_COUNT;

  CONTROLLER_BUTTON_UP     = DEVICE_UP;
  CONTROLLER_BUTTON_DOWN   = DEVICE_DOWN;
  CONTROLLER_BUTTON_LEFT   = DEVICE_LEFT;
  CONTROLLER_BUTTON_RIGHT  = DEVICE_RIGHT;
  CONTROLLER_BUTTON_SELECT = DEVICE_SELECT;
  CONTROLLER_BUTTON_START  = DEVICE_START;
  CONTROLLER_BUTTON_B      = DEVICE_B;
  CONTROLLER_BUTTON_A      = DEVICE_A;

  CONTROLLER_BUTTON_FIRST = CONTROLLER_BUTTON_UP;
  CONTROLLER_BUTTON_LAST  = CONTROLLER_BUTTON_A;


const
  KEYBOARD_SCANCODE_KEY_FIRST = 0;
  KEYBOARD_SCANCODE_KEY_LAST  = 255;

const
  CONTROLLER_SCANCODE_BUTTON_0  = 0;
  CONTROLLER_SCANCODE_BUTTON_1  = 1;
  CONTROLLER_SCANCODE_BUTTON_2  = 2;
  CONTROLLER_SCANCODE_BUTTON_3  = 3;
  CONTROLLER_SCANCODE_BUTTON_4  = 4;
  CONTROLLER_SCANCODE_BUTTON_5  = 5;
  CONTROLLER_SCANCODE_BUTTON_6  = 6;
  CONTROLLER_SCANCODE_BUTTON_7  = 7;
  CONTROLLER_SCANCODE_BUTTON_8  = 8;
  CONTROLLER_SCANCODE_BUTTON_9  = 9;
  CONTROLLER_SCANCODE_BUTTON_10 = 10;
  CONTROLLER_SCANCODE_BUTTON_11 = 11;
  CONTROLLER_SCANCODE_BUTTON_12 = 12;
  CONTROLLER_SCANCODE_BUTTON_13 = 13;
  CONTROLLER_SCANCODE_BUTTON_14 = 14;
  CONTROLLER_SCANCODE_BUTTON_15 = 15;
  CONTROLLER_SCANCODE_BUTTON_16 = 16;
  CONTROLLER_SCANCODE_BUTTON_17 = 17;
  CONTROLLER_SCANCODE_BUTTON_18 = 18;
  CONTROLLER_SCANCODE_BUTTON_19 = 19;
  CONTROLLER_SCANCODE_BUTTON_20 = 20;
  CONTROLLER_SCANCODE_BUTTON_21 = 21;
  CONTROLLER_SCANCODE_BUTTON_22 = 22;
  CONTROLLER_SCANCODE_BUTTON_23 = 23;
  CONTROLLER_SCANCODE_BUTTON_24 = 24;
  CONTROLLER_SCANCODE_BUTTON_25 = 25;
  CONTROLLER_SCANCODE_BUTTON_26 = 26;
  CONTROLLER_SCANCODE_BUTTON_27 = 27;
  CONTROLLER_SCANCODE_BUTTON_28 = 28;
  CONTROLLER_SCANCODE_BUTTON_29 = 29;
  CONTROLLER_SCANCODE_BUTTON_30 = 30;
  CONTROLLER_SCANCODE_BUTTON_31 = 31;

  CONTROLLER_SCANCODE_ARROW_UP    = CONTROLLER_ARROWS_OFFSET + 0;
  CONTROLLER_SCANCODE_ARROW_DOWN  = CONTROLLER_ARROWS_OFFSET + 1;
  CONTROLLER_SCANCODE_ARROW_LEFT  = CONTROLLER_ARROWS_OFFSET + 2;
  CONTROLLER_SCANCODE_ARROW_RIGHT = CONTROLLER_ARROWS_OFFSET + 3;

  CONTROLLER_SCANCODE_FIRST = CONTROLLER_SCANCODE_BUTTON_0;
  CONTROLLER_SCANCODE_LAST  = CONTROLLER_SCANCODE_ARROW_RIGHT;


const
  WINDOW_NATIVE     = 0;
  WINDOW_ZOOM_2X    = 1;
  WINDOW_ZOOM_3X    = 2;
  WINDOW_ZOOM_4X    = 3;
  WINDOW_FULLSCREEN = 4;

  WINDOW_FIRST = WINDOW_NATIVE;
  WINDOW_LAST  = WINDOW_FULLSCREEN;


const
  THEME_MODERN  = 0;
  THEME_CLASSIC = 1;

  THEME_FIRST = THEME_MODERN;
  THEME_LAST  = THEME_CLASSIC;


const
  SOUNDS_ENABLED  = 0;
  SOUNDS_DISABLED = 1;

  SOUNDS_FIRST = SOUNDS_ENABLED;
  SOUNDS_LAST  = SOUNDS_DISABLED;


const
  SCROLL_ENABLED  = 0;
  SCROLL_DISABLED = 1;

  SCROLL_FIRST = SCROLL_ENABLED;
  SCROLL_LAST  = SCROLL_DISABLED;


const
  PIECE_UNKNOWN = 0;
  PIECE_T       = 1;
  PIECE_J       = 2;
  PIECE_Z       = 3;
  PIECE_O       = 4;
  PIECE_S       = 5;
  PIECE_L       = 6;
  PIECE_I       = 7;


const
  BRICK_UNKNOWN = 0;
  BRICK_EMPTY   = 0;
  BRICK_COLOR_A = 1;
  BRICK_COLOR_B = 2;
  BRICK_COLOR_C = 3;


const
  COLOR_WINDOW = $000A0A0A;
  COLOR_WHITE  = $00FAFAFA;
  COLOR_GRAY   = $007F7F7F;
  COLOR_DARK   = $003F3F3F;
  COLOR_ORANGE = $003898FC;


const
  ALIGN_LEFT  = 0;
  ALIGN_RIGHT = 1;


implementation

end.

