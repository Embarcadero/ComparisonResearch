object CalculatorForm: TCalculatorForm
  Left = 0
  Top = 0
  Caption = 'CalculatorForm'
  ClientHeight = 272
  ClientWidth = 311
  Color = clBtnFace
  Constraints.MinHeight = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    311
    272)
  PixelsPerInch = 96
  TextHeight = 13
  object ExprLabel: TLabel
    Left = 12
    Top = 12
    Width = 291
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'ExprLabel'
    ExplicitWidth = 323
  end
  object NumLabel: TLabel
    Left = 12
    Top = 36
    Width = 291
    Height = 21
    Alignment = taRightJustify
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'NumLabel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 323
  end
  object EntryEdit: TEdit
    Left = 4
    Top = 4
    Width = 53
    Height = 21
    TabOrder = 0
    Text = 'EntryEdit'
    OnKeyPress = EntryEditKeyPress
  end
  object SevenPanel: TPanel
    Left = 12
    Top = 72
    Width = 49
    Height = 49
    Caption = '7'
    ParentBackground = False
    TabOrder = 1
    OnClick = AllPanelClick
  end
  object EightPanel: TPanel
    Left = 60
    Top = 72
    Width = 49
    Height = 49
    Caption = '8'
    ParentBackground = False
    TabOrder = 2
    OnClick = AllPanelClick
  end
  object NinePanel: TPanel
    Left = 108
    Top = 72
    Width = 49
    Height = 49
    Caption = '9'
    ParentBackground = False
    TabOrder = 3
    OnClick = AllPanelClick
  end
  object FourPanel: TPanel
    Left = 12
    Top = 120
    Width = 49
    Height = 49
    Caption = '4'
    ParentBackground = False
    TabOrder = 4
    OnClick = AllPanelClick
  end
  object FivePanel: TPanel
    Left = 60
    Top = 120
    Width = 49
    Height = 49
    Caption = '5'
    ParentBackground = False
    TabOrder = 5
    OnClick = AllPanelClick
  end
  object SixPanel: TPanel
    Left = 108
    Top = 120
    Width = 49
    Height = 49
    Caption = '6'
    ParentBackground = False
    TabOrder = 6
    OnClick = AllPanelClick
  end
  object OnePanel: TPanel
    Left = 12
    Top = 168
    Width = 49
    Height = 49
    Caption = '1'
    ParentBackground = False
    TabOrder = 7
    OnClick = AllPanelClick
  end
  object TwoPanel: TPanel
    Left = 60
    Top = 168
    Width = 49
    Height = 49
    Caption = '2'
    ParentBackground = False
    TabOrder = 8
    OnClick = AllPanelClick
  end
  object ThreePanel: TPanel
    Left = 108
    Top = 168
    Width = 49
    Height = 49
    Caption = '3'
    ParentBackground = False
    TabOrder = 9
    OnClick = AllPanelClick
  end
  object ClearPanel: TPanel
    Left = 12
    Top = 216
    Width = 49
    Height = 49
    Caption = 'C'
    ParentBackground = False
    TabOrder = 10
    OnClick = AllPanelClick
  end
  object ZeroPanel: TPanel
    Left = 60
    Top = 216
    Width = 49
    Height = 49
    Caption = '0'
    ParentBackground = False
    TabOrder = 11
    OnClick = AllPanelClick
  end
  object DecimalPanel: TPanel
    Left = 108
    Top = 216
    Width = 49
    Height = 49
    Caption = '.'
    ParentBackground = False
    TabOrder = 12
    OnClick = AllPanelClick
  end
  object DividePanel: TPanel
    Left = 163
    Top = 72
    Width = 70
    Height = 49
    Caption = '/'
    ParentBackground = False
    TabOrder = 13
    OnClick = AllPanelClick
  end
  object MultiplyPanel: TPanel
    Left = 163
    Top = 120
    Width = 70
    Height = 49
    Caption = 'X'
    ParentBackground = False
    TabOrder = 14
    OnClick = AllPanelClick
  end
  object SubtractPanel: TPanel
    Left = 163
    Top = 168
    Width = 70
    Height = 49
    Caption = '-'
    ParentBackground = False
    TabOrder = 15
    OnClick = AllPanelClick
  end
  object AddPanel: TPanel
    Left = 163
    Top = 216
    Width = 70
    Height = 49
    Caption = '+'
    ParentBackground = False
    TabOrder = 16
    OnClick = AllPanelClick
  end
  object BackspacePanel: TPanel
    Left = 232
    Top = 120
    Width = 70
    Height = 49
    Caption = #8592
    ParentBackground = False
    TabOrder = 17
    OnClick = AllPanelClick
  end
  object EqualPanel: TPanel
    Left = 232
    Top = 169
    Width = 70
    Height = 96
    Caption = '='
    ParentBackground = False
    TabOrder = 18
    OnClick = AllPanelClick
  end
  object TransparentCheckBox: TCheckBox
    Left = 244
    Top = 84
    Width = 97
    Height = 17
    Caption = 'Trans.'
    TabOrder = 19
    OnClick = TransparentCheckBoxClick
  end
  object FlashTimer: TTimer
    Enabled = False
    OnTimer = FlashTimerTimer
    Left = 100
    Top = 136
  end
end
