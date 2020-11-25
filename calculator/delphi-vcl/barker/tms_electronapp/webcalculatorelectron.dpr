program webcalculatorelectron;

{$R *.dres}

uses
  Vcl.Forms,
  WEBLib.Forms,
  forms.maincalculatorform in '..\tms_web_core\forms.maincalculatorform.pas' {Form1: TWebForm} {*.html},
  classes.tcalculationinterface in '..\common\classes.tcalculationinterface.pas',
  controllers.calculatorinterface in '..\common\controllers.calculatorinterface.pas',
  interfaces.icalculatorinterface in '..\common\interfaces.icalculatorinterface.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.AutoFormRoute := True;
  Application.MainFormOnTaskbar := True;
  if not Application.NeedsFormRouting then
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
