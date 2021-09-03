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

unit Fairtris.Converter;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TConverter = class(TObject)
  public
    function PiecesToString(APieces: Integer): String;
    function ScoreToString(AScore: Integer): String;
    function LinesToString(ALines: Integer): String;
    function LevelToString(ALevel: Integer): String;
    function BurnedToString(ABurned: Integer): String;
    function TetrisesToString(ATetrises: Integer): String;
    function GainToString(AGain: Integer): String;
  end;


var
  Converter: TConverter;


implementation

uses
  SysUtils,
  Fairtris.Memory,
  Fairtris.Constants;


function TConverter.PiecesToString(APieces: Integer): String;
begin
  Result := '%.3d'.Format([APieces]);
end;


function TConverter.ScoreToString(AScore: Integer): String;
var
  Prefix: Integer;
begin
  if Memory.Options.Theme = THEME_MODERN then
    Result := '%.7d'.Format([AScore])
  else
  begin
    Result := '%.6d'.Format([AScore]);

    if Result.Length > 6 then
    begin
      Prefix := Result.Substring(0, 2).ToInteger();
      Result := Result.Remove(0, 2);
      Result := Result.Insert(0, Chr(Prefix + Ord('A') - 10));
    end;
  end;
end;


function TConverter.LinesToString(ALines: Integer): String;
begin
  if Memory.Options.Theme = THEME_MODERN then
    Result := ALines.ToString()
  else
    Result := '%.3d'.Format([ALines]);
end;


function TConverter.LevelToString(ALevel: Integer): String;
begin
  if Memory.Options.Theme = THEME_MODERN then
    Result := ALevel.ToString()
  else
    Result := '%.2d'.Format([ALevel]);
end;


function TConverter.BurnedToString(ABurned: Integer): String;
begin
  Result := ABurned.ToString();
end;


function TConverter.TetrisesToString(ATetrises: Integer): String;
begin
  Result := ATetrises.ToString() + '%';
end;


function TConverter.GainToString(AGain: Integer): String;
begin
  Result := AGain.ToString();
end;


end.

