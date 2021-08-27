unit Fairtris.ControlFlow;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TControlFlow = class(TObject)
  end;


var
  ControlFlow: TControlFlow;


implementation


initialization
begin
  ControlFlow := TControlFlow.Create();
end;


finalization
begin
  ControlFlow.Free();
end;


end.

