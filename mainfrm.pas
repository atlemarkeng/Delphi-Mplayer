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
  LMDCustomBevelPanel, LMDBaseEdit, LMDCustomEdit, LMDEdit, JvLED,
  JvComponent;

const
 PRG_NAME ='MediaPlayer';

 TC_DATA_DIR ='C:\XNRK';
 TC_FILE_WRITE ='TC_mdb.txt';
 TC_FILE_READ ='TC_mp.txt';
 TC_IN_FNAME ='TCinn';
 TC_OUT_FNAME ='TCut';
 TC_CLIP_NAME ='ClipName';

 TC_ERROR_GREEN =2;
 TC_ERROR_YELLOW =4;
 TC_ERROR_RED = 8;

 INI_FILE_NAME ='mzplayer.ini';
 INI_SECT ='MPLAYER';
 //TC_CLOCK_DELAY =0.75;
 //PREROLL_FRAMES =150;
 PREROLL_SEC =3;
 PREROLL_DELAY =1.75;

 MAX_POS_DIF   =12;  //Max avvik i søk for å melde 'Cue feil'
 MAX_POS_DIF_RECUE =8; //Max avvik for nytt søk
 MAX_RECUE_CNT =2; //antall søkeforsøk
 MAX_FRAMES_OFF =4; //Maks ruteunøyaktighet før melding

 DEF_WIMD_STEP =1; //Defaiult step ved spoling
 MAX_WIMD_STEP =9; //Defaiult step ved spoling

 TC_REACTION =5;  //5 ruter trekkes hvis in/ut punkt legges i Play
 CUE_ENTRY =1;
 CUE_EXIT =2;

 CORR_INTERVAL_CUE =750; //ms før start av korreksjon
 CORR_INTERVAL_RECUE =500; //ms før start av neste korreksjon

 SET_WIND_SPEED =0;
 STEP_WIND_SPEED =1;

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
    upDnPreroll: TUpDown;
    TCinn: TEdit;
    TCut: TEdit;
    imgVTRbkg: TImage;
    TCled: TLMDLEDLabel;
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
    pnlServo: TPanel;
    tcStartOffset: TLabel;
    flashTimer: TTimer;
    timeLed: TLMDLEDLabel;
    viewTimeClock: TSpeedButton;
    media_offset: TLabel;
    UpDnMediaOffset: TUpDown;
    divFld: TEdit;
    TCledGreen: TJvLED;
    TCledYellow: TJvLED;
    TCledRed: TJvLED;
    TCerrors: TLabel;
    Label1: TLabel;
    tcHiddenFrames: TLabel;
    tcOffsetFrames: TLabel;
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
    procedure TCledDblClick(Sender: TObject);
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
    procedure upDnPrerollClick(Sender: TObject; Button: TUDBtnType);
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
    procedure flashTimerTimer(Sender: TObject);
    procedure tcStartOffsetDblClick(Sender: TObject);
    procedure viewTimeClockClick(Sender: TObject);
    procedure UpDnMediaOffsetClick(Sender: TObject; Button: TUDBtnType);
    procedure media_offsetDblClick(Sender: TObject);
    procedure btnVTRshuttleClick(Sender: TObject);


  private
    { Private declarations }

    PRV_media_filename: String;

    PRV_app_dir: String;
    PRV_work_dir: String;

    PUBints: ARFLDI;  //array med 32 Integer

    PRV_TC_data_dir: String;

    PRV_frame_time: Real; //tid avspilt mellom hver rute
    PRV_frame_offset: Integer;

    PRV_TC_offset: Integer;
    PRV_TC_frames: Integer;
    //PRV_TC_sec: Integer;

    PRV_TC_hidden_frames: Integer;

    PRV_TC_tot_frames: Integer;

    PRV_back_frame : Integer;  //blir 1 ved step bakover

    PRV_TC_last_frame: Integer;
    PRV_max_frames_off: Integer;

    PRV_TC_media_offset: Integer;

    PRV_TC_delay: Integer;

    PRV_seek_frms: Integer;
    PRV_prc_frms: Integer; //brukes av getDifStat();

    PRV_player_pos: Real;
    PRV_player_TC: STring;

    PRV_timer_inhibit : Boolean;

    PRV_last_sec: Real;
    PRV_last_time: Real;
    PRV_last_frms: Integer;

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

    PRV_speed : Integer;

    //PRV_start_TC: String;

    PRV_get_media_info: Boolean;
    PRV_init_media: Boolean;

    PRV_matchframe_offset : Integer;
    PRV_PB_offset_frames : Integer;

    PRV_skip_cue_error: Boolean;

    PRV_analyze: Boolean;
    PRV_start_analyze: Boolean;

    PRV_stat_pos_dif: Real;  //Antall sekunder feil ved søk til 95 prosent

    PRV_playing: Boolean;  //TRUE i normal avspilling

    PRV_timer_counter: Integer;

    PRV_display_log: Boolean;

    //PRV_stop_next_frame: Boolean;

    PRV_TC_errors :Integer;

    PRV_wind_step: Integer;  //Antall sekunder step ved spoling


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
   procedure setTimeClock(tcs: String);

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

   procedure setUpdateEnable(stat: Boolean);

   procedure setUpdateInhbit(stat: Boolean);
   function  isUpdateInhibit: Boolean;

   procedure stepTCframe(frmi,fval: Integer);
   procedure stepTCclock(seci: Integer);
   procedure stepTimeClock(frmi: Integer);


   procedure setTCframes(frms: Integer);
   //procedure displayTCframes;

   procedure startFrameTimer(start_frame: Integer);
   procedure stopFrameTimer;

   function  startPlayer: Boolean;
   procedure stopPlayer(cmd: Integer);


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

   procedure setTCdelay(delay_ms: Integer);

   procedure setMediaOffset(frmi: Integer);

   procedure enableLog;

   procedure displayLog(tcs: String; time_pos: Real);

   procedure setServoStat(colr: Tcolor; stat: Boolean);

   procedure setTCled(errs,cmd: Integer);

   procedure displayTCerror(frms_dif: Integer; msg: String);

   procedure setShuttleSpeed(windStep,cmd: Integer);

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
FTrackBar.Max := 99; //Må være prosent
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

  PRV_get_media_info :=TRUE; //For å hente div infor i play

  //PRV_show_init_data :=TRUE;


  if startPlayer() then
  begin
  //FMPlayer.Active := true;

   tcs :=TCinn.text;

   frms :=unitFrm.TC_toFrames(tcs);

   if frms>0 then
   begin
    //Denne er ikke rutenøkatig
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

procedure TfrmMain.setShuttleSpeed(windStep,cmd: Integer);
begin

 if cmd=SET_WIND_SPEED then
 begin
  PRV_wind_step :=windStep;

 end
 else
 if cmd=STEP_WIND_SPEED then
 begin

   inc(PRV_wind_step);

   if PRV_wind_step>MAX_WIMD_STEP then
    PRV_wind_step :=1;


 end;

  btnVTRshuttle.caption :=intToStr(PRV_wind_step)

end;

procedure TfrmMain.setTCled(errs,cmd: Integer);
begin

 //if cmd=CLEAR_ then
 //begin
  TCledGreen.Status :=FALSE;
  TCledYellow.Status :=FALSE;
  TCledRed.Status :=FALSE;
 //end

 if cmd=SET_ then
 begin
 //TC_ERROR_GREEN =2;
 //TC_ERROR_YELLOW =4;
 //TC_ERROR_RED = 8;

  if (errs>=0) and (errs<=TC_ERROR_GREEN) then
  begin
   TCledGreen.Status :=TRUE;
   TCledYellow.Status :=FALSE;
   TCledRed.Status :=FALSE;

  end
  else
  if (errs>TC_ERROR_GREEN) and (errs<=TC_ERROR_YELLOW) then
  begin
   TCledGreen.Status :=FALSE;
   TCledYellow.Status :=TRUE;
   TCledRed.Status :=FALSE;

  end
  else
  if (errs<0) OR (errs>TC_ERROR_YELLOW) then
  begin
   TCledGreen.Status :=FALSE;
   TCledYellow.Status :=FALSE;
   TCledRed.Status :=TRUE;

  end;

 end;

   PRV_TC_errors :=0;
   TCerrors.caption :=intToStr(PRV_TC_errors);

end;

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
FTrackBar.Max := 99; //Må være prosent
FTrackBar.OnKeyUp := DoTrackBarKeyUp;
FTrackBar.OnMouseUp := DoTrackBarMouseUp;
FTrackBar.PopupMenu := pppTrackBar;

 PRV_get_media_info :=FALSE;
 PRV_init_media :=FALSE;

 PRV_app_dir :=ExtractFileDir(paramStr(0));


 FMPlayer.mplayerPath :=PRV_app_dir;

 iniParams(frmMain,READ_);

 typFrm.setLocaleFormats(NUL);

 setPreroll(PRV_preroll);

 setTCled(-1,CLEAR_);

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

  PRV_get_media_info :=TRUE; //For å hente div infor i play
  PRV_init_media :=TRUE;

  if startPlayer() then
  begin

   //Framedrop =disabled kommer et to klikk ved første oppstart
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

    gotoStart();
  
    sleep(CORR_INTERVAL_RECUE);

    dec(PRV_TC_tot_frames);  //Pga. delay

    playPause(PLAY_);

   end;

   TCfileTimer.enabled :=TRUE;

  end;
 end;

 //setTcFrames(0); //PRV_TC_frames :=0;

 setUpdateInhbit(FALSE);

 PRV_pos_dif :=0;

 PRV_skip_cue_error :=FALSE;
 //PRV_cue_corr :=FALSE;

 PRV_analyze :=FALSE;
 PRV_start_analyze :=FALSE;

 PRV_prc_frms :=0;
 PRV_stat_pos_dif :=0;

 PRV_recue_cnt :=0;
 PRV_timer_counter :=0;

 PRV_display_log :=FALSE;

 PRV_seeking :=FALSE;
 PRV_frame_time :=0;
 PRV_back_frame :=0;

 PRV_speed :=0;

 setShuttleSpeed(PRV_wind_step,SET_WIND_SPEED);

 //PRV_stop_next_frame :=FALSE;

 //PRV_TC_errors :=0;

 //enableLog();

end;


procedure TfrmMain.FormDestroy(Sender: TObject);
begin

stopPlayer(0);
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

procedure TfrmMain.setTCdelay(delay_ms: Integer);
begin

 if delay_ms=0 then
  PRV_TC_delay :=0
 else
  PRV_TC_delay :=unitFrm.deciTimeToFrames((delay_ms/1000),0);


 //PRV_TC_delay :=delay_frms;

 TcStartOffset.caption :=format('%d',[PRV_TC_delay]);

end;

function TfrmMain.getMediaInfo: Integer;
var
 str,tcs: String;
 start_offset: Real;
 dtm: TdateTime;
 rt,moffset: Integer;
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

   moffset :=unitFrm.deciTimeToFrames(start_offset,0);

   setMediaOffset(moffset);

   //PRV_TC_media_offset :=0;

   //PRV_start_TC :=unitFrm.FramesTo_TC(PRV_TC_media_offset,TRUE);

   rt :=0;
  end
  else
  begin
   //PRV_start_TC :=TIME_00;
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
  exit  //Kan ikke legge på params i play
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

  //PRV_last_time :=PRV_player_pos;

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

 //For at doUpdateTimers() ikke skal flytte på tiden
  setUpdateInhbit(TRUE);  //Må være her ellers kan søk låse seg

  tc_offset :=getTCclockOffset();

  track_pos :=FMplayer.timePosition;

 frms :=unitFrm.TC_toFrames(tc_seek);

 track_frms :=unitFrm.deciTimeToFrames(track_pos,0);

 frms :=frms-tc_offset;

 seek_pos :=unitFrm.framesToDeciTime(frms);

 if track_pos=0 then   //Ikke oppdatert
  track_pos :=seek_pos;

 pos_dif :=(seek_pos-track_pos);

 sts.Panels.Items[2].Text :=format('%.2f (%d)',[pos_dif,PRV_recue_cnt]); //floatToStr(pos_dif);

 if pos_dif=0 then
 begin

  //Selv om pos_dif=0 kan posisjonen være på feil sted i forhold til TC
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

   FMPlayer.sendSeek((pos_dif-(PRV_preroll/2)),FALSE);

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
  //Gjør nytt søk hvis feilen er for stor

   inc(PRV_recue_cnt);

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

   //seekTimer.enabled :=TRUE;  //usikkert om det er nødvendig å gå via denne timeren

   PRV_seeking :=TRUE;  //Gjør at FMplayerTimer cuer til eksakt frame

   PRV_recue_cnt :=0;
   PRV_cue_point :=0;

   setUpdateInhbit(FALSE);  //Usikkert om denne er nødvendig


  {  //Usikkert hvorfor denne koden ikke kan ligger her og må ligge
     //i FMplayerTimer. Testet, men fungerer ikke.
     //Sannsynligvis noe å gjøre med at klokketidene ikke er oppdatert.
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

   str :=format('%s "%s %s" %d %d',[OSD_SHOW_TXT,'Søker TC',tcs,osd_on,osd_lvl]);

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

   //tcmem.lines.add('Før preroll: '+tc_clk);

   tc_clk :=unitFrm.FramesTo_TC(frms-unitFrm.deciTimeToFrames(PRV_preroll),TRUE);

   //OBS: denne stopper på første keyframe bakover
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

  iniFil.writeInteger(INI_SECT,'wind_step',PRV_wind_step);

 except
  Result :=ERROR_;
  exit;
 end;

end;


if cmd = READ_ then
begin
 defStr :='10,10,500,700';    //Default størrelse hvis INI-data mangler

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

 PRV_wind_step :=iniFil.readInteger(INI_SECT,'wind_step',DEF_WIMD_STEP);

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



 //Sjekk om dette tilhører valgt klipp
 if AnsiCompareText(cname,tc_cname)=0 then
 begin
  tc_in :=trim(copy(str,(ps_in+length(TC_IN_FNAME)+1),TC_LEN_F));
  tc_out :=trim(copy(str,(ps_out+length(TC_OUT_FNAME)+1),TC_LEN_F));

  //Slett filen slik at den ike leses før MediaDB har laget ny

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

  frms :=unitFrm.deciTimeToFrames(seci,0);

  tcs :=unitFrm.TC_add_frames(tcs,frms);

  setTCclock(tcs);

  {
  unitFrm.encodeTCdate(tcs,hr,mn,sc,frms);

  TCclock.FixedTime.Hour :=hr;
  TCclock.FixedTime.Minute :=mn;
  TCclock.FixedTime.second :=sc;
  }

end;

procedure TfrmMain.setTimeClock(tcs: String);
var
 str: String;
begin

 if not timeLed.Visible then
  exit;


 if trim(tcs)=NUL then
  str :=TC_NULL
 else
  str :=tcs;

 timeLed.caption :=str;  


end;


procedure TfrmMain.setTCclock(tcs: String);
var
 hr,mn,sc,frms,tc_offset: Integer;
 tcstr: String;
begin


 if not FMPlayer.Active then
 begin
   tcstr :=TC_NULL;

   stopFrameTimer();
   setTCframes(0);
   //displayTCframes();

 end
 else
  tcstr :=tcs;

  {
  unitFrm.encodeTCdate(tcs,hr,mn,sc,frms);

  TCclock.FixedTime.Hour :=hr;
  TCclock.FixedTime.Minute :=mn;
  TCclock.FixedTime.second :=sc;

  setTCframes(frms);
  displayTCframes();
  }

  TCled.Caption :=tcStr;

  application.processMessages();

end;

function TfrmMain.getTCclock: String;
var
 hr,mn,sc,frms,tc_offset: Integer;
 tcs: String;
begin

 {
 hr :=TCclock.FixedTime.Hour;
 mn :=TCclock.FixedTime.Minute;
 sc :=TCclock.FixedTime.Second;

 tcs :=unitFrm.encodeTCstr(hr,mn,sc,PRV_TC_frames);

 if not FMplayer.paused then
 begin
  //tcs :=unitFrm.TC_add_frames(tcs,round(-TC_CLOCK_DELAY));
 end;
 }

 tcs :=TCled.Caption;

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

 //Av ukjent årsak trigges denne hvert sekund, men bare dersom ActionManager er
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

// setTrackbarData();

 //Her skjer alle tidskode visninger og oppdateringer
 //Forsøk på å flytte denne til playerTimer fører til dårligere presisjon
// DoUpdateTimers();

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

 FMPlayer.SendSeek(- 1, false);

 setUpdateEnable(TRUE);

end;

procedure TfrmMain.DoBack10(ASender: TObject);
begin
if not FMPlayer.Active then
 Exit;

 FMPlayer.SendSeek(-(PRV_wind_step+2), false);

 setUpdateEnable(TRUE);

end;

procedure TfrmMain.DoBack60(ASender: TObject);
begin
if not FMPlayer.Active then
 Exit;

 FMPlayer.SendSeek(- 59, false);

 setUpdateEnable(TRUE);

end;

procedure TfrmMain.DoFileOpen(ASender: TObject);
var
   OpenDialog: TOpenDialog;
   str: String;
begin

//stopFrameTimer();

TCfileTimer.Enabled :=FALSE;

OpenDialog := TOpenDialog.Create(nil);

 try
 if not OpenDialog.Execute then
  Exit;

 stopPlayer(0);

 TCfileTimer.enabled :=FALSE;

 setTcclockOffset(NUL,0);

 PRV_get_media_info :=TRUE; //For å få ut mediaInfo
 //PRV_init_media :=TRUE;

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
 PRV_TC_hidden_frames :=0;
 tcHiddenFrames.Caption :=NUL;

 //PRV_TC_delay :=0;
 setTCdelay(0);

 PRV_last_sec :=0;
 PRV_last_time :=0;

 setTCclockOffset(NUL,0);

 PRV_get_media_info :=TRUE;
 //PRV_init_media :=TRUE;

 PRV_last_time :=0;
 PRV_timer_counter :=0;

 //doPause(self);


  str :=format('%s "%s" %d %d',[OSD_SHOW_TXT,'Start play',2000,1]);

  FMplayer.SendCommand(str);

 gotoStart();

 playPause(PAUSE_);

{
 sleep(400);

 playPause(0);

 PRV_TC_tot_frames :=0;
}

 //doPlay(self);

  {
   gotoStart();
   sleep(MP_CLOCK_INTERVAL);
   gotoStart();
  }
 //PRV_start_analyze :=TRUE;

 //PRV_show_init_data :=TRUE;

 //Finn antall sekunder søkefeil ved 95%

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


 FMPlayer.SendSeek(+ 1, false);

 setUpdateEnable(TRUE);

end;

procedure TfrmMain.DoForward10(ASender: TObject);
begin
 if not FMPlayer.Active then
 Exit;

 FMPlayer.SendSeek((PRV_wind_step-0.5), false);

 setUpdateEnable(TRUE);

end;

procedure TfrmMain.DoForward60(ASender: TObject);
begin

if not FMPlayer.Active then
 Exit;

 FMPlayer.SendSeek(+ 59, false);

 setUpdateEnable(TRUE);

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
 stepTimeClock(1);

 //For at ikke TC klokke skal feiloppdateres fra posisjon
 setUpdateInhbit(TRUE);

 FMPlayer.SendFrameStep;

//setUpdateInhbit(FALSE);

end;

procedure TfrmMain.stepTimeClock(frmi: Integer);
var
 tcs: STring;
 frms: Integer;
begin

 frms :=unitFrm.TC_toFrames(timeLed.caption);

 tcs :=unitFrm.FramesTo_TC(frms+frmi,TRUE);

 setTimeClock(tcs);

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

 //setTCdelay(0);

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
   begin
     setTCdelay(MP_CLOCK_INTERVAL);
     FMPlayer.Paused := false;
   end
   else
    //setTCdelay(0);

 end
 else
 begin
  setTCdelay(MP_CLOCK_INTERVAL);

  startPlayer();
 end;

                //PRV_frame_offset
 startFrameTimer(0);
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

 inc(PRV_speed);
 
end;

procedure TfrmMain.DoStop(ASender: TObject);
begin
//FMPlayer.Active := false;

 stopPlayer(0);

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
  VK_I,VK_N,VK_M,VK_O,VK_E:
   exit;  //Disse er behandlet
  VK_J,VK_K,VK_L:
   //doUpdateTimers();


 end;

 setUpdateInhbit(FALSE);

 DoUpdateMPlayer;  //ellers ødelegger tastetrykk posisjonen !
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
var
 tcs: String;
 frms: Integer;
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

 {
 frms :=unitFrm.deciTimeToFrames(FMplayer.TimePosition);
 tcs :=unitFrm.FramesTo_TC(frms,TRUE);
 setTCclock(tcs);
 }

end;

procedure TfrmMain.DoUpdateTimers;
var
 pval,tcs,tc_clk,str: String;
 secpos,timepos: Real;
 tc_offset: Integer;
 tc_in,tc_out,cname,tc_cname,tcs_tot: String;
 rt,frms,frms_tot,frmi,frms_tc,frms_dif,frmz: Integer;
 addLog,getInfo,secChange: Boolean;
begin


 getInfo :=FALSE;

 frms_dif :=0;
 timepos :=0;
 secChange :=FALSE;

 if isUpdateInhibit() then
 begin
  rt :=0;
  exit;
 end;

 if PRV_display_log then
 begin
  inc(PRV_timer_counter);

 if PRV_timer_counter >4000000 then
  PRV_timer_counter :=0;

 end;

//denne er ikke helt rutenøyaktig ...
 secpos :=FMPlayer.TimePosition;


 //PRV_player_pos :=secpos;

 //Finn eventuell start_time i filen.
 //Det må korrigeres for denne i visning av tid på tidslinjen
 if (secpos>0) and (PRV_get_media_info) then
 begin

  if getMediaInfo()>=0 then
  begin

   PRV_get_media_info :=FALSE;   //bare en gang

   frms_tot :=unitFrm.deciTimeToFrames(FMPlayer.SecsLength,0);

   sts.Panels.Items[1].Text :=unitFrm.FramesTo_TC(frms_tot,TRUE);
   sts.Panels.Items[3].Text :=PRV_media_filename;

   getInfo :=TRUE;
  end;

 end;

 //btnFileProperty.Transparent := PRV_get_media_info;

 setServoStat(clLime,TRUE);

 if PRV_TC_media_offset<>0 then
  timepos :=(secpos-(PRV_TC_media_offset/VIDEO_FRAME_RATE))
 else
  timepos :=secpos;


  if timepos<=0 then
  begin
   timepos :=0;

   //PRV_TC_tot_frames :=0;
  end;

  if timepos<PRV_last_time then
  begin
   //PRV_TC_tot_frames :=0;

   //dec(PRV_TC_tot_frames);
   //if PRV_TC_tot_frames<0 then
   // PRV_TC_tot_frames :=unitFrm.deciTimeToFrames(timepos,0);
   //frmz :=unitFrm.deciTimeToFrames(timepos,0);

   //if frmz=0 then
   //PRV_TC_tot_frames :=1;

   PRV_last_time :=timepos;

  end;


 if (trunc(PRV_last_time)<>trunc(timepos)) OR (getInfo) then
 begin

  secChange :=TRUE;

 if not TCfileTimer.Enabled then
  btnSetTCinn.Transparent :=(TCinn.text<>TC_NULL);

 if not TCfileTimer.Enabled then
  btnSetTCut.Transparent :=(TCut.text<>TC_NULL);

  tcs_tot :=unitFrm.FramesTo_TC(PRV_TC_tot_frames,TRUE);

  //Sjekk om det kan ligge udokumentert start_time i filen ("hidden frames")
  if PRV_init_media then
  begin

  if (PRV_TC_tot_frames<=(VIDEO_FRAME_RATE)) and (not PRV_seeking) then
  begin

   //finn TC feil i overgangen fra 0 til 1 sekund
   if (trunc(timepos)=1) and
   //if (trunc(PRV_last_time)=0) AND (trunc(timepos)=1) and //(timepos>=1) and
        (PRV_cue_point=0) and (PRV_stop_TC=NUL) then
   begin

     PRV_init_media :=FALSE;

     frms_dif :=unitFrm.deciTimeToFrames(timepos,0)-PRV_TC_tot_frames;

     if (frms_dif>0) and (frms_dif<VIDEO_FRAME_RATE) then
     begin

      frms_dif :=frms_dif+2; //Fordi det tar to frame å oppdage feilen

      displayTCerror(frms_dif,'TC offset');

     end;

    end;

   end;

  end; // if PRV_init_media

  //Korriger for start
  if getinfo then
  begin
   getInfo :=FALSE;

   rt :=0;
   //setTCframes(PRV_TC_tot_frames);
  end;

 end;
 //else
 if (PRV_TC_tot_frames=1) and (not PRV_init_media) then
 begin
    //detekter eventuelle "hidden frames"

     frms_dif :=unitFrm.deciTimeToFrames(timepos,0)-1;


     if frms_dif>0 then
      tcOffsetFrames.Caption :=intToStr(frms_dif)
     else
      tcOffsetFrames.Caption :=NUL;


     if (frms_dif>=MAX_FRAMES_OFF) and (frms_dif<VIDEO_FRAME_RATE) then
     begin

       if frms_dif<=MAX_FRAMES_OFF then
        frms_dif :=frms_dif-1;  //tvilsom logikk, men basert på testing

       displayTCerror(frms_dif,'TC start offset');
     end;

  end;





  //Posisjon fra null korrigert for start_time i filen
  //frms :=unitFrm.deciTimeToFrames(secpos)-(PRV_TC_media_offset-PRV_frame_offset);

  frms :=unitFrm.deciTimeToFrames((timepos-PRV_frame_offset),PRV_last_frms);

   if frms>PRV_last_frms+1 then
   begin
    inc(PRV_TC_errors);

    TCerrors.caption :=intToStr(PRV_TC_errors);
   end
   else
   begin
    //tid mellom hver frame
    PRV_frame_time :=timepos-PRV_last_time;
    //divFld.Text :=format('%.2f',[PRV_frame_time]);

   end;


  if frms<>PRV_last_frms then
   PRV_last_frms :=frms;    //Brukes i forbindelse med avrunding


  tc_offset :=getTCclockOffset();
                             //Pga. mplayer som henger 1 timer periode bak
  frms_tc :=(frms+tc_offset)+PRV_TC_delay;

  frms_tc :=frms_tc-PRV_TC_hidden_frames;  //ny 22.02.2012

  if frms_tc<0 then
   frms_tc :=0;


  PRV_TC_frames :=frms_tc mod VIDEO_FRAME_RATE;

  tcs :=unitFrm.FramesTo_TC(frms_tc,TRUE);

 //if not PRV_clock_inhibit then
  setTCclock(tcs);
 //else
 // rt :=0;
                              //Aktuell posisjon fra 0, ikke fra tc_offset
  str :=unitFrm.FramesTo_TC(frms,TRUE);//TimeToStr(SecsToDateTime(secpos)); //+ ' ' + intToStr(tc_offset);
  sts.Panels.Items[0].Text :=str;

  str :=unitFrm.FramesTo_TC(frms+PRV_TC_delay,TRUE);
  setTimeClock(str);

 //if (addLog) OR (getSec) then
 if PRV_display_log then
 begin

  displayLog(tcs,timepos);

 end;


 if ((secpos+1)>=FMPlayer.SecsLength) AND (FMPlayer.SecsLength>0) then
  if (not FMplayer.Paused) and (not PRV_seeking) then
   doPause(self);


  //times_fld.text :=format('%f %f',[secpos,PRV_last_sec]);

 {
  if (secpos=PRV_last_sec) then
  begin
    if (not PRV_playing) AND (PRV_stop_next_frame) then
    begin
     PRV_stop_next_frame :=FALSE;
     playPause(PAUSE_);
    end;
  end;
 }


  if secpos<>PRV_last_sec then
   PRV_last_sec :=secpos;

  if timepos<>PRV_last_time then
   PRV_last_time :=timepos;

  if secChange then
   setTCled(PRV_TC_errors,SET_);

 //application.processMessages;

end;


procedure TfrmMain.displayTCerror(frms_dif: Integer; msg: String);
var
 str: String;
begin

  str :=format('%s "%s %d ruter" %d %d',[OSD_SHOW_TXT,msg,frms_dif,2000,1]);

  FMplayer.SendCommand(str);

  PRV_TC_hidden_frames :=frms_dif;

 if frms_dif<>0 then
  tcHiddenFrames.caption :=intToStr(frms_dif)
 else
  tcHiddenFrames.caption :=NUL;

  tcOffsetFrames.Caption :=NUL;

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
var
 tcs: String;
begin

 if PRV_playing then
  tcs :=unitFrm.TC_add_frames(getTCclock(),-TC_REACTION)
 else
  tcs :=getTCclock();

 TCinn.text :=tcs;

 writeTCfile(PRV_media_filename,TCinn.Text,TCut.Text);

end;

procedure TfrmMain.btnSetTCutClick(Sender: TObject);
var
 tcs: String;
begin

 if PRV_playing then
  tcs :=unitFrm.TC_add_frames(getTCclock(),-TC_REACTION)
 else
  tcs :=getTCclock();

 TCut.text :=tcs;

 writeTCfile(PRV_media_filename,TCinn.Text,TCut.Text);

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  //FMplayer.active :=FALSE;

   stopPlayer(0);

  iniParams(frmMain,WRITE_);

  halt; //Ellers kommer det system exception ...
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
//G:\MediaDb\Browse\PRHO04002208AA.wmv 1384759 15:39:55:20 15:42:40:23
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

 stopFrameTimer();  //Usikkert om dette er nødvendig

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

  //FMPlayer.TimePosition :=sps;  //samme unøyaktighet som sendSeek()

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
  //Korreksjon starter etter 750 ms slik at alle tider er oppdatert før korr.

 PRV_skip_cue_error :=FALSE;
 //PRV_cue_corr :=TRUE;

 //pga. forsinkelse i mplayer, er det ikke kjent hvor mye sendSeek() bommer med.
 //Derfor må korreksjonen gjøres 1 sekund seinere når alle posisjoner er oppdaterte
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
  stopPlayer(RESTART_);
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
 tcs: STring;
 frms: Integer;
begin

 frms :=unitFrm.TC_toFrames(getTCclock());

 tcs :=unitFrm.FramesTo_TC(frms+frmi,TRUE);

 setTCclock(tcs);

{
 frms :=PRV_TC_frames;

 if (fval>=0) AND (fval<VIDEO_FRAME_RATE) then
  frms :=fval
 else
  frms :=frms+frmi;


 if frms>=(VIDEO_FRAME_RATE) then
 begin
  frms :=0;
  //stepTCclock(1);
 end
 else
 if frms<0 then
 begin
  frms :=VIDEO_FRAME_RATE-1;
  //stepTCclock(-1);
 end;


 setTCframes(frms);
 }
 
 //displayTCframes();

 //frameLED.Value :=frms;

end;

{
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
}

procedure TfrmMain.frameTimerTimer(Sender: TObject);
begin

   //Fjernet etter at doUpdateTimers() aktiveres pr rute

  if PRV_get_media_info then
   stepTCframe(1,-1);

  inc(PRV_TC_tot_frames); //Brukes for å detektere "hidden frames" og TC feil

  setTrackbarData();

  //Her skjer alle tidskode visninger og oppdateringer 8 ganger pr sek.
  DoUpdateTimers();

  //Dette er cue punktet for framematch hvis PRV_stop_TC har verdi
  if PRV_stop_TC<>NUL then
   stopOnTC(getStopTC());

 {
  if PRV_stop_next_frame then
  begin
     PRV_stop_next_frame :=FALSE;
     stopFrameTimer();
  end;
 }

end;


procedure TfrmMain.startFrameTimer(start_frame: Integer);
begin

 setTCframes(start_frame);
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


procedure TfrmMain.TCledDblClick(Sender: TObject);
begin
 frameTimer.Enabled :=not frameTimer.Enabled;
end;

procedure TfrmMain.btnFrameStepClick(Sender: TObject);
begin
 PRV_skip_cue_error :=FALSE;

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
 if key =VK_E then
 begin

  btnVTRejectClick(sender);


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
 begin
  doBack10(sender); //DoSpeedDec(sender)
  doUpdateTimers();
 end
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
   stopPlayer(0);

 end
 else
 if key=VK_HOME then
 begin
   gotoStart();
   sleep(MP_CLOCK_INTERVAL);
   gotoStart();

 end
 else
 if key=VK_END then
 begin
   gotoEnd();  //Fungerer ikke ...
   sleep(MP_CLOCK_INTERVAL);
   gotoEnd();
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
  DoUpdateMPlayer() //doBack01(sender)  //fungerer dårlig
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

  setTCclock(TC_NULL);

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


  FMplayer.Active :=TRUE;  //Går i Play  her

  FMplayer.Paused :=FALSE;

  //TCfileTimer.enabled :=TRUE;
  //playerTimer.enabled :=TRUE;


  imgBtnPause.Visible :=FALSE;
  imgBtnStop.Visible :=FALSE;

  startFrameTimer(0);

  setTCdelay(MP_CLOCK_INTERVAL);


  //playPause(PLAY_);


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

procedure TfrmMain.stopPlayer(cmd: Integer);
begin

 FMplayer.Active :=FALSE;

 if cmd<>RESTART_ then
 begin

 txtCue.Visible :=FALSE;

 setBtnStats(TRUE);

 imgBtnStop.Visible :=TRUE;
 imgBtnPause.Visible :=TRUE;

 PRV_playing :=FALSE;

 //TCfileTimer.enabled :=FALSE;


 //FMplayer.Active :=FALSE;

 //playerTimer.enabled :=FALSE;

 //PRV_TC_sec :=0;
 PRV_TC_tot_frames :=0;
 PRV_TC_hidden_frames :=0;
 tcHiddenFrames.Caption :=NUL;

 //PRV_TC_delay :=0;
 setTCdelay(0);

 PRV_skip_cue_error :=FALSE;

 PRV_last_sec :=0;
 PRV_last_time :=0;

 PRV_timer_counter :=0;

 PRV_back_frame :=0;

 setTCled(-1,CLEAR_);
 stopFrameTimer();

 //setTCclockOffset(TIME_00,0);  //Nei, bare når nye filer hentes

 setTCclock(TC_NULL);
 setStopTC(NUL);

 setTimeClock(TC_NULL);

 setTCframes(0);
 //displayTCframes();


 sts.Panels.Items[0].Text :=TIME_00;
 sts.Panels.Items[1].Text :=TIME_00;
 sts.Panels.Items[2].Text :=NUL;

 btnSetTCinn.Font.Color :=clBlack;
 btnSetTCut.Font.Color :=clBlack;

 PRV_get_media_info :=TRUE;
 //PRV_last_time :=0;
 //PRV_init_media :=FALSE;
end;

 //btnFileProperty.Transparent := PRV_get_media_info;
 setServoStat(clNone,FALSE);


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

 PRV_last_time :=PRV_player_pos;
 
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


 PRV_last_time :=FMplayer.TimePosition;

 seekpos :=FMPlayer.SecsLength*TC_SEEK_PRC/100;

 frms :=unitFrm.deciTimeToFrames(seekpos,0);

 tc_offset :=getTCclockOffset();

 //tcs :=unitFrm.FramesTo_TC(round(seekpos*VIDEO_FRAME_RATE),TRUE);

 tcs :=unitFrm.FramesTo_TC(frms+tc_offset,TRUE);

 //tcs :=unitFrm.TC_add_frames(tcs,tc_offset);

 PRV_player_TC :=tcs;

 setTCclock(tcs);  //Denne er ikke nøyaktig på slutten av fila

 sts.Panels.Items[0].Text :=tcs; //PRV_Start_TC;  //start på fil
 sts.Panels.Items[2].Text :=NUL;
 txtCue.Visible :=TRUE;

 //gotoTC(tcs);  //fungerer ikke

 FMPlayer.sendSeek(TC_SEEK_PRC,TRUE);

 setUpdateInhbit(FALSE);
 //doUpdateMplayer();
 doUpdateTimers();

 txtCue.Visible :=FALSE;

end;

procedure TfrmMain.gotoStart;
var
 str,tcs: String;
 frms_offset: Integer;
begin

 tcMem.Lines.clear();

 //frms_offset :=(getTCclockOffset()+PRV_PB_offset_frames);
 frms_offset :=getTCclockOffset();

 PRV_player_TC :=unitFrm.TC_add_frames(TC_NULL,frms_offset);

 if not FMplayer.Paused then
  FMplayer.Paused :=TRUE;


 gotoTC(TC_NULL,FALSE);

 //FMplayer.sendSeek(0,TRUE);

 stopFrameTimer();

 //setTCclockOffset(TIME_00,0);  //Nei, bare når nye filer hentes

 tcs :=unitFrm.framesTo_TC(frms_offset,TRUE);
 setTCclock(tcs);

 setTCframes(0);
 setStopTC(NUL);

 //displayTCframes();
 {
  str :=getMediaProp(ID_PARAM_MEDIA_START);

  if str<>NUl then
   PRV_start_TC :=unitFrm.format_TC(str,FALSE)
  else
   PRV_start_TC :=TIME_00;
}


 if not FMplayer.Paused then
  doPause(self);

 setTimeClock(TC_NULL);

 PRV_last_sec :=0;
 PRV_last_time :=0;

 PRV_TC_tot_frames :=0;
 PRV_TC_hidden_frames :=0;
 tcHiddenFrames.Caption :=NUL;
 tcOffsetFrames.Caption :=NUL;

 //PRV_get_media_info :=TRUE;
 PRV_timer_counter :=0;

 sts.Panels.Items[0].Text :=TC_NULL; //PRV_Start_TC;  //start på fil
 //sts.Panels.Items[1].Text :=  //tid
 sts.Panels.Items[2].Text :=NUL;

 txtCue.Visible :=FALSE;

 //PRV_init_media :=TRUE;

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

  frms :=unitFrm.deciTimeToFrames(FMPlayer.TimePosition,0);

  PRV_pos_dif :=unitFrm.framesToDeciTime(frms-PRV_seek_frms);

  if PRV_pos_dif>MAX_POS_DIF then
  begin
   PRV_seeking :=FALSE;

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

   str :=format('%s "%s %s" %d %d',[OSD_SHOW_TXT,'Søker TC',tcs,osd_on,osd_lvl]);

   FMplayer.SendCommand(str);  //OBS: denne starter av en eller annen grunn play



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

   //tcmem.lines.add('Før preroll: '+tc_clk);

   tc_clk :=unitFrm.FramesTo_TC(frms-unitFrm.deciTimeToFrames(PRV_preroll,0),TRUE);

   //OBS: denne stopper på første keyframe bakover
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

 //track_pos :=getDifStat(95,SET_);

 track_pos :=strToFloatDef(divFld.text,0);

 //FMplayer.SendSeek(-track_pos,FALSE);

 //Svakhet i mplayer gjør at små step bakover blir til framstep forover.
 //FMplayer.SendSeek(-0.0001,FALSE);
 //FMplayer.TimePosition :=FMplayer.TimePosition-0.0001;


 {
  getMediaInfo();

  setTcClockOffset(NUL,PRV_TC_offset);


  //FMPlayer.SendOsdToogle;
  //FMplayer.OsdLevel :=2;

  //FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"Søker TC ..."' + ' ');

  //FMplayer.SendOsd(1);
  FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"Søker TC ..."' + ' ' +'2000 1');

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
                                       //Korreksjon for step bakover
 frms_clk :=unitFrm.TC_toFrames(tc_clk)+PRV_back_frame;

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

   //Rød lampe som indikerer unøyaktig avspilling
   if PRV_TC_frames>=PRV_TC_last_frame+PRV_max_frames_off then
     setServoStat(clRed,TRUE);

   {
   if PRV_TC_frames>PRV_TC_last_frame+PRV_max_frames_off then
   begin
    FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"Unøyaktig avspilling"');

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

 //Avspilling er ikke rutenøyaktig og match må være +/- 1 frame
 if (frms_clk>=frms_tc) AND (frms_clk<=frms_tc+2) then
 begin

  setBtnStats(TRUE);

  setUpdateInhbit(TRUE);

  //doPause(self);

  fdif :=frms_clk-frms_tc;

  //+2 er egentlig bare en pga. avrundingsfeil
  if fdif>1 then
  begin
   tc_clk :=unitFrm.TC_add_frames(tc_clk,-1);
   fdif :=1
  end;
//  else
//   tc_clk :=unitFrm.FramesTo_TC(frms_clk,TRUE);

   setTCclock(tc_clk);

   //Korriger for step frame bakover
   if PRV_back_frame>0 then
   begin
    //tc_clk :=unitFrm.TC_add_frames(tc_clk,PRV_back_frame);

    stepTCframe(PRV_back_frame,-1);
    stepTimeClock(PRV_back_frame);

   end;



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
  PRV_skip_cue_error :=FALSE;
  PRV_seeking :=FALSE;
  PRV_stop_TC :=NUL;

  PRV_back_frame :=0;
 //  ofs :=NUL;

 // MATCH_FRAME ='Match frame';

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

   //Ikke vis Cue feil på startet av fila
   //if frms_tc<tc_offset+(PRV_preroll*VIDEO_FRAME_RATE) then
   //begin

    FMplayer.SendCommand(OSD_SHOW_TXT + ' '+'"Cue feil"');

   //end;

   txtCue.Visible :=FALSE;
   PRV_skip_cue_error :=FALSE;
   PRV_seeking :=FALSE;
   PRV_stop_TC :=NUL;
   PRV_back_frame :=0;

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

procedure TfrmMain.upDnPrerollClick(Sender: TObject; Button: TUDBtnType);
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

 if (not FMplayer.Active) OR (PRV_skip_cue_error) then
  exit;

 setBtnStats(FALSE);

 //fmt :=unitFrm.calcFrameTime(FMplayer.SecsLength);

 //stopFrameTimer();

 //stepTCframe(-1,-1);

 //setUpdateInhbit(TRUE);

 tcs :=getTCclock();

 //stopFrameTimer();

 txtCue.Visible :=TRUE;


 FMplayer.SendSeek(-PREROLL_SEC,FALSE);

 doPlay(self);

 //PRV_matchframe_offset er funnet i stopOnTC() via siste gotoTC()

 if PRV_matchframe_offset<0 then
  PRV_matchframe_offset :=0;


 //tcs :=unitFrm.TC_add_frames(tcs,-1);

 PRV_back_frame :=1; //Korreksjon i visning av TC ved step baover

 tcs :=unitFrm.TC_add_frames(tcs,-(PRV_matchframe_offset+PRV_back_frame));

 PRV_stop_TC :=tcs;

 PRV_skip_cue_error :=TRUE;

 str :=format('%s "%s %s" %d %d',[OSD_SHOW_TXT,'Til frame:',
                     tcs,(PREROLL_SEC*1000),1]);


 //PRV_stop_TC :=unitFrm.TC_add_frames(tcs,-(PRV_matchframe_offset+1));


 FMplayer.SendCommand(str);

 //PRV_timer_inhibit :=FALSE;

 //startFrameTimer(PRV_TC_frames);

 //gotoTC(tcs,TRUE);

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
   //imgBtnPause.Visible :=TRUE;

   imgBtnStop.Visible :=FALSE;
   PRV_playing :=TRUE;

   doPlay(self);

   setTCled(0,SET_);  //Lyser Grønn

   if PRV_speed>0 then
   begin
    doSpeedDef(self);
    PRV_speed :=0;
    doSpeedDef(self);
   end;

  end
  else
  if (cmd=0) OR (cmd=PAUSE_) then
  begin
   imgBtnPause.Visible :=TRUE;
   //imgBtnPause.Visible :=FALSE;

   PRV_playing :=FALSE;

   setServoStat(clNone,FALSE);

   doPause(self);
   setTCled(-1,CLEAR_);

  end;

   txtCue.Visible :=FALSE;

   PRV_back_frame :=0;

   setUpdateInhbit(FMPlayer.Paused);

end;

procedure TfrmMain.btnVTRstopClick(Sender: TObject);
begin
 stopPlayer(0);
 doPause(sender);
end;

procedure TfrmMain.btnVTRtcInClick(Sender: TObject);
begin

 btnSetTCinnClick(sender);
end;

procedure TfrmMain.btnVTRtcOutClick(Sender: TObject);
begin

 btnSetTCutClick(sender);
end;

procedure TfrmMain.btnVTRstepFrameRewClick(Sender: TObject);
var
 rt,fmt: Real;
 tcs: String;
begin

 if not FMplayer.Active then
  exit;

 btnStepFrameRewClick(Sender);
 

 {
 setBtnStats(FALSE);

 //fmt :=unitFrm.calcFrameTime(FMplayer.SecsLength);

 //stopFrameTimer();

 //stepTCframe(-1,-1);

 //setUpdateInhbit(TRUE);

 tcs :=getTCclock();

 stopFrameTimer();
 //stepTCframe(-1,-1);


 FMplayer.SendSeek(-(PRV_preroll),FALSE);

 //stepTCframe(-1,-1);

 doPlay(self);

 //PRV_matchframe_offset er funnet i stopOnTC() via siste gotoTC()

 if PRV_matchframe_offset<0 then
  PRV_matchframe_offset :=0;

 PRV_stop_TC :=unitFrm.TC_add_frames(tcs,-(PRV_matchframe_offset+1));

 //FMplayer.SendSeek(-0.004,FALSE);  //1 rute =40 ms  //fungerer ikke
 }
 
end;

procedure TfrmMain.btnVTRstepFrameFwdClick(Sender: TObject);
var
 fmt: Real;
 tcs: String;
begin

 DoFrameStep(sender);

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

 //Bakover antall Preroll sekunder
 FMplayer.TimePosition :=FMplayer.TimePosition-(PRV_preroll+PREROLL_DELAY);

 doPause(sender);
 setUpdateEnable(FALSE);

 //sleep(CORR_INTERVAL_RECUE);

 doUpdateTimers();
 setTcClock(tcs_seek);


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
 stopPlayer(0)
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

 PRV_speed :=0;

 startFrameTimer(0);
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

  FMplayer.SendSeek(0,TRUE); //Til start først

  FMplayer.SendSeek(prc_pos,TRUE);

  sleep(MP_CLOCK_INTERVAL);

  doPlay(self);

  end
  else
  if (cmd=GET_) then
  begin

   PRV_analyze :=FALSE;

   track_pos :=FMplayer.TimePosition;

   frms :=unitFrm.deciTimeToFrames(track_pos,0);

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

 //Her skjer alle tidskode visninger og oppdateringer 8 ganger pr sek.
 //DoUpdateTimers();

end;

procedure TfrmMain.flashTimerTimer(Sender: TObject);
begin
 pnlRecInhibit.Visible :=not pnlRecInhibit.Visible;

 //divFld.Text :=intToStr(PRV_back_frame);

 //setServoStat(clLime,FALSE);

 //pnlServo.Visible :=FALSE;

end;

procedure TfrmMain.tcStartOffsetDblClick(Sender: TObject);
begin

 enableLog();
end;

procedure TfrmMain.enableLog;
begin

 tcMem.Visible :=not tcMem.Visible;

 PRV_display_log :=not PRV_display_log;


end;

procedure TfrmMain.displayLog(tcs: STring; time_pos: Real);
begin


  if tcs=NUL then
   tcMem.Lines.clear()
  else
  begin

  tcMem.Lines.add(format('%d TC:%s Frames:%d Time:%f',
                    [PRV_timer_counter,tcs,
                     PRV_TC_tot_frames,time_pos]));
{
  tcMem.Lines.add(format('     Offset Play:%d Media:%d Frame:%d',
                    [PRV_TC_delay,
                     PRV_TC_media_offset,
                     PRV_frame_offset]));
}
  end;

end;

procedure TfrmMain.setServoStat(colr: Tcolor; stat: Boolean);
begin

 pnlServo.Color :=colr;
 pnlServo.Visible :=stat;

end;

procedure TfrmMain.viewTimeClockClick(Sender: TObject);
var
 tcs: String;
begin
 timeLed.Visible :=not timeLed.visible;

 if timeLed.Visible then
 begin
  //setUpdateInhbit(FALSE);
  //doUpdateTimers();

  tcs :=unitFrm.TC_add_frames(sts.Panels.Items[0].Text,PRV_TC_delay);
  setTimeClock(tcs);
 end;

end;

procedure TfrmMain.setMediaOffset(frmi: Integer);
var
 moff: Real;
 sec,frms: Integer;
 str,neg: String;
begin

 PRV_TC_media_offset :=frmi;


 moff :=unitFrm.framesToDeciTime(frmi);

 sec :=trunc(moff);

 frms :=frmi mod VIDEO_FRAME_RATE;

 if (frms<0) OR (sec<0) then
  neg :=MINUS_
 else
  neg :=NUL;

 str :=format('%s%d.%02d',[neg,abs(sec),abs(frms)]); //unitFrm.FramesTo_TC(frmi,TRUE);

 str :=unitFrm.strReplace(Pchar(str),BLANK,NULLDIGIT);

 media_offset.caption :=str;

end;

procedure TfrmMain.UpDnMediaOffsetClick(Sender: TObject;
  Button: TUDBtnType);
begin

 if button=btNext then
  inc(PRV_TC_media_offset)
 else
 if button=btPrev then
  dec(PRV_TC_media_offset);

  setMediaOffset(PRV_TC_media_offset);

end;

procedure TfrmMain.media_offsetDblClick(Sender: TObject);
begin
 UpDnMediaOffset.Visible :=not UpDnMediaOffset.Visible;

end;

procedure TfrmMain.setUpdateEnable(stat: Boolean);
var
 tot_len,time_pos: Real;
 frms: Integer;
 tcs: String;
begin

 setUpdateInhbit(FALSE);

 PRV_back_frame :=0;
 //PRV_TC_errors :=0;

 if FMplayer.Paused then
 begin

  //startFrameTimer(0);
  if stat then
   playPause(PLAY_);
  //PRV_stop_next_frame :=TRUE;
  //setUpdateInhbit(TRUE);


 end;

end;

procedure TfrmMain.btnVTRshuttleClick(Sender: TObject);
begin

 setShuttleSpeed(0,STEP_WIND_SPEED);

end;

end.
