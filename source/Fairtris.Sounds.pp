unit Fairtris.Sounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2_Mixer,
  Fairtris.Constants;


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


type
  TSounds = class(TObject)
  private type
    TRegions = array [SOUND_REGION_FIRST .. SOUND_REGION_LAST] of TRegionSounds;
  private
    FRegions: TRegions;
    FEnabled: Integer;
  private
    function GetRegion(ARegionID: Integer): TRegionSounds;
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
  Fairtris.Flow,
  Fairtris.Memory,
  Fairtris.Settings,
  Fairtris.Arrays;


constructor TRegionSounds.Create(const APath: String);
begin
  FSoundsPath := APath;
end;


destructor TRegionSounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FSounds) to High(FSounds) do
    Mix_FreeChunk(FSounds[Index]);

  inherited Destroy();
end;


function TRegionSounds.GetSound(ASoundID: Integer): PMix_Chunk;
begin
  Result := FSounds[ASoundID];
end;


procedure TRegionSounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FSounds) to High(FSounds) do
  begin
    FSounds[Index] := Mix_LoadWAV(PChar(FSoundsPath + SOUND_FILENAME[Index]));

    if FSounds[Index] = nil then
      Flow.HandleError(ERROR_SDL_LOAD_SOUND);
  end;
end;


constructor TSounds.Create();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index] := TRegionSounds.Create(SOUND_PATH[Index]);
end;


destructor TSounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Free();

  inherited Destroy();
end;


function TSounds.GetRegion(ARegionID: Integer): TRegionSounds;
begin
  Result := FRegions[SOUND_REGION[ARegionID]];
end;


procedure TSounds.Initilize();
begin
  FEnabled := Settings.General.Sounds;
end;


procedure TSounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Load();
end;


procedure TSounds.PlaySound(ASound: Integer; ANeedAttention: Boolean);
begin
  if ASound = SOUND_UNKNOWN then Exit;
  if FEnabled = SOUNDS_DISABLED then Exit;

  if ANeedAttention then
    Mix_HaltChannel(-1);

  Mix_PlayChannel(SOUND_CHANNEL[ASound], FRegions[SOUND_REGION[Memory.Play.Region]][ASound], 0);
end;


end.

