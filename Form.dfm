object MainForm: TMainForm
  Left = 696
  Top = 236
  Width = 357
  Height = 247
  Caption = 'XY Controller'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 230
    Top = 184
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 230
    Top = 168
    Width = 3
    Height = 13
  end
  object Mem_Rcv: TMemo
    Left = 8
    Top = 8
    Width = 209
    Height = 193
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = Mem_RcvChange
  end
  object ComboBox1: TComboBox
    Left = 232
    Top = 8
    Width = 105
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'COM4'
    OnChange = ComboBox1Change
    Items.Strings = (
      'COM1'
      'COM2'
      'COM3'
      'COM4'
      'COM5'
      'COM6'
      'COM7'
      'COM8'
      'COM9'
      'COM10'
      'COM11'
      'COM12'
      'COM13'
      'COM14'
      'COM15'
      'COM16'
      'COM17'
      'COM18'
      'COM19'
      'COM20')
  end
  object Tmr_Rcv: TTimer
    Enabled = False
    OnTimer = Tmr_RcvTimer
    Left = 56
    Top = 16
  end
end
