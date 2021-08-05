unit Fairtris.Interfaces;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Classes,
  Fairtris.Constants;


type
  IControllable = interface(IInterface)
    function GetSwitch(AIndex: Integer): TSwitch;
    function GetScanCode(AIndex: Integer): UInt8;
    function GetConnected(): Boolean;

    property Switch[AIndex: Integer]: TSwitch read GetSwitch;
    property ScanCode[AIndex: Integer]: UInt8 read GetScanCode;

    property Up: TSwitch index DEVICE_UP read GetSwitch;
    property Down: TSwitch index DEVICE_DOWN read GetSwitch;
    property Left: TSwitch index DEVICE_LEFT read GetSwitch;
    property Right: TSwitch index DEVICE_RIGHT read GetSwitch;
    property Select: TSwitch index DEVICE_SELECT read GetSwitch;
    property Start: TSwitch index DEVICE_START read GetSwitch;
    property B: TSwitch index DEVICE_B read GetSwitch;
    property A: TSwitch index DEVICE_A read GetSwitch;

    property Connected: Boolean read GetConnected;
  end;


type
  IRenderable = interface(IInterface)
    procedure RenderLegal();
    procedure RenderMenu();
    procedure RenderPlay();
    procedure RenderGame();
    procedure RenderPause();
    procedure RenderTopOut();
    procedure RenderOptions();
    procedure RenderKeyboard();
    procedure RenderController();
    procedure RenderQuit();

    procedure RenderScene(ASceneID: Integer);
  end;


type
  IGenerable = interface(IInterface)
    procedure Initialize();
    procedure Prepare();

    procedure Shuffle();
    procedure Step();

    function Pick(): Integer;
  end;


implementation

end.

