{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This unit is part of the "Fairtris" video game source code. It contains
  classes that store all the sound effects grouped by game region, as well
  as the top-level class responsible for playing the sounds.


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Sounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2_Mixer,
  Fairtris.Constants;


{
  This class is used to load and store a set of sound effects for game regions based on the same framerate. There are
  two sets of sounds, one for regions that use 60fps and one for regions that use 50fps. Access to individual sounds is
  provided by the "Sound" property.
}
type
  TRegionSounds = class(TObject)
  private type
    TSounds = array [SOUND_FIRST .. SOUND_LAST] of PMix_Chunk;
  private
    FSounds: TSounds;
    FSoundsPath: String;
  private
    function GetSound(ASoundID: Integer): PMix_Chunk;
  public
    constructor Create(const APath: String);
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Sound[ASoundID: Integer]: PMix_Chunk read GetSound; default;
  end;


{
  This class is used to manage objects that store collections of sound effects for specific regions of the game, as
  well as for playing these sounds, if the sounds are enabled.
}
type
  TSounds = class(TObject)
  private type
    TRegions = array [SOUND_REGION_FIRST .. SOUND_REGION_LAST] of TRegionSounds;
  private
    FRegions: TRegions;
    FEnabled: Integer;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Initilize();
    procedure Load();
  public
    procedure PlaySound(ASound: Integer; ANeedAttention: Boolean = False);
  public
    property Enabled: Integer read FEnabled write FEnabled;
  end;


var
  Sounds: TSounds;


implementation

uses
  SysUtils,
  Fairtris.Classes,
  Fairtris.Memory,
  Fairtris.Settings,
  Fairtris.Arrays;


{
  The constructor's job is to save the directory path with the full set of sound effect files. The data is loaded in
  the "TRegionSounds.Load" method.

  APath — directory path containing a set of sound effects for a single game region.

  It is called in the "TSounds.Create", when all sound sets are created.
}
constructor TRegionSounds.Create(const APath: String);
begin
  FSoundsPath := APath;
end;


{
  A class destructor that unloads previously loaded sound effects from memory.

  It is called in the "TSounds.Destroy" destructor, when releasing all sound sets objects.
}
destructor TRegionSounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FSounds) to High(FSounds) do
    Mix_FreeChunk(FSounds[Index]);

  inherited Destroy();
end;


{
  The "Sound" property getter, used to return a pointer to a sound chuck with a given ID.

  ASoundID — sound effect index ranging from "SOUND_BLIP" to "SOUND_GLASS".

  Result — correct chunk pointer or "nil" if the ID is "SOUND_UNKNOWN".

  The property using this getter is only used in the "TSounds.PlaySound" method.
}
function TRegionSounds.GetSound(ASoundID: Integer): PMix_Chunk;
begin
  Result := FSounds[ASoundID];
end;


{
  Method for loading sound effects from files, based on the path in the "TRegionSounds.FSoundsPath" field.
  If for some reason the sound cannot be loaded, an SDL exception is thrown, resulting in an error message and the
  game process abort.

  This method is called in the "TSounds.Load" method only.
}
procedure TRegionSounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FSounds) to High(FSounds) do
  begin
    FSounds[Index] := Mix_LoadWAV(PChar(FSoundsPath + SOUND_FILENAME[Index]));

    if FSounds[Index] = nil then
      raise SDLException.CreateFmt(
        ERROR_MESSAGE_SDL,
        [
          MESSAGE_ERROR[ERROR_SDL_LOAD_SOUND].Format([FSoundsPath + SOUND_FILENAME[Index]]),
          Mix_GetError()
        ]
      );
  end;
end;


{
  The constructor is responsible for creating objects with sets of sound effects for particular regions of the game.

  It is called in the "TGame.CreateObjects", when all top-level classes are created.
}
constructor TSounds.Create();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index] := TRegionSounds.Create(SOUND_PATH[Index]);
end;


{
  Destructor that releases objects with sound sets for different regions of the game.

  It is called in the "TGame.DestroyObjects" method.
}
destructor TSounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Free();

  inherited Destroy();
end;


{
  A method that initializes the state of playing sound effects in all game scenes. Set flag "TSounds.FEnabled" based
  on data in class "TSettings".

  It is called in the "TGame.Initialize" method, after loading data from files.
}
procedure TSounds.Initilize();
begin
  FEnabled := Settings.General.Sounds;
end;


{
  A method that loads collections of all sound effects from all regions of the game.

  Called in the "TGame.Initialize" method, before initializing all global objects.
}
procedure TSounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Load();
end;


{
  A method for playing sound effects. Do nothing if the given sound is "SOUND_UNKNOWN" or if the sounds in the game are
  disabled. If a newly played sound requires attention, it pre-mutes all channels so that the new sound can be clearly
  heard.

  ASound         — sound index ranging from "SOUND_BLIP" to "SOUND_GLASS".
  ANeedAttention — if set, mutes all audio channels before playing the specified sound effect.

  This method is used wherever a sound effect is required, both in menu scenes and during gameplay.
}
procedure TSounds.PlaySound(ASound: Integer; ANeedAttention: Boolean);
begin
  if ASound = SOUND_UNKNOWN then Exit;
  if FEnabled = SOUNDS_DISABLED then Exit;

  if ANeedAttention then
    Mix_HaltChannel(-1);

  Mix_PlayChannel(SOUND_CHANNEL[ASound], FRegions[SOUND_REGION[Memory.Play.Region]][ASound], 0);
end;


end.

