program vclfluentuicalculator;

uses
  Vcl.Forms,
  forms.almstylecalculator in 'forms.almstylecalculator.pas' {VCLCalculatorForm},
  WindowsDarkMode in 'WindowsDarkMode.pas',
  classes.tcalculationinterface in '..\common\classes.tcalculationinterface.pas',
  controllers.calculatorinterface in '..\common\controllers.calculatorinterface.pas',
  interfaces.icalculatorinterface in '..\common\interfaces.icalculatorinterface.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Calculator';
  Application.CreateForm(TVCLCalculatorForm, VCLCalculatorForm);
  Application.Run;
end.
