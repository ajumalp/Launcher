object FormAppGroupEditor: TFormAppGroupEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Group Editor'
  ClientHeight = 429
  ClientWidth = 371
  Color = 14871789
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 365
    Height = 423
    Align = alClient
    TabOrder = 0
    DesignSize = (
      365
      423)
    object Label2: TLabel
      Left = 17
      Top = 99
      Width = 39
      Height = 13
      Caption = 'Source'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sBtnBrowseAppSource: TSpeedButton
      Left = 327
      Top = 96
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = sBtnBrowseAppSourceClick
    end
    object Label3: TLabel
      Left = 17
      Top = 153
      Width = 65
      Height = 13
      Caption = 'Destination'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sBtnBrowseAppDest: TSpeedButton
      Left = 327
      Top = 150
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = sBtnBrowseAppSourceClick
    end
    object Label4: TLabel
      Left = 17
      Top = 180
      Width = 52
      Height = 13
      Caption = 'File Mask'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 17
      Top = 72
      Width = 62
      Height = 13
      Caption = 'Executable'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 17
      Top = 18
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
    object Label6: TLabel
      Left = 17
      Top = 207
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
    object Label7: TLabel
      Left = 17
      Top = 45
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
    object Label11: TLabel
      Left = 17
      Top = 126
      Width = 43
      Height = 13
      Caption = 'Copy to'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sBtnBrowseAppSourceCopy: TSpeedButton
      Left = 327
      Top = 123
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = sBtnBrowseAppSourceClick
    end
    object edtAppSource: TButtonedEdit
      Left = 171
      Top = 96
      Width = 150
      Height = 21
      Images = FormMDIMain.ImageList_Ord
      ReadOnly = True
      RightButton.ImageIndex = 34
      RightButton.PressedImageIndex = 4
      RightButton.Visible = True
      TabOrder = 5
      TextHint = 'Source Folder'
      OnRightButtonClick = edtAppSourceRightButtonClick
    end
    object edtAppDest: TButtonedEdit
      Left = 100
      Top = 150
      Width = 221
      Height = 21
      Images = FormMDIMain.ImageList_Ord
      ReadOnly = True
      RightButton.ImageIndex = 34
      RightButton.PressedImageIndex = 4
      RightButton.Visible = True
      TabOrder = 7
      TextHint = 'Target Folder'
      OnChange = edtAppDestChange
      OnRightButtonClick = edtAppSourceRightButtonClick
    end
    object edtFileMask: TButtonedEdit
      Left = 100
      Top = 177
      Width = 150
      Height = 21
      Hint = 'Multi format using ";" [*.mp3;*.wma]. Use "*" for folder only.'
      CustomHint = BalloonHint
      Images = FormMDIMain.ImageList_Ord
      LeftButton.CustomHint = BalloonHint
      ParentShowHint = False
      RightButton.CustomHint = BalloonHint
      RightButton.ImageIndex = 34
      RightButton.PressedImageIndex = 4
      RightButton.Visible = True
      ShowHint = True
      TabOrder = 8
      Text = '*.*'
      TextHint = 'File Mask'
      OnChange = edtFileMaskChange
      OnRightButtonClick = edtAppSourceRightButtonClick
    end
    object edtExeName: TButtonedEdit
      Left = 100
      Top = 69
      Width = 150
      Height = 21
      Hint = 
        'If executable file name is empty you can open all the the files ' +
        'inside source folder.'
      ParentShowHint = False
      RightButton.ImageIndex = 34
      RightButton.PressedImageIndex = 4
      RightButton.Visible = True
      ShowHint = True
      TabOrder = 2
      TextHint = 'Executable File Name'
      OnChange = edtExeNameChange
      OnRightButtonClick = edtAppSourceRightButtonClick
    end
    object btnCancel: TButton
      Left = 275
      Top = 385
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 13
      TabStop = False
    end
    object btnOK: TButton
      Left = 194
      Top = 385
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 14
      TabStop = False
      OnClick = btnOKClick
    end
    object edtGroupName: TButtonedEdit
      Left = 100
      Top = 15
      Width = 250
      Height = 21
      Images = FormMDIMain.ImageList_Ord
      RightButton.ImageIndex = 34
      RightButton.PressedImageIndex = 4
      RightButton.Visible = True
      TabOrder = 0
      TextHint = 'Group Name'
      OnChange = edtGroupNameChange
      OnEnter = edtGroupNameEnter
      OnKeyPress = edtGroupNameKeyPress
      OnRightButtonClick = edtAppSourceRightButtonClick
    end
    object cbFixedParams: TComboBox
      Left = 121
      Top = 204
      Width = 129
      Height = 21
      Style = csDropDownList
      TabOrder = 10
      TextHint = 'Fixed Prameter'
      OnSelect = cbFixedParamsSelect
    end
    object chkCreateFolder: TCheckBox
      Left = 264
      Top = 179
      Width = 90
      Height = 17
      TabStop = False
      Caption = ' Create Folder'
      Checked = True
      State = cbChecked
      TabOrder = 9
      OnClick = chkCreateFolderClick
    end
    object cbGroupType: TComboBox
      Left = 261
      Top = 69
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemIndex = 2
      TabOrder = 3
      TabStop = False
      Text = 'Zip Files'
      OnChange = cbGroupTypeChange
      Items.Strings = (
        'Application'
        'Folder'
        'Zip Files')
    end
    object cbDisplayLabel: TComboBox
      Left = 100
      Top = 42
      Width = 105
      Height = 21
      TabOrder = 1
      OnKeyPress = edtGroupNameKeyPress
    end
    object grpBranching: TGroupBox
      Left = 17
      Top = 231
      Width = 333
      Height = 141
      Caption = '  Branching  '
      TabOrder = 12
      object Label8: TLabel
        Left = 177
        Top = 82
        Width = 69
        Height = 13
        Caption = 'Main Branch'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label9: TLabel
        Left = 177
        Top = 110
        Width = 68
        Height = 13
        Caption = 'No: Of Builds'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label10: TLabel
        Left = 15
        Top = 82
        Width = 85
        Height = 13
        Caption = 'Current Branch'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object chkMajor: TCheckBox
        Left = 15
        Top = 53
        Width = 97
        Height = 17
        TabStop = False
        Caption = 'Major Version'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = chkMajorClick
      end
      object chkMinor: TCheckBox
        Left = 119
        Top = 53
        Width = 97
        Height = 17
        TabStop = False
        Caption = 'Minor Version'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = chkMajorClick
      end
      object chkRelease: TCheckBox
        Left = 222
        Top = 53
        Width = 97
        Height = 17
        TabStop = False
        Caption = 'Release Version'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnClick = chkMajorClick
      end
      object edtPrefix: TLabeledEdit
        Left = 53
        Top = 22
        Width = 110
        Height = 21
        EditLabel.Width = 33
        EditLabel.Height = 13
        EditLabel.Caption = 'Prefix'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 0
        TextHint = 'Prefix'
      end
      object edtSufix: TLabeledEdit
        Left = 210
        Top = 22
        Width = 110
        Height = 21
        EditLabel.Width = 28
        EditLabel.Height = 13
        EditLabel.Caption = 'Sufix'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 1
        TextHint = 'Sufix'
      end
      object sEdtMainBranch: TSpinEdit
        Left = 254
        Top = 79
        Width = 65
        Height = 22
        Enabled = False
        MaxValue = 9999
        MinValue = 0
        TabOrder = 3
        Value = 0
      end
      object sEdtNoOfBuilds: TSpinEdit
        Left = 254
        Top = 107
        Width = 65
        Height = 22
        MaxValue = 25
        MinValue = 0
        TabOrder = 4
        Value = 25
      end
      object sEdtCurrBranch: TSpinEdit
        Left = 111
        Top = 79
        Width = 52
        Height = 22
        Enabled = False
        MaxValue = 9999
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object chkCreateBranchFolder: TCheckBox
        Left = 15
        Top = 109
        Width = 143
        Height = 17
        TabStop = False
        Caption = ' Create Branch Folders'
        Enabled = False
        TabOrder = 8
      end
    end
    object chkSkipRecent: TCheckBox
      Left = 264
      Top = 206
      Width = 90
      Height = 17
      TabStop = False
      Caption = ' Skip Recent'
      TabOrder = 11
    end
    object btnTemplate: TButton
      Left = 17
      Top = 385
      Width = 90
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Template'
      DropDownMenu = PopupMenuTemplate
      ImageIndex = 9
      Images = FormMDIMain.ImageList_20
      Style = bsSplitButton
      TabOrder = 15
    end
    object chkParameter: TCheckBox
      Left = 100
      Top = 206
      Width = 15
      Height = 17
      Hint = 'Disable parameter browser with a fixed parameter.'
      TabStop = False
      TabOrder = 16
      OnClick = chkParameterClick
    end
    object edtAppSourceCopy: TButtonedEdit
      Left = 100
      Top = 123
      Width = 221
      Height = 21
      Images = FormMDIMain.ImageList_Ord
      ReadOnly = True
      RightButton.ImageIndex = 34
      RightButton.PressedImageIndex = 4
      RightButton.Visible = True
      TabOrder = 6
      TextHint = 'Source Folder'
      OnChange = edtAppSourceCopyChange
      OnRightButtonClick = edtAppSourceRightButtonClick
    end
    object cbSourcePrifix: TComboBox
      Left = 100
      Top = 96
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 4
      TabStop = False
      Items.Strings = (
        ''
        'file://')
    end
    object chkRunAsAdmin: TCheckBox
      Left = 212
      Top = 44
      Width = 138
      Height = 17
      TabStop = False
      AllowGrayed = True
      Caption = ' Run as Admin [Inherited]'
      State = cbGrayed
      TabOrder = 17
      OnClick = chkRunAsAdminClick
    end
  end
  object PopupMenuTemplate: TPopupMenu
    AutoHotkeys = maManual
    Images = FormMDIMain.ImageList_20
    Left = 120
    Top = 384
    object PMItemLoadTemplate: TMenuItem
      Caption = 'Load'
      ImageIndex = 19
    end
    object PMItemDeleteTemplate: TMenuItem
      Caption = 'Delete'
      ImageIndex = 4
    end
    object PMItemSaveTemplate: TMenuItem
      Caption = 'Save'
      ImageIndex = 20
      OnClick = PMItemSaveTemplateClick
    end
  end
  object BalloonHint: TBalloonHint
    Left = 152
    Top = 384
  end
end
