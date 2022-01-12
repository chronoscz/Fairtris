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

unit Fairtris.Directories;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Classes, SysUtils;

function GetDataDir(RelativePath: string): string;
function GetConfigDir(RelativePath: string): string;

implementation

function GetDataDir(RelativePath: string): string;
const
  LinuxBaseDir = '/usr/share/fairtris/';
begin
  if DirectoryExists(RelativePath) or FileExists(RelativePath) then Result := RelativePath
  else
  if DirectoryExists(LinuxBaseDir + RelativePath) or
    FileExists(LinuxBaseDir + RelativePath) then Result := LinuxBaseDir + RelativePath
  else Result := RelativePath;
end;

function GetConfigDir(RelativePath: string): string;
begin
  if DirectoryExists(RelativePath) or FileExists(RelativePath) then Result := RelativePath
  else
    Result := GetAppConfigDir(False) + RelativePath;
end;

end.

