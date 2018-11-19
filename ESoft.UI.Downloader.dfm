object FormDownloader: TFormDownloader
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Download Manager'
  ClientHeight = 151
  ClientWidth = 394
  Color = 14871789
  Constraints.MaxHeight = 180
  Constraints.MaxWidth = 400
  Constraints.MinHeight = 180
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    394
    151)
  PixelsPerInch = 96
  TextHeight = 13
  object lblTitle: TLabel
    AlignWithMargins = True
    Left = 15
    Top = 15
    Width = 376
    Height = 15
    Margins.Left = 15
    Margins.Top = 15
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object lblText: TLabel
    AlignWithMargins = True
    Left = 15
    Top = 33
    Width = 376
    Height = 15
    Cursor = crHandPoint
    Hint = 'Copy to clipboard'
    Margins.Left = 15
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Times New Roman'
    Font.Style = [fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Layout = tlCenter
    OnClick = lblTextClick
  end
  object lblPercentDone: TLabel
    Left = 15
    Top = 116
    Width = 81
    Height = 15
    Anchors = [akLeft, akBottom]
    Caption = '0% Percent done'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object lblFileIndex: TLabel
    Left = 15
    Top = 94
    Width = 110
    Height = 14
    Anchors = [akLeft, akBottom]
    Caption = 'Downloading file 1 of 5'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = [fsItalic]
    ParentFont = False
    Layout = tlCenter
  end
  object btnCancel: TButton
    Left = 304
    Top = 110
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 15
    Top = 63
    Width = 364
    Height = 23
    Margins.Left = 15
    Margins.Top = 15
    Margins.Right = 15
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object pbAll: TProgressBar
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 120
      Height = 17
      Margins.Left = 0
      Align = alLeft
      Smooth = True
      SmoothReverse = True
      TabOrder = 0
    end
    object pbMain: TProgressBar
      AlignWithMargins = True
      Left = 126
      Top = 3
      Width = 238
      Height = 17
      Margins.Right = 0
      Align = alClient
      Smooth = True
      SmoothReverse = True
      TabOrder = 1
    end
  end
  object bkGndWorker: TBackgroundWorker
    OnWork = bkGndWorkerWork
    OnWorkComplete = bkGndWorkerWorkComplete
    OnWorkProgress = bkGndWorkerWorkProgress
    Left = 264
    Top = 120
  end
end
