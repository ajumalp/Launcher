Program Launcher;

{ ---------------------------------------------------------- }
{ Developed by Muhammad Ajmal p }
{ ajumalp@gmail.com }
{ ---------------------------------------------------------- }

uses
  System.SysUtils,
  Vcl.Forms,
  Vcl.Menus,
  UnitMDIMain in 'UnitMDIMain.pas' {FormMDIMain},
  ESoft.Launcher.Application in 'ESoft.Launcher.Application.pas',
  ESoft.Launcher.UI.AppGroupEditor in 'ESoft.Launcher.UI.AppGroupEditor.pas' {FormAppGroupEditor},
  ESoft.Launcher.Parameter in 'ESoft.Launcher.Parameter.pas',
  ESoft.Launcher.UI.ParamEditor in 'ESoft.Launcher.UI.ParamEditor.pas' {FormParamEditor},
  ESoft.Launcher.UI.ParamBrowser in 'ESoft.Launcher.UI.ParamBrowser.pas' {FormParameterBrowser},
  ESoft.Utils in 'ESoft.Utils.pas',
  ESoft.Launcher.UI.BackupRestore in 'ESoft.Launcher.UI.BackupRestore.pas' {FormBackupRestore},
  ESoft.Launcher.RecentItems in 'ESoft.Launcher.RecentItems.pas',
  ESoft.Launcher.Clipboard in 'ESoft.Launcher.Clipboard.pas',
  ESoft.Launcher.UI.ClipboardBrowser in 'ESoft.Launcher.UI.ClipboardBrowser.pas' {FormClipboardBrowser},
  ESoft.UI.Downloader in 'ESoft.UI.Downloader.pas' {FormDownloader},
  ESoft.Launcher.PopupList in 'ESoft.Launcher.PopupList.pas',
  ESoft.Launcher.UI.ErrorViewer in 'ESoft.Launcher.UI.ErrorViewer.pas' {FormExceptionHandler},
  ESoft.Launcher.FavouriteItems in 'ESoft.Launcher.FavouriteItems.pas';

{$R *.res}

Begin
   ReportMemoryLeaksOnShutdown := DebugHook <> 0;

   FreeAndNil(PopupList);
   PopupList := TExPopupList.Create;
   // Note: will be freed by Finalization section of Menus unit { Ajmal }

   Application.Initialize;
   Application.MainFormOnTaskbar := True;
   Application.Title := 'Launcher';
   Application.CreateForm(TFormMDIMain, FormMDIMain);
   Application.Run;
End.
