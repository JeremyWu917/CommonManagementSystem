unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
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
  Form3: TForm3;

implementation

uses uMain;

{$R *.dfm}

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        //���ڹر�ʱ�����ڴ����Ƴ�����
  Action := caFree;
  Form3 := nil;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
      //���ڴ���ʱ���ڴ��ڲ˵��м��봰�ڵĲ˵�
  MainFrm.dxBarListWindows.Items.AddObject(Caption, Self);
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
       //���ڹر�ʱ���ڴ��ڲ˵����Ƴ����ڵĲ˵�
  with MainFrm.dxBarListWindows.Items do
    Delete(IndexOfObject(Self));
end;

end.
