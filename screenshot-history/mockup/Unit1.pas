unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.VirtualImage,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ImageCollection1: TImageCollection;
    VirtualImage1: TVirtualImage;
    VirtualImage2: TVirtualImage;
    VirtualImage3: TVirtualImage;
    VirtualImage4: TVirtualImage;
    Button1: TButton;
    ScrollBar1: TScrollBar;
    FlowPanel1: TFlowPanel;
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
