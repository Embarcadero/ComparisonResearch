unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw,
  Vcl.BaseImageCollection, Vcl.ImageCollection, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.TitleBarCtrls, Vcl.VirtualImage;

type
  TForm1 = class(TForm)
    SplitView1: TSplitView;
    SearchBox1: TSearchBox;
    ListBox1: TListBox;
    ListView1: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    WebBrowser1: TWebBrowser;
    Label2: TLabel;
    Timer1: TTimer;
    TitleBarPanel1: TTitleBarPanel;
    VirtualImage1: TVirtualImage;
    VirtualImage2: TVirtualImage;
    Label1: TLabel;
    VirtualImage3: TVirtualImage;
    procedure Timer1Timer(Sender: TObject);
    procedure VirtualImage2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Registry;

{$IFDEF MSWINDOWS}
procedure SetPermissions;
const
  cHomePath = 'SOFTWARE';
  cFeatureBrowserEmulation =
    'Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\';
  cIE11 = 11001;

var
  Reg: TRegIniFile;
  sKey: string;
begin

  sKey := ExtractFileName(ParamStr(0));
  Reg := TRegIniFile.Create(cHomePath);
  try
    if Reg.OpenKey(cFeatureBrowserEmulation, True) and
      not(TRegistry(Reg).KeyExists(sKey) and (TRegistry(Reg).ReadInteger(sKey)
      = cIE11)) then
      TRegistry(Reg).WriteInteger(sKey, cIE11);
  finally
    Reg.Free;
  end;

end;
{$ENDIF}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled := False;
{$IFDEF MSWINDOWS}
  SetPermissions;
{$ENDIF}
WebBrowser1.Navigate('https://learndelphi.org/code-faster-in-delphi/');
end;

procedure TForm1.VirtualImage2Click(Sender: TObject);
begin
  SplitView1.Opened := not SplitView1.Opened;
end;

end.
