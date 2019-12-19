unit uUserSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sCalculator, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxTextEdit, cxDropDownEdit,
  ADODB, Ora, ComCtrls, RzTreeVw, StdCtrls, RzCmboBx, RzLabel, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, Mask, RzEdit, RzRadChk, RzButton,
  ExtCtrls, RzPanel, RzTabs, cxCalendar, cxCheckBox, dxBar;

type
  TFrmUserSet = class(TForm)
    pageControlMain: TRzPageControl;
    tabSheetUserSet: TRzTabSheet;
    groupBoxParams: TRzGroupBox;
    btnRefresh: TRzBitBtn;
    btnAdd: TRzBitBtn;
    btnSave: TRzBitBtn;
    btnDelete: TRzBitBtn;
    checkBoxUserName: TRzCheckBox;
    edtUserName: TRzEdit;
    btnDodify: TRzBitBtn;
    cxGridMain: TcxGrid;
    cxGridMainDBTableView1: TcxGridDBTableView;
    cxGridMainLevel1: TcxGridLevel;
    tabSheetAuthSet: TRzTabSheet;
    groupBoxParamsA: TRzGroupBox;
    labGroupName: TRzLabel;
    lblNewGroupName: TRzLabel;
    cbbGroupName: TRzComboBox;
    btnSaveA: TRzBitBtn;
    btnDeleteA: TRzBitBtn;
    edtNewGroupName: TRzEdit;
    btnAddA: TRzBitBtn;
    checkTreeMain: TRzCheckTree;
    qryTmp: TADOQuery;
    qryUser: TADOQuery;
    dsUser: TDataSource;
    qryUserAuthority: TADOQuery;
    cxGridMainDBTableView1Column1: TcxGridDBColumn;
    cxGridMainDBTableView1Column2: TcxGridDBColumn;
    cxGridMainDBTableView1Column3: TcxGridDBColumn;
    cxGridMainDBTableView1Column4: TcxGridDBColumn;
    cxGridMainDBTableView1Column5: TcxGridDBColumn;
    cxGridMainDBTableView1Column6: TcxGridDBColumn;
    cxGridMainDBTableView1Column7: TcxGridDBColumn;
    procedure btnRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnDodifyClick(Sender: TObject);
    procedure LoadMenu(dxBar: TdxBarManager);
    procedure cbbGroupNameClick(Sender: TObject);
    procedure btnSaveAClick(Sender: TObject);
    procedure btnDeleteAClick(Sender: TObject);
    procedure btnAddAClick(Sender: TObject);
    procedure qryUserBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUserSet: TFrmUserSet;

implementation
uses
  uMain, sysPublic;
{$R *.dfm}

procedure TFrmUserSet.LoadMenu(dxBar: TdxBarManager);
var
  I, L: integer;
  Tnode: TTreenode;
begin
  with checkTreeMain.Items do
  begin
    Clear;
    for i := 0 to dxBar.Categories.Count - 1 do
    begin
      Tnode := AddChild(nil, GetPosName(dxBar.Categories.Strings[i]));
      for l := 0 to dxBar.ItemCount - 1 do
        if dxBar.Items[l] is TdxBarButton then
          if dxBar.Items[l].Category = i then
          begin
            AddChild(Tnode, GetPosName(dxBar.Items[l].Caption));
          end;
    end;
  end;
  with qryTmp do
  begin
    Close;
    SQL.Text := 'select MenuName from sysUserAuthority where SystemName=''CMS'' and GroupName=:GroupName';
    Parameters.ParamByName('GroupName').Value := cbbGroupName.Text;
    Open;
    for i := 0 to checkTreeMain.Items.Count - 1 do
      if checkTreeMain.Items[i].Level > 0 then
        if Locate('MenuName', checkTreeMain.Items[i].Text, []) then
          checkTreeMain.ItemState[i] := csChecked;
    Close;
  end;
end;

procedure TFrmUserSet.btnRefreshClick(Sender: TObject);
begin
  if not checkBoxUserName.Checked then
  begin
    with qryUser do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'select * from sysUser t';
      Open;
    end;
  end
  else
  begin
    with qryUser do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'select * from sysUser t where t.UserName =''' + edtUserName.text + '''  or t.WorkNO =''' + edtUserName.text + '''';
      Open;
    end;
  end;
  btnDodify.Enabled := True;
end;

procedure TFrmUserSet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    //���ڹر�ʱ�����ڴ����Ƴ�����
  Action := caFree;
  FrmUserSet := nil;
end;

procedure TFrmUserSet.FormDestroy(Sender: TObject);
begin
  //���ڹر�ʱ���ڴ��ڲ˵����Ƴ����ڵĲ˵�
  with MainFrm.dxBarListWindows.Items do
    Delete(IndexOfObject(Self));
end;

procedure TFrmUserSet.FormCreate(Sender: TObject);
begin
    //���ڴ���ʱ���ڴ��ڲ˵��м��봰�ڵĲ˵�
  MainFrm.dxBarListWindows.Items.AddObject(Caption, Self);
  cbbGroupName.Items.Clear;
  ComboAdd(cbbGroupName.Items, 'select distinct GroupName from sysUserAuthority where SystemName=''CMS'' order by GroupName');
  TcxComboBoxProperties(cxGridMainDBTableView1Column4.Properties).Items.Text := cbbGroupName.Items.Text;
  cbbGroupName.ItemIndex := 0;
  cbbGroupName.OnClick(Self);
end;

procedure TFrmUserSet.btnAddClick(Sender: TObject);
begin
  qryUser.Append;
  btnSave.Enabled := True;
end;

procedure TFrmUserSet.btnSaveClick(Sender: TObject);
begin
  qryUser.Post;
  btnSave.Enabled := False;
  MessageDlg('����ɹ�,�벻Ҫ�ظ�������', mtInformation, [mbOK], 0);
end;

procedure TFrmUserSet.btnDeleteClick(Sender: TObject);
begin
  case MessageDlg('ɾ�����޷��ָ�����ȷ��Ҫ����ɾ����', mtWarning, [mbYes,
    mbNo], 0) of
    mrYes:
      begin
        qryUser.Delete;
        btnSave.Enabled := False;
        MessageDlg('ɾ���ɹ�,�벻Ҫ�ظ�������', mtInformation, [mbOK], 0);
      end;
    mrNo:
      begin
        Exit;
      end;
  end;
end;

procedure TFrmUserSet.btnDodifyClick(Sender: TObject);
begin
  btnSave.Enabled := True;
  btnDelete.Enabled := True;
  qryUser.Edit;
end;

procedure TFrmUserSet.cbbGroupNameClick(Sender: TObject);
begin
  LoadMenu(MainFrm.dxBarManagerMain);
end;

procedure TFrmUserSet.btnSaveAClick(Sender: TObject);
var
  I: Integer;
begin
  for i := 0 to checkTreeMain.Items.Count - 1 do
  begin
    if checkTreeMain.Items[i].Level > 0 then
      if checkTreeMain.ItemState[i] = csChecked then
      begin
        with qryTmp do
        begin
          Close;
          SQL.Clear;
          SQL.Text := 'SELECT * FROM sysUserAuthority WHERE GROUPNAME =:GROUPNAME AND MENUNAME =:MENUNAME';
          Parameters.ParamByName('GROUPNAME').Value := cbbGroupName.Text;
          Parameters.ParamByName('MENUNAME').Value := checkTreeMain.Items.Item[i].Text;
          Open;
          if RecordCount = 0 then
          begin
            qryUserAuthority.Close;
            qryUserAuthority.SQL.Clear;
            qryUserAuthority.SQL.Text := 'INSERT INTO sysUserAuthority(GROUPNAME, MENUNAME, SystemName) VALUES(:GROUPNAME, :MENUNAME, :SystemName)';
            qryUserAuthority.Parameters.ParamByName('GROUPNAME').Value := cbbGroupName.Text;
            qryUserAuthority.Parameters.ParamByName('MENUNAME').Value := checkTreeMain.Items.Item[i].Text;
            qryUserAuthority.Parameters.ParamByName('SystemName').Value := 'CMS';
            qryUserAuthority.ExecSQL;
          end;
        end;
      end
      else
      begin
        ExecSql('DELETE FROM sysUserAuthority WHERE SystemName= ''CMS'' AND GROUPNAME=''' + cbbGroupName.Text + ''' AND MENUNAME=''' + checkTreeMain.Items.Item[i].Text + '''');
      end;
  end;
  TcxComboBoxProperties(cxGridMainDBTableView1Column4.Properties).Items.Text := cbbGroupName.Items.Text;
  ShowMessage('����ɹ���');
end;

procedure TFrmUserSet.btnDeleteAClick(Sender: TObject);
begin
  if MessageDLG('��ȷ��Ҫɾ���÷���Ȩ����', mtconfirmation, [MBOK, MBCANCEL], 0) = MRCANCEL then exit;
  ExecSql('Delete from sysUserAuthority where SystemName=''' + Application.Title + ''' AND groupname=''' + cbbGroupName.Text + '''');
end;

procedure TFrmUserSet.btnAddAClick(Sender: TObject);
begin
  if edtNewGroupName.Text = '' then
  begin
    ShowMessage('������������!');
    exit;
  end;
  cbbGroupName.Items.Add(edtNewGroupName.Text);
  cbbGroupName.ItemIndex := cbbGroupName.Items.Count - 1;
  cbbGroupName.OnClick(self);
  ShowMessage('��ӳɹ���');
  edtNewGroupName.Text := '';
end;

procedure TFrmUserSet.qryUserBeforePost(DataSet: TDataSet);
begin
    if (Pos(' ', qryUser.FieldByName('UserName').AsString) > 0) or (Pos(' ', qryUser.FieldByName('PassCode').AsString) > 0) then
    begin
        ShowMessage('�û����������в����пո�����������');
        Abort;
    end;
    if (qryUser.State = dsInsert) or ((qryUser.State = dsEdit) and (Length(qryUser.FieldByName('PassCode').AsString) < 20)) then
    begin
        qryUser.FieldByName('PassCode').AsString := GetMd5Str(qryUser.FieldByName('PassCode').AsString);
    end;
end;

end.

