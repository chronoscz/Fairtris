unit Fairtris.Classes;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  generic TCustomState<T> = class(TObject)
  protected
    FPrevious: T;
    FCurrent: T;
    FDefault: T;
  protected
    FChanged: Boolean;
  protected
    procedure SetCurrent(AState: T); virtual;
    procedure SetDefault(ADefault: T); virtual;
  public
    constructor Create(ADefault: T);
  public
    procedure Reset(); virtual;
    procedure Validate();
    procedure Invalidate();
  public
    property Previous: T read FPrevious;
    property Current: T read FCurrent write SetCurrent;
    property Default: T read FDefault write SetDefault;
  public
    property Changed: Boolean read FChanged;
  end;


type
  TSwitch = class(specialize TCustomState<Boolean>)
  private
    function GetJustPressed(): Boolean;
    function GetJustReleased(): Boolean;
  public
    property Pressed: Boolean read FCurrent write SetCurrent;
    property Released: Boolean read FCurrent;
  public
    property JustPressed: Boolean read GetJustPressed;
    property JustReleased: Boolean read GetJustReleased;
  end;


implementation


constructor TCustomState.Create(ADefault: T);
begin
  FDefault := ADefault;
  Reset();
end;


procedure TCustomState.SetCurrent(AState: T);
begin
  FPrevious := FCurrent;
  FCurrent := AState;

  FChanged := FPrevious <> FCurrent;
end;


procedure TCustomState.SetDefault(ADefault: T);
begin
  FDefault := ADefault;
  Reset();
end;


procedure TCustomState.Reset();
begin
  FPrevious := FDefault;
  FCurrent := FDefault;

  FChanged := False;
end;


procedure TCustomState.Validate();
begin
  SetCurrent(FCurrent);
end;


procedure TCustomState.Invalidate();
begin
  FChanged := True;
end;


function TSwitch.GetJustPressed(): Boolean;
begin
  Result := not FPrevious and FCurrent;
end;


function TSwitch.GetJustReleased(): Boolean;
begin
  Result := FPrevious and not FCurrent;
end;


end.

