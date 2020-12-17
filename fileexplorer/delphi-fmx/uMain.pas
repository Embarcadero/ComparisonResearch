unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus, System.Rtti, FMX.Grid.Style, FMX.Grid,
  FMX.ScrollBox, FMX.Layouts, FMX.TreeView, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.TabControl, uDM;

type
  TExpandableTreeViewItem = class(FMX.TTreeViewItem)
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

  TForm1 = class(TForm)
    MenuBar1: TMenuBar;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Layout1: TLayout;
    FolderEdit: TEdit;
    Splitter1: TSplitter;
    SearchEdit: TEdit;
    Layout2: TLayout;
    Layout3: TLayout;
    Folders: TTreeView;
    Splitter2: TSplitter;
    Files: TGrid;
    NameColumn: TStringColumn;
    DateModifiedColumn: TDateTimeColumn;
    TypeColumn: TStringColumn;
    SizeColumn: TStringColumn;
    StyleBook1: TStyleBook;
    Tabs: TTabControl;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FilesGetValue(Sender: TObject; const ACol, ARow: Integer; var Value:
        TValue);
    procedure FolderEditChange(Sender: TObject);
    procedure FoldersChange(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TabsChange(Sender: TObject);
  private
    FFoldersChangeActive: Boolean;
    FFilesData: TFilesData;
    function AddFolderToTreeView(APath: string; AParent: TFmxObject; IsSubItem: Boolean): TTreeViewItem;
    procedure AddSubItems(Item: TExpandableTreeViewItem);
    procedure ExpandTreeViewItem(Sender: TObject);
    procedure FoldersTryOpen(Path: string);
    procedure UpdateFilesPath(Path: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  FMX.DialogService;

{$R *.fmx}

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  var NewTab := Tabs.Add;
  NewTab.TagString := FolderEdit.Text;
  NewTab.Text := dm.GetFolderName(FolderEdit.Text);
  Tabs.ActiveTab := NewTab;
end;

{ TExpandableTreeViewItem }

procedure TExpandableTreeViewItem.SetIsExpanded(const Value: Boolean);
var
  LWasExpanded: Boolean;
begin
  LWasExpanded := IsExpanded;
  inherited;
  if IsExpanded and not LWasExpanded then
    if Assigned(OnExpanded) then
      OnExpanded(Self);
end;

procedure TExpandableTreeViewItem.SetPath(const Value: string);
begin
  FPath := Value;
  Text := dm.GetFolderName(FPath);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AddFolderToTreeView(PathDelim, Folders, False);
  Folders.Items[0].Select;
end;

function TForm1.AddFolderToTreeView(APath: string; AParent: TFmxObject; IsSubItem: Boolean): TTreeViewItem;
begin
  var Item := TExpandableTreeViewItem.Create(Folders);

  Item.Path := APath;

  if not IsSubItem then
  begin
    Item.OnExpanded := ExpandTreeViewItem;
    AddSubItems(Item);
  end;

  Item.Parent := AParent;

  Result := Item;
end;

procedure TForm1.AddSubItems(Item: TExpandableTreeViewItem);
  procedure RemoveFromParent(Parent, SubItem: TTreeViewItem);
  begin
    SubItem.Parent := nil;
    SubItem.Free;
  end;
begin
  for var i := Item.Count - 1 downto 0 do
    RemoveFromParent(Item, Item.Items[i]);
    
  var SubFolders := dm.GetSubFolders(Item.Path);
  if SubFolders <> nil then
    for var OneFolder in SubFolders do
      AddFolderToTreeView(OneFolder, Item, True);
end;

procedure TForm1.ExpandTreeViewItem(Sender: TObject);
begin
  if (Sender <> nil) and (Sender is TExpandableTreeViewItem) then
  begin
    var Item := TExpandableTreeViewItem(Sender);
    for var i := 0 to Item.Count - 1 do
      if Item.Items[i] is TExpandableTreeViewItem then
      begin
        var SubItem := TExpandableTreeViewItem(Item.Items[i]);
        AddSubItems(SubItem);
        SubItem.OnExpanded := ExpandTreeViewItem;
      end;
  end;
end;

procedure TForm1.FilesGetValue(Sender: TObject; const ACol, ARow: Integer; var
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

procedure TForm1.FolderEditChange(Sender: TObject);
begin
  FoldersTryOpen(FolderEdit.Text);
end;

procedure TForm1.FoldersChange(Sender: TObject);
begin
  if not FFoldersChangeActive and (Folders.Selected is TExpandableTreeViewItem) then
  begin
    FFoldersChangeActive := True;
    try
      var Path := (Folders.Selected as TExpandableTreeViewItem).Path;
      UpdateFilesPath(Path);
      FolderEdit.Text := Path;
      Assert(Tabs.ActiveTab <> nil);
      Tabs.ActiveTab.TagString := Path;
      Tabs.ActiveTab.Text := dm.GetFolderName(Path);      
    finally
      FFoldersChangeActive := False;
    end;
  end;
end;

procedure TForm1.FoldersTryOpen(Path: string);

  function CouldDescend(var Node: TTreeViewItem; const Folder: string): Boolean;
  var i: Integer;
  begin
    Result := False;
    for i := 0 to Node.Count - 1 do
      if SameFileName(Node.Items[i].Text, Folder) then
      begin
        Result := True;
        break;
      end;

    if Result then
    begin
      Node := Node.Items[i];
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
        Exit;
      Path := ExtractRelativePath(Drive, Path);

      if not CouldDescend(CurrentNode, Drive) then
      begin
        CurrentNode.Select;
        exit;
      end;
    {$ENDIF}

    for var PathItem in Path.Split([PathDelim]) do
      if not CouldDescend(CurrentNode, PathItem) then
      begin
        CurrentNode.Select;
        exit;
      end;

  finally
    Folders.EndUpdate;
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  TDialogService.InputQuery('Run', ['Type the name of a program folder, document or Internet resource to open:'], [''],
    procedure(const AResult: TModalResult; const AValues: array of string)
    begin
      if IsPositiveResult(AResult) then
        dm.ShellOpen(AValues[Low(AValues)]);
    end
  );
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
var Directory: string;
begin
  if SelectDirectory('Select a folder to open', PathDelim, Directory) then
    FolderEdit.Text := Directory;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  dm.PutFileToClipboard(FFilesData[Files.Row].FullFilename);
end;

procedure TForm1.TabsChange(Sender: TObject);
begin
  Assert(Tabs.ActiveTab <> nil);
  FolderEdit.Text := Tabs.ActiveTab.TagString;
end;

procedure TForm1.UpdateFilesPath(Path: string);
begin
  Files.BeginUpdate;
  try
    FFilesData := dm.GetFilesData(Path, SearchEdit.Text);
    Files.RowCount := Length(FFilesData);
  finally
    Files.EndUpdate;
  end;
end;

end.
