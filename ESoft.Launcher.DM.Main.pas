Unit ESoft.Launcher.DM.Main;

{ ---------------------------------------------------------- }
{ Developed by Muhammad Ajmal p }
{ ajumalp@gmail.com }
{ ---------------------------------------------------------- }

Interface

Uses
   Vcl.Forms,
   System.SysUtils,
   System.Classes,
   Data.DbxSqlite,
   Data.DB,
   Vcl.Dialogs,
   Data.SqlExpr, 
   Datasnap.Provider, 
   Datasnap.DBClient,
   Generics.Collections,
   Variants,
   VarUtils,   
   Data.Win.ADODB;

   Const
      cDB_FIELD_OID = 'OID';
      cDB_FIELD_PARENTID = 'PARENTID';
      cDB_FIELD_NAME = 'NAME';
      cDB_FIELD_VALUE = 'VALUE';
      cDB_FIELD_STATUS = 'STATUS';
      cDB_FIELD_ISUNIQUE = 'ISUNIQUE';

Type
   TdmMain = Class;
   TESTDBChildNodes = Class;

   eSTDBItemStatus = (sdsActive, sdsDeleted, sdsInActive);
   eSTDBItemState = (sdsNew, sdsUpdating);

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
      Function GetIsLastChild: Boolean;
      
      Function IsRootNode: Boolean;
      Function HasData: Boolean;
      Function FirstChild: IESTDBNode;
      Function NextChild: IESTDBNode;
      Procedure Post;
      Procedure Clear;

      Property OID: Int64 Read GetOID;
      Property ParentID: Int64 Read GetParentID;
      Property Name: String Read GetName;
      Property Status: eSTDBItemStatus Read GetStatus;

      Property IsLastChild: Boolean Read GetIsLastChild;
      Property ChildNode[aNodeName: String]: IESTDBNode Read GetChildNode; Default;
      Property ChildNodeEx[aNodeName: String; aDefaultValue: Variant]: IESTDBNode Read GetChildNodeEx;

      Property Value: Variant Read GetValue Write SetValue;
      Property AsString: String Read GetAsString;
      Property AsInteger: Integer Read GetAsInteger;
      Property AsBoolean: Boolean Read GetAsBoolean;
   End;

   TESTDBChildNodes = Class(TDictionary<String, IESTDBNode>)
   End;

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
   
      Function GetAsString: String;
      Function GetAsInteger: Integer;
      Function GetAsBoolean: Boolean;
      Procedure LoadData;
      Procedure ValidateLastChild;
      Function GetChildNode(aNodeName: String): IESTDBNode;
      Function GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode; 
      Function GetIsLastChild: Boolean;
      Function GetState: eSTDBItemState; 
      Function Locate(Const aKeys: Array Of String; Const aValues: Array Of Variant): Boolean; Overload;
      Function Locate: Boolean; Overload;
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
      Function FirstChild: IESTDBNode;
      Function NextChild: IESTDBNode;      
      Procedure Post;
      Procedure Clear;

      Property OID: Int64 Read GetOID;
      Property ParentID: Int64 Read GetParentID;
      Property Name: String Read GetName;
      Property Value: Variant Read GetValue Write SetValue;
      Property Status: eSTDBItemStatus Read GetStatus;

      Property State: eSTDBItemState Read GetState;
      Property IsLastChild: Boolean Read GetIsLastChild;
      Property ChildNode[aNodeName: String]: IESTDBNode Read GetChildNode; Default;
      Property ChildNodeEx[aNodeName: String; aDefaultValue: Variant]: IESTDBNode Read GetChildNodeEx;
      
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
   Public
      Constructor Create(Const aDataset: TClientDataSet); Reintroduce;
   End;

   TESTDatabase = Class
   Strict Private
      FDataModule: TdmMain;    
      FRootNode: IESTDBNode;      
      
      Function GetDataModule: TdmMain;
      Function GetRootNode: IESTDBNode;
      Function GetGeneralDSet: TClientDataSet;
      Function GetChildNode(aNodeName: String): IESTDBNode;
      Function GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode;
      
      Property DataModule: TdmMain Read GetDataModule;
      Property GeneralDSet: TClientDataSet Read GetGeneralDSet;
   Public      
      Constructor Create;
      Destructor Destroy; override;

      Procedure ReloadData;
      Function ApplyUpdates: Integer;

      Property RootNode: IESTDBNode Read GetRootNode; 
      Property ChildNode[aNodeName: String]: IESTDBNode Read GetChildNode; Default;
      Property ChildNodeEx[aNodeName: String; aDefaultValue: Variant]: IESTDBNode Read GetChildNodeEx; 
   End;

   TdmMain = Class(TDataModule)
      clntDSetRTDBMain: TClientDataSet;
      dsProRTDBMain: TDataSetProvider;
      SQLCnnMain: TADOConnection;
      qryRTDBMain: TADOQuery;

      Procedure DataModuleCreate(Sender: TObject);
   Public
      Function BuildConnectionString(Const aDatabase: String): String;
      Property GeneralDSet: TClientDataSet Read clntDSetRTDBMain;
   End;

   Function STDatabase: TESTDatabase;

Implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

Var
   _STDatabase: TESTDatabase = Nil;
Function STDatabase: TESTDatabase;
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

Procedure TdmMain.DataModuleCreate(Sender: TObject);
Begin
   SQLCnnMain.ConnectionString := BuildConnectionString('launcher.db3');
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

Function TESTDatabase.ApplyUpdates: Integer;
begin
   Result := GeneralDSet.ApplyUpdates(0);
end;

Constructor TESTDatabase.Create;
Begin
   FDataModule := Nil;
   FRootNode := TESTDBRootNode.Create(GeneralDSet);
End;

destructor TESTDatabase.Destroy;
begin
   If Assigned(FDataModule) Then
      FreeAndNil(FDataModule);

   Inherited;
end;

Function TESTDatabase.GetChildNode(aNodeName: String): IESTDBNode;
Begin
   Result := RootNode.ChildNode[aNodeName];
End;

Function TESTDatabase.GetChildNodeEx(aNodeName: String; aDefaultValue: Variant): IESTDBNode;
Begin
   Result := RootNode.ChildNodeEx[aNodeName, aDefaultValue];   
End;

Function TESTDatabase.GetDataModule: TdmMain;
Begin
   If Not Assigned(FDataModule) Then
   Begin
      FDataModule := TdmMain.Create(Nil);
      ReloadData;
   End;
   Result := FDataModule;
End;

Function TESTDatabase.GetRootNode: IESTDBNode;
Begin
   Result := FRootNode;
End;

Function TESTDatabase.GetGeneralDSet: TClientDataSet;
Begin
   Result := DataModule.GeneralDSet;
End;

Procedure TESTDatabase.ReloadData;
Begin
   If GeneralDSet.Active Then 
      GeneralDSet.Close;
   GeneralDSet.Open;
End;

{ TESTDBNode }

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

   FChildNodes := TESTDBChildNodes.Create;
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
      FDataset.FieldByName(cDB_FIELD_PARENTID).AsLargeInt := OID;
      FDataset.FieldByName(cDB_FIELD_NAME).AsString := aNodeName;      
      FDataset.FieldByName(cDB_FIELD_VALUE).Value := aDefaultValue;
      FDataset.Post;
      
      Result.Value := aDefaultValue;
      Result.Post;
   End;
End;

Function TESTDBNode.GetIsLastChild: Boolean;
Begin
   Result := FIsLastChild;    
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
      Result := sdsUpdating;
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
        FIsLastChild := FDataset.FieldByName(cDB_FIELD_PARENTID).AsLargeInt <> OID;
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
   
   FOID := FDataset.FieldByName(cDB_FIELD_OID).AsLargeInt;
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
   If IsLastChild Then 
      Raise Exception.Create('List Index Out Of Bounds');

   FDataset.BookmarkValid(FCurrentChildBookmark);
   FDataset.Next;
   FCurrentChildBookmark := FDataset.Bookmark;
   ValidateLastChild;   
   sChildNodeName := FDataset.FieldByName(cDB_FIELD_NAME).AsString;
   Result := ChildNode[sChildNodeName];
End;

Procedure TESTDBNode.Post;
Begin
  If Locate Then FDataset.Edit
  Else FDataset.Append;

  FDataset.FieldByName(cDB_FIELD_VALUE).Value := Value;
  FDataset.Post;
End;

Procedure TESTDBNode.SetValue(const aValue: Variant);
Begin
   LoadData;
   FValue := aValue;   
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

Initialization 

Finalization
  If Assigned(_STDatabase) Then
     FreeAndNil(_STDatabase);

End.
