unit propfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type

  TfrmProp = class(TForm)
    lstv: TListView;
    pnl: TPanel;
    btnClose: TButton;
    procedure DoCloseClick(ASender: TObject);
    procedure DoFormClose(ASender: TObject; var AAction: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateProps(AMediaPropList: TObject); virtual;
  end;

implementation

uses mplayer_lib;

{$R *.dfm}

{ TfrmProp }

procedure TfrmProp.DoCloseClick(ASender: TObject);
begin
Close;
end;

procedure TfrmProp.DoFormClose(ASender: TObject; var AAction: TCloseAction);
begin
AAction := caHide;
end;

procedure TfrmProp.UpdateProps(AMediaPropList: TObject);
var
   PropList: TMediaPropList;
   T, I: integer;
   ListItem: TListItem;
begin
lstv.Clear;
if not Assigned(AMediaPropList) then Exit;
if not(AMediaPropList is TMediaPropList) then Exit;
PropList := AMediaPropList as TMediaPropList;

T := PropList.Count - 1;
for I := 0 to T do
   begin
   ListItem := lstv.Items.Add;
   ListItem.Caption := PropList.PropLabels[I];
   ListItem.SubItems.Add(PropList.PropValues[I]);
   end;
end;

end.
