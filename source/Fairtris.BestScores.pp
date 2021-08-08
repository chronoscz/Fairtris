unit Fairtris.BestScores;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  FGL,
  IniFiles,
  Fairtris.Constants;


type
  TScoreEntry = class(TObject)
  private
    FRegion: Integer;
  private
    FLinesCleared: Integer;
    FLevelBegin: Integer;
    FLevelEnd: Integer;
    FTetrisRate: Integer;
    FTotalScore: Integer;
  private
    FValid: Boolean;
  private
    procedure Validate();
  public
    constructor Create(ARegion: Integer);
  public
    procedure Load(AFile: TIniFile; const ASection: String);
    procedure Save(AFile: TIniFile; const ASection: String);
  public
    property LinesCleared: Integer read FLinesCleared;
    property LevelBegin: Integer read FLevelBegin;
    property LevelEnd: Integer read FLevelEnd;
    property TetrisRate: Integer read FTetrisRate;
    property TotalScore: Integer read FTotalScore;
  public
    property Valid: Boolean read FValid;
  end;

type
  TScoreEntries = specialize TFPGObjectList<TScoreEntry>;


type
  TRNGEntries = class(TObject)
  private
    FScoresFile: TMemIniFile;
    FEntries: TScoreEntries;
  private
    FRegion: Integer;
  private
    function GetEntry(AIndex: Integer): TScoreEntry;
    function GetCount(): Integer;
  public
    constructor Create(const AFileName: String; ARegion: Integer);
    destructor Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    property Entry[AIndex: Integer]: TScoreEntry read GetEntry; default;
    property Count: Integer read GetCount;
  end;


type
  TRegionEntries = class(TObject)
  private
    FRNGs: array [RNG_FIRST .. RNG_LAST] of TRNGEntries;
  private
    function GetRNG(ARNG: Integer): TRNGEntries;
  public
    constructor Create(const APath: String; ARegion: Integer);
    destructor Destroy(); override;
  public
    property RNG[ARNG: Integer]: TRNGEntries read GetRNG; default;
  end;


type
  TBestScores = class(TObject)
  public
    procedure Load();
    procedure Save();
  end;


var
  BestScores: TBestScores;


implementation

uses
  Math,
  SysUtils,
  Fairtris.Arrays;


procedure TScoreEntry.Validate();
begin
  FValid := InRange(FLinesCleared, 0, 999);

  FValid := FValid and InRange(FLevelBegin, LEVEL_FIRST, LEVEL_KILLSCREEN[FRegion]);
  FValid := FValid and InRange(FLevelEnd,   LEVEL_FIRST, 99);

  FValid := FValid and (FLevelBegin <= FLevelEnd);

  FValid := FValid and InRange(FTetrisRate, 0, 100);
  FValid := FValid and InRange(FTotalScore, 0, 9999999);
end;


constructor TScoreEntry.Create(ARegion: Integer);
begin
  FRegion := ARegion;
end;


procedure TScoreEntry.Load(AFile: TIniFile; const ASection: String);
begin
  FLinesCleared := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LINES_CLEARED, -1);

  FLevelBegin := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_BEGIN, -1);
  FLevelEnd   := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_END,   -1);

  FTetrisRate := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TETRIS_RATE, -1);
  FTotalScore := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_SCORE, -1);

  Validate();
end;


procedure TScoreEntry.Save(AFile: TIniFile; const ASection: String);
begin
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LINES_CLEARED, FLinesCleared);

  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_BEGIN, FLevelBegin);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_END,   FLevelEnd);

  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TETRIS_RATE, FTetrisRate);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_SCORE, FTotalScore);
end;


constructor TRNGEntries.Create(const AFileName: String; ARegion: Integer);
begin
  FScoresFile := TMemIniFile.Create(AFileName);
  FEntries := TScoreEntries.Create();

  FRegion := ARegion;
end;


destructor TRNGEntries.Destroy();
begin
  FScoresFile.Free();
  FEntries.Free();

  inherited Destroy();
end;


function TRNGEntries.GetEntry(AIndex: Integer): TScoreEntry;
begin
  Result := FEntries[AIndex];
end;


function TRNGEntries.GetCount(): Integer;
begin
  Result := FEntries.Count;
end;


procedure TRNGEntries.Load();
var
  NewEntry: TScoreEntry;
  EntriesCount, Index: Integer;
begin
  FEntries.Clear();
  EntriesCount := FScoresFile.ReadInteger(BEST_SCORES_SECTION_GENERAL, BEST_SCORES_KEY_GENERAL_COUNT, 0);

  for Index := 0 to EntriesCount - 1 do
  begin
    NewEntry := TScoreEntry.Create(FRegion);
    NewEntry.Load(FScoresFile, BEST_SCORES_SECTION_SCORE.Format([Index]));

    if NewEntry.Valid then
      FEntries.Add(NewEntry);
  end;
end;


procedure TRNGEntries.Save();
var
  StoreCount, Index: Integer;
begin
  StoreCount := Min(FEntries.Count, BEST_SCORES_STORE_COUNT);

  FScoresFile.Clear();
  FScoresFile.WriteInteger(BEST_SCORES_SECTION_GENERAL, BEST_SCORES_KEY_GENERAL_COUNT, StoreCount);

  for Index := 0 to StoreCount - 1 do
    FEntries[Index].Save(FScoresFile, BEST_SCORES_SECTION_SCORE.Format([Index]));
end;


constructor TRegionEntries.Create(const APath: String; ARegion: Integer);
var
  Index: Integer;
begin
  for Index := Low(FRNGs) to High(FRNGs) do
    FRNGs[Index] := TRNGEntries.Create(APath + BEST_SCORES_FILENAME[Index], ARegion);
end;


destructor TRegionEntries.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FRNGs) to High(FRNGs) do
    FRNGs[Index].Free();

  inherited Destroy();
end;


function TRegionEntries.GetRNG(ARNG: Integer): TRNGEntries;
begin
  Result := FRNGs[ARNG];
end;


procedure TBestScores.Load();
begin

end;


procedure TBestScores.Save();
begin

end;


end.

