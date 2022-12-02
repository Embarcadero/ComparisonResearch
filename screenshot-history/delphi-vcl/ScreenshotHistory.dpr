program ScreenshotHistory;

uses
  Vcl.Forms,
  uScreenshotHistory in 'uScreenshotHistory.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 BlackPearl');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
