unit Fairtris.Utils;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2;


  function SDL_Rect(ALeft, ATop, AWidth, AHeight: SInt32): TSDL_Rect;

  function WrapAround(AValue, ACount, AStep: Integer): Integer;

  function GetR(AColor: Integer): UInt8;
  function GetG(AColor: Integer): UInt8;
  function GetB(AColor: Integer): UInt8;


implementation


function SDL_Rect(ALeft, ATop, AWidth, AHeight: SInt32): TSDL_Rect;
begin
  Self.X := ALeft;
  Self.Y := ATop;
  Self.W := AWidth;
  Self.H := AHeight;
end;


function WrapAround(AValue, ACount, AStep: Integer): Integer;
begin
  Result := (AValue + ACount + AStep) mod ACount;
end;


function GetR(AColor: Integer): UInt8;
begin
  Result := AColor and $000000FF;
end;


function GetG(AColor: Integer): UInt8;
begin
  Result := (AColor and $0000FF00) shr 8;
end;


function GetB(AColor: Integer): UInt8;
begin
  Result := (AColor and $00FF0000) shr 16;
end;


end.

