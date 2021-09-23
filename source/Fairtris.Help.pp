unit Fairtris.Help;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Classes;


type
  THelpThread = class(TThread)
  public
    procedure Execute(); override;
  end;


implementation

uses
  Windows,
  Fairtris.Logic,
  Fairtris.Constants;


procedure THelpThread.Execute();
var
  Address: String = 'https://github.com/furious-programming/fairtris/wiki';
begin
  case Logic.Scene.Current of
    SCENE_MENU:        Address += '/prime-menu';
    SCENE_PLAY:        Address += '/set-up-game';
    SCENE_GAME_NORMAL: Address += '/gameplay';
    SCENE_GAME_FLASH:  Address += '/gameplay';
    SCENE_PAUSE:       Address += '/game-pause';
    SCENE_TOP_OUT:     Address += '/game-summary';
    SCENE_OPTIONS:     Address += '/game-options';
    SCENE_KEYBOARD:    Address += '/set-up-keyboard';
    SCENE_CONTROLLER:  Address += '/set-up-controller';
  end;

  ShellExecute(0, 'open', PChar(Address), nil, nil, SW_SHOWNORMAL);
  Terminate();
end;


end.

