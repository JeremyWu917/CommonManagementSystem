unit uLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, StdCtrls, jpeg, ExtCtrls, DB, ADODB;

type
  TFrmLogin = class(TForm)
    lblLogin: TLabel;
    lblUserName: TLabel;
    lblPassCode: TLabel;
    lblURL: TLabel;
    edtUserName: TEdit;
    edtPassCode: TEdit;
    lblInfo: TLabel;
    btnLogin: TRzBitBtn;
    btnExit: TRzBitBtn;
    imgLogin: TImage;
    qryLogin: TADOQuery;
    procedure btnLoginClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtPassCodeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation
uses
  uMain, sysPublic;
{$R *.dfm}

procedure TFrmLogin.btnLoginClick(Sender: TObject);
begin
   // 检查录入完整性
  if (Trim(edtUserName.Text) = '') or (Trim(edtPassCode.Text) = '') then
  begin
    MessageDlg('用户名或者密码不能为空，请确认！', mtWarning, [mbOK], 0);
    edtUserName.SetFocus;
    Abort;
  end;
  // 开始登录
  with qryLogin do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'select * from sysUser t where UserName=:UserName and PassCode =:PassCode';
    Parameters.ParamByName('UserName').Value := Trim(edtUserName.Text);
    Parameters.ParamByName('PassCode').Value := GetMd5Str(Trim(edtPassCode.Text));
    Open;
    if FindFirst then
    begin
      sysUserName := FieldByName('UserName').AsString;
      sysGroupName := FieldByName('GroupName').AsString; ;
      sysWorkNO := FieldByName('WorkNO').AsString; ;
      sysRealName := FieldByName('RealName').AsString;
       // 刷新菜单权限
      ShowDxBarManagerMenu();
      // 更新状态栏信息
      MainFrm.statusPaneUser.Caption := '登录用户[' + sysUserName + '] 登陆组[' + sysGroupName + ']';
      FrmLogin.Tag := 1;
      FrmLogin.Close;
    end
    else
    begin
      MessageDlg('用户名或者密码不正确，请确认！', mtWarning, [mbOK], 0);
      edtUserName.SetFocus;
      Abort;
    end;
  end;

end;

procedure TFrmLogin.btnExitClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FrmLogin.Tag <> 1 then
    Application.Terminate;
end;

procedure TFrmLogin.edtPassCodeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnLogin.Click;
  end;

end;

end.

