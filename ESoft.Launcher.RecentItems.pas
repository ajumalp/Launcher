Unit ESoft.Launcher.RecentItems;

{ ---------------------------------------------------------- }
{ Developed by Muhammad Ajmal p }
{ ajumalp@gmail.com }
{ ---------------------------------------------------------- }

Interface

Uses
   Vcl.StdCtrls,
   Winapi.Windows,
   System.Classes,
   IniFiles,
   System.SysUtils,
   ShellApi,
   Vcl.Graphics,
   Generics.Collections,
   ESoft.Utils;

Type
   IEApplication = Interface
      Function GetActualName: String;
      Function GetISFixedParameter: Boolean;
      Function GetRunAsAdmin: TCheckBoxState;
      Procedure SetRunAsAdmin(Const aValue: TCheckBoxState);
      Function GetFixedParameter: String;
      Function GetLastUsedParamName: String;
      Procedure SetLastUsedParamName(Const aValue: String);
      Function RunExecutable(aParameter: String = ''): Boolean;
      Function UnZip: Boolean;
      Function CopyFromSourceFolder: Boolean;
      Function GetIcon: TIcon;

      Property ActualName: String Read GetActualName;
      Property Icon: TIcon Read GetIcon;
      Property ISFixedParameter: Boolean Read GetISFixedParameter;
      Property FixedParameter: String Read GetFixedParameter;
      Property LastUsedParamName: String Read GetLastUsedParamName Write SetLastUsedParamName;
      Property RunAsAdmin: TCheckBoxState Read GetRunAsAdmin Write SetRunAsAdmin;
   End;

   TERecentItems = Class; // Forward declaration { Ajmal }

   TERecentItem = Class(TPersistent, IEApplication)
   Strict Private
      FRunAsAdmin: TCheckBoxState;
      FOwner: TERecentItems;
      FName: String;
      FSourceFolder: String;
      FExecutableName: String;
      FParameters: TStringList;
      FIcon: TIcon;

      Procedure OnParamChange(aSender: TObject);
      Function GetActualName: String;
      Function GetISFixedParameter: Boolean;
      Function GetFixedParameter: String;
      Function GetLastUsedParamName: String;
      procedure SetLastUsedParamName(const aValue: String);
      Function GetRunAsAdmin: TCheckBoxState;
      Procedure SetRunAsAdmin(Const aValue: TCheckBoxState);
      Function GetIcon: TIcon;
      Function GetParameter: TStringList;
   Public
      Constructor Create(Const aOwner: TERecentItems; Const aName: String; Const aSourceFolder: String = ''; Const aExecutableName: String = '');
      Destructor Destroy; Override;

      Function QueryInterface(Const IID: TGUID; Out Obj): HRESULT; Stdcall;
      Function _AddRef: Integer; Stdcall;
      Function _Release: Integer; Stdcall;

      Function RunExecutable(aParameter: String = ''): Boolean;
      Function UnZip: Boolean;
      Function CopyFromSourceFolder: Boolean;

      Property ActualName: String Read GetActualName;
      Property Name: String Read FName;
      Property SourceFolder: String Read FSourceFolder Write FSourceFolder;
      Property ExecutableName: String Read FExecutableName Write FExecutableName;
      Property Parameter: TStringList Read GetParameter;
      Property Icon: TIcon Read GetIcon;
      Property RunAsAdmin: TCheckBoxState Read GetRunAsAdmin Write SetRunAsAdmin;
   End;

   TERecentItems = Class(TObjectList<TERecentItem>)
   Strict Private
      FOnChange: TNotifyEvent;
   Private
      Procedure DoChange(Const aItem: TERecentItem);
   Public
      Function Contains(Const aName: String): Boolean;
      Function IndexOf(Const aName: String): Integer;
      Function AddItem(Const aName: String; Const aSourceFolder: String = ''; Const aExecutableName: String = ''): TERecentItem;
   Published
      Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
   End;

Implementation

{ TERecentItem }

Uses
   UnitMDIMain;

Function TERecentItem.CopyFromSourceFolder: Boolean;
Begin
   Result := True;
End;

Constructor TERecentItem.Create(Const aOwner: TERecentItems; Const aName, aSourceFolder, aExecutableName: String);
Begin
   FOwner := aOwner;
   FName := aName;
   FSourceFolder := aSourceFolder;
   FExecutableName := aExecutableName;
End;

Destructor TERecentItem.Destroy;
Begin
   EFreeAndNil(FParameters);
   EFreeAndNil(FIcon);

   Inherited;
End;

Function TERecentItem.GetActualName: String;
Begin
   Result := Name;
End;

Function TERecentItem.GetFixedParameter: String;
Begin
   // For recent items, Parameters are fixed always from the previous used list. { Ajmal }
   Result := '';
End;

Function TERecentItem.GetIcon: TIcon;
Var
   sFileName: String;
Begin
   Result := Nil;

   sFileName := IncludeTrailingBackslash(SourceFolder) + ExecutableName;
   EFreeAndNil(FIcon);
   // Check for file extention 1st. If it's a network folder, then we skip it first since folder won't have extension { Ajmal }
   If ExtractFileExt(sFileName) = '' Then
      Exit;

   If Not FileExists(sFileName) Then
      Exit;

   FIcon := TIcon.Create;
   Try
      FetchIcon(sFileName, FIcon);
      Result := FIcon;
   Except
      EFreeAndNil(FIcon);
      // Do nothing, it's not mandatory to have icon { Ajmal }
   End;
End;

Function TERecentItem.GetISFixedParameter: Boolean;
Begin
   // For recent items, Parameters are fixed always from the previous used list. { Ajmal }
   Result := True;
End;

Function TERecentItem.GetLastUsedParamName: String;
Begin
   // For recent items, Parameters are fixed always from the previous used list. { Ajmal }
   Result := '';
End;

Function TERecentItem.GetParameter: TStringList;
Begin
   If Not Assigned(FParameters) Then
   Begin
      FParameters := TStringList.Create;
      FParameters.Duplicates := dupIgnore;
      FParameters.Sorted := True;
      FParameters.OnChange := OnParamChange;
   End;
   Result := FParameters;
End;

Function TERecentItem.GetRunAsAdmin: TCheckBoxState;
Begin
   Result := FRunAsAdmin;
End;

Procedure TERecentItem.OnParamChange(aSender: TObject);
Begin
   // For the 1st one, AddItem will call the DoChange { Ajmal }
   If Parameter.Count > 1 Then
      FOwner.DoChange(Self);
End;

Function TERecentItem.QueryInterface(Const IID: TGUID; Out Obj): HRESULT;
Begin
   Inherited;
End;

Function TERecentItem.RunExecutable(aParameter: String): Boolean;
Begin
   If (aParameter = '') And (Parameter.Count > 0) Then
      aParameter := Parameter[0];

   FormMDIMain.RunApplication(
      Name,
      ExecutableName,
      aParameter,
      SourceFolder,
      False,
      RunAsAdmin
   );
End;

Procedure TERecentItem.SetLastUsedParamName(const aValue: String);
Begin
   // For recent items, Parameters are fixed always from the previous used list. { Ajmal }
End;

Procedure TERecentItem.SetRunAsAdmin(const aValue: TCheckBoxState);
Begin
   FRunAsAdmin := aValue;
End;

Function TERecentItem.UnZip: Boolean;
Begin
   Result := True;
End;

Function TERecentItem._AddRef: Integer;
Begin
   Inherited;
End;

Function TERecentItem._Release: Integer;
Begin
   Inherited;
End;

{ TERecentItems }

Function TERecentItems.AddItem(Const aName, aSourceFolder, aExecutableName: String): TERecentItem;
Var
   iIndex: Integer;
Begin
   Result := Nil;

   iIndex := IndexOf(aName);
   If iIndex <> -1 Then
   Begin
      Result := Items[iIndex];
      Move(iIndex, 0);
      If iIndex <> IndexOf(aName) Then
         DoChange(Result);
      Exit;
   End;

   Result := TERecentItem.Create(Self, aName, aSourceFolder, aExecutableName);
   Insert(0, Result);
   DoChange(Result);
End;

Function TERecentItems.Contains(Const aName: String): Boolean;
Begin
   Result := IndexOf(aName) <> -1;
End;

Procedure TERecentItems.DoChange(Const aItem: TERecentItem);
Begin
   If Assigned(FOnChange) Then
      FOnChange(aItem);
End;

Function TERecentItems.IndexOf(Const aName: String): Integer;
Var
   iCntr: Integer;
Begin
   Result := -1;

   For iCntr := 0 To Pred(Count) Do
   Begin
      If SameText(Items[iCntr].Name, aName) Then
         Exit(iCntr);
   End;
End;

End.
