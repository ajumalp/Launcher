unit ESoft.Launcher.PopupList;

Interface

Uses
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Winapi.Messages,
   System.Classes,
   System.StrUtils,
   Vcl.Menus;

Const
   CM_MENUCLOSED    = CM_BASE - 1;
   CM_ENTERMENULOOP = CM_BASE - 2;
   CM_EXITMENULOOP  = CM_BASE - 3;   

Type
   TExPopupList = Class(TPopupList)
   Protected
      procedure WndProc(var aMessage: TMessage); override;
   End;

Implementation

{ TExPopupList }

procedure TExPopupList.WndProc(var aMessage: TMessage);

   Procedure _Send(aMsg: Integer);
   Begin
      If Assigned(Screen.Activeform) Then
         Screen.ActiveForm.Perform(aMsg, aMessage.WParam, aMessage.LParam);
   End;
  
Begin
   Case aMessage.Msg Of
      WM_ENTERMENULOOP: _Send(CM_ENTERMENULOOP);
      WM_EXITMENULOOP: _Send(CM_EXITMENULOOP);
      WM_MENUSELECT:
      Begin
         With TWMMenuSelect(aMessage) Do
         Begin
            If (Menuflag = $FFFF) and (Menu = 0) Then
               _Send(CM_MENUCLOSED);
         End;
      End;
   End;
   
   Inherited;
End;

End.
