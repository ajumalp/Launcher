Unit ESoft.Launcher.DM.Main;

{ ----------------- Single Table Database ------------------ }
{ ---------------------------------------------------------- }
{ Developed by Muhammad Ajmal p }
{ ajumalp@gmail.com }
{ ---------------------------------------------------------- }

Interface

Uses
  Vcl.Forms,
  System.SysUtils,
  System.Classes,
  System.Types,
  Data.DbxSqlite,
  Data.DB,
  Vcl.Dialogs,
  Data.SqlExpr,
  Datasnap.Provider,
  Datasnap.DBClient,
  Generics.Collections,
  Variants,
  Data.FMTBcd;

Const
  cDB_FIELD_OID = 'OID';
  cDB_FIELD_PARENTID = 'PARENTID';
  cDB_FIELD_NAME = 'NAME';
  cDB_FIELD_VALUE = 'VALUE';
  cDB_FIELD_STATUS = 'STATUS';

Type
  TdmMain = Class;
  TESTDBChildNodes = Class;

  eSTDBItemStatus = (sdsActive, sdsDeleted, sdsInActive);
  eSTDBItemState = (sdsBrowse, sdsNew, sdsUpdating);

  IESTDBNode = Interface
    Function GetOID: Int64;
    Function GetParentID: Int64;
    Function GetName: String;
    Function GetValue: Variant;
    Procedure SetValue(const aValue: Variant);
    Function GetStatus: eSTDBItemStatus;
    Function GetAsString: String;
    Function GetAsInteger: Integer;
    Function GetAsBoolean: Boolean;
    Function GetChildNode(aNodeName: String): IESTDBNode;
    Function GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode;
    Function GetState: eSTDBItemState;
    Function GetIsLastChild: Boolean;
    Function GetHasChildren: Boolean;

    Function IsRootNode: Boolean;
    Function HasData: Boolean;
    Function MoveToFirstChild: IESTDBNode;
    Function FirstChild: IESTDBNode;
    Function NextChild: IESTDBNode;
    Function ChildExists(Const aNodeName: String): Boolean;
    Procedure DeleteChild(Const aNodeName: String);
    Procedure Clear;
    Procedure Activate;
    Procedure Delete(Const aDeleteType: eSTDBItemStatus = sdsDeleted; Const aDeleteFromDB: Boolean = False);

    Property OID: Int64 Read GetOID;
    Property ParentID: Int64 Read GetParentID;
    Property Name: String Read GetName;
    Property Status: eSTDBItemStatus Read GetStatus;

    Property State: eSTDBItemState Read GetState;
    Property IsLastChild: Boolean Read GetIsLastChild;
    Property HasChildren: Boolean Read GetHasChildren;
    Property ChildNode[aNodeName: String]: IESTDBNode Read GetChildNode; Default;
    Property ChildNode[aNodeName: String; aDefaultValue: Variant]: IESTDBNode Read GetChildNodeEx; Default;

    Property Value: Variant Read GetValue Write SetValue;
    Property AsString: String Read GetAsString;
    Property AsInteger: Integer Read GetAsInteger;
    Property AsBoolean: Boolean Read GetAsBoolean;
  End;

  TESTDBChildNodes = Class(TDictionary<String, IESTDBNode>);

  TESTDBNode = Class(TInterfacedObject, IESTDBNode)
  Strict Private
    FChildNodes: TESTDBChildNodes;
    FDataset: TClientDataSet;
    FIsLoaded: Boolean;
    FOID: Int64;
    FParentID: Int64;
    FName: String;
    FValue: Variant;
    FStatus: eSTDBItemStatus;
    FIsLastChild: Boolean;
    FCurrentChildBookmark: TBookmark;
    FMoveToFirstChild: Boolean;
    FParentNode: IESTDBNode;

    Function GetAsString: String;
    Function GetAsInteger: Integer;
    Function GetAsBoolean: Boolean;
    Procedure LoadData;
    Procedure ValidateLastChild;
    Function GetChildNode(aNodeName: String): IESTDBNode;
    Function GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode;
    Function GetIsLastChild: Boolean;
    Function GetHasChildren: Boolean;
    Function GetState: eSTDBItemState;
    Function Locate(Const aKeys: Array Of String; Const aValues: Array Of Variant): Boolean; Overload;
    Function Locate: Boolean; Overload;
    Procedure Post;
  Strict Protected
    Function GetOID: Int64; Virtual;
    Function GetParentID: Int64; Virtual;
    Function GetName: String; Virtual;
    Function GetValue: Variant; Virtual;
    Procedure SetValue(const aValue: Variant);
    Function GetStatus: eSTDBItemStatus; Virtual;
  Public
    Constructor Create(Const aDataset: TClientDataSet; aParentID: Int64; aNodeName: String);
    Destructor Destroy; override;

    Function IsRootNode: Boolean;
    Function HasData: Boolean;
    Function MoveToFirstChild: IESTDBNode;
    Function FirstChild: IESTDBNode;
    Function NextChild: IESTDBNode;
    Function ChildExists(Const aNodeName: String): Boolean;
    Procedure DeleteChild(Const aNodeName: String);
    Procedure Clear;
    Procedure Activate;
    Procedure Delete(Const aDeleteType: eSTDBItemStatus = sdsDeleted; Const aDeleteFromDB: Boolean = False);

    Property OID: Int64 Read GetOID;
    Property ParentID: Int64 Read GetParentID;
    Property Name: String Read GetName;
    Property Value: Variant Read GetValue Write SetValue;
    Property Status: eSTDBItemStatus Read GetStatus;

    Property State: eSTDBItemState Read GetState;
    Property IsLastChild: Boolean Read GetIsLastChild;
    Property HasChildren: Boolean Read GetHasChildren;
    Property ChildNode[aNodeName: String]: IESTDBNode Read GetChildNode; Default;
    Property ChildNode[aNodeName: String; aDefaultValue: Variant]: IESTDBNode Read GetChildNodeEx; Default;

    Property AsString: String Read GetAsString;
    Property AsInteger: Integer Read GetAsInteger;
    Property AsBoolean: Boolean Read GetAsBoolean;
  End;

  TESTDBRootNode = Class(TESTDBNode)
  Strict Protected
    Function GetOID: Int64; Override;
    Function GetParentID: Int64; Override;
    Function GetName: String; Override;
    Function GetValue: Variant; Override;
    Function GetStatus: eSTDBItemStatus; Override;
    Procedure SetValue(const aValue: Variant);
  Public
    Constructor Create(Const aDataset: TClientDataSet); Reintroduce;
  End;

  IESTDatabase = Interface
    Function GetRootNode: IESTDBNode;
    Function GetChildNode(aNodeName: String): IESTDBNode;
    Function GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode;
    Function GetConnection: TSQLConnection;

    Function SaveToDB: Integer;
    Function NextOID: Int64;
    Function FetchQuery(Const aQuery: String): Variant;
    Function ExecuteQuery(Const aQuery: String): Integer;
    Function NodeExists(Const aParentID: Int64; Const aNodeName: String): Boolean;
    Procedure PurgeDatabase;

    Property Connection: TSQLConnection Read GetConnection;
    Property RootNode: IESTDBNode Read GetRootNode;
    Property ChildNode[aNodeName: String]: IESTDBNode Read GetChildNode; Default;
    Property ChildNode[aNodeName: String; aDefaultValue: Variant]: IESTDBNode Read GetChildNodeEx; Default;
  end;

  TESTDatabase = Class(TInterfacedObject, IESTDatabase)
  Strict Private
    FDataModule: TdmMain;
    FRootNode: IESTDBNode;
    FNextOID: Int64;

    Function GetDataModule: TdmMain;
    Function GetRootNode: IESTDBNode;
    Function GetGeneralDSet: TClientDataSet;
    Function GetChildNode(aNodeName: String): IESTDBNode;
    Function GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode;
    Procedure ExtractDatabaseFile(Const aResName, aFileName: String);
    Function GetConnection: TSQLConnection;
    Procedure ReloadData;
    Procedure ResetObjectIDPK;
    Function NextOID: Int64;

    Property DataModule: TdmMain Read GetDataModule;
    Property GeneralDSet: TClientDataSet Read GetGeneralDSet;
  Public
    Constructor Create;
    Destructor Destroy; override;

    Function SaveToDB: Integer;
    Function FetchQuery(Const aQuery: String): Variant;
    Function ExecuteQuery(Const aQuery: String): Integer;
    Function NodeExists(Const aParentID: Int64; Const aNodeName: String): Boolean;
    Procedure PurgeDatabase;

    Property Connection: TSQLConnection Read GetConnection;
    Property RootNode: IESTDBNode Read GetRootNode;
    Property ChildNode[aNodeName: String]: IESTDBNode Read GetChildNode; Default;
    Property ChildNode[aNodeName: String; aDefaultValue: Variant]: IESTDBNode Read GetChildNodeEx; Default;
  End;

  TdmMain = Class(TDataModule)
    clntDSetSTDBMain: TClientDataSet;
    dsProSTDBMain: TDataSetProvider;
    SQLCnnMain: TSQLConnection;
    qrySTDBMain: TSQLQuery;

    Procedure DataModuleCreate(Sender: TObject);
    procedure clntDSetSTDBMainReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
  Public
    Function BuildConnectionString(Const aDatabase: String): String;
    Property GeneralDSet: TClientDataSet Read clntDSetSTDBMain;
  End;

  Function STDatabase: IESTDatabase;

Implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

Var
  _STDatabase: IESTDatabase = Nil;
Function STDatabase: IESTDatabase;
Begin
  If Not Assigned(_STDatabase) Then
    _STDatabase := TESTDatabase.Create;
  Result := _STDatabase;
End;

Function TdmMain.BuildConnectionString(Const aDatabase: String): String;
Var
  sDatabase: String;
Begin
  If Not FileExists(aDatabase) Then
  Begin
    sDatabase := ExtractFilePath(ParamStr(0)) + aDatabase;
    If Not FileExists(sDatabase) Then
      Raise Exception.Create(Format('Invalid database [%s]', [aDatabase]));
  End;
  Result := 'DRIVER=SQLite3 ODBC Driver;Database=' + aDatabase + ';LongNames=0;Timeout=1000;NoTXN=0;SyncPragma=NORMAL;StepAPI=0;';
End;

Procedure TdmMain.clntDSetSTDBMainReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
Begin
  MessageDlg(E.Message, mtError, [mbOK], 0);
End;

Procedure TdmMain.DataModuleCreate(Sender: TObject);
Begin
  SQLCnnMain.Params.Values['Database'] := ExtractFilePath(ParamStr(0)) + 'launcher.db3';
  Try
    SQLCnnMain.LoginPrompt := False;
    SQLCnnMain.Connected := True;
    SQLCnnMain.Connected := False;
  Except
    On Ex: Exception Do
      MessageDlg(Ex.Message, mtError, [mbOK], 0);
  End;
End;

{ TESTDatabase }

Function TESTDatabase.SaveToDB: Integer;
begin
  Result := GeneralDSet.ApplyUpdates(0);
  ResetObjectIDPK;
  ReloadData;
end;

Function TESTDatabase.GetConnection: TSQLConnection;
Begin
  Result := DataModule.SQLCnnMain;
End;

Procedure TESTDatabase.PurgeDatabase;
Begin
  ExecuteQuery('DELETE FROM STDBMAIN WHERE STATUS = "D"');
End;

Constructor TESTDatabase.Create;
Begin
  FNextOID := -1;
  FDataModule := Nil;
  FRootNode := Nil;
End;

destructor TESTDatabase.Destroy;
begin
  If Assigned(FDataModule) Then
    FreeAndNil(FDataModule);

  Inherited;
end;

Function TESTDatabase.FetchQuery(const aQuery: String): Variant;
Var
  varSQLQuery: TSQLQuery;
Begin
  Result := Null;

  varSQLQuery := TSQLQuery.Create(Nil);
  Try
    varSQLQuery.SQLConnection := DataModule.SQLCnnMain;
    varSQLQuery.SQL.Text := aQuery;
    varSQLQuery.Open;
    If Not varSQLQuery.IsEmpty Then
      Result := varSQLQuery.Fields[0].AsVariant;
  Finally
    varSQLQuery.Free;
  End;
End;

Function TESTDatabase.ExecuteQuery(const aQuery: String): Integer;
Var
  varSQLQuery: TSQLQuery;
Begin
  varSQLQuery := TSQLQuery.Create(Nil);
  Try
    varSQLQuery.SQLConnection := DataModule.SQLCnnMain;
    varSQLQuery.SQL.Text := aQuery;
    Result := varSQLQuery.ExecSQL;
  Finally
    varSQLQuery.Free;
  End;
End;

Procedure TESTDatabase.ExtractDatabaseFile(Const aResName, aFileName: String);
Var
  varResStream: TResourceStream;
Begin
  If FileExists(ExtractFilePath(ParamStr(0)) + aFileName) Then
    Exit;

  varResStream := TResourceStream.Create(HInstance, aResName, RT_RCDATA);
  try
    varResStream.Position := 0;
    varResStream.SaveToFile(ExtractFilePath(ParamStr(0)) + aFileName);
  finally
    varResStream.Free;
  end;
End;

Function TESTDatabase.GetChildNode(aNodeName: String): IESTDBNode;
Begin
  Result := RootNode[aNodeName];
End;

Function TESTDatabase.GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode;
Begin
  Result := RootNode[aNodeName, aDefaultValue];
End;

Function TESTDatabase.GetDataModule: TdmMain;
Begin
  If Not Assigned(FDataModule) Then
  Begin
    ExtractDatabaseFile('sqlite_db', 'launcher.db3');
    ExtractDatabaseFile('sqlite_dll', 'sqlite3.dll');

    FDataModule := TdmMain.Create(Nil);
    ReloadData;
  End;
  Result := FDataModule;
End;

Function TESTDatabase.GetRootNode: IESTDBNode;
Begin
  If Not Assigned(FRootNode) Then
    FRootNode := TESTDBRootNode.Create(GeneralDSet);
  Result := FRootNode;
End;

Function TESTDatabase.NextOID: Int64;
Begin
  If FNextOID = -1 Then
  Begin
    FNextOID := FetchQuery('SELECT MAX(OID) + 1 AS NEXTOID FROM STDBMAIN');
    Exit(FNextOID);
  End;

  Inc(FNextOID);
  Result := FNextOID;
End;

Function TESTDatabase.NodeExists(Const aParentID: Int64; Const aNodeName: String): Boolean;
Var
  sKeys: String;
Begin
  sKeys := Format('%s;%s', [cDB_FIELD_PARENTID, cDB_FIELD_NAME]);
  Result := GeneralDSet.Locate(sKeys, VarArrayOf([aParentID, aNodeName]), [loCaseInsensitive]);
End;

Function TESTDatabase.GetGeneralDSet: TClientDataSet;
Begin
  Result := DataModule.GeneralDSet;
End;

Procedure TESTDatabase.ReloadData;
Begin
  Assert((FNextOID = -1) And (Not GeneralDSet.UpdatesPending), 'Should not reload dataset when updates pending');

  If GeneralDSet.Active Then
    GeneralDSet.Close;
  GeneralDSet.Open;

  // Set nill to free and existing objects { Ajmal }
  FRootNode := Nil;
End;

Procedure TESTDatabase.ResetObjectIDPK;
Const 
  cSQL_RESET_OID = 'UPDATE sqlite_sequence SET SEQ = (SELECT MAX(OID) FROM STDBMAIN) WHERE NAME = "STDBMAIN"';
Begin
  If FNextOID = -1 Then
    Exit;

  DataModule.SQLCnnMain.ExecuteDirect(cSQL_RESET_OID);
  FNextOID := -1;
End;

{ TESTDBNode }

Procedure TESTDBNode.Activate;
Begin
  LoadData;  
  FStatus := sdsActive;
  Post;
End;

Function TESTDBNode.ChildExists(const aNodeName: String): Boolean;
Begin
  Result := Locate([cDB_FIELD_PARENTID, cDB_FIELD_NAME], [OID, aNodeName]);
End;

Procedure TESTDBNode.Clear;
Begin
  Value := Null;
End;

Constructor TESTDBNode.Create(const aDataset: TClientDataSet; aParentID: Int64; aNodeName: String);
Begin
  FOID := 0;
  FValue := Null;
  FIsLoaded := False;
  FParentID := aParentID;
  FName := aNodeName;
  FDataset := aDataset;
  FIsLastChild := False;
  FMoveToFirstChild := False;

  FChildNodes := TESTDBChildNodes.Create;
End;

Procedure TESTDBNode.Delete(Const aDeleteType: eSTDBItemStatus = sdsDeleted; Const aDeleteFromDB: Boolean = False);

  Function _DeleteQuery(Const aDeleteFrom: String = 'PARENTID'): String;
  Begin
    If aDeleteFromDB Then 
      Exit('DELETE FROM STDBMAIN WHERE ' + aDeleteFrom + ' = ');

    Case aDeleteType Of
      sdsDeleted: Result := 'UPDATE STDBMAIN SET STATUS = "D" WHERE ' + aDeleteFrom + ' = ';
      sdsInActive: Result := 'UPDATE STDBMAIN SET STATUS = "I" WHERE ' + aDeleteFrom + ' = ';
    End;
  End;

  Procedure _DeleteChildNodes(Const aOID: Int64);
  Var
    lOID: Int64;
    varOIDList: TList<Int64>;
    varSQLQuery: TSQLQuery;
  Begin
    varOIDList := TList<Int64>.Create;
    varSQLQuery := TSQLQuery.Create(Nil);
    Try
      With varSQLQuery Do
      Begin
        varSQLQuery.SQLConnection := STDatabase.Connection;
        SQL.Text := 'SELECT OID FROM STDBMAIN WHERE PARENTID = ' + aOID.ToString;
        Open;
        While Not Eof Do
        Begin
          varOIDList.Add(FieldByName('OID').AsInteger);
          Next;
        End;
        Close;
      End;

      For lOID in varOIDList Do
        _DeleteChildNodes(lOID);
    Finally
      varSQLQuery.Free;
      varOIDList.Free;
    End;

    STDatabase.ExecuteQuery(_DeleteQuery + aOID.ToString);
  End;

Begin
  Assert(Not FDataset.UpdatesPending, 'Should not delete when updates are pending');

  _DeleteChildNodes(OID);
  STDatabase.ExecuteQuery(_DeleteQuery('OID') + OID.ToString);
End;

Procedure TESTDBNode.DeleteChild(const aNodeName: String);
Begin
  If ChildExists(aNodeName) Then
    ChildNode[aNodeName].Delete;
End;

Destructor TESTDBNode.Destroy;
Begin
  FreeAndNil(FChildNodes);

  Inherited;
End;

Function TESTDBNode.FirstChild: IESTDBNode;
Var
  sChildNodeName: String;
Begin
  Result := Nil;
  LoadData;

  If Locate([cDB_FIELD_PARENTID], [FOID]) Then
  Begin
    FCurrentChildBookmark := FDataset.Bookmark;
    ValidateLastChild;
    sChildNodeName := FDataset.FieldByName(cDB_FIELD_NAME).AsString;
    Result := ChildNode[sChildNodeName];
    FMoveToFirstChild := False;
  End;
End;

Function TESTDBNode.GetAsBoolean: Boolean;
Begin
  Result := AsString.ToBoolean;
End;

Function TESTDBNode.GetAsInteger: Integer;
Begin
  Result := AsString.ToInteger;
End;

Function TESTDBNode.GetAsString: String;
Begin
  Result := VarToStr(Value);
End;

Function TESTDBNode.GetChildNode(aNodeName: String): IESTDBNode;
Begin
  Result := GetChildNodeEx(aNodeName, Null);
End;

Function TESTDBNode.GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode;
Begin
  If Not FChildNodes.ContainsKey(aNodeName) Then
    FChildNodes.Add(aNodeName, TESTDBNode.Create(FDataset, OID, aNodeName));
  Result := FChildNodes.Items[aNodeName];

  If Not Locate([cDB_FIELD_PARENTID, cDB_FIELD_NAME], [OID, aNodeName]) Then
  Begin
    FDataset.Append;
    FDataset.FieldByName(cDB_FIELD_OID).ReadOnly := False;
    FDataset.FieldByName(cDB_FIELD_OID).Value := STDatabase.NextOID;
    FDataset.FieldByName(cDB_FIELD_PARENTID).AsInteger := OID;
    FDataset.FieldByName(cDB_FIELD_NAME).AsString := aNodeName;
    FDataset.FieldByName(cDB_FIELD_VALUE).Value := aDefaultValue;
    FDataset.FieldByName(cDB_FIELD_STATUS).AsString := 'A';
    FDataset.Post;

    Result.Value := aDefaultValue;
  End;
End;

Function TESTDBNode.GetHasChildren: Boolean;
Begin
  Result := Locate([cDB_FIELD_PARENTID], [OID]);
End;

Function TESTDBNode.GetIsLastChild: Boolean;
Begin
  Result := FIsLastChild Or Not HasChildren;
End;

Function TESTDBNode.GetName: String;
Begin
  LoadData;
  Result := FName
End;

Function TESTDBNode.GetOID: Int64;
Begin
  LoadData;
  Result := FOID;
End;

Function TESTDBNode.GetParentID: Int64;
Begin
  LoadData;
  Result := FParentID;
End;

Function TESTDBNode.GetState: eSTDBItemState;
Begin
  Result := sdsNew;
  If Locate([cDB_FIELD_PARENTID, cDB_FIELD_NAME], [ParentID, Name]) Then
  Begin
    Case FDataset.UpdateStatus Of
      usInserted: Result := sdsNew;
      usModified: Result := sdsUpdating;
      usUnmodified: Result := sdsBrowse;
    End;
  End;
End;

Function TESTDBNode.GetStatus: eSTDBItemStatus;
Begin
  LoadData;
  Result := FStatus;
End;

Function TESTDBNode.GetValue: Variant;
Begin
  LoadData;
  Result := FValue;
End;

Function TESTDBNode.HasData: Boolean;
Begin
  Result := Not VarIsNull(Value);
End;

Procedure TESTDBNode.ValidateLastChild;
Begin
  FIsLastChild := FDataset.Eof;
  If Not FIsLastChild Then
  Begin
    FDataset.Next;
    Try
      FIsLastChild := FDataset.FieldByName(cDB_FIELD_PARENTID).AsInteger <> OID;
    Finally
      FDataset.Prior;
    End;
  End;
End;

Function TESTDBNode.IsRootNode: Boolean;
Begin
  Result := ParentID = 0;
End;

Procedure TESTDBNode.LoadData;
Var
  sStatus: String;
Begin
  If FIsLoaded Then
    Exit;

  If Not Locate Then
    Raise Exception.Create('Invalid Node Access');
   
  FOID := FDataset.FieldByName(cDB_FIELD_OID).AsInteger;
  FValue := FDataset.FieldByName(cDB_FIELD_VALUE).AsVariant;
      
  sStatus := FDataset.FieldByName(cDB_FIELD_STATUS).AsString.Trim;
  If sStatus.Equals('A') Then FStatus := sdsActive
  Else If sStatus.Equals('D') Then FStatus := sdsDeleted
  Else If sStatus.Equals('I') Then FStatus := sdsInActive;

  FIsLoaded := True;
End;

Function TESTDBNode.Locate: Boolean;
Var
  vParentID: Variant;
Begin
  vParentID := FParentID;
  If FParentID = 0 Then
    vParentID := Null;
  Result := Locate([cDB_FIELD_PARENTID, cDB_FIELD_NAME], [vParentID, FName]);
End;

Function TESTDBNode.MoveToFirstChild: IESTDBNode;
Begin
  // We should call FirstChild to validate IsLastChild
  Result := FirstChild;
  // Set FMoveToFirstChild after calling FirstChild
  // Because FirstChild will reset FMoveToFirstChild
  FMoveToFirstChild := True;
End;

Function TESTDBNode.Locate(const aKeys: Array Of String; const aValues: array of Variant): Boolean;
Var
  iCntr: Integer;
  sKeys: String;
Begin
  sKeys := EmptyStr;
  For iCntr := Low(aKeys) To High(aKeys) Do
  Begin
    If Not sKeys.IsEmpty Then
      sKeys := sKeys + ';';
    sKeys := sKeys + aKeys[iCntr];
  End;
  Result := FDataset.Locate(sKeys, VarArrayOf(aValues), [loCaseInsensitive]);
End;

Function TESTDBNode.NextChild: IESTDBNode;
Var
  sChildNodeName: String;
Begin
  If FMoveToFirstChild Then
    Exit(FirstChild);

  If IsLastChild Then
    Exit(Nil);

  Assert(FDataset.BookmarkValid(FCurrentChildBookmark), 'Invalid bookmark');
  FDataset.Bookmark := FCurrentChildBookmark;
  FDataset.Next;
  FCurrentChildBookmark := FDataset.GetBookmark;
  ValidateLastChild;
  sChildNodeName := FDataset.FieldByName(cDB_FIELD_NAME).AsString;
  Result := ChildNode[sChildNodeName];
End;

Procedure TESTDBNode.Post;
Begin
  If Locate Then FDataset.Edit
  Else FDataset.Append;

  FDataset.FieldByName(cDB_FIELD_VALUE).Value := FValue;
  // When a value is set, the re activate the node { Ajmal }
  FDataset.FieldByName(cDB_FIELD_STATUS).Value := 'A';
  FDataset.Post;
End;

Procedure TESTDBNode.SetValue(const aValue: Variant);
Begin
  LoadData;
  FValue := aValue;
  Post;
End;

{ TESTDBRootNode }

Constructor TESTDBRootNode.Create(const aDataset: TClientDataSet);
Begin
  Inherited Create(aDataset, 0, 'root');
End;

Function TESTDBRootNode.GetName: String;
Begin
  Result := 'root';
End;

Function TESTDBRootNode.GetOID: Int64;
Begin
  Result := 1;
End;

Function TESTDBRootNode.GetParentID: Int64;
Begin
  Result := 0;
End;

Function TESTDBRootNode.GetStatus: eSTDBItemStatus;
begin
  Result := sdsActive;
End;

Function TESTDBRootNode.GetValue: Variant;
Begin
  Result := Null;
End;

Procedure TESTDBRootNode.SetValue(const aValue: Variant);
Begin
  // We should not change the value of root node { Ajmal }
End;

End.
