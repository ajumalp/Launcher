Unit ESoft.Launcher.UI.ParamEditor;

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
   ESoft.Launcher.Parameter;

Type
   TFormParamEditor = Class(TForm)
      GroupBox1: TGroupBox;
      btnCancel: TButton;
      btnOK: TButton;
      Label5: TLabel;
      Label1: TLabel;
      edtParameter: TButtonedEdit;
      edtParamName: TButtonedEdit;
      chkDefaultInclude: TCheckBox;
      chkConnectionParam: TCheckBox;
      cbConnections: TComboBox;
      Label2: TLabel;
      cbCategory: TComboBox;
      Label7: TLabel;
      chkExcludeAdditionalParameters: TCheckBox;
      Procedure chkConnectionParamClick(Sender: TObject);
      Procedure btnOKClick(Sender: TObject);
      Procedure edtParamNameKeyPress(Sender: TObject; Var Key: Char);
      Procedure edtParamNameRightButtonClick(Sender: TObject);
      Procedure FormActivate(Sender: TObject);
      Procedure cbConnectionsExit(Sender: TObject);
      procedure cbCategoryKeyPress(Sender: TObject; var Key: Char);
      procedure FormCreate(Sender: TObject);
   Private
      // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
   Strict Private
      // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
      FInitialized: Boolean;
      FParameter: TEParameterBase;

   Public
      { Public declarations }
      Constructor Create(aOwner: TComponent; Const aParameter: TEParameterBase = Nil); Reintroduce;

      Procedure LoadData(const aParameter: TEParameterBase);
   Published
      Property Parameter: TEParameterBase Read FParameter;
   End;

Var
   FormParamEditor: TFormParamEditor;

Implementation

{$R *.dfm}

Uses
   UnitMDIMain;

{ TFormParamEditor }

Procedure TFormParamEditor.btnOKClick(Sender: TObject);
Var
   iParameterType: Integer;
Begin
   cbConnectionsExit(Nil);

   If chkConnectionParam.Checked Then
      iParameterType := cParamTypeConnection
   Else
      iParameterType := cParamTypeAdditional;

   If Not Assigned(FParameter) Then
   Begin
      If Trim(edtParamName.Text) = '' Then
      Begin
         MessageDlg('Name cannot be empty', mtError, [mbOK], 0);
         Abort;
      End;
      FParameter := FormMDIMain.Parameters.AddItem(edtParamName.Text, iParameterType);
   End;
   Parameter.Name := edtParamName.Text;
   Parameter.Parameter := edtParameter.Text;
   If chkConnectionParam.Checked Then
      Parameter.ParamCategory := cbCategory.Text
   Else
      Parameter.ParamCategory := '';

   Case iParameterType Of
      cParamTypeConnection:
         Begin
            With TEConnectionParameter(FParameter) Do
            Begin
              Connection := cbConnections.Text;
              ExcludeAdditionalParams := chkExcludeAdditionalParameters.Checked;
            End;
         End;
      cParamTypeAdditional:
         Begin
            TEAdditionalParameter(FParameter).DefaultInclude := chkDefaultInclude.Checked;
         End;
   End;
   Parameter.SaveData(FormMDIMain.ParentFolder + cParam_INI);
   ModalResult := mrOk;
End;

Procedure TFormParamEditor.cbConnectionsExit(Sender: TObject);
Begin
   If (cbConnections.Text <> '') And ((cbConnections.Items.IndexOf(cbConnections.Text)) = -1) Then
   Begin
      MessageDlg('Invalid connection', mtError, [mbOK], 0);
      Abort;
   End;
End;

procedure TFormParamEditor.cbCategoryKeyPress(Sender: TObject; var Key: Char);
begin
   If Not(key In ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_', ' ', #46, #8]) Then
      Abort;
end;

Procedure TFormParamEditor.chkConnectionParamClick(Sender: TObject);
Begin
   chkDefaultInclude.Enabled := Not chkConnectionParam.Checked;
   chkExcludeAdditionalParameters.Enabled := chkConnectionParam.Checked;
   cbConnections.Enabled := chkConnectionParam.Checked;
   cbCategory.Enabled := chkConnectionParam.Checked;
End;

Constructor TFormParamEditor.Create(aOwner: TComponent; Const aParameter: TEParameterBase);
Begin
   FInitialized := False;
   Inherited Create(aOwner);

   FParameter := aParameter;
   edtParamName.Enabled := Not Assigned(FParameter);
   chkConnectionParam.Enabled := edtParamName.Enabled;
End;

Procedure TFormParamEditor.edtParamNameKeyPress(Sender: TObject; Var Key: Char);
Begin
   If Not(key In ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_', ' ', #46, #8]) Then
      Abort;
End;

Procedure TFormParamEditor.edtParamNameRightButtonClick(Sender: TObject);
Begin
   TButtonedEdit(Sender).Text := '';
End;

Procedure TFormParamEditor.FormActivate(Sender: TObject);
Begin
   If Not FInitialized Then
   Begin
      FInitialized := True;
      If Assigned(FParameter) Then
         LoadData(FParameter);
   End;
End;

procedure TFormParamEditor.FormCreate(Sender: TObject);
begin
   cbCategory.Items := FormMDIMain.ParamCategories;
   // Reload connections. { Ajmal }
   FormMDIMain.Connections.LoadConnections;
   cbConnections.Items.AddStrings(FormMDIMain.Connections.Connections);
end;

Procedure TFormParamEditor.LoadData(const aParameter: TEParameterBase);
var
  varConnParam: TEConnectionParameter Absolute aParameter;
  varAdditionalParam: TEAdditionalParameter Absolute aParameter;
Begin
   chkConnectionParamClick(Nil);

   edtParamName.Text := aParameter.Name;
   edtParameter.Text := aParameter.Parameter;
   chkConnectionParam.Checked := aParameter Is TEConnectionParameter;
   cbCategory.Text := aParameter.ParamCategory;

   If Not chkConnectionParam.Checked Then
   Begin
      chkDefaultInclude.Checked := varAdditionalParam.DefaultInclude;
      chkExcludeAdditionalParameters.Checked := False;
   End
   Else
   Begin
      chkExcludeAdditionalParameters.Checked := varConnParam.ExcludeAdditionalParams;
      cbConnections.ItemIndex := cbConnections.Items.IndexOf(TEConnectionParameter(aParameter).Connection);
   End;
End;

End.
