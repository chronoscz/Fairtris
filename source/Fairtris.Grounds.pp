unit Fairtris.Grounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Graphics,
  Fairtris.Constants;


type
  TThemeGrounds = class(TObject)
  private type
    TGrounds = array [SCENE_FIRST .. SCENE_LAST] of TBitmap;
  private
    FGrounds: TGrounds;
    FGroundsPath: String;
  private
    procedure InitGrounds();
    procedure DoneGrounds();
  private
    function GetGround(ASceneID: Integer): TBitmap;
  public
    constructor Create(const APath: String);
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Ground[ASceneID: Integer]: TBitmap read GetGround; default;
  end;


type
  TGrounds = class(TThemeGrounds)
  private type
    TThemes = array [THEME_FIRST .. THEME_LAST] of TThemeGrounds;
  private
    FThemes: TThemes;
  private
    procedure InitThemes();
    procedure DoneThemes();
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
  Fairtris.Arrays;


constructor TThemeGrounds.Create(const APath: String);
begin
  FGroundsPath := APath;
  InitGrounds();
end;


destructor TThemeGrounds.Destroy();
begin
  DoneGrounds();
  inherited Destroy();
end;


procedure TThemeGrounds.InitGrounds();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
    FGrounds[Index] := TBitmap.Create();
end;


procedure TThemeGrounds.DoneGrounds();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
    FGrounds[Index].Free();
end;


function TThemeGrounds.GetGround(ASceneID: Integer): TBitmap;
begin
  Result := FGrounds[ASceneID];
end;


procedure TThemeGrounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
    FGrounds[Index].LoadFromFile(FGroundsPath + GROUND_NAME[Index]);
end;


constructor TGrounds.Create();
begin
  InitThemes();
end;


destructor TGrounds.Destroy();
begin
  DoneThemes();
  inherited Destroy();
end;


procedure TGrounds.InitThemes();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index] := TThemeGrounds.Create(GROUND_PATH[Index]);
end;


procedure TGrounds.DoneThemes();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index].Free();
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

