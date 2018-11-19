Unit ESoft.UI.Downloader;

{ ---------- Developed by Muhammad Ajmal P ---------- }
{ ---------- ajumalp@gmail.com --------------------- }

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
   Vcl.ComCtrls,
   IdHTTP,
   Wininet,
   Generics.Collections,
   Math,
   ClipBrd,
   ESoft.Utils,
   BackgroundWorker, 
   Vcl.ExtCtrls;

Type
   // Forward declaration. { Ajmal }
   TEDownloadManager = Class;
   TEDownloaderItemDict = TDictionary<String, String>;

   TFormDownloader = Class(TForm)
      btnCancel: TButton;
      lblTitle: TLabel;
      lblText: TLabel;
      bkGndWorker: TBackgroundWorker;
      lblPercentDone: TLabel;
      Panel1: TPanel;
      pbAll: TProgressBar;
      pbMain: TProgressBar;
      lblFileIndex: TLabel;
      Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
      Procedure btnCancelClick(Sender: TObject);
      Procedure bkGndWorkerWorkComplete(Worker: TBackgroundWorker; Cancelled: Boolean);
      Procedure bkGndWorkerWork(Worker: TBackgroundWorker);
      Procedure bkGndWorkerWorkProgress(Worker: TBackgroundWorker; PercentDone: Integer);
      Procedure FormCreate(Sender: TObject);
      Procedure lblTextClick(Sender: TObject);
   Strict Private
      { Private declarations }
      FDownloader: TEDownloadManager;
      FPaused: Boolean;
      Procedure AdjustSize;
   Protected
      Procedure CreateParams(Var aParams: TCreateParams); Override;
   Public
      Constructor Create(aOwner: TComponent; Const aDownLoader: TEDownloadManager); Reintroduce;
      Destructor Destroy; override;
   End;

   IEDownloadManager = Interface
      ['{4487BEA6-68AF-4773-913A-23FF33D9D688}']
      Function GetOwnerForm: TForm;
      Function GetCaption: String;
      Procedure SetCaption(Const Value: String);
      Function GetDialog: TFormDownloader;
      Function GetPacketSize: Integer;
      Function GetItems: TEDownloaderItemDict;

      Function FileSize: Int64;
      Procedure Add(Const aUrl, aFileName: String);
      Function Download: Boolean;
      Function IsDownloading: Boolean;

      Property Caption: String Read GetCaption Write SetCaption;
      Property Dialog: TFormDownloader Read GetDialog;
      Property OwnerForm: TForm Read GetOwnerForm;
      Property PacketSize: Integer Read GetPacketSize;
      Property Items: TEDownloaderItemDict Read GetItems;
   End;

   TEDownloadManager = Class(TPersistent, IEDownloadManager)
   Strict Private
      FFileSize: Int64;
      FURL, FFileName: String;
      FOwnerForm: TForm;
      FDownloaderForm: TFormDownloader;

      Function GetOwnerForm: TForm;
      Function GetCaption: String;
      Procedure SetCaption(Const Value: String);
      Function GetDialog: TFormDownloader;
      Procedure SetURL(Const Value: String);
      Function GetPacketSize: Integer;
      Function GetItems: TEDownloaderItemDict;

      Function QueryInterface(Const IID: TGUID; Out Obj): HRESULT; Stdcall;
      Function _AddRef: Integer; Stdcall;
      Function _Release: Integer; Stdcall;
   Private
      FItems: TEDownloaderItemDict;
      Property URL: String Read FURL Write SetURL;
      Property FileName: String Read FFileName Write FFileName;
   Public
      Constructor Create(aOwner: TForm);
      Destructor Destroy; Override;

      Function FileSize: Int64;
      Procedure Add(Const aUrl, aFileName: String);
      Function Download: Boolean;
      Function IsDownloading: Boolean;
   Published
      Property Caption: String Read GetCaption Write SetCaption;
      Property Dialog: TFormDownloader Read GetDialog;
      Property OwnerForm: TForm Read GetOwnerForm;
      Property PacketSize: Integer Read GetPacketSize;
      Property Items: TEDownloaderItemDict Read GetItems;
   End;

Implementation

uses
  UnitMDIMain;

{$R *.dfm}

Const
   cProgressMessage = '%d percent downloaded [%2fMB/%2fMB]';
   cFileCountProgress = 'Downloading file %d of %d';
   cDefaultCaption = 'Download Manager';
   cDefaultTitle = 'Downloading file(s)';
   cDefaultText = 'Please wait . . . !';
   cDefaultPacketSize = 51200;
   cProgressFull = -1;
   cProgressUpdateFileSize = -2;
   cConnectionTimeOut = 3000;

   { TEDownloadManager }

Procedure TEDownloadManager.Add(Const aUrl, aFileName: String);
Begin
   Assert(aURL <> '');
   Assert(aFileName <> '');
   Assert(Not Items.ContainsKey(aUrl));
   Assert(Not Items.ContainsValue(aFileName));

   Items.Add(aUrl, aFileName);
End;

Constructor TEDownloadManager.Create(aOwner: TForm);
Begin
   Assert(Assigned(aOwner), 'Owner cannot be nil');

   FOwnerForm := aOwner;
End;

Destructor TEDownloadManager.Destroy;
Begin
   If Assigned(FDownloaderForm) Then
      FreeAndNil(FDownloaderForm);
   If Assigned(FItems) Then
      FreeAndNil(FItems);

   Inherited;
End;

Function TEDownloadManager.FileSize: Int64;

  Function _FileSize(Const aFilename: String): Int64;
  var
    varInfo: TWin32FileAttributeData;
  Begin
     Result := -1;

     If Not GetFileAttributesEx(PWideChar(aFileName), GetFileExInfoStandard, @varInfo) Then
        Exit;

     Result := Int64(varInfo.nFileSizeLow) or Int64(varInfo.nFileSizeHigh shl 32);
  End;

Var
   varHttp: TIdHttp;
Begin
   // If FFileSize <> -1. We have already read the size of this files once. { Ajmal }
   If FFileSize <> -1 Then
      Exit(FFileSize);

   If StrStartsWith(URL, 'file://', False) Then
      Exit(_FileSize(StringReplace(URL, 'file://', '', [])));

   varHttp := TIdHTTP.Create;
   Try
      varHttp.ConnectTimeout := cConnectionTimeOut;
      varHttp.Head(URL);
      FFileSize := varHttp.Response.ContentLength;
      Result := FFileSize;
   Finally
      varHttp.Free;
   End;
End;

Function TEDownloadManager.Download: Boolean;
Begin
   Result := False;

   If FileSize = -1 Then
      Exit;

   Dialog.pbAll.Position := 0;
   Dialog.pbAll.Max := Items.Count;
   If Items.Count < 2 Then
   Begin
      Dialog.pbAll.Hide;
      Dialog.lblFileIndex.Hide;
   End;

   Dialog.lblPercentDone.Caption := 'Connecting. Please wait . . . !';
   Dialog.AdjustSize;
   Dialog.bkGndWorker.Execute;
   Dialog.ShowModal;
   Result := Not (Dialog.bkGndWorker.IsWorking Or Dialog.bkGndWorker.IsCancelled);
End;

Function TEDownloadManager.GetCaption: String;
Begin
   Result := Dialog.Caption;
End;

Function TEDownloadManager.GetDialog: TFormDownloader;
Begin
   If Not Assigned(FDownloaderForm) Then
      FDownloaderForm := TFormDownloader.Create(OwnerForm, Self);
   Result := FDownloaderForm;
End;

Function TEDownloadManager.GetItems: TEDownloaderItemDict;
Begin
   If Not Assigned(FItems) Then
      FItems := TEDownloaderItemDict.Create;
   Result := FItems;
End;

Function TEDownloadManager.GetOwnerForm: TForm;
Begin
   Result := FOwnerForm;
End;

Function TEDownloadManager.GetPacketSize: Integer;
Begin
   Result := cDefaultPacketSize;
End;

Function TEDownloadManager.IsDownloading: Boolean;
Begin
   Result := Dialog.bkGndWorker.IsWorking;
End;

Function TEDownloadManager.QueryInterface(Const IID: TGUID; Out Obj): HRESULT;
Begin
   If GetInterface(IID, Obj) Then
      Result := 0
   Else
      Result := E_NOINTERFACE;
End;

Procedure TEDownloadManager.SetCaption(Const Value: String);
Begin
   Dialog.Caption := Value;
End;

Procedure TEDownloadManager.SetURL(Const Value: String);
Begin
   If FURL <> Value Then
   Begin
      FURL := Value;
      FFileSize := -1;
   End;
End;

Function TEDownloadManager._AddRef: Integer;
Begin
   Inherited;
End;

Function TEDownloadManager._Release: Integer;
Begin
   Free;
   Inherited;
End;

Procedure TFormDownloader.AdjustSize;
Begin
   lblTitle.Visible := Trim(lblTitle.Caption) <> '';
   lblText.Visible := lblTitle.Visible And (Trim(lblText.Caption) <> '');

   If Not lblTitle.Visible Then
      Height := Height - 40;
   If Not lblText.Visible Then
      Height := Height - 20;
End;

Procedure TFormDownloader.bkGndWorkerWork(Worker: TBackgroundWorker);
Var
   hSession: HINTERNET;
   hService: HINTERNET;
   lpBuffer: Array [0 .. cDefaultPacketSize + 1] Of Char;
   dwBytesRead, dwTimeOut: DWORD;
   varFileStrm: TFileStream;
   iProgress: Integer;
   sUrl: String;
Begin
   Assert(FDownloader.Items.Count <> 0);

   FPaused := False;
   For sUrl In FDownloader.Items.Keys Do
   Begin
      FDownloader.URL := sUrl;
      FDownloader.FileName := FDownloader.Items[sUrl];
      Worker.ReportProgress(cProgressUpdateFileSize);

      hSession := InternetOpen(PWideChar(Caption), INTERNET_OPEN_TYPE_PRECONFIG, Nil, Nil, 0);
      Try
         If Assigned(hSession) Then
         Begin
            dwTimeOut := cConnectionTimeOut;
            InternetSetOption(hSession, INTERNET_OPTION_CONNECT_TIMEOUT, @dwTimeOut, SizeOf(dwTimeOut));
            hService := InternetOpenUrl(hSession, PWideChar(FDownloader.URL), Nil, 0, INTERNET_FLAG_RELOAD, 0);
            If Assigned(hService) Then
            Begin
               varFileStrm := TFileStream.Create(FDownloader.FileName, fmCreate);
               iProgress := 0;
               While Not Worker.CancellationPending Do
               Begin
                  If FPaused Then
                  Begin
                     Sleep(1);
                     Continue;
                  End;
                  dwBytesRead := FDownloader.PacketSize;
                  InternetReadFile(hService, @lpBuffer, FDownloader.PacketSize, dwBytesRead);
                  If dwBytesRead = 0 Then
                     Break;
                  lpBuffer[dwBytesRead] := #0;
                  varFileStrm.WriteBuffer(lpBuffer, dwBytesRead);
                  Inc(iProgress);
                  Worker.ReportProgress(iProgress);
               End;

               If Worker.CancellationPending Then
                  Worker.AcceptCancellation
               Else
                  Worker.ReportProgress(cProgressFull);
            End;
         End;
      Finally
         varFileStrm.Free;
         InternetSetOption(hSession, INTERNET_OPTION_RESET_URLCACHE_SESSION, 0, 0);
         InternetCloseHandle(hService);
         InternetCloseHandle(hSession);
         Sleep(500); // Just to wait for progressbar to get updated. { Ajmal }
      End;
      If Worker.IsCancelled Then
         Break;
   End;
   Worker.ReportProgress(cProgressFull);
End;

Procedure TFormDownloader.bkGndWorkerWorkComplete(Worker: TBackgroundWorker; Cancelled: Boolean);
Begin
   If Cancelled Then
      DeleteFile(FDownloader.FileName);
   Close;
End;

Procedure TFormDownloader.bkGndWorkerWorkProgress(Worker: TBackgroundWorker; PercentDone: Integer);
Var
   iPercent, iPacketSizeInMB: Integer;
   bPausedState: Boolean;
Begin
   bPausedState := FPaused;
   FPaused := True;
   Try
     Case PercentDone Of
        cProgressFull:
           pbMain.Position := pbMain.Max;
        cProgressUpdateFileSize:
        Begin
           pbAll.Position := pbAll.Position + 1;
           lblFileIndex.Caption := Format(cFileCountProgress, [pbAll.Position, pbAll.Max]);
           pbMain.Position := 0;
           pbMain.Max := Round(FDownloader.FileSize / FDownloader.PacketSize);
           lblText.Caption := FDownloader.URL;
        End;
        Else
        Begin
           pbMain.Position := PercentDone;

           iPacketSizeInMB := Round(FDownloader.PacketSize / 1000);
           iPercent := Round((PercentDone * 100) Div pbMain.Max);
           If iPercent > 100 Then
              iPercent := 100;

           lblPercentDone.Caption := Format(cProgressMessage, [
              iPercent,
              (pbMain.Position / 1000) * iPacketSizeInMB,
              (pbMain.Max / 1000) * iPacketSizeInMB]);
        End;
     End;
   Finally
     FPaused := bPausedState;
   End;
End;

Procedure TFormDownloader.btnCancelClick(Sender: TObject);
Begin
   FPaused := True;
   pbAll.State := pbsPaused;
   pbMain.State := pbsPaused;
   If MessageDlg('Do you want to cancel downloading ?', mtWarning, [mbYes, mbNo], 0, mbNo) = mrNo Then
   Begin
      pbMain.State := pbsNormal;
      pbAll.State := pbsNormal;
      FPaused := False;
      Exit;
   End;

   If bkGndWorker.IsWorking Then
      bkGndWorker.Cancel;
   bkGndWorker.WaitFor;
   Close;
End;

Constructor TFormDownloader.Create(aOwner: TComponent; Const aDownLoader: TEDownloadManager);
Begin
   Assert(Assigned(aDownLoader));

   Inherited Create(aOwner);

   FDownloader := aDownLoader;
End;

Procedure TFormDownloader.CreateParams(var aParams: TCreateParams);
Begin
   Inherited;

   If Owner <> FormMDIMain Then
      aParams.ExStyle := aParams.ExStyle Or WS_EX_APPWINDOW;
End;

Destructor TFormDownloader.Destroy;
Begin
   bkGndWorker.Cancel;
   bkGndWorker.WaitFor;

   Inherited;
End;

Procedure TFormDownloader.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
   CanClose := Not bkGndWorker.IsWorking;
End;

Procedure TFormDownloader.FormCreate(Sender: TObject);
Begin
   FPaused := False;

   Caption := cDefaultCaption;
   lblTitle.Caption := cDefaultTitle;
   lblText.Caption := cDefaultText;
End;

Procedure TFormDownloader.lblTextClick(Sender: TObject);
Begin
   Clipboard.AsText := lblText.Caption;
End;

End.
