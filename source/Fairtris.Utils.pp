unit Fairtris.Utils;

{$MODE OBJFPC}{$LONGSTRINGS ON}{$MODESWITCH TYPEHELPERS}

interface

uses
  SDL2;


type
  TSDL_RectHelper = type helper for SDL2.TSDL_Rect
    constructor Create(ALeft, ATop, AWidth, AHeight: SInt32);
  end;


  function WrapAround(AValue, ACount, AStep: Integer): Integer;


implementation


constructor TSDL_RectHelper.Create(ALeft, ATop, AWidth, AHeight: SInt32);
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


end.

