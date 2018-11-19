object FormParamEditor: TFormParamEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Parameter Editor'
  ClientHeight = 200
  ClientWidth = 371
  Color = 14871789
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 365
    Height = 194
    Align = alClient
    TabOrder = 0
    DesignSize = (
      365
      194)
    object Label5: TLabel
      Left = 17
      Top = 72
      Width = 61
      Height = 13
      Caption = 'Parameter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 17
      Top = 45
      Width = 32
      Height = 13
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 17
      Top = 122
      Width = 63
      Height = 13
      Caption = 'Connection'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 17
      Top = 18
      Width = 52
      Height = 13
      Caption = 'Category'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnCancel: TButton
      Left = 275
      Top = 154
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 5
      TabStop = False
    end
    object btnOK: TButton
      Left = 194
      Top = 154
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 6
      TabStop = False
      OnClick = btnOKClick
    end
    object edtParameter: TButtonedEdit
      Left = 100
      Top = 69
      Width = 250
      Height = 21
      Images = FormMDIMain.ImageList_Ord
      RightButton.ImageIndex = 34
      RightButton.PressedImageIndex = 4
      RightButton.Visible = True
      TabOrder = 1
      TextHint = 'Parameter '
      OnRightButtonClick = edtParamNameRightButtonClick
    end
    object edtParamName: TButtonedEdit
      Left = 100
      Top = 42
      Width = 250
      Height = 21
      Images = FormMDIMain.ImageList_Ord
      RightButton.ImageIndex = 34
      RightButton.PressedImageIndex = 4
      RightButton.Visible = True
      TabOrder = 0
      TextHint = 'Identification Name'
      OnKeyPress = edtParamNameKeyPress
      OnRightButtonClick = edtParamNameRightButtonClick
    end
    object chkDefaultInclude: TCheckBox
      Left = 246
      Top = 96
      Width = 97
      Height = 17
      Caption = ' Default Include'
      Enabled = False
      TabOrder = 3
    end
    object chkConnectionParam: TCheckBox
      Left = 100
      Top = 96
      Width = 130
      Height = 17
      Caption = ' Connection Parameter '
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = chkConnectionParamClick
    end
    object cbConnections: TComboBox
      Left = 100
      Top = 119
      Width = 250
      Height = 21
      TabOrder = 4
      OnExit = cbConnectionsExit
    end
    object cbCategory: TComboBox
      Left = 100
      Top = 15
      Width = 250
      Height = 21
      TabOrder = 7
      OnKeyPress = cbCategoryKeyPress
    end
    object chkExcludeAdditionalParameters: TCheckBox
      Left = 17
      Top = 158
      Width = 171
      Height = 17
      TabStop = False
      Anchors = [akLeft, akBottom]
      Caption = ' Exclude Additional Parameters'
      TabOrder = 8
    end
  end
end
