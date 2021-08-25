unit Fairtris.Sounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TSounds = class(TObject)
  private
    FEnabled: Integer;
  public
    procedure Initilize();
  public
    procedure PlaySound(ASound: Integer);
  public
    property Enabled: Integer read FEnabled write FEnabled;
  end;


var
  Sounds: TSounds;


implementation

uses
  Fairtris.Settings,
  Fairtris.Arrays,
  Fairtris.Constants;


procedure TSounds.Initilize();
begin
  FEnabled := Settings.General.Sounds;
end;


procedure TSounds.PlaySound(ASound: Integer);
begin
  if ASound = SOUND_UNKNOWN then Exit;
  if FEnabled = SOUNDS_DISABLED then Exit;

  // play sound here
end;


end.

