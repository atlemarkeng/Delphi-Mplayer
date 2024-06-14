unit mplayer_lib;

interface

uses
 Classes, Windows, Forms, Controls, ExtCtrls, SysUtils, logfrm, propfrm;

const

  DECIMALPOINT      = '.';

  MPLAYEREXENAME    = 'mplayer.exe';
  OSDFONT           = 'Arial.ttf';
  OSD_SHOW          = 'osd_show_property_text';
  OSD_TXT           = 'pausing_keep_force osd_show_text';
  OSD_SHOW_TXT      = 'osd_show_text'; 

  CMD_AUDIODELAY    = 'audio_delay';
  CMD_FRAMEDROP     = 'frame_drop';
  CMD_FRAMESTEP     = 'frame_step';
  CMD_GETPERCENTPOS = 'get_percent_pos';
  CMD_GETTIMEPOS    = 'get_time_pos';
  //CMD_GRABFRAMES    = 'grab_frames';   //Fungerer ikke
  CMD_GRABFRAMES    = 'screenshot'; // ''G:\MediaDB\IMG\mp0001.png''';  //ny i versjon 9.1
  CMD_MUTE          = 'mute';
  CMD_OSD           = 'osd';
  CMD_PAUSE         = 'pause';
  CMD_QUIT          = 'quit';
  CMD_SEEK          = 'seek';
  CMD_SPEEDINCR     = 'speed_incr';
  CMD_SPEEDMULT     = 'speed_mult';
  CMD_SPEEDSET      = 'speed_set';

  DEF_BRIGHTNESS    = - 85;
  DEF_CONTRAST      = 0;
  DEF_SATURATION    = 0;

  ID_AUDIO_TRAC_1   = '-aid 1';
  ID_AUDIO_TRAC_2   = '-aid 2';

  ID_AUDIO_LINE     = 'ID_AUDIO_LINE';

type

  TClientWaitThread = class(TThread)
  private
    FMPlayer: TObject;
    hProcess: cardinal;
    procedure ClientDone;
  protected
    procedure Execute; override;
  public
    property MPlayer: TObject read FMPlayer write FMPlayer;
  end;

  TProcessor = class(TThread)
  private
    Data: string;
    FLock: TRTLCriticalSection;
    hPipe: cardinal;
  private
    procedure Lock;
    procedure Unlock;
  protected
    procedure Execute; override;
  public
    destructor Destroy; override;
    function ExtractData(var ALine: string): boolean;
    procedure AfterConstruction; override;
  end;

  TMediaProp = class(TObject)
  private
    FPropLabel: string;
    FPropValue: string;
  public
    property PropLabel: string read FPropLabel write FPropLabel;
    property PropValue: string read FPropValue write FPropValue;
  end;

  TMediaPropIndexEvent = procedure(Sender: TObject; const Index: integer) of object;

  TMediaPropList = class(TObject)
  private
    FList: TList;
    FOnChange: TMediaPropIndexEvent;
    function AddInputLineVideoOuput(const AInputLine: string): boolean;
    function GetItem(const AIndex: integer): TMediaProp;
    function GetPropLabel(const AIndex: integer): string;
    function GetPropLabelValue(const APropLabel: string): string;
    function GetPropValue(const AIndex: integer): string;
    procedure Add(ATextLabel, ATextValue: string);
  protected
    procedure DoChange(const AIndex: integer); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function AddInputLine(const AInputLine: string): boolean;
    function Count: integer;
    function IndexOf(const APropLabel: string): integer;
    procedure Clear;
    procedure Delete(const AIndex: integer);
    property PropLabels[const AIndex: integer]: string read GetPropLabel;
    property PropLabelValues[const APropLabel: string]: string read GetPropLabelValue; default;
    property PropValues[const AIndex: integer]: string read GetPropValue;
  published
    property OnChange: TMediaPropIndexEvent read FOnChange write FOnChange;
  end;

  EMPlayerExeption = class(Exception);

  TMPlayerAspect = (mpaAutoDetect, mpa40_30, mpa160_90, mpa235_10);
  TMPlayerAudioOut = (maoNoSound, maoNull, maoWin32, maoDsSound);
  TMPlayerFrameDrop = (mfdEnabled, mfdHard, mfdDisabled);

  TMPlayer = class(TCustomPanel)
  private
    FAudioDelay: real;
    FAudioOut: TMPlayerAudioOut;
    FAspect: TMPlayerAspect;
    FBrightness: integer;
    FClientProcess: cardinal;
    FCLientWaitThread: TClientWaitThread;
    FContrast: integer;
    FFailedOpen: boolean;
    FFirstChance: boolean;
    FFrameDrop: TMPlayerFrameDrop;
    FfrmLog: TfrmLog;
    FfrmProp: TfrmProp;
    FFullScreen: boolean;
    FHWNDCur: HWND;
    FMediaAddr: string;
    FMediaPropList: TMediaPropList;
    FMPlayerPath: string;
    FMute: boolean;
    FOnChangeAudioDelay: TNotifyEvent;
    FOnChangeFrameDrop: TNotifyEvent;
    FOnChangeProp: TMediaPropIndexEvent;
    FOnChangeSpeed: TNotifyEvent;
    FOnChangeVolume: TNotifyEvent;
    FOnFailedOpen: TNotifyEvent;
    FOnLogAdd: TNotifyEvent;
    FOnPlayEnd: TNotifyEvent;
    FOnProgress: TNotifyEvent;
    FOnStartPlay: TNotifyEvent;
    FOnTimer: TNotifyEvent;
    FOsdLevel: integer;
    FPaused: boolean;
    FParams: string;
    FProcessor: TProcessor;
    FProgressPosition: integer;
    FReadPipe: cardinal;
    FReIndex: boolean;
    FSaturation: integer;
    FSpeed: real;
    FSpeedChanged: boolean;
    FTimePosition: real;
    FTimeQueryTick: cardinal;
    FTimer: TTimer;
    FVolume: real;
    FWritePipe: cardinal;
    function CheckAudioDelay(const ALineInput: string): boolean;
    function CheckFailedOpen(const ALineInput: string): boolean;
    function CheckFrameDrop(const ALineInput: string): boolean;
    function CheckMute(const ALineInput: string): boolean;
    function CheckPercentPosition(const ALineInput: string): boolean;
    function CheckSpeed(const ALineInput: string): boolean;
    function CheckStartingPlayback(const ALineInput: string): boolean;
    function CheckTimePosition(const ALineInput: string): boolean;
    function CheckVolume(const ALineInput: string): boolean;
    function DblQuotedIfSpace(const AString: string): string;
    function GetActive: boolean;
    function GetAudioDelay: real;
    function GetAudioOut: TMPlayerAudioOut;
    function GetAspect: TMPlayerAspect;
    function GetBrightness: integer;
    function GetContrast: integer;
    function GetFailedOpen: boolean;
    function GetFontPath: string;
    function GetFrameDrop: TMPlayerFrameDrop;
    function GetFullScreen: boolean;
    function GetHaveAudio: boolean;
    function GetHaveVideo: boolean;
    function GetLogLines: TStrings;
    function GetLogVisible: boolean;
    function GetMediaAddr: string;
    function GetMediaPropList: TMediaPropList;
    function GetMediaPropListVisible: boolean;
    function GetMPlayerPath: string;
    function GetMute: boolean;
    function GetOnChangeAudioDelay: TNotifyEvent;
    function GetOnChangeFrameDrop: TNotifyEvent;
    function GetOnChangeProp: TMediaPropIndexEvent;
    function GetOnChangeSpeed: TNotifyEvent;
    function GetOnChangeVolume: TNotifyEvent;
    function GetOnFailedOpen: TNotifyEvent;
    function GetOnLogAdd: TNotifyEvent;
    function GetOnPlayEnd: TNotifyEvent;
    function GetOnProgress: TNotifyEvent;
    function GetOnStartPlay: TNotifyEvent;
    function GetOnTimer: TNotifyEvent;
    function GetOsdLevel: integer;
    function GetPaused: boolean;
    function GetParams: string;
    function GetPercentPosition: integer;
    function GetReIndex: boolean;
    function GetSaturation: integer;
    function GetSecsLength: real;
    function GetSpeed: real;
    function GetTimePosition: real;
    function GetVolume: real;
    function RealToStr(const AReal: real; ADecimalPoint: char): string;
    function StrToReal(const ARealStr: string; ADecimalPoint: char; var ARealRes: real): boolean;
    function WaitData(const ATimeOut: cardinal): boolean;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR; // private
    procedure DoTimer(ASender: TObject);
    procedure FetchData;
    procedure GetProperty(const APropName: string);
    procedure RaiseAlreadyOpen;
    procedure RaiseNoMplayer;
    //procedure SendCommand(const ACommand: string);
    procedure SetActive(const AActive: boolean);
    procedure SetAudioDelay(const AAudioDelay: real);
    procedure SetAudioOut(const AAudioOut: TMPlayerAudioOut);
    procedure SetAspect(const AAspect: TMPlayerAspect);
    procedure SetBrightness(const ABrightness: integer);
    procedure SetContrast(const AContrast: integer);
    procedure SetFrameDrop(const AFrameDrop: TMPlayerFrameDrop);
    procedure SetFullScreen(const AFullScreen: boolean);
    procedure SetLogVisible(const AVisible: boolean);
    procedure SetMediaAddr(const AMediaAddr: string);
    procedure SetMediaPropListVisible(const AVisible: boolean);
    procedure SetMPlayerPath(const AMPlayerPath: string);
    procedure SetMute(const AValue: boolean);
    procedure SetProperty(const APropName, APropValue: string);
    procedure SetOnChangeAudioDelay(const ANotifyEvent: TNotifyEvent);
    procedure SetOnChangeFrameDrop(const ANotifyEvent: TNotifyEvent);
    procedure SetOnChangeProp(const AMediaPropIndexEvent: TMediaPropIndexEvent);
    procedure SetOnChangeSpeed(const ANotifyEvent: TNotifyEvent);
    procedure SetOnChangeVolume(const ANotifyEvent: TNotifyEvent);
    procedure SetOnFailedOpen(const ANotifyEvent: TNotifyEvent);
    procedure SetOnLogAdd(const ANotifyEvent: TNotifyEvent);
    procedure SetOnPlayEnd(const ANotifyEvent: TNotifyEvent);
    procedure SetOnProgress(const ANotifyEvent: TNotifyEvent);
    procedure SetOnStartPlay(const ANotifyEvent: TNotifyEvent);
    procedure SetOnTimer(const ANotifyEvent: TNotifyEvent);
    procedure SetOsdLevel(const AOsdLevel: integer);
    procedure SetParams(const AParams: string);
    procedure SetPaused(const APaused: boolean);
    procedure SetPercentPosition(const APercPos: integer);
    procedure SetReIndex(const AReIndex: boolean);
    procedure SetSaturation(const ASaturation: integer);
    procedure SetSpeed(const ASpeed: real);
    procedure SetTimePosition(const ATimeSecsPos: real);
    procedure SetVolume(const AVolume: real);
    procedure Terminate;
  protected
    function SendCommandWait(const ACommand: string; const ATimeOut: cardinal; const AMaxTries: byte): boolean;
    procedure DoAudioDelay(const AAudioDelay: real); virtual;
    procedure DoChangeProp(ASender: TObject; const AIndex: integer); virtual;
    procedure DoFailedOpen; virtual;
    procedure DoFrameDrop(const AFrameDrop: TMPlayerFrameDrop); virtual;
    procedure DoFullScreen(const AFullScreen: boolean); virtual;
    procedure DoInputLine(const ALineInput: string); virtual;
    procedure DoMute(const AValue: boolean); virtual;
    procedure DoOnTimer; virtual;
    procedure DoPercentPosition(const APercPos: real); virtual;
    procedure DoPlayEnd; virtual;
    procedure DoProgress; virtual;
    procedure DoSpeed(const ASpeed: real); virtual;
    procedure DoStartPlay; virtual;
    procedure DoTimePosition(const ASecs: real); virtual;
    procedure DoVolume(const AVolume: real); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function BrightnessDefault: boolean;
    function ColorsDefault: boolean;
    function ContrastDefault: boolean;
    function MPlayerExists: boolean;
    function SaturationDefault: boolean;
    function SpeedChanged: boolean;
    procedure BrightnessReset;
    procedure Close;
    procedure CloseForced;
    procedure ColorsReset;
    procedure ContrastReset;
    procedure Open;
    procedure SaturationReset;

    procedure SendCommand(const ACommand: string);

    procedure SendAudioDelay(const AValue: real);
    procedure SendFrameDrop(const AValue: integer);
    procedure SendFrameDropToogle;
    procedure SendFrameStep;
    procedure SendGetPercentPos;
    procedure SendGetTimePos;
    procedure SendGrabFrames;
    procedure SendMute(const AValue: integer);
    procedure SendMuteToogle;
    procedure SendOsd(const AValue: integer);
    procedure SendOsdToogle;
    procedure SendPause;
    procedure SendQuit;
    procedure SendSeek(const AValue: real; const AUsePercent: boolean);
    procedure SendSpeedIncr(const AValue: real);
    procedure SendSpeedMult(const AValue: real);
    procedure SendSpeedSet(const AValue: real);
    property AudioDelay: real read GetAudioDelay write SetAudioDelay;
    property Brightness: integer read GetBrightness write SetBrightness;
    property Contrast: integer read GetContrast write SetContrast;
    property FailedOpen: boolean read GetFailedOpen;
    property FrameDrop: TMPlayerFrameDrop read GetFrameDrop write SetFrameDrop;
    property HaveAudio: boolean read GetHaveAudio;
    property HaveVideo: boolean read GetHaveVideo;
    property LogLines: TStrings read GetLogLines;
    property LogVisible: boolean read GetLogVisible write SetLogVisible default false;
    property MediaPropList: TMediaPropList read GetMediaPropList;
    property MediaPropListVisible: boolean read GetMediaPropListVisible write SetMediaPropListVisible default false;
    property Mute: boolean read GetMute write SetMute default false;
    property OsdLevel: integer read GetOsdLevel write SetOsdLevel;
    property PercentPosition: integer read GetPercentPosition write SetPercentPosition;
    property Saturation: integer read GetSaturation write SetSaturation;
    property SecsLength: real read GetSecsLength;
    property Speed: real read GetSpeed write SetSpeed;
    property TimePosition: real read GetTimePosition write SetTimePosition;
    property Volume: real read GetVolume write SetVolume;
  published
    property Active: boolean read GetActive write SetActive default false;
    property Aspect: TMPlayerAspect read GetAspect write SetAspect default mpaAutoDetect;
    property AudioOut: TMPlayerAudioOut read GetAudioOut write SetAudioOut default maoWin32;
    property FullScreen: boolean read GetFullScreen write SetFullScreen;
    property MediaAddr: string read GetMediaAddr write SetMediaAddr;
    property MPlayerPath: string read GetMPlayerPath write SetMPlayerPath;
    property OnChangeAudioDelay: TNotifyEvent read GetOnChangeAudioDelay write SetOnChangeAudioDelay;
    property OnChangeFrameDrop: TNotifyEvent read GetOnChangeFrameDrop write SetOnChangeFrameDrop;
    property OnChangeProp: TMediaPropIndexEvent read GetOnChangeProp write SetOnChangeProp;
    property OnChangeSpeed: TNotifyEvent read GetOnChangeSpeed write SetOnChangeSpeed;
    property OnChangeVolume: TNotifyEvent read GetOnChangeVolume write SetOnChangeVolume;
    property OnFailedOpen: TNotifyEvent read GetOnFailedOpen write SetOnFailedOpen;
    property OnLogAdd: TNotifyEvent read GetOnLogAdd write SetOnLogAdd;
    property OnPlayEnd: TNotifyEvent read GetOnPlayEnd write SetOnPlayEnd;
    property OnProgress: TNotifyEvent read GetOnProgress write SetOnProgress;
    property OnStartPlay: TNotifyEvent read GetOnStartPlay write SetOnStartPlay;
    property OnTimer: TNotifyEvent read GetOnTimer write SetOnTimer;
    property Paused: boolean read GetPaused write SetPaused default false;
    property Params: string read GetParams write SetParams;
    property ReIndex: boolean read GetReIndex write SetReIndex default false;
  // inherited properties
  public
    property DockManager;
  published
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DragCursor;
    property DragKind;
    property DragMode;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

{ TClientWaitThread }

procedure TClientWaitThread.ClientDone;
var
   AMPlayer: TMPlayer;
   ACLientWaitThread: TClientWaitThread;
   AProcessor: TProcessor;
begin
if not Assigned(FMPlayer) then Exit;
if not(FMPlayer is TMPlayer) then Exit;
AMPlayer := FMPlayer as TMPlayer;
AMPlayer.FClientProcess := 0;
CloseHandle(AMPlayer.FReadPipe);
AMPlayer.FReadPipe := 0;
CloseHandle(AMPlayer.FWritePipe);
AMPlayer.FWritePipe := 0;
ACLientWaitThread := AMPlayer.FCLientWaitThread;
if Assigned(ACLientWaitThread) then ACLientWaitThread.Terminate;
AProcessor := AMPlayer.FProcessor;
if Assigned(AProcessor) then AProcessor.Terminate;
AMPlayer.DoPlayEnd;
end;

procedure TClientWaitThread.Execute;
begin
WaitForSingleObject(hProcess, INFINITE);
try
Synchronize(ClientDone);
   except
   end;
end;

{ TProcessor }

procedure TProcessor.AfterConstruction;
begin
InitializeCriticalSection(FLock);
inherited AfterConstruction;
end;

destructor TProcessor.Destroy;
begin
inherited Destroy;
DeleteCriticalSection(FLock);
end;

procedure TProcessor.Execute;
const
  BufSize = 1024;
var
  Buffer: array[0..BufSize] of char;
  BytesRead: cardinal;
begin
Data := '';
repeat
   BytesRead := 0;
   if not ReadFile(hPipe, Buffer[0], BufSize, BytesRead, nil) then Break;
   Buffer[BytesRead] := #0;
   Lock;
   try
   Data := Data + Buffer;
      finally
      Unlock;
      end;
   until BytesRead = 0;
end;

function TProcessor.ExtractData(var ALine: string): boolean;
var
   EOL: integer;
begin

Lock;

try
Result := false;
EOL := Pos(#10, Data);
if EOL = 0 then
 Exit;

ALine := Copy(Data, 1, EOL - 1);
Delete(Data, 1, EOL);
Result := true;

   finally
   Unlock;
   end;
end;

procedure TProcessor.Lock;
begin
EnterCriticalSection(FLock);
end;

procedure TProcessor.Unlock;
begin
LeaveCriticalSection(FLock);
end;

{ TMediaPropList }

procedure TMediaPropList.Add(ATextLabel, ATextValue: string);
var
   I: integer;
   MediaProp: TMediaProp;
begin
I := IndexOf(ATextLabel);
if I < 0 then
   begin
   MediaProp := TMediaProp.Create;
   MediaProp.PropLabel := ATextLabel;
   MediaProp.PropValue := ATextValue;
   I := FList.Add(MediaProp);
   DoChange(I);
   end
else
   begin
   MediaProp := GetItem(I);
   if not(ATextValue = MediaProp.PropValue) then
      begin
      MediaProp.PropValue := ATextValue;
      DoChange(I);
      end;
   end;
end;

function TMediaPropList.AddInputLine(const AInputLine: string): boolean;
var
   InputLine, TextLabel, TextValue: string;
   L, P: integer;
begin
InputLine := Trim(AInputLine);
Result := AddInputLineVideoOuput(AInputLine);
if Result then Exit;

L := Length(InputLine);
if L < 6 then Exit; // min. 'ID_?=?'
if not(Copy(InputLine, 1, 3) = 'ID_') then
Exit;

P := Pos('=', InputLine);

if P < 5 then Exit;
if P = L then Exit;

TextLabel := Trim(Copy(InputLine, 1, P - 1));
System.Delete(TextLabel, 1, 3);
System.Delete(InputLine, 1, P);
TextValue := Trim(InputLine);
if TextValue = '' then Exit;

Add(TextLabel, TextValue);
Result := true;
end;

function TMediaPropList.AddInputLineVideoOuput(const AInputLine: string): boolean;
var
   Ail, TextLabel, TextValue: string;
   P, I, J, R: integer;
begin  // VO: [directx] 352x240 => 352x240 Planar YV12
Result := false;
Ail := AInputLine;
if not(Copy(Ail, 1, 5) = 'VO: [') then Exit;
P := Pos(' => ', Ail);
if P = 0 then Exit;
System.Delete(Ail, 1, P + 3);
P := Pos(#32, Ail);
if P = 0 then Exit;
SetLength(Ail, P - 1);
P := Pos('x', Ail);
if P = 0 then Exit;
Val(Copy(Ail, 1, P - 1), I, R);
if not(R = 0) or (I < 16) or not(I < 4096) then Exit;
Val(Copy(Ail, P + 1, 5), J, R);
if not(R = 0) or (J < 16) or not(J < 4096) then Exit;

TextLabel := 'VIDEONATIVE_WIDTH';
TextValue := IntToStr(I);
Add(TextLabel, TextValue);
TextLabel := 'VIDEONATIVE_HEIGHT';
TextValue := IntToStr(J);
Add(TextLabel, TextValue);
Result := true;
end;

procedure TMediaPropList.Clear;
begin
if FList.Count < 1 then
 Exit;

while FList.Count > 0 do
   begin
   GetItem(FList.Count - 1).Free;
   FList.Delete(FList.Count - 1);
   end;

 DoChange(- 1);
end;

function TMediaPropList.Count: integer;
begin
Result := FList.Count;
end;

constructor TMediaPropList.Create;
begin
FList := TList.Create;
end;

procedure TMediaPropList.Delete(const AIndex: integer);
begin
GetItem(AIndex).Free;
FList.Delete(AIndex);
DoChange(AIndex);
end;

destructor TMediaPropList.Destroy;
begin
Clear;
FList.Free;
inherited Destroy;
end;

procedure TMediaPropList.DoChange(const AIndex: integer);
begin
if Assigned(FOnChange) then
   FOnChange(Self, AIndex);
end;

function TMediaPropList.GetItem(const AIndex: integer): TMediaProp;
begin
Result := FList.Items[AIndex];
end;

function TMediaPropList.GetPropLabel(const AIndex: integer): string;
begin
Result := GetItem(AIndex).PropLabel;
end;

function TMediaPropList.GetPropLabelValue(const APropLabel: string): string;
var
   I: integer;
begin
I := IndexOf(APropLabel);
if I < 0 then
   Result := ''
else
   Result := GetPropValue(I);
end;

function TMediaPropList.GetPropValue(const AIndex: integer): string;
begin
Result := GetItem(AIndex).PropValue;
end;

function TMediaPropList.IndexOf(const APropLabel: string): integer;
var
   PLabel: string;
   T, I: integer;
begin
Result := - 1;
PLabel := Trim(APropLabel);
if PLabel = '' then Exit;
T := FList.Count - 1;
for I := 0 to T do
   if GetPropLabel(I) = PLabel then
      begin
      Result := I;
      Break;
      end;
end;

{ TMPlayer }

function TMPlayer.BrightnessDefault: boolean;
begin
Result := GetBrightness = DEF_BRIGHTNESS;
end;

procedure TMPlayer.BrightnessReset;
begin
if BrightnessDefault then Exit;
SetBrightness(DEF_BRIGHTNESS);
end;

function TMPlayer.CheckAudioDelay(const ALineInput: string): boolean;
var
   L: string;
   P: integer;
   AudioDelay: real;
begin
Result := false;
L := ALineInput;
if Length(L) < 15 then Exit;
if not(UpperCase(Copy(L, 1, 15)) = 'ANS_AUDIO_DELAY') then Exit;
Delete(L, 1, 15);
P := Pos('=', L);
if P < 1 then Exit;
Delete(L, 1, P);
L := Trim(L);
if Length(L) < 1 then Exit;
if not StrToReal(L, DECIMALPOINT, AudioDelay) then Exit;
DoAudioDelay(AudioDelay);
Result := true;
end;

function TMPlayer.CheckFailedOpen(const ALineInput: string): boolean;
var
   L: string;
begin
Result := false;
L := Trim(ALineInput);
if Length(L) < 14 then Exit;
if not(Copy(L, 1, 14) = 'Failed to open') then Exit;
DoFailedOpen;
Result := true;
end;

function TMPlayer.CheckFrameDrop(const ALineInput: string): boolean;
var
   L: string;
   P: integer;
   FDrop: TMPlayerFrameDrop;
begin
Result := false;
L := ALineInput;
if Length(L) < 17 then Exit;
if not(UpperCase(Copy(L, 1, 17)) = 'ANS_FRAMEDROPPING') then Exit;
Delete(L, 1, 17);
P := Pos('=', L);
if P < 1 then Exit;
Delete(L, 1, P);
L := Trim(L);
if not(Length(L) = 1) then Exit;
case L[1] of
  '0': FDrop := mfdDisabled;
  '1': FDrop := mfdEnabled;
  '2': FDrop := mfdHard;
  else
     Exit;
  end;
DoFrameDrop(FDrop);
Result := true;
end;

function TMPlayer.CheckMute(const ALineInput: string): boolean;
var
   L: string;
   P: integer;
begin
Result := false;
L := ALineInput;
if Length(L) < 8 then Exit;
if not(UpperCase(Copy(L, 1, 8)) = 'ANS_MUTE') then Exit;
Delete(L, 1, 8);
P := Pos('=', L);
if P < 1 then Exit;
Delete(L, 1, P);
L := Trim(L);
if Length(L) < 1 then Exit;
DoMute(not(UpperCase(L) = 'NO'));
Result := true;
end;

function TMPlayer.CheckPercentPosition(const ALineInput: string): boolean;
var
   L: string;
   P: integer;
   PercPos: real;
begin
Result := false;
L := ALineInput;
if Length(L) < 20 then Exit;
if not(UpperCase(Copy(L, 1, 20)) = 'ANS_PERCENT_POSITION') then Exit;
Delete(L, 1, 20);
P := Pos('=', L);
if P < 1 then Exit;
Delete(L, 1, P);
L := Trim(L);
if Length(L) < 1 then Exit;
if not StrToReal(L, DECIMALPOINT, PercPos) then Exit;
DoPercentPosition(PercPos);
Result := true;
end;

function TMPlayer.CheckSpeed(const ALineInput: string): boolean;
var
   L: string;
   P: integer;
   Speed: real;
begin
Result := false;
L := ALineInput;
if Length(L) < 9 then Exit;
if not(UpperCase(Copy(L, 1, 9)) = 'ANS_SPEED') then Exit;
Delete(L, 1, 9);
P := Pos('=', L);
if P < 1 then Exit;
Delete(L, 1, P);
L := Trim(L);
if Length(L) < 1 then Exit;
if not StrToReal(L, DECIMALPOINT, Speed) then Exit;
DoSpeed(Speed);
Result := true;
end;

function TMPlayer.CheckStartingPlayback(const ALineInput: string): boolean;
var
   L: string;
begin
Result := false;
L := ALineInput;

if Length(L) < 17 then
 Exit;

if not(UpperCase(Copy(L, 1, 17)) = 'STARTING PLAYBACK') then
 Exit;

 DoStartPlay;
Result := true;
end;

function TMPlayer.CheckTimePosition(const ALineInput: string): boolean;
var
   L: string;
   P: integer;
   Secs: real;
begin
Result := false;
L := ALineInput;
if Length(L) < 17 then Exit;
if not(UpperCase(Copy(L, 1, 17)) = 'ANS_TIME_POSITION') then Exit;
Delete(L, 1, 17);
P := Pos('=', L);
if P < 1 then Exit;
Delete(L, 1, P);
L := Trim(L);
if Length(L) < 1 then Exit;

if not StrToReal(L, DECIMALPOINT, Secs) then
 Exit;

DoTimePosition(Secs);
Result := true;
end;

function TMPlayer.CheckVolume(const ALineInput: string): boolean;
var
   L: string;
   P: integer;
   Vol: real;
begin
Result := false;
L := ALineInput;
if Length(L) < 10 then Exit;
if not(UpperCase(Copy(L, 1, 10)) = 'ANS_VOLUME') then Exit;
Delete(L, 1, 10);
P := Pos('=', L);
if P < 1 then Exit;
Delete(L, 1, P);
L := Trim(L);
if Length(L) < 1 then Exit;
if not StrToReal(L, DECIMALPOINT, Vol) then Exit;
DoVolume(Vol);
Result := true;
end;

procedure TMPlayer.Close;
begin
if FFirstChance then
   begin
   SendQuit;
   FFirstChance := false;
   end
else
   Terminate;
end;

procedure TMPlayer.CloseForced;
begin
if FFirstChance then
   begin
   SendQuit;
   FFirstChance := false;
   if WaitForSingleObject(FClientProcess, 1000) <> WAIT_TIMEOUT then Exit;
   end;
Terminate;
end;

procedure TMPlayer.CMDialogChar(var Message: TCMDialogChar);
begin
if FFullScreen and GetActive and (Message.CharCode = VK_ESCAPE) then
   begin
   SetFullScreen(false);
   Exit;
   end;
inherited;
end;

function TMPlayer.ColorsDefault: boolean;
begin
Result := BrightnessDefault and ContrastDefault and SaturationDefault; 
end;

procedure TMPlayer.ColorsReset;
begin
if not BrightnessDefault then
   BrightnessReset;
if not ContrastDefault then
   ContrastReset;
if not SaturationDefault then
   SaturationReset;
end;

function TMPlayer.ContrastDefault: boolean;
begin
Result := GetContrast = DEF_CONTRAST;
end;

procedure TMPlayer.ContrastReset;
begin
if ContrastDefault then Exit;
SetContrast(DEF_CONTRAST);
end;

constructor TMPlayer.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
Align := alClient;
Color := $00101010;
BevelInner := bvNone;
BevelOuter := bvNone;

FAudioOut := maoWin32;
FMPlayerPath := ExtractFileDir(Application.ExeName);

FfrmLog := TfrmLog.Create(nil);
FMediaPropList := TMediaPropList.Create;
FMediaPropList.OnChange := DoChangeProp;
FfrmProp := TfrmProp.Create(nil);

FTimer := TTimer.Create(nil);
FTimer.Enabled := false;
FTimer.Interval := 250; //1000;  //TC oppdateres 4 ganger i sekundet
FTimer.OnTimer := DoTimer;
FTimer.Enabled := true;
end;

function TMPlayer.DblQuotedIfSpace(const AString: string): string;
begin
if Pos(' ', AString) > 0 then
   Result := '"' + AString + '"'
else
   Result := AString;
end;

destructor TMPlayer.Destroy;
begin
FTimer.Free;
FMediaPropList.Free;
FfrmProp.Free;
FfrmLog.Free;
Terminate;
inherited Destroy;
end;

procedure TMPlayer.DoAudioDelay(const AAudioDelay: real);
begin
FAudioDelay := AAudioDelay;
if FOsdLevel > 0 then
SendCommand(OSD_SHOW + ' ' + 'AudioDelay:' + RealToStr(FAudioDelay, DECIMALPOINT));
   //SendCommand('osd_show_property_text' + ' ' + 'AudioDelay:' + RealToStr(FAudioDelay, DECIMALPOINT));

   if Assigned(FOnChangeAudioDelay) then
   FOnChangeAudioDelay(Self);
end;

procedure TMPlayer.DoChangeProp(ASender: TObject; const AIndex: integer);
begin
FfrmProp.UpdateProps(FMediaPropList);
if Assigned(FOnChangeProp) then
   FOnChangeProp(Self, AIndex);
end;

procedure TMPlayer.DoFailedOpen;
begin
FFailedOpen := true;
if Assigned(FOnFailedOpen) then FOnFailedOpen(Self);
end;

procedure TMPlayer.DoFrameDrop(const AFrameDrop: TMPlayerFrameDrop);
begin
FFrameDrop := AFrameDrop;
if Assigned(FOnChangeFrameDrop) then
   FOnChangeFrameDrop(Self);
end;

procedure TMPlayer.DoFullScreen(const AFullScreen: boolean);
var
   HWNDDesk: HWND;
begin
if AFullScreen then
   begin
   FHWNDCur := GetParent(Handle);
   HWNDDesk := GetDesktopWindow;
   windows.SetParent(Handle, HWNDDesk);
   Align := alNone;
   SetWindowPos(Handle, HWND_TOPMOST, 0, 0, Screen.Width, Screen.Height, SWP_SHOWWINDOW);
   end
else
   begin
   SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, Screen.Width, Screen.Height, SWP_SHOWWINDOW);
   Windows.SetParent(Handle, FHWNDCur);
   Align := alClient;
   end;
end;

procedure TMPlayer.DoInputLine(const ALineInput: string);
begin
if FFailedOpen then
 Exit;

if CheckTimePosition(ALineInput) then Exit;
if CheckPercentPosition(ALineInput) then Exit;
if CheckMute(ALineInput) then Exit;
if CheckSpeed(ALineInput) then Exit;
if CheckFrameDrop(ALineInput) then Exit;
if CheckVolume(ALineInput) then Exit;
if CheckStartingPlayback(ALineInput) then Exit;
if CheckAudioDelay(ALineInput) then Exit;
FfrmLog.Add(ALineInput);
FMediaPropList.AddInputLine(ALineInput);
if Assigned(FOnLogAdd) then FOnLogAdd(Self);
CheckFailedOpen(ALineInput);
end;

procedure TMPlayer.DoMute(const AValue: boolean);
begin
FMute := AValue;
end;

procedure TMPlayer.DoOnTimer;
begin
if Assigned(FOnTimer) then
   FOnTimer(Self);
end;

procedure TMPlayer.DoPercentPosition(const APercPos: real);
begin
try
FProgressPosition := Round(APercPos);
DoProgress;

   except
   end;
end;

procedure TMPlayer.DoPlayEnd;
begin
FAudioDelay := 0;
FBrightness := DEF_BRIGHTNESS;
FContrast := DEF_CONTRAST;
FFrameDrop := mfdEnabled;
FMediaPropList.Clear;
FMute := false;
FOsdLevel := 1;
FProgressPosition := 0;
FSaturation := DEF_SATURATION;
FSpeed := 1;
FSpeedChanged := false;
FTimePosition := 0;
FVolume := 10;
if Assigned(FOnPlayEnd) then
   FOnPlayEnd(Self);
Visible := false;
Visible := true;
if FFullScreen then
   DoFullScreen(false);
end;

procedure TMPlayer.DoProgress;
begin
if Assigned(FOnProgress) then
   FOnProgress(Self);
end;

procedure TMPlayer.DoSpeed(const ASpeed: real);
begin
FSpeed := ASpeed;
FSpeedChanged := not(FSpeed = 1);
if Assigned(FOnChangeSpeed) then
   FOnChangeSpeed(Self);
end;

procedure TMPlayer.DoStartPlay;
begin
if Assigned(FOnStartPlay) then
   FOnStartPlay(Self);
end;

procedure TMPlayer.DoTimePosition(const ASecs: real);
var
  TotalTime: real;
  ProgPos: integer;
begin
FTimePosition := ASecs;
TotalTime := GetSecsLength;
if TotalTime = 0 then
    ProgPos := 0
else
    ProgPos := Round(ASecs * 100 / TotalTime);
if ProgPos = FProgressPosition then Exit;
try
FProgressPosition := ProgPos;
DoProgress;

   except
   end;
end;

procedure TMPlayer.DoTimer(ASender: TObject);
var
   LineIn: string;
begin

while Assigned(FProcessor) and FProcessor.ExtractData(LineIn) do
   begin
   DoInputLine(LineIn);
   end;

FTimeQueryTick := 0;
if GetActive and not FPaused then
   SendGetTimePos;

DoOnTimer;
end;

procedure TMPlayer.DoVolume(const AVolume: real);
begin
FVolume := AVolume;
if FOsdLevel > 0 then
 SendCommand(OSD_SHOW + ' ' + 'volume:' + RealToStr(FVolume, DECIMALPOINT));
   //SendCommand('osd_show_property_text' + ' ' + 'volume:' + RealToStr(FVolume, DECIMALPOINT));

   if Assigned(FOnChangeVolume) then
   FOnChangeVolume(Self);
end;

procedure TMPlayer.FetchData;
var
   ALine: string;
begin
if not Assigned(FProcessor) then Exit;
while FProcessor.ExtractData(ALine) do
   DoInputLine(ALine);
end;

function TMPlayer.GetActive: boolean;
begin
Result := not(FClientProcess = 0);
end;

function TMPlayer.GetAspect: TMPlayerAspect;
begin
Result := FAspect;
end;

function TMPlayer.GetAudioDelay: real;
begin
Result := FAudioDelay;
end;

function TMPlayer.GetAudioOut: TMPlayerAudioOut;
begin
Result := FAudioOut;
end;

function TMPlayer.GetBrightness: integer;
begin
Result := FBrightness;
end;

function TMPlayer.GetContrast: integer;
begin
Result := FContrast;
end;

function TMPlayer.GetFailedOpen: boolean;
begin
Result := FFailedOpen;
end;

function TMPlayer.GetFontPath: string;
var
  WinDir: array[0..MAX_PATH] of char;
begin
GetWindowsDirectory(@WinDir[0], MAX_PATH);
Result := IncludeTrailingPathDelimiter(WinDir) + 'Fonts\' + OSDFONT;
end;

function TMPlayer.GetFrameDrop: TMPlayerFrameDrop;
begin
Result := FFrameDrop;
end;

function TMPlayer.GetFullScreen: boolean;
begin
Result := FFullScreen;
end;

function TMPlayer.GetHaveAudio: boolean;
begin
Result := false;
if not GetActive then Exit;
if FMediaPropList.IndexOf('AUDIO_ID') < 0 then Exit;
Result := true;
end;

function TMPlayer.GetHaveVideo: boolean;
begin
Result := false;
if not GetActive then Exit;
if FMediaPropList.IndexOf('VIDEO_ID') < 0 then Exit;
Result := true;
end;

function TMPlayer.GetLogLines: TStrings;
begin
Result := FfrmLog.mm.Lines;
end;

function TMPlayer.GetLogVisible: boolean;
begin
Result := FfrmLog.Visible;
end;

function TMPlayer.GetMediaAddr: string;
begin
Result := FMediaAddr;
end;

function TMPlayer.GetMediaPropList: TMediaPropList;
begin
Result := FMediaPropList
end;

function TMPlayer.GetMediaPropListVisible: boolean;
begin
Result := FfrmProp.Visible;
end;

function TMPlayer.GetMPlayerPath: string;
begin
Result := FMPlayerPath;
end;

function TMPlayer.GetMute: boolean;
begin
Result := FMute;
end;

function TMPlayer.GetOnChangeAudioDelay: TNotifyEvent;
begin
Result := FOnChangeAudioDelay;
end;

function TMPlayer.GetOnChangeFrameDrop: TNotifyEvent;
begin
Result := FOnChangeFrameDrop;
end;

function TMPlayer.GetOnChangeProp: TMediaPropIndexEvent;
begin
Result := FOnChangeProp;
end;

function TMPlayer.GetOnChangeSpeed: TNotifyEvent;
begin
Result := FOnChangeSpeed;
end;

function TMPlayer.GetOnChangeVolume: TNotifyEvent;
begin
Result := FOnChangeVolume;
end;

function TMPlayer.GetOnFailedOpen: TNotifyEvent;
begin
Result := FOnFailedOpen;
end;

function TMPlayer.GetOnLogAdd: TNotifyEvent;
begin
Result := FOnLogAdd;
end;

function TMPlayer.GetOnPlayEnd: TNotifyEvent;
begin
Result := FOnPlayEnd;
end;

function TMPlayer.GetOnProgress: TNotifyEvent;
begin
Result := FOnProgress;
end;

function TMPlayer.GetOnStartPlay: TNotifyEvent;
begin
Result := FOnStartPlay;
end;

function TMPlayer.GetOnTimer: TNotifyEvent;
begin
Result := FOnTimer;
end;

function TMPlayer.GetOsdLevel: integer;
begin
Result := FOsdLevel;
end;

function TMPlayer.GetParams: string;
begin
Result := FParams;
end;

function TMPlayer.GetPaused: boolean;
begin
Result := FPaused;
end;

function TMPlayer.GetPercentPosition: integer;
begin
Result := 0;
if not GetActive then Exit;
try
Result := FProgressPosition;

   except
   Result := 0;
   end;
end;

procedure TMPlayer.GetProperty(const APropName: string);
begin
if not GetActive or (FWritePipe = 0) then
   raise EMPlayerExeption.Create('mplayer not active, can''t get property' + sLineBreak + APropName);
SendCommand('get_property' + ' ' + APropName);
end;

function TMPlayer.GetReIndex: boolean;
begin
Result := FReIndex;
end;

function TMPlayer.GetSaturation: integer;
begin
Result := FSaturation;
end;

function TMPlayer.GetSecsLength: real;
var
  SLength: string;
  RLength: real;
begin
Result := 0;
if not GetActive then Exit;
SLength := FMediaPropList.GetPropLabelValue('LENGTH');
if SLength = '' then Exit;
if not StrToReal(SLength, DECIMALPOINT, RLength) then Exit;
Result := RLength;
end;

function TMPlayer.GetSpeed: real;
begin
Result := FSpeed;
end;

function TMPlayer.GetTimePosition: real;
var
   MSecsFromLastQuery: cardinal;
   Sp: real;
begin
Result := 0;
if not GetActive then Exit;
Result := FTimePosition;
if FTimeQueryTick = 0 then Exit;
MSecsFromLastQuery := GetTickCount - FTimeQueryTick;
Sp := GetSpeed;
case GetFrameDrop of
   mfdEnabled : if Sp > 6 then
                   Sp := 6; // max. speed framedrop enabled
   mfdHard    : begin end;
   mfdDisabled: if Sp > 4 then
                   Sp := 4; // max. speed framedrop disabled
   end;
MSecsFromLastQuery := Round(MSecsFromLastQuery * Sp);
Result := Result + MSecsFromLastQuery / 1000;
end;

function TMPlayer.GetVolume: real;
begin
Result := FVolume;
end;

function TMPlayer.MPlayerExists: boolean;
begin
Result := FileExists(FMPlayerPath + PathDelim + MPLAYEREXENAME);
end;

procedure TMPlayer.Open;
var
  CmdLine, FontPath: string;
  Sec: TSecurityAttributes;
  DummyPipe1, DummyPipe2: THandle;
  Si: TStartupInfo;
  Pi: TProcessInformation;
begin
Sleep(50); // wait for the processing threads to finish
Application.ProcessMessages;  // let the VCL process the finish messages

RaiseNoMplayer;
if FMediaAddr = '' then
   raise EMPlayerExeption.Create('media data not found');
RaiseAlreadyOpen;

FAudioDelay := 0;
FBrightness := DEF_BRIGHTNESS;
FContrast := DEF_CONTRAST;
FFailedOpen := false;
FFirstChance := true;
FFrameDrop := mfdEnabled;
FMute := false;
FOsdLevel := 1;
FProgressPosition := 0;
FSaturation := DEF_SATURATION;
FSpeed := 1;
FTimePosition := 0;
FVolume := 10;

FClientWaitThread := TClientWaitThread.Create(true);
FCLientWaitThread.MPlayer := Self;
FProcessor := TProcessor.Create(true);

 CmdLine := DblQuotedIfSpace(FMPlayerPath + PathDelim + MPLAYEREXENAME) + ' -quiet -slave -identify'
   + ' -wid '+ IntToStr(Handle) + ' -colorkey 0x101010'
   + ' -nokeepaspect -framedrop -autosync 100';

FontPath := GetFontPath;
if FileExists(FontPath) then
   FontPath := ' -font ' + DblQuotedIfSpace(FontPath);

if FReIndex then CmdLine := CmdLine + ' -idx';

case FAudioOut of
   maoNoSound : CmdLine := CmdLine + ' -nosound';
   maoNull    : CmdLine := CmdLine + ' -ao null';
   maoWin32   : CmdLine := CmdLine + ' -ao win32';
   maoDsSound : CmdLine := CmdLine + ' -ao dsound';
   end;

case FAspect of
   mpaAutoDetect: begin end;
   mpa40_30     : CmdLine := CmdLine + ' -aspect 4:3';
   mpa160_90    : CmdLine := CmdLine + ' -aspect 16:9';
   mpa235_10    : CmdLine := CmdLine + ' -aspect 2.35:1';
   end;

if not(FParams = '') then
   CmdLine := CmdLine + ' ' + FParams;

CmdLine := CmdLine + ' ' + DblQuotedIfSpace(FMediaAddr);

FfrmLog.Add('command line:');
FfrmLog.Add(CmdLine);
FfrmLog.Add('');

with Sec do
  begin
  nLength := SizeOf(Sec);
  lpSecurityDescriptor := nil;
  bInheritHandle := true;
  end;
CreatePipe(FReadPipe, DummyPipe1 , @sec, 0);

with Sec do
  begin
  nLength := SizeOf(Sec);
  lpSecurityDescriptor := nil;
  bInheritHandle := true;
  end;
CreatePipe(DummyPipe2, FWritePipe, @sec, 0);

FillChar(Si, SizeOf(Si), 0);
Si.cb := SizeOf(Si);
Si.dwFlags := STARTF_USESTDHANDLES;
Si.hStdInput := DummyPipe2;
Si.hStdOutput := DummyPipe1;
Si.hStdError := DummyPipe1;
CreateProcess(nil, PChar(CmdLine), nil, nil, true, DETACHED_PROCESS, nil, PChar(FMPlayerPath + PathDelim), Si, Pi);

CloseHandle(DummyPipe1);
CloseHandle(DummyPipe2);

FClientProcess := Pi.hProcess;
FClientWaitThread.hProcess := FClientProcess;
FProcessor.hPipe := FReadPipe;

FClientWaitThread.Resume;
FProcessor.Resume;

if FFullScreen then
   DoFullScreen(true);

if FPaused then SendCommand(CMD_PAUSE);
end;

procedure TMPlayer.RaiseAlreadyOpen;
begin
if GetActive then
   raise EMPlayerExeption.Create('media open, close first');
end;

procedure TMPlayer.RaiseNoMplayer;
begin
if not MPlayerExists then
   raise EMPlayerExeption.Create('mplayer not found');
end;

function TMPlayer.RealToStr(const AReal: real; ADecimalPoint: char): string;
var
   ValStr: string;
begin
if AReal < 0 then
   Result := '-'
else
   Result := '+';
ValStr := IntToStr(Round(Abs(AReal) * 100));
while Length(ValStr) < 3 do
   ValStr := '0' + ValStr;
Result := Result + Copy(ValStr, 1, Length(ValStr) - 2);
Result := Result + ADecimalPoint;
Delete(ValStr, 1, Length(ValStr) - 2);
Result := Result + ValStr;
end;

function TMPlayer.SaturationDefault: boolean;
begin
Result := GetSaturation = DEF_SATURATION;
end;

procedure TMPlayer.SaturationReset;
begin
if SaturationDefault then Exit;
SetSaturation(DEF_SATURATION);
end;

procedure TMPlayer.SendAudioDelay(const AValue: real);
begin
SendCommand(CMD_AUDIODELAY + ' ' + RealToStr(AValue, DECIMALPOINT));
end;

procedure TMPlayer.SendCommand(const ACommand: string);
var
   Dummy: cardinal;
   Cmd: string;
begin

 if not GetActive or (FWritePipe = 0) then
 begin
  // raise EMPlayerExeption.Create('mplayer not active, can''t send command' + sLineBreak + ACommand);

 end;

 Cmd := ACommand + #10;
 WriteFile(FWritePipe, Cmd[1], Length(Cmd), Dummy, nil);
end;

function TMPlayer.SendCommandWait(const ACommand: string;
   const ATimeOut: cardinal; const AMaxTries: byte): boolean;
var
  TryMax: byte;
begin
Result := false;
if ACommand = '' then Exit;
if AMaxTries < 1 then Exit;

FetchData;
TryMax := AMaxTries;
while true do
   begin
   SendCommand(ACommand);
   Result := WaitData(ATimeOut);
   if Result then
     Break;

    Dec(TryMax);
   if TryMax < 1 then
    Break;

   end;
end;

procedure TMPlayer.SendFrameDrop(const AValue: integer);
begin
SendCommand(CMD_FRAMEDROP + ' ' + IntToStr(AValue));
GetProperty('framedropping');
FPaused := false;
end;

procedure TMPlayer.SendFrameDropToogle;
begin
SendCommand(CMD_FRAMEDROP);
GetProperty('framedropping');
FPaused := false;
end;

procedure TMPlayer.SendFrameStep;
begin
SendGetTimePos;
SendCommand(CMD_FRAMESTEP);
FTimeQueryTick := 0;
FPaused := true;
end;

procedure TMPlayer.SendGetPercentPos;
begin
SendCommand(CMD_GETPERCENTPOS);
FPaused := false;
end;

procedure TMPlayer.SendGetTimePos;
begin
SendCommand(CMD_GETTIMEPOS);
FTimeQueryTick := GetTickCount;
FPaused := false;
end;

procedure TMPlayer.SendGrabFrames;
begin
SendCommand(CMD_GRABFRAMES);
FPaused := false;
end;

procedure TMPlayer.SendMute(const AValue: integer);
begin
SendCommand(CMD_MUTE + ' ' + IntToStr(AValue));
GetProperty('mute');
FPaused := false;
end;

procedure TMPlayer.SendMuteToogle;
begin
SendCommand(CMD_MUTE);
GetProperty('mute');
FPaused := false;
end;

procedure TMPlayer.SendOsd(const AValue: integer);
var
   V: integer;
begin
V := AValue;
if V < 0 then V := 0;
if V > 3 then V := 3;
SendCommand(CMD_OSD + ' ' + IntToStr(V));
FOsdLevel := V;
FPaused := false;
end;

procedure TMPlayer.SendOsdToogle;
begin
SendCommand(CMD_OSD);
Inc(FOsdLevel);
if FOsdLevel > 3 then
   FOsdLevel := 0;
FPaused := false;
end;

procedure TMPlayer.SendPause;
var
   IsPaused: boolean;
begin
IsPaused := FPaused;
SendGetTimePos;
SendCommand(CMD_PAUSE);
FPaused := not IsPaused;
if FPaused then
   FTimeQueryTick := 0;
end;

procedure TMPlayer.SendQuit;
begin
SendCommand(CMD_QUIT);
end;

procedure TMPlayer.SendSeek(const AValue: real; const AUsePercent: boolean);
var
   IsPaused: boolean;
begin
IsPaused := FPaused;
if AUsePercent then
   SendCommand(CMD_SEEK + ' ' + RealToStr(AValue, DECIMALPOINT) + ' ' + '1')
else
   SendCommand(CMD_SEEK + ' ' + RealToStr(AValue, DECIMALPOINT));
SendGetTimePos;
FPaused := IsPaused;
if IsPaused then
   SendCommand(CMD_PAUSE);
end;

procedure TMPlayer.SendSpeedIncr(const AValue: real);
begin
SendCommand(CMD_SPEEDINCR + ' ' + RealToStr(AValue, DECIMALPOINT));
GetProperty('speed');
FPaused := false;
FSpeedChanged := true;
end;

procedure TMPlayer.SendSpeedMult(const AValue: real);
begin
SendCommand(CMD_SPEEDMULT + ' ' + RealToStr(AValue, DECIMALPOINT));
GetProperty('speed');
FPaused := false;
FSpeedChanged := true;
end;

procedure TMPlayer.SendSpeedSet(const AValue: real);
begin
SendCommand(CMD_SPEEDSET + ' ' + RealToStr(AValue, DECIMALPOINT));
GetProperty('speed');
FPaused := false;
FSpeedChanged := not(Round(AValue * 100) = 100);
end;

procedure TMPlayer.SetActive(const AActive: boolean);
begin
if AActive = GetActive then Exit;
if AActive then
   Open
else
   Close;
end;

procedure TMPlayer.SetAspect(const AAspect: TMPlayerAspect);
begin
if AAspect = FAspect then Exit;
RaiseAlreadyOpen;
FAspect := AAspect;
end;

procedure TMPlayer.SetAudioDelay(const AAudioDelay: real);
var
   V: real;
begin
V := AAudioDelay;
if V < - 10 then V := - 10;
if V > + 10 then V := + 10;
if V = FAudioDelay then Exit;
SetProperty('audio_delay', RealToStr(AAudioDelay, DECIMALPOINT));
GetProperty('audio_delay');
FPaused := false;
end;

procedure TMPlayer.SetAudioOut(const AAudioOut: TMPlayerAudioOut);
begin
if AAudioOut = FAudioOut then Exit;
RaiseAlreadyOpen;
FAudioOut := AAudioOut;
end;

procedure TMPlayer.SetBrightness(const ABrightness: integer);
var
   V: integer;
begin
V := ABrightness;
if V < - 100 then V := - 100;
if V > + 100 then V := + 100;
if V = FBrightness then Exit;
SetProperty('brightness', IntToStr(V));
if FOsdLevel > 0 then
 SendCommand(OSD_SHOW + ' ' + 'brightness:' + IntToStr(V));
   //SendCommand('osd_show_property_text' + ' ' + 'brightness:' + IntToStr(V));

   FBrightness := V;
FPaused := false;
end;

procedure TMPlayer.SetContrast(const AContrast: integer);
var
   V: integer;
begin
V := AContrast;
if V < - 100 then V := - 100;
if V > + 100 then V := + 100;
if V = FContrast then Exit;
SetProperty('contrast', IntToStr(V));
if FOsdLevel > 0 then
 SendCommand(OSD_SHOW + ' ' + 'contrast:' + IntToStr(V));
   //SendCommand('osd_show_property_text' + ' ' + 'contrast:' + IntToStr(V));

   FContrast := V;
FPaused := false;
end;

procedure TMPlayer.SetFrameDrop(const AFrameDrop: TMPlayerFrameDrop);
begin
if AFrameDrop = GetFrameDrop then Exit;
case AFrameDrop of
   mfdEnabled : SendFrameDrop(1);
   mfdHard    : SendFrameDrop(2);
   mfdDisabled: SendFrameDrop(0);
   end;
end;

procedure TMPlayer.SetFullScreen(const AFullScreen: boolean);
begin
if AFullScreen = FFullScreen then Exit;
FFullScreen := AFullScreen;
if not GetActive then Exit;
DoFullScreen(FFullScreen);
end;

procedure TMPlayer.SetLogVisible(const AVisible: boolean);
begin
FfrmLog.Visible := AVisible;
end;

procedure TMPlayer.SetMediaAddr(const AMediaAddr: string);
begin
if AMediaAddr = FMediaAddr then Exit;
RaiseAlreadyOpen;
FMediaAddr := AMediaAddr;
end;

procedure TMPlayer.SetMediaPropListVisible(const AVisible: boolean);
begin
FfrmProp.Visible := AVisible;
end;

procedure TMPlayer.SetMPlayerPath(const AMPlayerPath: string);
begin
if AMPlayerPath = FMPlayerPath then Exit;
RaiseAlreadyOpen;
FMPlayerPath := AMPlayerPath;
end;

procedure TMPlayer.SetMute(const AValue: boolean);
begin
if AValue = FMute then Exit;
SendMuteToogle;
end;

procedure TMPlayer.SetOnChangeAudioDelay(const ANotifyEvent: TNotifyEvent);
begin
FOnChangeAudioDelay := ANotifyEvent;
end;

procedure TMPlayer.SetOnChangeFrameDrop(const ANotifyEvent: TNotifyEvent);
begin
FOnChangeFrameDrop := ANotifyEvent;
end;

procedure TMPlayer.SetOnChangeProp(const AMediaPropIndexEvent: TMediaPropIndexEvent);
begin
FOnChangeProp := AMediaPropIndexEvent;
end;

procedure TMPlayer.SetOnChangeSpeed(const ANotifyEvent: TNotifyEvent);
begin
FOnChangeSpeed := ANotifyEvent;
end;

procedure TMPlayer.SetOnChangeVolume(const ANotifyEvent: TNotifyEvent);
begin
FOnChangeVolume := ANotifyEvent;
end;

procedure TMPlayer.SetOnFailedOpen(const ANotifyEvent: TNotifyEvent);
begin
FOnFailedOpen := ANotifyEvent;
end;

procedure TMPlayer.SetOnLogAdd(const ANotifyEvent: TNotifyEvent);
begin
FOnLogAdd := ANotifyEvent;
end;

procedure TMPlayer.SetOnPlayEnd(const ANotifyEvent: TNotifyEvent);
begin
FOnPlayEnd := ANotifyEvent;
end;

procedure TMPlayer.SetOnProgress(const ANotifyEvent: TNotifyEvent);
begin
FOnProgress := ANotifyEvent;
end;

procedure TMPlayer.SetOnStartPlay(const ANotifyEvent: TNotifyEvent);
begin
FOnStartPlay := ANotifyEvent;
end;

procedure TMPlayer.SetOnTimer(const ANotifyEvent: TNotifyEvent);
begin
FOnTimer := ANotifyEvent;
end;

procedure TMPlayer.SetOsdLevel(const AOsdLevel: integer);
begin
if AOsdLevel = FOsdLevel then Exit;
SendOsd(AOsdLevel);
end;

procedure TMPlayer.SetParams(const AParams: string);
begin
if AParams = FParams then Exit;
RaiseAlreadyOpen;
FParams := AParams;
end;

procedure TMPlayer.SetPaused(const APaused: boolean);
begin
if APaused = FPaused then Exit;
if GetActive then
   SendPause
else
   FPaused := APaused;
end;

procedure TMPlayer.SetPercentPosition(const APercPos: integer);
var
  PP, CurPP: integer;
  TimePos: real;
begin
if not GetActive then Exit;
PP := APercPos;
if PP < 0 then PP := 0;
if PP > 99 then PP := 99;
CurPP := GetPercentPosition;
if PP = CurPP then Exit;
TimePos := PP * GetSecsLength / 100;
SetTimePosition(TimePos);
end;

procedure TMPlayer.SetProperty(const APropName, APropValue: string);
begin
if not GetActive or (FWritePipe = 0) then
   raise EMPlayerExeption.Create('mplayer not active, can''t set property' + sLineBreak + APropName);
SendCommand('set_property' + ' ' + APropName + ' ' + APropValue);
end;

procedure TMPlayer.SetReIndex(const AReIndex: boolean);
begin
if AReIndex = FReIndex then Exit;
RaiseAlreadyOpen;
FReIndex := AReIndex;
end;

procedure TMPlayer.SetSaturation(const ASaturation: integer);
var
   V: integer;
begin
V := ASaturation;
if V < - 100 then V := - 100;
if V > + 100 then V := + 100;
if V = FSaturation then Exit;
SetProperty('saturation', IntToStr(V));
if FOsdLevel > 0 then
 SendCommand(OSD_SHOW + ' ' + 'saturation:' + IntToStr(V));
   //SendCommand('osd_show_property_text' + ' ' + 'saturation:' + IntToStr(V));

   FSaturation := V;
FPaused := false;
end;

procedure TMPlayer.SetSpeed(const ASpeed: real);
begin
if ASpeed = FSpeed then Exit;
SetProperty('speed', RealToStr(ASpeed, DECIMALPOINT));
GetProperty('speed');
FPaused := false;
end;

procedure TMPlayer.SetTimePosition(const ATimeSecsPos: real);
begin
if not GetActive then Exit;
SendSeek(ATimeSecsPos - GetTimePosition, false);
end;

procedure TMPlayer.SetVolume(const AVolume: real);
begin
if AVolume = FVolume then Exit;
SetProperty('volume', RealToStr(AVolume, DECIMALPOINT));
GetProperty('volume');
FPaused := false;
end;

function TMPlayer.SpeedChanged: boolean;
begin
Result := FSpeedChanged;
end;

function TMPlayer.StrToReal(const ARealStr: string; ADecimalPoint: char; var ARealRes: real): boolean;
var
  R: string;
  CurDecSep: char;
begin
Result := false;
R := Trim(ARealStr);
if Length(R) < 1 then Exit;

CurDecSep := DecimalSeparator;
DecimalSeparator := ADecimalPoint;
try
try
ARealRes := StrToFloat(R);
ARealRes := Round(ARealRes * 100) / 100; // 2 digit round
Result := true;

   except
   end;

   finally
   DecimalSeparator := CurDecSep;
   end;
end;

procedure TMPlayer.Terminate;
begin
if GetActive then
   TerminateProcess(FClientProcess, cardinal(-1));
end;

function TMPlayer.WaitData(const ATimeOut: cardinal): boolean;
var
   ALine: string;
   TickStart: cardinal;
begin
Result := false;
TickStart := GetTickCount;
if not GetActive then Exit;
if not Assigned(FProcessor) then Exit;
if FProcessor.Suspended or FProcessor.Terminated then Exit;
Sleep(10);
while not FProcessor.ExtractData(ALine) do
   begin
   if ATimeOut = INFINITE then
      begin
      Sleep(10);
      Continue;
      end;
   if GetTickCount - TickStart < ATimeOut then
      begin
      Sleep(10);
      Continue;
      end;
   Exit;
   end;
Result := true;
DoInputLine(ALine);
while FProcessor.ExtractData(ALine) do
   DoInputLine(ALine)
end;

end.
