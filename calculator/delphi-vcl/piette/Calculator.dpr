program Calculator;

uses
  Vcl.Forms,
  CalculatorMain in 'CalculatorMain.pas' {CalculatorForm},
  CalculatorEngine in 'CalculatorEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCalculatorForm, CalculatorForm);
  Application.Run;
end.
