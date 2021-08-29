unit Fairtris.Constants;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2;


const
  CLOCK_FRAMERATE_NTSC = 60;
  CLOCK_FRAMERATE_PAL  = 50;

  CLOCK_FRAMERATE_DEFAULT = CLOCK_FRAMERATE_NTSC;


const
  MONITOR_DEFAULT = 0;


const
  BUFFER_WIDTH  = 256;
  BUFFER_HEIGHT = 240;

  BUFFER_CLIPPING = 8;


const
  CLIENT_RATIO_LANDSCAPE = 4 / 3;
  CLIENT_RATIO_PORTRAIT  = 3 / 4;


const
  WINDOW_RATIO = 8 / 7;


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
  SCENE_STOP        = 11;

  SCENE_FIRST = SCENE_LEGAL;
  SCENE_LAST  = SCENE_QUIT;


const
  STATE_PIECE_CONTROL    = 0;
  STATE_PIECE_LOCK       = 1;
  STATE_PIECE_SPAWN      = 2;
  STATE_LINES_CHECK      = 3;
  STATE_LINES_CLEAR      = 4;
  STATE_STACK_LOWER      = 5;
  STATE_UPDATE_COUNTERS  = 6;
  STATE_UPDATE_TOP_OUT   = 7;


const
  SOUND_REGION_NTSC = 0;
  SOUND_REGION_PAL  = 1;

  SOUND_REGION_FIRST = SOUND_REGION_NTSC;
  SOUND_REGION_LAST  = SOUND_REGION_PAL;


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
  SOUND_GLASS      = 11;

  SOUND_FIRST = SOUND_BLIP;
  SOUND_LAST  = SOUND_GLASS;

  SOUND_CHANNELS_COUNT = 6;


const
  DURATION_HANG_LEGAL = 5;
  DURATION_HANG_QUIT  = 2;


const
  ITEM_NEXT = +1;
  ITEM_PREV = -1;


const
  ITEM_MENU_PLAY    = 0;
  ITEM_MENU_OPTIONS = 1;
  ITEM_MENU_HELP    = 2;
  ITEM_MENU_QUIT    = 3;

  ITEM_MENU_FIRST = ITEM_MENU_PLAY;
  ITEM_MENU_LAST  = ITEM_MENU_QUIT;

  ITEM_MENU_COUNT = ITEM_MENU_LAST + 1;

const
  ITEM_PLAY_REGION = 0;
  ITEM_PLAY_RNG    = 1;
  ITEM_PLAY_LEVEL  = 2;
  ITEM_PLAY_START  = 3;
  ITEM_PLAY_BACK   = 4;

  ITEM_PLAY_FIRST = ITEM_PLAY_REGION;
  ITEM_PLAY_LAST  = ITEM_PLAY_BACK;

  ITEM_PLAY_COUNT = ITEM_PLAY_LAST + 1;

  ITEM_PLAY_BEST_SCORES_FIRST = 0;
  ITEM_PLAY_BEST_SCORES_LAST  = 2;

  ITEM_PLAY_BEST_SCORES_COUNT = ITEM_PLAY_BEST_SCORES_LAST + 1;

const
  ITEM_PAUSE_RESUME  = 0;
  ITEM_PAUSE_RESTART = 1;
  ITEM_PAUSE_OPTIONS = 2;
  ITEM_PAUSE_BACK    = 3;

  ITEM_PAUSE_FIRST = ITEM_PAUSE_RESUME;
  ITEM_PAUSE_LAST  = ITEM_PAUSE_BACK;

  ITEM_PAUSE_COUNT = ITEM_PAUSE_LAST + 1;

const
  ITEM_TOP_OUT_PLAY = 0;
  ITEM_TOP_OUT_BACK = 1;

  ITEM_TOP_OUT_FIRST = ITEM_TOP_OUT_PLAY;
  ITEM_TOP_OUT_LAST  = ITEM_TOP_OUT_BACK;

  ITEM_TOP_OUT_COUNT = ITEM_TOP_OUT_LAST + 1;

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

  ITEM_OPTIONS_COUNT = ITEM_OPTIONS_LAST + 1;

const
  ITEM_KEYBOARD_CHANGE  = 0;
  ITEM_KEYBOARD_RESTORE = 1;
  ITEM_KEYBOARD_SAVE    = 2;
  ITEM_KEYBOARD_CANCEL  = 3;

  ITEM_KEYBOARD_FIRST = ITEM_KEYBOARD_CHANGE;
  ITEM_KEYBOARD_LAST  = ITEM_KEYBOARD_CANCEL;

  ITEM_KEYBOARD_COUNT = ITEM_KEYBOARD_LAST + 1;

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

  ITEM_KEYBOARD_KEY_COUNT = ITEM_KEYBOARD_KEY_LAST + 1;

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

  ITEM_CONTROLLER_COUNT = ITEM_CONTROLLER_LAST + 1;

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

  ITEM_CONTROLLER_BUTTON_COUNT = ITEM_CONTROLLER_BUTTON_LAST + 1;

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

  ITEM_X_PLAY_REGION     = 32;
  ITEM_X_PLAY_RNG        = 32;
  ITEM_X_PLAY_LEVEL      = 32;
  ITEM_X_PLAY_START      = 32;
  ITEM_X_PLAY_BACK       = 32;
  ITEM_X_PLAY_PARAM      = 120;
  ITEM_X_PLAY_BEST_SCORE = 32;

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

  ITEM_Y_PLAY_BEST_SCORES_MODERN  = 140;
  ITEM_Y_PLAY_BEST_SCORES_CLASSIC = 142;

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

  ITEM_TEXT_PLAY_REGION_TITLE = 'REGION';
    ITEM_TEXT_PLAY_REGION_NTSC          = 'NTSC';
    ITEM_TEXT_PLAY_REGION_NTSC_EXTENDED = 'NTSC EXTENDED';
    ITEM_TEXT_PLAY_REGION_JPN           = 'JPN';
    ITEM_TEXT_PLAY_REGION_JPN_EXTENDED  = 'JPN EXTENDED';
    ITEM_TEXT_PLAY_REGION_PAL           = 'PAL';
    ITEM_TEXT_PLAY_REGION_PAL_EXTENDED  = 'PAL EXTENDED ';
    ITEM_TEXT_PLAY_REGION_EUR           = 'EUR';
    ITEM_TEXT_PLAY_REGION_EUR_EXTENDED  = 'EUR EXTENDED ';
  ITEM_TEXT_PLAY_RNG_TITLE = 'RNG TYPE';
    ITEM_TEXT_PLAY_RNG_7_BAG   = '7-BAG';
    ITEM_TEXT_PLAY_RNG_FAIR    = 'FAIR';
    ITEM_TEXT_PLAY_RNG_CLASSIC = 'CLASSIC';
    ITEM_TEXT_PLAY_RNG_UNFAIR  = 'UNFAIR';
  ITEM_TEXT_PLAY_LEVEL = 'LEVEL';
  ITEM_TEXT_PLAY_START = 'START';
  ITEM_TEXT_PLAY_BACK  = 'BACK';

  ITEM_TEXT_PAUSE_RESUME  = 'RESUME';
  ITEM_TEXT_PAUSE_RESTART = 'RESTART';
  ITEM_TEXT_PAUSE_OPTIONS = 'OPTIONS';
  ITEM_TEXT_PAUSE_BACK    = 'BACK TO MENU';

  ITEM_TEXT_TOP_OUT_PLAY = 'PLAY AGAIN';
  ITEM_TEXT_TOP_OUT_BACK = 'BACK TO MENU';

  ITEM_TEXT_OPTIONS_INPUT_TITLE = 'INPUT';
    ITEM_TEXT_OPTIONS_INPUT_KEYBOARD   = 'KEYBOARD';
    ITEM_TEXT_OPTIONS_INPUT_CONTROLLER = 'CONTROLLER';
  ITEM_TEXT_OPTIONS_SET_UP = 'SET UP';
  ITEM_TEXT_OPTIONS_WINDOW_TITLE = 'WINDOW';
    ITEM_TEXT_OPTIONS_WINDOW_NATIVE     = 'NATIVE';
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_2X    = 'ZOOM 2X';
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_3X    = 'ZOOM 3X';
    ITEM_TEXT_OPTIONS_WINDOW_ZOOM_4X    = 'ZOOM 4X';
    ITEM_TEXT_OPTIONS_WINDOW_FULLSCREEN = 'FULLSCREEN';
    ITEM_TEXT_OPTIONS_WINDOW_VIDEO_MODE = 'VIDEO MODE';
  ITEM_TEXT_OPTIONS_THEME_TITLE = 'THEME';
    ITEM_TEXT_OPTIONS_THEME_MODERN  = 'MODERN';
    ITEM_TEXT_OPTIONS_THEME_CLASSIC = 'CLASSIC';
  ITEM_TEXT_OPTIONS_SOUNDS_TITLE = 'SOUNDS';
    ITEM_TEXT_OPTIONS_SOUNDS_ENABLED  = 'ENABLED';
    ITEM_TEXT_OPTIONS_SOUNDS_DISABLED = 'DISABLED';
  ITEM_TEXT_OPTIONS_SCROLL_TITLE = 'SCROLL';
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
  REGION_JPN           = 2;
  REGION_JPN_EXTENDED  = 3;
  REGION_PAL           = 4;
  REGION_PAL_EXTENDED  = 5;
  REGION_EUR           = 6;
  REGION_EUR_EXTENDED  = 7;

  REGION_FIRST = REGION_NTSC;
  REGION_LAST  = REGION_EUR_EXTENDED;

  REGION_COUNT   = REGION_LAST + 1;
  REGION_DEFAULT = REGION_NTSC;


const
  RNG_7_BAG   = 0;
  RNG_FAIR    = 1;
  RNG_CLASSIC = 2;
  RNG_UNFAIR  = 3;

  RNG_FIRST = RNG_7_BAG;
  RNG_LAST  = RNG_UNFAIR;

  RNG_COUNT   = RNG_LAST + 1;
  RNG_DEFAULT = RNG_7_BAG;


const
  LEVEL_FIRST = 0;
  LEVEL_LAST  = 29;

  LEVEL_FIRST_NTSC = 0;
  LEVEL_FIRST_PAL  = 0;

  LEVEL_LAST_NTSC = 29;
  LEVEL_LAST_PAL  = 19;

  LEVEL_COUNT_NTSC = LEVEL_LAST_NTSC + 1;
  LEVEL_COUNT_PAL  = LEVEL_LAST_PAL  + 1;

  LEVEL_DEFAULT = LEVEL_FIRST_NTSC;


const
  BEST_SCORES_FIRST = 0;
  BEST_SCORES_LAST  = 2;

  BEST_SCORES_COUNT = BEST_SCORES_LAST + 1;

  BEST_SCORES_SPACING_Y = 12;


const
  INPUT_KEYBOARD   = 0;
  INPUT_CONTROLLER = 1;

  INPUT_FIRST = INPUT_KEYBOARD;
  INPUT_LAST  = INPUT_CONTROLLER;

  INPUT_COUNT   = INPUT_LAST + 1;
  INPUT_DEFAULT = INPUT_KEYBOARD;


const
  DEVICE_UP     = 0;
  DEVICE_DOWN   = 1;
  DEVICE_LEFT   = 2;
  DEVICE_RIGHT  = 3;
  DEVICE_SELECT = 4;
  DEVICE_START  = 5;
  DEVICE_B      = 6;
  DEVICE_A      = 7;

  DEVICE_FIRST = DEVICE_UP;
  DEVICE_LAST  = DEVICE_A;


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

  KEYBOARD_SCANCODE_KEY_HELP_UNDERSTAND = SDL_SCANCODE_F1;
  KEYBOARD_SCANCODE_KEY_HELP_CONTROL    = SDL_SCANCODE_F2;
  KEYBOARD_SCANCODE_KEY_TOGGLE_CLIP     = SDL_SCANCODE_F10;
  KEYBOARD_SCANCODE_KEY_TOGGLE_VIDEO    = SDL_SCANCODE_F11;
  KEYBOARD_SCANCODE_KEY_NOT_MAPPED      = SDL_SCANCODE_UNKNOWN;
  KEYBOARD_SCANCODE_KEY_CLEAR_MAPPING   = SDL_SCANCODE_BACKSPACE;

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

  CONTROLLER_SCANCODE_BUTTON_FIRST = CONTROLLER_SCANCODE_BUTTON_0;
  CONTROLLER_SCANCODE_BUTTON_LAST  = CONTROLLER_SCANCODE_ARROW_RIGHT;

  CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED = CONTROLLER_SCANCODE_BUTTON_LAST + 1;


const
  WINDOW_NATIVE     = 0;
  WINDOW_ZOOM_2X    = 1;
  WINDOW_ZOOM_3X    = 2;
  WINDOW_ZOOM_4X    = 3;
  WINDOW_FULLSCREEN = 4;

  WINDOW_FIRST = WINDOW_NATIVE;
  WINDOW_LAST  = WINDOW_FULLSCREEN;

  WINDOW_COUNT   = WINDOW_LAST + 1;
  WINDOW_DEFAULT = WINDOW_FULLSCREEN;


const
  THEME_MODERN  = 0;
  THEME_CLASSIC = 1;

  THEME_FIRST = THEME_MODERN;
  THEME_LAST  = THEME_CLASSIC;

  THEME_COUNT   = THEME_LAST + 1;
  THEME_DEFAULT = THEME_MODERN;


const
  SOUNDS_ENABLED  = 0;
  SOUNDS_DISABLED = 1;

  SOUNDS_FIRST = SOUNDS_ENABLED;
  SOUNDS_LAST  = SOUNDS_DISABLED;

  SOUNDS_COUNT   = SOUNDS_LAST + 1;
  SOUNDS_DEFAULT = SOUNDS_ENABLED;


const
  SCROLL_ENABLED  = 0;
  SCROLL_DISABLED = 1;

  SCROLL_FIRST = SCROLL_ENABLED;
  SCROLL_LAST  = SCROLL_DISABLED;

  SCROLL_COUNT   = SCROLL_LAST + 1;
  SCROLL_DEFAULT = SCROLL_ENABLED;


const
  PIECE_UNKNOWN = 0;
  PIECE_T       = 1;
  PIECE_J       = 2;
  PIECE_Z       = 3;
  PIECE_O       = 4;
  PIECE_S       = 5;
  PIECE_L       = 6;
  PIECE_I       = 7;

  PIECE_FIRST = PIECE_T;
  PIECE_LAST  = PIECE_I;

  PIECE_WIDTH  = 31;
  PIECE_HEIGHT = 15;


const
  PIECE_ORIENTATION_DOWN  = 0;
  PIECE_ORIENTATION_LEFT  = 1;
  PIECE_ORIENTATION_UP    = 2;
  PIECE_ORIENTATION_RIGHT = 3;

  PIECE_ORIENTATION_FIRST = PIECE_ORIENTATION_DOWN;
  PIECE_ORIENTATION_LAST  = PIECE_ORIENTATION_RIGHT;

  PIECE_ORIENTATION_COUNT = PIECE_ORIENTATION_LAST + 1;
  PIECE_ORIENTATION_SPAWN = PIECE_ORIENTATION_DOWN;


const
  PIECE_SPAWN_X = 5;
  PIECE_SPAWN_Y = 0;


const
  PIECE_SHIFT_LEFT  = -1;
  PIECE_SHIFT_RIGHT = +1;


const
  PIECE_ROTATE_COUNTERCLOCKWISE = -1;
  PIECE_ROTATE_CLOCKWISE        = +1;


const
  LINES_UNKNOWN  = 0;
  LINES_SINGLES  = 1;
  LINES_DOUBLES  = 2;
  LINES_TRIPLES  = 3;
  LINES_TETRISES = 4;

  LINES_FIRST = LINES_SINGLES;
  LINES_LAST  = LINES_TETRISES;


const
  GRAVITY_FIRST = LEVEL_FIRST;
  GRAVITY_LAST  = LEVEL_LAST;


const
  GAIN_SECONDS_VISIBLE = 3;


const
  FAIR_BAGS_FIRST = 0;
  FAIR_BAGS_LAST  = 6;

  FAIR_BAGS_COUNT = FAIR_BAGS_LAST + 1;


const
  FAIR_BAGS_PIECE_FIRST = 0;
  FAIR_BAGS_PIECE_LAST  = 7;

  FAIR_BAGS_PIECE_COUNT = FAIR_BAGS_PIECE_LAST + 1;


const
  BURNED_X = 72;
  BURNED_Y = 82;


const
  TETRISES_X = 72;
  TETRISES_Y = 106;


const
  GAIN_X = 72;
  GAIN_Y = 138;


const
  MINIATURE_UNKNOWN = PIECE_UNKNOWN;
  MINIATURE_T       = PIECE_T;
  MINIATURE_J       = PIECE_J;
  MINIATURE_Z       = PIECE_Z;
  MINIATURE_O       = PIECE_O;
  MINIATURE_S       = PIECE_S;
  MINIATURE_L       = PIECE_L;
  MINIATURE_I       = PIECE_I;

  MINIATURE_FIRST = PIECE_FIRST;
  MINIATURE_LAST  = PIECE_LAST;

  MINIATURE_WIDTH  = 23;
  MINIATURE_HEIGHT = 11;

const
  MINIATURE_X_T = 24;
  MINIATURE_X_J = 24;
  MINIATURE_X_Z = 24;
  MINIATURE_X_O = 24;
  MINIATURE_X_S = 24;
  MINIATURE_X_L = 24;
  MINIATURE_X_I = 24;

  MINIATURE_Y_T = 93;
  MINIATURE_Y_J = 108;
  MINIATURE_Y_Z = 125;
  MINIATURE_Y_O = 141;
  MINIATURE_Y_S = 157;
  MINIATURE_Y_L = 172;
  MINIATURE_Y_I = 189;


const
  STATISTICS_UNKNOWN = MINIATURE_UNKNOWN;
  STATISTICS_T       = MINIATURE_T;
  STATISTICS_J       = MINIATURE_J;
  STATISTICS_Z       = MINIATURE_Z;
  STATISTICS_O       = MINIATURE_O;
  STATISTICS_S       = MINIATURE_S;
  STATISTICS_L       = MINIATURE_L;
  STATISTICS_I       = MINIATURE_I;

  STATISTICS_FIRST = MINIATURE_FIRST;
  STATISTICS_LAST  = MINIATURE_LAST;

const
  STATISTIC_X_T = 48;
  STATISTIC_X_J = 48;
  STATISTIC_X_Z = 48;
  STATISTIC_X_O = 48;
  STATISTIC_X_S = 48;
  STATISTIC_X_L = 48;
  STATISTIC_X_I = 48;

  STATISTIC_Y_T = 96;
  STATISTIC_Y_J = 112;
  STATISTIC_Y_Z = 128;
  STATISTIC_Y_O = 144;
  STATISTIC_Y_S = 160;
  STATISTIC_Y_L = 176;
  STATISTIC_Y_I = 192;


const
  CONTROLLER_X = 15;
  CONTROLLER_Y = 176;


const
  BRICK_UNKNOWN = 0;
  BRICK_EMPTY   = 0;
  BRICK_A       = 1;
  BRICK_B       = 2;
  BRICK_C       = 3;

  BRICK_WIDTH  = 7;
  BRICK_HEIGHT = 7;

  BRICK_SPACING_X = 1;
  BRICK_SPACING_Y = 1;

  BRICK_CELL_WIDTH  = BRICK_WIDTH + BRICK_SPACING_X;
  BRICK_CELL_HEIGHT = BRICK_HEIGHT + BRICK_SPACING_Y;


const
  COLOR_WINDOW = $00000000;
  COLOR_WHITE  = $00FAFAFA;
  COLOR_GRAY   = $007F7F7F;
  COLOR_DARK   = $003F3F3F;
  COLOR_ORANGE = $003898FC;
  COLOR_RED    = $000028D8;


const
  ALIGN_LEFT  = 0;
  ALIGN_RIGHT = 1;


const
  SETTINGS_FILENAME = 'settings.ini';

const
  SETTINGS_SECTION_VIDEO      = 'VIDEO';
  SETTINGS_SECTION_GENERAL    = 'GENERAL';
  SETTINGS_SECTION_KEYBOARD   = 'KEYBOARD';
  SETTINGS_SECTION_CONTROLLER = 'CONTROLLER';

const
  SETTINGS_KEY_VIDEO_ENABLED = 'ENABLED';
  SETTINGS_KEY_VIDEO_WIDTH   = 'WIDTH';
  SETTINGS_KEY_VIDEO_HEIGHT  = 'HEIGHT';

  SETTINGS_KEY_GENERAL_DEFLORED = 'DEFLORED';
  SETTINGS_KEY_GENERAL_MONITOR  = 'MONITOR';
  SETTINGS_KEY_GENERAL_LEFT     = 'LEFT';
  SETTINGS_KEY_GENERAL_TOP      = 'TOP';

  SETTINGS_KEY_GENERAL_INPUT  = 'INPUT';
  SETTINGS_KEY_GENERAL_WINDOW = 'WINDOW';
  SETTINGS_KEY_GENERAL_THEME  = 'THEME';
  SETTINGS_KEY_GENERAL_SOUNDS = 'SOUNDS';
  SETTINGS_KEY_GENERAL_SCROLL = 'SCROLL';

  SETTINGS_KEY_GENERAL_REGION = 'REGION';
  SETTINGS_KEY_GENERAL_RNG    = 'RNG';
  SETTINGS_KEY_GENERAL_LEVEL  = 'LEVEL';

  SETTINGS_KEY_MAPPING_UP     = 'UP';
  SETTINGS_KEY_MAPPING_DOWN   = 'DOWN';
  SETTINGS_KEY_MAPPING_LEFT   = 'LEFT';
  SETTINGS_KEY_MAPPING_RIGHT  = 'RIGHT';
  SETTINGS_KEY_MAPPING_SELECT = 'SELECT';
  SETTINGS_KEY_MAPPING_START  = 'START';
  SETTINGS_KEY_MAPPING_B      = 'B';
  SETTINGS_KEY_MAPPING_A      = 'A';

const
  SETTINGS_VALUE_VIDEO_ENABLED = False;
  SETTINGS_VALUE_VIDEO_WIDTH   = 640;
  SETTINGS_VALUE_VIDEO_HEIGHT  = 480;

  SETTINGS_VALUE_GENERAL_DEFLORED = True;
  SETTINGS_VALUE_GENERAL_MONITOR  = MONITOR_DEFAULT;
  SETTINGS_VALUE_GENERAL_LEFT     = 0;
  SETTINGS_VALUE_GENERAL_TOP      = 0;

  SETTINGS_VALUE_GENERAL_INPUT  = INPUT_DEFAULT;
  SETTINGS_VALUE_GENERAL_WINDOW = WINDOW_DEFAULT;
  SETTINGS_VALUE_GENERAL_THEME  = THEME_DEFAULT;
  SETTINGS_VALUE_GENERAL_SOUNDS = SOUNDS_DEFAULT;
  SETTINGS_VALUE_GENERAL_SCROLL = SCROLL_DEFAULT;

  SETTINGS_VALUE_GENERAL_REGION = REGION_DEFAULT;
  SETTINGS_VALUE_GENERAL_RNG    = RNG_DEFAULT;
  SETTINGS_VALUE_GENERAL_LEVEL  = LEVEL_DEFAULT;


const
  BEST_SCORES_SECTION_GENERAL = 'GENERAL';
  BEST_SCORES_SECTION_SCORE   = 'SCORE %d';

const
  BEST_SCORES_KEY_GENERAL_COUNT = 'COUNT';

  BEST_SCORES_KEY_SCORE_LINES_CLEARED = 'LINES CLEARED';
  BEST_SCORES_KEY_SCORE_LEVEL_BEGIN   = 'LEVEL BEGIN';
  BEST_SCORES_KEY_SCORE_LEVEL_END     = 'LEVEL END';
  BEST_SCORES_KEY_SCORE_TETRIS_RATE   = 'TETRIS RATE';
  BEST_SCORES_KEY_SCORE_TOTAL_SCORE   = 'TOTAL SCORE';


const
  LOG_FILENAME = 'log.txt';


const
  ERROR_SDL_INITIALIZE_SYSTEM = 1;
  ERROR_SDL_INITIALIZE_AUDIO  = 2;

  ERROR_SDL_CREATE_WINDOW      = 3;
  ERROR_SDL_CREATE_RENDERER    = 4;
  ERROR_SDL_CREATE_HANDLE      = 5;
  ERROR_SDL_CREATE_BACK_BUFFER = 6;
  ERROR_SDL_CREATE_QUIT_BUFFER = 7;

  ERROR_SDL_LOAD_SPRITE = 8;
  ERROR_SDL_LOAD_GROUND = 9;
  ERROR_SDL_LOAD_SOUND  = 10;

  ERROR_UNEXPECTED = 11;

  ERROR_FIRST = ERROR_SDL_INITIALIZE_SYSTEM;
  ERROR_LAST  = ERROR_UNEXPECTED;


const
  ERROR_TITLE   = 'Fairtris crashed!';

  ERROR_MESSAGE = 'A fatal error occurred while booting the game, and the startup process must be interrupted. ' +
                  'More information on the reason for the error can be found in the "log.txt" file.' +

                  LineEnding + LineEnding +

                  'Reinstalling the game may fix the problem, and if it persists, contact the author or report ' +
                  'a bug in the project''s repository (see the file "license.txt" for helpful information).';


implementation

end.

