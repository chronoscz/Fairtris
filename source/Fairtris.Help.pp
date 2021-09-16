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
  Windows;


procedure THelpThread.Execute();
begin
  ShellExecute(0, 'open', 'https://github.com/furious-programming/fairtris/wiki', nil, nil, SW_SHOWNORMAL);
  Terminate();
end;


end.

