unit mainfrm;

interface

uses
  mtyps,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mplayer_lib, StdCtrls, ExtCtrls, Menus, ActnList, ActnMan,
  Buttons, ToolWin, ActnCtrls, ComCtrls, ActnMenus, ImgList, BandActn,
  XPStyleActnCtrls, LMDControl, LMDBaseControl, LMDBaseGraphicControl,
  LMDGraphicControl, LMDClock,
  iniFiles, LMDLEDCustomLabel, LMDLEDLabel, ThdTimer, JvExControls,
  JvButton, JvTransparentButton, jpeg, LMDCustomControl, LMDCustomPanel,
  LMDCustomBevelPanel, LMDBaseEdit, LMDCustomEdit, LMDEdit;

const
 PRG_NAME ='MediaPlayer';

 TC_DATA_DIR ='C:\XNRK';
 TC_FILE_WRITE ='TC_mdb.txt';
 TC_FILE_READ ='TC_mp.txt';
 TC_IN_FNAME ='TCinn';
 TC_OUT_FNAME ='TCut';
 TC_CLIP_NAME ='ClipName';

 INI_FILE_NAME ='mzplayer.ini';
 INI_SECT ='MPLAYER';
 TC_CLOCK_DELAY =0.75;
 //PREROLL_FRAMES =150;
 PREROLL_SEC =3;
 MAX_POS_DIF   =12;  //Max avvik i s�k for � melde 'Cue feil'
 MAX_POS_DIF_RECUE =8; //Max avvik for nytt s�k
 MAX_RECUE_CNT =2; //antall s�kefors�k
 MAX_FRAMES_OFF =4; //Maks ruteun�yaktighet f�r melding

 CUE_ENTRY =1;
 CUE_EXIT =2;

 CORR_INTERVAL_CUE =750; //ms f�r start av korreksjon
 CORR_INTERVAL_RECUE =500; //ms f�r start av neste korreksjon

 //PB_OFFSET_FRAMES =0;  //Korreksjon i forhold til generelt TC avvik mot Programbank

 FRAME_OFFSET =0; //7; //pga. forsinkelse mot mplayer

 M_PARAM_WMV ='-aid 2 -af channels=2 -stereo 0';

 ID_AUDIO_TRAC_0   = '-aid 0';
 ID_AUDIO_TRAC_1   = '-aid 1';
 ID_AUDIO_TRAC_2   = '-aid 2';

 ID_PARAM_AUDIO ='AUDIO_ID';
 ID_PARAM_MEDIA_START ='START_TIME';

type

  TMZTrackBar = class(TTrackBar)
  published
    property OnMouseUp;
  end;

  TMZTrackType = (mttPosition, mttAudioDelay, mttVolume, mttSpeed,
                  mttBrightness, mttContrast, mttSaturation);

  TfrmMain = class(TForm)
    pnlPlayer: TPanel;
    ActionManager: TActionManager;
    ctnPause: TAction;
    ctnPlay: TAction;
    ctnFileOpen: TAction;
    ctnStop: TAction;
    ctnBack01: TAction;
    ctnForward01: TAction;
    ctnBack10: TAction;
    ctnForward10: TAction;
    ctnFramStep: TAction;
    ctnSpeedDec: TAction;
    ctnSpeedInc: TAction;
    ctnSpeedDef: TAction;
    ctnOsdToogle: TAction;
    ctnFrameDropToogle: TAction;
    ActionMainMenuBar: TActionMainMenuBar;
    ctnClose: TAction;
    ctnBack60: TAction;
    ctnForward60: TAction;
    ctnProperties: TAction;
    ctnLogPlayer: TAction;
    sts: TStatusBar;
    ctnAspectAutodetect: TAction;
    ctnAspect40_30: TAction;
    ctnAspect160_90: TAction;
    ctnAspect235_10: TAction;
    ctnAudioOutNoSound: TAction;
    ctnAudioOutNull: TAction;
    ctnAudioOutWin32: TAction;
    ctnAudioOutDsSound: TAction;
    ctnReIndex: TAction;
    ctnParams: TAction;
    ctnNativeSize: TAction;
    ctnHaveVideo: TAction;
    ctnHaveAudio: TAction;
    ctnMute: TAction;
    pppTrackBar: TPopupMenu;
    miPosition: TMenuItem;
    miSpeed: TMenuItem;
    miVolume: TMenuItem;
    miBrightness: TMenuItem;
    miContrast: TMenuItem;
    miSaturation: TMenuItem;
    ctnResetColor: TAction;
    miAudioDelay: TMenuItem;
    ctnFullScreen: TAction;
    ImageList: TImageList;
    ctnCustomizeActionBars: TCustomizeActionBars;
    ctnAbout: TAction;
    FMPlayer: TMPlayer;
    pnlSlider: TPanel;
    correctionTimer: TTimer;
    frameTimer: TThreadedTimer;
    actStep: TAction;
    paramTimer: TTimer;
    ctnAudioTrack: TAction;
    ctnScreenshot: TAction;
    TCfileTimer: TTimer;
    tcMem: TMemo;
    pnlBtns: TPanel;
    imgVTRbtns1: TImage;
    pnlBottom: TPanel;
    btnVTRplay: TJvTransparentButton;
    btnVTRrew: TJvTransparentButton;
    btnVTRfwd: TJvTransparentButton;
    btnVTRstop: TJvTransparentButton;
    btnVTRrec: TJvTransparentButton;
    btnVTRedit: TJvTransparentButton;
    btnVTRpreroll: TJvTransparentButton;
    btnVTRstandby: TJvTransparentButton;
    btnVTReject: TJvTransparentButton;
    imageListVTR: TImageList;
    imgBtnPause: TImage;
    imgBtnStop: TImage;
    pnlRecInhibit: TPanel;
    pnlCue: TPanel;
    imgVTRbtns2: TImage;
    btnSetTCinn: TJvTransparentButton;
    btnSetTCut: TJvTransparentButton;
    btnVTRstepFrameRew: TJvTransparentButton;
    btnVTRstepFrameFwd: TJvTransparentButton;
    btnVTRshuttle: TJvTransparentButton;
    btnVTRjog: TJvTransparentButton;
    btnVTRvar: TJvTransparentButton;
    upDnRewind: TUpDown;
    TCinn: TEdit;
    TCut: TEdit;
    imgVTRbkg: TImage;
    TCclock: TLMDClock;
    frameSpace: TLMDLEDLabel;
    frameLED: TLMDLEDLabel;
    btnGotoTCin: TJvTransparentButton;
    btnGotoTCut: TJvTransparentButton;
    Preroll: TLabel;
    btnFileProperty: TJvTransparentButton;
    ActionToolBar: TActionToolBar;
    btnTest: TSpeedButton;
    btnFullScreen: TSpeedButton;
    btnGetAudioProp: TSpeedButton;
    txtCue: TLabel;
    seekTimer: TTimer;
    keyTimer: TTimer;
    trimTCinn: TUpDown;
    trimTCut: TUpDown;
    playerTimer: TTimer;
    pnlServo: TPanel;
    procedure DoActionManagerUpdate(AAction: TBasicAction; var AHandled: Boolean);

    procedure DoFileOpen(ASender: TObject);
    procedure DoStop(ASender: TObject);
    procedure DoLogPlayer(ASender: TObject);
    procedure DoProperies(ASender: TObject);
    procedure Do_Close(ASender: TObject);

    procedure DoPlay(ASender: TObject);
    procedure DoPause(ASender: TObject);
    procedure DoFrameStep(ASender: TObject);
    procedure DoBack01(ASender: TObject);
    procedure DoBack10(ASender: TObject);
    procedure DoBack60(ASender: TObject);
    procedure DoForward01(ASender: TObject);
    procedure DoForward10(ASender: TObject);
    procedure DoForward60(ASender: TObject);
    procedure DoSpeedDec(ASender: TObject);
    procedure DoSpeedDef(ASender: TObject);
    procedure DoSpeedInc(ASender: TObject);
    procedure DoMuteToogle(ASender: TObject);
    procedure DoResetColor(ASender: TObject);

    procedure DoOsdToogle(ASender: TObject);
    procedure DoFrameDropToogle(ASender: TObject);
    procedure DoAspectAutodetect(ASender: TObject);
    procedure DoAspect40_30(ASender: TObject);
    procedure DoAspect160_90(ASender: TObject);
    procedure DoAspect235_10(ASender: TObject);
    procedure DoNativeSize(ASender: TObject);
    procedure DoFullScreen(ASender: TObject);
    procedure DoAudioOutNoSound(ASender: TObject);
    procedure DoAudioOutNull(ASender: TObject);
    procedure DoAudioOutWin32(ASender: TObject);
    procedure DoAudioOutDsSound(ASender: TObject);
    procedure DoReIndex(ASender: TObject);
    procedure DoParams(ASender: TObject);

    procedure DoTrackBarKeyUp(ASender: TObject; var AKey: Word; AShift: TShiftState);
    procedure DoTrackBarMouseUp(ASender: TObject; AButton: TMouseButton; AShift: TShiftState; AX, AY: integer);
    procedure DoTrackMenuItemClick(ASender: TObject);

    procedure DoAbout(ASender: TObject);
    procedure btnSetTCinnClick(Sender: TObject);
    procedure btnSetTCutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure timePosDblClick(Sender: TObject);
    procedure btnGetAudioPropClick(Sender: TObject);
    procedure btnGotoTCinnClick(Sender: TObject);
    procedure correctionTimerTimer(Sender: TObject);
    procedure frameTimerTimer(Sender: TObject);
    procedure frameLEDDblClick(Sender: TObject);
    procedure btnFrameStepClick(Sender: TObject);
    procedure btnStepFrameFwdClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pnlBottomClick(Sender: TObject);
    procedure paramTimerTimer(Sender: TObject);
    procedure btnScreenshotClick(Sender: TObject);
    procedure TCfileTimerTimer(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FMPlayerTimer(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure upDnRewindClick(Sender: TObject; Button: TUDBtnType);
    procedure btnStepFrameRewClick(Sender: TObject);
    procedure btnVTRplayClick(Sender: TObject);
    procedure btnVTRstopClick(Sender: TObject);
    procedure btnVTRtcInClick(Sender: TObject);
    procedure btnVTRtcOutClick(Sender: TObject);
    procedure btnVTRstepFrameRewClick(Sender: TObject);
    procedure btnVTRstepFrameFwdClick(Sender: TObject);
    procedure btnCueTCinClick(Sender: TObject);
    procedure btnGotoTCutClick(Sender: TObject);
    procedure btnVTRprerollClick(Sender: TObject);
    procedure btnVTRrewClick(Sender: TObject);
    procedure btnVTRfwdClick(Sender: TObject);
    procedure btnVTReditClick(Sender: TObject);
    procedure btnVTRrecClick(Sender: TObject);
    procedure btnFilePropertyClick(Sender: TObject);
    procedure imgBtnStopClick(Sender: TObject);
    procedure btnVTRejectClick(Sender: TObject);
    procedure TCinnChange(Sender: TObject);
    procedure TCutChange(Sender: TObject);
    procedure btnFullScreenClick(Sender: TObject);
    procedure btnVTRrewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnVTRrewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnVTRfwdMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnVTRfwdMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure keyTimerTimer(Sender: TObject);
    procedure seekTimerTimer(Sender: TObject);
    procedure TCinnKeyPress(Sender: TObject; var Key: Char);
    procedure btnVTRjogClick(Sender: TObject);
    procedure btnVTRvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure trimTCinnClick(Sender: TObject; Button: TUDBtnType);
    procedure trimTCutClick(Sender: TObject; Button: TUDBtnType);
    procedure playerTimerTimer(Sender: TObject);


  private
    { Private declarations }
    PRV_init: Boolean;

    PRV_media_filename: String;

    PRV_app_dir: String;
    PRV_work_dir: String;

    PUBints: ARFLDI;  //array med 32 Integer

    PRV_TC_data_dir: String;

    PRV_frame_offset: Integer;

    PRV_TC_clock: String;

    PRV_TC_offset: Integer;
    PRV_TC_frames: Integer;
    //PRV_TC_sec: Integer;

    PRV_TC_tot_frames: Integer;


    PRV_TC_last_frame: Integer;
    PRV_max_frames_off: Integer;

    PRV_TC_media_offset: Integer;

    PRV_TC_start_offset: Integer;

    PRV_seek_frms: Integer;
    PRV_prc_frms: Integer; //brukes av getDifStat();

    PRV_player_pos: Real;
    PRV_player_TC: STring;

    PRV_timer_inhibit : Boolean;

    PRV_last_sec: Integer;

    PRV_params: STring;

    PRV_audio_param: STring;

    PRV_seeking: Boolean;
    PRV_pos_dif: Real;
    PRV_pos_dif_recue: Integer;



    PRV_stop_TC: String;

    PRV_preroll: Integer;

    PRV_cue_point: Integer;
    PRV_cue_corr: Boolean;
    PRV_max_recue_cnt: Integer;
    PRV_recue_cnt: Integer;


    PRV_start_TC: String;

    PRV_get_media_info: Boolean;

    PRV_matchframe_offset : Integer;
    PRV_PB_offset_frames : Integer;

    PRV_skip_cue_error: Boolean;

    PRV_analyze: Boolean;
    PRV_start_analyze: Boolean;

    PRV_stat_pos_dif: Real;  //Antall sekunder feil ved s�k til 95 prosent

    PRV_playing: Boolean;  //TRUE i normal avspilling

    //FMPlayer: TMPlayer;
    FNativeSize: boolean;
    FTrackBar: TMZTrackBar;
    FTrackType: TMZTrackType;
    function GetCustomizedFile: string;
    function GetMPlayer: TMPlayer;
    function GetNativeHeight: integer;
    function GetNativeSize: boolean;
    function GetNativeWidth: integer;
    function SecsToDateTime(const ASeconds: real): TDateTime;
    procedure LoadCustomizedFile;
    procedure SaveCustomizedFile;
    procedure SetNativeSize(const ANativeSize: boolean);


   procedure setTCclock(tcs: String);
   function getTCclock: String;
   procedure setTCclockOffset(tcs: String; tci: Integer);
   function getTCclockOffset: Integer;

   function getMediaInfo: Integer;

   function writeTCfile(cname,tc_in,tc_out: String): Integer;
   function readTCdataFile(cname: STring; var tc_in,tc_out,tc_cname: String): Integer;

   function  iniParams(frm: Tform; cmd: Integer): Integer;
   function  gotoTC(tcs: String; corr: Boolean): Integer;
   function  correctCueOffset(tcs: String): Integer;

   function  gotoPos(sps: Real): Integer;

   procedure setUpdateInhbit(stat: Boolean);
   function  isUpdateInhibit: Boolean;

   procedure stepTCframe(frmi,fval: Integer);
   procedure stepTCclock(seci: Integer);

   procedure setTCframes(frms: Integer);

   procedure displayTCframes;
   procedure startFrameTimer;
   procedure stopFrameTimer;

   function  startPlayer: Boolean;
   procedure stopPlayer;


   procedure setLocalParams(prms: String);
   function getLocalParams: String;

   procedure applyParams(pval: String; cmd: Integer);
   function getMediaProp(plbl: String): String;


   procedure gotoStart;
   procedure gotoEnd;

   function stopOnTC(tcs: String): Integer;

   procedure setStopTC(tcs: String);
   function getStopTC: String;

   procedure setPreroll(prl: Integer);

   function getCueTC(cue_pt: Integer): String;

   procedure setBtnStats(stat: Boolean);

   procedure playPause(cmd: Integer);

   procedure setTrackBarData;

   function getDifStat(prc_pos: Integer; cmd: Integer): Real;

   procedure setCorrectionTimer(intrvl: Integer; stat: Boolean);

   function initMediaFile: Integer;

  protected
    procedure DoApplicationHint(ASender: TObject); virtual;
    procedure DoPlayerChangeAudioDelay(ASender: TObject); virtual;
    procedure DoPlayerChangeSpeed(ASender: TObject); virtual;
    procedure DoPlayerChangeVolume(ASender: TObject); virtual;
    procedure DoPlayerProgress(ASender: TObject); virtual;
    procedure DoPlayerSetProp(ASender: TObject; const AIndex: integer); virtual;
    procedure DoPlayerStartPlay(ASender: TObject); virtual;
    procedure DoSetSize; virtual;
    procedure DoUpdateMPlayer; virtual;
    procedure DoUpdateTimers; virtual;
    procedure DoUpdateTrackBar; virtual;
  public
    { Public declarations }
    //constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
    property MPlayer: TMPlayer read GetMPlayer;
  published
    property NativeSize: boolean read GetNativeSize write SetNativeSize default true;
  end;

var
  frmMain: TfrmMain;

implementation

uses
About,
munits;


{$R *.dfm}

{ TfrmMain }

{
constructor TfrmMain.Create(AOwner: TComponent);
var
 tcs: String;
 tc_offset,frms: Integer;
begin

inherited Create(AOwner);

FNativeSize := true;
Application.OnHint := DoApplicationHint;

frmMain.Top :=10;
frmMain.Left :=10;

LoadCustomizedFile();

//FMPlayer := TMPlayer.Create(nil);
FMPlayer.Parent := pnlPlayer;
FMPlayer.Align := alClient;
FMPlayer.OnChangeAudioDelay := DoPlayerChangeAudioDelay;
FMPlayer.OnChangeProp := DoPlayerSetProp;
FMPlayer.OnChangeSpeed := DoPlayerChangeSpeed;
FMPlayer.OnChangeVolume := DoPlayerChangeVolume;
FMPlayer.OnProgress := DoPlayerProgress;
FMPlayer.OnStartPlay := DoPlayerStartPlay;
FMPlayer.Paused := false;

//FMPlayer.Params :='aspect 16:9';

FTrackBar := TMZTrackBar.Create(nil);
FTrackBar.Parent := pnlSlider;
FTrackBar.Align := alClient;
FTrackBar.Min := 0;
FTrackBar.Max := 99; //M� v�re prosent
FTrackBar.OnKeyUp := DoTrackBarKeyUp;
FTrackBar.OnMouseUp := DoTrackBarMouseUp;
FTrackBar.PopupMenu := pppTrackBar;

 PRV_get_media_info :=FALSE;


 PRV_app_dir :=ExtractFileDir(paramStr(0));


 FMPlayer.mplayerPath :=PRV_app_dir;

 iniParams(frmMain,READ_);

 typFrm.setLocaleFormats(NUL);

 setPreroll(PRV_preroll);


 //TC offset i frames
 if paramStr(2) <> NUL then
  setTCclockOffset(NUL,strToIntDef(paramStr(2),0))
 else
  setTCclockOffset(TIME_00,0);

 //Spill fra TC

 if paramStr(3) <> NUL then
  TCinn.Text :=unitFrm.format_TC(paramstr(3),TRUE);

 if paramStr(4) <> NUL then
  TCut.Text :=unitFrm.format_TC(paramstr(4),TRUE);

   //Er fil spesifisert ved oppstart ?
 //\\narkbrowser\y\~Omn~C~I~60~58.wmv
 if paramStr(1) <> NUL then
 begin
  PRV_media_filename :=trim(paramstr(1));

  FMPlayer.MediaAddr :=PRV_media_filename;

  PRV_get_media_info :=TRUE; //For � hente div infor i play

  //PRV_show_init_data :=TRUE;


  if startPlayer() then
  begin
  //FMPlayer.Active := true;

   tcs :=TCinn.text;

   frms :=unitFrm.TC_toFrames(tcs);

   if frms>0 then
   begin
    //Denne er ikke ruten�katig
    //FMPlayer.sendSeek(PRV_TC_play_from/MZ_FRAME_RATE,FALSE);

    gotoTC(tcs,TRUE);
    PRV_cue_point :=CUE_ENTRY;

    //correctionTimer.Enabled :=TRUE;

   end
   else
   begin

    tc_offset :=getTCclockOffset();

    tcs :=unitFrm.FramesTo_TC(tc_offset,TRUE);
    setTCclock(tcs);

   end;

   TCfileTimer.enabled :=TRUE;

  end;
 end;

 setTcFrames(0); //PRV_TC_frames :=0;

 setUpdateInhbit(FALSE);

 PRV_pos_dif :=0;

 PRV_skip_cue_error :=FALSE;

 PRV_analyze :=FALSE;
 PRV_start_analyze :=FALSE;

 PRV_prc_frms :=0;
 PRV_stat_pos_dif :=0;

 //PRV_operate_inhibit :=FALSE;

 PRV_seeking :=FALSE;
end;
}



procedure TfrmMain.FormCreate(Sender: TObject);
var
 tcs: String;
 tc_offset,frms: Integer;
begin

FNativeSize := true;
Application.OnHint := DoApplicationHint;

frmMain.Top :=10;
frmMain.Left :=10;

LoadCustomizedFile();

//FMPlayer := TMPlayer.Create(nil);
FMPlayer.Parent := pnlPlayer;
FMPlayer.Align := alClient;
FMPlayer.OnChangeAudioDelay := DoPlayerChangeAudioDelay;
FMPlayer.OnChangeProp := DoPlayerSetProp;
FMPlayer.OnChangeSpeed := DoPlayerChangeSpeed;
FMPlayer.OnChangeVolume := DoPlayerChangeVolume;
FMPlayer.OnProgress := DoPlayerProgress;
FMPlayer.OnStartPlay := DoPlayerStartPlay;
FMPlayer.Paused := false;

//FMPlayer.Params :='aspect 16:9';

FTrackBar := TMZTrackBar.Create(nil);
FTrackBar.Parent := pnlSlider;
FTrackBar.Align := alClient;
FTrackBar.Min := 0;
FTrackBar.Max := 99; //M� v�re prosent
FTrackBar.OnKeyUp := DoTrackBarKeyUp;
FTrackBar.OnMouseUp := DoTrackBarMouseUp;
FTrackBar.PopupMenu := pppTrackBar;

 PRV_get_media_info :=FALSE;


 PRV_app_dir :=ExtractFileDir(paramStr(0));


 FMPlayer.mplayerPath :=PRV_app_dir;

 iniParams(frmMain,READ_);

 typFrm.setLocaleFormats(NUL);

 setPreroll(PRV_preroll);


 //TC offset i frames
 if paramStr(2) <> NUL then
  setTCclockOffset(NUL,strToIntDef(paramStr(2),0))
 else
  setTCclockOffset(TIME_00,0);

 if paramStr(3) <> NUL then
  TCinn.Text :=unitFrm.format_TC(paramstr(3),TRUE);

 if paramStr(4) <> NUL then
  TCut.Text :=unitFrm.format_TC(paramstr(4),TRUE);

   //Er fil spesifisert ved oppstart ?
 //\\narkbrowser\y\~Omn~C~I~60~58.wmv
 if paramStr(1) <> NUL then
 begin
  PRV_media_filename :=trim(paramstr(1));

  FMPlayer.MediaAddr :=PRV_media_filename;

  PRV_get_media_info :=TRUE; //For � hente div infor i play

  //initMediaFile();

  if startPlayer() then
  begin

   //Framedrop =disabled kommer et to klikk ved f�rste oppstart
   DoFrameDropToogle(sender);
  // sleep(250); //pga mistanke om Ttimer krasj
   DoFrameDropToogle(sender);
  
   tcs :=TCinn.text;

   frms :=unitFrm.TC_toFrames(tcs);

   if frms>0 then
   begin

    gotoTC(tcs,TRUE);
    PRV_cue_point :=CUE_ENTRY;

   end
   else
   begin

    tc_offset :=getTCclockOffset();

    tcs :=unitFrm.FramesTo_TC(tc_offset,TRUE);
    setTCclock(tcs);

   end;

   TCfileTimer.enabled :=TRUE;

  end;


 end;

 setTcFrames(0); //PRV_TC_frames :=0;

 setUpdateInhbit(FALSE);

 PRV_pos_dif :=0;

 PRV_skip_cue_error :=FALSE;
 //PRV_cue_corr :=FALSE;

 PRV_analyze :=FALSE;
 PRV_start_analyze :=FALSE;

 PRV_prc_frms :=0;
 PRV_stat_pos_dif :=0;
 PRV_TC_start_offset :=0;
 PRV_last_sec :=0;

 PRV_recue_cnt :=0;

 PRV_seeking :=FALSE;
end;


procedure TfrmMain.FormDestroy(Sender: TObject);
begin

stopPlayer();
//FMplayer.active :=FALSE;

FTrackBar.Free;

SaveCustomizedFile();
ActionManager.FileName := NUL;

end;

{
destructor TfrmMain.Destroy;
begin

stopPlayer();
//FMplayer.active :=FALSE;

FTrackBar.Free;

SaveCustomizedFile();
ActionManager.FileName := '';

inherited Destroy;
end;
}


function TfrmMain.initMediaFile: Integer;
var
 cx,rt,max_loop: Integer;
 secpos: Real;
begin
 rt :=ERROR_;
 Result :=rt;

 with FMplayer do
 begin
  if MediaAddr = NUL then
   exit;

  try
   active :=TRUE
  except
   exit;
  end;  

  if Active then
  begin


   if not Paused then
     Paused := TRUE;


   sendSeek(0,TRUE);

   PRV_get_media_info :=TRUE;
   PRV_init :=TRUE;

   //paused :=FALSE;
   startPlayer();
 {
  setUpdateInhbit(TRUE);

   cx :=0;
   max_loop :=25;

   while (PRV_get_media_info) AND (cx<max_loop) do
   begin
    if getMediaInfo()>=0 then
    begin
     PRV_get_media_info :=FALSE;
     rt :=0;
     break;
    end;

    inc(cx);
    sleep(125);

    setTrackbarData();
    secpos :=timePosition;
   end;

   //paused :=TRUE;
   setUpdateInhbit(FALSE);
 }

  end; //if active


 end;


 Result :=rt;
end;


function TfrmMain.getMediaInfo: Integer;
var
 str,tcs: String;
 start_offset: Real;
 dtm: TdateTime;
 rt: Integer;
begin

 rt :=ERROR_;
 Result :=rt;


 if not FMplayer.active then
  exit;

 //PRV_TC_media_offset
  str :=getMediaProp(ID_PARAM_MEDIA_START);


  if str<>NUL then
  begin
   start_offset :=unitFrm.atof(str);

   if start_offset<0 then
    start_offset :=0;

   PRV_TC_media_offset :=unitFrm.deciTimeToFrames(start_offset);
   //PRV_TC_media_offset :=0;

   PRV_start_TC :=unitFrm.FramesTo_TC(PRV_TC_media_offset,TRUE);

   rt :=0;
  end
  else
  begin
   PRV_start_TC :=TIME_00;
   PRV_TC_media_offset :=0;

   rt :=CANCEL_;
  end;

  PRV_audio_param :=getMediaProp(ID_PARAM_AUDIO);


 Result :=rt;
end;



procedure TfrmMain.applyParams(pval: String; cmd: Integer);
var
 ext,prms: String;
 idx,ach: Integer;
 mps: Real;
begin

 if FMplayer.active then
 begin
  exit  //Kan ikke legge p� params i play
 end;


  FMplayer.Params :=NUL;

 if strToIntDef(pval,0)=0 then
  prms :=ID_AUDIO_TRAC_0
 else
 if strToIntDef(pval,0)=1 then
  prms :=ID_AUDIO_TRAC_1
 else
 if strToIntDef(pval,0)=2 then
  prms :=ID_AUDIO_TRAC_2;


 try
  FMplayer.Params :=prms; //PRV_wmv_params;
 except
  //
 end;

 //end;

 if cmd=RESTART_ then
 begin

  prms :=format(' -ss %d',[round(PRV_player_pos)]);
  FMplayer.Params :=FMplayer.Params+prms;

  FMplayer.active :=TRUE;

  goToTC(PRV_player_TC,FALSE);

 end;

end;

procedure TfrmMain.setUpdateInhbit(stat: Boolean);
begin
 PRV_timer_inhibit :=stat;
end;

function  TfrmMain.isUpdateInhibit: Boolean;
begin

 Result :=PRV_timer_inhibit;
end;


function TfrmMain.getCueTC(cue_pt: Integer): String;
var
 tcs: String;
begin
 tcs :=NUL;
 Result :=tcs;

 if cue_pt=CUE_ENTRY then
 begin
  tcs :=TCinn.text;
 end
 else
 if cue_pt=CUE_EXIT then
 begin
  tcs :=TCut.text;
 end
 else
 begin
  tcs :=PRV_player_TC;
 end;

 //PRV_cue_point :=0;

 Result :=tcs;
end;

procedure TfrmMain.setCorrectionTimer(intrvl: Integer; stat: Boolean);
begin


 if intrvl>0 then
  correctionTimer.interval :=intrvl;

 correctionTimer.enabled :=stat;
 
end;



function TfrmMain.correctCueOffset(tcs: String): Integer;
var
 seek_pos,pos_dif,tc_pos_dif,track_pos,sec,prerl,ps: Real;
 rt,frms,tc_offset,track_frms,frms_clk: Integer;
 tc_clk,tc_seek,tc_cue,str: String;

 osd_on,osd_lvl: Integer;

begin
 Result :=0;

 //exit;  //debug
 //cmd :=0;

 //tcs :=getTcClock();

 if tcs=NUL then
  exit
 else
  tc_seek :=tcs;

  if (tc_seek=NUL) OR (not FMplayer.Active) then
   exit;

 //For at doUpdateTimers() ikke skal flytte p� tiden
  setUpdateInhbit(TRUE);  //Usikkert om denne er n�dvendig

  tc_offset :=getTCclockOffset();

  track_pos :=FMplayer.timePosition;

 frms :=unitFrm.TC_toFrames(tc_seek);

 track_frms :=unitFrm.deciTimeToFrames(track_pos);

 frms :=frms-tc_offset;

 seek_pos :=unitFrm.framesToDeciTime(frms);

 if track_pos=0 then   //Ikke oppdatert
  track_pos :=seek_pos;

 pos_dif :=(seek_pos-track_pos);

 //if pos_dif<0 then
 // rt :=0;  //debug

 //if pos_dif>(PRV_preroll/2) then

 //minus ca 2 sek. for � v�re sikker p� at player ligger foran cue punkt
 //pos_dif :=pos_dif-(PRV_preroll/2);
 {
  tc_clk :=getTcClock();

  frms_clk :=unitFrm.TC_toFrames(tc_clk);

  if (frms_clk>0) and (PRV_recue_cnt>0) then
   pos_dif :=((frms-frms_clk)/VIDEO_FRAME_RATE)-PRV_preroll;
 }

 sts.Panels.Items[2].Text :=format('%.2f (%d)',[pos_dif,PRV_recue_cnt]); //floatToStr(pos_dif);

 if pos_dif=0 then
 begin

  //Selv om pos_dif=0 kan posisjonen v�re p� feil sted i forhold til TC
  tc_clk :=getTcClock();

  frms_clk :=unitFrm.TC_toFrames(tc_clk);

  if frms_clk>0 then
  begin
   tc_pos_dif :=((frms-frms_clk)/VIDEO_FRAME_RATE)-PRV_preroll;

   if tc_pos_dif>0 then
    FMPlayer.sendSeek(tc_pos_dif,FALSE);  //Send forover

  end;

  ps :=0;

 end
 else
 begin

    //if (pos_dif<0) and (pos_dif>(-(PRV_preroll))) then
  // pos_dif :=pos_dif-((PRV_preroll)-pos_dif);

   //if pos_dif>(-MAX_POS_DIF) then
   // pos_dif :=(pos_dif-(PRV_preroll/2));

   FMPlayer.sendSeek((pos_dif-(PRV_preroll/2)),FALSE);

   //FMPlayer.sendSeek(pos_dif,FALSE);

  if (PRV_recue_cnt>PRV_max_recue_cnt) then
  begin

    str :=format('"%d recue, sjekk preroll."',[PRV_recue_cnt]);
    FMplayer.SendCommand(OSD_SHOW_TXT + ' '+str);

    setUpdateInhbit(FALSE); 

    doPause(self);

    Result :=ERROR_;
    exit;

  end
  else
  if (abs(pos_dif)>PRV_pos_dif_recue) then
  begin
  //Gj�r nytt s�k hvis feilen er for stor

   inc(PRV_recue_cnt);

   //correctionTimer.Enabled :=TRUE;
   setCorrectionTimer(CORR_INTERVAL_RECUE,TRUE);

   setUpdateInhbit(FALSE);

   Result :=RETRY_;
   exit;

  end;

  end;


   setTcClock(tc_seek);

   //For at tidskodene skal bli oppdatert
   doPlay(self);
   doPause(self);

   //seekTimer.enabled :=TRUE;  //usikkert om det er n�dvendig � g� via denne timeren

   PRV_seeking :=TRUE;  //Gj�r at FMplayerTimer cuer til eksakt frame

   PRV_recue_cnt :=0;
   PRV_cue_point :=0;

   setUpdateInhbit(FALSE);  //Usikkert om denne er n�dvendig


  {  //Usikkert hvorfor denne koden ikke kan ligger her og m� ligge
     //i FMplayerTimer. Testet, men fungerer ikke.
     //Sannsynligvis noe � gj�re med at klokketidene ikke er oppdatert.
  PRV_seeking :=FALSE;

  tc_cue :=unitFrm.FramesTo_TC(PRV_seek_frms,TRUE);

  tc_offset :=getTCclockOffset();

  tc_cue :=unitFrm.TC_add_frames(tc_cue,tc_offset);


  frms :=unitFrm.deciTimeToFrames(FMPlayer.TimePosition);

  //PRV_pos_dif :=(PRV_player_pos_seek-frms)/VIDEO_FRAME_RATE;

  PRV_pos_dif :=unitFrm.framesToDeciTime(frms-PRV_seek_frms);

  if PRV_pos_dif>MAX_POS_DIF then
  begin
   FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"Cue feil"');

   doPause(self);

   exit;
  end;


  str :=floatToStr(PRV_pos_dif);

  //str :=intToStr(frms-PRV_seek_frms);

  tc_clk :=unitFrm.FramesTo_TC(frms,TRUE);

  sts.Panels.Items[0].Text := tc_clk;//TimeToStr(SecsToDateTime(secpos)); //+ ' ' + intToStr(tc_offset);

  sts.Panels.Items[2].Text :=str;

  prerl :=PRV_preroll + round(PRV_pos_dif);

  if prerl > PRV_preroll*2 then
   prerl :=PRV_preroll*2;

  if PRV_pos_dif<>0 then
  begin
   osd_on :=round((PRV_pos_dif*2)*1000);
   if osd_on>PRV_preroll then
    osd_on :=2000;

   osd_lvl :=1;

   str :=format('%s "%s %s" %d %d',[OSD_SHOW_TXT,'S�ker TC',tcs,osd_on,osd_lvl]);

   FMplayer.SendCommand(str);  //OBS: denne starter av en eller annen grunn play
  end;

  if PRV_pos_dif<(-(prerl)/2) then
  begin
   setStopTC(tcs);

   doPlay(self);

  end
  else
  begin
   //tc_clk :=getTcClock();

   //tcmem.lines.add('F�r preroll: '+tc_clk);

   tc_clk :=unitFrm.FramesTo_TC(frms-unitFrm.deciTimeToFrames(PRV_preroll),TRUE);

   //OBS: denne stopper p� f�rste keyframe bakover
   FMplayer.SendSeek(-(prerl),FALSE);

   setStopTC(tc_cue);

   setTCclock(tc_clk);

   doPlay(self);

  end;
   }




 Result :=round(pos_dif);
end;


function TfrmMain.iniParams(frm: Tform; cmd: Integer): Integer;
var
 inifil: TiniFile;
 defStr,str,flname: String;
begin

Result :=ERROR_;

if (not assigned(frm)) OR
   (frm.name=NUL) then
 exit;

flname :=uniTfrm.addFileToPath(PRV_app_dir,INI_FILE_NAME);

iniFil :=TiniFile.create(flname);


if cmd = WRITE_ then
begin

if frm.windowState = wsMaximized then
 str :=format('%d,%d,%d,%d',[0,0,0,0])
else
if frm.windowState = wsMinimized then
 str :=format('%d,%d,%d,%d',[-1,-1,-1,-1])
else
 str :=format('%d,%d,%d,%d',[frm.top,frm.left,frm.height,frm.width]);


 try
  iniFil.writeString(INI_SECT,frm.name,str);

  iniFil.writeString(INI_SECT,'local_params',getLocalParams());

  iniFil.writeString(INI_SECT,'TC_data_dir',PRV_tc_data_dir);

  iniFil.writeString(INI_SECT,'work_dir',PRV_work_dir);

  iniFil.writeInteger(INI_SECT,'preroll',PRV_preroll);

  iniFil.writeInteger(INI_SECT,'frame_offset',PRV_frame_offset);

  iniFil.writeInteger(INI_SECT,'pos_dif_recue',PRV_pos_dif_recue);

  iniFil.writeInteger(INI_SECT,'max_recue',PRV_max_recue_cnt);

  iniFil.writeInteger(INI_SECT,'max_frames_off',PRV_max_frames_off);


 except
  Result :=ERROR_;
  exit;
 end;

end;


if cmd = READ_ then
begin
 defStr :='10,10,500,700';    //Default st�rrelse hvis INI-data mangler

 try
  str :=iniFil.readString(INI_SECT,frm.name,defstr);
 except
  //raise;
  Result :=ERROR_;
  exit;
 end;

 //Splitt komma-separert 'str' til 'ints[]'
 if unitFrm.breakStrToInts(str,',',@PUBints) <0 then
  exit;

 frm.top :=PUBints[1];
 frm.left :=PUBints[2];
 frm.height :=PUBints[3];
 frm.width :=PUBints[4];

 str :=iniFil.readString(INI_SECT,'local_params',NUL);

 PRV_tc_data_dir := iniFil.readString(INI_SECT,'TC_data_dir',TC_DATA_DIR);
 PRV_work_dir := iniFil.readString(INI_SECT,'work_dir',PRV_app_dir);

 PRV_preroll := iniFil.readInteger(INI_SECT,'preroll',PREROLL_SEC);

 //PRV_PB_offset_frames := iniFil.readInteger(INI_SECT,'PB_offset_frames',PB_OFFSET_FRAMES);

 PRV_frame_offset := iniFil.readInteger(INI_SECT,'frame_offset',FRAME_OFFSET);


 PRV_pos_dif_recue :=iniFil.readInteger(INI_SECT,'pos_dif_recue',MAX_POS_DIF_RECUE);

 PRV_max_recue_cnt := iniFil.readInteger(INI_SECT,'max_recue',MAX_RECUE_CNT);
 PRV_max_frames_off := iniFil.readInteger(INI_SECT,'max_frames_off',MAX_FRAMES_OFF);

 try

 if PRV_work_dir<>PRV_app_dir then
  if directoryExists(PRV_work_dir) then
   chDir(PRV_work_dir);

 except
  //
 end;

 setLocalParams(str);

end;

 iniFil.free;

// if refPixels.checkedthen
//  frm.pixelsPerInch :=screen.pixelsPerInch;

 Result :=0;
end;

function Tfrmmain.readTCdataFile(cname: STring; var tc_in,tc_out,tc_cname: String): Integer;
var
 ps,ps_in,ps_out,fli: Integer;
 txtfile: TextFile;
 dats,appdir,flpath,str,flname: String;
 fldtm: TdateTime;
begin
 Result :=ERROR_;

 tc_cname :=NUL;
 dats :=NUL;

 if cname=NUL then
  exit;

 //Ikke oppdater TC inn og ut i play
 if frameTimer.Enabled then
  exit;

 //flname :=unitFrm.getCleanFilename(cname);

 //str :=format('ClipName:%s TCinn:%s TCut:%s',[flname,tc_in,tc_out]);
 flpath :=unitFrm.addFileToPath(PRV_TC_data_dir,TC_FILE_READ);

 if not fileExists(flpath) then
  exit;

 //Ikke oppdater TC inn og ut i play
 if frameTimer.Enabled then
 begin
  DeleteFile(flpath);

  exit;
 end;

 try
  AssignFile(txtFile,flpath);
  reset(txtFile);

  Readln(txtFile,str);

  CloseFile(txtFile);
 except
  //unitFrm.msgDlg(format('Kan ikke lese filen %s',[flpath]),ERROR_);
  exit;
 end;



  Result :=CANCEL_;

 if str=NUL then
  exit;

 ps_in :=pos(TC_IN_FNAME,str);
 ps_out :=pos(TC_OUT_FNAME,str);

 if (ps_in=0) OR (ps_out=0) then
  exit;

 ps := pos(TC_CLIP_NAME,str);
 if ps>=0 then
  tc_cname :=trim(copy(str,(ps+length(TC_CLIP_NAME)+1),
                           (ps_in-length(TC_CLIP_NAME)-2)));



 //Sjekk om dette tilh�rer valgt klipp
 if AnsiCompareText(cname,tc_cname)=0 then
 begin
  tc_in :=trim(copy(str,(ps_in+length(TC_IN_FNAME)+1),TC_LEN_F));
  tc_out :=trim(copy(str,(ps_out+length(TC_OUT_FNAME)+1),TC_LEN_F));

  //Slett filen slik at den ike leses f�r MediaDB har laget ny

  if fileExists(flpath) then
   DeleteFile(flpath);


 end
 else
 begin
  Result :=WARNING_;
  exit;
 end;

 Result :=1;
end;


function TfrmMain.writeTCfile(cname,tc_in,tc_out: String): Integer;
var
 txtfile: TextFile;
 appdir,flpath,str,flname: String;
begin
 Result :=ERROR_;

 if cname=NUL then
  exit;

 flname :=unitFrm.getCleanFilename(cname); 

  str :=format('ClipName:%s TCinn:%s TCut:%s',[flname,tc_in,tc_out]);
 flpath :=unitFrm.addFileToPath(PRV_TC_data_dir,TC_FILE_WRITE);

  AssignFile(txtFile,flpath);
  ReWrite(txtFile);
  //Reset(txtFile);

 WriteLn(txtFile,str);

 CloseFile(txtFile);

 Result :=0;
end;

procedure TfrmMain.stepTCclock(seci: Integer);
var
 hr,mn,sc,frms: Integer;
 tcs: String;
begin

  tcs :=getTCclock();

  //frms :=round(seci*VIDEO_FRAME_RATE);

  frms :=unitFrm.deciTimeToFrames(seci);

  tcs :=unitFrm.TC_add_frames(tcs,frms);

  unitFrm.encodeTCdate(tcs,hr,mn,sc,frms);

  TCclock.FixedTime.Hour :=hr;
  TCclock.FixedTime.Minute :=mn;
  TCclock.FixedTime.second :=sc;


end;


procedure TfrmMain.setTCclock(tcs: String);
var
 hr,mn,sc,frms,tc_offset: Integer;
 tcstr: String;
begin


 if not FMPlayer.Active then
 begin
   tcstr :=TIME_00;

   stopFrameTimer();
   setTCframes(0);
   displayTCframes();

 end
 else
  tcstr :=tcs;


  unitFrm.encodeTCdate(tcs,hr,mn,sc,frms);

  TCclock.FixedTime.Hour :=hr;
  TCclock.FixedTime.Minute :=mn;
  TCclock.FixedTime.second :=sc;

  setTCframes(frms);
  displayTCframes();

  //PRV_TC_clock :=getTcClock();

  application.processMessages();

end;

function TfrmMain.getTCclock: String;
var
 hr,mn,sc,frms,tc_offset: Integer;
 tcs: String;
begin

 hr :=TCclock.FixedTime.Hour;
 mn :=TCclock.FixedTime.Minute;
 sc :=TCclock.FixedTime.Second;

 tcs :=unitFrm.encodeTCstr(hr,mn,sc,PRV_TC_frames);

 if not FMplayer.paused then
 begin
  //tcs :=unitFrm.TC_add_frames(tcs,round(-TC_CLOCK_DELAY));
 end;

 Result :=tcs;
end;

function TfrmMain.getTCclockOffset: Integer;
begin

 Result :=PRV_TC_offset; //TCclock.Tag;
end;

procedure TfrmMain.setTCclockOffset(tcs: String; tci: Integer);
var
 frms,sec,frms_start: Integer;
begin

 if tci=0 then
  frms :=unitFrm.TC_toFrames(tcs)
 else
  frms :=tci;


 frms_start :=PRV_TC_media_offset;

 PRV_TC_offset :=frms; //-frms_start; //sec;

 if PRV_TC_offset<0 then
  PRV_TC_offset :=0;


end;


procedure TfrmMain.DoAbout(ASender: TObject);
begin
ShowAboutForm;
end;

procedure TfrmMain.setTrackBarData;
begin

  if FMPlayer.Active then
  begin
   //PRV_media_fileName :=ExtractFileName(FMPlayer.MediaAddr);

   //Caption := PRG_NAME + ' ' + '[' + PRV_filename + ']';
   FTrackBar.Enabled := true;
   miPosition.Checked := FTrackType = mttPosition;
   miPosition.Enabled := true;
   miAudioDelay.Checked := FTrackType = mttAudioDelay;
   miAudioDelay.Enabled := FMPlayer.HaveAudio and FMPlayer.HaveVideo;
   miVolume.Checked := FTrackType = mttVolume;
   miVolume.Enabled := FMPlayer.HaveAudio;
   miSpeed.Checked := FTrackType = mttSpeed;
   miSpeed.Enabled := true;
   miBrightness.Checked := FTrackType = mttBrightness;
   miBrightness.Enabled := FMPlayer.HaveVideo;
   miContrast.Checked := FTrackType = mttContrast;
   miContrast.Enabled := FMPlayer.HaveVideo;
   miSaturation.Checked := FTrackType = mttSaturation;
   miSaturation.Enabled := FMPlayer.HaveVideo;
  end
  else
  begin
   Caption := PRG_NAME;
   FTrackBar.Enabled := false;
   FTrackBar.Position := FTrackBar.Min;
  end;

end;

procedure TfrmMain.DoActionManagerUpdate(AAction: TBasicAction; var AHandled: Boolean);
var
   ReadyToPlay: boolean;
begin

 //Av ukjent �rsak trigges denne hvert sekund, men bare dersom ActionManager er
 //er synlig.

 if isUpdateInhibit() then
  exit;

{
  if FMPlayer.Active then
  begin
   //PRV_media_fileName :=ExtractFileName(FMPlayer.MediaAddr);

   //Caption := PRG_NAME + ' ' + '[' + PRV_filename + ']';
   FTrackBar.Enabled := true;
   miPosition.Checked := FTrackType = mttPosition;
   miPosition.Enabled := true;
   miAudioDelay.Checked := FTrackType = mttAudioDelay;
   miAudioDelay.Enabled := FMPlayer.HaveAudio and FMPlayer.HaveVideo;
   miVolume.Checked := FTrackType = mttVolume;
   miVolume.Enabled := FMPlayer.HaveAudio;
   miSpeed.Checked := FTrackType = mttSpeed;
   miSpeed.Enabled := true;
   miBrightness.Checked := FTrackType = mttBrightness;
   miBrightness.Enabled := FMPlayer.HaveVideo;
   miContrast.Checked := FTrackType = mttContrast;
   miContrast.Enabled := FMPlayer.HaveVideo;
   miSaturation.Checked := FTrackType = mttSaturation;
   miSaturation.Enabled := FMPlayer.HaveVideo;
  end
  else
  begin
   Caption := PRG_NAME;
   FTrackBar.Enabled := false;
   FTrackBar.Position := FTrackBar.Min;
  end;
}

 setTrackbarData();

 //Her skjer alle tidskode visninger og oppdateringer
 //Fors�k p� � flytte denne til playerTimer f�rer til d�rligere presisjon
 DoUpdateTimers();

if AAction = ctnFileOpen then
   begin
   ctnFileOpen.Enabled := not FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnStop then
   begin
    ctnStop.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnHaveAudio then
   begin
   ctnHaveAudio.Enabled := FMPlayer.Active;
   ctnHaveAudio.Checked := FMPlayer.HaveAudio;
   AHandled := true;
   Exit;
   end;
if AAction = ctnHaveVideo then
   begin
   ctnHaveVideo.Enabled := FMPlayer.Active;
   ctnHaveVideo.Checked := FMPlayer.HaveVideo;
   AHandled := true;
   Exit;
   end;
if AAction = ctnLogPlayer then
   begin
   ctnLogPlayer.Enabled := true;
   ctnLogPlayer.Checked := FMPlayer.LogVisible;
   AHandled := true;
   Exit;
   end;
if AAction = ctnProperties then
   begin
   ctnProperties.Enabled := true;
   ctnProperties.Checked := FMPlayer.MediaPropListVisible;
   AHandled := true;
   Exit;
   end;
if AAction = ctnClose then
   begin
   ctnClose.Enabled := true;
   AHandled := true;
   Exit;
   end;

if AAction = ctnPlay then
   begin
   ReadyToPlay := FMPlayer.MPlayerExists and not(FMPlayer.MediaAddr = '');
   if ReadyToPlay then
      begin
      if FMPlayer.Active then
         ctnPlay.Enabled := FMPlayer.Paused
      else
         ctnPlay.Enabled := true;
      end
   else
      ctnPlay.Enabled := false;
   AHandled := true;
   Exit;
   end;
if AAction = ctnPause then
   begin
   ctnPause.Enabled := true;
   ctnPause.Checked := FMPlayer.Paused;
   AHandled := true;
   Exit;
   end;
if AAction = ctnFramStep then
   begin
   ctnFramStep.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnBack01 then
   begin
   ctnBack01.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnForward01 then
   begin
   ctnForward01.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnBack10 then
   begin
   ctnBack10.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnForward10 then
   begin
   ctnForward10.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnBack60 then
   begin
   ctnBack60.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnForward60 then
   begin
   ctnForward60.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnSpeedDec then
   begin
   ctnSpeedDec.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnSpeedDef then
   begin
   ctnSpeedDef.Enabled := FMPlayer.Active and FMPlayer.SpeedChanged;
   AHandled := true;
   Exit;
   end;
if AAction = ctnSpeedInc then
   begin
   ctnSpeedInc.Enabled := FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnMute then
   begin
   ctnMute.Enabled := FMPlayer.Active and FMPlayer.HaveAudio;
   ctnMute.Checked := FMPlayer.Mute;
   AHandled := true;
   Exit;
   end;
if AAction = ctnResetColor then
   begin
   ctnResetColor.Enabled := FMPlayer.Active and FMPlayer.HaveVideo
      and not FMPlayer.ColorsDefault;
   AHandled := true;
   Exit;
   end;

if AAction = ctnOsdToogle then
   begin
   ctnOsdToogle.Enabled := FMPlayer.Active and FMPlayer.HaveVideo;
   AHandled := true;
   Exit;
   end;
if AAction = ctnFrameDropToogle then
   begin
   ctnFrameDropToogle.Enabled := FMPlayer.Active and FMPlayer.HaveVideo;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAspectAutodetect then
   begin
   ctnAspectAutodetect.Enabled := not FMPlayer.Active;
   ctnAspectAutodetect.Checked := FMPlayer.Aspect = mpaAutoDetect;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAspect40_30 then
   begin
   ctnAspect40_30.Enabled := not FMPlayer.Active;
   ctnAspect40_30.Checked := FMPlayer.Aspect = mpa40_30;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAspect160_90 then
   begin
   ctnAspect160_90.Enabled := not FMPlayer.Active;
   ctnAspect160_90.Checked := FMPlayer.Aspect = mpa160_90;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAspect235_10 then
   begin
   ctnAspect235_10.Enabled := not FMPlayer.Active;
   ctnAspect235_10.Checked := FMPlayer.Aspect = mpa235_10;
   AHandled := true;
   Exit;
   end;
if AAction = ctnNativeSize then
   begin
   ctnNativeSize.Enabled := FMPlayer.HaveVideo;
   if FMPlayer.Active then
      ctnNativeSize.Checked :=
         (pnlPlayer.Width = GetNativeWidth) and
         (pnlPlayer.Height = GetNativeHeight)
   else
      ctnNativeSize.Checked := FNativeSize;
   AHandled := true;
   Exit;
   end;
if AAction = ctnFullScreen then
   begin
   if FMPlayer.Active then
      ctnFullScreen.Enabled := FMPlayer.HaveVideo
   else
      ctnFullScreen.Enabled := true;
   ctnFullScreen.Checked := FMPlayer.FullScreen;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAudioOutNoSound then
   begin
   ctnAudioOutNoSound.Enabled := not FMPlayer.Active;
   ctnAudioOutNoSound.Checked := FMPlayer.AudioOut = maoNoSound;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAudioOutNull then
   begin
   ctnAudioOutNull.Enabled := not FMPlayer.Active;
   ctnAudioOutNull.Checked := FMPlayer.AudioOut = maoNull;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAudioOutWin32 then
   begin
   ctnAudioOutWin32.Enabled := not FMPlayer.Active;
   ctnAudioOutWin32.Checked := FMPlayer.AudioOut = maoWin32;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAudioOutDsSound then
   begin
   ctnAudioOutDsSound.Enabled := not FMPlayer.Active;
   ctnAudioOutDsSound.Checked := FMPlayer.AudioOut = maoDsSound;
   AHandled := true;
   Exit;
   end;
if AAction = ctnReIndex then
   begin
   ctnReIndex.Enabled := not FMPlayer.Active;
   ctnReIndex.Checked := FMPlayer.ReIndex;
   AHandled := true;
   Exit;
   end;
if AAction = ctnParams then
   begin
   ctnParams.Enabled := not FMPlayer.Active;
   AHandled := true;
   Exit;
   end;
if AAction = ctnAbout then
   begin
   ctnAbout.Enabled := true;
   AHandled := true;
   end;

   if AAction = ctnScreenshot then
   begin
    ctnScreenshot.Enabled := FMPlayer.Active;
    ctnScreenshot.caption :=NUL;
    AHandled := true;
   end;

  //ctnAudioTrack.Enabled :=TRUE;


end;

procedure TfrmMain.DoApplicationHint(ASender: TObject);
begin
//sts.Panels.Items[2].Text := Application.Hint;
end;

procedure TfrmMain.DoAspect160_90(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

FMPlayer.Aspect := mpa160_90;
end;

procedure TfrmMain.DoAspect235_10(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

 FMPlayer.Aspect := mpa235_10;
end;

procedure TfrmMain.DoAspect40_30(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

 FMPlayer.Aspect := mpa40_30;
end;

procedure TfrmMain.DoAspectAutodetect(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

 FMPlayer.Aspect := mpaAutoDetect;
end;

procedure TfrmMain.DoAudioOutDsSound(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

 FMPlayer.AudioOut := maoDsSound;
end;

procedure TfrmMain.DoAudioOutNoSound(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

 FMPlayer.AudioOut := maoNoSound;
end;

procedure TfrmMain.DoAudioOutNull(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

 FMPlayer.AudioOut := maoNull;
end;

procedure TfrmMain.DoAudioOutWin32(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

 FMPlayer.AudioOut := maoWin32;
end;

procedure TfrmMain.DoBack01(ASender: TObject);
begin
 if not FMPlayer.Active then
 Exit;

 setUpdateInhbit(FALSE);
 FMPlayer.SendSeek(- 1, false);
end;

procedure TfrmMain.DoBack10(ASender: TObject);
begin
if not FMPlayer.Active then
 Exit;

  setUpdateInhbit(FALSE);
 FMPlayer.SendSeek(- 9, false);
end;

procedure TfrmMain.DoBack60(ASender: TObject);
begin
if not FMPlayer.Active then
 Exit;

 setUpdateInhbit(FALSE);
 FMPlayer.SendSeek(- 59, false);
end;

procedure TfrmMain.DoFileOpen(ASender: TObject);
var
   OpenDialog: TOpenDialog;
begin

//stopFrameTimer();

TCfileTimer.Enabled :=FALSE;

OpenDialog := TOpenDialog.Create(nil);

 try
 if not OpenDialog.Execute then
  Exit;

 stopPlayer();

 TCfileTimer.enabled :=FALSE;

 setTcclockOffset(NUL,0);

 PRV_get_media_info :=TRUE; //For � f� ut mediaInfo

 FMPlayer.params :=getLocalParams();

 PRV_media_filename :=OpenDialog.FileName;

  finally
    OpenDialog.Free;
  end;

 TCinn.Text :=TC_NULL;

 TCut.Text :=TC_NULL;

 FMPlayer.MediaAddr := PRV_media_filename;

 startPlayer();
 //FMPlayer.Active := true;
 //PRV_TC_sec :=0;
 PRV_TC_tot_frames :=0;
 PRV_TC_start_offset :=0;
 PRV_last_sec :=0;


 setTCclockOffset(NUL,0);

 PRV_get_media_info :=TRUE;

 //PRV_start_analyze :=TRUE;

 //PRV_show_init_data :=TRUE;

 //Finn antall sekunder s�kefeil ved 95%

 //getDifStat(95,SET_);

 // try
   //FTrackBar.setFocus();

   //pnlSLider.SetFocus;
//  except
   //
//  end;

//FtrackBar

end;

procedure TfrmMain.DoForward01(ASender: TObject);
begin

if not FMPlayer.Active then
 Exit;

 setUpdateInhbit(FALSE);

 FMPlayer.SendSeek(+ 1, false);

end;

procedure TfrmMain.DoForward10(ASender: TObject);
begin
 if not FMPlayer.Active then
 Exit;

 setUpdateInhbit(FALSE);
 FMPlayer.SendSeek(+ 9, false);
end;

procedure TfrmMain.DoForward60(ASender: TObject);
begin

if not FMPlayer.Active then
 Exit;

  setUpdateInhbit(FALSE);
 FMPlayer.SendSeek(+ 59, false);
end;

procedure TfrmMain.DoFrameDropToogle(ASender: TObject);
begin

FMPlayer.SendFrameDropToogle;
end;

procedure TfrmMain.DoFrameStep(ASender: TObject);
begin
 if not FMPlayer.Active then
  Exit;

 PRV_stop_TC :=NUL;

 stopFrameTimer();

 stepTCframe(1,-1);

 //For at ikke TC klokke skal feiloppdateres fra posisjon
 setUpdateInhbit(TRUE);

 FMPlayer.SendFrameStep;

//setUpdateInhbit(FALSE);

end;

procedure TfrmMain.DoFullScreen(ASender: TObject);
begin
FMPlayer.FullScreen := not FMPlayer.FullScreen;
end;

procedure TfrmMain.DoLogPlayer(ASender: TObject);
begin
FMPlayer.LogVisible := not FMPlayer.LogVisible;
end;

procedure TfrmMain.DoMuteToogle(ASender: TObject);
begin
if not FMPlayer.Active then
 Exit;

 FMPlayer.Mute := not FMPlayer.Mute;
end;

procedure TfrmMain.DoNativeSize(ASender: TObject);
begin
SetNativeSize(not GetNativeSize);
end;

procedure TfrmMain.DoOsdToogle(ASender: TObject);
begin
FMPlayer.SendOsdToogle;
end;

procedure TfrmMain.DoParams(ASender: TObject);
var
 Par: string;
begin
if FMPlayer.Active then
 Exit;

Par := FMPlayer.Params;

if not InputQuery('Options', 'aditional params', Par) then
 Exit;

FMPlayer.Params := Par;
end;

procedure TfrmMain.DoPause(ASender: TObject);
begin

 if FMPlayer.Paused then
  setUpdateInhbit(FALSE);


 FMPlayer.Paused := TRUE; //not FMPlayer.Paused;

 //if FMplayer.paused then
  stopFrameTimer();
 //else
 // startFrameTimer();

 setBtnStats(TRUE);

end;

procedure TfrmMain.DoPlay(ASender: TObject);
begin

if not FMPlayer.MPlayerExists then
 Exit;

setUpdateInhbit(FALSE);

if FMPlayer.MediaAddr = NUL then
 Exit;

if FMPlayer.Active then
   begin
   if FMPlayer.Paused then
      FMPlayer.Paused := false;
   end
else
 startPlayer(); //FMPlayer.Active := true;

 startFrameTimer();
end;

procedure TfrmMain.DoPlayerChangeAudioDelay(ASender: TObject);
begin
DoUpdateTrackBar;
end;

procedure TfrmMain.DoPlayerChangeSpeed(ASender: TObject);
begin
DoUpdateTrackBar;
end;

procedure TfrmMain.DoPlayerChangeVolume(ASender: TObject);
begin
DoUpdateTrackBar;
end;

procedure TfrmMain.DoPlayerProgress(ASender: TObject);
begin


DoUpdateTrackBar;
end;

procedure TfrmMain.DoPlayerSetProp(ASender: TObject; const AIndex: integer);
begin
{
if FNativeSize and not(AIndex < 0) and
   (FMPlayer.MediaPropList.PropLabels[AIndex] = 'VIDEONATIVE_HEIGHT') then
   DoSetSize;
}
end;

procedure TfrmMain.DoPlayerStartPlay(ASender: TObject);
begin
if not FMPlayer.HaveVideo then
   Height := Height - pnlPlayer.Height;
DoUpdateTrackBar;
end;

procedure TfrmMain.DoProperies(ASender: TObject);
begin
FMPlayer.MediaPropListVisible := not FMPlayer.MediaPropListVisible;
end;

procedure TfrmMain.DoReIndex(ASender: TObject);
begin
if FMPlayer.Active then
 Exit;

 FMPlayer.ReIndex := not FMPlayer.ReIndex;
end;

procedure TfrmMain.DoResetColor(ASender: TObject);
begin
if not FMPlayer.Active then
 Exit;

 FMPlayer.ColorsReset;
DoUpdateTrackBar;
end;

procedure TfrmMain.DoSetSize;
var
   W, H, I: integer;
begin
if not FNativeSize then Exit;
W := GetNativeWidth;
if W < 0 then Exit;
H := GetNativeHeight;
if H < 0 then Exit;

for I := 1 to 10 do
   begin
   Width := Width - pnlPlayer.Width + W;
   Height := Height - pnlPlayer.Height + H;
   if (pnlPlayer.Width = W) and (pnlPlayer.Height = H) then Break;
   end;
end;

procedure TfrmMain.DoSpeedDec(ASender: TObject);
begin
if not FMPlayer.Active then
Exit;

FMPlayer.SendSpeedMult(0.5);
end;

procedure TfrmMain.DoSpeedDef(ASender: TObject);
begin
if not FMPlayer.Active then
 Exit;

 FMPlayer.SendSpeedSet(1);
end;

procedure TfrmMain.DoSpeedInc(ASender: TObject);
begin
if not FMPlayer.Active then
 Exit;

 FMPlayer.SendSpeedMult(2);
end;

procedure TfrmMain.DoStop(ASender: TObject);
begin
//FMPlayer.Active := false;

 stopPlayer();

 //TCinn.Text :=TIME_00;
//TCut.Text :=TIME_00;

end;

procedure TfrmMain.DoTrackBarKeyUp(ASender: TObject; var AKey: Word; AShift: TShiftState);
var
 rt: Integer;
begin

  if akey=VK_ESC then
  begin

    rt :=unitFrm.msgDlg('Avslutt programmet ?',QUESTION_);

    if (rt=mrYes) OR (rt=mrOK) then
    begin
     Do_Close(asender);
     exit;
    end;

  end;


  case akey of
  VK_SPACE,VK_ESC,VK_HOME,VK_END:
   exit;
  VK_I,VK_J,VK_K,VK_L,VK_N,VK_M,VK_O:
   exit;  //Disse er behandlet

 end;

 setUpdateInhbit(FALSE);

 DoUpdateMPlayer;  //ellers �delegger tastetrykk posisjonen !
end;

procedure TfrmMain.DoTrackBarMouseUp(ASender: TObject; AButton: TMouseButton;
   AShift: TShiftState; AX, AY: integer);
begin
 if not(AButton = mbLeft) then
  Exit;

 setUpdateInhbit(FALSE);

 DoUpdateMPlayer;
end;

procedure TfrmMain.DoTrackMenuItemClick(ASender: TObject);
begin
if ASender = miPosition then
   FTrackType := mttPosition;
if ASender = miAudioDelay then
   FTrackType := mttAudioDelay;
if ASender = miVolume then
   FTrackType := mttVolume;
if ASender = miSpeed then
   FTrackType := mttSpeed;
if ASender = miBrightness then
   FTrackType := mttBrightness;
if ASender = miContrast then
   FTrackType := mttContrast;
if ASender = miSaturation then
   FTrackType := mttSaturation;
DoUpdateTrackBar;
end;

procedure TfrmMain.DoUpdateMPlayer;
begin
case FTrackType of
  mttPosition  : FMPlayer.PercentPosition := FTrackBar.Position;
  mttAudioDelay: FMPlayer.AudioDelay := (FTrackBar.Position * 20 / 100) - 10;
  mttVolume    : FMPlayer.Volume := FTrackBar.Position;
  mttSpeed     : FMPlayer.Speed := (FTrackBar.Position + 1) / 10;
  mttBrightness: FMPlayer.Brightness := FTrackBar.Position * 2 - 100;
  mttContrast  : FMPlayer.Contrast := FTrackBar.Position * 2 - 100;
  mttSaturation: FMPlayer.Saturation := FTrackBar.Position * 2 - 100;
  end;
end;

procedure TfrmMain.DoUpdateTimers;
var
 pval,tcs,tc_clk,str: String;
 secpos,sec: Real;
 tc_offset: Integer;
 tc_in,tc_out,cname,tc_cname: String;
 rt,frms,frms_tot,frmi,frms_tc,tcm: Integer;
 addLog,getInfo: Boolean;
begin

 //UpdateTimers trigges via ActionManagerOnTimer.
 //Av ukjent �rsak er inetrvallet 1 sekund

 addLog :=FALSE;
 getInfo :=FALSE;

 if isUpdateInhibit() then
 begin
  rt :=0;
  exit;
 end;


 if not TCfileTimer.Enabled then
  btnSetTCinn.Transparent :=(TCinn.text<>TC_NULL);

 if not TCfileTimer.Enabled then
  btnSetTCut.Transparent :=(TCut.text<>TC_NULL);

 //pval :=getMediaProp(ID_PARAM_AUDIO);

 //getMediaProps();

 //tc_offset :=round(getTcClockOffset()*VIDEO_FRAME_RATE);

 //tc_offset :=getTcClockOffset();

 secpos :=FMPlayer.TimePosition;
 //PRV_player_pos :=secpos;

 if (secpos>0) and (PRV_get_media_info) then
 begin

  if getMediaInfo()>=0 then
  begin

   PRV_get_media_info :=FALSE;   //bare en gang

   frms_tot :=unitFrm.deciTimeToFrames(FMPlayer.SecsLength);

   sts.Panels.Items[1].Text :=unitFrm.FramesTo_TC(frms_tot,TRUE);
   sts.Panels.Items[3].Text :=PRV_media_filename;

   getInfo :=TRUE;
  end;

 end;


 //resett frameTimer til 0 for hvert nytt sekund
 if (PRV_last_sec<>trunc(secpos)) or (getInfo) then
 begin
  //addLog :=TRUE;

  frmi :=PRV_TC_frames;
  PRV_last_sec :=trunc(secpos);

  //Korriger for start fordi f�rste skifte fra 0 til 1 sekund
  //kan komme f�r antall frames er 25
  if (getInfo) OR
   ((trunc(secpos)=1) AND (PRV_TC_tot_frames<VIDEO_FRAME_RATE)) then
  begin                                          //+2 pga. forsinkelse

   if PRV_TC_tot_frames>VIDEO_FRAME_RATE then
    tcm :=PRV_TC_tot_frames mod VIDEO_FRAME_RATE
   else
    tcm :=PRV_TC_tot_frames;

   PRV_TC_start_offset :=(tcm+frmi)+2;

   rt :=0;
   //secpos :=unitFRm.framesToDeciTime(frmi);
   //setTCframes(PRV_TC_tot_frames);
  end;

   setTCframes(0);

    //pnlRecInhibit.Visible :=not pnlRecInhibit.Visible;
 end;


 //Finn eventuell start_time i filen.
 //Det m� korrigeres for denne i visning av tid p� tidslinjen
 //if (secpos>(1/VIDEO_FRAME_RATE)) and (PRV_get_media_info) then



  //Posisjon fra null korrigert for start_time i filen
  frms :=unitFrm.deciTimeToFrames(secpos)-(PRV_TC_media_offset-PRV_frame_offset);

  tc_offset :=getTCclockOffset();


  frms_tc :=(frms+tc_offset)-PRV_TC_start_offset;
  if frms_tc<0 then
   frms_tc :=0;


  tcs :=unitFrm.FramesTo_TC(frms_tc,TRUE);

 //if not PRV_clock_inhibit then
  setTCclock(tcs);
 //else
 // rt :=0;
                              //Aktuell posisjon fra 0, ikke fra tc_offset
  sts.Panels.Items[0].Text := unitFrm.FramesTo_TC(frms,TRUE);//TimeToStr(SecsToDateTime(secpos)); //+ ' ' + intToStr(tc_offset);

 if addLog then
  tcMem.Lines.add(format('TC:%s Frame:%d',[tcs,frmi]));


 if ((secpos+1)>=FMPlayer.SecsLength) AND (FMPlayer.SecsLength>0) then
  if not FMplayer.Paused then
   doPause(self);

 {
  if (PRV_start_analyze) AND (FMPlayer.SecsLength>0) then
   getDifStat(90,SET_)
  else
  if PRV_analyze then
   PRV_stat_pos_dif :=getDifStat(0,GET_);
 }

 //application.processMessages;

   //Sjekk om det skal legges inn offset
  //tc_offset :=round(getTCclockOffset()*VIDEO_FRAME_RATE);

end;

procedure TfrmMain.DoUpdateTrackBar;
begin
case FTrackType of
   mttPosition   : FTrackBar.Position := FMPlayer.PercentPosition;
   mttAudioDelay : FTrackBar.Position := Round((FMPlayer.AudioDelay + 10) * 100 / 20);
   mttVolume     : FTrackBar.Position := Round(FMPlayer.Volume);
   mttSpeed      : FTrackBar.Position := Round(FMPlayer.Speed * 10 - 1);
   mttBrightness : FTrackBar.Position := (FMPlayer.Brightness + 100) div 2;
   mttContrast   : FTrackBar.Position := (FMPlayer.Contrast + 100) div 2;
   mttSaturation : FTrackBar.Position := (FMPlayer.Saturation + 100) div 2;
   end;
end;

procedure TfrmMain.Do_Close(ASender: TObject);
begin
Close;
end;

function TfrmMain.GetCustomizedFile: string;
begin
Result := ExtractFileDir(Application.ExeName) + PathDelim + 'custom.dat';
end;

function TfrmMain.GetMPlayer: TMPlayer;
begin
Result := FMPlayer;
end;

function TfrmMain.GetNativeHeight: integer;
var
   I: integer;
begin
Result := - 1;
if not FMPlayer.Active then
 Exit;

 I := FMPlayer.MediaPropList.IndexOf('VIDEONATIVE_HEIGHT');
 
if I < 0 then Exit;
try
Result := StrToInt(FMPlayer.MediaPropList.PropValues[I]);
   except
   end;
end;

function TfrmMain.GetNativeSize: boolean;
begin
Result := FNativeSize;
end;

function TfrmMain.GetNativeWidth: integer;
var
   I: integer;
begin
Result := - 1;
if not FMPlayer.Active then
 Exit;

 I := FMPlayer.MediaPropList.IndexOf('VIDEONATIVE_WIDTH');
if I < 0 then Exit;
try
Result := StrToInt(FMPlayer.MediaPropList.PropValues[I]);
   except
   end;
end;

procedure TfrmMain.LoadCustomizedFile;
begin
ActionManager.FileName := GetCustomizedFile;

try
ActionManager.LoadFromFile(ActionManager.FileName);

   except
   end;
end;

procedure TfrmMain.SaveCustomizedFile;
begin
ActionManager.FileName := GetCustomizedFile;
try
ActionManager.SaveToFile(ActionManager.FileName);

   except
   end;
end;

function TfrmMain.SecsToDateTime(const ASeconds: real): TDateTime;
const
   SecsByMin = 60;
   SecsByHour = SecsByMin * 60;
var
   SCount: integer;
   Hours, Mins, Secs: word;
begin

SCount := Round(ASeconds);
Hours := SCount div SecsByHour;
SCount := SCount - Hours * SecsByHour;
Mins := SCount div SecsByMin;
Secs := SCount - Mins * SecsByMin;

Result := EncodeTime(Hours, Mins, Secs, 0);

end;

procedure TfrmMain.SetNativeSize(const ANativeSize: boolean);
begin
if ANativeSize = FNativeSize then Exit;
FNativeSize := ANativeSize;
if FMPlayer.Active then
   begin
   FNativeSize := true;
   DoSetSize;
   end;
end;

procedure TfrmMain.btnSetTCinnClick(Sender: TObject);
begin

 TCinn.text :=getTCclock();
 writeTCfile(PRV_media_filename,TCinn.Text,TCut.Text);
end;

procedure TfrmMain.btnSetTCutClick(Sender: TObject);
begin

 TCut.text :=getTCclock();
 writeTCfile(PRV_media_filename,TCinn.Text,TCut.Text);

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  //FMplayer.active :=FALSE;

  stopPlayer();

  iniParams(frmMain,WRITE_);

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  //iniWinPos(frmMain,READ_);

end;

function TfrmMain.gotoTC(tcs: String; corr: Boolean): Integer;
var
 rt,totsec,sec,prcpos,frms,frms_tc,tc_offset: Integer;
 secpos,sps,deci_sec,len_corr,sec_tot,sps_prc: Real;
 tcs_seek,tc_clk,str: String;
begin

 PRV_recue_cnt :=0;

 if (not FMplayer.Active) then
  exit;


 setBtnStats(FALSE);

 stopFrameTimer();

 if tcs=NUL then
   exit;

  //OBS: denne er null ved oppstart ! 
  sec_tot :=FMplayer.SecsLength; //Totaltid

 {
  if sec_tot=0 then
  begin
   rt :=0;
   exit;
  end;
 }
  txtCue.Visible :=TRUE;

  tc_offset :=getTCclockOffset();

  frms_tc :=unitFrm.TC_toFrames(tcs);

  frms :=frms_tc-tc_offset;

  PRV_seek_frms :=frms;

  sps :=unitFrm.framesToDeciTime(frms);

  tcs_seek :=unitFrm.FramesTo_TC(frms,TRUE);

  //sps :=sps - sps/60;  //usikkert hvorfor ...

  if (sps>sec_tot) and (sec_tot>0) then
  begin
   sps :=sec_tot;
  end;

  FMPlayer.sendSeek(0,TRUE);  //Til start

  //sleep(250);
  //FMplayer.Paused :=TRUE;

  //pga. forsinkelse i visning av TC
  //sps :=sps-(TC_CLOCK_DELAY);

  //sps :=sps -(sps/(60));  //Fungerer ikke

  if sps<0 then
   sps :=0;

  //FMPlayer.TimePosition :=sps;  //samme un�yaktighet som sendSeek()

  if sps>0 then
   FMPlayer.sendSeek(sps,FALSE); //kan bomme med mange sekunder

  {
  frms :=unitFrm.deciTimeToFrames(sps)+getTcclockOffset();

  tcs_seek :=unitFrm.FramesTo_TC(frms,TRUE);

  setTCclock(tcs_seek);
  }
{
  secpos :=FMPlayer.TimePosition;       //+12 pga. offsetfeil i TLMDclock
 //PRV_player_pos :=secpos;

 //frms :=(secpos*VIDEO_FRAME_RATE); //TC_CLOCK_OFFSET);

 frms :=unitFrm.deciTimeToFrames(secpos)-(PRV_TC_media_offset+PRV_PB_offset_frames);

 //frms :=unitFrm.deciTimeToFrames(secpos)-(PRV_TC_media_offset);

 tc_offset :=getTCclockOffset();
 //tcso :=unitFrm.TC_add_frames(tcs,tc_offset);

 tcs_seek :=unitFrm.FramesTo_TC(round(frms+tc_offset),TRUE);

 //if not PRV_clock_inhibit then
 setTCclock(tcs_seek);
}

  //sleep(250);
  //doUpdateTimers();

  //str :=unitFrm.TC_add_frames(tcs,-round((PRV_preroll*VIDEO_FRAME_RATE)));

  //setTcClock(str);
  //application.ProcessMessages;

  //sendSeek() feiler avhengig av koding og lengde
  //Korreksjon starter etter 750 ms slik at alle tider er oppdatert f�r korr.

 PRV_skip_cue_error :=FALSE;
 //PRV_cue_corr :=TRUE;

 //pga. forsinkelse i mplayer, er det ikke kjent hvor mye sendSeek() bommer med.
 //Derfor m� korreksjonen gj�res 1 sekund seinere n�r alle posisjoner er oppdaterte
 if corr then
  setCorrectionTimer(CORR_INTERVAL_CUE,TRUE);   //trigger correctCueOffset();

  //correctionTimer.Enabled :=TRUE;  //trigger correctCueOffset();

end;

function TfrmMain.gotoPos(sps: Real): Integer;
var
 ps: Real;
begin

 if (not FMplayer.Active) then
  exit;

  FMPlayer.sendSeek(0,TRUE);  //Til start

  //FMPlayer.sendSeek(prcpos,TRUE);

  //ps :=sps/100;

  //FMPlayer.timePosition :=sps;
  FMPlayer.sendSeek(sps,FALSE);

  if not FMplayer.Paused then
   doPause(self);

end;


procedure TfrmMain.timePosDblClick(Sender: TObject);
begin

// gotoPos(strToFloatDef(timePos.text,0));
end;

procedure TfrmMain.btnGetAudioPropClick(Sender: TObject);
var
 frms: Integer;
begin

//Fmplayer.Params :='-ac ffwmav2 -ao win32 -channels 2 -stereo 0';
//Fmplayer.Params :='-aid 2 -af channels=2 -stereo 0';
 PRV_player_pos :=FMplayer.TimePosition;
 PRV_audio_param :=getMediaProp(ID_PARAM_AUDIO);


 PRV_player_TC :=getTCclock();
 frms :=unitFrm.TC_toFrames(PRV_player_TC);
 PRV_player_TC :=unitFrm.FramesTo_TC(frms-VIDEO_FRAME_RATE,TRUE);

 if PRV_audio_param<>NUL then
 begin
  stopPlayer();
  paramTimer.Enabled :=TRUE;
 end; 

{
  FMPlayer.sendSeek(0,TRUE);  //Til start

  //FMPlayer.sendSeek(prcpos,TRUE);

  //ps :=sps/100;

  //FMPlayer.timePosition :=sps;
  FMPlayer.sendSeek(FMPlayer.SecsLength-1,FALSE);

  if not FMplayer.Paused then
   doPause(self);
}
end;

procedure TfrmMain.btnGotoTCinnClick(Sender: TObject);
begin

  gotoTC(TCinn.text,TRUE);

  PRV_cue_point :=CUE_ENTRY;

end;

procedure TfrmMain.correctionTimerTimer(Sender: TObject);
begin

 //correctionTimer.Enabled :=FALSE;

 setCorrectionTimer(CORR_INTERVAL_CUE,FALSE);

 correctCueOffset(getCueTC(PRV_cue_point));

end;


procedure TfrmMain.stepTCframe(frmi,fval: Integer);
var
 frms: Integer;
begin

 frms :=PRV_TC_frames;

 if (fval>=0) AND (fval<VIDEO_FRAME_RATE) then
  frms :=fval
 else
  frms :=frms+frmi;


 if frms>=(VIDEO_FRAME_RATE) then
 begin
  frms :=0;
  stepTCclock(1);
 end
 else
 if frms<0 then
 begin
  frms :=VIDEO_FRAME_RATE-1;
  stepTCclock(-1);
 end;


 setTCframes(frms);
 displayTCframes();

 frameLED.Value :=frms;

end;


procedure TfrmMain.displayTCframes;
var
 frms: String;
begin


  case PRV_TC_frames of
   0: frms :='00';

   1: frms :='01';
   2: frms :='02';
   3: frms :='03';
   4: frms :='04';
   5: frms :='05';
   6: frms :='06';
   7: frms :='07';
   8: frms :='08';
   9: frms :='09';

   10: frms :='10';
   11: frms :='11';
   12: frms :='12';
   13: frms :='13';
   14: frms :='14';
   15: frms :='15';
   16: frms :='16';
   17: frms :='17';
   18: frms :='18';
   19: frms :='19';

   20: frms :='20';
   21: frms :='21';
   22: frms :='22';
   23: frms :='23';
   24:
    frms :='24';

  else
   frms :='..';

  end;

  frameLed.Caption :=frms;

end;

procedure TfrmMain.frameTimerTimer(Sender: TObject);
begin

   stepTCframe(1,-1);

   inc(PRV_TC_tot_frames);

  //Dette er cue punktet for framematch hvis PRV_stop_TC har verdi 
  if PRV_stop_TC<>NUL then
   stopOnTC(getStopTC());

end;


procedure TfrmMain.startFrameTimer;
begin

 setTCframes(0);
 frameTimer.enabled :=TRUE;
end;


procedure TfrmMain.stopFrameTimer;
begin
 frameTimer.enabled :=FALSE;
end;

procedure TfrmMain.setTCframes(frms: Integer);
var
 rt: Integer;
 tcs: String;
begin

 if (frms<0) or (frms>VIDEO_FRAME_RATE) then
  PRV_TC_frames :=0
 else
  PRV_TC_frames :=frms;

// displayTCframes();

end;


procedure TfrmMain.frameLEDDblClick(Sender: TObject);
begin
 frameTimer.Enabled :=not frameTimer.Enabled;
end;

procedure TfrmMain.btnFrameStepClick(Sender: TObject);
begin

DoFrameStep(sender);

end;


procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin


 //if PRV_operate_inhibit then
 // exit;

try
 case key of
  VK_PRIOR,VK_NEXT: //,VK_LEFT,VK_RIGHT:
  if not FtrackBar.Focused then
   FtrackBar.SetFocus();

 end;

except
//
end;


 if (key=VK_SPACE) OR (key=VK_K) then
 begin

   //actionmanager.ExecuteAction(ctnPause);
  //ctnPauseOnExecute(sender);
   setStopTC(NUL);

   playPause(0);


 end
 else
 if key =VK_F then
 begin

  if shift=[] then
   DoFrameDropToogle(sender);


 end
 else
 if key =VK_I then
 begin

  if shift=[] then
   btnSetTCinnClick(sender)
  else
  if shift  = [ssShift] then
   btnGotoTCinnClick(sender);


 end
 else
 if key =VK_O then
 begin

  if shift=[] then
   btnSetTCutClick(sender)
  else
  if shift  = [ssShift] then
   btnGotoTCutClick(sender);



 end
 else
 if key =VK_K then
  DoSpeedDef(sender)
 else
 if key =VK_J then
  doBack10(sender) //DoSpeedDec(sender)
 else
 {
 if key =VK_L then
 begin
  doForward10(sender); //DoSpeedInc(sender);

  if FMplayer.Paused then
   doPlay(sender);

 end
 else
 }
 if key =VK_N then
  btnStepFrameRewClick(Sender)
 else
 if key =VK_M then
  doFrameStep(sender)
 else
 if key =VK_P then
 begin

  if shift=[] then
   startPlayer();

 end
 else
 if key =VK_S then
 begin

  if shift=[] then
   stopPlayer();

 end
 else
 if key=VK_HOME then
 begin
   gotoStart();
 end
 else
 if key=VK_END then
 begin
   gotoEnd();  //Fungerer ikke ...
 end;


  {
 else
 if key =VK_PRIOR then
  doBack60(sender)
 else
 if key =VK_NEXT then
 begin

  if FMplayer.TimePosition<FMplayer.SecsLength-60 then
   doForward60(sender);

 end
 else
 if (key=VK_UP) OR (key=VK_DOWN) then
  abort
 else
 if key=VK_LEFT then
  DoUpdateMPlayer() //doBack01(sender)  //fungerer d�rlig
 else
 if key=VK_RIGHT then
  DoUpdateMPlayer(); //doForward01(sender);
 }

end;

procedure TfrmMain.pnlBottomClick(Sender: TObject);
begin

 FTrackBar.setFocus();

 frameTimer.Enabled :=TRUE;
end;

function TfrmMain.startPlayer: Boolean;
var
 str: String;
begin

 //if not FMplayer.active then
 // applyParams();

 //Sjekk om mediafilen finnes
 if not fileExists(PRV_media_filename) then
 begin
  //FMplayer.Active :=FALSE;

  setTCclock(TIME_00);

  unitFrm.msgDlg(format('Finner ikke %s',[PRV_media_filename]),INFO_);

  Result :=FALSE;
  exit;
 end
 else
 begin
{
 if not ctnStop.Enabled then
 begin
  setTCclock(TIME_00);
  stopFrameTimer();
  displayTCframes();
 end
}

  //startFrameTimer();
  
  FMplayer.Active :=TRUE;
  //TCfileTimer.enabled :=TRUE;
  playerTimer.enabled :=TRUE;


  imgBtnPause.Visible :=FALSE;
  imgBtnStop.Visible :=FALSE;


  playPause(PLAY_);


{
  str :=getMediaProp(ID_PARAM_MEDIA_START);

  if str<>NUl then
   PRV_start_time :=unitFrm.strTimeToTC(str);
}

  Result :=TRUE;
 end;

 {
 idx :=FMplayer.MediaPropList.IndexOf('AUDIO_ID');

 if idx>=0 then
  pval :=FMplayer.MediaPropList.PropValues[idx];
 }

end;

procedure TfrmMain.stopPlayer;
begin


 txtCue.Visible :=FALSE;

 setBtnStats(TRUE);

 imgBtnStop.Visible :=TRUE;
 imgBtnPause.Visible :=TRUE;

 PRV_playing :=FALSE;

 //TCfileTimer.enabled :=FALSE;


 FMplayer.Active :=FALSE;

 playerTimer.enabled :=FALSE;

 //PRV_TC_sec :=0;
 PRV_TC_tot_frames :=0;
 PRV_TC_start_offset :=0;
 PRV_last_sec :=0;


 stopFrameTimer();

 //setTCclockOffset(TIME_00,0);  //Nei, bare n�r nye filer hentes

 setTCclock(TC_NULL);
 setTCframes(0);
 setStopTC(NUL);

 displayTCframes();


 sts.Panels.Items[0].Text :=TIME_00;
 sts.Panels.Items[1].Text :=TIME_00;
 sts.Panels.Items[2].Text :=NUL;

 btnSetTCinn.Font.Color :=clBlack;
 btnSetTCut.Font.Color :=clBlack;


end;

function TfrmMain.getMediaProp(plbl: String): String;
var
 cx,idx,cnt: Integer;
 str,pval,ptxt: String;
begin

 pval :=NUL;
 Result :=pval;
 if trim(plbl)=NUL then
  exit;

try

 cnt :=FMplayer.MediaPropList.count;

 for cx :=0 to pred(cnt) do
 begin
  ptxt :=FMplayer.MediaPropList.PropLabels[cx];

  //str :=FMplayer.MediaPropList.PropLabelValues

  if ptxt=plbl then
  begin
   pval :=FMplayer.MediaPropList.PropValues[cx];
   break;
  end;

 end;

except
 //
end;

 Result :=pval;
end;

procedure TfrmMain.paramTimerTimer(Sender: TObject);
begin

 applyParams(PRV_audio_param,RESTART_);
 paramTimer.Enabled :=FALSE;

 playPause(PLAY_);
end;

function TfrmMain.getLocalParams: String;
begin

 Result :=PRV_params; //fra ini fil
end;

procedure TfrmMain.setLocalParams(prms: String);
begin

 PRV_params :=prms;
end;

procedure TfrmMain.btnScreenshotClick(Sender: TObject);
begin

 if FMplayer.active then
  FMplayer.SendGrabFrames();

end;

procedure TfrmMain.TCfileTimerTimer(Sender: TObject);
var
 tc_in,tc_out,cname,tc_cname: String;
 rt: Integer;
begin

{
 if btnSetTCinn.Font.Color =clBlack then
   btnSetTCinn.Font.Color :=clGray
 else
   btnSetTCinn.Font.Color :=clBlack;

 if btnSetTCut.Font.Color =clBlack then
   btnSetTCut.Font.Color :=clGray
 else
   btnSetTCut.Font.Color :=clBlack;
 }


  btnSetTCinn.Transparent :=not btnSetTCinn.Transparent;

  btnSetTCut.Transparent :=not btnSetTCut.Transparent;

  //pnlRecInhibit.Visible :=not pnlRecInhibit.Visible;

 cname :=unitFrm.getCleanFilename(PRV_media_filename);

 rt :=readTCdatafile(cname,tc_in,tc_out,tc_cname);

 if rt=1 then
 begin

  if (tc_in<>TC_NULL) and (tc_in<>TC_NULL_HMS) then
   TCinn.Text :=tc_in;

  if (tc_out<>TC_NULL) and (tc_out<>TC_NULL_HMS) then
   TCut.Text :=tc_out;

 end;

end;

procedure TfrmMain.FormDeactivate(Sender: TObject);
begin
 //TCfileTimer.enabled :=TRUE;
end;

procedure TfrmMain.gotoEnd;
var
 tcs: String;
 seekpos: Real;
 frms,tc_offset: Integer;
begin

 seekpos :=FMPlayer.SecsLength*TC_SEEK_PRC/100;

 frms :=unitFrm.deciTimeToFrames(seekpos);

 tc_offset :=getTCclockOffset();

 //tcs :=unitFrm.FramesTo_TC(round(seekpos*VIDEO_FRAME_RATE),TRUE);

 tcs :=unitFrm.FramesTo_TC(frms+tc_offset,TRUE);

 //tcs :=unitFrm.TC_add_frames(tcs,tc_offset);

 PRV_player_TC :=tcs;

 setTCclock(tcs);  //Denne er ikke n�yaktig p� slutten av fila

 sts.Panels.Items[0].Text :=tcs; //PRV_Start_TC;  //start p� fil
 sts.Panels.Items[2].Text :=NUL;

 //gotoTC(tcs);  //fungerer ikke

 FMPlayer.sendSeek(TC_SEEK_PRC,TRUE);

 txtCue.Visible :=FALSE;

end;

procedure TfrmMain.gotoStart;
var
 str,tcs: String;
 frms_offset: Integer;
begin

 //frms_offset :=(getTCclockOffset()+PRV_PB_offset_frames);
 frms_offset :=getTCclockOffset();

 PRV_player_TC :=unitFrm.TC_add_frames(TC_NULL,frms_offset);

 gotoTC(TC_NULL,FALSE);

 //FMplayer.sendSeek(0,TRUE);

 stopFrameTimer();
 PRV_TC_tot_frames :=0;

 //setTCclockOffset(TIME_00,0);  //Nei, bare n�r nye filer hentes

 tcs :=unitFrm.framesTo_TC(frms_offset,TRUE);
 setTCclock(tcs);

 //setTCframes(0);
 setStopTC(NUL);


 //displayTCframes();

{
  str :=getMediaProp(ID_PARAM_MEDIA_START);

  if str<>NUl then
   PRV_start_TC :=unitFrm.format_TC(str,FALSE)
  else
   PRV_start_TC :=TIME_00;
}

 sts.Panels.Items[0].Text :=TC_NULL; //PRV_Start_TC;  //start p� fil
 //sts.Panels.Items[1].Text :=  //tid
 sts.Panels.Items[2].Text :=NUL;

 if not FMplayer.Paused then
  doPause(self);

 PRV_TC_start_offset :=0;
 PRV_last_sec :=0;

 txtCue.Visible :=FALSE;

end;

procedure TfrmMain.FMPlayerTimer(Sender: TObject);
var
 pos_dif,track_pos,prerl: Real;
 str,tcs,tc_clk: String;
 frms,osd_on,osd_lvl,tc_offset,track_frms: Integer;
begin

 //exit;
 //setTrackbarData();

 //DoUpdateTimers();

 //kommer fra seekTimerTimer()
 if PRV_seeking then
 begin

  PRV_seeking :=FALSE;

  tcs :=unitFrm.FramesTo_TC(PRV_seek_frms,TRUE);

  tc_offset :=getTCclockOffset();

  tcs :=unitFrm.TC_add_frames(tcs,tc_offset);

  frms :=unitFrm.deciTimeToFrames(FMPlayer.TimePosition);

  PRV_pos_dif :=unitFrm.framesToDeciTime(frms-PRV_seek_frms);

  if PRV_pos_dif>MAX_POS_DIF then
  begin
   FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"Cue feil"');

   doPause(self);

   exit;
  end;



  str :=floatToStr(PRV_pos_dif);

  tc_clk :=unitFrm.FramesTo_TC(frms,TRUE);

  sts.Panels.Items[0].Text := tc_clk;

 // sts.Panels.Items[2].Text :=str;

  //tcs :=unitFrm.FramesTo_TC(PRV_seek_frms,TRUE);
{
  setUpdateInhbit(FALSE);

  DoUpdateTimers();

  sleep(250);
 }

  prerl :=PRV_preroll + round(PRV_pos_dif);

  if prerl > PRV_preroll*2 then
   prerl :=PRV_preroll*2;


  //if PRV_pos_dif<>0 then
  //begin
   osd_on :=round((PRV_pos_dif*2)*1000);
   //if osd_on>PRV_preroll then
   // osd_on :=2000;

   if osd_on<=0 then
    osd_on :=2000;


   osd_lvl :=1;

   str :=format('%s "%s %s" %d %d',[OSD_SHOW_TXT,'S�ker TC',tcs,osd_on,osd_lvl]);

   FMplayer.SendCommand(str);  //OBS: denne starter av en eller annen grunn play
  //end;

  if PRV_pos_dif<(-(prerl)/2) then
  begin
    setStopTC(tcs);

   doPlay(self);
   //doPause(self);

  end
  else
  begin
   //setUpdateInhbit(FALSE);


  // DoUpdateTimers();
   //tc_clk :=getTcClock();

   //tcmem.lines.add('F�r preroll: '+tc_clk);

   tc_clk :=unitFrm.FramesTo_TC(frms-unitFrm.deciTimeToFrames(PRV_preroll),TRUE);

   //OBS: denne stopper p� f�rste keyframe bakover
   //FMplayer.SendSeek(-(prerl),FALSE);

   setStopTC(tcs);

   setTCclock(tc_clk);

 {
   DoUpdateTimers();
   sleep(250);

   tc_clk :=getTcClock();
  }
 {
  track_pos :=FMplayer.timePosition;

  track_frms :=unitFrm.deciTimeToFrames(track_pos);

   tc_clk :=unitFrm.FramesTo_TC(track_frms,TRUE);
 }


  // application.ProcessMessages;


  // if not FMplayer.Paused then
  //  doPause(self);


   //tc_clk :=getTcClock();
   //tcmem.lines.add('Etter preroll: '+tc_clk);


   //setUpdateInhbit(FALSE);

   doPlay(self);
   //doPause(self);

  end;


  PRV_seek_frms :=0;
 end;

end;

procedure TfrmMain.btnTestClick(Sender: TObject);
var
 track_pos: Real;
 frms,cx,cnt: Integer;
begin

 track_pos :=getDifStat(95,SET_);


 {
  getMediaInfo();

  setTcClockOffset(NUL,PRV_TC_offset);


  //FMPlayer.SendOsdToogle;
  //FMplayer.OsdLevel :=2;

  //FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"S�ker TC ..."' + ' ');

  //FMplayer.SendOsd(1);
  FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"S�ker TC ..."' + ' ' +'2000 1');

  exit;
 }

 {
  for cx :=1 to 25 do
  begin
    DoFrameStep(Sender);  //Eksakt 1 sekund
  end;
 }

{
  track_pos :=FMplayer.TimePosition;
  //FMplayer.sendSeek(0,TRUE);


  //Forbi siste I frame
  FMplayer.sendSeek(-PREROLL_FRAMES/VIDEO_FRAME_RATE,FALSE);

  PRV_seeking :=TRUE;

  //doPause(sender);

  //if (PRV_pos_dif<>0) and (track_pos>PRV_pos_dif) then
  //begin
   //doPlay(sender);
   //FMplayer.sendSeek(PRV_pos_dif,FALSE);
   //doPause(sender);
  //end;

}

end;

function TfrmMain.stopOnTC(tcs: String): Integer;
var
 fdif,frms_clk,frms_tc,tc_offset: Integer;
 tc_tmp,tc_clk,tc_match,ofs,str: String;
begin
 Result :=0;

 if length(tcs)<length(TC_NULL) then
  exit;

 tc_clk :=getTCclock();

 frms_clk :=unitFrm.TC_toFrames(tc_clk);

 frms_tc :=unitFrm.TC_toFrames(tcs);

 //tc_match :=tcs; //unitFrm.TC_add_frames(tcs,-1);

 //tcmem.lines.add(tc_clk + ' '+ tcs);

 //application.ProcessMessages;

 //if copy(tc_clk,1,8)=copy(tcs,1,8) then
 //if tc_clk=tc_match then

// if PRV_playing then
// begin
  if PRV_TC_frames<>PRV_TC_last_frame then
  begin

   //R�d lampe som indikerer un�yaktig avspilling
   if PRV_TC_frames>=PRV_TC_last_frame+PRV_max_frames_off then
    pnlServo.Visible :=TRUE;

   {
   if PRV_TC_frames>PRV_TC_last_frame+PRV_max_frames_off then
   begin
    FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"Un�yaktig avspilling"');

    txtCue.Visible :=FALSE;
    setTCclock(tc_clk);

    doPause(self);
    Result :=(-1);
   end;
   }
   {
   if PRV_TC_frames>PRV_TC_last_frame+1 then
   begin

   if PRV_TC_last_frame_offset =0 then
   begin
    dec(frms_clk);
    PRV_TC_last_frame_offset :=-1;
   end
   else
    PRV_TC_last_frame_offset :=0;

   end
   else
    PRV_TC_last_frame_offset :=0;
   }

   PRV_TC_last_frame :=PRV_TC_frames;

  end
  else
  begin
   {
   if PRV_TC_last_frame_offset=0 then
   begin
    inc(frms_clk);
    PRV_TC_last_frame_offset :=1;
   end
   else
    PRV_TC_last_frame_offset :=0;
   }

  end;

  //tcMem.Lines.add(format('TC_clk:%s Frame:%d',[tc_clk,frms_clk]));

// end;

 //Avspilling er ikke ruten�yaktig og match m� v�re +/- 1 frame
 if (frms_clk>=frms_tc) AND (frms_clk<=frms_tc+2) then
 begin

  setBtnStats(TRUE);

  setUpdateInhbit(TRUE);

  //doPause(self);

  fdif :=frms_clk-frms_tc;

  //+2 er egentlig bare en pga. avrundingsfeil
  if fdif>1 then
  begin
   tc_clk :=unitFRm.TC_add_frames(tc_clk,-1);
   fdif :=1
  end;
//  else
//   tc_clk :=unitFrm.FramesTo_TC(frms_clk,TRUE);


  setTCclock(tc_clk);


  if fdif<>0 then
  begin

   if fdif>0 then
    ofs :='+'+intToStr(fdif)
   else
    ofs :=intToStr(fdif);

  end
  else
   ofs :=NUL;


  PRV_matchframe_offset :=fdif;

 //  ofs :=NUL;

  str :=format('%s "%s %s" %d %d',[OSD_SHOW_TXT,'Match frame',ofs,2000,1]);
  FMplayer.SendCommand(str);

  //doPause(self);

  playPause(PAUSE_);

  setStopTC(NUL);
  //PRV_clock_inhibit :=FALSE;


  Result :=1;
 end
 else
 if (frms_clk>frms_tc+2) and (not  PRV_skip_cue_error) then
 begin

   tc_offset :=getTCclockOffset();

   //Ikke vis Cue feil p� startet av fila
   //if frms_tc<tc_offset+(PRV_preroll*VIDEO_FRAME_RATE) then
   //begin

    FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"Cue feil"');

   //end;

    txtCue.Visible :=FALSE;

    //tc_clk :=unitFRm.TC_add_frames(tc_clk,-1);

   setTCclock(tc_clk);

   doPause(self);

   Result :=(-1);
 end;


  //setUpdateInhbit(FALSE);
end;

function TfrmMain.getStopTC: String;
begin

 Result :=PRV_stop_TC;
end;

procedure TfrmMain.setStopTC(tcs: String);
begin

  PRV_stop_TC :=tcs;

end;

procedure TfrmMain.upDnRewindClick(Sender: TObject; Button: TUDBtnType);
begin

//type TUDBtnType = (btNext, btPrev);

 if button=btNext then
  inc(PRV_preroll)
 else
 if button=btPrev then
  dec(PRV_preroll);

  setPreroll(PRV_preroll);

end;

procedure TfrmMain.setPreroll(prl: Integer);
begin

 preroll.caption :=intToStr(PRV_preroll);

end;

procedure TfrmMain.btnStepFrameFwdClick(Sender: TObject);
var
 rt,fmt: Real;
begin

 DoFrameStep(sender);

 //sleep(250);

 //fmt :=Fmplayer.TimePosition;

 rt :=0;
end;


procedure TfrmMain.btnStepFrameRewClick(Sender: TObject);
var
 fmt: Real;
 tcs,str: String;
begin

 if not FMplayer.Active then
  exit;

 setBtnStats(FALSE);

 //fmt :=unitFrm.calcFrameTime(FMplayer.SecsLength);

 //stopFrameTimer();

 //stepTCframe(-1,-1);

 //setUpdateInhbit(TRUE);

 tcs :=getTCclock();

 stopFrameTimer();
 //stepTCframe(-1,-1);


 //FMplayer.SendSeek(-(PRV_preroll-1),FALSE);
 FMplayer.SendSeek(-PREROLL_SEC,FALSE);
 //sleep(250);

 //stepTCframe(-1,-1);

 doPlay(self);

 //PRV_matchframe_offset er funnet i stopOnTC() via siste gotoTC()

 if PRV_matchframe_offset<0 then
  PRV_matchframe_offset :=0;

 PRV_stop_TC :=unitFrm.TC_add_frames(tcs,-(PRV_matchframe_offset+1));

 PRV_skip_cue_error :=TRUE;

 str :=format('%s "%s %s" %d %d',[OSD_SHOW_TXT,'Til frame:',
                     PRV_stop_TC,(PREROLL_SEC*1000),1]);
 FMplayer.SendCommand(str);

 //FMplayer.SendSeek(-0.004,FALSE);  //1 rute =40 ms  //fungerer ikke

 
end;

procedure TfrmMain.setBtnStats(stat: Boolean);
begin

 //txtCue.Visible :=not stat;


 //btnVTRstepFrameRew.Enabled :=stat;
 //btnVTRstepFrameFwd.Enabled :=stat;
 //btnGotoTCin.Enabled :=stat;
 //btnGotoTCut.Enabled :=stat;

 //PRV_operate_inhibit :=not stat;

end;



procedure TfrmMain.btnVTRplayClick(Sender: TObject);
begin

 playPause(0);

end;

procedure TfrmMain.playPause(cmd: Integer);
begin

  if ((FMPlayer.Paused) and (cmd<>PAUSE_)) OR (cmd=PLAY_) then
  begin

   imgBtnPause.Visible :=FALSE;
   imgBtnStop.Visible :=FALSE;
   PRV_playing :=TRUE;

   doPlay(self);
  end
  else
  if (cmd=0) OR (cmd=PAUSE_) then
  begin
   imgBtnPause.Visible :=TRUE;
   PRV_playing :=FALSE;
   pnlServo.Visible :=FALSE;

   doPause(self);

  end;

   txtCue.Visible :=FALSE;

   setUpdateInhbit(FMPlayer.Paused);

end;

procedure TfrmMain.btnVTRstopClick(Sender: TObject);
begin
 stopPlayer();
 doPause(sender);
end;

procedure TfrmMain.btnVTRtcInClick(Sender: TObject);
begin
 TCinn.text :=getTCclock();
 writeTCfile(PRV_media_filename,TCinn.Text,TCut.Text);

end;

procedure TfrmMain.btnVTRtcOutClick(Sender: TObject);
begin
 TCut.text :=getTCclock();
 writeTCfile(PRV_media_filename,TCinn.Text,TCut.Text);

end;

procedure TfrmMain.btnVTRstepFrameRewClick(Sender: TObject);
var
 rt,fmt: Real;
 tcs: String;
begin

 if not FMplayer.Active then
  exit;

 setBtnStats(FALSE);

 //fmt :=unitFrm.calcFrameTime(FMplayer.SecsLength);

 //stopFrameTimer();

 //stepTCframe(-1,-1);

 //setUpdateInhbit(TRUE);

 tcs :=getTCclock();

 stopFrameTimer();
 //stepTCframe(-1,-1);


 FMplayer.SendSeek(-(PRV_preroll),FALSE);
 //sleep(250);

 //stepTCframe(-1,-1);

 doPlay(self);

 //PRV_matchframe_offset er funnet i stopOnTC() via siste gotoTC()

 if PRV_matchframe_offset<0 then
  PRV_matchframe_offset :=0;

 PRV_stop_TC :=unitFrm.TC_add_frames(tcs,-(PRV_matchframe_offset+1));

 //FMplayer.SendSeek(-0.004,FALSE);  //1 rute =40 ms  //fungerer ikke

end;

procedure TfrmMain.btnVTRstepFrameFwdClick(Sender: TObject);
var
 fmt: Real;
 tcs: String;
begin


 DoFrameStep(sender);

 //sleep(250);

 //fmt :=Fmplayer.TimePosition;


end;

procedure TfrmMain.btnCueTCinClick(Sender: TObject);
begin

  gotoTC(TCinn.text,TRUE);

  PRV_cue_point :=CUE_ENTRY;

end;

procedure TfrmMain.btnGotoTCutClick(Sender: TObject);
begin
  gotoTC(TCut.text,TRUE);

  PRV_cue_point :=CUE_EXIT;

end;

procedure TfrmMain.btnVTRprerollClick(Sender: TObject);
var
 tcs,tcs_seek: String;
 frms: Integer;
 sps: Real;
begin

 tcs :=getTcClock();

 frms :=round(PRV_preroll*VIDEO_FRAME_RATE);

 tcs_seek :=unitFrm.TC_add_frames(tcs,-frms);

 //setTcClock(tcs_seek);

 //application.ProcessMessages();

 //Bakover til n�rmeste I-frame
 FMplayer.TimePosition :=FMplayer.TimePosition-(PRV_preroll+1);

 //doUpdateTimers();

 //setTcClock(tcs_seek);

 doPause(sender);

end;

procedure TfrmMain.btnVTRrewClick(Sender: TObject);
begin

  //doSpeedDec(sender);

  doBack10(sender); //DoSpeedDec(sender)

  keyTimer.Tag :=REW_;
   //unitFrm.PostKeyEx32(Ord('J'), [], False);

end;

procedure TfrmMain.btnVTRfwdClick(Sender: TObject);
begin
 doForward10(sender);

 //doSpeedInc(sender);

 keyTimer.Tag :=FWD_;

end;

procedure TfrmMain.btnVTReditClick(Sender: TObject);
begin
 FMPlayer.SendFrameDropToogle; //
end;

procedure TfrmMain.btnVTRrecClick(Sender: TObject);
begin

 if FMplayer.active then
  FMplayer.SendGrabFrames();

end;

procedure TfrmMain.btnFilePropertyClick(Sender: TObject);
begin

 FMPlayer.MediaPropListVisible := not FMPlayer.MediaPropListVisible;

end;

procedure TfrmMain.imgBtnStopClick(Sender: TObject);
begin
 stopPlayer()
end;

procedure TfrmMain.btnVTRejectClick(Sender: TObject);
begin

 btnVTRstopClick(sender);
 DoFileOpen(Sender);

end;

procedure TfrmMain.TCinnChange(Sender: TObject);
begin

 if not TCfileTimer.Enabled then
  btnSetTCinn.Transparent :=(TCinn.text<>TC_NULL);

end;

procedure TfrmMain.TCutChange(Sender: TObject);
begin

 if not TCfileTimer.Enabled then
  btnSetTCut.Transparent :=(TCut.text<>TC_NULL);

end;

procedure TfrmMain.btnFullScreenClick(Sender: TObject);
begin
 DoFullScreen(Sender);
end;

procedure TfrmMain.btnVTRrewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 keyTimer.Enabled :=TRUE;
end;

procedure TfrmMain.btnVTRrewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 keyTimer.Enabled :=FALSE;
end;

procedure TfrmMain.btnVTRfwdMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 keyTimer.Enabled :=TRUE;

end;

procedure TfrmMain.btnVTRfwdMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 keyTimer.Enabled :=FALSE;

end;

procedure TfrmMain.keyTimerTimer(Sender: TObject);
begin

 if keyTimer.tag=REW_ then
  doBack10(sender)
 else
 if keyTimer.tag=FWD_ then
  doForward10(sender);

end;

procedure TfrmMain.seekTimerTimer(Sender: TObject);
begin
 PRV_seeking :=TRUE;
 seekTimer.enabled :=FALSE;
end;

procedure TfrmMain.TCinnKeyPress(Sender: TObject; var Key: Char);
begin

 if (unitFrm.isDigit(key)) OR (key=':') OR (key=BS_C) then
  //
 else 
  abort;

end;

procedure TfrmMain.btnVTRjogClick(Sender: TObject);
begin
 doSpeedDef(sender);
end;

procedure TfrmMain.btnVTRvarClick(Sender: TObject);
begin

 doSpeedInc(sender);
end;

function TfrmMain.getDifStat(prc_pos: Integer; cmd: Integer): Real;
var
 track_pos,pos_dif: Real;
 tcs,tcs_track: STring;
 frms,frms_prc,totfrms: Integer;
begin

 Result :=0;

 if not FMplayer.Active then
  exit;

  pos_dif :=0;

  if (cmd=SET_) then
  begin

  PRV_start_analyze :=FALSE;

  totfrms :=round(FMplayer.SecsLength*VIDEO_FRAME_RATE);

  if totfrms=0 then
  begin
   PRV_analyze :=FALSE;
   exit;
  end;

  PRV_prc_frms :=round((totfrms/100)*prc_pos);

  tcs :=unitFrm.FramesTo_TC(frms_prc,TRUE);

  //setUpdateInhbit(TRUE);

  PRV_analyze :=TRUE;

  FMplayer.SendSeek(0,TRUE); //Til start f�rst

  FMplayer.SendSeek(prc_pos,TRUE);

  sleep(250);

  doPlay(self);

  end
  else
  if (cmd=GET_) then
  begin

   PRV_analyze :=FALSE;

   track_pos :=FMplayer.TimePosition;

   frms :=unitFrm.deciTimeToFrames(track_pos);

   tcs_track :=unitFrm.FramesTo_TC(frms,TRUE);

   pos_dif :=unitFrm.framesToDeciTime(frms - PRV_prc_frms);

   sts.Panels.Items[2].Text :=floatToStr(pos_dif);

   //doPause(self);
   FMplayer.SendSeek(0,TRUE); //Til start


  end;


  Result :=pos_dif;
end;



procedure TfrmMain.trimTCinnClick(Sender: TObject; Button: TUDBtnType);
begin


 if button=btNext then
  TCinn.text :=unitFrm.TC_add_Frames(TCinn.text,1)
 else
 if button=btPrev then
  TCinn.text :=unitFrm.TC_add_Frames(TCinn.text,-1);

end;

procedure TfrmMain.trimTCutClick(Sender: TObject; Button: TUDBtnType);
begin

 if button=btNext then
  TCut.text :=unitFrm.TC_add_Frames(TCut.text,1)
 else
 if button=btPrev then
  TCut.text :=unitFrm.TC_add_Frames(TCut.text,-1);

end;

procedure TfrmMain.playerTimerTimer(Sender: TObject);
begin

 //setTrackbarData();

 //Her skjer alle tidskode visninger og oppdateringer
 //DoUpdateTimers();

 pnlRecInhibit.Visible :=not pnlRecInhibit.Visible;
 pnlServo.Visible :=FALSE;
end;

end.
