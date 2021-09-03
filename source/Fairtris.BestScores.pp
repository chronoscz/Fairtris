{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

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
    constructor Create(ARegion: Integer; AValid: Boolean = False);
  public
    procedure Load(AFile: TIniFile; const ASection: String);
    procedure Save(AFile: TIniFile; const ASection: String);
  public
    property LinesCleared: Integer read FLinesCleared write FLinesCleared;
    property LevelBegin: Integer read FLevelBegin write FLevelBegin;
    property LevelEnd: Integer read FLevelEnd write FLevelEnd;
    property TetrisRate: Integer read FTetrisRate write FTetrisRate;
    property TotalScore: Integer read FTotalScore write FTotalScore;
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
    function GetBestScore(): Integer;
  public
    constructor Create(const AFileName: String; ARegion: Integer);
    destructor Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    procedure Add(AEntry: TScoreEntry);
  public
    property Entry[AIndex: Integer]: TScoreEntry read GetEntry; default;
    property Count: Integer read GetCount;
  public
    property BestScore: Integer read GetBestScore;
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
    procedure Load();
    procedure Save();
  public
    property RNG[ARNG: Integer]: TRNGEntries read GetRNG; default;
  end;


type
  TBestScores = class(TObject)
  private
    FRegions: array [REGION_FIRST .. REGION_LAST] of TRegionEntries;
  private
    function GetRegion(ARegion: Integer): TRegionEntries;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    property Region[ARegion: Integer]: TRegionEntries read GetRegion; default;
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


constructor TScoreEntry.Create(ARegion: Integer; AValid: Boolean);
begin
  FRegion := ARegion;
  FValid := AValid;
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


function TRNGEntries.GetBestScore(): Integer;
begin
  if FEntries.Count = 0 then
    Result := 0
  else
    Result := FEntries.First.TotalScore;
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
  StoreCount := Min(FEntries.Count, BEST_SCORES_COUNT);

  FScoresFile.Clear();
  FScoresFile.WriteInteger(BEST_SCORES_SECTION_GENERAL, BEST_SCORES_KEY_GENERAL_COUNT, StoreCount);

  for Index := 0 to StoreCount - 1 do
    FEntries[Index].Save(FScoresFile, BEST_SCORES_SECTION_SCORE.Format([Index]));
end;


procedure TRNGEntries.Add(AEntry: TScoreEntry);
var
  Index: Integer;
begin
  for Index := 0 to FEntries.Count - 1 do
    if AEntry.TotalScore > FEntries[Index].TotalScore then
    begin
      FEntries.Insert(Index, AEntry);
      Exit;
    end;

  FEntries.Add(AEntry);
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


procedure TRegionEntries.Load();
var
  Index: Integer;
begin
  for Index := Low(FRNGs) to High(FRNGs) do
    FRNGs[Index].Load();
end;


procedure TRegionEntries.Save();
var
  Index: Integer;
begin
  for Index := Low(FRNGs) to High(FRNGs) do
    FRNGs[Index].Save();
end;


function TRegionEntries.GetRNG(ARNG: Integer): TRNGEntries;
begin
  Result := FRNGs[ARNG];
end;


constructor TBestScores.Create();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index] := TRegionEntries.Create(BEST_SCORES_PATH[Index], Index);
end;


destructor TBestScores.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Free();

  inherited Destroy();
end;


function TBestScores.GetRegion(ARegion: Integer): TRegionEntries;
begin
  Result := FRegions[ARegion];
end;


procedure TBestScores.Load();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Load();
end;


procedure TBestScores.Save();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Save();
end;


end.

