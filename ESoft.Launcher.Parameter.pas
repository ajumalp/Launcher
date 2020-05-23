Unit ESoft.Launcher.Parameter;

{----------------------------------------------------------}
{Developed by Muhammad Ajmal p}
{ajumalp@gmail.com}
{----------------------------------------------------------}

Interface

Uses
  System.Classes,
  Vcl.Dialogs,
  IniFiles,
  Generics.Collections,
  System.SysUtils,
  ESoft.Launcher.DM.Main;

Const
  cParamTypeInvalid = -1;
  cParamTypeConnection = 0;
  cParamTypeAdditional = 1;

Type
  TEConnections = Class(TPersistent)
  Private
    // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
  Strict Private
    // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
    FItems: TStringList;
    FFileName: String;
    Function GetFileName: String;
    Procedure SetFileName(Const Value: String);
    Function GetItems(aIndex: Integer): String;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure LoadConnections;

    // This is the default property of this call. We can access with Self[iCntr] { Ajmal }
    Property Items[aIndex: Integer]: String Read GetItems; Default;
    Property Connections: TStringList Read FItems;
  Published
    Property FileName: String Read GetFileName Write SetFileName;
  End;

Type
  TEParameterBase = Class(TPersistent)
    // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
  Strict Private
    // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
    FParamType: Integer;
    FParameter: String;
    FName: String;
    FCategory: String;
    FSTDBNode: IESTDBNode;

    Function GetSTDBNode: IESTDBNode;
  Public
    Constructor Create; Virtual;

    Procedure LoadData; Overload; Virtual;
    Procedure LoadData(Const aFilename: String); Overload; Virtual; Deprecated;
    Procedure SaveData; Virtual;
  Published
    Property Name: String Read FName Write FName;
    Property Parameter: String Read FParameter Write FParameter;
    Property ParamType: Integer Read FParamType Write FParamType;
    Property ParamCategory: String Read FCategory Write FCategory;
    Property STDBNode: IESTDBNode Read GetSTDBNode;
  End;

  TEParameters = Class(TObjectDictionary<String, TEParameterBase>)
  Strict Private
    FIsLoaded: Boolean;
    FSTDBParams: IESTDBNode;

    Function GetSTDBParams: IESTDBNode;
  Public
    Constructor Create;

    Procedure DeleteItemByName(Const aParmName: String);
    Procedure LoadData(Const aFileName: String);
    Procedure SaveData;
    Function AddItem(
      Const aName: String;
      Const aType: SmallInt = cParamTypeConnection): TEParameterBase;

    Property STDBParams: IESTDBNode Read GetSTDBParams;
  End;

  TEAdditionalParameter = Class(TEParameterBase)
  Private
    // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
  Strict Private
    // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
    FDefaultInclude: Boolean;
  Public
    Constructor Create; Override;

    Procedure LoadData; Override;
    Procedure LoadData(Const aFilename: String); Override; Deprecated;
    Procedure SaveData; Override;
  Published
    Property DefaultInclude: Boolean Read FDefaultInclude Write FDefaultInclude;
  End;

  TEConnectionParameter = Class(TEParameterBase)
  Private
    // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
  Strict Private
    // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
    FConnection: String;
    FExcludeAdditionalParams: Boolean;
  Public
    Constructor Create; Override;

    Procedure LoadData; Override;
    Procedure LoadData(Const aFilename: String); Override; Deprecated;
    Procedure SaveData; Override;
  Published
    Property Connection: String Read FConnection Write FConnection;
    Property ExcludeAdditionalParams: Boolean Read FExcludeAdditionalParams Write FExcludeAdditionalParams;
  End;

Implementation

Uses
  UnitMDIMain;

Const
  cParamType = 'Param_Type';
  cParamText = 'Param_Text';
  cParamTextStrm = 'Param_Text_Strm';
  cParamConnection = 'Param_Connection';
  cParamDefaultInclude = 'Param_Default_Include';
  cParamCategory = 'Param_Category';
  cParamExcludeAdditional = 'Param_Exclude_Additional';

  {TEParameterBase}

Constructor TEParameterBase.Create;
Begin
  // Virtual method, do nothing here. { Ajmal }
  FParameter := '';
  FSTDBNode := Nil;
End;

Function TEParameterBase.GetSTDBNode: IESTDBNode;
Begin
   If Not Assigned(FSTDBNode) Then
      FSTDBNode := STDatabase[cSTDBNodeParams, False].ChildNode[Name];
   Result := FSTDBNode;
End;

Procedure TEParameterBase.LoadData;
Begin
  Parameter := STDBNode[cParamTextStrm, EmptyStr].AsString;
  ParamType := STDBNode[cParamType, cParamTypeInvalid].AsInteger;
  ParamCategory := STDBNode[cParamCategory, EmptyStr].AsString;
End;

Procedure TEParameterBase.LoadData(Const aFilename: String);
Var
  varIniFile: TIniFile;
  varStrm: TStringStream;
Begin
  varIniFile := TIniFile.Create(aFilename);
  varStrm := TStringStream.Create;
  Try
    If varIniFile.ValueExists(Name, cParamTextStrm) And (varIniFile.ReadBinaryStream(Name, cParamTextStrm, varStrm) <> 0) Then
       Parameter := varStrm.DataString
    Else // To be removed soon. { Ajmal }
       Parameter := varIniFile.ReadString(Name, cParamText, '');

    ParamType := varIniFile.ReadInteger(Name, cParamType, cParamTypeInvalid);
    ParamCategory := varIniFile.ReadString(Name, cParamCategory, '');
  Finally
    varStrm.Free;
    varIniFile.Free;
  End;
End;

Procedure TEParameterBase.SaveData;
Var
  iParamType: Integer;
Begin
  If Self Is TEConnectionParameter Then
    iParamType := cParamTypeConnection
  Else If Self Is TEAdditionalParameter Then
    iParamType := cParamTypeAdditional
  Else
    iParamType := cParamTypeInvalid;

  STDBNode.Activate;
  STDBNode[cParamTextStrm].Value := Parameter;
  STDBNode[cParamType].Value := iParamType;
  STDBNode[cParamCategory].Value := ParamCategory;
End;

{TEAdditionalParameter}

Constructor TEAdditionalParameter.Create;
Begin
  Inherited;

  ParamType := cParamTypeAdditional;
End;

Procedure TEAdditionalParameter.LoadData(Const aFilename: String);
Var
  varIniFile: TIniFile;
Begin
  Inherited;

  varIniFile := TIniFile.Create(aFilename);
  Try
    DefaultInclude := varIniFile.ReadBool(Name, cParamDefaultInclude, False);
  Finally
    varIniFile.Free;
  End;
End;

Procedure TEAdditionalParameter.LoadData;
Begin
  Inherited;

  DefaultInclude := STDBNode[cParamDefaultInclude, False].AsBoolean;
End;

Procedure TEAdditionalParameter.SaveData;
Begin
  Inherited;

  STDBNode[cParamDefaultInclude].Value := DefaultInclude;
End;

{TEConnections}

Constructor TEConnections.Create;
Begin
  Inherited;

  FItems := TStringList.Create;
  FItems.Duplicates := dupIgnore;
  FItems.Sorted := True;
End;

Destructor TEConnections.Destroy;
Begin
  FItems.Free;

  Inherited;
End;

Function TEConnections.GetFileName: String;
Begin
  If Trim(FFileName) = '' Then
    Result := cV6_FOLDER + cConnection_INI
  Else
    Result := FFileName;
End;

Procedure TEConnections.SetFileName(Const Value: String);
Begin
  If FFileName <> Value Then
  Begin
    FFileName := Value;
    LoadConnections;
  End;
End;

Function TEConnections.GetItems(aIndex: Integer): String;
Begin
  Result := FItems[aIndex];
End;

Procedure TEConnections.LoadConnections;
Var
  varIniFile: TIniFile;
  varList: TStringList;
  iCntr: Integer;
Begin
  FItems.Clear;
  varIniFile := TIniFile.Create(FileName); // Don't use local variable [FFileName] directly. Always use property. { Ajmal }
  varList := TStringList.Create;
  Try
    varList.Duplicates := dupIgnore;
    varList.Sorted := True;
    varIniFile.ReadSections(varList);
    For iCntr := 0 To Pred(varList.Count) Do
    Begin
      // Check if this is connected. { Ajmal }
      If varIniFile.ReadInteger(varList[iCntr], cConnectionState, 0) = 2 Then
        FItems.Add(varList[iCntr])
    End;
  Finally
    varList.Free;
    varIniFile.Free;
  End;
End;

{TEParameters}

Function TEParameters.AddItem(
  Const aName: String;
  Const aType: SmallInt): TEParameterBase;
Begin
  If ContainsKey(aName) Then
    Raise Exception.Create('Parameter with same name already exist');

  Case aType Of
    cParamTypeConnection:
      Result := TEConnectionParameter.Create;
    cParamTypeAdditional:
      Result := TEAdditionalParameter.Create;
  Else
    Raise Exception.Create(Format('Invalid type [Value %d - %d expected]', [cParamTypeConnection, cParamTypeAdditional]));
  End;
  Result.Name := aName;
  Add(aName, Result);
End;

Constructor TEParameters.Create;
Begin
  Inherited Create([doOwnsValues]);

  FIsLoaded := False;
  FSTDBParams := Nil;
End;

Procedure TEParameters.DeleteItemByName(const aParmName: String);
Begin
  STDBParams.DeleteChild(aParmName);
  Remove(aParmName);
End;

Function TEParameters.GetSTDBParams: IESTDBNode;
Begin
   If Not Assigned(FSTDBParams) Then
      FSTDBParams := STDatabase[cSTDBNodeParams, False];
   Result := FSTDBParams;
End;

Procedure TEParameters.LoadData(Const aFileName: String);
Var
  varIniFile: TIniFile;
  varList: TStringList;
  varParameter: TEParameterBase;
  sCurrName: String;
  iCntr: Integer;
  varSTDBNode: IESTDBNode;
Begin
  varSTDBNode := STDBParams.FirstChild;
  While Assigned(varSTDBNode) Do
  Begin
    sCurrName := varSTDBNode.Name.Trim;
    If sCurrName.IsEmpty Then
      Raise Exception.Create('Parameter Name cannot be empty');

    // Only load active Items { Ajmal }
    If STDBParams[sCurrName].Status = sdsActive Then
    Begin
      varParameter := AddItem(sCurrName, STDBParams[sCurrName].ChildNode[cParamType, cParamTypeInvalid].Value);
      varParameter.LoadData;
    End;

    varSTDBNode := STDBParams.NextChild;
  End;

  // If data is already saved to db, then don't load from Ini anymore { Ajmal }
  If STDBParams.AsBoolean Then
    Exit;

  varIniFile := TIniFile.Create(aFileName);
  varList := TStringList.Create;
  varList.Duplicates := dupIgnore;
  varList.Sorted := True;
  Try
    varIniFile.ReadSections(varList);
    For iCntr := 0 To Pred(varList.Count) Do
    Begin
      sCurrName := varList[iCntr];
      If sCurrName = '' Then
        Continue;

      varParameter := AddItem(sCurrName, varIniFile.ReadInteger(sCurrName, cParamType, cParamTypeInvalid));
      If Not Assigned(varParameter) Then
        Continue; // Parameter with same name already exist or invalid parameter type. { Ajmal }

      varParameter.LoadData(aFileName);
    End;
    FIsLoaded := True;

    // Save data to database { Ajmal }
    SaveData;
  Finally
    varIniFile.Free;
    varList.Free;
  End;
End;

Procedure TEParameters.SaveData;
Var
  varParameter: TEParameterBase;
Begin
  If Not FIsLoaded Then
    Exit; // Don't save if it's not loaded. { Ajmal }

  For varParameter In Values Do
    varParameter.SaveData;

  STDBParams.Value := True;
  STDatabase.SaveToDB;
End;

{TEConnectionParameter}

Constructor TEConnectionParameter.Create;
Begin
  Inherited;

  ParamType := cParamTypeConnection;
End;

Procedure TEConnectionParameter.LoadData(Const aFilename: String);
Var
  varIniFile: TIniFile;
Begin
  Inherited;

  varIniFile := TIniFile.Create(aFilename);
  Try
    Connection := varIniFile.ReadString(Name, cParamConnection, '');
    ExcludeAdditionalParams := varIniFile.ReadBool(Name, cParamExcludeAdditional, False);
  Finally
    varIniFile.Free;
  End;
End;

Procedure TEConnectionParameter.LoadData;
Begin
  Inherited;

  Connection := STDBNode[cParamConnection, ''].AsString;
  ExcludeAdditionalParams := STDBNode[cParamExcludeAdditional, False].AsBoolean;
End;

Procedure TEConnectionParameter.SaveData;
Begin
  Inherited;

  STDBNode[cParamConnection].Value := Connection;
  STDBNode[cParamExcludeAdditional].Value := ExcludeAdditionalParams;
End;

End.
