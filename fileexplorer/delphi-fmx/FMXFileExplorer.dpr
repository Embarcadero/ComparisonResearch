program FMXFileExplorer;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  uDM in 'uDM.pas' {DataModule2: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TDataModule2, DataModule2);
  Application.Run;
end.
