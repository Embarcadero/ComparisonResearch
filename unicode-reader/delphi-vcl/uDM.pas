unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Phys.PGDef,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.Script,
  FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    ChannelsQuery: TFDQuery;
    ArticlesQuery: TFDQuery;
    FDScript: TFDScript;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDConnection: TFDConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
