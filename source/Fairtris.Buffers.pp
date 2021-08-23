unit Fairtris.Buffers;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Types;


type
  TBuffers = class(TObject)
  private
    FNative: TBitmap;
    FClient: TRect;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    property Native: TBitmap read FNative;
    property Client: TRect read FClient write FClient;
  end;


var
  Buffers: TBuffers;


implementation

uses
  Fairtris.Constants;


constructor TBuffers.Create();
begin
  FNative := TBitmap.Create();

  FNative.PixelFormat := pf24bit;
  FNative.SetSize(BUFFER_WIDTH, BUFFER_HEIGHT);
end;


destructor TBuffers.Destroy();
begin
  FNative.Free();
  inherited Destroy();
end;


end.

