program FMXFileExplorer;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form3},
  uDM in 'uDM.pas' {dm: TDataModule},
  uPlatform in 'uPlatform.pas',
  uTypes in 'uTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
