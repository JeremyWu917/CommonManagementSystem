unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ExtCtrls, RzPanel, RzStatus, RzPrgres, dxBar,
  cxClasses, ActnList, ImgList;

type
  TMainFrm = class(TForm)
    conMain: TADOConnection;
    statusBarMain: TRzStatusBar;
    statusPaneAccess: TRzStatusPane;
    marqueeStatusMain: TRzMarqueeStatus;
    statusPaneUser: TRzStatusPane;
    progressBarMain: TRzProgressBar;
    statusPaneMain: TRzStatusPane;
    RzClockStatus1: TRzClockStatus;
    dxBarManagerMain: TdxBarManager;
    dxBarManagerMainBar1: TdxBar;
    dxBarManagerMainBar2: TdxBar;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarListWindows: TdxBarListItem;
    qryTmp: TADOQuery;
    actionListMain: TActionList;
    imageListMain: TImageList;
    dxBarSubItem3: TdxBarSubItem;
    dxBarSubItem4: TdxBarSubItem;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    procedure FormShow(Sender: TObject);
    procedure dxBarButton1Click(Sender: TObject);
    procedure dxBarListWindowsClick(Sender: TObject);
    procedure dxBarListWindowsGetData(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

implementation

uses uLogin, uUserSet, sysPublic, uMDIChildTes, Unit1, Unit2, Unit3, Unit4;

{$R *.dfm}

procedure TMainFrm.FormShow(Sender: TObject);
begin
  // ��̬����Access���ݿ�
  try
    Screen.Cursor := crSQLWait;
    ChDir(ExtractFilePath(Application.ExeName));
    ChDir('..');
    try //��̬�������ݿ�
      conMain.Connected := False;
      conMain.ConnectionString := 'Provider=Microsoft.Jet.OlEDB.4.0;Data Source=' + GetCurrentDir + '\DataX\DataX.mdb' + ';User ID=admin;Password=;Persist security Info=False';
      conMain.Connected := True;
      conMain.LoginPrompt := False;
      statusPaneAccess.Caption := '���ݿ�������';
      Screen.Cursor := crDefault;
    except
      Screen.Cursor := crDefault;
      statusPaneAccess.Caption := '���ݿ�δ����';
      MessageDlg('���ݿ�����ʧ�ܣ���ȷ�ϣ�', mtError, [mbOK], 0);
    end;
    Screen.Cursor := crDefault;
  except
    statusPaneAccess.Caption := '���ݿ�δ����';
    MessageDlg('���ݿ�����ʧ�ܣ���ȷ�ϣ�', mtError, [mbOK], 0);
  end;

  // ϵͳ��¼
  if not assigned(FrmLogin) then
    FrmLogin := TFrmLogin.create(Application);
  FrmLogin.ShowModal;
end;

procedure TMainFrm.dxBarButton1Click(Sender: TObject);
var
  T_StrMenu: string;
begin
  T_StrMenu := TAction(Sender).Name;
  if (T_StrMenu = 'dxBarButton1') then //ϵͳ����
  begin
    OpenForm(TFrmUserSet, FrmUserSet, Self);
    Abort;
  end;
  if (T_StrMenu = 'dxBarButton2') then //����
  begin
    OpenForm(TFrmMDIChildTest, FrmMDIChildTest, Self);
    Abort;
  end;
  if (T_StrMenu = 'dxBarButton6') then //���Դ���1-1
  begin
    OpenForm(TForm1, FrmMDIChildTest, Self);
    Abort;
  end;
  if (T_StrMenu = 'dxBarButton7') then //���Դ���1-2
  begin
    OpenForm(TForm2, FrmMDIChildTest, Self);
    Abort;
  end;
  if (T_StrMenu = 'dxBarButton8') then //���Դ���2-1
  begin
    OpenForm(TForm3, FrmMDIChildTest, Self);
    Abort;
  end;
  if (T_StrMenu = 'dxBarButton9') then //���Դ���2-2
  begin
    OpenForm(TForm4, FrmMDIChildTest, Self);
    Abort;
  end;
  if (T_StrMenu = 'dxBarButton3') then //ƽ��
  begin
    TileMode := tbHorizontal; //MDI�Ӵ���ˮƽ���У�ƽ�̡������
    Tile;
    Abort;
  end;
  if (T_StrMenu = 'dxBarButton4') then //���
  begin
    TileMode := tbHorizontal; //MDI�Ӵ���ˮƽ���У�ƽ�̡������
    Cascade;
    Abort;
  end;
  if (T_StrMenu = 'dxBarButton5') then //��ֱ
  begin
    TileMode := tbVertical; //MDI�Ӵ��崹ֱ����
    Tile;
    Abort;
  end;
end;

procedure TMainFrm.dxBarListWindowsClick(Sender: TObject);
begin
  with dxBarListWindows do
    TCustomForm(Items.Objects[ItemIndex]).Show;
end;

procedure TMainFrm.dxBarListWindowsGetData(Sender: TObject);
begin
  with dxBarListWindows do
    ItemIndex := Items.IndexOfObject(ActiveMDIChild);
end;

procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  if MessageDlg(' ȷ���˳���ϵͳ��', mtconfirmation, [mbyes, mbno], 0) = mryes then
  begin
    for i := MDIChildCount - 1 downto 0 do
    begin
      MDIChildren[i].Close;
    end;
    Application.Terminate
  end
  else
    Action := caNone;
end;

end.

