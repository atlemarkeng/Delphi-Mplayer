program mzplayer;

uses
  Forms,
  mainfrm in 'mainfrm.pas' {frmMain},
  About in 'About.pas' {frmAbout},
  propfrm in 'propfrm.pas' {frmProp},
  logfrm in 'logfrm.pas' {frmLog},
  mplayer_lib in 'mplayer_lib.pas',
  mtyps in 'mtyps.pas' {typFrm},
  munits in 'munits.pas' {unitFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'mzplayer';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TtypFrm, typFrm);
  Application.CreateForm(TunitFrm, unitFrm);
  Application.Run;
end.
