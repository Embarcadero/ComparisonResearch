unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.BaseImageCollection,
  Vcl.ImageCollection, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList;

type
  TForm1 = class(TForm)
    SplitView1: TSplitView;
    ListView1: TListView;
    Image1: TImage;
    SearchBox1: TSearchBox;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  SplitView1.Opened := not SplitView1.Opened;
end;

end.
