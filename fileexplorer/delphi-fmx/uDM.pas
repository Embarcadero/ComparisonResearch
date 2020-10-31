unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.StdActns;

type
  TDataModule2 = class(TDataModule)
    ActionList1: TActionList;
    FileExit1: TFileExit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
