{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021-2022. All rights reversed.

  https://github.com/furious-programming/fairtris


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Help;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Classes, Process;


type
  THelpThread = class(TThread)
  public
    procedure Execute(); override;
  end;


implementation

uses
  {$IFDEF WINDOWS}Windows,{$ENDIF}
  StrUtils,
  Fairtris.Memory,
  Fairtris.Logic,
  Fairtris.Constants;


procedure ExecuteProgram(Executable: string; Parameters: array of string);
var
  Process: TProcess;
  I: Integer;
begin
  try
    Process := TProcess.Create(nil);
    Process.Executable := Executable;
    for I := 0 to Length(Parameters) - 1 do
      Process.Parameters.Add(Parameters[I]);
    Process.Options := [poNoConsole];
    Process.Execute;
  finally
    Process.Free;
  end;
end;

procedure THelpThread.Execute();
var
  Address: String = 'https://github.com/furious-programming/fairtris/wiki';
begin
  case Logic.Scene.Current of
    SCENE_MENU:            Address += '/prime-menu';
    SCENE_MODES:           Address += '/game-modes';
    SCENE_FREE_MARATHON:   Address += '/free-marathon';
    SCENE_FREE_SPEEDRUN:   Address += '/free-speedrun';
    SCENE_MARATHON_QUALS:  Address += '/marathon-qualifications';
    SCENE_MARATHON_MATCH:  Address += '/marathon-match';
    SCENE_SPEEDRUN_QUALS:  Address += '/speedrun-qualifications';
    SCENE_SPEEDRUN_MATCH:  Address += '/speedrun-match';
    SCENE_GAME_NORMAL:     Address += '/marathon';
    SCENE_GAME_FLASH:      Address += '/marathon';
    SCENE_SPEEDRUN_NORMAL: Address += '/speedrun';
    SCENE_SPEEDRUN_FLASH:  Address += '/speedrun';
    SCENE_PAUSE:           Address += '/game-pause';
    SCENE_OPTIONS:         Address += '/game-options';
    SCENE_KEYBOARD:        Address += '/set-up-keyboard';
    SCENE_CONTROLLER:      Address += '/set-up-controller';
    SCENE_TOP_OUT:         Address += IfThen(Memory.GameModes.IsMarathon, '/marathon-summary', '/speedrun-summary');
  end;

  {$IFDEF WINDOWS}ShellExecute(0, 'open', PChar(Address), nil, nil, SW_SHOWNORMAL);{$ENDIF}
  {$IFDEF LINUX}ExecuteProgram('/usr/bin/xdg-open', [Address]);{$ENDIF}
  Terminate();
end;


end.

