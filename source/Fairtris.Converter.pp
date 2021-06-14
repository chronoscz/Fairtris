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


function TConverter.PiecesToString(APieces: Integer): String;
begin
  Result := '';
end;


function TConverter.ScoreToString(AScore: Integer): String;
begin
  Result := '';
end;


function TConverter.LinesToString(ALines: Integer): String;
begin
  Result := '';
end;


function TConverter.LevelToString(ALevel: Integer): String;
begin
  Result := '';
end;


function TConverter.BurnedToString(ABurned: Integer): String;
begin
  Result := '';
end;


function TConverter.TetrisesToString(ATetrises: Integer): String;
begin
  Result := '';
end;


function TConverter.GainToString(AGain: Integer): String;
begin
  Result := '';
end;


end.

