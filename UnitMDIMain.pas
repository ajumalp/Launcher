Unit UnitMDIMain;

{ ---------------------------------------------------------- }
{ Developed by Muhammad Ajmal p }
{ ajumalp@gmail.com }
{ ---------------------------------------------------------- }

Interface

Uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Types,
  System.Variants,
  System.UITypes,
  DateUtils,
  Clipbrd,
  StrUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  ShlObj,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ImgList,
  ShellApi,
  IniFiles,
  Generics.Collections,
  Vcl.Buttons,
  Vcl.Menus,
  Vcl.AppEvnts,
  Vcl.ComCtrls,
  ESoft.Launcher.Application,
  ESoft.Launcher.Parameter,
  ESoft.Launcher.RecentItems,
  System.Zip,
  ESoft.Utils,
  PngImageList,
  Vcl.Samples.Spin,
  Vcl.StdActns,
  Vcl.BandActn,
  Vcl.ExtActns,
  Vcl.ListActns,
  Vcl.DBClientActns,
  Vcl.DBActns,
  Vcl.ActnList,
  ESoft.Launcher.Clipboard,
  AbBase,
  AbBrowse,
  AbZBrows,
  AbUnzper,
  AbArcTyp,
  ESoft.Launcher.PopupList,
  BackgroundWorker,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  ESoft.UI.Downloader,
  IdHTTP,
  System.Actions,
  System.ImageList;

Const
  cIMG_NONE = -1;

  cESoftLauncher = 'ESoft_Launcher';
  cV6_FOLDER = 'C:\Users\All Users\SoftTech\V6\';
  cConnection_INI = 'V6ConnectionIds.ini';
  cConfig_INI = 'Config.ini';
  cGroup_INI = 'Group.eini';
  cTemplateGroup_INI = 'TemplateGroup.eini';
  cParam_INI = 'Params.eini';
  cClipbord_Data = 'ClpBrd.edat';
  cDatabaseFileName = 'launcher.db3';
  cConnectionState = 'CONNECTION_STATE';

  cSTDBNodeConfig = 'Config';
  cSTDBNodeGroups = 'Groups';
  cSTDBNodeParams = 'Params';

  cMenuSeperatorCaption = '-';

  // In the order MMmmRRBB
  // M - Major, m - Minor, R - Release and B - Build { Ajmal }
  cApplication_Version = 02000112;
  cAppVersion = '2.0.1.12';

Type
  // Forward declarations
  TFormMDIMain = Class;

  eTBatteryState = (ebsVeryLow, ebsLow, ebsNormal, ebsHigh, ebsFull);

  TEBatterySmartPlug = Class
  Strict Private
    FEnabled: Boolean;
    FOwner: TFormMDIMain;
    FRequestWaitInterval: Integer;

    Function GetEnabled: Boolean;
    Procedure SetEnabled(Const aValue: Boolean);

    Function GetBatteryPercent: Byte;
    Function GetTimer: TTimer;
    Procedure SetEnableSmartPlug(Const aValue: Boolean);
    Function GetBatteryState: eTBatteryState;
    Function GetTurnOffLevel: Integer;
    Function GetTurnOffUniqueID: String;
    Function GetTurnOnLevel: Integer;
    Function GetTurnOnUniqueID: String;
    Procedure SetTurnOffLevel(aValue: Integer);
    Procedure SetTurnOffUniqueID(Const aValue: String);
    Procedure SetTurnOnLevel(aValue: Integer);
    Procedure SetTurnOnUniqueID(Const aValue: String);
  Public
    FSysPowerStatus: TSystemPowerStatus;

    Constructor Create(Const aOwner: TFormMDIMain);
    Procedure Execute;
    Function IsACInputAvailable: Boolean;

    Property Owner: TFormMDIMain Read FOwner;
    Property SysPowerStatus: TSystemPowerStatus Read FSysPowerStatus;
    Property BatteryPercent: Byte Read GetBatteryPercent;
    Property Timer: TTimer Read GetTimer;
    Property BatteryState: eTBatteryState Read GetBatteryState;
    Property EnableSmartPlug: Boolean Write SetEnableSmartPlug;

    Property Enabled: Boolean Read GetEnabled Write SetEnabled;
    Property TurnOnLevel: Integer Read GetTurnOnLevel Write SetTurnOnLevel;
    Property TurnOffLevel: Integer Read GetTurnOffLevel Write SetTurnOffLevel;
    Property TurnOnUniqueID: String Read GetTurnOnUniqueID Write SetTurnOnUniqueID;
    Property TurnOffUniqueID: String Read GetTurnOffUniqueID Write SetTurnOffUniqueID;
  End;

  TFormMDIMain = Class(TForm)
    OpenDialog: TOpenDialog;
    TrayIcon: TTrayIcon;
    PopupMenuTray: TPopupMenu;
    ApplicationEvents: TApplicationEvents;
    PMItemExit: TMenuItem;
    N1: TMenuItem;
    PMItemShowHide: TMenuItem;
    N2: TMenuItem;
    PMItemAppSep: TMenuItem;
    PopupMenuListView: TPopupMenu;
    PMItemEditGroup: TMenuItem;
    PMItemAddGroup: TMenuItem;
    N3: TMenuItem;
    PMItemUpdate: TMenuItem;
    PMItemDeleteGroup: TMenuItem;
    tvApplications: TTreeView;
    MainMenu: TMainMenu;
    MenuSettings: TMenuItem;
    MenuFile: TMenuItem;
    N4: TMenuItem;
    MItemExit: TMenuItem;
    MItemHide: TMenuItem;
    MItemStartMinimized: TMenuItem;
    MItemParameters: TMenuItem;
    PanelDeveloper: TPanel;
    MItemShowHideSettings: TMenuItem;
    MItemAutoStart: TMenuItem;
    PMItemTrayUpdate: TMenuItem;
    N5: TMenuItem;
    MItemBackup: TMenuItem;
    MItemRestore: TMenuItem;
    MItemAutobackup: TMenuItem;
    MenuHelp: TMenuItem;
    PMItemCheckforupdate: TMenuItem;
    imlAppIcons: TPngImageList;
    grpSettings: TGroupBox;
    pnlConnection: TPanel;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    sBtnBrowseConnection: TSpeedButton;
    edtConnection: TButtonedEdit;
    hKeyGeneral: THotKey;
    Label3: TLabel;
    PMItemRecentItems: TMenuItem;
    N6: TMenuItem;
    PMItemNotes: TMenuItem;
    PMItemAddFromClipboard: TMenuItem;
    PMItemViewOrEditNotes: TMenuItem;
    PMItemRunasAdministrator: TMenuItem;
    Panel2: TPanel;
    Label4: TLabel;
    sEdtRecentItemCount: TSpinEdit;
    PMItemApplications: TMenuItem;
    PMItemCategories: TMenuItem;
    Label5: TLabel;
    cbGroupItems: TComboBox;
    ImageList_20: TImageList;
    tskDlgUpdateList: TTaskDialog;
    bkGndUpdateAppList: TBackgroundWorker;
    MItemImmediateUpdate: TMenuItem;
    lblAppListNotUpdated: TLabel;
    ActionListMain: TActionList;
    actSendMailDeveloper: TSendMail;
    tskDlgGetVersionDetails: TTaskDialog;
    bkGndFetchAppVersionDetails: TBackgroundWorker;
    PMItemFavorite: TMenuItem;
    TimerBatterySmartPlug: TTimer;
    MItemBattSP: TMenuItem;
    MItemPurgeDB: TMenuItem;
    grpSmartPlugSettings: TGroupBox;
    MItemGeneralSettings: TMenuItem;
    MItemSmartPlugSettings: TMenuItem;
    MItemHideAllSettings: TMenuItem;
    Panel3: TPanel;
    Label6: TLabel;
    edtTurnOFFID: TButtonedEdit;
    edtMaxThreshold: TEdit;
    Panel4: TPanel;
    Label7: TLabel;
    edtTurnONID: TButtonedEdit;
    edtMinThreshold: TEdit;
    MItemSave: TMenuItem;
    Procedure sBtnBrowseConnectionClick(Sender: TObject);
    Procedure edtConnectionRightButtonClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure FormHide(Sender: TObject);
    Procedure PMItemShowHideClick(Sender: TObject);
    Procedure PMItemExitClick(Sender: TObject);
    Procedure PMItemEditGroupClick(Sender: TObject);
    Procedure PopupMenuListViewPopup(Sender: TObject);
    Procedure PMItemUpdateClick(Sender: TObject);
    Procedure PMItemDeleteGroupClick(Sender: TObject);
    Procedure PMItemAddGroupClick(Sender: TObject);
    Procedure tvApplicationsDblClick(Sender: TObject);
    Procedure PopupMenuTrayPopup(Sender: TObject);
    Procedure ApplicationEventsActivate(Sender: TObject);
    Procedure MItemParametersClick(Sender: TObject);
    Procedure MItemAutoStartClick(Sender: TObject);
    Procedure MItemBackupClick(Sender: TObject);
    Procedure MItemRestoreClick(Sender: TObject);
    Procedure PMItemCheckforupdateClick(Sender: TObject);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Procedure tvApplicationsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure cbGroupItemsChange(Sender: TObject);
    Procedure PMItemAddFromClipboardClick(Sender: TObject);
    Procedure PMItemViewOrEditNotesClick(Sender: TObject);
    Procedure bkGndUpdateAppListWork(Worker: TBackgroundWorker);
    Procedure bkGndUpdateAppListWorkComplete(Worker: TBackgroundWorker; Cancelled: Boolean);
    Procedure tskDlgUpdateListButtonClicked(Sender: TObject; ModalResult: TModalResult; Var CanClose: Boolean);
    Procedure bkGndUpdateAppListWorkProgress(Worker: TBackgroundWorker; PercentDone: Integer);
    Procedure PanelDeveloperClick(Sender: TObject);
    Procedure bkGndFetchAppVersionDetailsWork(aWorker: TBackgroundWorker);
    Procedure bkGndFetchAppVersionDetailsWorkComplete(Worker: TBackgroundWorker; Cancelled: Boolean);
    Procedure tskDlgGetVersionDetailsButtonClicked(Sender: TObject; ModalResult: TModalResult; Var CanClose: Boolean);
    Procedure PMItemFavoriteClick(Sender: TObject);
    Procedure TimerBatterySmartPlugTimer(aSender: TObject);
    Procedure MItemBattSPClick(Sender: TObject);
    Procedure MItemPurgeDBClick(Sender: TObject);
    Procedure MItemHideAllSettingsClick(Sender: TObject);
    Procedure MItemGeneralSettingsClick(Sender: TObject);
    Procedure MItemSmartPlugSettingsClick(Sender: TObject);
    Procedure edtTurnOFFIDRightButtonClick(Sender: TObject);
    Procedure MItemSaveClick(Sender: TObject);
    // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
  Strict Private
    // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
    FFixedMenuItems: TList<TMenuItem>;
    FHotKeyMain: NativeUInt;
    FParameters: TEParameters;
    FInitialized: Boolean;
    FAppGroups, FTemplateGroups: TEApplicationGroups;
    FParentFolder: String;
    FConnections: TEConnections;
    FDisplayLabels: TStringList;
    FParamCategories: TStringList;
    FRecentItems: TERecentItems;
    FClipboardItems: TEClipboardItems;
    FCurrentProgressMessage: String;
    FPopupMenuClosed: Boolean;
    FDownloadManager: IEDownloadManager;
    FBatterySmartPlug: TEBatterySmartPlug;
    FUseDatabase: Boolean;

    Procedure OnRecentItemsChange(aSender: TObject);
    Function MenuItemApplications(Const aType: Integer = cIMG_NONE): TMenuItem;
    Procedure OpenClipboardBrowser;
    Procedure OpenParamBrowser(Const aApplication: IEApplication = Nil);
    Function GetConnections: TEConnections;
    Function GetAppGroups: TEApplicationGroups;
    Function GetParameters: TEParameters;
    Function GetDisplayLabels: TStringList;
    Procedure DeleteOldBackups;
    Procedure RegisterAppHotKey;
    Function ApplicationFromMenuItem(Const aMenuItem: TMenuItem): TEApplication;
    Function GetRunAsAdmin: Boolean;
    Procedure SetRunAsAdmin(Const aValue: Boolean);
    Function GetRecentItems: TERecentItems;
    Procedure ClearRecentItems(aSender: TObject);
    Function AppSeparatorMenuIndex(Const aType: Integer): Integer;
    Function GetClipboardItems: TEClipboardItems;
    Function GetImageIndexForFileExt(Const aExtension: String): Integer;
    Function GetAppGroupTemplates: TEApplicationGroups;
    Function GetParamCategories: TStringList;
    Procedure OpenParentFolderClick(aSender: TObject);
    Function GetBatterySmartPlug: TEBatterySmartPlug;
  Protected
    Procedure WndProc(Var aMessage: TMessage); Override;
    Procedure WMHotKey(Var Msg: TWMHotKey); Message WM_HOTKEY;
    Procedure WMDropFiles(Var aMessage: TWMDropFiles); Message WM_DROPFILES;
  Public
    { Public declarations }
    Constructor Create(aOwner: TComponent); Override;
    Destructor Destroy; Override;

    Procedure LoadConfig;
    Procedure SaveConfig;
    Procedure LoadConfigFromDB;
    Function BackupFolder: String;
    Procedure UpdateApplicationListInBackGround;
    Procedure UpdateApplicationList(Const aForceUpdate: Boolean = False);
    Procedure ReloadFromIni;
    Procedure RunApplication(Const aName, aExecutableName, aParameter, aSourcePath: String; aSkipFromRecent: Boolean; Const aRunAsAdmin: TCheckBoxState);
    Procedure LoadParamCategories;
    Procedure ShowTrayNotification(Const aMessage: String; Const aMsgType: TBalloonFlags = bfInfo);

    Property BatterySmartPlug: TEBatterySmartPlug Read GetBatterySmartPlug;
    Property BatterySPTimer: TTimer Read TimerBatterySmartPlug;
    Property RecentItems: TERecentItems Read GetRecentItems;
  Published
    Property AppGroups: TEApplicationGroups Read GetAppGroups;
    Property AppGroupTemplates: TEApplicationGroups Read GetAppGroupTemplates;
    Property Parameters: TEParameters Read GetParameters;
    Property Connections: TEConnections Read GetConnections;
    Property ParentFolder: String Read FParentFolder;
    Property IsRunAsAdmin: Boolean Read GetRunAsAdmin Write SetRunAsAdmin;
    Property DisplayLabels: TStringList Read GetDisplayLabels;
    Property ParamCategories: TStringList Read GetParamCategories;
    Property ClipboardItems: TEClipboardItems Read GetClipboardItems;
    Property UseDatabase: Boolean Read FUseDatabase;
  End;

Var
  FormMDIMain: TFormMDIMain;

Implementation

{$R *.dfm}

Uses
  ESoft.Launcher.UI.AppGroupEditor,
  ESoft.Launcher.UI.ParamBrowser,
  ESoft.Launcher.UI.BackupRestore,
  ESoft.Launcher.UI.ClipboardBrowser,
  ESoft.Launcher.DM.Main;

Const
  cIMG_DELETE = 4;
  cIMG_BRANCH = 9;
  cIMG_CATEGORY = 19;
  cIMG_HIDE = 40;
  cIMG_SHOW = 41;
  cIMG_APPLICATION = 45;
  cIMG_APP_UPDATE = 46;
  cIMG_PARENT_GROUP = 48;
  cIMG_GROUP = 54;
  cIMG_FILE_UNKNOWN = 55;
  cIMG_FILE_PDF = 56;
  cIMG_FILE_ZIP = 57;
  cIMG_FILE_DOC = 58;
  cIMG_FILE_EXCEL = 59;
  cIMG_FILE_MUSIC = 60;
  cIMG_FILE_LINK = 61;
  cIMG_FOLDER = 62;
  cIMG_URL = 63;
  cIMG_APP_UPDATE_REQUIRED = 64;
  cIMG_FILE_PPT = 65;
  cIMG_FILE_PUBLISHER = 66;
  cIMG_FILE_ACCESSDB = 67;
  cIMG_FILE_TEXT = 68;
  cIMG_FILE_IMAGE = 69;
  cIMG_FILE_VIDEO = 70;

  cGroupVisible_None = 0;
  cGroupVisible_All = 1;
  cGroupVisible_ApplicationOnly = 2;
  cGroupVisible_CategoryOnly = 3;

  cAppZipFileNameInSite = 'http://esoft.ucoz.com/Downloads/Launcher/Launcher.zip';
  cAppZipLinkedFileNameFormat = 'http://esoft.ucoz.com/Downloads/Launcher/Launcher.z%.2d';
  cUniqueAppVersionCode = cESoftLauncher;

  cConfigBasic = 'Basic';
  cConfigFileName = 'FileName';
  cConfigStartMinimized = 'StartMinimized';
  cConfigRunAsAdmin = 'RunAsAdmin';
  cConfigAutoBackUpOnExit = 'AutoBackUpOnExit';
  cConfigHotKey = 'HotKey';
  cConfigDefaultHotKeyText = 'Alt+Q';
  cConfigRecentCount = 'RecentItemsCount';
  cConfigGroupItems = 'GroupItems';
  cConfigImediateUpdate = 'ImediateUpdate';
  cConfigUseDB = 'UseDatabase';

  cConfigSPBattery = 'Smart Plug (Battery)';
  cConfigSPBEnabled = 'Enabled';
  cConfigSPBMinThreshold = 'MinThreshold';
  cConfigSPBMaxThreshold = 'MaxThreshold';
  cConfigSPBONUID = 'ONUniqueID';
  cConfigSPBOFFUID = 'OFFUniqueID';

  cBackups = 'Backups\';

  cURL_API_BASE = 'https://saapp.erratums.com/api.php';

Resourcestring
  rsClearRecentItems = 'Clear';
  rsUpdateApplication = 'Update';
  rsUpdateApplicationRequired = 'Update [Required]';

  { TFormMDIMain }
Procedure TFormMDIMain.ApplicationEventsActivate(Sender: TObject);
Var
  Mutex: THandle;
Begin
  If Not FInitialized Then
  Begin
    FInitialized := True;
    Mutex := CreateMutex(Nil, False, cESoftLauncher);
    If WaitForSingleObject(Mutex, 0) = WAIT_TIMEOUT Then
    Begin
      MessageDlg('Aplication is already running.' + sLineBreak + 'Only single instance allowed.', mtError, [mbOK], 0);
      Application.Terminate;
    End
    Else
    Begin
      Visible := Not MItemStartMinimized.Checked;
      UpdateApplicationList(True);
      ClipboardItems.Load;
    End;
  End;
End;

Function TFormMDIMain.ApplicationFromMenuItem(Const aMenuItem: TMenuItem): TEApplication;
Var
  varObject: TObject;
Begin
  Result := Nil;

  varObject := Pointer(aMenuItem.Tag);
  If varObject.InheritsFrom(TEApplication) Then
    Result := varObject As TEApplication;
End;

Function TFormMDIMain.AppSeparatorMenuIndex(Const aType: Integer): Integer;
Var
  varMenuItem: TMenuItem;
Begin
  Result := 0;
  varMenuItem := MenuItemApplications(aType);
  If varMenuItem = PopupMenuTray.Items Then
    Result := varMenuItem.IndexOf(PMItemAppSep)
  Else
    Result := varMenuItem.Count;
End;

Function TFormMDIMain.BackupFolder: String;
Begin
  Result := ParentFolder + cBackups;
End;

Procedure TFormMDIMain.bkGndFetchAppVersionDetailsWork(aWorker: TBackgroundWorker);
Var
  sZipFileName, sFileLink: String;
  varIDHttp: TIdHTTP;
  iCntr: Integer;
Begin
  varIDHttp := TIdHTTP.Create(Self);
  Try
    sZipFileName := ParamStr(0) + ExtractFileExt(cAppZipFileNameInSite);
    FDownloadManager.Add(cAppZipFileNameInSite, sZipFileName);
    iCntr := 0;
    While True Do
    Begin
      If bkGndFetchAppVersionDetails.CancellationPending Then
      Begin
        bkGndFetchAppVersionDetails.AcceptCancellation;
        Break;
      End;

      Try
        Inc(iCntr);
        sFileLink := Format(cAppZipLinkedFileNameFormat, [iCntr]);
        sZipFileName := ParamStr(0) + ExtractFileExt(sFileLink);
        varIDHttp.Head(sFileLink);
        If varIDHttp.ResponseCode = 200 Then
        Begin
          FDownloadManager.Add(sFileLink, sZipFileName);
          // Delete the file if exists { Ajmal }
          If FileExists(sZipFileName) Then
          Begin
            If Not DeleteFile(sZipFileName) Then
              Raise Exception.Create('Cannot delete the file.');
          End;
        End;
      Except
        Break; // No more file exist so exit loop. { Ajmal }
      End;
    End;
  Finally
    varIDHttp.Free;
  End;
End;

Procedure TFormMDIMain.bkGndFetchAppVersionDetailsWorkComplete(Worker: TBackgroundWorker; Cancelled: Boolean);
Begin
  tskDlgGetVersionDetails.Buttons[0].Click;
End;

Procedure TFormMDIMain.bkGndUpdateAppListWork(Worker: TBackgroundWorker);
Begin
  UpdateApplicationListInBackGround;
End;

Procedure TFormMDIMain.bkGndUpdateAppListWorkComplete(Worker: TBackgroundWorker; Cancelled: Boolean);
Begin
  tskDlgUpdateList.Buttons[0].Click;
End;

Procedure TFormMDIMain.bkGndUpdateAppListWorkProgress(Worker: TBackgroundWorker; PercentDone: Integer);
Var
  iPercentageDone: Integer;
Begin
  tskDlgUpdateList.ProgressBar.Position := PercentDone;
  tskDlgUpdateList.ExpandedText := FCurrentProgressMessage;
  iPercentageDone := Round((PercentDone / tskDlgUpdateList.ProgressBar.Max) * 100);
  tskDlgUpdateList.FooterText := Format('%d%% compleated', [iPercentageDone]);
End;

Procedure TFormMDIMain.cbGroupItemsChange(Sender: TObject);
Begin
  UpdateApplicationList;
End;

Procedure TFormMDIMain.edtConnectionRightButtonClick(Sender: TObject);
Begin
  Connections.FileName := '';
  edtConnection.Text := Connections.FileName;
End;

Procedure TFormMDIMain.edtTurnOFFIDRightButtonClick(Sender: TObject);
Begin
  If Sender Is TButtonedEdit Then
    TButtonedEdit(Sender).Clear;
End;

Procedure TFormMDIMain.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
  CanClose := False;
  Hide;
End;

Procedure TFormMDIMain.FormCreate(Sender: TObject);
Var
  iCntr: Integer;
Begin
  PMItemFavorite.Visible := False;
  Caption := 'Launcher [' + cAppVersion + ']';
  FPopupMenuClosed := True;
  DragAcceptFiles(Handle, True);
  // Store the permenent menu into FixedItem list. { Ajmal }
  // While updating the TrayIcon popup, we should not remove these menu items. { Ajmal }
  FFixedMenuItems := TList<TMenuItem>.Create;
  For iCntr := 0 To Pred(MenuItemApplications.Count) Do
    FFixedMenuItems.Add(MenuItemApplications[iCntr]);

  PanelDeveloper.Caption := 'Developed by Muhammad Ajmal P';
  FInitialized := False;
  FParentFolder := ExtractFilePath(ParamStr(0));
  MItemAutoStart.Checked := AddToStartup(cESoftLauncher, REG_READ);

  LoadConfig;
  RegisterAppHotKey;

  edtConnection.Text := Connections.FileName;
End;

Procedure TFormMDIMain.FormDestroy(Sender: TObject);
Begin
  bkGndUpdateAppList.Cancel;
  bkGndFetchAppVersionDetails.Cancel;
  bkGndUpdateAppList.WaitFor;
  bkGndFetchAppVersionDetails.WaitFor;

  UnRegisterHotKey(Handle, FHotKeyMain);
  GlobalDeleteAtom(FHotKeyMain);

  EFreeAndNil(FFixedMenuItems);
  EFreeAndNil(FRecentItems);
  EFreeAndNil(FDisplayLabels);
  EFreeAndNil(FParamCategories);
  EFreeAndNil(FConnections);
  EFreeAndNil(FClipboardItems);
  EFreeAndNil(FTemplateGroups);
End;

Procedure TFormMDIMain.FormHide(Sender: TObject);
Begin
  ShowTrayNotification('Developed by Muhammad Ajmal P');
End;

Function TFormMDIMain.GetAppGroups: TEApplicationGroups;
Begin
  If FAppGroups = Nil Then
  Begin
    FAppGroups := TEApplicationGroups.Create;
    FAppGroups.LoadData(ParentFolder + cGroup_INI);
  End;

  Result := FAppGroups;
End;

Function TFormMDIMain.GetAppGroupTemplates: TEApplicationGroups;
Begin
  If Not Assigned(FTemplateGroups) Then
  Begin
    FTemplateGroups := TEApplicationGroups.Create;
    FTemplateGroups.LoadData(ParentFolder + cTemplateGroup_INI);
  End;

  Result := FTemplateGroups;
End;

Function TFormMDIMain.GetBatterySmartPlug: TEBatterySmartPlug;
Begin
  If Not Assigned(FBatterySmartPlug) Then
    FBatterySmartPlug := TEBatterySmartPlug.Create(Self);
  Result := FBatterySmartPlug;
End;

Function TFormMDIMain.GetClipboardItems: TEClipboardItems;
Begin
  If Not Assigned(FClipBoardItems) Then
    FClipboardItems := TEClipboardItems.Create;
  Result := FClipboardItems;
End;

Function TFormMDIMain.GetConnections: TEConnections;
Begin
  If FConnections = Nil Then
    FConnections := TEConnections.Create;
  Result := FConnections;
End;

Function TFormMDIMain.GetDisplayLabels: TStringList;
Begin
  If Not Assigned(FDisplayLabels) Then
  Begin
    FDisplayLabels := TStringList.Create;
    FDisplayLabels.Duplicates := dupIgnore;
    FDisplayLabels.Sorted := True;
  End;
  Result := FDisplayLabels;
End;

Function TFormMDIMain.GetImageIndexForFileExt(Const aExtension: String): Integer;
Begin
  Result := cIMG_FILE_UNKNOWN;
  If SameText(aExtension, '.pdf') Then
    Result := cIMG_FILE_PDF
  Else If SameText(aExtension, '.txt') Then
    Result := cIMG_FILE_TEXT
  Else If SameText(aExtension, '.zip') Then
    Result := cIMG_FILE_ZIP
  Else If SameText(aExtension, '.rar') Then
    Result := cIMG_FILE_ZIP
  Else If SameText(aExtension, '.doc') Or SameText(aExtension, '.docx') Then
    Result := cIMG_FILE_DOC
  Else If SameText(aExtension, '.xls') Or SameText(aExtension, '.xlsx') Then
    Result := cIMG_FILE_EXCEL
  Else If SameText(aExtension, '.ppt') Or SameText(aExtension, '.pptx') Then
    Result := cIMG_FILE_PPT
  Else If SameText(aExtension, '.pub') Then
    Result := cIMG_FILE_PUBLISHER
  Else If SameText(aExtension, '.accdb') Then
    Result := cIMG_FILE_ACCESSDB
  Else If SameText(aExtension, '.mp3') Or SameText(aExtension, '.wma') Then
    Result := cIMG_FILE_MUSIC
  Else If SameText(aExtension, '.jpg') Or SameText(aExtension, '.jpeg') Or SameText(aExtension, '.png') Or SameText(aExtension, '.bmp') Then
    Result := cIMG_FILE_IMAGE
  Else If SameText(aExtension, '.mp4') Or SameText(aExtension, '.avi') Or SameText(aExtension, '.wmv') Then
    Result := cIMG_FILE_VIDEO
  Else If SameText(aExtension, '.lnk') Then
    Result := cIMG_FILE_LINK;
End;

Function TFormMDIMain.GetParamCategories: TStringList;
Begin
  If Not Assigned(FParamCategories) Then
  Begin
    FParamCategories := TStringList.Create;
    FParamCategories.Duplicates := dupIgnore;
    FParamCategories.Sorted := True;
    LoadParamCategories;
  End;
  Result := FParamCategories;
End;

Procedure TFormMDIMain.LoadParamCategories;
Var
  varParameter: TEParameterBase;
Begin
  ParamCategories.Clear;
  For varParameter In Parameters.Values Do
  Begin
    If Trim(varParameter.ParamCategory) <> '' Then
      ParamCategories.Add(varParameter.ParamCategory);
  End;
End;

Function TFormMDIMain.GetParameters: TEParameters;
Begin
  If Not Assigned(FParameters) Then
  Begin
    FParameters := TEParameters.Create;
    FParameters.LoadData(ParentFolder + cParam_INI);
    LoadParamCategories;
  End;
  Result := FParameters;
End;

Function TFormMDIMain.GetRecentItems: TERecentItems;
Begin
  If Not Assigned(FRecentItems) Then
  Begin
    FRecentItems := TERecentItems.Create(True);
    FRecentItems.OnChange := OnRecentItemsChange;
  End;
  Result := FRecentItems;
End;

Function TFormMDIMain.GetRunAsAdmin: Boolean;
Begin
  Result := PMItemRunasAdministrator.Checked;
End;

Procedure TFormMDIMain.LoadConfig;
Var
  varIniFile: TIniFile;
  bIsCopiedToDB: Boolean;
Begin
  bIsCopiedToDB := STDatabase[cSTDBNodeConfig, False].AsBoolean;
  LoadConfigFromDB;

  If bIsCopiedToDB Then
    Exit;

  varIniFile := TIniFile.Create(ParentFolder + cConfig_INI);
  Try
    FUseDatabase := varIniFile.ReadBool(cConfigBasic, cConfigUseDB, True);
    MItemAutobackup.Checked := varIniFile.ReadBool(cConfigBasic, cConfigAutoBackUpOnExit, False);
    MItemStartMinimized.Checked := varIniFile.ReadBool(cConfigBasic, cConfigStartMinimized, True);
    MItemImmediateUpdate.Checked := varIniFile.ReadBool(cConfigBasic, cConfigImediateUpdate, True);
    IsRunAsAdmin := varIniFile.ReadBool(cConfigBasic, cConfigRunAsAdmin, False);
    Connections.FileName := varIniFile.ReadString(cConfigBasic, cConfigFileName, '');
    hKeyGeneral.HotKey := TextToShortCut(varIniFile.ReadString(cConfigBasic, cConfigHotKey, cConfigDefaultHotKeyText));
    sEdtRecentItemCount.Value := varIniFile.ReadInteger(cConfigBasic, cConfigRecentCount, 5);
    cbGroupItems.ItemIndex := varIniFile.ReadInteger(cConfigBasic, cConfigGroupItems, cGroupVisible_None);

    BatterySmartPlug.Enabled := varIniFile.ReadBool(cConfigSPBattery, cConfigSPBEnabled, False);
    BatterySmartPlug.TurnOnLevel := varIniFile.ReadInteger(cConfigSPBattery, cConfigSPBMinThreshold, 20);
    BatterySmartPlug.TurnOffLevel := varIniFile.ReadInteger(cConfigSPBattery, cConfigSPBMaxThreshold, 100);
    BatterySmartPlug.TurnOnUniqueID := varIniFile.ReadString(cConfigSPBattery, cConfigSPBONUID, '');
    BatterySmartPlug.TurnOffUniqueID := varIniFile.ReadString(cConfigSPBattery, cConfigSPBOFFUID, '');

    // Save data to database { Ajmal }
    SaveConfig;
  Finally
    varIniFile.Free;
  End;
End;

Procedure TFormMDIMain.LoadConfigFromDB;
Var
  varSTDBNode: IESTDBNode;
Begin
  varSTDBNode := STDatabase[cSTDBNodeConfig].ChildNode[cConfigBasic];
  MItemAutobackup.Checked := varSTDBNode[cConfigAutoBackUpOnExit, False].AsBoolean;
  MItemStartMinimized.Checked := varSTDBNode[cConfigStartMinimized, True].AsBoolean;
  MItemImmediateUpdate.Checked := varSTDBNode[cConfigImediateUpdate, True].AsBoolean;
  IsRunAsAdmin := varSTDBNode[cConfigRunAsAdmin, False].AsBoolean;
  Connections.FileName := varSTDBNode[cConfigFileName, ''].AsString;
  hKeyGeneral.HotKey := TextToShortCut(varSTDBNode[cConfigHotKey, cConfigDefaultHotKeyText].AsString);
  sEdtRecentItemCount.Value := varSTDBNode[cConfigRecentCount, 5].AsInteger;
  cbGroupItems.ItemIndex := varSTDBNode[cConfigGroupItems, cGroupVisible_None].AsInteger;

  varSTDBNode := STDatabase[cSTDBNodeConfig].ChildNode[cConfigSPBattery];
  BatterySmartPlug.Enabled := varSTDBNode[cConfigSPBEnabled, False].AsBoolean;
  BatterySmartPlug.TurnOnLevel := varSTDBNode[cConfigSPBMinThreshold, 20].AsInteger;
  BatterySmartPlug.TurnOffLevel := varSTDBNode[cConfigSPBMaxThreshold, 100].AsInteger;
  BatterySmartPlug.TurnOnUniqueID := varSTDBNode[cConfigSPBONUID, ''].AsString;
  BatterySmartPlug.TurnOffUniqueID := varSTDBNode[cConfigSPBOFFUID, ''].AsString;
End;

Function TFormMDIMain.MenuItemApplications(Const aType: Integer): TMenuItem;
Begin
  Result := PopupMenuTray.Items;
  If cbGroupItems.ItemIndex = cGroupVisible_None Then
    Exit;

  Case aType Of
    cIMG_CATEGORY:
      Begin
        If cbGroupItems.ItemIndex In [cGroupVisible_All, cGroupVisible_CategoryOnly] Then
          Result := PMItemCategories;
      End;
    cIMG_APPLICATION:
      Begin
        If cbGroupItems.ItemIndex In [cGroupVisible_All, cGroupVisible_ApplicationOnly] Then
          Result := PMItemApplications;
      End;
  End;
End;

Procedure TFormMDIMain.MItemAutoStartClick(Sender: TObject);
Begin
  MItemAutoStart.Checked := Not MItemAutoStart.Checked;
  If MItemAutoStart.Checked Then
    AddToStartup(cESoftLauncher, REG_ADD)
  Else
    AddToStartup(cESoftLauncher, REG_DELETE);
End;

Procedure TFormMDIMain.DeleteOldBackups;
Const
  cDate_Year = 0;
  cDate_Month = 1;
  cDate_Day = 2;
Var
  varSearch: TSearchRec;
  varDate: TDate;
  sFileDateTemp: String;
  sFileDateArray: TStringDynArray;
  iYear, iMonth, iDay: Word;
Begin
  If FindFirst(BackupFolder + cESoftLauncher + '_*.zip', faArchive, varSearch) = 0 Then
  Begin
    Repeat
      // The name of the file will be
      // ESoft_Launcher_2015_Nov_02-22_30_13
      // So if we split using '_' 3rd will be the year, 4th month and 5th is day.
      // We split again to get the Year, Month and day { Ajmal }
      sFileDateTemp := StringReplace(varSearch.Name, cESoftLauncher + '_', '', []);
      sFileDateTemp := SplitString(sFileDateTemp, '-')[0];
      sFileDateArray := SplitString(sFileDateTemp, '_');
      iYear := StrToInt(sFileDateArray[cDate_Year]);
      iMonth := IndexText(sFileDateArray[cDate_Month], FormatSettings.ShortMonthNames) + 1;
      iDay := StrToInt(sFileDateArray[cDate_Day]);
      varDate := EncodeDate(iYear, iMonth, iDay);

      If varDate < (Date - 15) Then
        DeleteFile(BackupFolder + varSearch.Name);

    Until FindNext(varSearch) <> 0;
    FindClose(varSearch);
  End;
End;

Destructor TFormMDIMain.Destroy;
Begin
  FreeAndNil(FBatterySmartPlug);

  Inherited;
End;

Procedure TFormMDIMain.MItemBackupClick(Sender: TObject);
Var
  varZipFile: TZipFile;

  Procedure _AddFileToZip(Const aFileName: String);
  Begin
    If FileExists(aFileName) Then
      varZipFile.Add(aFileName);
  End;

Var
  sZipFileName: String;
Begin
  If Not DirectoryExists(BackupFolder) Then
  Begin
    If Not ForceDirectories(BackupFolder) Then
      Raise Exception.Create('Access denied. Cannot create backup folder.');
  End;

  DeleteOldBackups;
  STDatabase.Connection.Close;
  varZipFile := TZipFile.Create;
  Try
    sZipFileName := GetUniqueFilename(BackupFolder, '.zip', cESoftLauncher + '_');
    varZipFile.Open(sZipFileName, zmWrite);
    _AddFileToZip(ParentFolder + cConfig_INI);
    _AddFileToZip(ParentFolder + cGroup_INI);
    _AddFileToZip(ParentFolder + cParam_INI);
    _AddFileToZip(ParentFolder + cClipbord_Data);
    _AddFileToZip(ParentFolder + cDatabaseFileName);
    varZipFile.Close;
  Finally
    varZipFile.Free;
  End;
End;

Procedure TFormMDIMain.MItemBattSPClick(Sender: TObject);
Begin
  BatterySPTimer.Enabled := Not BatterySPTimer.Enabled;
  MItemBattSP.Checked := BatterySPTimer.Enabled;
End;

Procedure TFormMDIMain.MItemGeneralSettingsClick(Sender: TObject);
Begin
  grpSmartPlugSettings.Hide;
  grpSettings.Show;
  MItemGeneralSettings.Checked := True;
End;

Procedure TFormMDIMain.MItemHideAllSettingsClick(Sender: TObject);
Begin
  grpSettings.Hide;
  grpSmartPlugSettings.Hide;
  MItemHideAllSettings.Checked := True;
End;

Procedure TFormMDIMain.MItemPurgeDBClick(Sender: TObject);
Begin
  If MessageDlg('Are you sure you want delete purge data? ', mtWarning, mbYesNo, mrYes) = mrNo Then
    Exit;

  STDatabase.PurgeDatabase;
End;

Procedure TFormMDIMain.MItemParametersClick(Sender: TObject);
Begin
  OpenParamBrowser;
End;

Procedure TFormMDIMain.MItemRestoreClick(Sender: TObject);
Begin
  FormBackupRestore := TFormBackupRestore.Create(Self);
  Try
    FormBackupRestore.ShowModal;
  Finally
    FreeAndNil(FormBackupRestore);
  End;
End;

Procedure TFormMDIMain.MItemSaveClick(Sender: TObject);
Begin
  SaveConfig;
  ClipboardItems.Save;
  If Assigned(FParameters) Then
  Begin
    Parameters.SaveData;
    FreeAndNil(FParameters);
  End;

  If Assigned(FAppGroups) Then
  Begin
    Try
      AppGroups.SaveData(ParentFolder + cGroup_INI);
    Except
      // Do nothing here { Ajmal }
    End;
    FreeAndNil(FAppGroups);
  End;

  MessageDlg('Data saved successfully', mtInformation, [mbOK], 0);
End;

Procedure TFormMDIMain.MItemSmartPlugSettingsClick(Sender: TObject);
Begin
  grpSettings.Hide;
  grpSmartPlugSettings.Show;
  MItemSmartPlugSettings.Checked := True;
End;

Procedure TFormMDIMain.ClearRecentItems(aSender: TObject);
Begin
  If MessageDlg('Do you want to clear recent items ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo Then
    Exit;

  RecentItems.Clear;
  PMItemRecentItems.Clear;
End;

Constructor TFormMDIMain.Create(aOwner: TComponent);
Begin
  Inherited;

  FBatterySmartPlug := Nil;
  FUseDatabase := True;
End;

Procedure TFormMDIMain.OnRecentItemsChange(aSender: TObject);

  Function _AddMenuItem(Const aCaption: String; Const aItem: TERecentItem = Nil): TMenuItem;
  Var
    iImageIndex: Integer;
    varIcon: TIcon;
    iCntr: Integer;
    varParamMenu: TMenuItem;
  Begin
    Result := TMenuItem.Create(PMItemRecentItems);
    Result.Caption := aCaption;
    If Assigned(aItem) Then
    Begin
      Try
        varIcon := aItem.Icon;
        If Assigned(varIcon) Then
        Begin
          iImageIndex := imlAppIcons.AddIcon(aItem.Icon);
          imlAppIcons.GetBitmap(iImageIndex, Result.Bitmap);
        End;
      Except
        // Currently it's not important to have the icon. { Ajmal }
      End;
      // Adding the new item { Ajmal }
      If aItem.Parameter.Count < 2 Then
      Begin
        Result.Hint := '';
        Result.Tag := NativeInt(aItem);
        Result.OnClick := tvApplicationsDblClick;
      End
      Else
      Begin
        For iCntr := 0 To Pred(aItem.Parameter.Count) Do
        Begin
          varParamMenu := TMenuItem.Create(Result);
          varParamMenu.Caption := aItem.Parameter[iCntr];
          varParamMenu.Hint := aItem.Parameter[iCntr];
          varParamMenu.OnClick := tvApplicationsDblClick;
          varParamMenu.Tag := NativeInt(aItem);
          Result.Add(varParamMenu);
        End;
      End;
    End;
    PMItemRecentItems.Add(Result);
  End;

Var
  iCntr: Integer;
Begin
  PMItemRecentItems.Clear;
  With _AddMenuItem(rsClearRecentItems, Nil) Do
  Begin
    ImageIndex := cIMG_DELETE;
    OnClick := ClearRecentItems;
  End;

  _AddMenuItem(cMenuSeperatorCaption);
  For iCntr := 0 To Pred(RecentItems.Count) Do
  Begin
    If iCntr = sEdtRecentItemCount.Value Then
      Break;

    _AddMenuItem(RecentItems[iCntr].Name, RecentItems[iCntr]);
  End;
End;

Procedure TFormMDIMain.OpenClipboardBrowser;
Begin
  If Assigned(FormClipboardBrowser) Then
  Begin
    FormClipboardBrowser.BringToFront;
    EFlashWindow(FormClipboardBrowser.Handle);
    Exit;
  End;

  If Visible Then
    FormClipboardBrowser := TFormClipboardBrowser.Create(Self)
  Else
    FormClipboardBrowser := TFormClipboardBrowser.Create(Application);
  Try
    FormClipboardBrowser.Load;
    FormClipboardBrowser.ShowModal;
  Finally
    EFreeAndNil(FormClipboardBrowser);
  End;
End;

Procedure TFormMDIMain.OpenParamBrowser(Const aApplication: IEApplication);
Begin
  If Assigned(FormParameterBrowser) Then
  Begin
    FormParameterBrowser.BringToFront;
    EFlashWindow(FormParameterBrowser.Handle);
    Exit;
  End;

  If Visible Then
    FormParameterBrowser := TFormParameterBrowser.Create(Self, aApplication)
  Else
    FormParameterBrowser := TFormParameterBrowser.Create(Application, aApplication);
  Try
    FormParameterBrowser.ShowModal;
  Finally
    EFreeAndNil(FormParameterBrowser);
  End;
End;

Procedure TFormMDIMain.OpenParentFolderClick(aSender: TObject);
Var
  varAppGroup: TEApplicationGroup;
Begin
  varAppGroup := Pointer(TMenuItem(aSender).Tag);

  If Assigned(varAppGroup) Then
    ShellExecute(Handle, 'open', PWideChar(varAppGroup.TargetFolder), '', '', SW_SHOWMAXIMIZED);
End;

Procedure TFormMDIMain.PMItemAddGroupClick(Sender: TObject);
Begin
  If TFormAppGroupEditor.CreatGroupFromFile = mrOk Then
    UpdateApplicationList;
End;

Procedure TFormMDIMain.PMItemCheckforupdateClick(Sender: TObject);
Var
  iAppVersion: Integer;
  sMainZipFilaeName: String;
  varZipFile: TAbUnZipper;
Begin
  Try
    iAppVersion := StrToInt(GetAppVersionFromSite(cUniqueAppVersionCode));
  Except
    MessageDlg('Cannot connect to server.' + sLineBreak + 'Please check your internet connection', mtError, [mbOK], 0);
    Exit;
  End;

  If cApplication_Version < iAppVersion Then
  Begin
    If MessageDlg(cNewAppVersionAvailablePrompt, mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes Then
    Begin
      sMainZipFilaeName := ParamStr(0) + '.zip';
      FDownloadManager := TEDownloadManager.Create(Self);
      varZipFile := TAbUnZipper.Create(Self);
      Try
        bkGndFetchAppVersionDetails.Execute;
        tskDlgGetVersionDetails.Execute;

        If bkGndFetchAppVersionDetails.CancellationPending Then
          Exit;

        If FDownloadManager.Download Then
        Begin
          If FileExists(ParentFolder + 'Old_' + ExtractFileName(ParamStr(0))) Then
          Begin
            If Not DeleteFile(ParentFolder + 'Old_' + ExtractFileName(ParamStr(0))) Then
              Raise Exception.Create('Cannot delete the file.');
          End;
          RenameFile(ParamStr(0), ParentFolder + 'Old_' + ExtractFileName(ParamStr(0)));
          varZipFile.FileName := sMainZipFilaeName;
          varZipFile.BaseDirectory := ParentFolder;
          varZipFile.ExtractOptions := [eoCreateDirs, eoRestorePath];
          varZipFile.ExtractFiles('*.*');

          If FileExists(ParamStr(0)) Then
            MessageDlg('Application updated.', mtWarning, [mbOK], 0)
          Else
          Begin
            RenameFile(ParentFolder + 'Old_' + ExtractFileName(ParamStr(0)), ParamStr(0));
            MessageDlg('Updation failed. Please try again.', mtError, [mbOK], 0);
          End;
          PMItemExit.Click;
        End;
      Finally
        FDownloadManager := Nil;
        varZipFile.Free;
      End;
    End;
  End
  Else
    MessageDlg(Format(cNoNewAppVersionAvailablePrompt, [cAppVersion]), mtInformation, [mbOK], 0);
End;

Procedure TFormMDIMain.PMItemViewOrEditNotesClick(Sender: TObject);
Begin
  OpenClipboardBrowser;
End;

Procedure TFormMDIMain.PMItemDeleteGroupClick(Sender: TObject);
Var
  varSelected: TObject;
Begin
  If MessageDlg('Are you sure you want to delete ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes Then
  Begin
    If Assigned(tvApplications.Selected) Then
      varSelected := tvApplications.Selected.Data;
    If Assigned(varSelected) And varSelected.InheritsFrom(TEApplicationGroup) Then
    Begin
      AppGroups.Remove(TEApplicationGroup(varSelected).Name);
      AppGroups.SaveData(ParentFolder + cGroup_INI);
    End;
    UpdateApplicationList;
  End;
End;

Procedure TFormMDIMain.PMItemEditGroupClick(Sender: TObject);
Var
  varSelected: TObject;
Begin
  varSelected := TObject(tvApplications.Selected.Data);
  If Assigned(varSelected) And varSelected.InheritsFrom(TEApplicationGroup) Then
  Begin
    FormAppGroupEditor := TFormAppGroupEditor.Create(Self, varSelected As TEApplicationGroup);
    Try
      If FormAppGroupEditor.ShowModal = mrOk Then
        UpdateApplicationList;
    Finally
      FormAppGroupEditor.Free;
    End;
  End;
End;

Procedure TFormMDIMain.PMItemExitClick(Sender: TObject);
Begin
  Try
    Try
      SaveConfig;
    Except
      // Do nothing { Ajmal }
    End;
  Finally
    Application.Terminate;
  End;
End;

Procedure TFormMDIMain.PMItemFavoriteClick(Sender: TObject);
Begin
  Raise Exception.Create('Funtionality not implimented yet.');
End;

Procedure TFormMDIMain.PanelDeveloperClick(Sender: TObject);
Begin
  // actSendMailDeveloper.Execute;
End;

Procedure TFormMDIMain.PMItemAddFromClipboardClick(Sender: TObject);
Var
  sClpBrdName: String;
  bFormVisiblity: Boolean;
Const
  cItemExistMessage = 'An item with same name already exist.' + sLineBreak + 'Do you want to overwrite ?';
Begin
  bFormVisiblity := Visible;
  Try
    If Not Visible Then
      Show;

    While True Do
    Begin
      sClpBrdName := DateTimeToStr(Now);
      If Not InputQuery('Copy clipboard', 'Name', sClpBrdName) Then
        Exit;

      If sClpBrdName = '' Then
        Continue; // cannot add without name { Ajmal }
      If ClipboardItems.Contains(sClpBrdName) And (MessageDlg(cItemExistMessage, mtWarning, [mbYes, mbNo], 0, mbNo) = mrNo) Then
        Continue;
      ClipboardItems.AddItem(sClpBrdName).LoadFromClipboard;
      ClipboardItems.Save;
      Break; // We did the change. Exit the loop now { Ajmal }
    End;
  Finally
    Visible := bFormVisiblity;
  End;
End;

Procedure TFormMDIMain.PMItemShowHideClick(Sender: TObject);
Begin
  If Assigned(FormParameterBrowser) Then
  Begin
    OpenParamBrowser;
    Exit;
  End
  Else If Assigned(FormClipboardBrowser) Then
  Begin
    OpenClipboardBrowser;
    Exit;
  End;

  Visible := Not Visible;
  If Visible And (WindowState = wsMinimized) Then
    WindowState := wsNormal;
  BringToFront;
End;

Procedure TFormMDIMain.PMItemUpdateClick(Sender: TObject);
Begin
  UpdateApplicationList(True);
End;

Procedure TFormMDIMain.PopupMenuListViewPopup(Sender: TObject);
Begin
  PMItemUpdate.ImageIndex := cIMG_APP_UPDATE;
  If lblAppListNotUpdated.Visible Then
    PMItemUpdate.ImageIndex := cIMG_APP_UPDATE_REQUIRED;

  PMItemEditGroup.Enabled := Assigned(tvApplications.Selected) And Assigned(tvApplications.Selected.Data) And TObject(tvApplications.Selected.Data).InheritsFrom(TEApplicationGroup);
  PMItemDeleteGroup.Enabled := PMItemEditGroup.Enabled;
End;

Procedure TFormMDIMain.PopupMenuTrayPopup(Sender: TObject);
Begin
  If Assigned(FDownloadManager) And FDownloadManager.IsDownloading Then
    Abort;

  If bkGndFetchAppVersionDetails.IsWorking Then
    Abort;

  PMItemTrayUpdate.Caption := rsUpdateApplication;
  PMItemTrayUpdate.ImageIndex := cIMG_APP_UPDATE;
  If lblAppListNotUpdated.Visible Then
  Begin
    PMItemTrayUpdate.Caption := rsUpdateApplicationRequired;
    PMItemTrayUpdate.ImageIndex := cIMG_APP_UPDATE_REQUIRED;
  End;

  PMItemApplications.Visible := cbGroupItems.ItemIndex In [cGroupVisible_All, cGroupVisible_ApplicationOnly];
  PMItemCategories.Visible := cbGroupItems.ItemIndex In [cGroupVisible_All, cGroupVisible_CategoryOnly];
  PMItemApplications.Enabled := PMItemApplications.Count > 0;
  PMItemCategories.Visible := PMItemCategories.Count > 0;
  PMItemViewOrEditNotes.Enabled := ClipboardItems.Count > 0;
  PMItemAddFromClipboard.Enabled := Trim(Clipboard.AsText) <> '';
  PMItemNotes.Visible := (PMItemAddFromClipboard.Enabled Or PMItemViewOrEditNotes.Enabled) And Not Assigned(FormClipboardBrowser);
  PMItemRecentItems.Visible := PMItemRecentItems.Count > 0;

  If Visible Then
    PMItemShowHide.ImageIndex := cIMG_HIDE
  Else
    PMItemShowHide.ImageIndex := cIMG_SHOW;
End;

Procedure TFormMDIMain.RegisterAppHotKey;

  Function _GetModifier(Const aModifiers: THKModifiers = [hkAlt]): Cardinal;
  Begin
    Result := 0;
    If hkShift In aModifiers Then
      Result := Result Or MOD_SHIFT;
    If hkCtrl In aModifiers Then
      Result := Result Or MOD_CONTROL;
    If hkAlt In aModifiers Then
      Result := Result Or MOD_ALT;
  End;

Var
  varShift: TShiftState;
  cKey: Word;
Begin
  FHotKeyMain := GlobalAddAtom(cESoftLauncher);
  ShortCutToKey(hKeyGeneral.HotKey, cKey, varShift);
  RegisterHotKey(Handle, FHotKeyMain, _GetModifier(hKeyGeneral.Modifiers), cKey);
End;

Procedure TFormMDIMain.ReloadFromIni;
Begin
  LoadConfig;
  EFreeAndNil(FParameters);
  EFreeAndNil(FAppGroups);
  EFreeAndNil(FTemplateGroups);
  UpdateApplicationList(True);
End;

Procedure TFormMDIMain.SaveConfig;
Var
  varSTDBNode: IESTDBNode;
Begin
  If MItemAutobackup.Checked Then
    MItemBackup.Click;

  varSTDBNode := STDatabase[cSTDBNodeConfig].ChildNode[cConfigBasic];
  varSTDBNode[cConfigAutoBackUpOnExit].Value := MItemAutobackup.Checked;
  varSTDBNode[cConfigStartMinimized].Value := MItemStartMinimized.Checked;
  varSTDBNode[cConfigImediateUpdate].Value := MItemImmediateUpdate.Checked;
  varSTDBNode[cConfigRunAsAdmin].Value := IsRunAsAdmin;
  varSTDBNode[cConfigHotKey].Value := ShortCutToText(hKeyGeneral.HotKey);
  varSTDBNode[cConfigRecentCount].Value := sEdtRecentItemCount.Value;
  varSTDBNode[cConfigGroupItems].Value := cbGroupItems.ItemIndex;
  varSTDBNode[cConfigFileName].Value := Connections.FileName;
  If Connections.FileName = (cV6_FOLDER + cConnection_INI) Then
    varSTDBNode[cConfigFileName].Clear;

  varSTDBNode := STDatabase[cSTDBNodeConfig].ChildNode[cConfigSPBattery];
  varSTDBNode[cConfigSPBEnabled].Value := BatterySmartPlug.Enabled;
  varSTDBNode[cConfigSPBMinThreshold].Value := BatterySmartPlug.TurnOnLevel;
  varSTDBNode[cConfigSPBMaxThreshold].Value := BatterySmartPlug.TurnOffLevel;
  varSTDBNode[cConfigSPBONUID].Value := BatterySmartPlug.TurnOnUniqueID;
  varSTDBNode[cConfigSPBOFFUID].Value := BatterySmartPlug.TurnOffUniqueID;

  STDatabase[cSTDBNodeConfig].Value := True;
  STDatabase.SaveToDB;
End;

Procedure TFormMDIMain.sBtnBrowseConnectionClick(Sender: TObject);
Begin
  If OpenDialog.Execute(Handle) Then
  Begin
    Connections.FileName := OpenDialog.FileName;
    edtConnection.Text := Connections.FileName;
  End;
End;

Procedure TFormMDIMain.SetRunAsAdmin(Const aValue: Boolean);
Begin
  PMItemRunasAdministrator.Checked := aValue;
End;

Procedure TFormMDIMain.ShowTrayNotification(Const aMessage: String; Const aMsgType: TBalloonFlags);
Begin
  TrayIcon.BalloonFlags := aMsgType;
  TrayIcon.BalloonHint := aMessage;
  TrayIcon.ShowBalloonHint;
End;

Procedure TFormMDIMain.TimerBatterySmartPlugTimer(aSender: TObject);
Begin
  BatterySmartPlug.Execute;
End;

Procedure TFormMDIMain.tskDlgGetVersionDetailsButtonClicked(Sender: TObject; ModalResult: TModalResult; Var CanClose: Boolean);
Begin
  If bkGndFetchAppVersionDetails.IsWorking Then
  Begin
    CanClose := MessageDlg('Are you sure you want to cancel ?', mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes;
    If CanClose Then
    Begin
      bkGndFetchAppVersionDetails.Cancel;
      bkGndFetchAppVersionDetails.WaitFor;
    End;
  End;
End;

Procedure TFormMDIMain.tskDlgUpdateListButtonClicked(Sender: TObject; ModalResult: TModalResult; Var CanClose: Boolean);
Begin
  If bkGndUpdateAppList.IsWorking Then
  Begin
    CanClose := MessageDlg('Are you sure you want to cancel ?', mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes;
    If CanClose Then
    Begin
      bkGndUpdateAppList.Cancel;
      bkGndUpdateAppList.WaitFor;
    End;
  End;
End;

Procedure TFormMDIMain.tvApplicationsDblClick(Sender: TObject);
Var
  varSelected: TObject;
  varAppGroup: TEApplicationGroup Absolute varSelected;
  varApplication: TEApplication Absolute varSelected;
  varRecentItem: TERecentItem Absolute varSelected;
  varMenu: TMenuItem ABSOLUTE Sender;
Begin
  varSelected := Nil;
  If Sender Is TTreeView Then
  Begin
    If Not Assigned(tvApplications.Selected) Then
      Exit;
    varSelected := tvApplications.Selected.Data;
  End
  Else If Sender Is TMenuItem Then
    varSelected := Pointer(varMenu.Tag);

  If Assigned(varSelected) Then
  Begin
    If varSelected.InheritsFrom(TERecentItem) Then
      varRecentItem.RunExecutable(varMenu.Hint) // TERecentItem are in Popupmenu only { Ajmal }
    Else If varSelected.InheritsFrom(TEApplication) Then
    Begin
      If Not varApplication.ISFixedParameter Then
        OpenParamBrowser(varApplication)
      Else
      Begin
        If varApplication.CopyFromSourceFolder Then
          varApplication.UnZip;
        varApplication.RunExecutable;
      End;
    End
    Else If varSelected.InheritsFrom(TEApplicationGroup) And varAppGroup.IsApplication Then
    Begin
      If Not varAppGroup.ISFixedParameter Then
        OpenParamBrowser(varAppGroup)
      Else
        varAppGroup.RunExecutable;
    End;
  End;
End;

Procedure TFormMDIMain.tvApplicationsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  varSelectedNode: TTreeNode;
Begin
  varSelectedNode := tvApplications.GetNodeAt(X, Y);
  If Assigned(varSelectedNode) Then
    varSelectedNode.Selected := True;
End;

Procedure TFormMDIMain.UpdateApplicationList(Const aForceUpdate: Boolean);
Var
  bVisible: Boolean;
Begin
  If Not(aForceUpdate Or MItemImmediateUpdate.Checked) Then
  Begin
    lblAppListNotUpdated.Show;
    Exit;
  End;

  bVisible := Visible;
  If Not Visible Then
  Begin
    WindowState := wsMinimized;
    Show;
  End;

  Try
    tskDlgUpdateList.ProgressBar.Max := AppGroups.Count;
    bkGndUpdateAppList.Execute;
    tskDlgUpdateList.Execute;
    lblAppListNotUpdated.Hide;
  Finally
    Visible := bVisible;
  End;
End;

Procedure TFormMDIMain.UpdateApplicationListInBackGround;
Var
  varMenuItems: TStringList;

  Function _AddMenu(Const aLabel: String; Const aMenuItem: TMenuItem; Const aParentMenu: TMenuItem = Nil): TMenuItem;
  Var
    varCurrMenuLabel: TMenuItem;
    iCntr: Integer;
  Begin
    Result := Nil;

    If Assigned(aParentMenu) Then
    Begin
      Result := aParentMenu.Find(aLabel);
      If Assigned(Result) Then
        Exit;

      Result := TMenuItem.Create(aParentMenu);
      Result.Caption := aLabel;
      Result.ImageIndex := cIMG_BRANCH;
      aParentMenu.Add(Result);
      Exit;
    End;

    If aLabel = '' Then
    Begin
      MenuItemApplications(cIMG_APPLICATION).Insert(AppSeparatorMenuIndex(cIMG_APPLICATION), aMenuItem);
      Exit;
    End;

    varCurrMenuLabel := Nil;
    For iCntr := 0 To Pred(varMenuItems.Count) Do
    Begin
      varCurrMenuLabel := varMenuItems.Objects[iCntr] As TMenuItem;
      If SameText(aLabel, varCurrMenuLabel.Caption) Then
        Break;
      varCurrMenuLabel := Nil;
    End;
    If Not Assigned(varCurrMenuLabel) Then
    Begin
      varCurrMenuLabel := TMenuItem.Create(MenuItemApplications(cIMG_CATEGORY));
      varCurrMenuLabel.Caption := aLabel;
      varCurrMenuLabel.ImageIndex := cIMG_CATEGORY;
      varMenuItems.AddObject(aLabel, varCurrMenuLabel);
    End;
    varCurrMenuLabel.Add(aMenuItem);
  End;

  Function _GetLabelNode(Const aLabel: String; Const aCurrentNode: TTreeNode): TTreeNode;
  Var
    varNode: TTreeNode;
    iCntr: Integer;
  Begin
    If aLabel = '' Then
      Exit(aCurrentNode);

    For iCntr := 0 To Pred(aCurrentNode.Count) Do
    Begin
      varNode := aCurrentNode.Item[iCntr];
      If SameText(varNode.Text, aLabel) Then
        Exit(varNode);
    End;
    Result := tvApplications.Items.AddChild(aCurrentNode, aLabel);
    Result.ImageIndex := cIMG_CATEGORY;
    Result.SelectedIndex := cIMG_CATEGORY;
    DisplayLabels.Add(Result.Text);
  End;

  Procedure _ClearMenuItems;
  Var
    iCntr: Integer;
  Begin
    iCntr := 0;
    PMItemApplications.Clear;
    PMItemCategories.Clear;

    While iCntr < MenuItemApplications.Count Do
    Begin
      If FFixedMenuItems.IndexOf(MenuItemApplications[iCntr]) = -1 Then
        MenuItemApplications.Delete(iCntr)
      Else
        Inc(iCntr);
    End;
  End;

  Function _ApplicationBranch(Const aApplication: TEApplication; Const aParentGroup: TMenuItem): TMenuItem;
  Var
    iCntr: Integer;
  Begin
    Result := aParentGroup;

    If Not aApplication.Owner.IsBranchingEnabled Then
      Exit;

    If aApplication.MajorVersionName <> '' Then
      Result := _AddMenu(aApplication.MajorVersionName, Nil, Result);

    If aApplication.MinorVersionName <> '' Then
      Result := _AddMenu(aApplication.MinorVersionName, Nil, Result);

    If aApplication.ReleaseVersionName <> '' Then
      Result := _AddMenu(aApplication.ReleaseVersionName, Nil, Result);

    // For build seperation { Ajmal }
    If aApplication.Owner.NoOfBuilds = 0 Then
      Exit;
    If aApplication.BuildNumber = cInvalidBuildNumber Then
      Exit(Nil);

    If (Result.Count > 0) And (Result.Items[Pred(Result.Count)].Count In [1 .. aApplication.Owner.NoOfBuilds]) Then
    Begin
      Result := Result.Items[Pred(Result.Count)];
      Result.Caption := Format('Builds [%d-%d]', [ //
        aApplication.BuildNumber, //
        ApplicationFromMenuItem(Result.Items[0]).BuildNumber]);
    End
    Else
      Result := _AddMenu(Format('Builds [%d-%d]', [aApplication.BuildNumber, aApplication.BuildNumber]), Nil, Result);
  End;

  Procedure _AddApplications(Const aAppGroup: TEApplicationGroup; Const aCurrentMenuGroup: TMenuItem; Const aFixedMenuCount: Integer);
  Var
    varApp: TEApplication;
    varCurrMenuItem, varBranchMenuItem: TMenuItem;
    iCurrGrpImageIndex, iCurrentItemImgIndex: Integer;
    varIcon: TIcon;
  Begin
    iCurrGrpImageIndex := cIMG_NONE;
    For varApp In aAppGroup Do
    Begin
      If bkGndUpdateAppList.CancellationPending Then
        Break;

      If aAppGroup.IsFolder Then
        varBranchMenuItem := aCurrentMenuGroup
      Else
        varBranchMenuItem := _ApplicationBranch(varApp, aCurrentMenuGroup);

      If Assigned(varBranchMenuItem) Then
      Begin
        varCurrMenuItem := TMenuItem.Create(varBranchMenuItem);
        varCurrMenuItem.Caption := varApp.Name;
        varCurrMenuItem.Tag := NativeInt(varApp);
        varCurrMenuItem.OnClick := tvApplicationsDblClick;
        If iCurrGrpImageIndex <> cIMG_NONE Then
          imlAppIcons.GetBitmap(iCurrGrpImageIndex, varCurrMenuItem.Bitmap)
        Else
        Begin
          varCurrMenuItem.ImageIndex := GetImageIndexForFileExt(varApp.Extension);
          If varCurrMenuItem.ImageIndex = cIMG_FILE_UNKNOWN Then
          Begin
            varCurrMenuItem.Caption := varApp.FileName;
            varIcon := varApp.Icon;
            If Assigned(varIcon) Then
            Begin
              iCurrentItemImgIndex := imlAppIcons.AddIcon(varIcon);
              imlAppIcons.GetBitmap(iCurrentItemImgIndex, varCurrMenuItem.Bitmap);
              If Assigned(varCurrMenuItem.Bitmap) Then
                varCurrMenuItem.ImageIndex := cIMG_NONE;
            End;
          End;
        End;

        // For folder, we need the files to be order in accending. { Ajmal }
        If aAppGroup.IsFolder Then
          varBranchMenuItem.Insert(aFixedMenuCount, varCurrMenuItem)
        Else
          varBranchMenuItem.Add(varCurrMenuItem);
      End;
    End;
  End;

  Function _AddFolders(Const aAppGroup: TEApplicationGroup; Const aCurrMenuGroup: TMenuItem): Integer;
  Var
    varCurrMenuItem, varSubMenuItem: TMenuItem;
    varSubAppGroup: TEApplicationGroup;
    iFolderFixedMenuCount: Integer;
    varFolderNames: TArray<String>;
    sFolderName: String;
  Begin
    Result := 0;
    If bkGndUpdateAppList.CancellationPending Then
      Exit;

    If Not aAppGroup.IsFolder Then
      Exit;

    aCurrMenuGroup.ImageIndex := cIMG_FOLDER;
    If (aAppGroup.Count > 0) Or (aAppGroup.SubItems.Count > 0) Then
    Begin
      varCurrMenuItem := _AddMenu('Open Folder', Nil, aCurrMenuGroup);
      varCurrMenuItem.ImageIndex := cIMG_FILE_LINK;
      aCurrMenuGroup.InsertNewLineAfter(varCurrMenuItem);
    End
    Else
      varCurrMenuItem := aCurrMenuGroup;
    varCurrMenuItem.Tag := NativeInt(aAppGroup);
    varCurrMenuItem.OnClick := OpenParentFolderClick;

    If aAppGroup.SubItems.Count > 0 Then
    Begin
      varFolderNames := aAppGroup.SubItems.Keys.ToArray;
      TArray.Sort<String>(varFolderNames);
      For sFolderName In varFolderNames Do
      Begin
        varSubAppGroup := aAppGroup.SubItems[sFolderName];
        If bkGndUpdateAppList.CancellationPending Then
          Break;

        varSubMenuItem := _AddMenu(varSubAppGroup.Name, Nil, aCurrMenuGroup);
        varSubMenuItem.ImageIndex := cIMG_FOLDER;
        iFolderFixedMenuCount := _AddFolders(varSubAppGroup, varSubMenuItem);
        _AddApplications(varSubAppGroup, varSubMenuItem, iFolderFixedMenuCount);
      End;
      aCurrMenuGroup.InsertNewLineAfter(varSubMenuItem);
    End;

    Result := aCurrMenuGroup.Count;
  End;

Var
  varAppGrp: TEApplicationGroup;
  varCurrNode, varParentNode, varCurrLabelNode: TTreeNode;
  varCurrMenuGroup, varCurrMenuItem: TMenuItem;
  varGroupNames: TArray<String>;
  sCurrGroupName: String;
  iCurrGrpImageIndex: Integer;
  iCntr, iProgressCntr: Integer;
  varIcon: TIcon;
  iFolderFixedMenuCount: Integer;
Begin
  varIcon := Nil;
  iFolderFixedMenuCount := 0;
  tvApplications.Items.Clear;
  _ClearMenuItems;
  imlAppIcons.Clear;

  varMenuItems := TStringList.Create;
  tvApplications.Items.BeginUpdate;
  Try
    varMenuItems.Duplicates := dupIgnore;
    varMenuItems.Sorted := True;
    varParentNode := tvApplications.Items.AddChild(Nil, 'Groups');
    varParentNode.ImageIndex := cIMG_PARENT_GROUP;
    varParentNode.SelectedIndex := cIMG_PARENT_GROUP;
    MenuItemApplications.Enabled := AppGroups.Count > 0;

    varGroupNames := AppGroups.Keys.ToArray;
    TArray.Sort<String>(varGroupNames);
    iProgressCntr := 1;
    For sCurrGroupName In varGroupNames Do
    Begin
      Sleep(25);
      FCurrentProgressMessage := 'Loading application group ' + sCurrGroupName;
      bkGndUpdateAppList.ReportProgressWait(iProgressCntr);
      Inc(iProgressCntr);
      If bkGndUpdateAppList.CancellationPending Then
        Break;

      varAppGrp := AppGroups[sCurrGroupName];
      varCurrLabelNode := _GetLabelNode(varAppGrp.DisplayLabel, varParentNode);
      varCurrNode := tvApplications.Items.AddChildObject(varCurrLabelNode, varAppGrp.Name, varAppGrp);
      varCurrNode.ImageIndex := cIMG_GROUP;
      varCurrNode.SelectedIndex := cIMG_GROUP;
      varCurrMenuGroup := TMenuItem.Create(MenuItemApplications(cIMG_APPLICATION));
      varCurrMenuGroup.Caption := varAppGrp.Name;
      varCurrMenuGroup.ImageIndex := cIMG_GROUP;
      _AddMenu(varAppGrp.DisplayLabel, varCurrMenuGroup);
      iCurrGrpImageIndex := cIMG_NONE;
      If varAppGrp.IsApplication Then
      Begin
        varCurrMenuGroup.Tag := NativeInt(varAppGrp);
        varCurrMenuGroup.OnClick := tvApplicationsDblClick;

        If StrStartsWith(varAppGrp.ExecutableName, 'http://', False) Or StrStartsWith(varAppGrp.ExecutableName, 'https://', False) Then
          iCurrGrpImageIndex := cIMG_URL
        Else If (varAppGrp.ExecutableName <> '') And (ExtractFileExt(varAppGrp.ExecutableName) = '') Then
          iCurrGrpImageIndex := cIMG_FOLDER
        Else
          iCurrGrpImageIndex := cIMG_APPLICATION;

        varCurrMenuGroup.ImageIndex := iCurrGrpImageIndex;
        varCurrNode.ImageIndex := iCurrGrpImageIndex;
        varCurrNode.SelectedIndex := iCurrGrpImageIndex;
        varIcon := varAppGrp.Icon;
        If Assigned(varIcon) Then
        Begin
          iCurrGrpImageIndex := imlAppIcons.AddIcon(varIcon);
          imlAppIcons.GetBitmap(iCurrGrpImageIndex, varCurrMenuGroup.Bitmap);
          varCurrMenuGroup.ImageIndex := cIMG_NONE;
        End;
        Continue;
      End;

      varAppGrp.LoadApplications;
      varCurrMenuGroup.Enabled := (varAppGrp.Count > 0) Or (varAppGrp.SubItems.Count > 0);

      iFolderFixedMenuCount := _AddFolders(varAppGrp, varCurrMenuGroup);
      _AddApplications(varAppGrp, varCurrMenuGroup, iFolderFixedMenuCount);
    End;
    Sleep(500); // Just to wait for progressbar to get updated. { Ajmal }

    // Add a seperator before categories. Only if we have enabled no grouping { Ajmal }
    If cbGroupItems.ItemIndex = cGroupVisible_None Then
    Begin
      varCurrMenuItem := TMenuItem.Create(MenuItemApplications);
      varCurrMenuItem.Caption := cMenuSeperatorCaption;
      MenuItemApplications.Insert(AppSeparatorMenuIndex(cIMG_CATEGORY), varCurrMenuItem);
    End;
    // Add label menu items to popup menu { Ajmal }
    For iCntr := 0 To Pred(varMenuItems.Count) Do
      MenuItemApplications(cIMG_CATEGORY).Insert(AppSeparatorMenuIndex(cIMG_CATEGORY), varMenuItems.Objects[iCntr] As TMenuItem);
    varParentNode.Expand(False);
  Finally
    tvApplications.Items.EndUpdate;
    varMenuItems.Free;
  End;
End;

Procedure TFormMDIMain.WMDropFiles(Var aMessage: TWMDropFiles);
Const
  cMAXFILENAME = 255;
Var
  iCntr, iFileCount: Integer;
  varFileName: Array [0 .. cMAXFILENAME] Of Char;
  varModalResult: TModalResult;
Begin
  varModalResult := mrNone;
  iFileCount := DragQueryFile(aMessage.Drop, $FFFFFFFF, varFileName, cMAXFILENAME);
  Try
    For iCntr := 0 To Pred(iFileCount) Do
    Begin
      DragQueryFile(aMessage.Drop, iCntr, varFileName, cMAXFILENAME);
      If TFormAppGroupEditor.CreatGroupFromFile(varFileName) = mrOk Then
        varModalResult := mrOk; // If any one of the drop file is saved then update the list { Ajmal }
    End;
  Finally
    DragFinish(aMessage.Drop);
    If varModalResult = mrOk Then
      UpdateApplicationList;
  End;
End;

Procedure TFormMDIMain.WMHotKey(Var Msg: TWMHotKey);
Begin
  If Msg.HotKey = FHotKeyMain Then
  Begin
    If Not bkGndUpdateAppList.IsWorking Then
    Begin
      FPopupMenuClosed := False; // Set to false 1st. WndProc will be called before ending below Popup function { Ajmal }
      SetForegroundWindow(Handle);
      PopupMenuTray.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
      PostMessage(Handle, WM_NULL, 0, 0);
    End
  End;
End;

Procedure TFormMDIMain.WndProc(Var aMessage: TMessage);
Begin
  Case aMessage.Msg Of
    CM_MENUCLOSED:
      FPopupMenuClosed := True;
  End;

  Inherited;
End;

Procedure TFormMDIMain.RunApplication(Const aName, aExecutableName, aParameter, aSourcePath: String; aSkipFromRecent: Boolean; Const aRunAsAdmin: TCheckBoxState);
Var
  varRecentItems: TERecentItem;
  bRunAsAdmin: Boolean;
Begin
  bRunAsAdmin := (aRunAsAdmin = cbChecked) Or ((aRunAsAdmin = cbGrayed) And IsRunAsAdmin);
  Try
    If bRunAsAdmin Then
      Try
        RunAsAdmin(Handle, PWideChar(aExecutableName), PWideChar(aParameter), PWideChar(aSourcePath))
      Except
        If MessageDlg('Cannot run as admin' + sLineBreak + 'Do you wan''t to run normal mode ?', mtError, [mbYes, mbNo], 0, mbYes) = mrYes Then
          ShellExecute(Handle, 'open', PWideChar(aExecutableName), PWideChar(aParameter), PWideChar(aSourcePath), SW_SHOWNORMAL);
      End
    Else
      ShellExecute(Handle, 'open', PWideChar(aExecutableName), PWideChar(aParameter), PWideChar(aSourcePath), SW_SHOWNORMAL);

    If Not aSkipFromRecent Then
    Begin
      varRecentItems := RecentItems.AddItem(aName, aSourcePath, aExecutableName);
      varRecentItems.RunAsAdmin := aRunAsAdmin;
      varRecentItems.Parameter.Add(aParameter);
    End;
  Except
    // Do nothing. It's not easily possible to handle all the issues related to shell execute. { Ajmal }
  End;
End;

{ TEBatterySmartPlug }

Constructor TEBatterySmartPlug.Create(Const aOwner: TFormMDIMain);
Begin
  FOwner := aOwner;
  Timer.Interval := 1000;
  Timer.Enabled := True;
  Enabled := False;

  FRequestWaitInterval := 0;
End;

Function TEBatterySmartPlug.IsACInputAvailable: Boolean;
Begin
  Result := SysPowerStatus.ACLineStatus = 1;
End;

Procedure TEBatterySmartPlug.SetEnabled(Const aValue: Boolean);
Begin
  FEnabled := aValue;
  Owner.MItemBattSP.Checked := aValue;
End;

Procedure TEBatterySmartPlug.SetEnableSmartPlug(Const aValue: Boolean);
Var
  varIDHttp: TIdHTTP;
  varParams: TStrings;
Begin
  // Check input power is already in smae state { Ajmal }
  If IsACInputAvailable = aValue Then
    Exit;

  If (Timer.Interval <> 1000) Then
  Begin
    FRequestWaitInterval := 0;
  End
  Else If FRequestWaitInterval > 0 Then
  Begin
    Dec(FRequestWaitInterval);
    Exit;
  End;

  If Not Enabled Then
  Begin
    FRequestWaitInterval := 5;
    If Not aValue Then
      Owner.ShowTrayNotification('Battery full, please turn OFF plug')
    Else
      Owner.ShowTrayNotification('Battery low, please turn ON plug');

    Exit;
  End;

  varParams := TStringList.Create;
  varIDHttp := TIdHTTP.Create(Owner);
  Try
    varParams.Values['uid'] := IfThen(aValue, TurnOnUniqueID, TurnOffUniqueID);
    Try
      If varIDHttp.Post(cURL_API_BASE, varParams).Equals('True') Then
      Begin
        // The request is successful, so wait for 5 secs before next request { Ajmal }
        FRequestWaitInterval := 5;
        Owner.ShowTrayNotification('Request send to turn ' + IfThen(aValue, 'ON', 'Off') + ' smart plug');
      End
      Else
      Begin
        FRequestWaitInterval := 10;
        Owner.ShowTrayNotification('Request to turn ' + IfThen(aValue, 'ON', 'Off') + ' smart plug failed', bfError);
      End;
    Except
      Enabled := False;
      Raise;
    End;
  Finally
    varIDHttp.Free;
    varParams.Free;
  End;
End;

Procedure TEBatterySmartPlug.SetTurnOffLevel(aValue: Integer);
Begin
  If Not(aValue In [20 .. 100]) Then
    aValue := 100;
  Owner.edtMaxThreshold.Text := IntToStr(aValue);
End;

Procedure TEBatterySmartPlug.SetTurnOffUniqueID(Const aValue: String);
Begin
  Owner.edtTurnOFFID.Text := aValue;
End;

Procedure TEBatterySmartPlug.SetTurnOnLevel(aValue: Integer);
Begin
  If Not(aValue In [5 .. 80]) Then
    aValue := 20;
  Owner.edtMinThreshold.Text := IntToStr(aValue);
End;

Procedure TEBatterySmartPlug.SetTurnOnUniqueID(Const aValue: String);
Begin
  Owner.edtTurnONID.Text := aValue;
End;

Procedure TEBatterySmartPlug.Execute;
Begin
  If Not GetSystemPowerStatus(FSysPowerStatus) Then
    Exit;

  If Timer.Interval <> 1000 Then
  Begin
    // If the battery level is near to threshold, check every sec { Ajaml }
    If IfThen(IsACInputAvailable, BatteryState = ebsHigh, BatteryState In [ebsVeryLow, ebsLow]) = True Then
      Timer.Interval := 1000;
  End
  Else
  Begin
    If IfThen(IsACInputAvailable, BatteryState In [ebsVeryLow, ebsLow], BatteryState = ebsHigh) = True Then
      Timer.Interval := 10000;

    If BatteryState In [ebsNormal, ebsFull] Then
      Timer.Interval := 10000;
  End;

  If BatteryPercent In [0 .. TurnOnLevel] Then
    EnableSmartPlug := True
  Else If BatteryPercent In [TurnOffLevel .. 100] Then
    EnableSmartPlug := False;
End;

Function TEBatterySmartPlug.GetBatteryPercent: Byte;
Begin
  Result := SysPowerStatus.BatteryLifePercent;
End;

Function TEBatterySmartPlug.GetBatteryState: eTBatteryState;
Const
  cBatteryLevelAdjust = 3;
Begin
  If BatteryPercent >= 100 Then
    Result := ebsFull
  Else If BatteryPercent <= TurnOnLevel Then
    Result := ebsVeryLow
  Else If BatteryPercent In [TurnOnLevel .. (TurnOnLevel + cBatteryLevelAdjust)] Then
    Result := ebsLow
  Else If BatteryPercent In [(TurnOffLevel - cBatteryLevelAdjust) .. TurnOffLevel] Then
    Result := ebsHigh
  Else
    Result := ebsNormal;
End;

Function TEBatterySmartPlug.GetEnabled: Boolean;
Begin
  Result := FEnabled;
End;

Function TEBatterySmartPlug.GetTimer: TTimer;
Begin
  Result := Owner.BatterySPTimer;
End;

Function TEBatterySmartPlug.GetTurnOffLevel: Integer;
Begin
  Result := 100;
  If Not Integer.TryParse(Owner.edtMaxThreshold.Text, Result) Then
  Begin
    If Not(Result In [20 .. 100]) Then
      Exit(100);
  End;
End;

Function TEBatterySmartPlug.GetTurnOffUniqueID: String;
Begin
  Result := Owner.edtTurnOFFID.Text;
End;

Function TEBatterySmartPlug.GetTurnOnLevel: Integer;
Begin
  Result := 20;
  If Not Integer.TryParse(Owner.edtMinThreshold.Text, Result) Then
  Begin
    If Not(Result In [5 .. 80]) Then
      Exit(20);
  End;
End;

Function TEBatterySmartPlug.GetTurnOnUniqueID: String;
Begin
  Result := Owner.edtTurnONID.Text;
End;

End.
