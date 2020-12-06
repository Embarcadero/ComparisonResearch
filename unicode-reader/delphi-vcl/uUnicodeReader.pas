unit uUnicodeReader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.OleCtrls, SHDocVw, Vcl.WinXCtrls, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  System.ImageList, Vcl.ImgList, Data.Bind.DBScope, Xml.xmldom, Xml.XMLIntf,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  Xml.XMLDoc;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    ConnectionButton: TButton;
    StatusBar1: TStatusBar;
    RefreshButton: TButton;
    ThemeButton: TButton;
    ChannelsList: TListView;
    Splitter1: TSplitter;
    ArticlesList: TListView;
    Splitter2: TSplitter;
    SplitView: TSplitView;
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
    WebBrowser: TWebBrowser;
    XMLDocument: TXMLDocument;
    Net: TNetHTTPClient;
    ClearButton: TButton;
    procedure ThemeButtonClick(Sender: TObject);
    procedure ConnectionButtonClick(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure ChannelsDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure RefreshButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ChannelsListClick(Sender: TObject);
    procedure ArticlesListClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
  private
    { Private declarations }
    IsEmptyURL: boolean;
    procedure CMStyleChanged(var Message: TMessage); message CM_STYLECHANGED;
    procedure WMMeasureItem(var AMsg: TWMMeasureItem); message WM_MEASUREITEM;
    procedure BeginLoad;
    procedure EndLoad;
    procedure LoadURL(IsEmpty: boolean = False);
    procedure ImportFeed(const Name: string; id: integer);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
uses
  Vcl.Themes, Vcl.Styles,
  Registry,
  System.StrUtils, System.UITypes, IdGlobalProtocols,
  FireDAC.Stan.Param, FireDAC.Phys.PGDef, uDM;

const
  SelectAllArticles = 'select * from  articles order by id';
  SelectArticles = 'select * from  articles where channel = :channel order by id';
  DarkThemeName = 'Windows10 Blue Whale';
  LightThemeName = 'Puerto Rico';
  DarkThemeBgColor = $202f46;
  LightThemeBgColor = $ffffff;

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

procedure TMainForm.CMStyleChanged(var Message: TMessage);
begin
  if IsEmptyURL then
    LoadURL(True)
  else
    LoadURL;
end;

procedure TMainForm.WMMeasureItem(var AMsg: TWMMeasureItem);
begin
  inherited;
  if (AMsg.IDCtl = ChannelsList.Handle) or (AMsg.IDCtl = ArticlesList.Handle) then
    AMsg.MeasureItemStruct^.itemHeight := 40;
end;

procedure TMainForm.BeginLoad;
begin
  StatusBar1.Panels[1].Text := 'Loading...';
  Application.ProcessMessages;
end;

procedure TMainForm.EndLoad;
begin
  StatusBar1.Panels[1].Text := '';
end;

procedure TMainForm.LoadURL(IsEmpty: boolean = False);
var
  Doc : Variant;
  FontColor: string;
begin
  SetPermissions;

  WebBrowser.Navigate('about:blank');
  while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
   Application.ProcessMessages;

  Doc := WebBrowser.OleObject.Document;
  if TVarData(Doc).VDispatch = nil then
    Doc := WebBrowser.OleObject.Document;
  if TVarData(Doc).VDispatch <> nil then begin
    if not IsEmpty then begin
      ArticlesBS.DataSet.RecNo := ArticlesList.ItemIndex + 1;

      if TStyleManager.ActiveStyle.Name = DarkThemeName then
        FontColor := '"#ffffff"'
      else
        FontColor := '"#000000"';

      Doc.open('text/html', 'replace');
      Doc.Write('<meta charset="UTF-8" />' + #13#10 + '<font color=' + FontColor + '>' +  #13#10 +
        ArticlesBS.DataSet.FieldByName('content').AsString + '</font>');

      Doc.Close;
      IsEmptyURL := False;
    end
    else
      IsEmptyURL := True;

    if TStyleManager.ActiveStyle.Name = DarkThemeName then
      Doc.bgColor  := DarkThemeBgColor
    else
      Doc.bgColor := LightThemeBgColor;
  end;
end;

procedure TMainForm.ImportFeed(const Name: string; id: integer);
var
  Stream: TStream;
  StartItemNode: IXMLNode;
  Node: IXMLNode;
  Content, Title, Desc, Link: string;
begin
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
end;

procedure TMainForm.ArticlesListClick(Sender: TObject);
begin
  if DM.FDConnection.Connected then begin
    BeginLoad;
    try
      LoadURL;
    finally
      EndLoad;
    end;
  end;
end;

procedure TMainForm.ConnectionButtonClick(Sender: TObject);
begin
  if SplitView.Opened then
    SplitView.Close
  else
    SplitView.Open;
end;

procedure TMainForm.RefreshButtonClick(Sender: TObject);
begin
  BeginLoad;
  try
    ChannelsBS.DataSet.Open;
    if (ChannelsList.ItemIndex <> -1) and (ChannelsBS.DataSet.FieldByName('link').AsString <> 'All feed') then begin
      ChannelsBS.DataSet.RecNo := ChannelsList.ItemIndex + 1;
      ArticlesBS.DataSet.Refresh;
      ImportFeed(ChannelsBS.DataSet.FieldByName('Link').AsString, ChannelsBS.DataSet.FieldByName('Id').AsInteger);
    end;
  finally
    EndLoad;
  end;
end;

procedure TMainForm.ThemeButtonClick(Sender: TObject);
begin
  if TStyleManager.ActiveStyle.Name = DarkThemeName then
    TStyleManager.TrySetStyle(LightThemeName)
  else
    TStyleManager.TrySetStyle(DarkThemeName);
end;

procedure TMainForm.ClearButtonClick(Sender: TObject);
begin
  if not DM.FDConnection.Connected then
    ShowMessage('You are not connected to the server. Please connect to the server!')
  else begin
    if MessageDlg('This operation will clear all data. Are you sure?',
      mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes
    then begin
      DM.FDScript.ExecuteAll;
      ArticlesBS.DataSet.Refresh;
    end;
  end;
end;

procedure TMainForm.ConnectButtonClick(Sender: TObject);
begin
  StatusBar1.Panels[1].Text := 'Connecting to server...';
  Application.ProcessMessages;
  try
  with DM.FDConnection.Params as TFDPhysPgConnectionDefParams do begin
    Server := ServerEdit.Text;
    Port := StrToInt(PortEdit.Text);
    UserName := UserEdit.Text;
    Password := PasswordEdit.Text;
    Database := DatabaseEdit.Text;
  end;
  DM.FDConnection.Connected := True;
  DM.ChannelsQuery.Open;
  DM.ArticlesQuery.Open;
  SplitView.Close;
  StatusBar1.Panels[0].Text := 'Server connected';
  StatusBar1.Panels[0].Width := StatusBar1.Canvas.TextWidth(StatusBar1.Panels[0].Text) + 16;;
  finally
    StatusBar1.Panels[1].Text := '';
  end;
end;

procedure TMainForm.ChannelsDrawItem(Sender: TCustomListView; Item: TListItem;
  Rect: TRect; State: TOwnerDrawState);
var
  BrushColor, BrushSelectColor, FontColor: TColor;
begin
  if TStyleManager.ActiveStyle.Name = LightThemeName then begin
    BrushColor := clWhite;
    BrushSelectColor := RGB(115, 213, 202);
    FontColor := clBlack;
  end
  else begin
    BrushColor := RGB(32, 47, 70);
    BrushSelectColor := RGB(0, 161, 161);
    FontColor := clWhite;
  end;

  if odSelected in State then
    Sender.Canvas.Brush.Color := BrushSelectColor
  else
    Sender.Canvas.Brush.Color := BrushColor;

  Sender.Canvas.Font.Color := FontColor;
  Sender.Canvas.FillRect(Rect);
  Imagelist1.Draw(Sender.Canvas, Rect.Left, Rect.Top, 0);
  Rect := Bounds(Rect.Left + 30, Rect.Top + 2, Rect.Width, Rect.Height);
  DrawText(Sender.Canvas.Handle, PChar(' ' + Item.Caption + #13#10 + '     ' + Item.SubItems[0]),
    -1, Rect, DT_LEFT);
end;

procedure TMainForm.ChannelsListClick(Sender: TObject);
begin
  if DM.FDConnection.Connected then begin
    BeginLoad;
    try
      LoadURL(True);
      ChannelsBS.DataSet.RecNo := ChannelsList.ItemIndex + 1;
      if ChannelsBS.DataSet.FieldByName('Id').AsInteger = 0 then
        dm.ArticlesQuery.SQL.Text := SelectAllArticles
      else begin
        dm.ArticlesQuery.SQL.Text := SelectArticles;
        dm.ArticlesQuery.ParamByName('channel').AsInteger := ChannelsBS.DataSet.FieldByName('Id').AsInteger;
        dm.ArticlesQuery.Prepare;
      end;
      dm.ArticlesQuery.Open;
    finally
      EndLoad;
    end;
  end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  LoadURL(True);
  SplitView.OpenedWidth := ChannelsList.Width;
end;

end.


