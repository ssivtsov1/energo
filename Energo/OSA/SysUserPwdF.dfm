object FUserPwd: TFUserPwd
  Left = 305
  Top = 137
  BorderStyle = bsDialog
  Caption = '������ �������������'
  ClientHeight = 168
  ClientWidth = 693
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 66
    Top = 68
    Width = 111
    Height = 19
    Caption = '������� ������ '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 66
    Top = 108
    Width = 217
    Height = 19
    Caption = '������� ������������� ������'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times'
    Font.Style = []
    ParentFont = False
  end
  object LabName: TLabel
    Left = 16
    Top = 4
    Width = 675
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Caption = ' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabOldPwd: TLabel
    Left = 66
    Top = 40
    Width = 164
    Height = 19
    Caption = '������� ������ ������ '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object EdPwd1: TEdit
    Left = 320
    Top = 68
    Width = 89
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 0
  end
  object EdPwd2: TEdit
    Left = 320
    Top = 110
    Width = 89
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
    OnChange = EdPwd2Change
    OnExit = EdPwd2Exit
  end
  object BitBtnOK: TBitBtn
    Left = 450
    Top = 72
    Width = 107
    Height = 25
    Caption = '��������� '
    Enabled = False
    TabOrder = 2
    OnClick = BitBtnOKClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777077777
      777777777700777777777777700007777777777770CC00777777777700CCC000
      777777770CCCCCC0000777700C00000007777770CC07777777777700CC077777
      7777700CCC077777777770CCCC077777777770CCCC077777777770CCCC077777
      77770CCCC007777777770CCCC077777777770000007777777777}
  end
  object BitBtn2: TBitBtn
    Left = 450
    Top = 110
    Width = 105
    Height = 25
    Caption = '��������'
    TabOrder = 3
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00700777777777
      7000099077777777099009990777777099907099907777099907770999077099
      9077777099900999077777770999999077777777709999077777777770999907
      7777777709999990777777709990099907777709990770999077709990777709
      9907099907777770999009907777777709900007777777777000}
  end
  object EdOldPwd: TEdit
    Left = 320
    Top = 38
    Width = 89
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 4
    Visible = False
    OnChange = EdOldPwdChange
    OnExit = EdOldPwdExit
  end
end
