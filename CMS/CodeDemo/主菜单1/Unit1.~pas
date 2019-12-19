unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses uMain;

{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     //窗口关闭时，从内存中移除窗口
  Action := caFree;
  Form1 := nil;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   //窗口创建时，在窗口菜单中加入窗口的菜单
  MainFrm.dxBarListWindows.Items.AddObject(Caption, Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    //窗口关闭时，在窗口菜单中移除窗口的菜单
  with MainFrm.dxBarListWindows.Items do
    Delete(IndexOfObject(Self));
end;

end.

