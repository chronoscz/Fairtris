{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This unit is part of the "Fairtris" video game source code. Contains
  classes that store the background textures of all game scenes, grouping
  them by theme. There is also a top-level class that manages backgrounds
  and provides an interface for convenient access to textures.


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Grounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


{
  The class that stores the textures of all scene backgrounds for a single theme. It is responsible for loading
  textures from disk and provides a convenient interface for downloading texture pointers.
}
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


{
  High-level class for managing the objects of all texture sets for scene backgrounds. Its only job is to group
  textures objects, manage them, and share references via "Theme" property.
}
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
  SysUtils,
  Fairtris.Window,
  Fairtris.Classes,
  Fairtris.Arrays;


{
  The constructor's only task is to save the path of the background textures directory.

  APath — a path to directory with a background texture set for a single theme.

  It is called in the "TGrounds.Create" constructor, when creating objects of all themes.
}
constructor TThemeGrounds.Create(const APath: String);
begin
  FGroundsPath := APath;
end;


{
  This destructor unloads all previously loaded scene background textures from memory.

  It is called in the "TGrounds.Destroy" destructor, when destroying object of all themes.
}
destructor TThemeGrounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
    SDL_DestroyTexture(FGrounds[Index]);

  inherited Destroy();
end;


{
  This method is the "TThemeGrounds.Ground" property ghetto, it is used to get texture indicator for given scene.

  ASceneID — scene index ranging from "SCENE_LEGAL" to "SCENE_QUIT".

  The property using this getter is used in the "TRenderer.RenderGround" method when rendering the background of
  the current scene.
}
function TThemeGrounds.GetGround(ASceneID: Integer): PSDL_Texture;
begin
  Result := FGrounds[ASceneID];
end;


{
  The method responsible for loading the texture set for all scenes of a given theme. If the texture cannot be loaded
  for some reason, an SDL exception is thrown, resulting in an error message and the process aborted.

  It is called only in the "TGrounds.Load" method.
}
procedure TThemeGrounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
  begin
    FGrounds[Index] := Img_LoadTexture(Window.Renderer, PChar(FGroundsPath + GROUND_FILENAME[Index]));

    if FGrounds[Index] = nil then
      raise SDLException.CreateFmt(
        ERROR_MESSAGE_SDL,
        [
          MESSAGE_ERROR[ERROR_SDL_LOAD_GROUND].Format([FGroundsPath + GROUND_FILENAME[Index]]),
          Img_GetError()
        ]
      );
  end;
end;


{
  Constructor of an object that manages texture sets for various themes. Its only task is to instantiate the classes
  that hold the texture sets.

  This constructor is called in the "TGame.CreateObjects" method.
}
constructor TGrounds.Create();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index] := TThemeGrounds.Create(GROUND_PATH[Index]);
end;


{
  This desuctor releases all objects that collect the scene background texture sets.

  It is called in the "TGame.DestroyObjects" method.
}
destructor TGrounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index].Free();

  inherited Destroy();
end;


{
  The "TGrounds.Theme" property getter. It is used to return reference of an object with a set of textures, based
  on a given theme ID.

  AThemeID — a theme index ranging from "THEME_MODERN" to "THEME_CLASSIC".

  The property using this getter is only used when rendering the background of the current scene, which is done in
  the "TRenderer.RenderGround" method.
}
function TGrounds.GetTheme(AThemeID: Integer): TThemeGrounds;
begin
  Result := FThemes[AThemeID];
end;


{
  This method is responsible for loading texture sets with backgrounds for all scenes of all themes.

  It is called in the "TGame.Initialize" method only.
}
procedure TGrounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index].Load();
end;


end.

