{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This unit is part of the "Fairtris" video game source code. It contains
  the class responsible for storing the textures of all sprite
  collections, including the charset, bricks and piecec needed to render
  different game scenes.


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Sprites;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


{
  Class for managing sprite collections. Its task is to load all textures from files in the appropriate directory.
  Texture pointers are accessed through the "Collection" property.
}
type
  TSprites = class(TObject)
  private type
    TCollections = array [SPRITE_FIRST .. SPRITE_LAST] of PSDL_Texture;
  private
    FCollections: TCollections;
  private
    function GetCollection(ACollectionID: Integer): PSDL_Texture;
  public
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Collection[ACollectionID: Integer]: PSDL_Texture read GetCollection; default;
  public
    property Charset: PSDL_Texture index SPRITE_CHARSET read GetCollection;
    property Bricks: PSDL_Texture index SPRITE_BRICKS read GetCollection;
    property Pieces: PSDL_Texture index SPRITE_PIECES read GetCollection;
    property Miniatures: PSDL_Texture index SPRITE_MINIATURES read GetCollection;
    property Controller: PSDL_Texture index SPRITE_CONTROLLER read GetCollection;
  end;


var
  Sprites: TSprites;


implementation

uses
  SDL2_Image,
  SysUtils,
  Fairtris.Window,
  Fairtris.Classes,
  Fairtris.Arrays;


{
  Destructor is only responsible for releasing textures from memory.

  It is called in the "TGame.DestroyObjects" method.
}
destructor TSprites.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FCollections) to High(FCollections) do
    SDL_DestroyTexture(FCollections[Index]);

  inherited Destroy();
end;


{
  Collection property getter, returning a texture pointer based on the collection ID.

  ACollectionID — the collection index in the range "SPRITE_CHARSET" to "SPRITE_CONTROLLER".

  The property using this getter is used by many methods of all renderer classes located in the "Fairtris.Renderers"
  unit, when rendering any text, stack contents, or pieces thumbnails.
}
function TSprites.GetCollection(ACollectionID: Integer): PSDL_Texture;
begin
  Result := FCollections[ACollectionID];
end;


{
  Method loading textures of sprite sets from a given directory. If for some reason the texture cannot be loaded, an
  SDL exception is thrown, resulting in an error message and the process abort.

  It is called in the "TGame.Initialize" method, when all data is loaded from different files.
}
procedure TSprites.Load();
var
  Index: Integer;
begin
  for Index := Low(FCollections) to High(FCollections) do
  begin
    FCollections[Index] := Img_LoadTexture(Window.Renderer, PChar(SPRITE_PATH + SPRITE_FILENAME[Index]));

    if FCollections[Index] = nil then
      raise SDLException.CreateFmt(
        ERROR_MESSAGE_SDL,
        [
          MESSAGE_ERROR[ERROR_SDL_LOAD_SPRITE].Format([SPRITE_PATH + SPRITE_FILENAME[Index]]),
          Img_GetError()
        ]
      );
  end;
end;


end.

