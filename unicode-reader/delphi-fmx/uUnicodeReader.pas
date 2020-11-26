unit uUnicodeReader;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.WebBrowser, FMX.ListView, FMX.Edit,
  FMX.MultiView, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, System.ImageList, FMX.ImgList;

type
  TMainForm = class(TForm)
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    ConnectionButton: TButton;
    RefreshButton: TButton;
    ThemeButton: TButton;
    StatusLabel: TLabel;
    ChannelsList: TListView;
    Splitter1: TSplitter;
    ArticlesList: TListView;
    Splitter2: TSplitter;
    WebBrowser: TWebBrowser;
    MultiView: TMultiView;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ServerEdit: TEdit;
    PortEdit: TEdit;
    UserEdit: TEdit;
    PasswordEdit: TEdit;
    DatabaseEdit: TEdit;
    ConnectButton: TButton;
    ChannelsBS: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    ArticlesBS: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    ImageList1: TImageList;
    Net: TNetHTTPClient;
    XMLDocument: TXMLDocument;
    LightStyle: TStyleBook;
    BlackStyle: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure ThemeButtonClick(Sender: TObject);
    procedure ChannelsListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ConnectionButtonClick(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure ChannelsListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure RefreshButtonClick(Sender: TObject);
    procedure ArticlesListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure WebBrowserDidFailLoadWithError(ASender: TObject);
    procedure WebBrowserDidFinishLoad(ASender: TObject);
    procedure WebBrowserDidStartLoad(ASender: TObject);
  private
    { Private declarations }
    IsEmptyURL: boolean;
    procedure BeginLoad;
    procedure EndLoad;
    procedure LoadEmptyURL;
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
  SelectAllArticles = 'select * from articles order by id';
  SelectArticles = 'select * from articles where channel = :channel order by id';
  DarkThemeURL = '<body style="padding: 25px; background-color: #20262f">';
  LightThemeURL = '<body style="padding: 25px; background-color: #ffffff">';

{$IFDEF MSWINDOWS}
procedure SetPermissions;
const
  cHomePath = 'SOFTWARE';
  cFeatureBrowserEmulation = 'Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMALATION';
  cIE11 = 11001;
var
  Reg: TRegIniFile;
  sKey: string;
begin
  sKey := ExtractFileName(Paramstr(0));
  Reg := TRegIniFile.Create(cHomePath);
  try
    if Reg.OpenKey(cFeatureBrowserEmulation, True) and
      not (TRegistry(Reg).KeyExists(sKey) and (TRegistry(Reg).ReadInteger(sKey) = cIE11))
    then
      TRegistry(Reg).WriteInteger(sKey, cIE11);
  finally
    Reg.Free;
  end;
end;
{$ENDIF}

procedure TMainForm.ArticlesListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ArticlesBS.DataSet.RecNo := ArticlesList.ItemIndex + 1;

{$IFDEF MSWINDOWS}
  SetPermissions;
{$ENDIF}
  WebBrowser.LoadFromStrings('<meta charset="UTF-8" />' + #13#10 +
    ArticlesBS.DataSet.FieldByName('content').AsString, TEncoding.UTF8, 'about:blank');

  IsEmptyURL := False;
end;

procedure TMainForm.BeginLoad;
begin
  StatusLabel.Text := 'Loading...';
end;

procedure TMainForm.ChannelsListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  LoadEmptyURL;
  ChannelsBS.DataSet.RecNo := ChannelsList.ItemIndex + 1;
  if ChannelsBS.DataSet.FieldByName('Id').AsInteger = 0 then
    DM.ArticlesQuery.SQL.Text := SelectAllArticles
  else begin
    DM.ArticlesQuery.SQL.Text := SelectArticles;
    DM.ArticlesQuery.ParamByName('channel').AsInteger := ChannelsBS.DataSet.FieldByName('Id').AsInteger;
    DM.ArticlesQuery.Prepare;
  end;
    DM.ArticlesQuery.Open;
end;

procedure TMainForm.ChannelsListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if AItem.ImageIndex <> 0 then
    AItem.ImageIndex := 0;
end;

procedure TMainForm.ConnectButtonClick(Sender: TObject);
begin
  with DM.FDConnection.Params as TFDPhysPGConnectionDefParams do begin
    Server := ServerEdit.Text;
    Port := StrToInt(PortEdit.Text);
    UserName := UserEdit.Text;
    Password := PasswordEdit.Text;
    Database := DatabaseEdit.Text;
  end;
  DM.FDConnection.Connected := True;
  DM.ChannelsQuery.Open;
  DM.ArticlesQuery.Open;
  MultiView.HideMaster;
end;

procedure TMainForm.ConnectionButtonClick(Sender: TObject);
begin
  if MultiView.IsShowed then
    MultiView.HideMaster
  else
    MultiView.ShowMaster;
end;

procedure TMainForm.EndLoad;
begin
  StatusLabel.Text := '';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadEmptyURL;
end;

procedure TMainForm.LoadEmptyURL;
begin
{$IFDEF MSWINDOWS}
  SetPermissions;
{$ENDIF}
  if MainForm.StyleBook = BlackStyle then
    WebBrowser.LoadFromStrings(DarkThemeURL, 'about:blanck')
  else
    WebBrowser.LoadFromStrings(LightThemeURL, 'about:blanck');
  IsEmptyURL := True;
end;

procedure TMainForm.RefreshButtonClick(Sender: TObject);
begin
  ChannelsBS.DataSet.Open;
  if (ChannelsList.ItemIndex <> -1) and (ChannelsBS.DataSet.FieldByName('link').AsString <> 'All feed') then begin
    ChannelsBS.DataSet.RecNo := ChannelsList.ItemIndex + 1;
    ArticlesBS.DataSet.Refresh;
    ImportFeed(ChannelsBS.DataSet.FieldByName('Link').AsString, ChannelsBS.DataSet.FieldByName('Id').AsInteger);
  end;
end;

procedure TMainForm.ThemeButtonClick(Sender: TObject);
begin
  if MainForm.StyleBook = LightStyle then
    MainForm.StyleBook := BlackStyle
  else
    MainForm.StyleBook := LightStyle;
  if IsEmptyURL then
    LoadEmptyURL;
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
    Stream.Free
  end;

  XMLDocument.Active := True;

  StartItemNode := XMLDocument.DocumentElement.ChildNodes.First.ChildNodes.FindNode('item');
  Node := StartItemNode;
  repeat
    Title := Node.ChildNodes['title'].Text;
    Link := Node.ChildNodes['link'].Text;
    Desc := Node.ChildNodes['description'].Text;
    Content := Node.ChildNodes['content:encoded'].Text;

    if VarIsNull(ArticlesBS.DataSet.Lookup('Link', VarArrayOf([Link]), 'id')) then
      ArticlesBS.DataSet.AppendRecord([nil, Title, Desc, Content, Link, nil, StrInternetToDateTime(Node.ChildNodes['pubDate'].Text), id]);
    Node := Node.NextSibling;
  until Node = nil;

  EndLoad;
end;

end.
