program vclcalculator;

uses
  Vcl.Forms,
  forms.VCLCalculator in 'forms.VCLCalculator.pas' {VCLCalculatorForm},
  classes.tcalculationinterface in '..\common\classes.tcalculationinterface.pas',
  controllers.calculatorinterface in '..\common\controllers.calculatorinterface.pas',
  interfaces.icalculatorinterface in '..\common\interfaces.icalculatorinterface.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TVCLCalculatorForm, VCLCalculatorForm);
  Application.Run;
end.
