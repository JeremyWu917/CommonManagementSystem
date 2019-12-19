unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm4 = class(TForm)
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
  Form4: TForm4;

implementation

uses uMain;

{$R *.dfm}

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
            //���ڹر�ʱ�����ڴ����Ƴ�����
  Action := caFree;
  Form4 := nil;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
        //���ڴ���ʱ���ڴ��ڲ˵��м��봰�ڵĲ˵�
  MainFrm.dxBarListWindows.Items.AddObject(Caption, Self);
end;

procedure TForm4.FormDestroy(Sender: TObject);
begin
         //���ڹر�ʱ���ڴ��ڲ˵����Ƴ����ڵĲ˵�
  with MainFrm.dxBarListWindows.Items do
    Delete(IndexOfObject(Self));
end;

end.

