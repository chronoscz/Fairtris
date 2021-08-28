unit Fairtris.Grounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


type
  TThemeGrounds = class(TObject)
  private type
    TGrounds = array [SCENE_FIRST .. SCENE_LAST] of PSDL_Texture;
  private
    FGrounds: TGrounds;
    FGroundsPath: String;
  private
    function GetGround(ASceneID: Integer): PSDL_Texture;
  public
    constructor Create(const APath: String);
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Ground[ASceneID: Integer]: PSDL_Texture read GetGround; default;
  end;


type
  TGrounds = class(TThemeGrounds)
  private type
    TThemes = array [THEME_FIRST .. THEME_LAST] of TThemeGrounds;
  private
    FThemes: TThemes;
  private
    function GetTheme(AThemeID: Integer): TThemeGrounds;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Theme[AThemeID: Integer]: TThemeGrounds read GetTheme; default;
  end;


var
  Grounds: TGrounds;


implementation

uses
  SDL2_Image,
  Fairtris.Flow,
  Fairtris.Window,
  Fairtris.Arrays;


constructor TThemeGrounds.Create(const APath: String);
begin
  FGroundsPath := APath;
end;


destructor TThemeGrounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
    SDL_DestroyTexture(FGrounds[Index]);

  inherited Destroy();
end;


function TThemeGrounds.GetGround(ASceneID: Integer): PSDL_Texture;
begin
  Result := FGrounds[ASceneID];
end;


procedure TThemeGrounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
  begin
    FGrounds[Index] := Img_LoadTexture(Window.Renderer, PChar(FGroundsPath + GROUND_FILENAME[Index]));

    if FGrounds[Index] = nil then
      ControlFlow.HandleError(ERROR_SDL_LOAD_GROUND);
  end;
end;


constructor TGrounds.Create();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index] := TThemeGrounds.Create(GROUND_PATH[Index]);
end;


destructor TGrounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index].Free();

  inherited Destroy();
end;


function TGrounds.GetTheme(AThemeID: Integer): TThemeGrounds;
begin
  Result := FThemes[AThemeID];
end;


procedure TGrounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index].Load();
end;


end.

