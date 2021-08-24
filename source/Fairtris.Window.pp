unit Fairtris.Window;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2;


type
  TWindow = class(TObject)
  private
    FWindow: PSDL_Window;
    FRenderer: PSDL_Renderer;
  private
    function GetLeft(): Integer;
    function GetTop(): Integer;
  private
    function GetFocused(): Boolean;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    property Window: PSDL_Window read FWindow;
    property Renderer: PSDL_Renderer read FRenderer;
  public
    property Left: Integer read GetLeft;
    property Top: Integer read GetTop;
  public
    property Focused: Boolean read GetFocused;
  end;


var
  Window: TWindow;


implementation


constructor TWindow.Create();
begin
  FWindow := SDL_CreateWindow('Fairtris', SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 0, 0, SDL_WINDOW_BORDERLESS);
  if FWindow = nil then Halt();

  FRenderer := SDL_CreateRenderer(FWindow, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_TARGETTEXTURE);
  if FRenderer = nil then Halt();
end;


destructor TWindow.Destroy();
begin
  SDL_DestroyWindow(FWindow);
  SDL_DestroyRenderer(FRenderer);

  inherited Destroy();
end;


function TWindow.GetLeft(): Integer;
var
  Dummy: Integer = -1;
begin
  SDL_GetWindowPosition(FWindow, @Result, @Dummy);
end;


function TWindow.GetTop(): Integer;
var
  Dummy: Integer = -1;
begin
  SDL_GetWindowPosition(FWindow, @Dummy, @Result);
end;


function TWindow.GetFocused(): Boolean;
begin
  Result := SDL_GetWindowFlags(Window) and SDL_WINDOW_INPUT_FOCUS = SDL_WINDOW_INPUT_FOCUS;
end;


end.

