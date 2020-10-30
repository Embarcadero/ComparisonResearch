unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus;

type
  TForm3 = class(TForm)
    WinMenu: TMenuBar;
    MacMenu: TMainMenu;
    WinMenuFile: TMenuItem;
    MacMenuFile: TMenuItem;
    WinMenuRun: TMenuItem;
    WinMenuBrowseForFolder: TMenuItem;
    WinMenuExit: TMenuItem;
    MacMenuBrowseForFolder: TMenuItem;
    MacMenuRun: TMenuItem;
    MacMenuExit: TMenuItem;
    WinMenuEdit: TMenuItem;
    WinMenuCopy: TMenuItem;
    WinMenuWindow: TMenuItem;
    WinMenuArrange: TMenuItem;
    MacMenuEdit: TMenuItem;
    MacMenuCopy: TMenuItem;
    MacMenuWindow: TMenuItem;
    MacMenuArrange: TMenuItem;
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
