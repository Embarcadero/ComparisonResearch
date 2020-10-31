unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, System.Actions,
  FMX.ActnList, FMX.StdActns, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, FMX.Header, FMX.StdCtrls, FMX.TreeView, FMX.TabControl;

type
  TForm3 = class(TForm)
    WinMenu: TMenuBar;
    WinMenuFile: TMenuItem;
    WinMenuRun: TMenuItem;
    WinMenuBrowseForFolder: TMenuItem;
    WinMenuEdit: TMenuItem;
    WinMenuCopy: TMenuItem;
    WinMenuWindow: TMenuItem;
    WinMenuArrange: TMenuItem;
    ActionList1: TActionList;
    MenuItem1: TMenuItem;
    Layout1: TLayout;
    Edit1: TEdit;
    FileExit1: TFileExit;
    Edit2: TEdit;
    Layout2: TLayout;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    Layout3: TLayout;
    Header1: THeader;
    Grid1: TGrid;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

end.
