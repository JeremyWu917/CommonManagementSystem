unit SysPublic;

interface

uses
  Windows, Messages, SysUtils, Dialogs, Forms,
  Classes, Variants, StdCtrls, Db,
  Controls, WinSock, ShellApi, jpeg, graphics, TypInfo,
  ExtCtrls, ComObj, ComCtrls, IdSMTP, IdMessage,
  RzChkLst, ActnList, DBCtrls, RzTreeVw, RzGroupBar, DateUtils,
  StrUtils, Math, RzPanel, cxStyles, RzDBCmbo, RzDBBnEd,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit,
  cxDBData, cxTextEdit, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, Ora, MemDS, DBAccess, cxGridLevel, cxClasses, dxBar,
  cxControls, cxGridCustomView, cxGrid, cxDropDownEdit, cxGridBandedTableView, cxGridDBBandedTableView, cxGridExportLink, Clipbrd,
  IdBaseComponent, IdComponent, RzDBEdit, IdHash, IdHashMessageDigest,
  IdFTP, IdFTPCommon, nb30, CwMboxLib_TLB, TlHelp32, winspool, Registry,
  IdIPWatch, ADODB;
var
  sysMsgBuffer, //消息缓存
    sysWorkNO, //工号
    sysUserName, //用户名称
    sysGroupName, //登录组
    sysRealName, //用户姓名
    sysMac, //MAC地址
    sysIP, //IP地址
    sysDataXPath: string; //数据库地址
function GetMd5Str(ContenStr: string): string; //获取Md5码
procedure OpenForm(FormClass: TFormClass; var fm; AOwner: TComponent);
procedure ExecSQL(sSQL: string);
procedure SetParam(V_Qry: TADOQuery; V_Param: string);
procedure Openquery(Q: TADOQuery; V_Sql: string);
procedure ComboAdd(Sender: Tstrings; SQLStr: string);
procedure ShowDxBarManagerMenu();

function GetIPAddress(): Variant;
function SaveToExcel(GridMain: TcxGrid; FileName: string): string;
function GetSql(Ssql, V_Param: string): Variant;
function GetPosName(sName: string): string;

implementation
uses uMain;

procedure OpenForm(FormClass: TFormClass; var fm; AOwner: TComponent);
{根据传递过来的参数，打开相应的窗体}
var
  i: integer;
  Child: TForm;
begin
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].ClassType = FormClass then
    begin
            {检查窗体是否已经打开，如果没有打开，打开它，
            如果已经打开，让它正常显示即可}
      Child := Screen.Forms[i];
      if Child.WindowState = wsMinimized then
        ShowWindow(Child.handle, SW_SHOWNORMAL)
      else
        ShowWindow(Child.handle, SW_SHOWNA);
      if (not Child.Visible) then Child.Visible := True;
      Child.BringToFront;
      Child.Setfocus;
      TForm(fm) := Child;
      exit;
    end;
  Child := TForm(FormClass.NewInstance);
  TForm(fm) := Child;
  Child.Create(AOwner);
end;

procedure SetParam(V_Qry: TADOQuery; V_Param: string);
var
  i: Integer;
  S: tstringlist;
begin
  s := tstringlist.Create;
  s.Clear;
  if v_Param <> '' then
  begin
    s.Text := stringreplace(v_Param, '[;]', '[KEY]', [rfReplaceAll]);
    s.Text := stringreplace(s.Text, ';', #13 + #10, [rfReplaceAll]);
    if S.Count > V_Qry.Fields.Count then
    begin
      ShowMessage('参数个数超过要求:' + V_Param + '[' + V_Qry.SQL.Text + ']');
      Abort;
    end;
    for i := 0 to s.Count - 1 do
    begin
      if (V_Qry.FieldDefList[i].Name = 'RQ1') or (V_Qry.FieldDefList[i].Name = 'RQ2') then
      begin
        V_Qry.FieldDefList[i].Name := s[i];
      end
      else
      begin
        V_Qry.FieldDefList[i].Name := stringreplace(s[i], '[KEY]', ';', [rfReplaceAll]);
      end;
    end;
  end;
end;

procedure OpenQuery(Q: TADOQuery; V_Sql: string);
begin
  Q.Close;
  Q.SQL.Text := V_Sql;
end;

procedure ComboAdd(Sender: Tstrings; SQLStr: string);
var
  i, r: Integer;
begin
  with MainFrm.qryTmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLStr);
    Open;
    First;
    R := RecordCount;
    for i := 1 to r do
    begin
      Sender.Add(Fields[0].AsString);
      Next;
    end;
    Close;
  end;
end;

procedure ExecSQL(sSQL: string);
begin
  MainFrm.qryTmp.Close;
  MainFrm.qryTmp.SQL.Text := sSQL;
  MainFrm.qryTmp.ExecSQL;
end;

function GetIPAddress(): Variant;
var
  IPAddress: TIdIPWatch;
  IPAdd_Buff: string;
begin
  IPAddress := TIdIPWatch.Create(nil);
  IPAdd_Buff := IPAddress.LocalIP;
  if IPAdd_Buff <> '' then
  begin
    Result := IPAdd_Buff;
  end
  else
  begin
    Result := '';
    ShowMessage('获取IP地址错误，请确认！');
    Abort;
  end;
end;

function SaveToExcel(GridMain: TcxGrid; FileName: string): string;
var
  SaveFileDialog: TSaveDialog;
begin
  SaveFileDialog := TSaveDialog.Create(nil);
  SaveFileDialog.FileName := FileName;
  SaveFileDialog.Filter := '*.xls';
  if SaveFileDialog.Execute then
  begin
    if pos('.XLS', UpperCase(SaveFileDialog.FileName)) <= 0 then
      SaveFileDialog.FileName := SaveFileDialog.FileName + '.XLS';
    ExportGridToExcel(SaveFileDialog.FileName, gridMain);
    ShowMessage('数据已成功导出到您指定的目录中');
  end;
  Result := SaveFileDialog.FileName;
  SaveFileDialog.Free;
end;

function GetSql(Ssql, V_Param: string): Variant;
var
  S: Tstringlist;
  I: Integer;
begin
  S := Tstringlist.Create;
  S.Clear;
  OpenQuery(MainFrm.qryTmp, Ssql);
  SetParam(MainFrm.qryTmp, V_Param);
  MainFrm.qryTmp.Open;
  if MainFrm.qryTmp.IsEmpty then
    Result := ''
  else
    Result := MainFrm.qryTmp.Fields[0].Value;
  if VarIsNull(result) then
  begin
    result := '';
  end;
  MainFrm.qryTmp.Close;
  MainFrm.qryTmp.Free;
end;

function GetPosName(sName: string): string;
var
  s: string;
begin
  s := Trim(sName);
  if pos('(', s) > 0 then
    s := copy(s, 0, pos('(', s) - 1);
  Result := s;
end;


//获取MD5码
//ContenStr：原码，返回MD5码

function GetMd5Str(ContenStr: string): string;
var
  RegMd5: TIdHashMessageDigest5;
  RegDigest: T4x4LongWordRecord;
begin
  RegMd5 := TIdHashMessageDigest5.Create;
  RegDigest := RegMd5.HashValue(ContenStr);
  Result := LowerCase(RegMd5.AsHex(RegDigest));
end;

//刷线主界面菜单权限

procedure ShowDxBarManagerMenu();
var
  dxBar: TdxBarManager;
  i, l, lIndex: integer;
  sCap, sSql, m_menu_group, m_menu: string;
begin
  with MainFrm.qryTmp do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'select a.GroupName, b.MenuName, a.UserName from sysUser a, sysUserAuthority b where a.GroupName = b.GroupName and a.UserName=:UserName and b.SystemName=:SystemName';
    Parameters.ParamByName('UserName').Value := sysUserName;
    Parameters.ParamByName('SystemName').Value := 'CMS';

    Open;
    dxBar := MainFrm.dxBarManagerMain;
    for i := 1 to dxBar.Categories.Count - 2 do
    begin
      m_menu_group := dxBar.Categories.Strings[i];
      for l := 0 to dxBar.ItemCount - 1 do
      begin
        if dxBar.Items[l] is TdxBarButton then
        begin
          if dxBar.Items[l].Category = i then
          begin
            sCap := dxBar.Items[l].Caption;
            lIndex := dxBar.Items[l].Index;
            m_menu := sCap;
            if Locate('MenuName', sCap, []) then
              dxBar.Items[l].Enabled := true
            else
              dxBar.Items[l].Enabled := false;
          end;
        end;
      end;
    end;
  end;

end;

end.

