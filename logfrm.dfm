object frmLog: TfrmLog
  Left = 272
  Top = 148
  Width = 489
  Height = 301
  BorderStyle = bsSizeToolWin
  Caption = 'Log player'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnl: TPanel
    Left = 0
    Top = 240
    Width = 481
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      481
      34)
    object btnClear: TButton
      Left = 316
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'C&lear'
      TabOrder = 0
      OnClick = DoClearClick
    end
    object btnClose: TButton
      Left = 396
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Close'
      TabOrder = 1
      OnClick = DoCloseClick
    end
  end
  object mm: TMemo
    Left = 0
    Top = 0
    Width = 481
    Height = 240
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
