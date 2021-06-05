unit Fairtris.Sounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TSounds = class(TObject)
  private
    FSound: Integer;
    FRegion: Integer;
    FEnabled: Integer;
  private
    FTimeExecute: TDateTime;
    FTimeExpired: TDateTime;
  private
    FStillPlaying: Boolean;
  private
    function GetSoundLength(): Integer;
    function GetSoundPath(): WideString;
  private
    function CanPlaySound(ASound: Integer): Boolean;
  private
    procedure UpdateSound(ASound, ARegion: Integer);
    procedure ExecuteSound();
  public
    procedure Initilize();
  public
    procedure Update();
    procedure Reset();
  public
    procedure PlaySound(ASound, ARegion: Integer);
  public
    property Enabled: Integer read FEnabled write FEnabled;
  end;


var
  Sounds: TSounds;


implementation

uses
  MMSystem,
  SysUtils,
  DateUtils,
  Fairtris.Arrays,
  Fairtris.Constants;


function TSounds.GetSoundLength(): Integer;
begin
  case FRegion of
    REGION_NTSC, REGION_NTSC_EXTENDED: Result := SOUND_LENGTH_NTSC[FSound];
    REGION_PAL,  REGION_PAL_EXTENDED:  Result := SOUND_LENGTH_PAL[FSound];
    REGION_EUR,  REGION_EUR_EXTENDED:  Result := SOUND_LENGTH_EUR[FSound];
  otherwise
    Result := 0;
  end;
end;


function TSounds.GetSoundPath(): WideString;
begin
  Result := SOUND_PATH[FRegion] + SOUND_NAME[FSound];
end;


function TSounds.CanPlaySound(ASound: Integer): Boolean;
begin
  if not FStillPlaying then Exit(True);

  if FSound in [SOUND_START, SOUND_TRANSITION, SOUND_TOP_OUT, SOUND_PAUSE] then
    Exit(False);

  if FSound in [SOUND_BURN, SOUND_TETRIS] then
    Exit(ASound in [SOUND_TRANSITION, SOUND_TOP_OUT]);

  Result := True;
end;


procedure TSounds.UpdateSound(ASound, ARegion: Integer);
begin
  FSound := ASound;
  FRegion := ARegion;

  FTimeExecute := Now();
  FTimeExpired := IncMilliSecond(FTimeExecute, GetSoundLength());

  FStillPlaying := True;
end;


procedure TSounds.ExecuteSound();
var
  SoundPath: WideString;
begin
  SoundPath := GetSoundPath();
  PlaySoundW(PWideChar(SoundPath), 0, SND_FILENAME or SND_ASYNC or SND_NODEFAULT);
end;


procedure TSounds.Initilize();
begin
  // tu odczytać stan dźwięków z "Settings"
end;


procedure TSounds.Update();
begin
  FStillPlaying := (FSound <> SOUND_UNKNOWN) and (Now() < FTimeExpired);

  if not FStillPlaying then
    Reset();
end;


procedure TSounds.Reset();
begin
  FSound := SOUND_UNKNOWN;

  FTimeExecute := Default(TDateTime);
  FTimeExpired := Default(TDateTime);

  FStillPlaying := False;
end;


procedure TSounds.PlaySound(ASound, ARegion: Integer);
begin
  if FEnabled = SOUNDS_DISABLED then Exit;
  if ASound = SOUND_UNKNOWN then Exit;

  if CanPlaySound(ASound) then
  begin
    UpdateSound(ASound, ARegion);
    ExecuteSound();
  end;
end;


end.

