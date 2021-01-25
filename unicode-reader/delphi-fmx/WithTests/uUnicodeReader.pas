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
  System.Diagnostics, System.TimeSpan, FMX.DialogService, System.IOUtils,
  System.ImageList, FMX.ImgList, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TMainForm = class(TForm)
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    StatusLabel: TLabel;
    RefreshButton: TButton;
    BlackStyle: TStyleBook;
    LightStyle: TStyleBook;
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
    Label5: TLabel;
    Label4: TLabel;
    ServerEdit: TEdit;
    PortEdit: TEdit;
    UserEdit: TEdit;
    PasswordEdit: TEdit;
    DatabaseEdit: TEdit;
    Label3: TLabel;
    ConnectionButton: TButton;
    LinkListControlToField1: TLinkListControlToField;
    LinkListControlToField2: TLinkListControlToField;
    ImageList1: TImageList;
    RecreateButton: TButton;
    StorageTestButton: TButton;
    StorageTestEdit: TEdit;
    OpenDialog: TOpenDialog;
    ScriptFileNameButton: TButton;
    RetrievalTestEdit: TEdit;
    RetrievalTestButton: TButton;
    procedure ColorButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure ChannelsListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ArticlesListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ConnectionButtonClick(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ArticlesListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure RecreateButtonClick(Sender: TObject);
    procedure StorageTestButtonClick(Sender: TObject);
    procedure ScriptFileNameButtonClick(Sender: TObject);
    procedure RetrievalTestButtonClick(Sender: TObject);
    procedure NetValidateServerCertificate(const Sender: TObject;
      const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
  private
    { Private declarations }
    IsEmptyURL: boolean;
    IsTesting: boolean;
    FStopwatch: TStopwatch;
    FElapsed: TTimeSpan;
    procedure BeginLoad;
    procedure EndLoad;
    procedure LoadURL(IsEmpty: boolean = False);
    procedure ImportFeed(const Name: string; id: integer);

    function CheckConnection: boolean;
    function CheckScriptFileName: boolean;

    procedure StartTimer;
    procedure StopTimer;
    procedure BeforeTest(Edit: TEdit);
    procedure AfterTest(Edit: TEdit); overload;
    procedure AfterTest; overload;
    procedure StorageTest;
    procedure RetrievalTest;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  ErrorStr: string;
  FS: TFileStream;
  i: integer;

implementation

{$R *.fmx}
uses
{$IFDEF MSWINDOWS}
  Registry,
{$ENDIF}
  System.StrUtils, IdGlobalProtocols,
  FireDAC.Stan.Param, Data.DB, FireDAC.Phys.PGDef, uDM;

const
  SelectAllArticles = 'select * from  articles order by id';
  SelectAllArticlesChannles = 'select c.description as "Channel Name", c.link as "Channel Link",' +
    'a.title as "Article Title", a.link as "Article Link", a.timestamp as "Date", ' +
    'a.content as "Article content" from articles a, channels c where a.channel =  c.id order by "Date" DESC';
  SelectArticles = 'select * from  articles where channel = :channel order by id';
  DarkThemeURL = '<body style="padding: 25px; background-color: #20262f">';
  LightThemeURL = '<body style="padding: 25px; background-color: #ffffff">';
  RetrievalHTMLBegin =
    '<html>' + #13#10 +
    '<head>' + #13#10 +
    '<title>Combined RSS Feeds</title>' + #13#10 +
    '</head>' + #13#10 +
    '<body>';
  RetrievalHTMLEnd =
    '</body>' + #13#10 +
    '</html>';
  RetrievalHTMLText =
    '<h2><a href="%s">%s</a> - <a href="%s">%s</a></h2>' + #13#10 +
    '<h3>%s</h3>' + #13#10 +
    '<p>%s</p>' + #13#10 +
    '<br>' + #13#10 +
    '<hr>';

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
  if not IsTesting then
    StatusLabel.Text := 'Loading...';
  Application.ProcessMessages;
end;

procedure TMainForm.RecreateButtonClick(Sender: TObject);
begin
  if not CheckConnection then
    Exit;

  if not CheckScriptFileName then
    Exit;

  TDialogService.MessageDialog('This operation will delete data. Are you sure?', TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0, procedure(const AResult: TModalResult)
  begin
    if (AResult = mrYes) then
      begin
        DM.FDScript.ExecuteAll;
        DM.ArticlesQuery.Refresh;
        DM.ChannelsQuery.Refresh;
        LoadURL(True);
      end;
  end);
end;

procedure TMainForm.StorageTestButtonClick(Sender: TObject);
begin
  StorageTest;
end;

procedure TMainForm.EndLoad;
begin
  if not IsTesting then
    StatusLabel.Text := '';
end;

procedure TMainForm.LoadURL(IsEmpty: boolean = False);
var
  FontColor, StyleStr: string;
begin
{$IFDEF MSWINDOWS}
  SetPermissions;
{$ENDIF}

  if MainForm.StyleBook = BlackStyle then begin
    FontColor := '"#ffffff"';
    StyleStr := DarkThemeURL;
  end
  else begin
    FontColor := '"#000000"';
    StyleStr := LightThemeURL;
  end;

  if not IsEmpty then begin
    ArticlesBS.DataSet.RecNo := ArticlesList.ItemIndex + 1;

    WebBrowser.LoadFromStrings(StyleStr + #13#10 +
      '<meta charset="UTF-8" />' + #13#10 + '<font color=' + FontColor + '>' +  #13#10 +
      ArticlesBS.DataSet.FieldByName('content').AsString + '</font>',
      TEncoding.UTF8, 'about:blank');

    IsEmptyURL := False;
  end
  else begin
    WebBrowser.LoadFromStrings(StyleStr, 'about:blank');
    IsEmptyURL := True;
  end;
end;

procedure TMainForm.NetValidateServerCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
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
    XMLDocument.LoadFromStream(Stream, xetUTF_8);
  finally
    Stream.Free;
  end;

  XMLDocument.Active := True;

  StartItemNode := XMLDocument.DocumentElement.ChildNodes.First.ChildNodes.FindNode('item') ;
  Node := StartItemNode;
  if Node <> nil then
    repeat
      Title := Node.ChildNodes['title'].Text;
      Link := Node.ChildNodes['link'].Text;
      Desc := Node.ChildNodes['description'].Text;
      if Node.ChildNodes.FindNode('content:encoded') <> nil then
        Content := Node.ChildNodes['content:encoded'].Text
      else
        Content := '';

      if VarIsNull(ArticlesBS.DataSet.Lookup('Link', VarArrayOf([Link]), 'Id')) then
        ArticlesBS.DataSet.AppendRecord([nil, Title, Desc, Content, Link,  nil, StrInternetToDateTime(Node.ChildNodes['pubDate'].Text), id]);
      Node := Node.NextSibling;
    until Node = nil;

  EndLoad;
end;

function TMainForm.CheckConnection: boolean;
begin
  Result := DM.FDConnection.Connected;
  if not Result then
    if not MultiView.IsShowed then
      MultiView.ShowMaster;
end;

function TMainForm.CheckScriptFileName: boolean;
begin
  if DM.FDScript.SQLScriptFileName = '' then
    if OpenDialog.Execute then
      DM.FDScript.SQLScriptFileName := OpenDialog.FileName;

  Result := DM.FDScript.SQLScriptFileName <> '';
  ScriptFileNameButton.Hint := 'Current file name: ' + DM.FDScript.SQLScriptFileName;
  if DM.FDScript.SQLScriptFileName = '' then
    ShowMessage('Please set the name of the script file');
end;

procedure TMainForm.ScriptFileNameButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    DM.FDScript.SQLScriptFileName := OpenDialog.FileName;
  ScriptFileNameButton.Hint := 'Current file name: ' + DM.FDScript.SQLScriptFileName;
end;

procedure TMainForm.StartTimer;
begin
  FStopwatch := TStopwatch.StartNew;
end;

procedure TMainForm.StopTimer;
begin
  FElapsed := FStopwatch.Elapsed;
end;

procedure TMainForm.BeforeTest(Edit: TEdit);
begin
  LoadURL(True);
  IsTesting := True;
  ErrorStr := '';
  StatusLabel.Text := 'Testing...';
  Application.ProcessMessages;
  Edit.Text := '00h:00m:00s:000ms';
  DM.ChannelsQuery.Close;
  DM.ArticlesQuery.Close;
  DM.ChannelsQuery.DisableControls;
  DM.ArticlesQuery.DisableControls;
end;

procedure TMainForm.AfterTest(Edit: TEdit);
begin
  StopTimer;
  Edit.Text := Format('%.2dh:%.2dm:%.2ds:%.3dms', [FElapsed.Hours, FElapsed.Minutes, FElapsed.Seconds, FElapsed.Milliseconds]);

  IsTesting := False;
  if ErrorStr = '' then
    StatusLabel.Text := 'Testing completed'
  else
    StatusLabel.Text := 'Testing completed with errors. Feeds with errors: ' + ErrorStr;
end;

procedure TMainForm.AfterTest;
begin
  Application.ProcessMessages;
  DM.ChannelsQuery.EnableControls;
  DM.ArticlesQuery.EnableControls;
end;

procedure TMainForm.StorageTest;
begin
  if not CheckConnection then
    Exit;

  if not CheckScriptFileName then
    Exit;

  BeforeTest(StorageTestEdit);
  try
    DM.FDScript.ExecuteAll;

    DM.ChannelsQuery.Open;
    DM.ChannelsQuery.First;

    DM.ArticlesQuery.SQL.Text := SelectArticles;
    DM.ArticlesQuery.ParamByName('channel').DataType := ftInteger;
    DM.ArticlesQuery.Prepare;

    StartTimer;
    try
      if DM.ChannelsQuery.Eof then
        Exit;

      repeat
        if DM.ChannelsQuery.FieldByName('Id').AsInteger = 0 then begin
          DM.ChannelsQuery.Next;
          Continue;
        end;

        DM.ArticlesQuery.ParamByName('channel').AsInteger := DM.ChannelsQuery.FieldByName('Id').AsInteger;
        DM.ArticlesQuery.Open;
        try
          ImportFeed(DM.ChannelsQuery.FieldByName('Link').AsString, DM.ChannelsQuery.FieldByName('Id').AsInteger);
        except
          if ErrorStr = '' then
            ErrorStr := DM.ChannelsQuery.FieldByName('description').AsString
          else
            ErrorStr := ErrorStr + ', ' + DM.ChannelsQuery.FieldByName('title').AsString;
        end;
        DM.ChannelsQuery.Next;
      until DM.ChannelsQuery.Eof;
    finally
      AfterTest(StorageTestEdit);
    end;
  finally
    AfterTest;
  end;
end;

procedure TMainForm.RetrievalTest;
var
  s: string;
  Bytes: TBytes;
begin
  if not CheckConnection then
    Exit;

  BeforeTest(RetrievalTestEdit);
  FS := TFileStream.Create(ExtractFilePath(ParamStr(0))+ 'combinedRSS.html', fmCreate or fmOpenWrite);
  s := RetrievalHTMLBegin;

  Bytes := TEncoding.UTF8.GetBytes(RetrievalHTMLBegin);
  fs.Write(Bytes, Length(Bytes));
  try

    DM.ArticlesQuery.SQL.Text := SelectAllArticlesChannles;
    DM.ArticlesQuery.Open;

    StartTimer;
    try
      if DM.ArticlesQuery.Eof then
        Exit;

      repeat
          s := Format(RetrievalHTMLText,
            [DM.ArticlesQuery.FieldByName('Channel Link').AsString,
             DM.ArticlesQuery.FieldByName('Channel Name').AsString,
             DM.ArticlesQuery.FieldByName('Article Link').AsString,
             DM.ArticlesQuery.FieldByName('Article Title').AsString,
             DM.ArticlesQuery.FieldByName('Date').AsString,
             DM.ArticlesQuery.FieldByName('Article content').AsString
            ]);
          fs.Write(TEncoding.UTF8.GetBytes(s), Length(TEncoding.UTF8.GetBytes(s)));
        DM.ArticlesQuery.Next;
      until DM.ArticlesQuery.Eof;
    finally
      AfterTest(RetrievalTestEdit);
      FS.Free;
    end;
  finally
    DM.ChannelsQuery.Open;
    DM.ArticlesQuery.SQL.Text := SelectAllArticles;
    DM.ArticlesQuery.Open;
    AfterTest;
  end;
end;

procedure TMainForm.RetrievalTestButtonClick(Sender: TObject);
begin
  RetrievalTest;
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
  MultiView.HideMaster;
end;

procedure TMainForm.ColorButtonClick(Sender: TObject);
begin
  BeginLoad;
  try
    if MainForm.StyleBook = LightStyle then
      MainForm.StyleBook := BlackStyle
    else
      MainForm.StyleBook := LightStyle;
    if IsEmptyURL then
      LoadURL(True)
    else
      LoadURL;
  finally
    EndLoad;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadURL(True);
end;

procedure TMainForm.ChannelsListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  BeginLoad;
  try
    LoadURL(True);
    ChannelsBS.DataSet.RecNo := ChannelsList.ItemIndex + 1;
    if ChannelsBS.DataSet.FieldByName('Id').AsInteger = 0 then
      dm.ArticlesQuery.SQL.Text := SelectAllArticles
    else begin
      dm.ArticlesQuery.SQL.Text := SelectArticles;
      dm.ArticlesQuery.ParamByName('channel').DataType := ftInteger;
      dm.ArticlesQuery.Prepare;
      dm.ArticlesQuery.ParamByName('channel').AsInteger := ChannelsBS.DataSet.FieldByName('Id').AsInteger;
    end;
    dm.ArticlesQuery.Open;
  finally
    EndLoad;
  end;
end;

procedure TMainForm.ArticlesListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  BeginLoad;
  try
    LoadURL;
  finally
    EndLoad;
  end;
end;

procedure TMainForm.RefreshButtonClick(Sender: TObject);
begin
  BeginLoad;
  try
    ChannelsBS.DataSet.Open;
    if (ChannelsList.ItemIndex <> -1) and (ChannelsBS.DataSet.FieldByName('Link').AsString <> 'All feed') then begin
      ChannelsBS.DataSet.RecNo := ChannelsList.ItemIndex  + 1;
      ArticlesBS.DataSet.Refresh;
      ImportFeed(ChannelsBS.DataSet.FieldByName('Link').AsString, ChannelsBS.DataSet.FieldByName('Id').AsInteger);
      ArticlesBS.DataSet.Refresh;
    end;
  finally
    EndLoad;
  end;
end;

end.
