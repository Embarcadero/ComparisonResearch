unit uMain;

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
    MenuItem1: TMenuItem;
    Layout1: TLayout;
    Edit1: TEdit;
    Edit2: TEdit;
    Layout2: TLayout;
    Folders: TTreeView;
    Splitter1: TSplitter;
    Layout3: TLayout;
    Header1: THeader;
    Grid1: TGrid;
    hiName: THeaderItem;
    hiDateModified: THeaderItem;
    hiType: THeaderItem;
    hiSize: THeaderItem;
    Layout4: TLayout;
    TabControl1: TTabControl;
    tiWindows: TTabItem;
    tiDesktop: TTabItem;
    btnNewTab: TSpeedButton;
    procedure FormCreate(Sender: TObject);
  private
    function AddFolderToTreeView(Path: string; Parent: TFmxObject): TTreeViewItem;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

uses
  System.IOUtils,
  uDM;

type
  TExpandableTreeViewItem = class(FMX.TreeView.TTreeViewItem)
    private
      FOnExpanded: TNotifyEvent;
      FOnCollapsed: TNotifyEvent;
      FPath: string;
    protected
      procedure SetIsExpanded(const Value: Boolean); override;
    published
      property OnExpanded: TNotifyEvent read FOnExpanded write FOnExpanded;
      property OnCollapsed: TNotifyEvent read FOnCollapsed write FOnCollapsed;
  end;


procedure TExpandableTreeViewItem.SetIsExpanded(const Value: Boolean);
var
  LWasExpanded: boolean;
begin
  LWasExpanded := IsExpanded;
  inherited;
  if (IsExpanded) AND (LWasExpanded = false) then
    if Assigned(OnExpanded) then
      OnExpanded(Self)
    else
  else
    if Assigned(OnCollapsed) then
      OnCollapsed(Self);
end;

function TForm3.AddFolderToTreeView(Path: string;
  Parent: TFmxObject): TTreeViewItem;
var
  Item: TExpandableTreeViewItem absolute Result;
begin
  Result:= TExpandableTreeViewItem.Create(Folders);

  if Path <> PathDelim then
    Result.Text := TPath.GetFileName(Path)
  else
    Result.Text := Path;

  Result.Parent := Parent;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  AddFolderToTreeView('\', Folders);
end;

end.
