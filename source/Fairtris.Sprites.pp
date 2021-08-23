unit Fairtris.Sprites;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Constants;


type
  TSprites = class(TObject)
  private type
    TCollections = array [SPRITE_FIRST .. SPRITE_LAST] of TBitmap;
  private
    FCollections: TCollections;
  private
    procedure InitCollections();
    procedure DoneCollections();
  private
    function GetCollection(ACollectionID: Integer): TBitmap;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Collection[ACollectionID: Integer]: TBitmap read GetCollection; default;
  public
    property Charset: TBitmap index SPRITE_CHARSET read GetCollection;
    property Bricks: TBitmap index SPRITE_BRICKS read GetCollection;
    property Pieces: TBitmap index SPRITE_PIECES read GetCollection;
    property Miniatures: TBitmap index SPRITE_MINIATURES read GetCollection;
    property Controller: TBitmap index SPRITE_CONTROLLER read GetCollection;
  end;


var
  Sprites: TSprites;


implementation

uses
  Fairtris.Arrays;


constructor TSprites.Create();
begin
  InitCollections();
end;


destructor TSprites.Destroy();
begin
  DoneCollections();
  inherited Destroy();
end;


procedure TSprites.InitCollections();
var
  Index: Integer;
begin
  for Index := Low(FCollections) to High(FCollections) do
    FCollections[Index] := TBitmap.Create();
end;


procedure TSprites.DoneCollections();
var
  Index: Integer;
begin
  for Index := Low(FCollections) to High(FCollections) do
    FCollections[Index].Free();
end;


function TSprites.GetCollection(ACollectionID: Integer): TBitmap;
begin
  Result := FCollections[ACollectionID];
end;


procedure TSprites.Load();
var
  Index: Integer;
begin
  for Index := Low(FCollections) to High(FCollections) do
    FCollections[Index].LoadFromFile(SPRITE_PATH + SPRITE_FILENAME[Index]);
end;


end.

