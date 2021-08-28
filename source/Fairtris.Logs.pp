unit Fairtris.Logs;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Classes;


type
  TLog = class(TObject)
  private
    FContent: TStringList;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure AddEntry(const AHeader, AMessage: String);
  public
    procedure AddError(const AMessage: String);
    procedure AddWarning(const AMessage: String);
    procedure AddException(const AMessage: String);
  public
    procedure SaveToFile(const AFileName: String);
  end;


var
  Log: TLog;


implementation


constructor TLog.Create();
begin
  FContent := TStringList.Create();
end;


destructor TLog.Destroy();
begin
  FContent.Free();
  inherited Destroy();
end;


procedure TLog.AddEntry(const AHeader, AMessage: String);
begin
  FContent.AddStrings([
    AHeader,
    '',
    AMessage,
    '',
    ''
  ]);
end;


procedure TLog.AddError(const AMessage: String);
begin
  AddEntry('Error occured:', AMessage);
end;


procedure TLog.AddWarning(const AMessage: String);
begin
  AddEntry('Warning occured:', AMessage);
end;


procedure TLog.AddException(const AMessage: String);
begin
  AddEntry('Exception occured:', AMessage);
end;


procedure TLog.SaveToFile(const AFileName: String);
begin
  FContent.SaveToFile(AFileName);
end;


initialization
begin
  Log := TLog.Create();
end;


finalization
begin
  Log.Free();
end;


end.

