unit ESoft.Launcher.UI.ErrorViewer;

{ ---------- Developed by Muhammad Ajmal P ---------- }
{ ---------- ajumalp@gmail.com --------------------- }

Interface

uses
  SysUtils,
  Forms,
  StdCtrls,
  Classes,
  Controls,
  ExtCtrls,
  Graphics,
  Buttons,
  ActnList,
  ExtActns,
  StdActns,
  ShellApi;

type
  TFormExceptionHandler = class(TForm)
    Bevel1: TPanel;
    btnOK: TButton;
    btnDetails: TButton;
    memTechnical: TMemo;
    btnPrint: TButton;
    lblBuildNumber: TLabel;
    edtBuildNumber: TEdit;
    lblBottomRightOne: TLabel;
    lblBottomRightTwo: TLabel;
    btnTerminate: TButton;
    btnEmail: TButton;
    Image1: TImage;
    memUser: TMemo;
    btnCopyStackTrace: TSpeedButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCopyStackTraceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEmailClick(Sender: TObject);
    procedure btnTerminateClick(Sender: TObject);
  private
    procedure AppException(aSender: TObject; aExcept: Exception);
  end;

implementation

{$R *.DFM}

uses
  Windows,
  Dialogs,
  Clipbrd, { Clipboard object }
  JclDebug,
  Variants,
  UnitMDIMain;

const
  cDetailsLALA = '&Details <<';
  cDetailsRARA = '&Details >>';

 var
  _varErrorFrame: TFormExceptionHandler;

{ TfrmError }

procedure TFormExceptionHandler.btnOKClick(Sender: TObject);
begin
  try
    ModalResult := mrOk;
    Screen.Cursor := crDefault;
    memTechnical.Lines.Clear;
  except on E:Exception do
    MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFormExceptionHandler.btnDetailsClick(Sender: TObject);
begin
  try
    if Height < lblBottomRightOne.Top + 60 then
    begin
      Height := lblBottomRightTwo.Top + lblBottomRightTwo.Height + 29;
      btnDetails.Caption := cDetailsLALA;
    end
    else
    begin
      Height := lblBottomRightOne.Top + lblBottomRightOne.Height + 29;
      btnDetails.Caption := cDetailsRARA;
    end;
    btnOK.SetFocus;
  except
    ; { purposefully ignore any errors in the error handler }
  end;
end;

procedure TFormExceptionHandler.btnEmailClick(Sender: TObject);
Const
  cExceptionReportLink = 'mailto:ajumalp@gmail.com?subject=Laucnher%20Exception%20Report';
begin
  if MessageDlg('Do you want to copy error message to clipboard ?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    btnCopyStackTrace.Click;
  ShellExecute(Handle, 'open', cExceptionReportLink, '', '', SW_HIDE);
  ModalResult := mrClose;
end;

procedure TFormExceptionHandler.btnPrintClick(Sender: TObject);
begin
  try
    Print;
    btnOK.SetFocus;
  except
    ; { purposefully ignore any errors in the error handler }
  end;
end;

procedure TFormExceptionHandler.btnTerminateClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormExceptionHandler.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    Height := lblBottomRightOne.Top + lblBottomRightOne.Height + 29;
    btnDetails.Caption := cDetailsRARA;
  except
    ; { purposefully ignore any errors in the error handler }
  end;
end;

procedure TFormExceptionHandler.btnCopyStackTraceClick(Sender: TObject);
begin
  Clipboard.AsText := memTechnical.Lines.Text;
end;

procedure TFormExceptionHandler.FormCreate(Sender: TObject);
begin
  Application.OnException := AppException;
end;

procedure TFormExceptionHandler.AppException(aSender: TObject; aExcept: Exception);
var
  bFormShowing: Boolean;
begin
  edtBuildNumber.Text := cAppVersion;
  memTechnical.Lines.Clear;
  memTechnical.Lines.Add(aExcept.Message);
  if Assigned(aSender) then
    memTechnical.Lines.Add('Exception from class: ' + aSender.ClassName);
  memTechnical.Lines.Add('Launcher Version: ' + edtBuildNumber.Text);
  memTechnical.Lines.Add('');

  JclLastExceptStackListToStrings(memTechnical.Lines, False, True, True);

  bFormShowing := FormMDIMain.Visible;
  FormMDIMain.Show;
  _varErrorFrame.ShowModal;
  FormMDIMain.Visible := bFormShowing;
end;

initialization
  _varErrorFrame := TFormExceptionHandler.Create(Application);
  JclStackTrackingOptions := JclStackTrackingOptions + [stRawMode, stStaticModuleList];
  JclStartExceptionTracking;

finalization
  // Don't free _varErrorFrame. Application will free this. { Ajmal }
  // FreeAndNil(_varErrorFrame);
  JclStopExceptionTracking;

end.
