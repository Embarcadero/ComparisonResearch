unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, System.Actions,
  FMX.ActnList, FMX.StdActns, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, FMX.Header, FMX.StdCtrls, FMX.TreeView, FMX.TabControl;

type
  TExpandableTreeViewItem = class(FMX.TreeView.TTreeViewItem)
    private
      FOnExpanded: TNotifyEvent;
      FPath: string;
      procedure SetPath(const Value: string);
      property Path: string read FPath write SetPath;
    protected
      procedure SetIsExpanded(const Value: Boolean); override;
    published
      property OnExpanded: TNotifyEvent read FOnExpanded write FOnExpanded;
  end;

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
    function AddFolderToTreeView(APath: string; AParent: TFmxObject; IsSubItem: boolean): TTreeViewItem;
    procedure AddSubItems(Item: TExpandableTreeViewItem);
    procedure ExpandTreeViewItem(Sender: TObject);
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

procedure TExpandableTreeViewItem.SetIsExpanded(const Value: Boolean);
var
  LWasExpanded: boolean;
begin
  LWasExpanded := IsExpanded;
  inherited;
  if IsExpanded and not LWasExpanded then
    if Assigned(OnExpanded) then
      OnExpanded(Self);
end;

function TForm3.AddFolderToTreeView(APath: string;
  AParent: TFmxObject; IsSubItem: boolean): TTreeViewItem;
begin
  var Item:= TExpandableTreeViewItem.Create(Folders);

  Item.Path := APath;

  if not IsSubItem then
  begin
    Item.OnExpanded := ExpandTreeViewItem;
    AddSubItems(Item);
  end;

  Item.Parent := AParent;
  
  Result := Item;
end;

procedure TForm3.AddSubItems(Item: TExpandableTreeViewItem);
begin
  var SubFolders := dm.GetSubFolders(Item.Path);
  if (SubFolders <> nil) then
    for var OneFolder in SubFolders do
      AddFolderToTreeView(OneFolder, Item, True);
end;

procedure TForm3.ExpandTreeViewItem(Sender: TObject);
begin
  if (Sender <> nil) and (Sender is TExpandableTreeViewItem) then
  begin
    var Item := TExpandableTreeViewItem(Sender);
    for var i:= 0 to Item.Count - 1 do
      if Item.Items[i] is TExpandableTreeViewItem then
      begin
        var SubItem := TExpandableTreeViewItem(Item.Items[i]);
        AddSubItems(SubItem);
        SubItem.OnExpanded := ExpandTreeViewItem;
      end;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  AddFolderToTreeView('\', Folders, False);
end;

procedure TExpandableTreeViewItem.SetPath(const Value: string);
begin
  FPath := Value;
  Text := dm.GetFilename(FPath);
end;

end.
