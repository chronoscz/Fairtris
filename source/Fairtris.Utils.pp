unit Fairtris.Utils;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


  function WrapAround(AValue, ACount, AStep: Integer): Integer;


implementation


function WrapAround(AValue, ACount, AStep: Integer): Integer;
begin
  Result := (AValue + ACount + AStep) mod ACount;
end;


end.

