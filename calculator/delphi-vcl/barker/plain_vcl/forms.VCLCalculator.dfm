object VCLCalculatorForm: TVCLCalculatorForm
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 245
  Caption = 'VCLCalculatorForm'
  ClientHeight = 470
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 501
    Height = 104
    Align = alTop
    TabOrder = 0
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 499
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      Color = 11842224
      ParentBackground = False
      TabOrder = 0
      object HistoryLabel: TLabel
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 489
        Height = 29
        Margins.Left = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alClient
        Alignment = taRightJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 485
        ExplicitWidth = 4
        ExplicitHeight = 17
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 33
      Width = 499
      Height = 70
      Align = alClient
      BevelOuter = bvNone
      Color = 11842224
      ParentBackground = False
      TabOrder = 1
      object CurrentValueLabel: TLabel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 489
        Height = 70
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alClient
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -40
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 232
        ExplicitTop = 32
        ExplicitWidth = 22
        ExplicitHeight = 54
      end
    end
  end
  object FunctionsPanel: TPanel
    Left = 0
    Top = 104
    Width = 501
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    Color = 11842224
    ParentBackground = False
    TabOrder = 1
    object Mem1: TLabel
      Left = 3
      Top = 0
      Width = 38
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'MC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMedGray
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Mem2: TLabel
      Left = 47
      Top = 0
      Width = 38
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'MR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMedGray
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Mem3: TLabel
      Left = 91
      Top = 0
      Width = 38
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'M+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Mem4: TLabel
      Left = 136
      Top = 0
      Width = 38
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'M-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Mem6: TLabel
      Left = 225
      Top = 0
      Width = 38
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'M*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMedGray
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Mem5: TLabel
      Left = 180
      Top = 0
      Width = 38
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'MS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
  end
  object ButtonsPanel: TPanel
    Left = 0
    Top = 141
    Width = 501
    Height = 329
    Align = alClient
    BevelOuter = bvNone
    Color = 11842224
    ParentBackground = False
    TabOrder = 2
    object Pnl1: TPanel
      Left = 24
      Top = 1
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      OnClick = Pnl1Click
    end
    object Pnl2: TPanel
      Left = 82
      Top = 1
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
    end
    object Pnl3: TPanel
      Left = 140
      Top = 1
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      OnClick = Pnl3Click
    end
    object Pnl4: TPanel
      Left = 198
      Top = 1
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      OnClick = Pnl4Click
    end
    object Pnl5: TPanel
      Left = 24
      Top = 59
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 4
    end
    object Pnl6: TPanel
      Left = 82
      Top = 59
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 5
    end
    object Pnl7: TPanel
      Left = 140
      Top = 59
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 6
    end
    object Pnl8: TPanel
      Left = 198
      Top = 59
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 7
    end
    object Pnl12: TPanel
      Left = 266
      Top = 59
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 8
      OnClick = Pnl12Click
    end
    object Pnl16: TPanel
      Left = 324
      Top = 59
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 9
      OnClick = Pnl16Click
    end
    object Pnl20: TPanel
      Left = 382
      Top = 59
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 13158342
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 10
      OnClick = Pnl20Click
    end
    object Pnl9: TPanel
      Left = 24
      Top = 136
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 11
      OnClick = NumberClick
    end
    object Pnl10: TPanel
      Left = 82
      Top = 136
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 12
      OnClick = NumberClick
    end
    object Pnl11: TPanel
      Left = 140
      Top = 136
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 13
      OnClick = NumberClick
    end
    object Pnl13: TPanel
      Left = 198
      Top = 136
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 14
      OnClick = NumberClick
    end
    object Pnl14: TPanel
      Left = 24
      Top = 194
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 15
      OnClick = NumberClick
    end
    object Pnl15: TPanel
      Left = 82
      Top = 194
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 16
      OnClick = NumberClick
    end
    object Pnl17: TPanel
      Left = 140
      Top = 194
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 17
      OnClick = NumberClick
    end
    object Pnl18: TPanel
      Left = 198
      Top = 194
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 18
      OnClick = NumberClick
    end
    object Pnl22: TPanel
      Left = 140
      Top = 252
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 19
      OnClick = NumberClick
    end
    object Pnl21: TPanel
      Left = 82
      Top = 252
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 20
      OnClick = Pnl21Click
    end
    object Pnl19: TPanel
      Left = 24
      Top = 252
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 21
      OnClick = NumberClick
    end
    object Pnl23: TPanel
      Left = 198
      Top = 252
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 14474460
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 22
      OnClick = Pnl23Click
    end
    object Pnl24: TPanel
      Left = 266
      Top = 252
      Width = 52
      Height = 52
      BevelOuter = bvNone
      Caption = 'Pnl1'
      Color = 12228204
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 23
      OnClick = Pnl24Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 125
    OnTimer = Timer1Timer
    Left = 248
    Top = 240
  end
end
