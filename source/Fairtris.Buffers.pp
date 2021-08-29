unit Fairtris.Buffers;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2;


type
  TBuffers = class(TObject)
  private
    FNative: PSDL_Texture;
    FClient: TSDL_Rect;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    property Native: PSDL_Texture read FNative;
    property Client: TSDL_Rect read FClient write FClient;
  end;


var
  Buffers: TBuffers;


implementation

uses
  Fairtris.Window,
  Fairtris.Constants;


constructor TBuffers.Create();
begin
  FNative := SDL_CreateTexture(Window.Renderer, SDL_PIXELFORMAT_BGR24, SDL_TEXTUREACCESS_TARGET, BUFFER_WIDTH, BUFFER_HEIGHT);

  if FNative = nil then
    Flow.HandleError(ERROR_SDL_CREATE_BACK_BUFFER);
end;


destructor TBuffers.Destroy();
begin
  SDL_DestroyTexture(FNative);
  inherited Destroy();
end;


end.

