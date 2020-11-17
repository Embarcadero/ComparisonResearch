unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, System.Actions,
  FMX.ActnList, FMX.StdActns, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, FMX.Header, FMX.StdCtrls, FMX.TreeView, FMX.TabControl, uDM;

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
    FolderEdit: TEdit;
    SearchEdit: TEdit;
    Layout2: TLayout;
    Folders: TTreeView;
    Splitter1: TSplitter;
    Layout3: TLayout;
    Files: TGrid;
    Layout4: TLayout;
    TabControl1: TTabControl;
    tiWindows: TTabItem;
    tiDesktop: TTabItem;
    btnNewTab: TSpeedButton;
    StyleBook1: TStyleBook;
    DateModifiedColumn: TDateTimeColumn;
    TypeColumn: TStringColumn;
    SizeColumn: TStringColumn;
    NameColumn: TStringColumn;
    procedure FilesGetValue(Sender: TObject; const ACol, ARow: Integer; var Value:
        TValue);
    procedure FolderEditChange(Sender: TObject);
    procedure FoldersChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FFilesData: TFilesData;
    function AddFolderToTreeView(APath: string; AParent: TFmxObject; IsSubItem: boolean): TTreeViewItem;
    procedure AddSubItems(Item: TExpandableTreeViewItem);
    procedure ExpandTreeViewItem(Sender: TObject);
    procedure FoldersTryOpen(Path: string);
    procedure UpdateFilesPath(Path: string);
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}


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
  procedure RemoveFromParent(Parent, SubItem: TTreeViewItem);
  begin
    SubItem.Parent := nil;
    SubItem.Free;
  end;
begin
  for var i := Item.Count - 1 downto 0 do
    RemoveFromParent(Item, Item.Items[i]);

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

procedure TForm3.FilesGetValue(Sender: TObject; const ACol, ARow: Integer; var
    Value: TValue);
begin
  if FFilesData <> nil then
  begin
    if Files.Columns[ACol] = NameColumn then
      Value := FFilesData[ARow].Filename
    else if Files.Columns[ACol] = DateModifiedColumn then
      Value := FFilesData[ARow].DateModified
    else if Files.Columns[ACol] = TypeColumn then
      Value := FFilesData[ARow].Filetype
    else if Files.Columns[ACol] = SizeColumn then
      Value := FFilesData[ARow].Size
  end;
end;

procedure TForm3.FolderEditChange(Sender: TObject);
begin
  FoldersTryOpen(FolderEdit.Text);
end;

procedure TForm3.FoldersChange(Sender: TObject);
begin
  if Folders.Selected is TExpandableTreeViewItem then
    UpdateFilesPath((Folders.Selected as TExpandableTreeViewItem).Path);
end;

procedure TForm3.FoldersTryOpen(Path: string);

  function CouldDescend(var Node: TTreeViewItem; const Folder: string): Boolean;
  var i: Integer;
  begin
    Result := False;
    for i := 0 to Node.Count - 1 do
      if SameFilename(Node.Items[i].Text, Folder) then
      begin
        Result := True;
        break;
      end;
        
    if Result then
    begin
      Node := Node.Items[i];
      Node.Select;
      Node.Expand;            
    end;
  end;
  
var
  CurrentNode: TTreeViewItem;
begin
  Folders.BeginUpdate;
  try
    Assert(Folders.Count > 0);
    CurrentNode := Folders.ItemByIndex(0);

    {$IFDEF MSWINDOWS}
      var Drive:= ExtractFileDrive(Path);
      if Drive = '' then
        exit;
      Path := ExtractRelativePath(Drive, Path);

      if not CouldDescend(CurrentNode, Drive) then
        exit;
    {$ENDIF}
      
    for var PathItem in Path.Split([PathDelim]) do
      if not CouldDescend(CurrentNode, Drive) then
        exit;
  finally
    Folders.EndUpdate;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  AddFolderToTreeView(PathDelim, Folders, False);
end;

procedure TForm3.UpdateFilesPath(Path: string);
begin
  Files.BeginUpdate;
  try
    FFilesData := dm.GetFilesData(Path, SearchEdit.Text);
    Files.RowCount := Length(FFilesData);
  finally
    Files.EndUpdate;
  end;
end;

procedure TExpandableTreeViewItem.SetPath(const Value: string);
begin
  FPath := Value;
  Text := dm.GetFolderName(FPath);
end;

end.
