Unit ESoft.Launcher.UI.ParamBrowser;

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
   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.StdCtrls,
   Vcl.ExtCtrls,
   Vcl.Grids,
   Vcl.DBGrids,
   Vcl.Menus,
   Data.DB,
   Datasnap.DBClient,
{$IFDEF AbbreviaZipper}
   AbBase,
   AbBrowse,
   AbZBrows,
   AbUnzper,
   AbComCtrls,
{$ENDIF}
   Generics.Collections,
   ESoft.Launcher.Parameter,
   ESoft.Launcher.Application,
   ESoft.Utils,
   ESoft.Launcher.RecentItems;

Type
   TFormParameterBrowser = Class(TForm)
      PanelSearch: TPanel;
      Label1: TLabel;
      Panel1: TPanel;
      Label2: TLabel;
      btnCancel: TButton;
      btnOK: TButton;
      EditParam: TEdit;
      dbGridParameters: TDBGrid;
      MainMenu: TMainMenu;
      MenuFile: TMenuItem;
      MItemClose: TMenuItem;
      edtFilter: TButtonedEdit;
      SourceParametres: TDataSource;
      ClntDSetParameters: TClientDataSet;
      ClntDSetParametersParamCode: TStringField;
      ClntDSetParametersParamText: TStringField;
      MItemSearch: TMenuItem;
      MenuSearch: TMenuItem;
      btnAdditionalParameters: TButton;
      PopupMenuAdditionalParameters: TPopupMenu;
      PopupMenu: TPopupMenu;
      PMItemAdd: TMenuItem;
      PMItemDelete: TMenuItem;
      PMItemEdit: TMenuItem;
      N1: TMenuItem;
      PMItemUpdate: TMenuItem;
      ClntDSetParametersParamConnection: TStringField;
      ClntDSetParametersData: TIntegerField;
      lblParameter: TLabel;
      lbAdditionalParams: TListBox;
      pnlProgress: TPanel;
      PopupMenuRunApp: TPopupMenu;
      PMItemRun: TMenuItem;
      PMItemRunasadministrator: TMenuItem;
      ClntDSetParametersParamCategory: TStringField;
      cbCategories: TComboBox;
      PMItemCopy: TMenuItem;
      Procedure edtFilterKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
      Procedure edtFilterChange(Sender: TObject);
      Procedure MItemSearchClick(Sender: TObject);
      Procedure MItemCloseClick(Sender: TObject);
      Procedure FormCreate(Sender: TObject);
      Procedure ClntDSetParametersAfterScroll(DataSet: TDataSet);
      Procedure PMItemAddClick(Sender: TObject);
      Procedure btnAdditionalParametersClick(Sender: TObject);
      Procedure PMItemEditClick(Sender: TObject);
      Procedure dbGridParametersCellClick(Column: TColumn);
      Procedure EditParamChange(Sender: TObject);
      Procedure ClntDSetParametersAfterOpen(DataSet: TDataSet);
      Procedure PMItemDeleteClick(Sender: TObject);
      Procedure btnOKClick(Sender: TObject);
      Procedure lbAdditionalParamsExit(Sender: TObject);
      Procedure FormActivate(Sender: TObject);
      Procedure PMItemUpdateClick(Sender: TObject);
      Procedure dbGridParametersDblClick(Sender: TObject);
      Procedure PopupMenuPopup(Sender: TObject);
      Function HasCategory: Boolean;
      Procedure cbCategoriesChange(Sender: TObject);
      Procedure PMItemCopyClick(Sender: TObject);
      // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
   Strict Private
      // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
      FZipProgressBarArchive, FZipProgressBarItem: TObject;
      FSelectedApplication: IEApplication;

      Function SelectedParameter: TEParameterBase;
      Function GetParameter: String;
      Procedure LoadParametrs;
   Protected
      Procedure CreateParams(Var Params: TCreateParams); Override;
   Public
      { Public declarations }
      Constructor Create(aOwner: TComponent; Const aApplication: IEApplication = Nil); Reintroduce;

      Property Parameter: String Read GetParameter;
      Property ZipProgressBarArchive: TObject Read FZipProgressBarArchive;
      Property ZipProgressBarItem: TObject Read FZipProgressBarItem;
   End;

Var
   FormParameterBrowser: TFormParameterBrowser = Nil;

Implementation

{$R *.dfm}

Uses
   UnitMDIMain,
   ESoft.Launcher.UI.ParamEditor;

Procedure TFormParameterBrowser.btnAdditionalParametersClick(Sender: TObject);
Begin
   lbAdditionalParams.Visible := Not lbAdditionalParams.Visible;
   If lbAdditionalParams.Visible Then
      lbAdditionalParams.SetFocus;
End;

Procedure TFormParameterBrowser.btnOKClick(Sender: TObject);
Begin
   If Sender <> btnOK Then
      btnOK.ElevationRequired := Sender = PMItemRunasadministrator;
   FormMDIMain.IsRunAsAdmin := btnOK.ElevationRequired;

   Assert(Assigned(FSelectedApplication));

   If FSelectedApplication.CopyFromSourceFolder Then
   Begin
     FSelectedApplication.UnZip;
     FSelectedApplication.RunExecutable(Parameter);
     FSelectedApplication.LastUsedParamName := ClntDSetParametersParamCode.AsString;
   End;
   ModalResult := mrOk;
End;

procedure TFormParameterBrowser.cbCategoriesChange(Sender: TObject);
begin
   edtFilterChange(Nil);
end;

Procedure TFormParameterBrowser.ClntDSetParametersAfterOpen(DataSet: TDataSet);
Begin
   ClntDSetParametersAfterScroll(Nil);
End;

Procedure TFormParameterBrowser.ClntDSetParametersAfterScroll(DataSet: TDataSet);
Begin
   EditParam.Text := Trim(ClntDSetParametersParamText.AsString);
   If Trim(ClntDSetParametersParamConnection.AsString) <> '' Then
      EditParam.Text := EditParam.Text + ' -a ' + Trim(ClntDSetParametersParamConnection.AsString);
End;

Constructor TFormParameterBrowser.Create(aOwner: TComponent; Const aApplication: IEApplication);
Begin
   Inherited Create(aOwner);

   FSelectedApplication := aApplication;
   If Assigned(FSelectedApplication) Then
      Caption := Format('Parameter Browser [%s]', [FSelectedApplication.ActualName]);
End;

Procedure TFormParameterBrowser.CreateParams(Var Params: TCreateParams);
Begin
   Inherited;

   If Owner = Application Then
      Params.ExStyle := Params.ExStyle Or WS_EX_APPWINDOW;
End;

Procedure TFormParameterBrowser.dbGridParametersCellClick(Column: TColumn);
Begin
   lbAdditionalParams.Hide;
   ClntDSetParametersAfterScroll(Nil);
End;

Procedure TFormParameterBrowser.dbGridParametersDblClick(Sender: TObject);
Begin
   If btnOK.Enabled Then
      btnOK.Click;
End;

Procedure TFormParameterBrowser.EditParamChange(Sender: TObject);
Begin
   lblParameter.Caption := 'Parameter [' + Trim(Parameter) + ']';
End;

Procedure TFormParameterBrowser.edtFilterChange(Sender: TObject);
Var
   iCnt: Integer;
   TempSearchArray: Array [0 .. 3] Of WideString;
   sCategoryFilter: String;
Const
   TempFieldArray: Array [0 .. 3] Of WideString = ('ParamCode', 'ParamText', 'ParamConnection', 'ParamCategory');
Begin
   For iCnt := 0 To Pred(Length(TempSearchArray)) Do
   Begin
      With TButtonedEdit(Sender) Do
         TempSearchArray[iCnt] := IfThen(Trim(Text) = '', '', 'UPPER(' + TempFieldArray[iCnt] + ') LIKE ' + QuotedStr('%' + UpperCase(Text) + '%'));
   End;
   With ClntDSetParameters Do
   Begin
      Filtered := False;
      Filter := '';
      For iCnt := 0 To Pred(Length(TempSearchArray)) Do
      Begin
         Filter := IfThen((Trim(Filter) <> '') And (Not StrEndsWith(Filter, 'Or ')), Filter + ' Or ', Filter);
         Filter := Filter + TempSearchArray[iCnt];
      End;
      If StrEndsWith(Filter, 'Or ') Then
         Filter := StrSubString(3, Filter);
         
      If Trim(cbCategories.Text) <> cParameterAll Then
      Begin
         sCategoryFilter := Format('UPPER(ParamCategory) = %s', [QuotedStr(UpperCase(cbCategories.Text))]);
         If Trim(Filter) = '' Then
            Filter := sCategoryFilter
         Else 
            Filter := Format('(%s) And (%s)', [Filter, sCategoryFilter]);
      End;

      Filtered := True;
   End;
End;

Procedure TFormParameterBrowser.edtFilterKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
   Case Key Of
      VK_UP:
         ClntDSetParameters.Prior;
      VK_DOWN:
         ClntDSetParameters.Next;
   End;
End;

Procedure TFormParameterBrowser.FormActivate(Sender: TObject);
Begin
   ClntDSetParametersAfterScroll(Nil);
End;

Procedure TFormParameterBrowser.FormCreate(Sender: TObject);

   Procedure AddProgressbars;
   Begin
{$IFDEF AbbreviaZipper}
      FZipProgressBarArchive := TAbProgressBar.Create(Self);
      With TAbProgressBar(FZipProgressBarArchive) Do
      Begin
         Parent := pnlProgress;
         Align := alLeft;
         Width := (pnlProgress.Width Div 2);
         AlignWithMargins := True;
      End;
      FZipProgressBarItem := TAbProgressBar.Create(Self);
      With TAbProgressBar(FZipProgressBarItem) Do
      Begin
         Parent := pnlProgress;
         Align := alClient;
         AlignWithMargins := True;
      End;
{$ELSE}
      pnlProgress.Hide;
{$ENDIF}
   End;

Begin
   btnOK.ElevationRequired := FormMDIMain.IsRunAsAdmin;
   dbGridParameters.Columns[0].Title.Font.Color := clBlue;
   AddProgressbars;
   LoadParametrs;
   
   cbCategories.Clear;
   cbCategories.Items.Add(cParameterAll);
   cbCategories.Items.AddStrings(FormMDIMain.ParamCategories);
   If HasCategory Then
   Begin
      cbCategories.ItemIndex := cbCategories.Items.IndexOf(FSelectedApplication.FixedParameter);
      edtFilterChange(Nil);
   End
   Else
   Begin
      cbCategories.ItemIndex := cbCategories.Items.IndexOf(cParameterAll);
   End;

   btnOK.Enabled := Assigned(FSelectedApplication);
   If Assigned(FSelectedApplication) Then
   Begin
      If Not ClntDSetParameters.Locate(ClntDSetParametersParamCode.FieldName, FSelectedApplication.LastUsedParamName, []) Then
         ClntDSetParameters.First;
   End
End;

Function TFormParameterBrowser.GetParameter: String;
Var
   iCntr: Integer;
   varCurrMenuItem: TMenuItem;
   varSelectedConnParam: TEConnectionParameter;
   bExcludeAdditionalParams: Boolean;
Begin
   Result := '';
   bExcludeAdditionalParams := False;

   If ClntDSetParameters.RecordCount > 0 Then
   Begin
      varSelectedConnParam := TEConnectionParameter(ClntDSetParametersData.AsInteger);
      bExcludeAdditionalParams := varSelectedConnParam.ExcludeAdditionalParams;
   End;

   If Not bExcludeAdditionalParams Then
   Begin
     For iCntr := 0 To Pred(PopupMenuAdditionalParameters.Items.Count) Do
     Begin
        varCurrMenuItem := PopupMenuAdditionalParameters.Items[iCntr];
        If varCurrMenuItem.Checked Then
           Result := Result + ' ' + Trim(varCurrMenuItem.Hint);
     End;
   End;

   Result := Trim(Trim(Result) + ' ' + Trim(EditParam.Text));
End;

Procedure TFormParameterBrowser.lbAdditionalParamsExit(Sender: TObject);
Begin
   lbAdditionalParams.Hide;
End;

Function TFormParameterBrowser.HasCategory: Boolean;
Begin
   Result := Assigned(FSelectedApplication)
      And (Not FSelectedApplication.ISFixedParameter)
      And (FSelectedApplication.FixedParameter <> '')
      And (FormMDIMain.ParamCategories.IndexOf(FSelectedApplication.FixedParameter) <> -1);
End;

Procedure TFormParameterBrowser.LoadParametrs;
Var
   varParameter: TEParameterBase;
   varCurrMenuItem: TMenuItem;
   varParamNames: TArray<String>;
   sCurrParamName: String;
Begin
   ClntDSetParameters.Close;
   ClntDSetParameters.CreateDataSet;
   lbAdditionalParams.Clear;
   PopupMenuAdditionalParameters.Items.Clear;

   // Sort the TDictionary keys. { Ajmal }
   varParamNames := FormMDIMain.Parameters.Keys.ToArray;
   TArray.Sort<String>(varParamNames);
   For sCurrParamName In varParamNames Do
   Begin
      varParameter := FormMDIMain.Parameters[sCurrParamName];
      If varParameter Is TEConnectionParameter Then
      Begin
         ClntDSetParameters.Insert;
         ClntDSetParametersParamCode.AsString := varParameter.Name;
         ClntDSetParametersParamText.AsString := varParameter.Parameter;
         ClntDSetParametersParamConnection.AsString := TEConnectionParameter(varParameter).Connection;
         ClntDSetParametersParamCategory.AsString := varParameter.ParamCategory;
         ClntDSetParametersData.AsInteger := Nativeint(varParameter);
      End
      Else If varParameter Is TEAdditionalParameter Then
      Begin
         lbAdditionalParams.AddItem(varParameter.Name, varParameter);
         varCurrMenuItem := TMenuItem.Create(PopupMenuAdditionalParameters.Items);
         varCurrMenuItem.AutoCheck := True;
         varCurrMenuItem.Checked := TEAdditionalParameter(varParameter).DefaultInclude;
         varCurrMenuItem.Caption := varParameter.Name;
         varCurrMenuItem.Hint := varParameter.Parameter;
         varCurrMenuItem.OnClick := EditParamChange;
         PopupMenuAdditionalParameters.Items.Add(varCurrMenuItem);
      End;
   End;

   If ClntDSetParameters.State In [dsInsert, dsEdit] Then
      ClntDSetParameters.Post;
   ClntDSetParametersAfterScroll(Nil);
   FormMDIMain.LoadParamCategories;
End;

Procedure TFormParameterBrowser.MItemCloseClick(Sender: TObject);
Begin
   btnCancel.Click;
End;

Procedure TFormParameterBrowser.MItemSearchClick(Sender: TObject);
Begin
   edtFilter.SetFocus;
   edtFilter.SelectAll;
End;

Procedure TFormParameterBrowser.PMItemAddClick(Sender: TObject);
Begin
   FormParamEditor := TFormParamEditor.Create(Self);
   Try
      If FormParamEditor.ShowModal = mrOk Then
         LoadParametrs;
   Finally
      FormParamEditor.Free;
   End;
End;

Procedure TFormParameterBrowser.PMItemCopyClick(Sender: TObject);
Begin
   FormParamEditor := TFormParamEditor.Create(Self);
   Try
      FormParamEditor.LoadData(SelectedParameter);
      If FormParamEditor.ShowModal = mrOk Then
         LoadParametrs;
   Finally
      FormParamEditor.Free;
   End;
End;

Procedure TFormParameterBrowser.PMItemDeleteClick(Sender: TObject);
Var
   varParam: TEParameterBase;
Begin
   If MessageDlg('Are you sure you want to delete ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes Then
   Begin
      varParam := SelectedParameter;
      If Assigned(varParam) And varParam.InheritsFrom(TEParameterBase) Then
         FormMDIMain.Parameters.DeleteItemByName(varParam.Name);
      LoadParametrs;
   End;
End;

Procedure TFormParameterBrowser.PMItemEditClick(Sender: TObject);
Begin
   FormParamEditor := TFormParamEditor.Create(Self, SelectedParameter);
   Try
      If FormParamEditor.ShowModal = mrOk Then
         LoadParametrs;
   Finally
      FormParamEditor.Free;
   End;
End;

Procedure TFormParameterBrowser.PMItemUpdateClick(Sender: TObject);
Begin
   LoadParametrs;
End;

Procedure TFormParameterBrowser.PopupMenuPopup(Sender: TObject);
Var
   varSelectedParam: TEParameterBase;
Begin
   varSelectedParam := SelectedParameter;
   PMItemDelete.Enabled := Assigned(varSelectedParam);
   PMItemEdit.Enabled := PMItemDelete.Enabled;
End;

Function TFormParameterBrowser.SelectedParameter: TEParameterBase;
Var
   varSelected: TObject;
Begin
   Result := Nil;
   varSelected := Nil;

   If (PopupMenu.PopupComponent = lbAdditionalParams) And (lbAdditionalParams.ItemIndex <> -1) Then
      varSelected := lbAdditionalParams.Items.Objects[lbAdditionalParams.ItemIndex]
   Else If PopupMenu.PopupComponent = dbGridParameters Then
      varSelected := Pointer(ClntDSetParametersData.AsInteger);

   If Assigned(varSelected) And varSelected.InheritsFrom(TEParameterBase) Then
      Result := varSelected As TEParameterBase;
End;

End.
