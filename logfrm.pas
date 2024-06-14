unit logfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type

  TfrmLog = class(TForm)
    pnl: TPanel;
    btnClear: TButton;
    btnClose: TButton;
    mm: TMemo;
    procedure DoClearClick(ASender: TObject);
    procedure DoCloseClick(ASender: TObject);
    procedure DoFormClose(ASender: TObject; var AAction: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Add(const ALogLine: string);
  end;


implementation

{$R *.dfm}

{ Tfrmlog }

procedure TfrmLog.Add(const ALogLine: string);
begin
mm.Lines.Add(ALogLine);
btnClear.Enabled := true;
end;

constructor TfrmLog.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
btnClear.Enabled := false;
end;

procedure TfrmLog.DoClearClick(ASender: TObject);
begin
mm.Lines.Clear;
btnClear.Enabled := false;
end;

procedure TfrmLog.DoCloseClick(ASender: TObject);
begin
Close;
end;

procedure TfrmLog.DoFormClose(ASender: TObject; var AAction: TCloseAction);
begin
AAction := caHide;
end;

end.
