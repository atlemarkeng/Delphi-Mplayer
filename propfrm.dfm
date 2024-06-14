object frmProp: TfrmProp
  Left = 292
  Top = 127
  Width = 293
  Height = 317
  BorderStyle = bsSizeToolWin
  Caption = 'Media properties'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 100
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
    Top = 256
    Width = 285
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      285
      34)
    object btnClose: TButton
      Left = 200
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Close'
      TabOrder = 0
      OnClick = DoCloseClick
    end
  end
  object lstv: TListView
    Left = 0
    Top = 0
    Width = 285
    Height = 256
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 120
      end
      item
        Caption = 'Value'
        Width = 140
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
end
