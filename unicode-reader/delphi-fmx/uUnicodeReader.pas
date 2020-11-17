unit uUnicodeReader;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, Xml.xmldom, Xml.XMLIntf, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.WebBrowser, Data.Bind.Components, Xml.omnixmldom, Xml.XMLDoc,
  Data.Bind.DBScope, Fmx.Bind.Editors, FMX.MultiView, FMX.Edit,
  System.ImageList, FMX.ImgList, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TMainForm = class(TForm)
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    StatusLabel: TLabel;
    RefreshButton: TButton;
    ColorButton: TButton;
    BlackStyle: TStyleBook;
    WhiteStyle: TStyleBook;
    XMLDocument: TXMLDocument;
    Net: TNetHTTPClient;
    WebBrowser: TWebBrowser;
    Splitter2: TSplitter;
    ArticlesList: TListView;
    Splitter1: TSplitter;
    ChannelsList: TListView;
    ArticlesBS: TBindSourceDB;
    BindingsList1: TBindingsList;
    ChannelsBS: TBindSourceDB;
    MultiView: TMultiView;
    ConnectButton: TButton;
    Label7: TLabel;
    Edit5: TEdit;
    Edit4: TEdit;
    Label6: TLabel;
    Label5: TLabel;
    Edit3: TEdit;
    Edit2: TEdit;
    Label4: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    ConnectionButton: TButton;
    LinkListControlToField1: TLinkListControlToField;
    LinkListControlToField2: TLinkListControlToField;
    ImageList1: TImageList;
    procedure ColorButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure ChannelsListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ArticlesListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ConnectionButtonClick(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure WebBrowserDidStartLoad(ASender: TObject);
    procedure WebBrowserDidFinishLoad(ASender: TObject);
    procedure WebBrowserDidFailLoadWithError(ASender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ArticlesListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    IsEmptyURL: boolean;
    procedure BeginLoad;
    procedure EndLoad;
    procedure LoadEmptyUrl;
    procedure ImportFeed(const Name: string; id: integer);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}
uses
{$IFDEF MSWINDOWS}
  Registry,
{$ENDIF}
  System.StrUtils, IdGlobalProtocols,
  FireDAC.Stan.Param, FireDAC.Phys.PGDef, uDM;

const
  SelectAllArticles = 'select * from  articles order by id';
  SelectArticles = 'select * from  articles where channel = :channel order by id';
  DarkThemeURL =
    '<!doctype html>' +
    '<html lang="en">' +
    '  <head>' +
    '    <!-- Required meta tags -->' +
    '    <meta charset="utf-8">' +
    '    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">' +
    '    <style> .img-responsive{width: 100%;} </style>' +
    '    <!-- Bootstrap CSS -->' +
    '    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">' +
    '  </head>' +
    '  <body style="padding: 25px; background-color: #20262f !important; color: #eee;">' +
    '<div class="container-fluid"><div class="row">' +
    '  </body>' +
    '</html>';

{$IFDEF MSWINDOWS}
procedure SetPermissions;
const
  cHomePath = 'SOFTWARE';
  cFeatureBrowserEmulation = 'Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\';
  cIE11 = 11001;
var
  Reg: TRegIniFile;
  sKey: string;
begin
  sKey := ExtractFileName(ParamStr(0));
  Reg := TRegIniFile.Create(cHomePath);
  try
    if Reg.OpenKey(cFeatureBrowserEmulation, True) and
      not(TRegistry(Reg).KeyExists(sKey) and (TRegistry(Reg).ReadInteger(sKey) = cIE11))
    then
      TRegistry(Reg).WriteInteger(sKey, cIE11);
  finally
    Reg.Free;
  end;
end;
{$ENDIF}

procedure TMainForm.BeginLoad;
begin
  StatusLabel.Text := 'Loading...';
end;

procedure TMainForm.EndLoad;
begin
  StatusLabel.Text := '';
end;

procedure TMainForm.LoadEmptyUrl;
begin
{$IFDEF MSWINDOWS}
  SetPermissions;
{$ENDIF}
  if MainForm.StyleBook = BlackStyle then
    WebBrowser.LoadFromStrings(DarkThemeURL, 'about:blank')
  else
    WebBrowser.LoadFromStrings('', 'about:blank');
  IsEmptyURL := True;
end;

procedure TMainForm.ImportFeed(const Name: string; id: integer);
var
  Stream: TStream;
  StartItemNode: IXMLNode;
  Node: IXMLNode;
  Content, Title, Desc, Link: string;
begin
  BeginLoad;

  Stream := TMemoryStream.Create;
  try
    Net.Get(Name, Stream);
    Stream.Position := 0;
    XMLDocument.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;

  XMLDocument.Active := True;

  StartItemNode := XMLDocument.DocumentElement.ChildNodes.First.ChildNodes.FindNode('item') ;
  Node := StartItemNode;
  repeat
    Title := Node.ChildNodes['title'].Text;
    Link := Node.ChildNodes['link'].Text;
    Desc := Node.ChildNodes['description'].Text;
    Content := Node.ChildNodes['content:encoded'].Text;

    if VarIsNull(ArticlesBS.DataSet.Lookup('Link', VarArrayOf([Link]), 'Id')) then
      ArticlesBS.DataSet.AppendRecord([nil, Title, Desc, Content, Link,  nil, StrInternetToDateTime(Node.ChildNodes['pubDate'].Text), id]);
    Node := Node.NextSibling;
  until Node = nil;

  EndLoad;
end;

procedure TMainForm.ArticlesListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ArticlesBS.DataSet.RecNo := ArticlesList.ItemIndex + 1;

{$IFDEF MSWINDOWS}
  SetPermissions;
{$ENDIF}
  WebBrowser.LoadFromStrings ('<meta charset="UTF-8" />' + #13#10 + ArticlesBS.DataSet.FieldByName('contenet').AsString, TEncoding.UTF8, 'about:blank');

  IsEmptyURL := False;
end;

procedure TMainForm.ArticlesListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if AItem.ImageIndex <> 0 then
    AItem.ImageIndex := 0;
end;

procedure TMainForm.ConnectionButtonClick(Sender: TObject);
begin
  if MultiView.IsShowed then
    MultiView.HideMaster
  else
    MultiView.ShowMaster;
end;

procedure TMainForm.ConnectButtonClick(Sender: TObject);
begin
  with DM.FDConnection1.Params as TFDPhysPgConnectionDefParams do begin
    Server := Edit1.Text;
    Password := Edit2.Text;
    UserName := Edit3.Text;
    Password := Edit4.Text;
    Database := Edit5.Text;
  end;
  DM.FDConnection1.Connected := True;
  DM.ChannelsQuery.Open;
  DM.ArticlesQuery.Open;
  MultiView.HideMaster;
end;

procedure TMainForm.ColorButtonClick(Sender: TObject);
begin
  if MainForm.StyleBook = WhiteStyle then
    MainForm.StyleBook := BlackStyle
  else
    MainForm.StyleBook := WhiteStyle;
  if IsEmptyURL then
   LoadEmptyUrl;
end;

procedure TMainForm.ChannelsListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  LoadEmptyUrl;
  ChannelsBS.DataSet.RecNo := ChannelsList.ItemIndex + 1;
  if ChannelsBS.DataSet.FieldByName('Id').AsInteger = 0 then
    dm.ArticlesQuery.SQL.Text := SelectAllArticles
  else begin
    dm.ArticlesQuery.SQL.Text := SelectArticles;
    dm.ArticlesQuery.ParamByName('channel').AsInteger := ChannelsBS.DataSet.FieldByName('Id').AsInteger;
    dm.ArticlesQuery.Prepare;
  end;
  dm.ArticlesQuery.Open;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadEmptyUrl;
end;

procedure TMainForm.RefreshButtonClick(Sender: TObject);
begin
  ChannelsBS.DataSet.Open;
  if (ChannelsList.ItemIndex <> -1) and (ChannelsBS.DataSet.FieldByName('Link').AsString <> 'All feed') then begin
    ChannelsBS.DataSet.RecNo := (ChannelsList.ItemIndex div 2) + 1;
    ChannelsBS.DataSet.FieldByName('Id').AsInteger;
    ChannelsBS.DataSet.FieldByName('Link').AsString;
    ImportFeed(ChannelsBS.DataSet.FieldByName('Link').AsString, ChannelsBS.DataSet.FieldByName('Id').AsInteger);
  end;
end;

procedure TMainForm.WebBrowserDidFailLoadWithError(ASender: TObject);
begin
  EndLoad;
end;

procedure TMainForm.WebBrowserDidFinishLoad(ASender: TObject);
begin
  EndLoad;
end;

procedure TMainForm.WebBrowserDidStartLoad(ASender: TObject);
begin
  BeginLoad;
end;

end.
