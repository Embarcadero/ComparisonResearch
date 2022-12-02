object MainForm: TMainForm
  Left = 0
  Top = 0
  Margins.Left = 6
  AlphaBlend = True
  Caption = 'Screenshot History'
  ClientHeight = 654
  ClientWidth = 1095
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 241
    Width = 1095
    Height = 10
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 8
    ExplicitTop = 225
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 598
    Width = 1095
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 40
    ExplicitTop = 627
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 1095
    Height = 241
    Align = alTop
    AutoScroll = False
    TabOrder = 0
    object FP: TFlowPanel
      Left = 0
      Top = 0
      Width = 1091
      Height = 237
      Align = alClient
      BevelWidth = 2
      BorderWidth = 2
      TabOrder = 0
      OnResize = FPResize
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 604
    Width = 1089
    Height = 47
    Align = alBottom
    TabOrder = 1
    object btCrop: TButton
      AlignWithMargins = True
      Left = 276
      Top = 4
      Width = 266
      Height = 39
      Align = alLeft
      Caption = 'Crop'
      TabOrder = 0
      OnClick = btCropClick
    end
    object btCapture: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 266
      Height = 39
      Align = alLeft
      Caption = 'Capture'
      TabOrder = 1
      OnClick = btCaptureClick
    end
    object btResize: TButton
      AlignWithMargins = True
      Left = 547
      Top = 4
      Width = 266
      Height = 39
      Align = alRight
      Caption = 'Resize'
      TabOrder = 2
      OnClick = btResizeClick
    end
    object btSave: TButton
      AlignWithMargins = True
      Left = 819
      Top = 4
      Width = 266
      Height = 39
      Align = alRight
      Caption = 'Save'
      TabOrder = 3
      OnClick = btSaveClick
    end
  end
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 251
    Width = 1095
    Height = 347
    Align = alClient
    AutoScroll = False
    TabOrder = 2
    DesignSize = (
      1091
      343)
    object MainImage: TImage
      Left = 0
      Top = 0
      Width = 1091
      Height = 343
      Align = alClient
      AutoSize = True
      OnMouseDown = MainImageMouseDown
      OnMouseMove = MainImageMouseMove
      OnMouseUp = MainImageMouseUp
      ExplicitLeft = -256
      ExplicitTop = -80
    end
    object SplitView: TSplitView
      Left = 1090
      Top = 3
      Width = 0
      Height = 200
      Margins.Right = 10
      DisplayMode = svmOverlay
      Opened = False
      OpenedWidth = 200
      ParentColor = True
      Placement = svpRight
      TabOrder = 0
      OnResize = SplitViewResize
      object Label1: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = -13
        Height = 13
        Margins.Left = 10
        Margins.Top = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Zoom value:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        ExplicitWidth = 59
      end
      object lbZoomValue: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 26
        Width = -13
        Height = 13
        Margins.Left = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = '1.0X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 24
      end
      object TrackBar: TTrackBar
        AlignWithMargins = True
        Left = 3
        Top = 42
        Width = 0
        Height = 48
        Align = alTop
        Max = 100
        Min = -100
        PageSize = 10
        Frequency = 10
        Position = 1
        TabOrder = 0
        OnChange = TrackBarChange
        ExplicitWidth = 194
      end
    end
  end
  object UpdateQuery: TFDQuery
    Connection = Connection
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    Left = 992
    Top = 112
  end
  object Query: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'SELECT * FROM SCREENSHOTTABLE ')
    Left = 928
    Top = 112
  end
  object Script: TFDScript
    SQLScripts = <
      item
        SQL.Strings = (
          'CREATE TABLE IF NOT EXISTS SCREENSHOTTABLE ('
          '    ID INTEGER PRIMARY KEY,'
          '    DATE DATE,'
          '    SCREENSHOT BLOB'
          ');'
          ''
          'DELETE FROM SCREENSHOTTABLE;')
      end>
    Connection = Connection
    Params = <>
    Macros = <>
    FetchOptions.AssignedValues = [evItems, evAutoClose, evAutoFetchAll]
    FetchOptions.AutoClose = False
    FetchOptions.Items = [fiBlobs, fiDetails]
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvDirectExecute, rvPersistent]
    ResourceOptions.MacroCreate = False
    ResourceOptions.DirectExecute = True
    Left = 872
    Top = 112
  end
  object Connection: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 800
    Top = 112
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 704
    Top = 112
  end
  object PopupMenu: TPopupMenu
    Left = 608
    Top = 107
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
  object SavePictureDialog: TSavePictureDialog
    DefaultExt = 'jpg'
    Filter = 'JPEG|*.jpeg;*.jpg'
    Left = 504
    Top = 120
  end
end
