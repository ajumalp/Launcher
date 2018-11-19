Unit ESoft.Launcher.UI.ClipboardBrowser;

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
   Vcl.DBCtrls,
   Vcl.Grids,
   Vcl.DBGrids,
   Data.DB,
   Datasnap.DBClient,
   ESoft.Utils,
   ESoft.Launcher.Clipboard,
   Vcl.Menus, 
   Vcl.ImgList, 
   Vcl.ActnList, 
   Vcl.StdActns, 
   Vcl.ComCtrls;

Type
   TFormClipboardBrowser = Class(TForm)
      PanelSearch: TPanel;
      Label1: TLabel;
      edtFilter: TButtonedEdit;
      dbGridClpBrdItems: TDBGrid;
      ClntDSetClipBboardItems: TClientDataSet;
      ClntDSetClipBboardItemsName: TStringField;
      ClntDSetClipBboardItemsData: TStringField;
      SourceClipboardItems: TDataSource;
      chkSearchInData: TCheckBox;
      MainMenu: TMainMenu;
      MenuFile: TMenuItem;
      MItemClose: TMenuItem;
      MenuSearch: TMenuItem;
      MItemSearch: TMenuItem;
      PMItemSearchInData: TMenuItem;
      PopupMenu: TPopupMenu;
      PMItemDelete: TMenuItem;
      Panel1: TPanel;
      btnCancel: TButton;
      btnSave: TButton;
      PMItemRename: TMenuItem;
      N1: TMenuItem;
      MItemDelete: TMenuItem;
      MItemRename: TMenuItem;
      MItemSave: TMenuItem;
      MItemEdit: TMenuItem;
      MItemCopy: TMenuItem;
      MItemCut: TMenuItem;
      aclNotes: TActionList;
      imlNotes: TImageList;
      actEditCut: TEditCut;
      actEditCopy: TEditCopy;
      actEditPaste: TEditPaste;
      actEditSelectAll: TEditSelectAll;
      actEditUndo: TEditUndo;
      actEditDelete: TEditDelete;
      Paste1: TMenuItem;
      SelectAll1: TMenuItem;
      N2: TMenuItem;
      DBRichEditData: TDBRichEdit;
      Procedure edtFilterChange(Sender: TObject);
      Procedure edtFilterKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
      Procedure MItemCloseClick(Sender: TObject);
      Procedure MItemSearchClick(Sender: TObject);
      Procedure PMItemSearchInDataClick(Sender: TObject);
      Procedure chkSearchInDataClick(Sender: TObject);
      Procedure FormCreate(Sender: TObject);
      Procedure PMItemDeleteClick(Sender: TObject);
      Procedure btnSaveClick(Sender: TObject);
      Procedure btnCancelClick(Sender: TObject);
      Procedure PMItemRenameClick(Sender: TObject);
      Procedure PopupMenuPopup(Sender: TObject);
    procedure actEditCutExecute(Sender: TObject);
    procedure actEditCopyExecute(Sender: TObject);
    procedure actEditPasteExecute(Sender: TObject);
    procedure actEditSelectAllExecute(Sender: TObject);
    procedure actEditUndoExecute(Sender: TObject);
    procedure DBRichEditDataExit(Sender: TObject);
   Strict Private
      { Private declarations }
      Function ClipboardItems: TEClipboardItems;
      function SelectedClpBrdItem: TEClipboardItem;
   Protected
      Procedure CreateParams(Var Params: TCreateParams); Override;
   Public
      { Public declarations }
      Procedure Load;
   End;

Var
   FormClipboardBrowser: TFormClipboardBrowser;

Implementation

{$R *.dfm}

Uses
   UnitMDIMain;
{ TFormClipboardBrowser }

procedure TFormClipboardBrowser.actEditCopyExecute(Sender: TObject);
begin
   DBRichEditData.CopyToClipboard;
end;

procedure TFormClipboardBrowser.actEditCutExecute(Sender: TObject);
begin
   DBRichEditData.CutToClipboard;
end;

procedure TFormClipboardBrowser.actEditPasteExecute(Sender: TObject);
begin
   DBRichEditData.PasteFromClipboard;
end;

procedure TFormClipboardBrowser.actEditSelectAllExecute(Sender: TObject);
begin
   DBRichEditData.SelectAll;
end;

procedure TFormClipboardBrowser.actEditUndoExecute(Sender: TObject);
begin
   DBRichEditData.Undo;
end;

Procedure TFormClipboardBrowser.btnCancelClick(Sender: TObject);
Begin
   // If it's canceled, reload the items { Ajmal }
   ClipboardItems.Load;
End;

Procedure TFormClipboardBrowser.btnSaveClick(Sender: TObject);
Begin
   ClipboardItems.Save;
End;

Procedure TFormClipboardBrowser.chkSearchInDataClick(Sender: TObject);
Begin
   PMItemSearchInData.Checked := chkSearchInData.Checked;
   edtFilterChange(edtFilter);
End;

Function TFormClipboardBrowser.SelectedClpBrdItem: TEClipboardItem;
Begin
   Result := ClipboardItems.ItemByName[ClntDSetClipBboardItemsName.AsString];
End;

Function TFormClipboardBrowser.ClipboardItems: TEClipboardItems;
Begin
   Result := FormMDIMain.ClipboardItems;
End;

Procedure TFormClipboardBrowser.CreateParams(Var Params: TCreateParams);
Begin
   Inherited;

   If Owner = Application Then
      Params.ExStyle := Params.ExStyle Or WS_EX_APPWINDOW;
End;

procedure TFormClipboardBrowser.DBRichEditDataExit(Sender: TObject);
begin
   SelectedClpBrdItem.Data := DBRichEditData.Text;
end;

Procedure TFormClipboardBrowser.edtFilterChange(Sender: TObject);
Var
   iCnt: Integer;
   TempSearchArray: Array [0 .. 1] Of WideString;
Const
   TempFieldArray: Array [0 .. 1] Of WideString = ('ClpBrdName', 'ClpBrdData');
Begin
   For iCnt := 0 To Pred(Length(TempSearchArray)) Do
   Begin
      With TButtonedEdit(Sender) Do
         TempSearchArray[iCnt] := IfThen(Trim(Text) = '', '', 'UPPER(' + TempFieldArray[iCnt] + ') LIKE ' + QuotedStr('%' + UpperCase(Text) + '%'));
   End;
   With ClntDSetClipBboardItems Do
   Begin
      Filtered := False;
      Filter := '';
      For iCnt := 0 To Pred(Length(TempSearchArray)) Do
      Begin
         If (TempFieldArray[iCnt] = 'ClpBrdData') And Not chkSearchInData.Checked Then
            Continue;

         Filter := IfThen((Trim(Filter) <> '') And (Not StrEndsWith(Filter, 'Or ')), Filter + ' Or ', Filter);
         Filter := Filter + TempSearchArray[iCnt];
      End;
      If StrEndsWith(Filter, 'Or ') Then
         Filter := StrSubString(3, Filter);
      Filtered := True;
   End;
End;

Procedure TFormClipboardBrowser.edtFilterKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
   Case Key Of
      VK_UP:
         ClntDSetClipBboardItems.Prior;
      VK_DOWN:
         ClntDSetClipBboardItems.Next;
   End;
End;

Procedure TFormClipboardBrowser.FormCreate(Sender: TObject);
Begin
   dbGridClpBrdItems.Columns[0].Title.Font.Color := clBlue;
End;

Procedure TFormClipboardBrowser.Load;
Var
   iCntr: Integer;
Begin
   ClntDSetClipBboardItems.Close;
   ClntDSetClipBboardItems.CreateDataSet;
   For iCntr := 0 To Pred(ClipboardItems.Count) Do
   Begin
      ClntDSetClipBboardItems.Insert;
      ClntDSetClipBboardItemsName.AsString := ClipboardItems[iCntr].Name;
      ClntDSetClipBboardItemsData.AsString := ClipboardItems[iCntr].Data;
      If ClntDSetClipBboardItems.State In [dsInsert, dsEdit] Then
         ClntDSetClipBboardItems.Post;
   End;
End;

Procedure TFormClipboardBrowser.MItemCloseClick(Sender: TObject);
Begin
   btnCancel.Click;
End;

Procedure TFormClipboardBrowser.MItemSearchClick(Sender: TObject);
Begin
   edtFilter.SetFocus;
   edtFilter.SelectAll;
End;

Procedure TFormClipboardBrowser.PMItemDeleteClick(Sender: TObject);
Begin
   If (MessageDlg('Are you sure you want to delete this item ?', mtWarning, [mbYes, mbNo], 0, mbNo) = mrNo) Then
      Exit;

   ClipboardItems.DeleteByItemName(ClntDSetClipBboardItemsName.AsString);
   Load;
End;

Procedure TFormClipboardBrowser.PMItemRenameClick(Sender: TObject);
Var
   sClpBrdName: String;
Begin
   sClpBrdName := ClntDSetClipBboardItemsName.AsString;
   if not InputQuery('Copy clipboard', 'Name', sClpBrdName) then
      Exit;

   If ClipboardItems.Contains(sClpBrdName) Then
   Begin
      MessageDlg('An item with same name already exist.', mtError, [mbOK], 0);
      Exit;
   End;
   SelectedClpBrdItem.Rename(sClpBrdName);
   Load;
End;

Procedure TFormClipboardBrowser.PMItemSearchInDataClick(Sender: TObject);
Begin
   chkSearchInData.Checked := Not chkSearchInData.Checked;
End;

Procedure TFormClipboardBrowser.PopupMenuPopup(Sender: TObject);
Begin
   PMItemDelete.Enabled := Not ClntDSetClipBboardItems.IsEmpty;
   PMItemRename.Enabled := PMItemDelete.Enabled;
End;

End.
