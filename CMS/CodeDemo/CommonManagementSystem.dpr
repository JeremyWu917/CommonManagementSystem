program CommonManagementSystem;

uses
  Forms,
  uMain in 'uMain.pas' {MainFrm},
  uLogin in 'ϵͳ��¼\uLogin.pas' {FrmLogin},
  sysPublic in 'ϵͳͨ��ģ��\sysPublic.pas',
  uUserSet in 'ϵͳ����\uUserSet.pas' {FrmUserSet},
  uMDIChildTes in '�˵�����\uMDIChildTes.pas' {FrmMDIChildTest},
  Unit1 in '���˵�1\Unit1.pas' {Form1},
  Unit2 in '���˵�1\Unit2.pas' {Form2},
  Unit3 in '���˵�2\Unit3.pas' {Form3},
  Unit4 in '���˵�2\Unit4.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'CMS';
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
