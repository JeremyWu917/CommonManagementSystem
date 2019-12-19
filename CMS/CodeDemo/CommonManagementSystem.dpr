program CommonManagementSystem;

uses
  Forms,
  uMain in 'uMain.pas' {MainFrm},
  uLogin in '系统登录\uLogin.pas' {FrmLogin},
  sysPublic in '系统通用模块\sysPublic.pas',
  uUserSet in '系统设置\uUserSet.pas' {FrmUserSet},
  uMDIChildTes in '菜单窗体\uMDIChildTes.pas' {FrmMDIChildTest},
  Unit1 in '主菜单1\Unit1.pas' {Form1},
  Unit2 in '主菜单1\Unit2.pas' {Form2},
  Unit3 in '主菜单2\Unit3.pas' {Form3},
  Unit4 in '主菜单2\Unit4.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'CMS';
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
