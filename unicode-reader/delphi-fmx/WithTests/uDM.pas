unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.FMXUI.Wait, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.IOUtils,
  FireDAC.Comp.Script;

type
  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDScript: TFDScript;
    ChannelsQuery: TFDQuery;
    ArticlesQuery: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}
uses
  uUnicodeReader;

end.
