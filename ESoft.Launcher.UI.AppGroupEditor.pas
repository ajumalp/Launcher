Unit ESoft.Launcher.UI.AppGroupEditor;

{ ---------------------------------------------------------- }
{ Developed by Muhammad Ajmal p }
{ ajumalp@gmail.com }
{ ---------------------------------------------------------- }

Interface

Uses
   Winapi.Windows,
   Winapi.Messages,
   System.SysUtils,
   System.Variants,
   System.Classes,
   System.Types,
   IniFiles,
   TypInfo,
   Generics.Collections,
   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.StdCtrls,
   Vcl.ExtCtrls,
   Vcl.FileCtrl,
   ESoft.Launcher.Application,
   Vcl.Buttons,
   Vcl.Samples.Spin, 
   Vcl.Menus;

Type
   TFormAppGroupEditor = Class(TForm)
      GroupBox2: TGroupBox;
      Label2: TLabel;
      sBtnBrowseAppSource: TSpeedButton;
      Label3: TLabel;
      sBtnBrowseAppDest: TSpeedButton;
      Label4: TLabel;
      Label5: TLabel;
      edtAppSource: TButtonedEdit;
      edtAppDest: TButtonedEdit;
      edtFileMask: TButtonedEdit;
      edtExeName: TButtonedEdit;
      btnCancel: TButton;
      btnOK: TButton;
      Label1: TLabel;
      edtGroupName: TButtonedEdit;
      Label6: TLabel;
      cbFixedParams: TComboBox;
      chkCreateFolder: TCheckBox;
      cbGroupType: TComboBox;
      Label7: TLabel;
      cbDisplayLabel: TComboBox;
      grpBranching: TGroupBox;
      chkMajor: TCheckBox;
      chkMinor: TCheckBox;
      chkRelease: TCheckBox;
      edtPrefix: TLabeledEdit;
      edtSufix: TLabeledEdit;
      sEdtMainBranch: TSpinEdit;
      Label8: TLabel;
      Label9: TLabel;
      sEdtNoOfBuilds: TSpinEdit;
      Label10: TLabel;
      sEdtCurrBranch: TSpinEdit;
      chkCreateBranchFolder: TCheckBox;
      chkSkipRecent: TCheckBox;
      btnTemplate: TButton;
      PopupMenuTemplate: TPopupMenu;
      PMItemSaveTemplate: TMenuItem;
      PMItemDeleteTemplate: TMenuItem;
      PMItemLoadTemplate: TMenuItem;
      chkParameter: TCheckBox;
      Label11: TLabel;
      sBtnBrowseAppSourceCopy: TSpeedButton;
      edtAppSourceCopy: TButtonedEdit;
      cbSourcePrifix: TComboBox;
      BalloonHint: TBalloonHint;
      chkRunAsAdmin: TCheckBox;
      Procedure sBtnBrowseAppSourceClick(Sender: TObject);
      Procedure btnOKClick(Sender: TObject);
      Procedure FormActivate(Sender: TObject);
      Procedure edtAppSourceRightButtonClick(Sender: TObject);
      Procedure edtGroupNameKeyPress(Sender: TObject; Var Key: Char);
      Procedure edtGroupNameEnter(Sender: TObject);
      Procedure edtGroupNameChange(Sender: TObject);
      Procedure FormCreate(Sender: TObject);
      Procedure chkMajorClick(Sender: TObject);
      Procedure chkCreateFolderClick(Sender: TObject);
      procedure cbGroupTypeChange(Sender: TObject);
      procedure edtExeNameChange(Sender: TObject);
      procedure edtAppDestChange(Sender: TObject);
      procedure edtFileMaskChange(Sender: TObject);
      Procedure PMItemSaveTemplateClick(Sender: TObject);
      procedure chkParameterClick(Sender: TObject);
      procedure cbFixedParamsSelect(Sender: TObject);
      procedure edtAppSourceCopyChange(Sender: TObject);
      Procedure chkRunAsAdminClick(Sender: TObject);
   Private
      // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
   Strict Private
      // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
      FTempExecutable, FTempDestFolder, FTempFileMask, FTempSourceFolderCopyTo: String;
      FInitialized: Boolean;
      FUpdateFileMakWithName: Boolean;
      FAppGroup: TEApplicationGroup;

      Procedure AssignGroup(Const aAppGroup: TEApplicationGroup);
      Procedure ReloadTemplatesMenu;
      Procedure TemplateLoadClick(aSender: TObject);
      Procedure TemplateDeleteClick(aSender: TObject);
   Public
      { Public declarations }
      Constructor Create(aOwner: TComponent; Const aAppGroup: TEApplicationGroup = Nil); Reintroduce;

      Class Function CreatGroupFromFile(Const aFileName: String = ''): TModalResult;
      Procedure LoadData(Const aAppGroup: TEApplicationGroup; Const aIsTemplate: Boolean = False);

   Published
      Property AppGroup: TEApplicationGroup Read FAppGroup;
   End;

Var
   FormAppGroupEditor: TFormAppGroupEditor;

Implementation

{$R *.dfm}

Uses
   UnitMDIMain, 
   ESoft.Utils;

Type
   hTStringList = Class Helper For TStringList
   Public
      Function AddText(Const aText: String): String;
      Function InCaseSensitiveIndexOf(Const aText: String): Integer;
   End;

Procedure TFormAppGroupEditor.btnOKClick(Sender: TObject);
Begin
   If Not Assigned(FAppGroup) Then
   Begin
      If Trim(edtGroupName.Text) = '' Then
      Begin
         MessageDlg('Name cannot be empty', mtError, [mbOK], 0);
         Abort;
      End;
      Try
         FAppGroup := FormMDIMain.AppGroups.AddItem(edtGroupName.Text);
      Except
         On Ex:Exception Do
         Begin
            edtGroupName.SetFocus;
            Raise;
         End;
      End;
   End;

   AssignGroup(AppGroup);
   AppGroup.SaveData(FormMDIMain.ParentFolder + cGroup_INI);
   ModalResult := mrOk;
End;

procedure TFormAppGroupEditor.cbFixedParamsSelect(Sender: TObject);
begin
   chkParameter.Checked := False;
end;

procedure TFormAppGroupEditor.cbGroupTypeChange(Sender: TObject);
begin
   chkCreateFolder.Enabled := cbGroupType.ItemIndex = cGroupType_ZipFiles;
   grpBranching.Enabled := cbGroupType.ItemIndex = cGroupType_ZipFiles;

   edtFileMask.Enabled := cbGroupType.ItemIndex <> cGroupType_Application;
   If Not edtFileMask.Enabled Then
      edtFileMask.Clear
   Else
      edtFileMask.Text := FTempFileMask;

   edtAppDest.Enabled := cbGroupType.ItemIndex = cGroupType_ZipFiles;
   If Not edtAppDest.Enabled Then
      edtAppDest.Clear
   Else
      edtAppDest.Text := FTempDestFolder;

   edtAppSourceCopy.Enabled := cbGroupType.ItemIndex <> cGroupType_Application;
   If Not edtAppSourceCopy.Enabled Then
      edtAppSourceCopy.Clear
   Else
      edtAppSourceCopy.Text := FTempSourceFolderCopyTo;

   edtExeName.Enabled := cbGroupType.ItemIndex <> cGroupType_Folder;
   If Not edtExeName.Enabled Then
      edtExeName.Clear
   Else
      edtExeName.Text := FTempExecutable;
end;

Procedure TFormAppGroupEditor.chkCreateFolderClick(Sender: TObject);
Begin
   chkCreateBranchFolder.Enabled := chkCreateFolder.Checked And edtPrefix.Enabled;
End;

Procedure TFormAppGroupEditor.chkMajorClick(Sender: TObject);
Begin
   sEdtMainBranch.Enabled := chkMajor.Checked Or chkMinor.Checked Or chkRelease.Checked;
   sEdtCurrBranch.Enabled := sEdtMainBranch.Enabled;
   chkCreateFolderClick(Nil);
End;

Procedure TFormAppGroupEditor.chkParameterClick(Sender: TObject);
Begin
   If chkParameter.Checked Then
      cbFixedParams.Style := csDropDown
   Else
      cbFixedParams.Style := csDropDownList;
End;

procedure TFormAppGroupEditor.chkRunAsAdminClick(Sender: TObject);
begin
   Case chkRunAsAdmin.State Of
      cbUnchecked: chkRunAsAdmin.Caption := ' Run as Admin [Never]';
      cbChecked: chkRunAsAdmin.Caption := ' Run as Admin [Always]';
      cbGrayed: chkRunAsAdmin.Caption := ' Run as Admin [Inherited]';
   End;
end;

Constructor TFormAppGroupEditor.Create(aOwner: TComponent; Const aAppGroup: TEApplicationGroup);
Begin
   FInitialized := False;
   Inherited Create(aOwner);

   cbFixedParams.Clear;
   cbFixedParams.Items.Add(cParameterAll);
   cbFixedParams.Items.AddStrings(FormMDIMain.ParamCategories);

   FAppGroup := aAppGroup;
   edtGroupName.Enabled := Not Assigned(FAppGroup);
End;

Class Function TFormAppGroupEditor.CreatGroupFromFile(Const aFileName: String): TModalResult;
var
   bIsDirectory: Boolean;
   varAppGroup: TEApplicationGroup;
begin
   Result := mrNone;
   bIsDirectory := False;
   Try
      varAppGroup := FormMDIMain.AppGroups.Items[ExtractFileName(aFileName)];
   Except
      varAppGroup := Nil;
   End;

   FormAppGroupEditor := TFormAppGroupEditor.Create(FormMDIMain, varAppGroup);
   Try
      If (varAppGroup = Nil) And (aFileName <> '') Then
      Begin
         bIsDirectory := DirectoryExists(aFileName);
         With FormAppGroupEditor Do
         Begin
            edtAppDest.Clear;
            cbGroupType.ItemIndex := cGroupType_Folder;
            edtGroupName.Text := ExtractFileName(aFileName);
            If bIsDirectory Then
            Begin
               edtAppSource.Text := aFileName;
               chkCreateFolder.Checked := False;
               chkSkipRecent.Checked := True;
               chkParameter.Checked := True;
            End
            Else
            Begin
               edtFileMask.Clear;
               cbGroupType.ItemIndex := cGroupType_Application;
               edtExeName.Text := edtGroupName.Text;
               edtAppSource.Text := ExtractFilePath(aFileName);
               cbFixedParams.ItemIndex := -1;
            End;
            cbGroupTypeChange(Nil);
         End;
      End;
      Result := FormAppGroupEditor.ShowModal;
   Finally
     FreeAndNil(FormAppGroupEditor);
   End;
end;

procedure TFormAppGroupEditor.edtAppDestChange(Sender: TObject);
begin
   If Trim(edtAppDest.Text) <> '' Then
      FTempDestFolder := edtAppDest.Text;
end;

procedure TFormAppGroupEditor.edtAppSourceCopyChange(Sender: TObject);
begin
   If Trim(edtAppSourceCopy.Text) <> '' Then
      FTempSourceFolderCopyTo := edtAppSourceCopy.Text;
end;

Procedure TFormAppGroupEditor.edtAppSourceRightButtonClick(Sender: TObject);
Begin
   TButtonedEdit(Sender).Text := '';
End;

procedure TFormAppGroupEditor.edtExeNameChange(Sender: TObject);
begin
   If Trim(edtExeName.Text) <> '' Then
      FTempExecutable := edtExeName.Text;
end;

procedure TFormAppGroupEditor.edtFileMaskChange(Sender: TObject);
begin
   If Trim(edtFileMask.Text) <> '' Then
      FTempFileMask := edtFileMask.Text;
end;

Procedure TFormAppGroupEditor.edtGroupNameChange(Sender: TObject);
Begin
   If FUpdateFileMakWithName Then
      edtFileMask.Text := edtGroupName.Text;
End;

Procedure TFormAppGroupEditor.edtGroupNameEnter(Sender: TObject);
Begin
   FUpdateFileMakWithName := (edtFileMask.Text = '') Or (edtFileMask.Text = edtGroupName.Text);
End;

Procedure TFormAppGroupEditor.edtGroupNameKeyPress(Sender: TObject; Var Key: Char);
Begin
   If Not(key In ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_', ' ', #46, #8]) Then
      Abort;
End;

Procedure TFormAppGroupEditor.FormActivate(Sender: TObject);
Begin
   If Not FInitialized Then
   Begin
      FInitialized := True;
      If Assigned(FAppGroup) Then
         LoadData(AppGroup);
   End;
End;

Procedure TFormAppGroupEditor.FormCreate(Sender: TObject);
Begin
   cbDisplayLabel.Items := FormMDIMain.DisplayLabels;
   FTempExecutable := edtExeName.Text;
   FTempDestFolder := edtAppDest.Text;
   FTempSourceFolderCopyTo := edtAppSourceCopy.Text;
   FTempFileMask := edtFileMask.Text;
   ReloadTemplatesMenu;
End;

Procedure TFormAppGroupEditor.LoadData(Const aAppGroup: TEApplicationGroup; Const aIsTemplate: Boolean);

   Function _AssignValue(Const aControl: TWinControl; Const aValue: String): Boolean;
   Begin
      Result := Not (aIsTemplate And (Trim(aValue) = ''));
      If Result Then
         SetPropValue(aControl, 'Text', aValue);
   End;

Begin
   If Not aIsTemplate Then
      edtGroupName.Text := aAppGroup.Name;

   With aAppGroup Do
   Begin
      _AssignValue(edtExeName, ExecutableName);
      _AssignValue(edtAppSource, SourceFolder);
      _AssignValue(edtAppSourceCopy, SourceFolderCopyTo);
      _AssignValue(edtAppDest, DestFolder);
      _AssignValue(edtFileMask, FileMask);
      _AssignValue(edtPrefix, BranchingPrefix);
      _AssignValue(edtSufix, BranchingSufix);
      _AssignValue(cbDisplayLabel, DisplayLabel);

      chkParameter.Checked := ISFixedParameter;
      If ISFixedParameter Then
         _AssignValue(cbFixedParams, FixedParameter)
      Else
         cbFixedParams.ItemIndex := cbFixedParams.Items.IndexOf(FixedParameter);
   End;
   cbGroupType.ItemIndex := aAppGroup.GroupType;
   cbSourcePrifix.ItemIndex := cbSourcePrifix.Items.IndexOf(aAppGroup.SourceFolderPrefix);

   chkCreateFolder.Checked := aAppGroup.CreateFolder;
   chkSkipRecent.Checked := aAppGroup.SkipFromRecent;
   chkRunAsAdmin.State := aAppGroup.RunAsAdmin;
   chkMajor.Checked := aAppGroup.IsMajorBranching;
   chkMinor.Checked := aAppGroup.IsMinorBranching;
   chkRelease.Checked := aAppGroup.IsReleaseBranching;
   chkCreateBranchFolder.Checked := aAppGroup.CreateBranchFolder;

   sEdtMainBranch.Value := aAppGroup.MainBranch;
   sEdtNoOfBuilds.Value := aAppGroup.NoOfBuilds;
   sEdtCurrBranch.Value := aAppGroup.CurrentBranch;

   cbGroupTypeChange(Nil);
   chkRunAsAdminClick(chkRunAsAdmin);
End;

Procedure TFormAppGroupEditor.PMItemSaveTemplateClick(Sender: TObject);
var
   varTemplate: TEApplicationGroup;
   sTemplateName: String;
Begin
   While True Do
   Begin
      sTemplateName := edtGroupName.Text;
      If Not InputQuery('Save Template', 'Name', sTemplateName) Then
         Exit;

      If Trim(sTemplateName) = '' Then
      Begin
         MessageDlg('Name cannot be empty', mtError, [mbOK], 0);
         Continue;
      End
      Else
      Begin
         Try
            varTemplate := FormMDIMain.AppGroupTemplates.AddItem(sTemplateName);
         Except
            MessageDlg('A template with same name already exist.', mtError, [mbOK], 0);
            Continue;
         End;
      End;
      Break;
   End;

   Assert(Assigned(varTemplate));
   AssignGroup(varTemplate);
   // Overwrite the name with template name { Ajmal }
   varTemplate.Name := sTemplateName;
   varTemplate.SaveData(FormMDIMain.ParentFolder + cTemplateGroup_INI);
   ReloadTemplatesMenu;
End;

Procedure TFormAppGroupEditor.ReloadTemplatesMenu;

   Function _CreateMenuItem(Const aName: String; Const aClickEvent: TNotifyEvent): TMenuItem;
   Begin
      Result := PopupMenuTemplate.CreateMenuItem;
      Result.Caption := aName;
      Result.Tag := NativeInt(FormMDIMain.AppGroupTemplates[aName]);
      Result.OnClick := aClickEvent;
   End;

var
   sTempGrpName: String;
   varMenuItem: TMenuItem;
   varTempGrpNames: TArray<String>;
Begin
   varTempGrpNames := FormMDIMain.AppGroupTemplates.Keys.ToArray;
   TArray.Sort<String>(varTempGrpNames);

   PMItemLoadTemplate.Clear;
   PMItemDeleteTemplate.Clear;
   For sTempGrpName In varTempGrpNames Do
   Begin
      PMItemLoadTemplate.Add(_CreateMenuItem(sTempGrpName, TemplateLoadClick));
      PMItemDeleteTemplate.Add(_CreateMenuItem(sTempGrpName, TemplateDeleteClick));
   End;
End;

Procedure TFormAppGroupEditor.AssignGroup(const aAppGroup: TEApplicationGroup);
Begin
   aAppGroup.DisplayLabel := FormMDIMain.DisplayLabels.AddText(cbDisplayLabel.Text);
   aAppGroup.FixedParameter := cbFixedParams.Text;
   aAppGroup.ISFixedParameter := chkParameter.Checked;
   aAppGroup.ExecutableName := edtExeName.Text;
   aAppGroup.Name := edtGroupName.Text;
   aAppGroup.SourceFolder := edtAppSource.Text;
   If cbSourcePrifix.ItemIndex = 0 Then
      aAppGroup.SourceFolderPrefix := ''
   Else
      aAppGroup.SourceFolderPrefix := cbSourcePrifix.Text;
   aAppGroup.SourceFolderCopyTo := edtAppSourceCopy.Text;
   aAppGroup.DestFolder := edtAppDest.Text;
   aAppGroup.FileMask := edtFileMask.Text;
   aAppGroup.CreateFolder := chkCreateFolder.Enabled And chkCreateFolder.Checked;
   aAppGroup.SkipFromRecent := chkSkipRecent.Checked;
   aAppGroup.RunAsAdmin := chkRunAsAdmin.State;
   aAppGroup.GroupType := cbGroupType.ItemIndex;

   aAppGroup.IsMajorBranching := chkMajor.Checked;
   aAppGroup.IsMinorBranching := chkMinor.Checked;
   aAppGroup.IsReleaseBranching := chkRelease.Checked;
   aAppGroup.BranchingPrefix := edtPrefix.Text;
   aAppGroup.BranchingSufix := edtSufix.Text;
   aAppGroup.MainBranch := sEdtMainBranch.Value;
   aAppGroup.CurrentBranch := sEdtCurrBranch.Value;
   aAppGroup.NoOfBuilds := sEdtNoOfBuilds.Value;
   aAppGroup.CreateBranchFolder := chkCreateBranchFolder.Checked;
End;

Procedure TFormAppGroupEditor.sBtnBrowseAppSourceClick(Sender: TObject);
Var
   sPath: String;
Begin
   If SelectDirectory('Select a folder', '', sPath, [sdNewFolder, sdShowEdit], Self) Then
   Begin
      If Sender = sBtnBrowseAppSource Then
      Begin
         edtAppSource.Text := sPath;
         If edtAppDest.Text = '' Then
            edtAppDest.Text := sPath;
      End
      Else If Sender = sBtnBrowseAppDest Then
         edtAppDest.Text := sPath
      Else If Sender = sBtnBrowseAppSourceCopy Then
         edtAppSourceCopy.Text := sPath;
   End;
End;

procedure TFormAppGroupEditor.TemplateDeleteClick(aSender: TObject);
var
   varMenuItem: TMenuItem Absolute aSender;
begin
   If MessageDlg('Are you sure you want to delete ' + varMenuItem.Caption, mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo Then
      Exit;

   FormMDIMain.AppGroupTemplates.DeleteGroup(FormMDIMain.ParentFolder + cTemplateGroup_INI, varMenuItem.Caption);
   ReloadTemplatesMenu;
end;

Procedure TFormAppGroupEditor.TemplateLoadClick(aSender: TObject);
var
   varMenuItem: TMenuItem Absolute aSender;
   varTempGroup: TEApplicationGroup;
Begin
   varTempGroup := Pointer(varMenuItem.Tag);
   If Assigned(varTempGroup) Then
      LoadData(varTempGroup, True);
End;

{ hTStringList }

Function hTStringList.AddText(Const aText: String): String;
Var
   iIndex: Integer;
Begin
   iIndex := InCaseSensitiveIndexOf(aText);
   If iIndex = -1 Then
      iIndex := Add(aText);
   Result := Self[iIndex];
End;

Function hTStringList.InCaseSensitiveIndexOf(Const aText: String): Integer;
Var
   iCntr: Integer;
Begin
   For iCntr := 0 To Pred(Count) Do
   Begin
      If SameText(aText, Self[iCntr]) Then
         Exit(iCntr)
   End;
   Result := -1;
End;

End.
