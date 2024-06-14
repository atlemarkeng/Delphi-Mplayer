
unit munits;

interface

uses
  mtyps,
  //p_edit,
  //p_combo,
  //p_memo,

  //wwdblook,

  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,                
  Controls,
  Forms,
  Grids,
  Dialogs,
  commctrl,
  ExtCtrls,
  StdCtrls,
  DBGrids,
  shellApi,
  Wwdbigrd,
  Wwdbgrid,
  JvExDBGrids,
  JvDBGrid,
  JvDBUltimGrid,

  cUnicode,
  
  DSPack,
  DirectShow9;

type
 PCharBuf = record
 str1: Pchar;
 str2: Pchar;
 destStr: Pchar;
 tmpStr: Pchar;
 srcLen: Integer;
 keyLen: Integer;
end;


type
  EdateInvalid = class(Exception);

  TunitFrm = class(TForm)
    aliasList: TListBox;
    Panel1: TPanel;
    fontLabel: TLabel;
    JvDBUltimGrid1: TJvDBUltimGrid;
    FG: TFilterGraph;


 //procedure fldEnter(sender: Tobject);
 //procedure fldExit(sender: Tobject);
 procedure FormCreate(Sender: TObject);

 private
    { Private declarations }

 hr,mins,sec,msec: Integer;
 strHr,strMins,strSec,strMsec: packed array[1..6] of char;
 signFlag,tmpTc: String;
 pcb: PCharBuf;
 saveBkgColor,saveTxtColor: Tcolor;

  procedure splitTime(stm: String);
  function UTF16GetNextChar(const S: TUTF16String; var StrPos: SizeInt): UCS4;
  function UTF16SetNextChar(var S: WideString; var StrPos: Integer; Ch: UCS4): Boolean;

  procedure FlagInvalidUCS2Char(var Ch: UCS4);
  procedure FlagInvalidSequence(var StrPos: SizeInt; Increment: SizeInt; out Ch: UCS4);


 public
    { Public declarations }
   //OBS: midlertidig variable som skal assignes til var parameter
   //     i funksjoner MÅ ligge her og ikke lokalt. Ellers oppfører
   //     'var' seg mystisk etterpå.
   strChars: packed array [1..127] of char;

{$IFNDEF DVC}

  function  checkRunning(ActivateIt: boolean) : Boolean;
  procedure initPbar;
  function  AddPbar(Wnd: hWnd): hWnd;
  procedure AlignPbar(w,h: Integer; pBarWnd: hWnd; wctl: TwinControl);
  procedure AddPband(w,h: Integer; pBarWnd: hWnd; wctl: TWinControl);

  procedure initPnlMove(ppo: pPnlObj; id: Integer; sender: Tobject);
  procedure doPnlMove(ppo: pPnlObj; xpos,ypos: Integer;
             sender: Tobject; shift: TshiftState);
  procedure stopPnlMove(ppo: pPnlObj);
  procedure setPnlSize(ppo: pPnlObj; xpos,ypos: Integer);
 {$ENDIF}

 // constructor Create(AOwner: TComponent); override;

  function  msgDlg(txt: String; cmd: Integer): Integer;

  function  strReplace(src: PChar; const skey: Pchar;
		  const fill: PChar): String;
  //function memset(var src: String; const fill: Char; len: Longint): Byte;

  function  snult(var src: String): Word;

  function  strToUpper(src: String): String;
  function  strToLower(src: String): String;

  function  chToUpper(ch: Char): Char;
  function  chToLower(ch: Char): Char;

  function  breakStrToInts(str: String; delim: Char;  ar: pARFLDI): Integer;
  function  breakStrToStrs(str: String; delim: Char;  ar: pARFLDS): Integer;
  function  setWindowSize(mdi,frm: Tform; cmd: Integer): Integer;

  function  atoi(const val: String): Integer;
  function  atof(const val: String): Real;

  function  isAlpha(ch: Char): Boolean;
  function  isDigit(ch: Char): Boolean;
  //procedure markToggle(fld: Tfld; var key: Char);

  //function  isDataFld(sender: Tobject): Integer;
  function  getParseValue(str: String; var ival: Integer): String;

  function  makeFontStyle(fs:String): TfontStyles;
  function  getFontStyle(fs:TfontStyles): String;
  function  stripLastChr(var str: String; keys,stop: String): Integer;
  function  checkDir(dr: String; cmd: Integer): Integer;
  function  formatFloatToStr(floatVal: Real; mask: String): String;

  function  deciTimeToFrames(tm: Real): Integer;
  function  framesToDeciTime(frms: Integer): Real;


  function  encodeTCdate(tcs: String; var hr,min,sec,frms: Integer): TdateTime;

  function  encodeTCstr(hr,min,sec,frms: Integer): String;

  function  format_TC(tcs: String; showFrames: Boolean): String;

  function  TC_lenToStr(tc_in,tc_out: STring; showAsTC: Boolean): String;

  function  TC_lenToExitStr(tc_in,tc_len: STring; showAsTC: Boolean): String;

  function  TC_toFrames(tcs: String): Integer;
  function  FramesTo_TC(frms: Integer; showFrames: Boolean): String;
  function  TC_toLen(tcs: String): String;
  function  TC_add(tc1,tc2: String; typ: Integer): String;

  function  TC_add_frames(tcs: String; frms: Integer): String;

  function  TCtoMin(tc: TdateTime): Integer;
  function  minToTC(min: Integer): TdateTime;
  function  strTimeToTC(stm: String): TdateTime;

  function  TCtoStrTime(tc: TdateTime): String;
  function  TCtoStrTimeTC(tc: TdateTime): String;

  function  calcFrameTime(mediaLen: Real): Real;

  function  minToStrTime(min: Integer; leadZeros: Integer): String;
  function  secToStrTime(secs: Integer; leadZeros: Integer): String;

  function  strTimeToMin(stm: String): Integer;

  function  strTimeToStrMin(stm: String): String;
  function  strMinToStrTime(smin: String; leadZeros: Integer): String;
  function  strMinToStrTCount(stm: String): String;

  function minToStrFloat(min: Integer): String;
  function strFloatToMin(stf: String): Integer;

  function roundMinToMin(min: Integer; cmd: Integer): Integer;
  function strTimeToStrDays(stm,ref: String): String;

  function  minToDeciStr(min: Integer;sep: String): String;
  function  deciStrToMin(str: String): Integer;



  function  stripBlanks(src: String): String;
  function  stripChars(src: String; ch: Char): String;
  function  charReplace(src: String; key,fill: Char): String;

  function  isWildCardInStr(str: String): Boolean;
  function  setOraWildcards(str: String): String;

  function  removeWildCards(str: String): String;
  function  removeQuotes(str: String): String;

  function  convertQuotes(str: String): String;

  function  makeValidStrTime(str: String): String;
  function  makeClipStr(str: String; sep: Char): String;

 {
  function checkMidNightPass(t1,t2:Integer): Integer;
  function timeLen(t1,t2: Integer): Integer;
 }
  function getOS: integer;
  function convertFormulaDate(dat: String): String;
  function dateStrToPBdate(dat: String): STring;

  function StrNumToStrTime(val: String; sep: String): String;
  function strTimeToStrNum(val: String; var sign: String): String;
  function strCharOnly(str: String): String;
  function strNumOnly(str: String): String;
  function checkTextWidth(txt: String; fnt: Tfont; maxwidth,cmd: Integer): String;
  function colorToHTML(colr: Tcolor): String;
  function formatTimeStr(val: String; leadZeros: Integer): String;
  function getTimeSepPos(val: String): Integer;

  //function checkNorChars(str: String): Integer;
  function strChange(str, key,fill: String): String;


  function replaceXMLnorChars(str: String): String;
  function replaceNorCharsXML(str: String): String;

  function decodeXMLnorChars(str: String): String;
  function decodeXMLreserved(wstr: WideString): Widestring;


  function intToDeciStr(val: Integer): String;
  function deciStrToInt(str: String): Integer;
  function getDelimPos(str: String; startPos: Integer): Integer;

  function minToFormulaStrMin(min: Integer; rndTyp: Integer): string;
  function formatFormulaValue(strMin: String): String;

  function formatProdNr(prodnr: String; typ: Integer): String;
  function fillProdNr(prodnr,dep: String): String;


  function countChars(str: String; ch: Char): Integer;
  function minVal(v1,v2: Real): Real;
  function maxVal(v1,v2: Real): Real;
  function strFloat(str: String;prec: Integer): String;

  function cleanupStr(str: String): String;
  function cleanupWideStr(wstr: WideString): String;


  function cleanupBlanks(str: String): String;

  function cleanupMemoStr(str: String): String;

  function safeSQL(str: String): String;
//  function safeSQL2(str: String): String;
  function safeSQL_2(str: String): String;

  function cleanupProdNr(str: String): String;

  function timeToCount(str: String; prec: Integer): String;
  function formatTime(min: Integer): String;

  function stepScaleMins(var mins: Integer; cmd: Integer): String;

  function difDateTimeMins(fromDtm,toDtm: TdateTime): Integer;
  function floatToSQLnumber(fval: Real): String;
  //function fillNullTime(fld: TovcPictureField): Integer;
  function  minToDaysStr(min,dayLen: Integer): String;
  function getTimeStr(tcs: String): String;
  function replaceNorChar(str: String): String;
  function isKeyNullTime(str: STring): Boolean;
  function isKeyTimeValue(str: STring): Boolean;

  function isCharNorChar(ch: Char): Boolean;
  function isNorCharInString(str: String): Boolean;
  function replaceNorCharInString(str: String; replch: Char): String;

  function makeStrValid(str: String): String;
  function getLum(colr: Tcolor): Integer;

  function removeAmPm(tstr: String): String;
  function dtmTimeToStr(dtm: TdateTime): String;
  function stripWildCards(str: String): String;
  function minToFldStrTime(min: Integer; leadZeros: Integer): String;
  function addFileToPath(path,fileName: String): String;

  procedure writeCanvas(str: String; sender: Tobject; rect: Trect;
     fldColor,fontColor: Tcolor);

  function framesToTimeStr(frames: Integer): String;
  function getMediaClipLen(filename: String; var sec_len: Integer): String;
  function getMediaClipName(filename: String): String;

  function isMediaVideo(filename: String): Boolean;
  function isMediaAudio(filename: String): Boolean;
  function isMediaImage(filename: String): Boolean;
  function isMediaPDF(filename: String): Boolean;
  function isMediaFlash(filename: String): Boolean;


  function getMediaExt(filename: String): String;
  function getCleanFilename(filename: String): String;

  function execWinProgr(path,name: String): Integer;

  function getTopicCode(flname,prefix: String): String;
  function getAspectCode(flname,suffix: String): String;

  function isStrClean(str: String; allowChar1,allowChar2: Char): Boolean;
  function move_File(flname,destDir: String; overwrt: Boolean): Boolean;
  function copy_File(flname,destDir: String): Boolean;
  function delete_File(flname: String): Boolean;

  function ShellFindExecutable(const FileName, DefaultDir: string): string;

  function getFileSize(flname: string): Integer;

  function strToUnicode(str: String): String;

  function isQryFilled(fdata,fname: String): Boolean;

  function isFileName(flname: String): Boolean;

  function isPBid(pbid: STring): Boolean;

  function isFldBlank(str: String): Boolean;
  function isFldEmpty(str: String): Boolean;

  function getLastPos(skey,str: String): Integer;

  function isFileBrowse(flname: String): Boolean;

  function getCleanText(txt: STring): STring;

  function WideStringToString(const ws: WideString; codePage: Word): String;
  function StringToWideString(const s: AnsiString; codePage: Word): WideString;
  function WideStrToUTF8(wstr: WideString): string;
  function saveStream(flname: String; wstr: WideString): Integer;
  function saveWideStringToUTF8(flname:string; wstr:WideString): Integer;

  function readStream(flname: String): WideString;
  function streamToString(aStream: TStream): string;

  function StrReplaceW(wSource: WideString;
                             const wSearch, wReplace: WideString): WideString;

  function UTF16ToUTF8(const wstr: WideString): String;

  function WideStringToUTF16(const wstr: WideString): WideString; // WideString = UCS2
  function UTF16ToWideString(const wstr: WideString): WideString; // WideString = UCS2

  function getNodeLine(nstr: String; caseMatch: Boolean): String;
  function getNodeValue(nstr: String): String;

  function isTagMatch(xtag,xkey: String): Boolean;

  procedure PostKeyEx32(key: Word; const shift: TShiftState; specialkey: Boolean);
  procedure PostKeyExHWND(hWindow: HWnd; key: Word; const shift: TShiftState;
                                   specialkey: Boolean);

 end;

  function InitCommonControlsEx (var ICCRec: TICCEx): Boolean; stdcall; external 'COMCTL32.DLL';

var
  unitFrm: TunitFrm;


//Function prototypes

implementation

uses
  cUnicodeCodecs;
//uses
// xprocs;
 //cStrings;

{$R *.DFM}
//{$B-}
{$H+}


//Functions
{
constructor TunitFrm.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
 //Div buffer for strreplace(). For å slippe allokering hver gang denne brukes

 pcb.str1 :=StrAlloc(MAX_PCHAR_LEN);
 pcb.str2 :=StrAlloc(MAX_PCHAR_LEN);
 pcb.destStr :=StrAlloc(MAX_PCHAR_LEN);
 pcb.tmpStr :=StrAlloc(MAX_PCHAR_LEN);

end;
}

procedure TunitFrm.PostKeyEx32(key: Word; const shift: TShiftState; specialkey: Boolean);
{************************************************************
* Procedure PostKeyEx32
*
* Parameters:
*  key    : virtual keycode of the key to send. For printable
*           keys this is simply the ANSI code (Ord(character)).
*  shift  : state of the modifier keys. This is a set, so you
*           can set several of these keys (shift, control, alt,
*           mouse buttons) in tandem. The TShiftState type is
*           declared in the Classes Unit.
*  specialkey: normally this should be False. Set it to True to
*           specify a key on the numeric keypad, for example.
* Description:
*  Uses keybd_event to manufacture a series of key events matching
*  the passed parameters. The events go to the control with focus.
*  Note that for characters key is always the upper-case version of
*  the character. Sending without any modifier keys will result in
*  a lower-case character, sending it with [ssShift] will result
*  in an upper-case character!
************************************************************}
type
  TShiftKeyInfo = record
    shift: Byte;
    vkey: Byte;
  end;
  byteset = set of 0..7;
const
  shiftkeys: array [1..3] of TShiftKeyInfo =
    ((shift: Ord(ssCtrl); vkey: VK_CONTROL),
    (shift: Ord(ssShift); vkey: VK_SHIFT),
    (shift: Ord(ssAlt); vkey: VK_MENU));
var
  flag: DWORD;
  bShift: ByteSet absolute shift;
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    if shiftkeys[i].shift in bShift then
      keybd_event(shiftkeys[i].vkey, MapVirtualKey(shiftkeys[i].vkey, 0), 0, 0);
  end; { For }
  if specialkey then
    flag := KEYEVENTF_EXTENDEDKEY
  else
    flag := 0;
  keybd_event(key, MapvirtualKey(key, 0), flag, 0);
  flag := flag or KEYEVENTF_KEYUP;
  keybd_event(key, MapvirtualKey(key, 0), flag, 0);
  for i := 3 downto 1 do
  begin
    if shiftkeys[i].shift in bShift then
      keybd_event(shiftkeys[i].vkey, MapVirtualKey(shiftkeys[i].vkey, 0),
        KEYEVENTF_KEYUP, 0);
  end; { For }
end; { PostKeyEx32 }
{
procedure TForm1.Button1Click(Sender: TObject);
begin
  PostKeyEx32(VK_LWIN, [], False);
  PostKeyEx32(Ord('D'), [], False);
  PostKeyEx32(Ord('C'), [ssctrl, ssAlt], False);
end;
}

{************************************************************}
{2. With keybd_event API}

{
procedure TForm1.Button1Click(Sender: TObject);
begin
  //or you can also try this simple example to send any
  // amount of keystrokes at the same time.
  //Pressing the A Key and showing it in the Edit1.Text
  Edit1.SetFocus;
  keybd_event(VK_SHIFT, 0, 0, 0);
  keybd_event(Ord('A'), 0, 0, 0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
  //Presses the Left Window Key and starts the Run
  keybd_event(VK_LWIN, 0, 0, 0);
  keybd_event(Ord('R'), 0, 0, 0);
  keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);
end;
}

{***********************************************************}
{3. With keybd_event API}

procedure TunitFrm.PostKeyExHWND(hWindow: HWnd; key: Word; const shift: TShiftState;
  specialkey: Boolean);
{************************************************************
* Procedure PostKeyEx 
* 
* Parameters: 
*  hWindow: target window to be send the keystroke 
*  key    : virtual keycode of the key to send. For printable 
*           keys this is simply the ANSI code (Ord(character)). 
*  shift  : state of the modifier keys. This is a set, so you 
*           can set several of these keys (shift, control, alt, 
*           mouse buttons) in tandem. The TShiftState type is 
*           declared in the Classes Unit. 
*  specialkey: normally this should be False. Set it to True to 
*           specify a key on the numeric keypad, for example. 
*           If this parameter is true, bit 24 of the lparam for 
*           the posted WM_KEY* messages will be set. 
* Description: 
*  This 
procedure sets up Windows key state array to correctly 
*  reflect the requested pattern of modifier keys and then posts 
*  a WM_KEYDOWN/WM_KEYUP message pair to the target window. Then 
*  Application.ProcessMessages is called to process the messages 
*  before the keyboard state is restored. 
* Error Conditions: 
*  May fail due to lack of memory for the two key state buffers. 
*  Will raise an exception in this case. 
* NOTE: 
*  Setting the keyboard state will not work across applications
*  running in different memory spaces on Win32 unless AttachThreadInput
*  is used to connect to the target thread first. 
*Created: 02/21/96 16:39:00 by P. Below 
************************************************************} 
type 
  TBuffers = array [0..1] of TKeyboardState; 
var 
  pKeyBuffers: ^TBuffers; 
  lParam: LongInt; 
begin 
  (* check if the target window exists *) 
  if IsWindow(hWindow) then 
  begin 
    (* set local variables to default values *) 
    pKeyBuffers := nil; 
    lParam := MakeLong(0, MapVirtualKey(key, 0)); 
    (* modify lparam if special key requested *) 
    if specialkey then 
      lParam := lParam or $1000000; 
    (* allocate space for the key state buffers *) 
    New(pKeyBuffers); 
    try 
      (* Fill buffer 1 with current state so we can later restore it. 
         Null out buffer 0 to get a "no key pressed" state. *) 
      GetKeyboardState(pKeyBuffers^[1]); 
      FillChar(pKeyBuffers^[0], SizeOf(TKeyboardState), 0); 
      (* set the requested modifier keys to "down" state in the buffer*) 
      if ssShift in shift then 
        pKeyBuffers^[0][VK_SHIFT] := $80; 
      if ssAlt in shift then
      begin 
        (* Alt needs special treatment since a bit in lparam needs also be set *) 
        pKeyBuffers^[0][VK_MENU] := $80; 
        lParam := lParam or $20000000; 
      end; 
      if ssCtrl in shift then 
        pKeyBuffers^[0][VK_CONTROL] := $80; 
      if ssLeft in shift then 
        pKeyBuffers^[0][VK_LBUTTON] := $80; 
      if ssRight in shift then 
        pKeyBuffers^[0][VK_RBUTTON] := $80; 
      if ssMiddle in shift then 
        pKeyBuffers^[0][VK_MBUTTON] := $80; 
      (* make out new key state array the active key state map *) 
      SetKeyboardState(pKeyBuffers^[0]); 
      (* post the key messages *) 
      if ssAlt in Shift then 
      begin 
        PostMessage(hWindow, WM_SYSKEYDOWN, key, lParam); 
        PostMessage(hWindow, WM_SYSKEYUP, key, lParam or $C0000000); 
      end 
      else 
      begin 
        PostMessage(hWindow, WM_KEYDOWN, key, lParam);
        PostMessage(hWindow, WM_KEYUP, key, lParam or $C0000000);
      end;
      (* process the messages *)
      Application.ProcessMessages;
      (* restore the old key state map *)
      SetKeyboardState(pKeyBuffers^[1]);
    finally
      (* free the memory for the key state buffers *)
      if pKeyBuffers <> nil then
        Dispose(pKeyBuffers);
    end; { If }
  end;
end; { PostKeyEx }

{
procedure TForm1.Button1Click(Sender: TObject);
var
  targetWnd: HWND;
begin
  targetWnd := FindWindow('notepad', nil)
    if targetWnd <> 0 then
    begin
      PostKeyExHWND(targetWnd, Ord('I'), [ssAlt], False);
  end;
end;

}
{***********************************************************}
{3. With SendInput API}

{
procedure TForm1.Button1Click(Sender: TObject);
const
   Str: string = 'writing writing writing';
var
  Inp: TInput;
  I: Integer;
begin
  Edit1.SetFocus;
  for I := 1 to Length(Str) do
  begin
    Inp.Itype := INPUT_KEYBOARD;
    Inp.ki.wVk := Ord(UpCase(Str[i]));
    Inp.ki.dwFlags := 0;
    SendInput(1, Inp, SizeOf(Inp));
    Inp.Itype := INPUT_KEYBOARD;
    Inp.ki.wVk := Ord(UpCase(Str[i]));
    Inp.ki.dwFlags := KEYEVENTF_KEYUP;
    SendInput(1, Inp, SizeOf(Inp));
    Application.ProcessMessages;
    Sleep(80);
  end;
end;
}
{
procedure TunitFrm.SendAltTab;
var
  KeyInputs: array of TInput;
  KeyInputCount: Integer;

procedure KeybdInput(VKey: Byte; Flags: DWORD);
  begin
    Inc(KeyInputCount);
    SetLength(KeyInputs, KeyInputCount);
    KeyInputs[KeyInputCount - 1].Itype := INPUT_KEYBOARD;
    with  KeyInputs[KeyInputCount - 1].ki do
    begin
      wVk := VKey;
      wScan := MapVirtualKey(wVk, 0);
      dwFlags := KEYEVENTF_EXTENDEDKEY;
      dwFlags := Flags or dwFlags;
      time := 0;
      dwExtraInfo := 0;
    end;
  end;

 begin
  KeybdInput(VK_MENU, 0);                // Alt
  KeybdInput(VK_TAB, 0);                 // Tab
  KeybdInput(VK_TAB, KEYEVENTF_KEYUP);   // Tab
  KeybdInput(VK_MENU, KEYEVENTF_KEYUP); // Alt
  SendInput(KeyInputCount, KeyInputs[0], SizeOf(KeyInputs[0]));
end;
}


function TunitFrm.deciTimeToFrames(tm: Real): Integer;
var
 frms,sec: Integer;
 dif: Real;
begin

 frms :=0;
 Result :=frms;

 if tm=0 then
  exit;

  //hele sekunder
 {
  sec :=trunc(tm);

  dif :=tm -sec;  //millisekunder

  frms :=round((sec*VIDEO_FRAME_RATE)+(dif*VIDEO_FRAME_RATE));
 }

  frms :=round(tm*VIDEO_FRAME_RATE);

  Result :=frms;
end;

function TunitFrm.framesToDeciTime(frms: Integer): Real;
var
 tm: Real;
 frmi,dif_frms: Integer;
begin
 tm :=0;
 Result :=tm;

 if frms=0 then
  exit;

 //112 4 sek 12 frames
 {
 frmi :=trunc(frms/VIDEO_FRAME_RATE)*VIDEO_FRAME_RATE;

 tm :=frmi/VIDEO_FRAME_RATE;  //hele sekunder

 dif_frms :=frms-frmi;

 tm :=tm+((dif_frms*100/25)/100);
 }

 tm :=round(frms/VIDEO_FRAME_RATE);

 Result :=tm;
end;



function TunitFrm.encodeTCstr(hr, min, sec,frms: Integer): String;
var
 hrs,mins,secs,frs,str: String;
begin

    hrs :=format('%02d',[hr]);
    mins :=format('%02d',[min]);
    secs :=format('%02d',[sec]);
    frs :=format('%02d',[frms]);


   if (frms>=0) and (frms<VIDEO_FRAME_RATE) then
    str :=format('%s%s%s%s%s%s%s',[hrs,TC_SEP,mins,TC_SEP,secs,TC_SEP,frs])
   else
    str :=format('%s%s%s%s%s',[hrs,TC_SEP,mins,TC_SEP,secs]);

    str :=strReplace(PChar(str),BLANK,NULLDIGIT);


 Result :=str;

end;


 function TunitFrm.encodeTCdate(tcs: String; var hr,min,sec,frms: Integer): TdateTime;
 var
 // hr,min,sec: Integer;
  dtm: TdateTime;
  msec: Integer;
 begin

  dtm :=0;

  hr :=0;
  min :=0;
  sec :=0;
  frms :=0;
  msec :=0;

  Result :=dtm;
  if tcs=NUL then
   exit;

   hr :=atoi(copy(tcs,1,2));
   min :=atoi(copy(tcs,4,2));
   sec :=atoi(copy(tcs,7,2));

  if length(trim(tcs))>=TC_LEN_F then
   frms :=atoi(copy(tcs,10,2))
  else
   frms :=0; 

   if (frms>=0) and (frms<=VIDEO_FRAME_RATE) then
   begin
    msec :=round((frms/VIDEO_FRAME_RATE)/1000);
   end;

  dtm :=encodeTime(hr,mins,sec,msec);

  Result :=dtm;
 end;


 function TunitFrm.isTagMatch(xtag,xkey: String): Boolean;
 begin

  Result := (AnsiCompareText(copy(trim(xkey),1,length(xtag)),xtag)=0);


 end;

 function TunitFrm.getNodeValue(nstr: String): String;
 var
  str,xstr: String;
  ps1,ps2,len: Integer;
 begin
  str :=NUL;
  Result :=str;

  xstr :=trim(nstr);

  if xstr=NUL then
   exit
  else
  if (copy(xstr,1,1)<>'<') OR (copy(xstr,1,2)='</') then
    exit;

  ps1 :=pos('>',xstr);
  ps2 :=pos('</',xstr);

  len :=(ps2-ps1)-1;
  if len<=0 then
   exit
  else
   str :=trim(copy(xstr,ps1+1,len));

  Result :=str;
 end;


 function TunitFrm.getNodeLine(nstr: String; caseMatch: Boolean): String;
 var
  str: String;
 begin

  if not caseMatch then
   str :=trim(lowercase(nstr))
  else
   str :=trim(nstr);

  Result :=str;
 end;


procedure TunitFrm.FlagInvalidUCS2Char(var Ch: UCS4);
begin
  {$IFDEF UNICODE_SILENT_FAILURE}
  Ch := UCS4ReplacementCharacter;
  {$ELSE ~UNICODE_SILENT_FAILURE}
   //raise EJclUnicodeError.CreateResFmt(@RsEInvalidUCS2Char, [Ch]);
  {$ENDIF ~UNICODE_SILENT_FAILURE}
end;

procedure TunitFrm.FlagInvalidSequence(var StrPos: SizeInt; Increment: SizeInt; out Ch: UCS4);
begin
  {$IFDEF UNICODE_SILENT_FAILURE}
  Ch := UCS4ReplacementCharacter;
  Inc(StrPos, Increment);
  {$ELSE ~UNICODE_SILENT_FAILURE}
  StrPos := -1;
  {$ENDIF ~UNICODE_SILENT_FAILURE}
end;


function TunitFrm.UTF16SetNextChar(var S: WideString; var StrPos: Integer; Ch: UCS4): Boolean;
var
  StrLength: Integer;
begin
  StrLength := Length(S);

  if Ch <= MaximumUCS2 then
  begin
    // 16 bits to store in place
    Result := StrPos <= StrLength;
    if Result then
    begin
      S[StrPos] := WideChar(Ch);
      Inc(StrPos);
    end;
  end
  else
  if Ch <= MaximumUTF16 then
  begin
    // stores a surrogate pair
    Result := StrPos < StrLength;
    if Result then
    begin
      Ch := Ch - HalfBase;
      S[StrPos] := WideChar((Ch shr HalfShift) + SurrogateHighStart);
      S[StrPos + 1] := WideChar((Ch and HalfMask) + SurrogateLowStart);
      Inc(StrPos, 2);
    end;
  end
  else
  begin
    {$IFDEF UNICOLE_SILENT_FAILURE}
    // add ReplacementCharacter
    Result := StrPos <= StrLength;
    if Result then
    begin
      S[StrPos] := WideChar(ReplacementCharacter);
      Inc(StrPos, 1);
    end;
    {$ELSE ~UNICODE_SILENT_FAILURE}
    StrPos := -1;
    Result := False;
    {$ENDIF ~UNICODE_SILENT_FAILURE}
  end;

  end;


function TunitFrm.UTF16GetNextChar(const S: TUTF16String; var StrPos: SizeInt): UCS4;
var
  StrLength: SizeInt;
  ChNext: UCS4;
begin
  StrLength := Length(S);

  if (StrPos <= StrLength) and (StrPos > 0) then
  begin
    Result := UCS4(S[StrPos]);

    case Result of
      SurrogateHighStart..SurrogateHighEnd:
        begin
          // 2 bytes to read
          if StrPos >= StrLength then
          begin
            FlagInvalidSequence(StrPos, 1, Result);
            Exit;
          end;
          ChNext := UCS4(S[StrPos + 1]);
          if (ChNext < SurrogateLowStart) or (ChNext > SurrogateLowEnd) then
          begin
            FlagInvalidSequence(StrPos, 1, Result);
            Exit;
          end;
          Result := ((Result - SurrogateHighStart) shl HalfShift) +  (ChNext - SurrogateLowStart) + HalfBase;
          Inc(StrPos, 2);
        end;
      SurrogateLowStart..SurrogateLowEnd:
        FlagInvalidSequence(StrPos, 1, Result);
    else
      // 1 byte to read
      Inc(StrPos);
    end;
  end
  else
  begin
    // StrPos > StrLength
    Result := 0;
    FlagInvalidSequence(StrPos, 0, Result);
  end;

end;



function TunitFrm.WideStringToUTF16(const wstr: WideString): WideString;
var
  SrcIndex, SrcLength, DestIndex: Integer;
begin

  if wstr = NUL then
    Result := ''
  else
  begin
    SrcLength := Length(wstr);
    SetLength(Result, SrcLength * 2); // assume worst case
    DestIndex := 1;

    for SrcIndex := 1 to SrcLength do
    begin
      UTF16SetNextChar(Result, DestIndex, UCS4(wstr[SrcIndex]));
      if DestIndex = -1 then
       exit;

    end;

    SetLength(Result, DestIndex - 1); // set to actual length
  end;
end;

function TunitFrm.UTF16ToWideString(const wstr: WideString): WideString;
var
  SrcIndex, SrcLength, DestIndex: Integer;
  Ch: UCS4;
begin

  if wstr = NUL then
    Result := ''
  else
  begin
    SrcLength := Length(wstr);
    SetLength(Result, SrcLength); // create enough room

    SrcIndex := 1;
    DestIndex := 1;
    while SrcIndex <= SrcLength do
    begin
      Ch := UTF16GetNextChar(wstr, SrcIndex);
      if SrcIndex = -1 then
       exit;

      if Ch > MaximumUCS2 then
        FlagInvalidUCS2Char(Ch);

      Result[DestIndex] := UCS2(Ch);
      Inc(DestIndex);
    end;
    SetLength(Result, DestIndex - 1); // now fix up length
  end;
end;


function TunitFrm.UTF16ToUTF8(const wstr: WideString): String;

function UTF8SetNextChar(var S: TUTF8String; var StrPos: SizeInt; Ch: UCS4): Boolean;
var
  StrLength: SizeInt;
begin
  StrLength := Length(S);

  if Ch <= $7F then
  begin
    // 7 bits to store
    Result := (StrPos > 0) and (StrPos <= StrLength);
    if Result then
    begin
      S[StrPos] := AnsiChar(Ch);
      Inc(StrPos);
    end;
  end
  else
  if Ch <= $7FF then
  begin
    // 11 bits to store
    Result := (StrPos > 0) and (StrPos < StrLength);
    if Result then
    begin
      S[StrPos] := AnsiChar($C0 or (Ch shr 6));  // 5 bits
      S[StrPos + 1] := AnsiChar((Ch and $3F) or $80); // 6 bits
      Inc(StrPos, 2);
    end;
  end
  else
  if Ch <= $FFFF then
  begin
    // 16 bits to store
    Result := (StrPos > 0) and (StrPos < (StrLength - 1));
    if Result then
    begin
      S[StrPos] := AnsiChar($E0 or (Ch shr 12)); // 4 bits
      S[StrPos + 1] := AnsiChar(((Ch shr 6) and $3F) or $80); // 6 bits
      S[StrPos + 2] := AnsiChar((Ch and $3F) or $80); // 6 bits
      Inc(StrPos, 3);
    end;
  end
  else
  if Ch <= $1FFFFF then
  begin
    // 21 bits to store
    Result := (StrPos > 0) and (StrPos < (StrLength - 2));
    if Result then
    begin
      S[StrPos] := AnsiChar($F0 or (Ch shr 18)); // 3 bits
      S[StrPos + 1] := AnsiChar(((Ch shr 12) and $3F) or $80); // 6 bits
      S[StrPos + 2] := AnsiChar(((Ch shr 6) and $3F) or $80); // 6 bits
      S[StrPos + 3] := AnsiChar((Ch and $3F) or $80); // 6 bits
      Inc(StrPos, 4);
    end;
  end
  else
  if Ch <= $3FFFFFF then
  begin
    // 26 bits to store
    Result := (StrPos > 0) and (StrPos < (StrLength - 2));
    if Result then
    begin
      S[StrPos] := AnsiChar($F8 or (Ch shr 24)); // 2 bits
      S[StrPos + 1] := AnsiChar(((Ch shr 18) and $3F) or $80); // 6 bits
      S[StrPos + 2] := AnsiChar(((Ch shr 12) and $3F) or $80); // 6 bits
      S[StrPos + 3] := AnsiChar(((Ch shr 6) and $3F) or $80); // 6 bits
      S[StrPos + 4] := AnsiChar((Ch and $3F) or $80); // 6 bits
      Inc(StrPos, 5);
    end;
  end
  else
  if Ch <= MaximumUCS4 then
  begin
    // 31 bits to store
    Result := (StrPos > 0) and (StrPos < (StrLength - 3));
    if Result then
    begin
      S[StrPos] := AnsiChar($FC or (Ch shr 30)); // 1 bits
      S[StrPos + 1] := AnsiChar(((Ch shr 24) and $3F) or $80); // 6 bits
      S[StrPos + 2] := AnsiChar(((Ch shr 18) and $3F) or $80); // 6 bits
      S[StrPos + 3] := AnsiChar(((Ch shr 12) and $3F) or $80); // 6 bits
      S[StrPos + 4] := AnsiChar(((Ch shr 6) and $3F) or $80); // 6 bits
      S[StrPos + 5] := AnsiChar((Ch and $3F) or $80); // 6 bits
      Inc(StrPos, 6);
    end;
  end
  else
  begin
    {$IFDEF UNICODE_SILENT_FAILURE}
    // add ReplacementCharacter
    Result := (StrPos > 0) and (StrPos < (StrLength - 1));
    if Result then
    begin
      S[StrPos] := AnsiChar($E0 or (UCS4ReplacementCharacter shr 12)); // 4 bits
      S[StrPos + 1] := AnsiChar(((UCS4ReplacementCharacter shr 6) and $3F) or $80); // 6 bits
      S[StrPos + 2] := AnsiChar((UCS4ReplacementCharacter and $3F) or $80); // 6 bits
      Inc(StrPos, 3);
    end;
    {$ELSE ~UNICODE_SILENT_FAILURE}
    StrPos := -1;
    Result := False;
    {$ENDIF ~UNICODE_SILENT_FAILURE}
  end;
end;


var
  SrcIndex, SrcLength, DestIndex: SizeInt;
  Ch: UCS4;
begin

  if wstr = NUL then
    Result := NUL
  else
  begin
    SrcLength := Length(wstr);
    SetLength(Result, SrcLength * 3); // worste case

    SrcIndex := 1;
    DestIndex := 1;
    while SrcIndex <= SrcLength do
    begin
      Ch := UTF16GetNextChar(wstr, SrcIndex);
      if SrcIndex = -1 then
      begin
        Result :=wstr;
        exit;
      end;

      UTF8SetNextChar(Result, DestIndex, Ch);
    end;
    SetLength(Result, DestIndex - 1); // now fix up length
  end;

end;

function TunitFrm.decodeXMLreserved(wstr: WideString): Widestring;
var
 w_str: WideString;
begin

 w_str :=wstr;
 Result :=w_str;


 w_str :=uniTfrm.StrReplaceW(w_str,WideString(AMP_CODE),WideString(AMP_CHAR));
 w_str :=uniTfrm.StrReplaceW(w_str,WideString(LT_CODE),WideString(LT_CHAR));
 w_str :=uniTfrm.StrReplaceW(w_str,WideString(GT_CODE),WideString(GT_CHAR));

 Result :=w_str;
end;

function TunitFrm.StrReplaceW(wSource: WideString;
                             const wSearch, wReplace: WideString): WideString;
var
  nPos, nSrchLen, nReplLen : integer;
  wstr: WideString;
begin

   wstr :=wSource;
   Result :=wstr;


    // StrFindW is a wrapper around HyperStr.WScan
    //nPos := StrFindW(wSource, wSearch);
    //nPos :=WidePos(wSource,wSearch,1);
    nPos :=WidePos(wSearch,wSource,1);
    if nPos = 0 then
        exit;


    nSrchLen := Length(wSearch);
    nReplLen := Length(wReplace);


    while nPos > 0 do
    begin
        // note that Delete and Insert are WideString-compatible
        System.Delete(wstr, nPos, nSrchLen);
        // just in case empty replace string passed...
        if nReplLen > 0 then
        begin
            System.Insert(wReplace, wstr, nPos);
            inc(nPos, nReplLen);
        end;
        // next match
        //nPos := StrFindW(wstr, wSearch, nPos);
        nPos :=WidePos(wSearch,wstr,nPos);

    end;


   Result :=wstr;
 end;


function TunitFrm.StreamToString(aStream: TStream): string;
 var   SS: TStringStream;
begin

 if aStream <> nil then
 begin
  SS := TStringStream.Create(NUL);
 try
  aStream.Position := 0;
  SS.CopyFrom(aStream, aStream.Size);
  Result := SS.DataString;

 finally
  SS.Free;
 end;
 end
 else
 begin
  Result := NUL;
 end;

end;

function TunitFrm.readStream(flname: String): WideString;
var
 stre: TmemoryStream;
 wstr: WideString;
begin

 wstr :=NUL;
 Result :=wstr;

 if trim(flname)=NUL then
  exit;

 try
  stre :=TMemoryStream.create;

  stre.LoadFromFile(flname);

  //SetString(wstr, stre.Memory, stre.Size div SizeOf(Char));

  wstr :=streamToString(stre);


 finally
  stre.Free;

 end;

 Result :=wstr;
end;



function TunitFrm.saveWideStringToUTF8(flname:string; wstr:WideString): Integer;
var
 f:TFileStream;
begin
Result :=ERROR_;

 if trim(flname)=NUL then
  exit;

 f:=TFileStream.Create(flname,fmCreate);

 try
 f.Write(Utf8ByteOrderMark,3);
 f.Write(wstr[1],Length(wstr)*2);
finally
 f.Free;
 end;

 Result :=0;
end;



function TunitFrm.saveStream(flname: String; wstr: WideString): Integer;
var
 stre: TmemoryStream;

begin
 Result :=ERROR_;

 if trim(flname)=NUL then
  exit;

 try
  stre :=TMemoryStream.create;

  stre.Write(wstr[1],length(wstr)*2);
  stre.SaveToFile(flname);


 finally
  stre.Free;

 end;

 Result :=0;
end;

function TunitFrm.WideStrToUTF8(wstr: WideString): string;
var
 s: pchar;
 i: integer;
 str: string;
begin

str := NUL;
Result := str;

s := pchar(Utf8encode(wstr));

for i := 0 to strlen(s) do
begin
 str := str + format('%2.2x', [ord(s[i])]);
end;

Result := str;
end;



function TunitFrm.WideStringToString(const ws: WideString; codePage: Word): String;
var
  i: integer;
begin
  if ws = NUL then
    Result := NUL
  else
  begin

    i := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], - 1, nil, 0, nil, nil);

    SetLength(Result, i - 1);

    if i > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], - 1, @Result[1], i - 1, nil, nil);

  end;
end; { WideStringToString }


function TunitFrm.StringToWideString(const s: AnsiString; codePage: Word): WideString;
var
  l: integer;
begin
  if s = NUL then
    Result := NUL
  else
  begin
    l := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PChar(@s[1]), - 1, nil, 0);
    SetLength(Result, l - 1);
    if l > 1 then
      MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PChar(@s[1]),
        - 1, PWideChar(@Result[1]), l - 1);
  end;
end; { StringToWideString }


function TunitFrm.getCleanText(txt: STring): STring;
var
 str: STring;
 cx,dx,len: Integer;
begin
 str :=txt;
 Result :=str;

 len :=length(txt);

 dx :=1;
 for cx :=1 to len do
 begin
  if (txt[cx]=S_NUL) OR
     (txt[cx]=CR) OR
     (txt[cx]=LF) then
   //
  else
   str[dx] :=txt[cx];

  inc(dx);

 end;

 setlength(str,dx);


 Result :=str;
end;

function TunitFrm.isFileBrowse(flname: String): Boolean;
begin
 Result :=FALSE;

 if flname=NUL then
  exit;

  if pos('~',flname)>0 then
   Result :=TRUE


end;

function TunitFrm.getLastPos(skey,str: String): Integer;
var
 cstr: String;
 cx,sps,ps,lastPs,len,cnt: Integer;
begin
 ps :=0;
 Result :=ps;

 if (skey=NUL) OR (str=NUL) then
  exit;

 len :=length(str);

 ps :=pos(skey,str);
 sps :=0;
 lastps :=ps;

 //maks loop verdi
 cnt :=round(len/length(skey));
 cx :=0;

     //Finn siste komplette forekomst
     while (ps>0) AND (cx<=cnt) do
     begin
      sps :=sps+ps;
      lastps :=sps;
      sps :=sps+length(skey);

      cstr :=copy(str,sps,len);
      ps :=pos(skey,cstr);

      inc(cx);  //For sikkerhets skyld så loop ikke spinner

     end;

     ps :=lastps;


 Result :=ps;
end;


function TunitFrm.isFldBlank(str: String): Boolean;
begin

 if (trim(str)=NUL) OR (str=BLANK_FLD) then
  Result :=TRUE
 else
  Result :=FALSE;


end;


function TunitFrm.isFldEmpty(str: String): Boolean;
var
 cstr: String;
 cx,len: Integer;
 ch_hit: Boolean;
begin

 cstr :=trim(str);

 if isFldBlank(cstr) then
  Result :=TRUE
 else
 begin

  len :=length(cstr);

  ch_hit :=FALSE;
  cx :=1;
  while (cx<=len) do
  begin
   if (IsCharAlphaNumeric(cstr[cx])) OR
      (cstr[cx]='-') OR
      (cstr[cx]='_') then
   begin
    ch_hit :=TRUE;
    break;
   end;

   inc(cx);
  end;

   if ch_hit then
    Result :=FALSE  //det er bokstaver eller tall, og str er ikke "empty"
   else
    Result :=TRUE;


 end;

end;



function TunitFrm.isPBid(pbid: STring): Boolean;
var
 pb_id: String;
begin
 Result :=FALSE;


 pb_id :=trim(pbid);
 if length(pb_id)<MIN_PBID_LEN then
  exit;

  // \\OPRO\OMN\A\Q\63\56
  //Sjekk om det ligger \\ først
 if copy(pb_id,1,2)=PBID_PREFIX then
  Result :=TRUE;

end;

function TunitFrm.isFileName(flname: String): Boolean;
begin


 if (pos('.',flname)>0) OR
    (pos(':',flname)>0) OR
    (pos('\',flname)>0) OR
    (pos('/',flname)>0) then
     Result :=TRUE
    else
     Result :=FALSE;


end;



function TunitFrm.isQryFilled(fdata,fname: String): Boolean;
var
 str: String;
 len: Integer;
begin

 str :=trim(fdata);
 len :=length(str);

 if (trim(str)=NUL) OR
    (copy(str,1,1)='+') OR
    (isWildCardInStr(copy(str,1,1)) AND (len<2)) then
   Result :=FALSE
  else
   Result :=TRUE;

end;

function TunitFrm.strToUnicode(str: String): String;
var
 wstr,wstrx: WideString;
 ai,cx,ps,len: Integer;
 ch: Char;
 wch: WideChar;
 stru,strx: String;
begin

 wstr :=str;

 stru :=WideStringToUTF8String(str);

 len :=length(stru);

 //strx :=wstr;

// wstrx :=strToHex(str);

 ps :=1;
 strx :=stru;
 for cx :=1 to len do
 begin

  ch :=AnsiChar(stru[cx]);

  ai :=ord(ch);

  if ai=195 then
  begin
   strx[cx] :=ch;

   ai :=ord(HEX_AA_HI);

   ch :=HEX_AA_HI;

   ai :=ord(ch);

   strx[cx+1] :=ch; // intToHex(ai,2); //HEX_AA_HI;
   continue;
  end
  else
   strx[cx] :=AnsiChar(stru[cx]);


  inc(ps);

 end;


 Result :=strx;
end;

function TunitFrm.getFileSize(flname: string): Integer;
var
   fl: file of Byte;
   len: Longint;
begin

 len :=0;
 Result :=len;
 if trim(flname)=NUL then
  exit;

    AssignFile(fl, flName);
    Reset(fl);

    try
      len := FileSize(fl);
//      S := 'File size in bytes: ' + IntToStr(size);
    finally
      CloseFile(fl);
    end;

 Result :=len;
end;

function TunitFrm.ShellFindExecutable(const FileName, DefaultDir: string): string;
var
  Res: HINST;
  Buffer: array[0..MAX_PATH] of Char;
  P: PChar;
begin
  FillChar(Buffer, SizeOf(Buffer), #0);
  if DefaultDir = '' then P := nil
  else
    P := PChar(DefaultDir);
  Res := FindExecutable(PChar(FileName), P, Buffer);
  if Res > 32 then
  begin
    P := Buffer;
    while PWord(P)^ <> 0 do
    begin
      if P^ = #0 then // FindExecutable replaces #32 with #0
        P^ := #32;
      Inc(P);
    end;
    Result := Buffer;
  end
  else
    Result := '';
end;



function TunitFrm.move_File(flname,destDir: String; overwrt: Boolean): Boolean;
var
 srcPath,destPath: PChar;
 filename,fl_name,destFlname: String;
begin
 Result :=FALSE;

 if trim(flname)=NUL then
  exit;

 if trim(destDir)=NUL then
  exit;


 if not directoryExists(destDir) then
  exit;

 //if copy_file(flname,destDir) then
// begin
//  Result :=delete_File(flname);   //Må inneholde full path

  fl_name :=expandFileName(flname);
  srcPath :=PChar(fl_name);

  filename :=extractFileName(flname);

  destPath:=Pchar(addFileToPath(destDir,filename));

  if overwrt then
  begin
  
   if fileExists(destPath) then
    if not deleteFile(destpath) then
     exit;

  end;


  Result :=moveFile(srcPath,destPath);

  //filename :=extractFileName(flname);

                              //False=overwrite
//  add_to_loggmemo('Moved: '+flname+' to '+destPath)
// end;
// else
  //add_to_loggmemo('Error moving: '+flname+' to '+destPath);


end;


function TunitFrm.copy_File(flname,destDir: String): Boolean;
var
 destPath: PChar;
 filename: String;
begin
 Result :=FALSE;

 if trim(flname)=NUL then
  exit;

 if trim(destDir)=NUL then
  exit;

 if not directoryExists(destDir) then
  exit;

 filename :=extractFileName(flname);

 destPath:=Pchar(addFileToPath(destDir,filename));
                              //False=overwrite
	if copyfile(PChar(flname),destPath,false) then
  begin
    Result :=TRUE;
	  //add_to_loggmemo('Copied: '+flname+' to '+destPath);
  end;
//   else
//	  add_to_loggmemo('Error copying: '+flname+' to '+destPath);


end;

function TunitFrm.delete_File(flname: String): Boolean;
begin

  Result:=true;

  if not FileExists(flname) then
   exit;

  Result:=deletefile(flname);

end; // function TMainForm._Delete_File(totname:string):boolean;



function TunitFrm.isStrClean(str: String; allowChar1,allowChar2: Char): Boolean;
var
 i,j,len: Integer;
 rtb: Boolean;
begin

rtb :=FALSE;

len :=length(trim(str));

j :=0;
for i :=1 to len do
begin

 if (str[i] = BLANK) OR
    (not IsCharAlphaNumeric(str[i])) then
 begin
   if (str[i]=allowChar1) OR (str[i]=allowChar2) then
    rtb :=TRUE
   else
    rtb :=FALSE;

   break;
 end
 else
  rtb :=TRUE

end;

 Result :=rtb;
end;




function TunitFrm.execWinProgr(path,name: String): Integer;
var
 ar: array [0..64] of char;
 progName: String;
 hnd: Thandle;
begin
 Result :=ERROR_;

    //Denne kan brukes til f.eks å starte Netscape
//  ShellExecute(Application.Handle,'open','http://www.ven.be/freestyle/delphi.htm', nil, nil, SW_NORMAL);

 strPcopy(ar,name);
 progName :=path; //<path to your .EXE> //i.e 'C:\APPLIC\app.exe'

 hnd :=findWindow(nil,ar);

 if hnd = 0 then     //if not already executed and open
 begin
  if winExec(PChar(progName),SW_SHOW) <=31 then
  begin
   unitFrm.msgDlg(format('Kan ikke starte %s',
    [progName]),ERROR_);
   exit;
  end;

  hnd :=findWindow(nil,ar);
  SetWindowPos(hnd,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
 end
 else
  setForegroundWindow(hnd);
  //setActiveWindow(hnd); //WinProcs.setFocus(hnd);


 Result :=0;
end;

function TunitFrm.getAspectCode(flname,suffix: String): String;
var
 str,fl_name,fl_ext,acode: String;
 ps,cx,len,suflen,extlen,psext: Integer;
begin

 acode :=NUL;
 Result :=acode;


 if trim(flname)=NUL then
  exit;

 len :=0;
 extlen :=0;

 fl_name :=extractFileName(flname);
 fl_ext :=extractFileExt(flname);

 len :=length(fl_name);
 suflen :=length(suffix);
 extlen :=length(fl_ext);

 ps :=0;
 psext :=0;
 for cx :=len downto 1 do
 begin

  if fl_name[cx]=DOT then
   psext :=cx
  else
  if fl_name[cx]=FILE_NAME_SEP then
  begin
   ps :=cx;
   break;
  end;

 end;

 if (ps>0) AND (psext>0) then
 begin
  acode :=copy(fl_name,(ps+1),((psext-ps)-1));

 end;

 if length(acode)>ASPECT_CODE_LEN then
  acode :=NUL;

 if (acode=NUL) AND (suffix<>NUL) then
 begin

  //SKOLE-NA12345W-UV.mov

   str :=copy(fl_name,(len-(suflen+extlen))+1,suflen); //UV.mov

  if str=suffix then
  begin
   acode :=copy(fl_name,(len-(suflen+extlen))-1,1);  //W

  end;
 end;


   //FMT_NORMAL_CODE ='N';
   //FMT_WIDE_CODE ='W';
 
 //Sjekk gyldige verdier
  if (acode=FMT_NORMAL_CODE) OR (acode=FMT_WIDE_CODE) OR
     (acode=FMT_NORMAL) OR (acode=FMT_WIDE) then
    //
   else
    acode :=NUL;


 Result :=trim(acode);
end;

function TunitFrm.getTopicCode(flname,prefix: String): String;
var
 fl_name,tcode: String;
 ps,len: Integer;
begin

 tcode :=NUL;
 Result :=tcode;

 if trim(flname)=NUL then
  exit;

 len :=0;

 fl_name :=extractFileName(flname);
 //fl_ext :=extractFileExt(flname);

 ps :=pos(FILE_NAME_SEP,fl_name);

 if ps>0 then
 begin

  tcode :=copy(fl_name,1,(ps-1));

  if length(tcode)>TOPIC_CODE_LEN then
   tcode :=NUL;

 end
 else
 begin

  if prefix<>NUL then
  begin
   if copy(fl_name,1,length(prefix)+1)=prefix+'-' then
   begin

    tcode :=copy(fl_name,length(prefix)+2,2);

    if length(tcode)>TOPIC_CODE_LEN then
    tcode :=NUL;

    end

  end;
 end;

 Result :=trim(tcode);
end;


function TunitFrm.getMediaExt(filename: String): String;
var
 exts: String;
begin
 exts :=NUL;
 Result :=exts;


 if trim(filename)=NUL then
  exit;

 exts :=extractFileExt(filename);

 if exts<>NUL then
  exts :=copy(exts,2,length(exts)-1);

 Result :=uppercase(exts);

end;

function TunitFrm.getCleanFilename(filename: String): String;
var
 cname,flname,ext: String;
 len,extlen,ps_end: Integer;
begin
 flname :=NUL;
 Result :=flname;

 if trim(filename)=NUL then
  exit;

  flname :=extractFileName(filename);

  len :=length(flname);
  ext :=extractFileExt(flname);
  extlen :=length(ext);

  ps_end :=(len-extlen);

  cname :=copy(flname,1,ps_end);

 Result :=cname;
end;

function TunitFrm.isMediaImage(filename: String): Boolean;
var
 exts: String;
 ps: Integer;
begin

Result :=FALSE;

 if trim(filename)=NUL then
  exit;
{
 exts :=extractFileExt(filename);

 if exts<>NUL then
  exts :=copy(exts,2,length(exts)-1);
}

 exts :=getMediaExt(filename);

 if AnsiCompareText(exts,JPG_IMG)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,TIF_IMG)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,WMF_IMG)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,GIF_IMG)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,BMP_IMG)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,PNG_IMG)=0 then
  Result :=TRUE;


end;

function TunitFrm.isMediaVideo(filename: String): Boolean;
var
 exts: String;
 ps: Integer;
begin

Result :=FALSE;

 if trim(filename)=NUL then
  exit;
{
 exts :=extractFileExt(filename);

 if exts<>NUL then
  exts :=copy(exts,2,length(exts)-1);
}

 exts :=getMediaExt(filename);

 if AnsiCompareText(exts,AVI_VIDEO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,MPG_VIDEO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,MPEG_VIDEO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,MOV_VIDEO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,WMV_VIDEO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,WMF_VIDEO)=0 then
  Result :=TRUE;


end;

function TunitFrm.isMediaAudio(filename: String): Boolean;
var
 exts: String;
begin

Result :=FALSE;

 if trim(filename)=NUL then
  exit;
{
 exts :=extractFileExt(filename);
 if exts<>NUL then
  exts :=copy(exts,2,length(exts)-1);
}

 exts :=getMediaExt(filename);

 if AnsiCompareText(exts,WAV_AUDIO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,WMA_AUDIO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,AIFF_AUDIO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,AU_AUDIO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,MIDI_AUDIO)=0 then
  Result :=TRUE
 else
 if AnsiCompareText(exts,MP3_AUDIO)=0 then
  Result :=TRUE;


end;


function TunitFrm.isMediaPDF(filename: String): Boolean;
var
 exts: String;
begin

Result :=FALSE;

 if trim(filename)=NUL then
  exit;
{
 exts :=extractFileExt(filename);
 if exts<>NUL then
  exts :=copy(exts,2,length(exts)-1);
}

 exts :=getMediaExt(filename);

 if AnsiCompareText(exts,PDF_)=0 then
  Result :=TRUE;


end;

function TunitFrm.isMediaFlash(filename: String): Boolean;
var
 exts: String;
 ps: Integer;
begin

Result :=FALSE;

 if trim(filename)=NUL then
  exit;
{
 exts :=extractFileExt(filename);

 if exts<>NUL then
  exts :=copy(exts,2,length(exts)-1);
}

 exts :=getMediaExt(filename);

 if AnsiCompareText(exts,FLASH_SWF)=0 then
  Result :=TRUE

end;

function TunitFrm.getMediaClipName(filename: String): String;
var
 str,fn,exts,acode,tcode: String;
 ps: Integer;
begin

 str :=NUL;
 Result :=str;

 if trim(filename)=NUL then
  exit;

 if unitFrm.isMediaFlash(filename) then
  exit;

 fn :=extractFilename(filename);
 exts :=extractFileExt(filename);

 //Fjern extension
 ps :=pos(exts,fn);
 if ps>0 then
  str :=copy(fn,1,(ps-1))
 else
  str :=fn;

 //Fjern separatorer
  str :=trim(strReplace(Pchar(str),FILE_NAME_SEP,BLANK));

  tcode :=getTopicCode(filename,SKOLE);
  acode :=getAspectCode(filename,PB_SKOLE_ID);

  if tcode<>NUL then
   str :=trim(strReplace(Pchar(str),Pchar(tcode),NUL));

  if acode<>NUL then
   str :=trim(strReplace(Pchar(str),Pchar(acode),NUL));


  //Fjern bit/s fra streamfiler
  str :=trim(strReplace(Pchar(str),STREAM_Q1,BLANK));
  str :=trim(strReplace(Pchar(str),STREAM_QA,BLANK));



  Result :=str;
end;

function TunitFrm.getMediaClipLen(filename: String;
                                 var sec_len: Integer): String;
var
 str: String;
 ms: IMediaSeeking;
 totalSamples: Int64;
 sec: Real;
begin

str :=NUL;
Result :=str;
sec_len :=0;

if trim(filename)=NUL then
 exit;

 if unitFrm.isMediaFlash(filename) then
  exit;

 {
file:O:\Ressurser\TTEK\TTRU\Kildekode\Pakker\DSPACK234.zip

Installer denne pakken først. Det hjelper også å ha DX SDK installert pga. hjelpefilene, eller online her: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/directshow/htm/imediaseekinginterface.asp

For å finne lengde på filer:

Legg til en FilterGraph (FG) komponent på formen.
Du må også sannsynligvis inkludere denne unit'en:  DirectShow9
}

//Eksempel på å åpne en fil.

   if not FileExists(FileName) then
      Exit;

try

  with FG do
  begin

   try
   if not Active then
    Active := true;
   except
    msgDlg(format('Kan ikke åpne %s',[filename]),ERROR_);
    exit;
   end;

    ClearGraph;
    RenderFile(FileName);
  end;

except
 exit;
end; 

{
Deretter må du sette ønsket tidsformat,
dvs, frames, time, samples etc du ønsker å ta ut lengde i. Default er tid i nanosekunder.
Dette gjøres med SetTimeFormat: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/directshow/htm/imediaseekingsettimeformat.asp
Les ut lengde:
}

{
Declaration: Uuids.h.

GUID Description
TIME_FORMAT_NONE No format.
TIME_FORMAT_FRAME Video frames.
TIME_FORMAT_SAMPLE Samples in the stream.
TIME_FORMAT_FIELD Interlaced video fields.
TIME_FORMAT_BYTE Byte offset within the stream.
TIME_FORMAT_MEDIA_TIME Reference time (100-nanosecond units).
}

   totalSamples := 0;
   sec :=0;

  with FG do
  begin

  // ms.SetTimeFormat(TIME_FORMAT_FRAME);
    //ms.
   try
      if QueryInterface( IID_IMediaSeeking, ms) = S_OK then
      begin
        ms.GetDuration(totalSamples);

        sec :=totalSamples/10000000;

        sec_len :=trunc(sec);
      end;
   finally
      ms := nil;
      active :=FALSE;
   end;

 end;

 if sec<>0 then
  str :=framesToTimeStr(trunc(sec*VIDEO_FRAME_RATE));

 Result :=str;
end;

function TunitFrm.framesToTimeStr(frames: Integer): String;
var
 str: String;
 sumsec: real;
 min,sec: Integer;
begin
 str :=NUL;
 Result :=str;
 if frames=0 then
  exit;

 sumsec :=frames/VIDEO_FRAME_RATE;

 min :=trunc(sumsec/60);

  sec :=trunc(sumsec-(min*60));

 str :=format('%3d:%2.2d',[min,sec]);


 Result :=str;
end;

procedure TunitFrm.writeCanvas(str: String; sender: Tobject; rect: Trect;
     fldColor,fontColor: Tcolor);
begin


//if typFrm.triggInhibit(CHECK_) =ONX then
//  beep;
//begin


if sender is TDBgrid then
 with (sender as TDBgrid).canvas do
 begin

   if fldColor <> clNone then
     Brush.Color :=fldColor;

   if fontColor <> clNone then
    Font.color :=fontColor;

    //setTextAlign(handle,TA_RIGHT);

    FillRect(Rect);
    TextRect(Rect,Rect.Left+2,Rect.Top+2, str);
 end
 else
 if sender is TstringGrid then
 with (sender as TstringGrid).canvas do
 begin

   if fldColor <> clNone then
     Brush.Color :=fldColor;

   if fontColor <> clNone then
    Font.color :=fontColor;

    FillRect(Rect);
    TextRect(Rect,Rect.Left+2,Rect.Top+2, str);
 end
 else
 if sender is TjvDBultimGrid then
 with (sender as TjvDBultimGrid).canvas do
 begin

   if fldColor <> clNone then
     Brush.Color :=fldColor;

   if fontColor <> clNone then
    Font.color :=fontColor;

    //setTextAlign(handle,TA_RIGHT);

    FillRect(Rect);
    TextRect(Rect,Rect.Left+2,Rect.Top+2, str);
 end
 else
 if sender is TwwDBGrid then
 with (sender as TwwDBGrid).canvas do
 begin

   if fldColor <> clNone then
     Brush.Color :=fldColor;

   if fontColor <> clNone then
    Font.color :=fontColor;

    FillRect(Rect);
    TextRect(Rect,Rect.Left+4,Rect.Top+2, str);
 end;


end;


function TunitFrm.addFileToPath(path,fileName: String): String;
var
 len: Integer;
 pth: String;
begin

 Result :=fileName;
 pth :=NUL;
 len :=length(path);
 if len<=0 then
   exit;

 //Hvis allerede \ tilsutt
 if path[len] =LSLASH then
  pth :=path
 else
 begin
  pth :=path+LSLASH;
 end;

 pth :=pth+fileName;

 Result :=pth;
end;


function TunitFrm.minToFldStrTime(min: Integer; leadZeros: Integer): String;
begin

if min>DAY_MIN_LEN then
 Result :=unitFrm.minToStrTime((min-DAY_MIN_LEN),leadZeros)
else
 Result :=unitFrm.minToStrTime(min,leadZeros);

end;

function TunitFrm.setOraWildcards(str: String): String;
var
 outstr: String;
 len,i: Integer;
begin
 outstr :=str;
 Result :=outstr;

 if trim(str)<>NUL then
 begin

  //outstr :=stripChars(trim(str),QUEST);
  //outstr :=stripChars(outstr,STAR);
  len :=length(str);

  for i :=1 to len do
  begin

  case str[i] of
   QUEST: outstr[i] :='_';
   STAR: outstr[i] :='%';
   else
   begin
    outstr[i] := str[i];
   end;

  end;

 end;

 end;

 Result :=outstr;
end;



function TunitFrm.stripWildCards(str: String): String;
var
 outstr: String;
begin
 outstr :=NUL;
 Result :=outstr;

 if trim(str)<>NUL then
 begin
  outstr :=stripChars(trim(str),QUEST);
  outstr :=stripChars(outstr,STAR);
 end;

 Result :=outstr;
end;

function TunitFrm.dtmTimeToStr(dtm: TdateTime): String;
var
 dats,timekey,str: String;
 min,ps,psPm: Integer;
begin
 min :=0;

 try
  //På win2000 vil f.eks. 20.11.00 (uten tid) gi 12:00:00 på tid
  dats :=dateTimeToStr(dtm);
  ps := pos(BLANK,dats);
  if ps=0 then
   timeKey :=TIME_00
  else
  begin
   str :=timeToStr(dtm);

   timeKey :=removeAmPm(str);

   psPm :=pos(PM_,str);

   if psPm>0 then
   begin
    //Legg til 12 timer
    min :=strTimeToMin(timekey)+720;
    if min>DAY_MIN_LEN then
     min :=min-DAY_MIN_LEN;

    timeKey :=format('%s:00',[minToStrTime(min,2)]);
   end;
{
    unitFrm.msgDlg(format('%s %s %d'+FNUL+
                          'AM:%d PM:%d',
                          [str,timekey,min,psAm,psPm]),INFO_)
 }
  end;

 except
  timeKey :=TIME_00;
 end;
{
 unitFrm.msgDlg(format('%s '+FNUL+
                       '%s  %s',[dateTimeToStr(dtm),str,timekey]),INFO_);
}

 Result :=timeKey;
end;


function TunitFrm.removeAmPm(tstr: String): String;
var
 str: String;
begin
 str :=tstr;

 if pos(AM_,tstr)>0 then
  str :=trim(strReplace(Pchar(str),AM_,NUL));

 if pos(PM_,tstr)>0 then
  str :=trim(strReplace(Pchar(str),PM_,NUL));

 Result :=str;
end;

function TunitFrm.getLum(colr: Tcolor): Integer;
 function hexStrToInt(hexstr: String): Integer;
 var
  ival: Integer;
 begin

  try

  if hexstr=NUL then
   ival :=0
  else
   ival :=strToInt(HEX_PREFIX+hexstr);
  except
   ival :=0;
  end;

  Result :=ival;
 end;
var
 lum,rval,gval,bval: Real;
 colrStr: String;
begin


 colrStr :=colorToString(colr);

  //Sjekk om 'colrStr' er identfarge som f.eks. clWhite o.l.
 if copy(colrStr,1,2)='cl' then
 begin

  //-1 for at det ikke skal bli identfarge
  if colr>=1 then
   colrStr :=colorToString(colr-1)
  else
   colrStr :=colorToString(0);  //svart

 end;

 rval :=hexStrToInt(copy(colrStr,8,2));  //rød
 gval :=hexStrToInt(copy(colrStr,6,2));  //grønn
 bval :=hexStrToInt(copy(colrStr,4,2));  //blå

 //kompenser for luminansligning
 lum :=((bval*0.11)+(gval*0.59)+(rval*0.3));

 //lum blir 254,7 for hvitt (ikke 255 pgr. -1)
 Result :=round(lum);
end;

function TunitFrm.makeStrValid(str: String): String;
var
 nulval: String;
begin

 nulval :=NUL;

 Result :=str; //Anta dette først

 if length(trim(str))>0 then
 begin

   //Sjekk at det ikke vises merkelige tegn
   if (str[1]=CR) OR
      (str[1]=LF) OR
      (str[1]=ENTER)OR
      (str[1]=TAB) then
     Result:=nulval;  //NUL

 end;

end;

function TunitFrm.isCharNorChar(ch: Char): Boolean;
begin

  if ((ch='æ') OR (ch='Æ')) OR
     ((ch='ø') OR (ch='Ø')) OR
     ((ch='å') OR (ch='Å')) then
     Result :=TRUE
    else
     Result :=FALSE;


end;


function TunitFrm.isNorCharInString(str: String): Boolean;
var
 cx,len: Integer;
begin

 len :=length(str);

 for cx:=1 to len do
 begin

  if isCharNorChar(str[cx]) then
  begin
   Result :=TRUE;
   exit;
  end;

 end;

 Result :=FALSE;
end;


function TunitFrm.replaceNorCharsXML(str: String): String;
var
 s1,s2,s3,s4,s5,s6: String;
 xstr: AnsiString;
begin
// s1 :=NUL;
// Result :=s1;

 Result :=str;
 exit;  //02.03.11 utkoblet pga. UTF-16

 xstr :=str;

// AMP_CODE ='&amp;';
// AMP_CHAR ='&';
 xstr :=trim(strReplace(Pchar(str),AMP_CODE,AMP_CHAR));

 xstr :=trim(strReplace(Pchar(str),AE_LO,'æ'));

 xstr :=trim(strReplace(Pchar(xstr),AE_HI,'Æ'));

 xstr :=trim(strReplace(Pchar(xstr),OE_LO,'ø'));
 xstr :=trim(strReplace(Pchar(xstr),OE_HI,'Ø'));

 xstr :=trim(strReplace(Pchar(xstr),AA_LO,'å'));
 xstr :=trim(strReplace(Pchar(xstr),AA_HI,'Å'));


 xstr :=trim(strReplace(Pchar(xstr),A_LO,'ä'));
 xstr :=trim(strReplace(Pchar(xstr),A_HI,'Ä'));

 xstr :=trim(strReplace(Pchar(xstr),AS_LO,'á'));
 xstr :=trim(strReplace(Pchar(xstr),AS_HI,'Á'));

 xstr :=trim(strReplace(Pchar(xstr),E_LO,'é'));
 xstr :=trim(strReplace(Pchar(xstr),E_HI,'É'));
 
 xstr :=trim(strReplace(Pchar(xstr),O_LO,'ö'));
 xstr :=trim(strReplace(Pchar(xstr),O_HI,'Ö'));

 xstr :=trim(strReplace(Pchar(xstr),U_LO,'ü'));
 xstr :=trim(strReplace(Pchar(xstr),U_HI,'Ü'));



 Result :=xstr;

end;


function TunitFrm.replaceXMLnorChars(str: String): String;
var
 s1,s2,s3,s4,s5,s6: String;
 xstr: AnsiString;
begin
// s1 :=NUL;
// Result :=s1;

 Result :=str;
 exit;  //02.03.11 utkoblet pga. UTF-16

 xstr :=str;

{
 xstr :=strChange(xstr,'æ',AE_LO);
 xstr :=strChange(xstr,'Æ',AE_HI);

  xstr :=strChange(xstr,'ø',OE_LO);
  xstr :=strChange(xstr,'Ø',OE_HI);

  xstr :=strChange(xstr,'å',AA_LO);
  xstr :=strChange(xstr,'Å',AA_HI);
}

 {
 s1 :=xprocs.strReplace(xstr,'æ',AE_LO);
 s2 :=xprocs.strReplace(s1,'Æ',AE_HI);

 s3 :=xprocs.strReplace(s2,'ø',OE_LO);
 s4 :=xprocs.strReplace(s3,'Ø',OE_HI);

 s5 :=xprocs.strReplace(s4,'å',AA_LO);
 s6 :=xprocs.strReplace(s5,'Å',AA_HI);
}
{
 s1 :=cStrings.strReplace('æ',AE_LO,str);
 s2 :=cStrings.strReplace('Æ',AE_HI,s1);

 s3 :=cStrings.strReplace('ø',OE_LO,s2);
 s4 :=cStrings.strReplace('Ø',OE_HI,s3);

 s5 :=cStrings.strReplace('å',AA_LO,s4);
 s6 :=cStrings.strReplace('Å',AA_HI,s5);
}

 xstr :=trim(strReplace(Pchar(str),'æ',AE_LO));
 xstr :=trim(strReplace(Pchar(xstr),'Æ',AE_HI));

 xstr :=trim(strReplace(Pchar(xstr),'ø',OE_LO));
 xstr :=trim(strReplace(Pchar(xstr),'Ø',OE_HI));

 xstr :=trim(strReplace(Pchar(xstr),'å',AA_LO));
 xstr :=trim(strReplace(Pchar(xstr),'Å',AA_HI));

 xstr :=trim(strReplace(Pchar(xstr),'ä',A_LO));
 xstr :=trim(strReplace(Pchar(xstr),'Ä',A_HI));

 xstr :=trim(strReplace(Pchar(xstr),'á',AS_LO));
 xstr :=trim(strReplace(Pchar(xstr),'Á',AS_HI));

 xstr :=trim(strReplace(Pchar(xstr),'é',E_LO));
 xstr :=trim(strReplace(Pchar(xstr),'É',E_HI));

 xstr :=trim(strReplace(Pchar(xstr),'ö',O_LO));
 xstr :=trim(strReplace(Pchar(xstr),'Ö',O_HI));

 xstr :=trim(strReplace(Pchar(xstr),'ü',U_LO));
 xstr :=trim(strReplace(Pchar(xstr),'Ü',U_HI));



 Result :=xstr;
end;


function TunitFrm.decodeXMLnorChars(str: String): String;
var
 s1,s2,s3,s4,s5,s6: String;
 xstr: AnsiString;
begin
// s1 :=NUL;
// Result :=s1;

 xstr :=str;
 {
 s1 :=xprocs.strReplace(xstr,'æ',AE_LO);
 s2 :=xprocs.strReplace(s1,'Æ',AE_HI);

 s3 :=xprocs.strReplace(s2,'ø',OE_LO);
 s4 :=xprocs.strReplace(s3,'Ø',OE_HI);

 s5 :=xprocs.strReplace(s4,'å',AA_LO);
 s6 :=xprocs.strReplace(s5,'Å',AA_HI);
}
{
 s1 :=cStrings.strReplace('æ',AE_LO,str);
 s2 :=cStrings.strReplace('Æ',AE_HI,s1);

 s3 :=cStrings.strReplace('ø',OE_LO,s2);
 s4 :=cStrings.strReplace('Ø',OE_HI,s3);

 s5 :=cStrings.strReplace('å',AA_LO,s4);
 s6 :=cStrings.strReplace('Å',AA_HI,s5);
}

 xstr :=trim(strReplace(Pchar(str),AE_LO,'æ'));
 xstr :=trim(strReplace(Pchar(xstr),AE_HI,'Æ'));

 xstr :=trim(strReplace(Pchar(xstr),OE_LO,'ø'));
 xstr :=trim(strReplace(Pchar(xstr),OE_HI,'Ø'));

 xstr :=trim(strReplace(Pchar(xstr),AA_LO,'å'));
 xstr :=trim(strReplace(Pchar(xstr),AA_HI,'Å'));


 Result :=xstr;
end;



function TunitFrm.replaceNorCharInString(str: String; replch: Char): String;
var
 outstr: String;
 cx,len: Integer;
begin

 outstr :=str;
 Result :=outstr;

 len :=length(str);

 for cx:=1 to len do
 begin

  if isCharNorChar(str[cx]) then
  begin
   outstr[cx] :=replch;

  end;

 end;


 Result :=outstr;
end;


function TunitFrm.isKeyNullTime(str: STring): Boolean;
var
 i,nullCh,len: Word;
begin
 Result :=FALSE;

 if (str=BLANKTIME) OR (str=NULLTIME) then
 begin
  Result :=TRUE;
  exit;
 end;

 len :=length(str);

 nullCh :=0;
 for i:=1 to len do
 begin

  if (str[i]=NULLDIGIT) OR
     (str[i]=BLANK) OR
     (str[i]=DOT) OR
     (str[i]=COLON) then
   inc(nullCh)
  else
   break;

 end;

 if nullCh=len then
  Result :=TRUE;


end;


function TunitFrm.isKeyTimeValue(str: STring): Boolean;
begin
 Result :=FALSE;

 if trim(str)=NUL then
  exit;

 if (str<>UNDFTIME) AND
    (length(trim(str))<=TIME_FLD_LEN) AND
    ((pos(DOT,str)>0) OR (pos(COLON,str)>0)) then
     Result :=TRUE;

end;

function Tunitfrm.replaceNorChar(str: String): String;
var
 outstr: String;
 i,len: Integer;
begin

 outstr :=str;
 Result :=str;
 len :=length(str);

 for i :=1 to len do
 begin

  case str[i] of
   'æ': outstr[i] :='e';
   'Æ': outstr[i] :='E';
   'ø': outstr[i] :='o';
   'Ø': outstr[i] :='O';
   'å': outstr[i] :='a';
   'Å': outstr[i] :='A';
   else
   begin
    outstr[i] := str[i];
   end;

  end;

 end;

 Result :=outstr;
end;


function TunitFrm.minToDaysStr(min,dayLen: Integer): String;
var
 days,dif: Integer;
 txt: String;
begin
 txt :=NUL;
 Result :=txt;

 if daylen=0 then
  exit;

  try
   dif :=min mod daylen;

   days :=trunc((min-dif)/daylen);

  txt :=format('%d d %s',[days,unitFrm.minToStrTime(dif,1)]);

  except
   //
  end;


 Result :=txt;
end;


 {
function TunitFrm.fillNullTime(fld: TovcPictureField): Integer;
begin

 if length(trim(fld.text))<TIME_FLD_LEN then
  fld.text :=NULLTIME;

 Result :=0;
end;
 }

function TunitFrm.floatToSQLnumber(fval: Real): String;
var
 str: String;
begin

 str :=charReplace(format('%.2f',[fval]),COMMA,DOT);

 Result :=str;
end;

function TunitFrm.difDateTimeMins(fromDtm,toDtm: TdateTime): Integer;
var
 hr,mins,sec,msec: Word;
 difMin,totmins,fromMin,toMin,days: Integer;
 timeStr: String;
begin

 decodeTime(fromDtm,hr,mins,sec,msec);
 if (hr=23) AND (mins=59) AND (sec=59) then
  timeStr :=TIME_24
 else
  timeStr :=dtmtimeToStr(fromDtm);

 fromMin :=strTimeToMin(timeStr);

 decodeTime(toDtm,hr,mins,sec,msec);
 if ((hr=23) AND (mins=59) AND (sec=59)) OR
    ((hr=0) AND (mins=0) AND (sec=0)) then
  timeStr :=TIME_24
 else
  timeStr :=dtmtimeToStr(toDtm);

 toMin :=strTimeToMin(timeStr);

 difMin :=(toMin-fromMin);

 //OBS: Dette er basert på at dato er satt fra 0 - 1440 ved full tid
 //og at begge har 4 siffret årstall
 days :=trunc(toDtm-fromDtm);

 //Totalt antall minutter sett i forhold til hele datoer
 totmins :=(days*DAY_MIN_LEN)+difMin;

 Result :=totmins;
end;


 function TunitFrm.stepScaleMins(var mins: Integer; cmd: Integer): String;
 var
  txt: STring;
  minScale: Integer;
 begin

  minScale :=mins;
  txt :=NUL;
  Result :=txt;

  if mins<0 then
   mins :=0;

  if (cmd=REW_) OR (cmd=FWD_) then
  begin

  case mins of
   0:
   begin
    if cmd=REW_ then
     minScale :=DAY_MIN_LEN
    else
     minScale :=10;  //10 minutt

   end;

   10:
   begin
    if cmd=REW_ then
     minScale :=10    //Nederste grense
    else
     minScale :=15;  //Kvarter

   end;

   15:
   begin
    if cmd=REW_ then
     minScale :=10
    else
     minScale :=30;  //Halvtimer
   end;

   30:
   begin
    if cmd=REW_ then
     minScale :=15
    else
     minScale :=60;  //Hele timer
   end;

   60:
   begin
    if cmd=REW_ then
     minScale :=30
    else
     minScale :=120;  //2 timer
   end;

   120:
   begin
    if cmd=REW_ then
     minScale :=60
    else
     minScale :=180;  //3 timer
   end;

   180:
   begin
    if cmd=REW_ then
     minScale :=120
    else
     minScale :=240;  //4 timer
   end;

   240:
   begin
    if cmd=REW_ then
     minScale :=180
    else
     minScale :=360;  //6 timer
   end;
   360:
   begin
    if cmd=REW_ then
     minScale :=240
    else
     minScale :=480;  //8 timer
   end;
   480:
   begin
    if cmd=REW_ then
     minScale :=360
    else
     minScale :=720;  //12 timer
   end;
   720:
   begin
    if cmd=REW_ then
     minScale :=480
    else
     minScale :=DAY_MIN_LEN;  //24 time
   end;
   DAY_MIN_LEN:
   begin
    if cmd=REW_ then
     minScale :=720
    else
     minScale :=DAY_MIN_LEN;  //Maks
   end;

  end;  //case

  mins :=minScale;

 end //if (cmd...
 else
  minscale :=mins;

  case minScale of
   0:
    txt :='Hele dager';

   10:
    txt :='10 min';

   15:
    txt :='15 min';

   30:
    txt :='Halv time';

   60:
    txt :='1 time';

   120:
    txt :='2 timer';

   180:
    txt :='3 timer';

   240:
    txt :='4 timer';

   360:
    txt :='6 timer';

   480:
    txt :='8 timer';

   720:
    txt :='12 timer';

   DAY_MIN_LEN:
    txt :='Hele dager';

  end;  //case


  Result :=txt;
 end;


function TunitFrm.formatTime(min: Integer): String;
var
 str,klStr,timeStr: String;
begin


 klStr :=minToStrTime(min,2);

 if klStr<>NUL then
  timeStr :=format('%s%s00',[klStr,COLON]);

 //24:00 tillates ikke
 //Gjør om til 23:59:59
 if copy(klStr,1,2)=copy(TIME_24,1,2) then
  timeStr :=TIME_235959;

 str :=charReplace(timeStr,DOT,COLON);

 Result :=str;
end;

function TunitFrm.timeToCount(str: String; prec: Integer): String;
var
 vlen: Integer;
 cntstr: String;
begin
 cntstr :=NUL;
 Result :=cntstr;

 if pos(DOT,str)>0 then  //Tid ?
 begin
  vlen :=strTimeToMin(str);
  cntstr :=trim(minToDeciStr(vlen,COMMA));
 end
 else
  cntstr :=strFloat(str,prec);


 Result :=cntstr;
end;

function TunitFrm.cleanupProdNr(str: String): String;
const
 offset =6;
var
 ps,len: Integer;
 tmpStr,clnStr: String;
begin

 clnStr :=str;

 len :=length(str);

 //Sjekk om det ligger noe etter prodnr
 tmpStr :=copy(str,offset,(len-offset));

 ps :=pos(BLANK,tmpstr);

   //det ligger blank mellom ProdNr og ProdNavn
   //ps :=pos(BLANK,str);

  if (ps>0) AND (ps<=(PRODNR_LEN+1)) then
  begin
   tmpStr :=copy(str,1,(ps+offset)-1);
  end
  else
   tmpstr :=str;

  clnStr :=formatProdNr(tmpStr,0);  //Fjern alt som ikke er tall eller bokstaver

 Result :=clnstr;
end;


function TunitFrm.safeSQL(str: String): String;
var
 i,j,len,rt: Integer;
 clnStr: String;
begin

len :=length(str);

//Pga. buffer
clnstr :=str+str;
for i :=1 to (len+len) do
 clnstr[i] :=BLANK;

//Strip vekk ugyldige tegn

try

j :=0;
for i :=1 to len do
begin

 if (str[i]='''') then
 begin

  //Enkeltfnutt må registreres som to
  inc(j);
  clnstr[j] :='''';
  inc(j);
  clnstr[j] :='''';

 end
 else
 if (str[i]='"') then
 begin

  //dobbelfnutt må registreres som fire enkeltfnutt
{
  inc(j);
  clnstr[j] :='"';
  inc(j);
  clnstr[j] :='"';

  inc(j);
  clnstr[j] :='"';
  inc(j);
  clnstr[j] :='"';
}

  inc(j);
  clnstr[j] :='''';
  inc(j);
  clnstr[j] :='''';

  inc(j);
  clnstr[j] :='''';
  inc(j);
  clnstr[j] :='''';

 end
 else
 begin
  inc(j);
  clnstr[j] :=str[i];
 end;

end;

 setlength(clnStr,j);

except
 //clnstr :=NUL;
 rt :=0;
end;

 Result :=clnStr;
end;

{
function TunitFrm.safeSQL2(str: String): String;
var
 i,j,len,rt: Integer;
 clnStr: String;
begin

len :=length(str);


//Pga. buffer
clnstr :=str+str;
for i :=1 to (len+len) do
 clnstr[i] :=BLANK;

try

j :=0;
for i :=1 to len do
begin

 if (str[i]='''') then
 begin

  //Enkeltfnutt må registreres som to
  inc(j);
  clnstr[j] :='''';
  inc(j);
  clnstr[j] :='''';

 end
 else
 if (str[i]='"') then
 begin

  //inc(j);
  //clnstr[j] :=str[i];

  //dobbelfnutt må registreres som fire enkeltfnutt

  inc(j);
  clnstr[j] :='''';
  inc(j);
  clnstr[j] :='''';

  inc(j);
  clnstr[j] :='''';
  inc(j);
  clnstr[j] :='''';


 end
 else
 begin
  inc(j);
  clnstr[j] :=str[i];
 end;

end;

 setlength(clnStr,j);

except
 //clnstr :=NUL;
 rt :=0;
end;

 Result :=clnStr;
end;
}

function TunitFrm.safeSQL_2(str: String): String;
var
 i,j,len,rt: Integer;
 cstr: String;
begin

len :=length(str);

try

j :=0;
cstr :=NUL;

for i :=1 to len do
begin

 if (str[i]='''') then
 begin

  //Enkeltfnutt
  cstr :=cstr+SQL_SQUOTE;

 end
 else
 if (str[i]='"') then
 begin

  //dobbelfnutt
  cstr :=cstr+SQL_DQUOTE;

 end
 else
 begin
  cstr :=cstr+str[i];
 end;

end;

// setlength(clnStr,j);

except
 //clnstr :=NUL;
 rt :=0;
end;

 Result :=cstr;
end;


function TunitFrm.cleanupMemoStr(str: String): String;
var
 i,j,len: Integer;
 clnStr: String;
begin

len :=length(str);
clnStr :=str;

//Strip vekk ugyldige tegn
j :=0;
for i :=1 to len do
begin

if (IsCharAlphaNumeric(str[i])) OR
    (str[i]=' ') OR
    (str[i]='%') OR
    (str[i]=':') OR
    (str[i]=';') OR
    (str[i]='/') OR
    (str[i]='\') OR
    (str[i]='(') OR
    (str[i]=')') OR
    (str[i]='+') OR
    (str[i]='_') OR
    (str[i]='-') OR
    (str[i]='.') OR
    (str[i]=',') then
 begin
  inc(j);
  clnstr[j] :=str[i];
 end
 else
 begin
  inc(j);
  clnstr[j] :=BLANK;
 end;

end;

 setlength(clnStr,j);

 Result :=clnStr;
end;



function TunitFrm.cleanupStr(str: String): String;
var
 i,j,len: Integer;
 clnStr: String;
begin

len :=length(str);
clnStr :=str;

//Strip vekk ugyldige tegn
j :=0;
for i :=1 to len do
begin

if (str[i] <> BLANK) then
 if (IsCharAlphaNumeric(str[i])) OR
    (str[i]='/') OR
    (str[i]='\') OR
    (str[i]='(') OR
    (str[i]=')') OR
    (str[i]='+') OR
    (str[i]='_') OR
    (str[i]='-') then
 begin
  inc(j);
  clnstr[j] :=str[i];
 end;

end;

 setlength(clnStr,j);

 Result :=clnStr;
end;


function TunitFrm.cleanupWideStr(wstr: WideString): String;
var
 i,j,len: Integer;
 clnStr: String;
begin

len :=length(wstr);
clnStr :=wstr;

//Strip vekk ugyldige tegn
j :=0;
for i :=1 to len do
begin

 if (wstr[i] <> S_NUL) and
    (wstr[i] <> CR_C) and
    (wstr[i] <> LF_C)then
 begin
  inc(j);
  clnstr[j] :=char(wstr[i]);
 end;

end;

 setlength(clnStr,j);

 Result :=clnStr;
end;



function TunitFrm.cleanupBlanks(str: String): String;
var
 i,j,len,ps: Integer;
 bhit: Boolean;
 clnStr: String;
 ch: Char;
begin

len :=length(str);
clnStr :=str;

//Erstatt alle blanke og tab med kun en blank
//...... erstattes med :
j :=0;
bhit :=FALSE;

for i :=1 to len do
begin

 if ((str[i] = BLANK) OR (str[i] = TAB) OR (str[i] = DOT)) then
 begin

  if (not bhit) then
  begin
   bhit :=TRUE;
   inc(j);

   ps :=i+1;
   if ps>len then
    ps :=len;

   //if (str[i]=DOT) AND (str[ps]=DOT) then
   if (str[ps]=DOT) then
   begin
    clnstr[j] :=':';
    inc(j);
   end;
   //else

   if j<len then
    clnstr[j] :=BLANK;

  end;

 end
 else
 begin
  bhit :=FALSE;

  inc(j);

  if j<len then
   clnstr[j] :=str[i];
 end;

end;

 setlength(clnStr,j);

 Result :=clnStr;
end;


function TunitFrm.makeClipStr(str: String; sep: Char): String;
var
 i,j,len: Integer;
 clnStr: String;
begin

len :=length(str);
clnStr :=str;

//Strip vekk ugyldige tegn
j :=0;
for i :=1 to len do
begin

if (str[i] = BLANK) then
begin
 inc(j);
 clnstr[j] :=sep;
end
else
if (IsCharAlphaNumeric(str[i])) OR
    ((str[i]='æ') OR (str[i]='Æ') OR
      (str[i]='ø') OR (str[i]='Ø') OR
      (str[i]='å') OR (str[i]='Å')) then
 begin
  inc(j);
  clnstr[j] :=str[i];
 end;

end;

 setlength(clnStr,j);

 Result :=clnStr;
end;


function TunitFrm.strFloat(str: String;prec: Integer): String;
begin

 Result :=format('%.*f',[prec,atof(str)]);

end;

function TunitFrm.minVal(v1,v2: Real): Real;
begin

if v1<v2 then
 Result :=v1
else
 Result :=v2;

end;

function TunitFrm.maxVal(v1,v2: Real): Real;
begin

if v1>v2 then
 Result :=v1
else
 Result :=v2;

end;

function TunitFrm.countChars(str: String; ch: Char): Integer;
var
 cx,len,cnt: Integer;
begin
 cnt :=0;
 len :=length(str);

 for cx :=1 to len do
 begin
  if str[cx] =ch then
   inc(cnt);

 end;


 Result :=cnt;
end;


function TunitFrm.fillProdNr(prodnr,dep: String): String;
var
 prd: String;
 prdlen,deplen,cx,dx: Integer;
begin

 //For å allokere 'prd'
 prd :=trim(prodnr);
 Result :=prd;

 if (prd=NUL) OR (dep=NUL) then
  exit;

 prdlen :=length(prodnr);
 deplen :=length(dep);


 //Bytt ut ? eller * med tegn fra 'dep'
 //dx :=0;
 for cx :=1 to deplen do
 begin

  if cx>prdlen then
   break;

  if (prd[cx]=QUEST) OR (prd[cx]=STAR) then
  begin
   prd[cx] :=dep[cx];

  end;

{
  if (isCharAlphaNumeric(prodnr[cx])) AND
     (prodnr[cx]<>BLANK) then
  begin
   inc(dx);
   prd[dx] :=prodnr[cx];
  end;
 }
 end;

 //setlength(prd,dx);

 Result :=prd;
end;

function TunitFrm.formatProdNr(prodnr: String; typ: Integer): String;
var
 prd: String;
 len,cx,dx: Integer;
 begin

 //For å allokere 'prd'
 prd :=prodnr;
 Result :=prd;

 if prd=NUL then
  exit;

 len :=length(prodnr);


 //Fjern alt som ikke er bokstaver eller tall
 dx :=0;
 for cx :=1 to len do
 begin
  if (isCharAlphaNumeric(prodnr[cx])) AND
     (prodnr[cx]<>BLANK) then
  begin
   inc(dx);
   prd[dx] :=prodnr[cx];
  end;

 end;

 setlength(prd,dx);

 len :=length(prd);

 if (typ=PRODNR_WIDE) and (len<PRODNR_WIDE) then
  prd :=format('%s%s%s',[copy(prd,1,6),'00',copy(prd,7,4)])
 else
 if (typ=PRODNR_NORMAL) and (len>PRODNR_NORMAL) then
  prd :=format('%s%s',[copy(prd,1,6),copy(prd,7,4)]);


 Result :=prd;
end;



function TunitFrm.deciStrToMin(str: String): Integer;
var
 ps: Integer;
 strInVal,minStr,hrStr: String;
 deciMin,fmins: Single;
begin

 Result :=0;

 if str=NUL then
  exit
 else
  strInVal :=format('%.2f',[atof(str)]);

  ps :=pos(DOT,strInVal);

  //Sjekk videre for komma separert
  if ps=0 then
   ps :=pos(COMMA,strInVal);


  if ps>0 then
  begin
   hrStr :=copy(strInVal,1,(ps-1));
   minStr :=copy(strInVal,(ps+1),2);

   hr :=strToIntDef(hrStr,0);
   mins :=strToIntDef(minStr,0);

   fmins :=mins;  //Typcast

   deciMin :=fmins*(60/100);

   mins :=(hr*60)+round(deciMin);
  end;

 Result :=mins;
end;



function TunitFrm.minToDeciStr(min: Integer; sep: String): String;
var
 len,cx,ps: Integer;
 strInVal,strOutVal,minStr,hrStr: String;
 deciMin,fmins: Single;
begin

 strOutVal :=NULLCOUNT;

 Result :=strOutVal;

 if min=0 then
  exit;

  //Denne funksjonen regner om fra timer og minutter
  //til antall med tiendeler

  strInVal :=minToStrTime(min,1);

  ps :=pos(DOT,strInVal);

  //Sjekk videre for komma separert
  if ps=0 then
   ps :=pos(COMMA,strInVal);


  if ps>0 then
  begin
   hrStr :=copy(strInVal,1,(ps-1));
   minStr :=copy(strInVal,(ps+1),2);

   hr :=strToIntDef(hrStr,0);
   mins :=strToIntDef(minStr,0);

   fmins :=mins;  //Typcast

   deciMin :=fmins*(100/60);

   minStr :=format('%.0f',[deciMin]);

   strOutVal :=format('%2s%s%2s',[hrStr,sep,minStr]);
   len :=length(strOutVal);

   //Legg inn 0 på evnt. blanke posisjoner etter komma (pgr format)
   for cx :=pos(COMMA,strOutVal) to len do
    if strOutVal[cx]=BLANK then
     strOutVal[cx] :=NULLDIGIT;

  end;

  Result :=strOutVal;
end;


function TunitFrm.intToDeciStr(val: Integer): String;
var
 len,intVal,deciVal,inVal: Integer;
 str: String;
 neg: Boolean;
begin

 str :=NUL;
 Result :=str;

 if val=0 then
  exit;

 inVal :=val;

 if inVal<0 then
 begin
  neg :=TRUE;
  inVal :=inVal*(-1);  //Blir snudd etterpå
 end
 else
  neg :=FALSE;

 intVal :=0;
 while (inval>=DECI_FACTOR) do
 begin
  inVal :=inVal-DECI_FACTOR;
  inc(intVal);
 end;

 deciVal :=inVal;

 //Av ehnsyn til bakover kompabilitet. Skal fjernes.
 if (intVal=0) AND (deciVal<50) then
 begin
  intVal :=deciVal;
  deciVal :=0;
 end;


 if neg then
 begin

  if deciVal=0 then
   str :=format('-%d',[intVal])
  else
   str :=format('-%d,%d',[intVal,deciVal]);

 end
 else
 begin

  if deciVal=0 then
   str :=format('%d',[intVal])
  else
   str :=format('%d,%d',[intVal,deciVal]);

 end;

 len :=length(str);

 if (deciVal>0) AND (str[len]=NULLDIGIT) then
  setLength(str,(len-1));

 Result :=str;
end;

function TunitFrm.deciStrToInt(str: String): Integer;
var
 outVal: Integer;
begin

 Result :=0;
// outVal :=0;

 if str=NUL then
  exit;
{
 ps :=pos(COMMA,str);

 if ps=0 then
  ps :=pos(DOT,str);

 if ps>0 then
 begin
  intVal :=unitFrm.atoi(copy(str,1,(ps-1)));
  deciVal :=unitFrm.atoi(copy(str,(ps+1),2));

  outVal :=(intVal+deciVal)*DECI_FACTOR;
 end;
}

 outval :=round(unitFrm.atof(str)*DECI_FACTOR);

 Result :=outVal;
end;




{
function TunitFrm.checkNorChars(str: String): Integer;
var
 inStr: String;
 i,len: Integer;
begin

 Result :=ERROR_;

 inStr :=trim(str);

 if instr=NUL then
  exit;

 len :=length(instr);

 for i:=1 to len do
 begin
  if (instr[i]='æ') OR
     (instr[i]='Æ') OR
     (instr[i]='ø') OR
     (instr[i]='Ø') OR
     (instr[i]='å') OR
     (instr[i]='Å') then
   exit;

 end;


 Result :=0;
end;
}

function TunitFrm.getTimeSepPos(val: String): Integer;
var
 sepPos: Integer;
begin

Result :=0;

if val =NUL then
 exit;

 //Punktum ?
 sepPos :=pos(DOT,val);

 if sepPos=0 then    //Komma ?
  sepPos :=pos(COMMA,val)
 else
 if sepPos=0 then   //Kolon ?
  sepPos :=pos(COLON,val);

  //Fortsatt ingen time.min separator funnet ?
 if sepPos=0 then
 begin
  Result :=ERROR_
 end
 else
  Result :=sepPos;

end;


function TunitFrm.formatTimeStr(val: String; leadZeros: Integer): String;
var
 sepPos,min,minLen: Integer;
 instr,tmpTc: String;
begin

 inStr :=trim(val);

 if inStr=NUL then
 begin
  tmpTc :=format('%*.*d.%2.2d',
   [leadZeros,leadZeros,0,0]);

  Result :=tmpTc;
  exit;
 end;

 //len :=length(inStr);

 sepPos :=getTimeSepPos(inStr);

 if sepPos <=0 then
 begin
  //Beregn 'val' som minutter
  min :=atoi(inStr);

 end
 else
 begin

 minLen :=length(copy(inStr,(sepPos+1),2));

 splitTime(inStr);

//f.eks 7.3 blir 7.30 (ikke 7.03)
if minLen=1 then
 mins :=mins*10;

 if signflag ='-' then
  min :=((hr*60)+mins)*(-1)
 else
  min :=((hr*60)+mins);

 end;

 tmpTC :=MinToStrTime(min,leadZeros);

 Result :=tmpTc;
end;


function TunitFrm.colorToHTML(colr: Tcolor): String;
var
 //RGBvalue: Longint;
 colorStr,htmlStr: String;
 red,green,blue: String;
begin


 colorStr :=format('$%.8x',[colr]);

 //$<nearest system color><B><G><R>  f.eks $0000FF00 = Grønn

 if copy(colorStr,1,1)='$' then
 begin

  blue :=copy(colorStr,4,2);

  green :=copy(colorStr,6,2);

  red :=copy(colorStr,8,2);

  htmlStr :=format('#%s%s%s',[red,green,blue]);

 end
 else
 begin
 {
  clBlack = TColor($000000);
  clMaroon = TColor($000080);
  clGreen = TColor($008000);
  clOlive = TColor($008080);
  clNavy = TColor($800000);
  clPurple = TColor($800080);
  clTeal = TColor($808000);
  clGray = TColor($808080);
  clSilver = TColor($C0C0C0);
  clRed = TColor($0000FF);
  clLime = TColor($00FF00);
  clYellow = TColor($00FFFF);
  clBlue = TColor($FF0000);
  clFuchsia = TColor($FF00FF);
  clAqua = TColor($FFFF00);
  clLtGray = TColor($C0C0C0);
  clDkGray = TColor($808080);
  clWhite =   TColor($FFFFFF);
  clNone =    TColor($1FFFFFFF);
  clDefault = TColor($20000000);
 }

 end;


 Result :=htmlStr;
end;


function TunitFrm.checkTextWidth(txt: String; fnt: Tfont; maxwidth,cmd: Integer): String;
var
 inStr,outstr,tmpstr: String;
 cx,numchr: Integer;
begin

 if txt=NUL then
  exit;


  instr:=trim(txt);

  with fontLabel do
  begin
   font :=fnt;
   width :=4;
   caption :=format('%s',[inStr]);
  end;

  //Vil txt ta større plass enn spesifisert maks bredde ?
  if fontLabel.width>maxWidth then
  begin
   numChr :=length(inStr);

   tmpstr :=inStr;
   for cx :=numChr downto 1 do
   begin
    setlength(tmpstr,cx);
    fontLabel.caption :=tmpStr;
    if fontLabel.width<maxWidth then
    begin
     outStr :=format('%s.',[tmpStr]);
     break;
    end;

   end;
  end
  else
   outStr :=inStr;



  Result :=outstr;
end;


function TunitFrm.strCharOnly(str: String): String;
var
 inStr,outStr: String;
 i,j,len: Integer;
begin

 inStr :=trim(str);
 outStr :=inStr;   //pgr memeory allokering
 len :=length(instr);
 if len =0 then
  exit;

 j :=0;
 //Fjern alt annet enn bokstaver
 for i :=1 to len do
 begin
  if isCharAlpha(inStr[i]) then
  begin
   inc(j);
   outStr[j] :=inStr[i];

  end;
 end;

 setLength(outStr,j);

 Result :=outStr;
end;


function TunitFrm.strNumOnly(str: String): String;
var
 inStr,outStr: String;
 i,j,len: Integer;
begin

 inStr :=trim(str);
 outStr :=inStr;   //pgr memeory allokering
 len :=length(instr);
 if len =0 then
  exit;

 j :=0;
 //Fjern alt annet enn tall
 for i :=1 to len do
 begin

  case inStr[i] of

  '1','2','3','4','5','6','7','8','9','0':
   begin
    inc(j);
    outStr[j] :=inStr[i];
   end;
  end;

 end;

 setLength(outStr,j);

 Result :=outStr;
end;



function TunitFrm.StrNumToStrTime(val: String; sep: String): String;
var
 v1,v2: Integer;
 str: String;
begin

Result :='0.00';

if (trim(val)=NUL) OR
   (trim(val)=NULLDIGIT) then
 exit;

 //Gjør om fra f.eks 0800 til 8,00
 //De to siste siffer er alltid desimaler
  v1 :=strToInt(copy(val,1,length(val)-2));
  v2 :=strToInt(copy(val,length(val)-1,2));
  //value :=unitFrm.atof(format('%d.%d',[v1,v2]);

  {
  if typFrm.numberSep <> NUL then
   sep :=typFrm.numberSep
  else
   sep :=COMMA;
  }

  str :=format('%2d%s%2.2d',[v1,sep,v2]);

 Result :=str;
end;

function TunitFrm.strTimeToStrNum(val: String; var sign: String): String;
var
 ps,v1,v2: Integer;
 tmp,valStr,str: String;
begin


v1 :=0;
v2 :=0;

valStr :='0000';
Result :=valStr;

if (trim(val)=NUL) OR
   (trim(val)=NULLDIGIT) then
 exit;

//Fjern minus
ps :=pos(MINUS_,val);
if ps>0 then
begin
 str :=copy(val,(ps+1),(length(val)-1));
 sign :=copy(val,ps,1);
end
else
begin
 str :=val;
 sign :=NUL;
end;

 //ps :=0;

 //Gjør om fra f.eks 8,00 til 0800
 //Forsøk med både komma og punktum

 ps :=pos(COMMA,str);
 if ps=0 then
  ps :=pos(DOT,str);

 //Sjekk om dette evnt er heltall uten komma
 if ps=0 then
 begin

 try
  v1 :=StrToInt(str);
 except
  v1 :=0;
 end;

  v2 :=0;

 end
 else
 begin

  try
   v1 :=StrToInt(copy(str,1,ps-1));
  except
   v1 :=0;
  end;

  try

  tmp :=trim(copy(str,ps+1,2));

   if length(tmp)=1 then
    v2 :=strToInt(tmp)*10
   else
    v2 :=strToInt(tmp);

  except
   v2 :=0;

 end;
end;

 //Hvis sum er større enn 100,
 //vil 2.2 overprøves slikt at det blir f.eks 164.00
 valStr :=format('%2.2d%2.2d',[v1,v2]);

 Result :=valStr;
end;





//end;
function TunitFrm.getOS: integer;
var
 osi: TosVersionInfo;
 os,osVer: Integer;
begin

 os :=0;
 osVer :=0;

 osi.dwOSversionInfoSize :=sizeof(osi);
 getVersionEx(osi);

 //os :=swap(loword(getVersion));
 //os :=osi.dwMajorVersion;
 os :=osi.dwPlatFormID;

 case os of
  VER_PLATFORM_WIN32_WINDOWS: osVer :=OS_WIN95;
  VER_PLATFORM_WIN32_NT: osVer :=OS_NT;
 end;

 Result :=osVer;
end;


//******************************************

function TunitFrm.formatFloatToStr(floatVal: Real; mask: String): String;
var
 tmp,maskSep: String;
 cx,len,maskLead,maskPrec: Integer;
begin

Result :=NULLDIGIT;

 if mask = NUL then
  exit;

len :=length(trim(mask));

 maskLead :=0;
 maskPrec :=0;

 for cx:=1 to len do
 begin

  if (mask[cx] =',') OR (mask[cx] = DOT) then
  begin
   maskLead :=cx;
   maskSep :=mask[cx];
  end;

 end;

 //Hvis ingen mask-separator er funnet
 if maskLead =0 then
  exit;

 maskPrec :=len-(maskLead);

 if maskPrec <=0 then
  exit;

 tmp :=format('%*.*f',[maskLead,maskPrec,floatVal]);

 //format() legger komma mellom int og float f.eks 23,45
 //OvcPictureField aksepterer bare punktum, derfor ...
 result :=strReplace(Pchar(tmp),',',Pchar(maskSep));

end;


function TunitFrm.stripLastChr(var str: String; keys,stop: String): Integer;
var
 cx,len: Integer;
begin


 len :=length(str);
 Result :=len;

 if len<2 then
  exit;

 if keys = NUL then
  exit;

 for cx :=len downto 1 do
 begin

 try
  if (stop = NUL)  AND
     ((str[cx] <> keys[1]) AND (str[cx] <> BLANK)) then
    break;

  if stop <> NUL then
   if str[cx] =stop[1] then
    break;

  if keys <> NUL then
   if str[cx] =keys[1] then
   begin
    str[cx] :=BLANK;
    dec(len);
   end;

 except
  continue;
 end;

 end;

 //NEI ! fordi dette blir feil hvis det ligger blank først
 //var feil helt til 1/7-99
 //len :=length(trim(str));

 setLength(str,len);

 Result :=len;
end;


function TunitFrm.makeFontStyle(fs:String): TfontStyles;
begin
//
  Result :=[];   //Anta dette først

 if AnsiCompareText(fs,'Bold') =0 then
   Result :=[fsBold];

 if AnsiCompareText(fs,'Italic') =0 then
   Result :=[fsItalic];

 if AnsiCompareText(fs,'Bold Italic') =0 then
   Result :=[fsBold,fsItalic];

end;


function TunitFrm.getFontStyle(fs:TfontStyles): String;
begin
 //

 Result :='Regular';

 if fs = [fsBold] then
  Result :='Bold';

 if fs = [fsItalic] then
  Result :='Italic';

 if fs = [fsBold,fsItalic] then
  Result :='Bold Italic';


end;








//****************************************************************

function TunitFrm.msgDlg(txt: String; cmd: Integer): Integer;
var
 msgStr: String;
 dlgType:TMsgDlgType;
 rt,flag: Word;
 dlgBtns: TMsgDlgButtons;
 begin

screen.cursor :=crDefault;

dlgType :=mtError;
flag :=mb_OK;

 case cmd of
  YESNOCANCEL_:
  begin
   //messageBeep(65535);
   dlgType :=mtConfirmation;
   msgStr :='OBS';
   flag :=mb_YesNoCancel;
   dlgBtns :=[mbYes, mbNo,mbCancel];
  end;


  QUESTION_,QUESTION_NO_,QUESTION_YES_:
  begin

   if cmd=QUESTION_YES_ then
    dlgBtns :=[mbYes,mbNo]
   else
   if cmd=QUESTION_NO_ then
   begin
    //dlgBtns :=[mbNo,mbYes];  //Dette fungerer ikke ...

{
  Windows.MessageBox(
    handle,
    'This is a system modal message'#13#10'from an inactive application',
    'A message from an inactive application!',
    MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST or MB_ICONHAND) ;

The most important piece is the last parameter. The "MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST" ensures the message box is system modal, top most and becomes the foreground window.
MB_SYSTEMMODAL flag ensures that the user must respond to the message box before continuing work in the window identified by the hWnd parameter.
MB_TOPMOST flag specifies that the message box should be placed above all non-topmost windows and should stay above them, even when the window is deactivated.
MB_SETFOREGROUND flag ensures that the message box becomes the foreground window.
}


              //OBS: For at modal skal virke, må handle være mainform !
   rt := MessageBox(Application.MainForm.handle, PAnsiChar(txt),
    PAnsiChar(Application.MainForm.caption),
    (MB_ICONWARNING or MB_SYSTEMMODAL or //MB_SETFOREGROUND or MB_TOPMOST or
     MB_YESNO or MB_DEFBUTTON2));

   Result :=rt;
   exit;


   end
   else
    dlgBtns :=[mbYes,mbNo];

   dlgType :=mtWarning;
   msgStr :='OBS';
   flag :=mb_OKCancel;
  end;

  ERROR_:
  begin
   dlgType :=mtError;
   msgStr :='Error';
   flag :=mb_OK;
   dlgBtns :=[mbCancel];
  end;

  INFO_:
  begin
   dlgType :=mtInformation;
   msgStr :='OBS';
   flag :=mb_OK;
   dlgBtns :=[mbOK];
  end;
 end;
{
function MessageDlg(const Msg: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons;   HelpCtx: Longint): Word;
if MessageDlg('Welcome to my Object Pascal application.  Exit now?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
}

rt :=messageDlg(txt,dlgType,dlgBtns,0);

Result :=rt;
 //Result :=Application.MessageBox(Pchar(txt),Pchar(msgStr), flag OR MB_DEFBUTTON2);

end;




//*************************************************************************

function TunitFrm.breakStrToInts(str: String; delim: Char;ar: pARFLDI): Integer;
var
 ax,i,j,k,len: Integer;
const
 MAX_ITEM_LEN = 8;
begin

ax :=0;

len :=length(str);
if len>0 then
begin

 j :=1;
 for ax :=1 to MAXFLDS-1 do
 begin

  ar[ax] :=0;
  i:=1;
  for k:=1 to MAX_ITEM_LEN+1 do
   strChars[k] :=S_NUL;

   while (i<MAX_ITEM_LEN) AND (j<=len) do
    begin

    if (str[j]=BLANK) OR (str[j]=TAB)then
    begin
     inc(j);
    end
    else
    begin

    if (str[j] = delim) then
     break
    else
     begin
     strChars[i] :=str[j];
     inc(i);
     inc(j);
     end;
    end;
   end;
   

   if length(strChars)>0 then
    ar[ax] :=atoi(strChars);

   if j>=len then
    break
   else
    inc(j);

  end;
end;


 Result :=ax;   //Antall items
end;

//************************************************************************

function TunitFrm.breakStrToStrs(str: String; delim: Char; ar: pARFLDS): Integer;
var
 ax,i,j,k,len: Integer;
 arstr: String;
const
 MAX_ITEM_LEN = 32;   //Tidligere 24
begin

//setlength(strChars,MAX_PCHAR_LEN);
ax:=0;

len :=length(str);

if len>0 then
begin

 j :=1;
 for ax :=1 to MAXFLDS-1 do
 begin

   ar[ax] :=NUL;
   i:=1;
  for k:=1 to MAX_ITEM_LEN+1 do
   strChars[k] :=#32; //SNUL;

   while (i<MAX_ITEM_LEN) AND (j<=len) do
    begin

    if {(str[j]=BLANK) OR }(str[j]=TAB)then
    begin
     inc(j);
    end
    else
    begin

    if (str[j] = delim) then
     break
    else
     begin
     strChars[i] :=str[j];
     inc(i);
     inc(j);
     end;
    end;
   end;


   if length(strChars)>0 then
   begin

    //ar[ax] :=strChars;
    //setLength(ar[ax],(i-1));

    arstr := strChars;  //Ny 27.02.99
    setLength(arstr,(i-1));
    ar[ax] :=trim(arstr);  //trim fordi det kan være blanke foran

    // k :=0;
    {
    tmplen :=length(strChars);
    for k:=1 to tmplen do
     ar[ax][k] :=strChars[k];
    k :=0;
    }
   end;


   if j>=len then
    break
   else
    inc(j);

  end;
end;


 Result :=ax;
end;


//********************************************************************


function Tunitfrm.strToUpper(src: String): String;
var
 len,i: Integer;
 res: String;
begin



len :=length(src);
res :=NUL;

res := upperCase(src);

//Fordi upperCase feiler på æ.ø og å ....
 for i:=1 to len do
 begin

  case res[i] of
   'æ': res[i]:='Æ';
   'ø': res[i]:='Ø';
   'å': res[i]:='Å';

  end;

 end;


 Result :=res;
end;




//*******************************************************

function TunitFrm.strToLower(src: String): String;
var
 len,i: Integer;
 res: String;
begin

len :=length(src);
res :=NUL;

res := lowerCase(src);

//Fordi upperCase feiler på æ.ø og å ....
 for i:=1 to len do
 begin

  case res[i] of
   'Æ': res[i]:='æ';
   'Ø': res[i]:='ø';
   'Å': res[i]:='å';

  end;

 end;


 Result :=res;
end;


function Tunitfrm.chToUpper(ch: Char): Char;
var
 res: Char;
begin

//Fordi upCase feiler på æ.ø og å ....
  case ch of
   'æ': res :='Æ';
   'ø': res :='Ø';
   'å': res :='Å';
   else
    res := upCase(ch);
  end;


 Result :=res;
end;


function Tunitfrm.chToLower(ch: Char): Char;
var
 res: Char;
 tmp: String;
begin


 tmp :=ch;

//Fordi loCase feiler på æ.ø og å ....
  case ch of
   'æ': res :='Æ';
   'ø': res :='Ø';
   'å': res :='Å';
   else
   begin
    tmp := lowerCase(tmp);
    res :=tmp[1];
   end;
  end;


 Result :=res;
end;


//********************************************************

function TunitFrm.snult(var src: String): Word;
begin

  src :=trim(src);

  Result :=length(src);

end;

//********************************************************
{
function memset(var src: String; const fill: Char; len: Longint): Byte;
var
 i: Integer;
begin

 for i :=1 to 2 do
  src[i] := fill;

 Result :=0;
end;
}


function TunitFrm.strChange(str,key,fill: String): String;
 function  str_Pos(const aSubstr,s: String; aOfs: Integer): Integer;
 begin

  Result:=Pos(aSubStr,Copy(s,aOfs,(Length(s)-aOfs)+1));
  if (Result>0) and (aOfs>1) then
   Inc(Result,aOfs-1);

 end;
var
  P : Integer;
  outstr: String;
begin

  outstr :=str;
  Result :=outstr;

  P:=Pos(key,outstr);

  while P<>0 do
  begin
    Delete(outstr,P,Length(key));

    Insert(fill,outstr,P);

    Inc(P,Length(fill));
    P:=str_Pos(key,outstr,P);
  end;

  Result :=outstr;
 end;


function TunitFrm.strReplace(src: PChar; const skey: PChar;
		 const fill: PChar): String;
var
 ps,cnt: Integer;
 str,tmp: String;
begin

 //Ny 01.07.08
 str :=strChange(src,skey,fill);
 Result :=str;
 exit;

{
 //PChar-buffere som er allokert i constructor
 pcb.str1 :=S_NUL;
 pcb.str2 :=S_NUL;
 //pcb.destStr :=SNUL;
 pcb.tmpStr :=S_NUL;

pcb.srcLen :=strlen(src);
pcb.keyLen :=strlen(skey);

//pcb.destStr :=SNUL;
//Result :=pcb.destStr;


//Hvis tom source string
if pcb.srcLen<1 then
begin
 Result :=src;
 exit;
end;

 if pcb.srcLen > MAX_PCHAR_LEN then
  begin
   showMessage('Source string to big for destination buffer');
   exit;
  end;

 if pcb.keyLen > MAX_PCHAR_LEN then
  begin
   showMessage('Key string to big for destination buffer');
   exit;
  end;

pcb.str1 :=S_NUL;
pcb.str2 :=S_NUL;

//ignoreCaseInStringCompares(No)

ps :=1;
cnt :=0;
pcb.destStr :=src;

//Alloker tmp memory
//pcb.destStr :=StrAlloc(pcb.srcLen+32);
//strPCopy(pcb.destStr,src);  //Pga logikk i while-loop


//Loop til alle 'skey' er byttet ut
while (ps>0) and (cnt<MAX_OBJECTS) do
begin

//Finnes 'skey' fortsatt i 'destStr' ?
pcb.tmpStr :=sysUtils.strpos(pcb.destStr,skey);

if pcb.tmpStr =nil then
 ps :=0
else
 ps :=(pcb.tmpStr-pcb.destStr)+1;


if ps>0 then
 begin
  pcb.str1 :=S_NUL;
  pcb.str2 :=pcb.tmpStr+pcb.keylen;
  //dif :=(srcLen-(ps+keyLen))+1;

   pcb.str1 :=pcb.destStr;
 // pcb.str1[ps-1] :=SNUL;   //Dette influerer på orginal 'src' ....

  tmp :=pcb.str1;
  setLength(tmp,(ps-1));

  //Ny string der 'skey' er satt til 'fill'
  Str :=format('%s%s%s',[tmp,fill,pcb.str2]);


 if length(str)> MAX_PCHAR_LEN then
  begin
   showMessage('New string to big for destination buffer');
   //pcb.destStr :=SNUL;
   //strDispose(pcb.destStr);
   Result :=S_NUL;
   exit;
  end
  else
   pcb.destStr :=PChar(str);
   //strCopy(pcb.destStr,Pchar(str));


 end
  else
   break;

   inc(cnt);
 end;

 if pcb.destStr = S_NUL then
 begin
  tmp :=NUL;
  Result :=tmp;
 end
 else
  Result :=pcb.destStr;

  //strDispose(pcb.destStr);
}
end;

 //************************************************************************

function TunitFrm.setWindowSize(mdi,frm: Tform; cmd: Integer): Integer;
var
 tws: TwindowState;
 frmCnt: Integer;

const
 leftMargin =20;
 bottomMargin = 20;
 yOffset = 16;
 xOffset = 16;
 begin


frmCnt :=mdi.MDIchildCount;

if frmCnt <=0 then
begin
 Result :=ERROR_;
 exit;
end;


case cmd of

NORMAL_SIZE:
begin
  typFrm.triggInhibit(ONX); //For å unngå  at click() aktiveres påny
  tws :=Frm.windowState;
  //Hvis ett annet form er maximized blir også aktuell form
  //av ukjent grunn maximized ved bruk av show() ...
  Frm.show;
  Frm.windowState :=tws;
 typFrm.triggInhibit(OFF);
end;


DESIGNED_SIZE:
begin
 frm.left :=(frmCnt-1)*xOffset;
 frm.top :=(frmCnt-1)*yOffset;
end;

MAX_SIZE:
 begin
 frm.left :=(frmCnt-1)*xOffset;
 frm.top :=(frmCnt-1)*yOffset;
 frm.width :=mdi.clientWidth-leftMargin;
 frm.height :=mdi.clientHeight-bottomMargin;
 end;

 MIN_SIZE:
 frm.windowstate :=wsMinimized;
end;

 Result :=0;
end;

//********************************************************

function  TunitFrm.atof(const val: String): Real;
var
 len,i: Smallint;
 sval: String;
begin


 sval:= trim(val);

 if (sval = NUL) OR
    (sval='-') OR
    (sval='+') OR
    (sval='%') OR
    (sval='/') then
  sval :=NULLDIGIT;

len :=0;
//StrToFloat må ha riktig decimal-separator iflg.regionale settinger
//i kontroll-panel
if typFrm.numberSep <> NUL then
begin
 len :=length(sval);

for i:=1 to len do
 if (sval[i]=COMMA) OR (sval[i]=DOT) then
  sval[i] :=typFrm.numberSep;

end;

 try
  Result :=strToFloat(sval);
  except

    //Kan skyldes feil decimalseparator
    //Gjør nytt forsøk med å bytte om komma og punktum
  if len =0 then
   len :=length(sval);

   for i :=1 to len do
   begin
    if sval[i]=DOT then
     sval[i] :=COMMA
    else
    if sval[i]=COMMA then
     sval[i] :=DOT;

   end;

  try
   Result :=strToFloat(sval);
  except
   Result :=0;
  end;
 end;


end;

//***************************************************

function TunitFrm.atoi(const val: String): Integer;
var
 ps: Integer;
 sval: String;
begin

 sval:= trim(val);

 if (sval = NUL) OR
    (sval='-') OR
    (sval='+') OR
    (sval='%') OR
    (sval='/') then
  sval :=NULLDIGIT;


//Sjekk om 'val' har desimaler
ps :=pos(DOT,sval);
if ps=0 then
 ps :=pos(COMMA,sval);

if ps>0 then
begin
 sval :=format('%.0f',[atof(sval)]);
end;

try
 Result :=strToInt(sval);
except
 Result :=0;
end;

end;

//***********************************************************

{
procedure TunitFrm.fldEnter(sender: Tobject);
begin

if (sender is Tedit) then
begin

 with sender as Tedit do
 begin
  savetxtColor :=font.Color;
  saveBkgColor :=Color;
  color :=clAqua;
  font.color :=clBlack;
 end;


end
else
begin

if (sender is TcomboFld) then
begin

 with sender as TcomboFld do
 begin
  savetxtColor :=font.Color;
  saveBkgColor :=Color;
  color :=clAqua;
  font.color :=clBlack;
 end;

end
else
begin

if (sender is TmemoFld) then
begin

 with sender as TmemoFld do
 begin
  savetxtColor :=font.Color;
  saveBkgColor :=Color;
  color :=clAqua;
  font.color :=clBlack;
 end;

end
else
begin


end;
//end;
//end;
//end;
//end;
end;
end;

end;


procedure TunitFrm.fldExit(sender: Tobject);
begin

if (sender is Tedit) then
begin
 with sender as Tedit do
 begin
 color :=clBlue;
 font.color :=saveTxtColor; //clWhite;
 color :=saveBkgColor;
 end;

end
else
begin

if (sender is TcomboFld) then
begin
 with sender as TcomboFld do
 begin
 color :=clBlue;
 font.color :=saveTxtColor; //clWhite;
 color :=saveBkgColor;
 end;

end
else
begin


if (sender is TmemoFld) then
begin
 with sender as TmemoFld do
 begin
 color :=clBlue;
 font.color :=saveTxtColor; //clWhite;
 color :=saveBkgColor;
 end;

end
else
begin

end;
//end;
//end;
//end;
//end;
end;
end;

end;

}


//**************************************************

function TunitFrm.isAlpha(ch: Char): Boolean;
begin

if (ord(ch) <ASCII_LETTER_LOW) OR
   (ord(ch) >ASCII_LETTER_HIGH) then
begin
  Result :=FALSE;
  exit;
end;

 Result :=TRUE;
end;

//*********************************************************

function TunitFrm.isDigit(ch: Char): Boolean;
begin

if (ord(ch) <ASCII_NUM_LOW) OR
   (ord(ch) >ASCII_NUM_HIGH) then
begin
  Result :=FALSE;
  exit;
end;

 Result :=TRUE;
end;

//*********************************************************

{
procedure TunitFrm.markToggle(fld: Tfld; var key: Char);
begin

if (key = TAB) OR (key =ENTER) then
 exit;

 if (fld.text <> MARK) then
  key :=MARK
 else
  key := BACK_SPACE;

 fld.selStart :=0;
 fld.selLength :=1;


end;
}



//*********************************************************

function  TunitFrm.getParseValue(str: String; var ival: Integer): String;
var
 i,j,k,len: Byte;
 fname,val: String;
const
 LB = '(';
 RB = ')';

begin

 len :=Strlen(PChar(str));
 val :='     ';  //For å allokere memory
 for i :=1 to len do
 begin
  if str[i] = LB then
  begin

   fname :=copy(str,1,(i-1));   //Posisjon før (n)
   j :=1;
   k :=i+1;
   while (str[k] <> RB) AND (k<len) do
   begin
    val[j] :=str[k];
    inc(j);
    inc(k);
   end;

   break;
  end;

  end;

ival :=atoi(val);

Result :=fname;
end;

//*******************************************************************
{$IFNDEF DVC}

function TunitFrm.checkRunning(ActivateIt: boolean) : Boolean;
var
  hSem : THandle;
  hWndMe : HWnd;
  AppTitle: string;
begin
	// default result
  Result := False;

  // Save the current title
  AppTitle := Application.Title;

  // Create a Semaphore in memory - If the semaphore exist,
  // an error code is generated.  To make it unique, we will use the
  // application title!
  hSem := CreateSemaphore(nil, 0, 1, pChar(AppTitle));

  //Now, check to see if the semaphore exists
  if ((hSem <> 0) AND (GetLastError() = ERROR_ALREADY_EXISTS)) then begin
    CloseHandle(hSem); // The semaphore handle will be close with the app anyway!
		//set result
    Result := True;
  end;

  if Result and ActivateIt then begin
	  //Change our name so we don't find us
    Application.Title :=  'zzzzzzz';

  	//Find other instance and bring it to the top
	  hWndMe := FindWindow(nil, pChar(AppTitle));
  	if (hWndMe <> 0) then begin
  		if IsIconic(hWndMe) then
	    	ShowWindow(hWndMe, SW_SHOWNORMAL)
  	  else
    	  SetForegroundWindow(hWndMe);
	  end;
  end;
end;




procedure TunitFrm.initPbar;
var
    ICCRec: TICCEx;
begin
    ICCRec.dwSize := sizeof (ICCRec);
    ICCRec.dwFlags := ICC_Cool_Classes;
    InitCommonControlsEx (ICCRec);
end;


procedure TunitFrm.AlignPbar (w,h: Integer; PbarWnd: hWnd; wctl: TwinControl);
var
    rcForm: TRect;
begin
    //GetClientRect (GetParent (PbarWnd), rcForm);
   if (w=0) AND (h=0) then
   begin
    rcForm.right :=wctl.left+wctl.width;
    rcForm.bottom :=wctl.top+wctl.height;
   end
   else
   begin
    rcForm.right :=w;
    rcForm.bottom :=h;
   end;

   MoveWindow (PbarWnd, 0, 0, rcForm.right, rcForm.Bottom, True);
end;


procedure TunitFrm.AddPband (w,h: Integer; PbarWnd: hWnd; wctl: TWinControl);
var
    rc: TRect;
    rbbi: TRebarBandInfo;
//    szBuff: array [0..100] of Char;
begin
    FillChar (rbbi, sizeof (rbbi), 0);
    GetWindowRect (wctl.Handle, rc);

    with rbbi do
    begin
        cbSize := sizeof (rbbi);
        fMask := RBBIM_Child or RBBIM_ChildSize or RBBIM_Style or RBBIM_Colors;
        cxMinChild := w; //Minimum bredde ved click på skille-strek
        cyMinChild := (rc.bottom - rc.top);
        clrFore := GetSysColor (Color_BtnText);
        clrBack := GetSysColor (Color_BtnFace);
        fStyle := RBBS_ChildEdge or RBBS_FixedBmp;
        hwndChild := wctl.Handle;
        iImage := 0;
    end;
                                             //trick pgr datatype
    SendMessage (PbarWnd, RB_InsertBand, -1, LongInt (@rbbi));

    AlignPbar (h,w,PbarWnd,wctl);
end;



function TunitFrm.AddPbar(Wnd: hWnd): hWnd;
var
    style: DWord;
begin
    style := ws_Visible or ws_Child or ws_Border or ws_ClipChildren or ws_ClipSiblings;
    style := style or RBS_VarHeight or rbs_BandBorder;
    style := style or CCS_NoDivider or CCS_NoParentAlign;

    Result := CreateWindowEx (ws_ex_ToolWindow, ReBarClassName,
                              Nil, style, 0, 0, 200, 100, Wnd,
                              0, hInstance, Nil);
end;


procedure TunitFrm.setPnlSize(ppo: pPnlObj; xpos,ypos: Integer);
var
 xtmp: Integer;
begin

 xtmp :=round(((ppo.pos+0)-xpos)*(1/ppo.scale));
 ppo.pnl.width :=ppo.width -xtmp;

end;


procedure TunitFrm.stopPnlMove(ppo: pPnlObj);
begin

 if ppo.mode = ONX then
 begin
  ppo.left :=ppo.pnl.left;
  ppo.width :=ppo.pnl.width;
  ppo.fromKl :=ppo.difFromKl;
  ppo.toKl :=ppo.difToKl;
{
  ppo.pnl.caption :=format('%s - %s',
   [unitFrm.minToStrTime(ppo.fromKl,2),
    unitFrm.minToStrTime(ppo.toKl,2)]);
}
  screen.cursor :=crDefault;
  ppo.mode :=OFF;
 end;


end;



procedure TunitFrm.doPnlMove(ppo: pPnlObj; xpos,ypos: Integer;
 sender: Tobject; shift: TshiftState);
begin


if shift = [ssLeft,ssShift] then
begin

 setPnlSize(ppo,xpos,ypos);

end
else
if shift = [ssLeft] then
begin


if ppo.mode =ONX then
begin
 ppo.pnl.left :=xpos+(ppo.pnl.left-ppo.pos);
 screen.cursor :=crSizeWE;
 //ppo.left :=ppo.pnl.left;
end
else
begin
 ppo.left :=ppo.pnl.left;
 screen.cursor :=crSizeWE;
 ppo.mode :=ONX;
end;

end;

end;

procedure TunitFrm.initPnlMove(ppo: pPnlObj; id: Integer; sender: Tobject);
begin

  if sender is Tpanel then
  begin

   with sender as Tpanel do
   begin
    ppo.id :=id;
    ppo.pnl :=sender as Tpanel;
    ppo.width :=ppo.pnl.width;
    ppo.pos :=round(ppo.pnl.width/2);
   end;
  end;

end;



{$ENDIF}


//*******************************************************

function TunitFrm.checkDir(dr: String; cmd: Integer): Integer;
var
 dirAr: ARFLDS;
 delim,rootDir,tmpdir,curDir: String;
 dirFlag: Boolean;
 cx,dirCnt,rt: Integer;
begin

 Result :=CANCEL_;

 if dr = NUL then
  exit;

  curDir :=getCurrentDir;

  dirFlag :=setCurrentDir(dr);  //Sjekk om 'dr' finnes

  setCurrentDir(curDir);    //Sett tilbake opprinnelig


  if cmd = CHECK_ then
  begin

   if dirFlag = TRUE then
    Result :=0
   else
    result :=ERROR_;

   exit;
  end;


  if dirFlag = FALSE then
  begin
   rt :=unitFrm.msgDlg(format('Katalog %s eksisterer ikke.'+FNUL+
   'Skal dette opprettes ?',[dr]),QUESTION_);

   if (rt = mrYes) OR (rt = mrOK) then
   begin
{
    curDir :=format('%*s',[MAX_DIRECTORY_LEN,NUL]);

 dirLen :=getCurrentDirectory(MAX_DIRECTORY_LEN,PChar(curDir));

 if (dirLen>0) AND (dirLen<MAX_DIRECTORY_LEN) then
 begin

  setCurrentDirectory(PChar(progrDir.text));

  CreateDirectory('XLS',nil);
  CreateDirectory('BTX',nil);
  CreateDirectory('HTML',nil);

  setCurrentDirectory(PChar(curDir));
 end;
}

    delim :='\';

    //Sjekk om flere directories er oppgitt
    dirCnt :=unitFrm.breakStrToStrs(dr,delim[1],@dirAr);

    if dirCnt>MAX_DIRS then
    begin
     msgDlg(format('Max %d kataloger kan opprettes pr gang.',
      [MAX_DIRS]),INFO_);
     exit;
    end;

   if dirCnt >1 then
   begin
     rootDir :=format('%s%s%s',[dirAr[1],delim,dirAr[2]]);

     //Lag første directory (hvis det ikke allerede er der)
     //Funksjonen bare feiler hvis 'rootDir' allerede er der
     createDir(rootDir);

    tmpDir :=rootDir;
    //Lag neste directories. Start på 3 pgr.rootDir
    for cx :=3 to dirCnt do
    begin

      if (dirAr[cx]=NUL) OR (dirAr[cx]=DOT) OR (dirAr[cx]=COMMA) then
       break;

      if setCurrentDir(tmpDir) then
      begin

       if createDir(dirAr[cx]) then
        tmpDir :=tmpDir+delim+dirAr[cx]
       else
       begin
        unitFrm.msgDlg(format('%s %s',
        [NO_CREATE_,dirAr[cx]]),ERROR_);
        break;
       end;

      end
      else
      begin
       unitFrm.msgDlg(format('%s %s',
       [NO_ACCESS_,tmpDir]),ERROR_);
       break;
      end;

    end;

     setCurrentDir(curDir);    //Sett tilbake opprinnelig

    end; //if dirCnt >1
   end
   else
    exit;

  end;


 Result :=0;
end;

//***********************************************************

function TunitFrm.TCtoMin(tc: TdateTime): Integer;
var
 hr,mins,sec,msec: Word;
begin
 //

 decodeTime(tc,hr,mins,sec,msec);

 Result :=(hr*60)+mins+round(sec/60);

end;


function TunitFrm.minToTC(min: Integer): TdateTime;
var
 hr,mins,sec,msec: Word;
begin

 hr :=0;
 sec :=0;
 msec :=0;
 mins :=min;

 signflag :=NUL;

{
if mins<0 then
begin
 mins:=mins*(-1);
 signflag :='-';
end;
}

 while (mins>=60) do
 begin
  mins :=mins-60;
  inc(hr)
 end;


 Result :=encodeTime(hr,mins,sec,msec);

 //
end;


 function TunitFrm.format_TC(tcs: String; showFrames: Boolean): String;
 var
  str,tcrs,hrs,mins,secs,frms: String;
  cx,cnt,len,ival: Integer;
  tcr: ARFLDS;
 begin

  str :=NUL;
  Result :=str;

  //if trim(tcs)=NUL then
  // exit;


  if showFrames then
   str :=TC_NULL
  else
   str :=TC_NULL_HMS;

  Result :=str;

  len :=length(tcs);

  tcrs :=strReplace(Pchar(tcs),DOT,TC_SEP);


  if pos(DOT,tcrs)>0 then
   cnt :=breakStrToStrs(tcrs,DOT,@tcr)
  else
  if pos(COMMA,tcrs)>0 then
   cnt :=breakStrToStrs(tcrs,COMMA,@tcr)
  else
  if pos(COLON,tcrs)>0 then
   cnt :=breakStrToStrs(tcrs,COLON,@tcr)
  else
  begin
   //Er det bare et tall? Bruk dette som sekunder
   ival :=atoi(tcs);
   if (ival>0) AND (ival<=59) then
   begin
    tcrs :=format('.%d',[ival]);
    cnt :=breakStrToStrs(tcrs,DOT,@tcr);
   end
   else
    exit;

  end;

   frms :='00';

   if cnt =4 then
   begin
    hrs :=format('%02d',[atoi(tcr[1])]);
    mins :=format('%02d',[atoi(tcr[2])]);
    secs :=format('%02d',[atoi(tcr[3])]);
    frms :=format('%02d',[atoi(tcr[4])]);
   end
   else
   if cnt =3 then
   begin
    hrs :=format('%02d',[atoi(tcr[1])]);
    mins :=format('%02d',[atoi(tcr[2])]);
    secs :=format('%02d',[atoi(tcr[3])]);
   end
   else
   if cnt =2 then
   begin
    mins :=format('%02d',[atoi(tcr[1])]);
    secs :=format('%02d',[atoi(tcr[2])]);
   end
   else
   if cnt =1 then
   begin
    secs :=format('%02d',[atoi(tcr[1])]);
   end;


  if secs=NUL then
   secs :=TC_ZERO;

  if mins=NUL then
   mins :=TC_ZERO;

  if hrs=NUL then
   hrs :=TC_ZERO;


  if showFrames then
   str :=format('%s%s%s%s%s%s%s',[hrs,TC_SEP,mins,TC_SEP,secs,TC_SEP,frms])
  else
   str :=format('%s%s%s%s%s',[hrs,TC_SEP,mins,TC_SEP,secs]);

  str :=strReplace(PChar(str),BLANK,NULLDIGIT);

  Result :=str;
 end;


function TunitFrm.getTimeStr(tcs: String): String;
var
 timeStr: String;
 cx,len,psMin,psSec: Integer;

begin

 timeStr :=NUL;
 Result :=timeStr;

 len :=length(tcs);
 if len=0 then
  exit;

if tcs[1]=BLANK then
  cx :=1;

 psMin :=0;
 psSec :=0;

 //Finn posisjon der minutt og sekund ligger
 for cx :=1 to len do
 begin

  if (not IsCharAlphaNumeric(tcs[cx])) AND
      (tcs[cx]<>BLANK) AND
      (tcs[cx]<>PLUS_) AND
      (tcs[cx]<>MINUS_) then
  begin
   if (psMin=0) then
    psMin :=cx
   else
    psSec :=cx;

   end;

 end;

 //Fjern sekunder f.eks. 09:23:18 blir 09:23
 if psSec>psMin then
  len :=psSec-1;


 timeStr :=copy(tcs,1,len);

 Result :=trim(timeStr);
end;


function TunitFrm.FramesTo_TC(frms: Integer; showFrames: Boolean): String;
var
 str: String;
 dif,dif2,dif3,hr,min,sec,frs,fs: Integer;
begin


//TC_NULL ='00:00:00:00';
//TC_NULL_HMS ='00:00:00';

if frms<=0 then
begin
 if showFrames then
  str :=TC_NULL
 else
  str :=TC_NULL_HMS;

  Result :=str;
  exit;

end;


 dif :=frms mod ((60*60)*25);  //timer
 hr :=trunc((frms-dif)/((60*60)*25));

 dif2 :=frms mod ((60)*25);  //minutter
 min :=trunc((dif-dif2)/((60)*25));

 dif3 :=frms mod (25);  //sekunder
 sec :=trunc((dif2-dif3)/(25));

 frs :=dif3; //frames


 if showFrames then
  str :=format('%2d%s%2d%s%2d%s%2d',[hr,TC_SEP,min,TC_SEP,sec,TC_SEP,frs])
 else
  str :=format('%2d%s%2d%s%2d',[hr,TC_SEP,min,TC_SEP,sec]);

 str :=strReplace(Pchar(str),BLANK,NULLDIGIT);

 Result :=str;
end;

function TunitFrm.TC_toLen(tcs: String): String;
var
 hr,min,sec: Integer;
 str,t_c: String;
begin

 str :=tcs;
 Result :=str;

 if (length(trim(tcs))<8) then
  exit;


  if length(tcs)>=TC_LEN_F then
   t_c :=format_TC(tcs,TRUE)
  else
   t_c :=format_TC(tcs,FALSE);


   hr :=atoi(copy(t_c,1,2));
   min :=atoi(copy(t_c,4,2));
   sec :=atoi(copy(t_c,7,2));
   //Ikke ta med frames her

   //Vis tid som minutter og sekunder

  if (round(hr*60)+min)>=100 then
   str :=format('%2d.%2d.%2d',[hr,min,sec])
  else
   str :=format('%d.%2d',[round((hr*60)+min),sec]);



   str :=strReplace(Pchar(str),BLANK,NULLDIGIT);

  Result :=str;
end;


function TunitFrm.TC_toFrames(tcs: String): Integer;
var
 str,t_c: String;
 hr,min,sec,frs: Integer;
 frms,len: Integer;
begin
 frms :=0;
 Result :=frms;

 if trim(tcs)=NUL then
  exit;

  if length(tcs)>=TC_LEN_F then
   t_c :=format_TC(tcs,TRUE)
  else
   t_c :=format_TC(tcs,FALSE);


 //12345678       123456789
 //00.00.00 eller 00.00.00.00

 hr :=atoi(copy(t_c,1,2));
 min :=atoi(copy(t_c,4,2));
 sec :=atoi(copy(t_c,7,2));

 if length(t_c)=TC_LEN_F then
  frs :=atoi(copy(t_c,10,2))
 else
  frs :=0;

 frms :=round(frs+(sec*25)+((min*60)*25)+(((hr*60)*60)*25));

 //str :=framesToTC(frms,TRUE);

 Result :=frms;
end;


function TunitFrm.TC_lenToExitStr(tc_in,tc_len: STring; showAsTC: Boolean): String;
var
 tcin,tcout,tcdur,hr,min,sec,frms: Integer;
 str,tcs,t_cin,t_cout,t_len: String;
begin
 str :=NUL;
 Result :=str;

 if (tc_in=NUL) OR (tc_len=NUL) then
  exit;

  if length(tc_in)>=TC_LEN_F then
   t_cin :=format_TC(tc_in,TRUE)
  else
   t_cin :=format_TC(tc_in,FALSE);

  if length(tc_len)>=TC_LEN_F then
   t_len :=format_TC(tc_len,TRUE)
  else
   t_len :=format_TC(tc_len,FALSE);


  tcin :=TC_toFrames(t_cin);
  tcdur :=TC_toFrames(t_len);

  tcout :=tcin+tcdur;

  tcs :=framesTo_TC(tcout,FALSE);

  if not showAsTC then
   str :=format_TC(tcs,FALSE)
  else
   str :=tcs;

 Result :=str;
end;


function TunitFrm.TC_lenToStr(tc_in,tc_out: STring; showAsTC: Boolean): String;
var
 tcin,tcout,tcdur,hr,min,sec,frms: Integer;
 str,tcs,t_cin,t_cout: String;
begin
 str :=NUL;
 Result :=str;

 if (tc_in=NUL) OR (tc_out=NUL) then
  exit;

  if length(tc_in)>=TC_LEN_F then
   t_cin :=format_TC(tc_in,TRUE)
  else
   t_cin :=format_TC(tc_in,FALSE);

  if length(tc_out)>=TC_LEN_F then
   t_cout :=format_TC(tc_out,TRUE)
  else
   t_cout :=format_TC(tc_out,FALSE);


  tcin :=TC_toFrames(t_cin);
  tcout :=TC_toFrames(t_cout);

  tcdur :=tcout-tcin;

  tcs :=framesTo_TC(tcdur,FALSE);

  if not showAsTC then
   str :=TC_toLen(tcs)
  else
   str :=tcs;

 Result :=str;
end;

function TunitFrm.TC_add_frames(tcs: String; frms: Integer): String;
var
 str: String;
 frs: Integer;
begin

 str :=tcs;
 Result :=str;

 if trim(tcs)=NUL then
  exit;

  frs :=TC_toFrames(tcs);

  frs :=frs+frms;

  if frs<0 then
   frs :=0;

  str :=unitFrm.framesTo_TC(frs,TRUE);


 Result :=str;
end;

function TunitFrm.TC_add(tc1,tc2: String; typ: Integer): String;
var
 tcin,tcout,tcdur,hr,min,sec,frms: Integer;
 str,tcs,t_cin,t_cout: String;
begin
 str :=NUL;
 Result :=str;

 if (tc1=NUL) OR (tc2=NUL) then
  exit;

  if length(tc1)>=TC_LEN_F then
   t_cin :=format_TC(tc1,TRUE)
  else
   t_cin :=format_TC(tc1,FALSE);

  if length(tc2)>=TC_LEN_F then
   t_cout :=format_TC(tc2,TRUE)
  else
   t_cout :=format_TC(tc2,FALSE);


  tcin :=TC_toFrames(t_cin);
  tcout :=TC_toFrames(t_cout);

  if typ=ADD_PLUS_ then
   tcdur :=tcin+tcout
  else
  if typ=ADD_MINUS_ then
   tcdur :=tcin-tcout
  else
   tcdur :=0; 


  tcs :=framesTo_TC(tcdur,FALSE);

 Result :=tcs;
end;



function TunitFrm.strTimeToTC(stm: String): TdateTime;
var
 timeStr: String;
begin

 if (trim(stm)=NUL) OR
    (trim(stm)=NULLDIGIT) then
 begin
  Result :=0;
  exit;
 end;


 //timeStr :=getTimeStr(stm);

 splitTime(stm);

 Result :=encodeTime(hr,mins,sec,msec);

end;


function TunitFrm.TCtoStrTime(tc: TdateTime): String;
var
 i: Integer;
 sHrs,sMins:String;
begin
 //

 //decodeTime(tc,hr,mins,sec,msec);
 for i :=1 to 4 do
 begin
   strHr[i] :=#0;
   strMins[i] :=#0;
 end;

 tmpTc :=dtmtimeToStr(tc);

 try
  sec :=strToInt(copy(tmpTc,7,2));
 except
  sec :=0;
 end;

 sHrs :=copy(tmpTc,1,2);
 sMins :=copy(tmpTc,4,2);

 sMins :=IntToStr(round(sec/60)+strToInt(sMins));

 tmpTc :=format('%s.%s',[sHrs,sMins]);
 Result :=tmpTc;
end;


function TunitFrm.TCtoStrTimeTC(tc: TdateTime): String;
var
 i: Integer;
 sHrs,sMins,sSec:String;
begin
 //

 //decodeTime(tc,hr,mins,sec,msec);
 for i :=1 to 4 do
 begin
   strHr[i] :=#0;
   strMins[i] :=#0;
   strSec[i] :=#0;
 end;

 tmpTc :=dtmtimeToStr(tc);

 try
  sec :=strToInt(copy(tmpTc,7,2));
 except
  sec :=0;
 end;

 sHrs :=copy(tmpTc,1,2);
 sMins :=copy(tmpTc,4,2);
 sSec :=copy(tmpTc,7,2);

 //sMins :=IntToStr(round(sec/60)+strToInt(sMins));

 tmpTc :=format('%s:%s:%s',[sHrs,sMins,sSec]);

 Result :=tmpTc;
end;



function TunitFrm.secToStrTime(secs: Integer; leadZeros: Integer): String;
begin

 //OBS: Sett lokal 'mins' variabel
 sec :=secs;
 mins :=0;

 while (sec>=60) do
 begin
  sec :=sec-60;
  inc(mins);

 end;


  tmptc:=format('%*.*d.%2.2d',
    [leadZeros,leadZeros,mins,sec]);

 Result :=tmpTc;
end;


function TunitFrm.minToStrTime(min: Integer; leadZeros: Integer): String;
begin

 hr :=0;

 //OBS: Sett lokal 'mins' variabel
 mins :=min;
 signflag :=NUL;

 if mins>=DAY_MIN_LEN then
  hr :=0;

if mins<0 then
begin
 mins:=mins*(-1);
 signflag :='-';
end;

 while (mins>=60) do
 begin
  mins :=mins-60;
  inc(hr);

 end;

 if (hr=0) AND (mins=0) then
  tmpTc :=NUL
 else
 begin
//  tmptc:=format('%s%*d.%02d',[signflag,leadZeros,hr,mins]);
 try

 if leadZeros=0 then
  tmptc:=format('%s%d',[signflag,hr])
 else
  tmptc:=format('%s%*.*d.%2.2d',
    [signflag,leadZeros,leadZeros,hr,mins]);

 except
  //tmpTc :=NUL;
 end;

  //tmpTc :=strReplace(Pchar(tmpTc),BLANK,NULLDIGIT);
 end;

 Result :=tmpTc;
end;



function TunitFrm.strMinToStrTime(smin: String; leadZeros: Integer): String;
begin

hr :=0;
mins :=0;

if smin <> NUL then
begin

if (smin=TIME_235959) OR (smin=TIME_235959_DOT) then
begin
 Result :=copy(TIME_24_DOT,1,TIME_FLD_LEN);
 exit;
end;


 hr :=0;
try
 mins :=strToInt(smin);
except
 Result :=NULLTIME;
 exit;
end;


signflag :=NUL;

if mins<0 then
begin
 mins:=mins*(-1);
 signflag :='-';
end;


while (mins >=60) do
begin
  mins :=mins-60;
  inc(hr)
end;

end;


if (hr=0) AND (mins=0) then
 tmpTc :=NUL
else
begin
 //tmpTc :=format('%s%*d.%2.2d',[signflag,leadZeros,hr,mins]);

 if leadZeros<0 then
  leadZeros :=0;

 try
 tmpTc :=format('%s%*.*d.%2.2d',
   [signflag,leadZeros,leadZeros,hr,mins]);
 except
  signFlag :=NUL;
  //tmpTc :=NUL;
 end;

 //tmpTc :=strReplace(Pchar(tmpTc),BLANK,NULLDIGIT);

 //tmpTc :=format('%s%*.*d.%2.2d',
 //  [signflag,leadZeros,leadZeros,hr,mins]);

end;

 Result :=tmpTc;
end;



function TunitFrm.strTimeToMin(stm: String): Integer;
var
 timeStr: String;
begin

 if (trim(stm)=NUL) OR
    (trim(stm)=NULLDIGIT) then
 begin
  Result :=0;
  exit;
 end;

if (stm=TIME_235959) OR (stm=TIME_235959_DOT) then
begin
 Result :=DAY_MIN_LEN;
 exit;
end;


 //timeStr :=getTimeStr(stm); //copy(stm,1,len);


  splitTime(stm);

 if signflag ='-' then
  Result :=((hr*60)+mins)*(-1)
 else
  Result :=((hr*60)+mins);

end;


function TunitFrm.strTimeToStrMin(stm: String): String;
var
 timeStr,str: String;
begin
 str :=NUL;

 if (trim(stm)=NUL) OR
    (trim(stm)=NULLDIGIT) then
 begin
  Result :=str;
  exit;
 end;

if (stm=TIME_235959) OR (stm=TIME_235959_DOT) then
begin
 Result :=copy(TIME_24_DOT,1,TIME_FLD_LEN);
 exit;
end;


 //Fjern sekunder f.eks. 09:23:18 blir 09:23
 //timeStr :=getTimeStr(stm); //copy(stm,1,TIME_FLD_LEN);


 splitTime(stm);

 tmpTc:=signflag+IntTostr((hr*60)+mins);
 Result :=tmpTc;
end;


function TunitFrm.strMinToStrTCount(stm: String): String;
begin

beep;

end;


procedure TunitFrm.splitTime(stm: String);
var
 timeStr: STring;
 i,j,stat,len: Word;
begin

//Fjern sekunder f.eks. 09:23:18 blir 09:23

 timeStr :=getTimeStr(stm); //copy(stm,1,len);

 len :=length(timeStr);

 j:=1;
 stat :=0;

 hr :=0;
 mins :=0;
 sec :=0;
 msec :=0;
 signflag :=NUL;

 for i :=1 to 6 do
 begin
   strHr[i] :=#0;
   strMins[i] :=#0;
 end;


 for i:=1 to (len) do
 begin

 //Er dette negativ tid ?
  if (timeStr[i] = '-') then
  begin
   signflag :='-';
   continue;
  end;


 if stat = 0 then
 begin

  if (timeStr[i]<>',') AND
     (timeStr[i]<>'.') AND
     (timeStr[i]<>':') then
  begin
   strHr[j] :=timeStr[i];
   inc(j);
  end
  else
  begin
   stat :=i;
   j :=1;
  end;

  end
  else
  begin
   strMins[j] :=timeStr[i];
   inc(j);
  end;

 end;

 try
  hr :=StrToInt(strHr);
 except
  hr :=0;
 end;

 try
  mins :=StrToInt(strMins);
 except
  mins :=0;
 end;


end;



function TunitFrm.minToStrFloat(min: Integer): String;
var
 sep: Char;
 rndi: Integer;
 rndf: Real;
begin

 hr :=0;
 mins :=min;
 signflag :=NUL;

 sep :=typFrm.numberSep;

if mins<0 then
begin
 mins:=mins*(-1);
 signflag :='-';
end;

 while (mins>=60) do
 begin
  mins :=mins-60;
  inc(hr);
 end;

 if (hr=0) AND (mins=0) then
  tmpTc :=NUL
 else
 begin
  rndf :=(mins*10)/60;

  //pgr bug med avrunding til neste hele time (og ikke f.eks. 14,1)
  if rndf>=9.5 then
  begin
   inc(hr);
   rndi :=0;
  end
  else
   rndi :=round(rndf);


  tmptc:=format('%s%d%s%d',
   [signflag,
    hr,
    sep,
    rndi]);
  //tmpTc :=strReplace(Pchar(tmpTc),BLANK,NULLDIGIT);
 end;

 Result :=tmpTc;
end;


function TunitFrm.strFloatToMin(stf: String): Integer;
begin

 splitTime(stf);


 //OBS: minuttdel er nå tiendeler av time f.eks 37,5 t
 mins :=round((mins/10)*60);

 Result :=((hr*60)+mins);
end;

function TunitFrm.getDelimPos(str: String; startPos: Integer): Integer;
var
 stps,ps,len,cx: Integer;
begin

 Result :=0;

 if str=NUL then
  exit;

len :=length(str);

if startPos>len then
 stps :=len
else
if startPos<1 then
 stps :=1
else
 stps :=startPos;


ps :=0;
for cx :=stps to len do
begin
 if (str[cx]=DOT) OR
    (str[cx]=COMMA) OR
    (str[cx]=SEMICOLON) OR
    (str[cx]=COLON) then
 begin
  ps :=cx;
  break;
 end;

end;


  Result :=ps;
end;


function TunitFrm.roundMinToMin(min: Integer; cmd: Integer): Integer;
var
 minStr,hrStr,str: String;
 ps,rndBrk1,rndBrk2: Integer;
 rndSum: Integer;
begin

 hr :=0;
 rndsum :=0;
 mins :=min;
 signflag :=NUL;

 rndBrk1 :=0;
 rndBrk2 :=0;

 rndSum :=min;

 Result :=rndSum;  //Anta dette først

 if cmd=ROUND_ONE then
 begin
  rndBrk1 :=30;  //Kun til hele timer
  rndBrk2 :=30;
 end
 else
 if cmd=ROUND_HALF then
 begin
  rndBrk1 :=15;  //til halve timer
  rndBrk2 :=45;
 end
 else
  exit;    //Udefinert avrundingstype

{ //fjernet 06.03.2002
if mins<0 then
begin
 mins:=mins*(-1);  //For å slippe negative verdier
 signflag :='-';
end;
}

str :=minToStrTime(mins,2);

ps :=getDelimPos(str,1);

//Ta ut timer og minutter
if ps>0 then
begin

 hrStr :=copy(str,1,(ps-1));
 minStr :=copy(str,(ps+1),2);

 hr :=strToIntDef(hrStr,0);
 mins :=strToIntDef(minStr,0);

 if (mins<rndBrk1) then
  mins :=0
 else
 if (mins>=rndBrk1) AND (mins<rndBrk2) then
 begin

  if cmd=ROUND_HALF then
   mins :=30
  else
  begin
   mins :=0;
   inc(hr);
  end;

 end
 else
 if (mins>=rndBrk2) then
 begin
  mins :=0;
  inc(hr);
 end;

 rndsum :=((hr*60)+mins);
end;


{
 while (mins>=60) do
 begin
  mins :=mins-60;
  inc(hr);
 end;

 if (hr=0) AND (mins=0) then
  rndsum :=0
 else
 begin


  if (mins<rndBrk1) then
  begin
   mins:=0
  end
  else
  begin
   mins :=0;
   inc(hr);
  end;

 end;


  rndsum :=((hr*60)+mins);
 end;
 }

 {   //fjernet 06.03.2002
 if signflag ='-' then
  rndsum :=rndsum*(-1);
 }

  Result :=rndsum;
end;


function TunitFrm.makeValidStrTime(str: String): String;
var
 mins: Integer;
 tmp: String;
begin

 mins :=strTimeToMin(str);

   //Trekk fra 24 t ved f.eks 24.06
 if mins >DAY_MIN_LEN then
   mins :=mins-DAY_MIN_LEN;

 tmp :=minToStrTime(mins,2);

 Result :=tmp;
end;

procedure TunitFrm.FormCreate(Sender: TObject);
begin

 pcb.str1 :=StrAlloc(MAX_PCHAR_LEN);
 pcb.str2 :=StrAlloc(MAX_PCHAR_LEN);
 pcb.destStr :=StrAlloc(MAX_PCHAR_LEN);
 pcb.tmpStr :=StrAlloc(MAX_PCHAR_LEN);

 saveBkgColor :=clBlue;
 saveTxtColor :=clWhite;
end;


function TunitFrm.strTimeToStrDays(stm,ref: String): String;
var
 timeStr,str: String;
 minx,refx,refDayMin,dayMin: Integer;
begin

 str :=NUL;

 if (trim(stm)=NUL) OR
    (trim(ref) = NUL) OR
    (trim(stm)=NULLDIGIT) then
 begin
  Result :=str;
  exit;
 end;

//Fjern sekunder f.eks. 09:23:18 blir 09:23
 //timeStr :=copy(stm,1,TIME_FLD_LEN);
 //timeStr :=getTimeStr(stm);

 splitTime(stm);

 minx :=(hr*60)+mins;

 splitTime(ref);

 refx :=(hr*60)+mins;

 refDayMin :=round(refx/5);

 dayMin :=round(minx/refDayMin);

 tmpTc:=signflag+IntTostr(dayMin);

 Result :=tmpTc;
end;

//********************************************************

function  TunitFrm.stripChars(src: String; ch: Char): String;
var
 i,j,len: Integer;
 tmp: String;
begin

 tmp :=NUL;
 Result :=tmp;

 if src=NUL then
  exit;

 //tmp :=unitFrm.strReplace(PChar(value),BLANK,NULLDIGIT);
 tmp :=BLANK;

  //pgr memory allokering
 tmp :=format('%'+IntToStr(MAX_PCHAR_LEN)+'s',[tmp]);

 j:=0;
 len :=length(src);

 for i:=1 to len do
 begin

  if (src[i] <> ch) then
  begin
   inc(j);
   tmp[j] :=src[i];
  end;

 end;

 len :=length(trim(tmp));
 setLength(tmp,len);

 Result :=tmp;
end;


function  TunitFrm.charReplace(src: String; key,fill: Char): String;
var
 i,j,len: Integer;
 tmp: String;
begin

 tmp :=NUL;
 Result :=tmp;

 if src=NUL then
  exit;

 //tmp :=unitFrm.strReplace(PChar(value),BLANK,NULLDIGIT);
 tmp :=src;

  //pgr memory allokering
 //tmp :=format('%'+IntToStr(MAX_PCHAR_LEN)+'s',[tmp]);

 j:=0;
 len :=length(src);

 for i:=1 to len do
 begin

  if (tmp[i] = key) then
  begin
   inc(j);
   tmp[i] :=fill;
  end;

 end;

 //len :=length(trim(tmp));
 //setLength(tmp,len);

 Result :=tmp;
end;


//********************************************************

function  TunitFrm.stripBlanks(src: String): String;
var
 i,j,len: Integer;
 tmp: String;
begin

 tmp :=NUL;
 Result :=tmp;

 if src=NUL then
  exit;

 //tmp :=unitFrm.strReplace(PChar(value),BLANK,NULLDIGIT);
 tmp :=BLANK;

 j:=0;
 len :=length(src);

   //pgr memory allokering
 tmp :=format('%*s',[(len+2),tmp]);

 for i:=1 to len do
 begin
  if (ord(src[i]) <> BLANK_ORD) AND
     (src[i] <> BLANK) then
  begin
   inc(j);
   tmp[j] :=src[i];
  end;

 end;

 len :=length(trim(tmp));

 setLength(tmp,len);

 Result :=tmp;
end;


function TunitFrm.isWildCardInStr(str: String): Boolean;
begin
 Result :=FALSE;
{
 Result :=0;

 if trim(str) =NUL then
 begin
  Result :=1;
  exit;
 end;
}

 if (pos('*',str)>0) OR
    (pos('?',str)>0) OR
    (pos('%',str)>0) OR
    (pos('_',str)>0) then
 begin
  //Result :=2;
  Result :=TRUE;
 end;


end;




function TunitFrm.removeWildCards(str: String): String;
var
 outstr: String;
 len,i,j: Integer;
begin

 outstr :=str;
 Result :=outstr;

 len :=length(trim(str));
 if len=0 then
  exit;

 j :=0;
 for i :=1 to len do
 begin

  if (str[i]<>'*') AND
     (str[i]<>'?') AND
     (str[i]<>'%') AND
     (str[i]<>'*') then
   begin
     inc(j);
     outstr[j] :=str[i];
   end;

 end;

 setLength(outstr,j);


 Result :=outstr;
end;


function TunitFrm.convertQuotes(str: String): String;
var
 outstr: String;
 len,i,j,ps,nx,ofs: Integer;
begin

 outstr :=str;
 Result :=outstr;


 len :=length(trim(str));
 if len=0 then
  exit;

 for i :=1 to len do
  outstr[i] :=BLANK;


 //erstatt to enkeltfnutter med dobbeltfnutt
 j :=0;
 ps :=0;
 ofs :=0;

 for i :=1 to len do
 begin

  if ofs>0 then
  begin
   ofs :=0;
   inc(j);
   continue; //fordi to fnutter er ersattet av en dobbeltfnutt
  end;

  if i<len then
   nx :=1
  else
   nx :=0;

  if (nx>0) AND
     ((str[i]='''') AND (str[i+nx]='''')) then
   begin
     inc(j);
     outstr[j] :='"';

     inc(ofs); //neste loop runde går forbi

     inc(ps);
   end
   else
   begin

    if ps=0 then
    begin
     inc(j);
     outstr[j] :=str[i];
    end
    else
     ps :=0;

   end;


 end;

 //setLength(outstr,j);


 Result :=trim(outstr);
end;



function TunitFrm.removeQuotes(str: String): String;
var
 outstr: String;
 len,i,j: Integer;
begin

 outstr :=str;
 Result :=outstr;

 len :=length(trim(str));
 if len=0 then
  exit;

 j :=0;
 for i :=1 to len do
 begin

  if (str[i]<>'''') AND
     (str[i]<>'"') then
   begin
     inc(j);
     outstr[j] :=str[i];
   end;

 end;

 setLength(outstr,j);


 Result :=outstr;
end;


function TunitFrm.dateStrToPBdate(dat: String): STring;
var
 str: String;
 dtm: TdateTime;
begin
 str :=dat;

 try
  str := FormatDateTime('yyyy-mm-dd', strToDate(dat));
 except
  //
 end; 

 Result :=str;
end;


function TunitFrm.convertFormulaDate(dat: String): String;
var
 str,dd,mm,yy: String;
 i: Integer;
begin


//Datoer fra formula er yymmdd.
//Konverter til dd.mm.yy

 yy := copy(dat,1,2);
 mm := copy(dat,3,2);
 dd := copy(dat,5,2);

 str :=format('%s.%s.%s',[dd,mm,yy]);

 if pos('?',str)>0 then
 begin
  for i:=1 to length(str) do
  begin
   if str[i]='?' then
    str[i] :=NULLDIGIT;

  end;
 end;


 Result :=str;
end;


function TunitFrm.minToFormulaStrMin(min: Integer; rndTyp: Integer): string;
var
 strOutVal,strInVal: String;
begin

 strOutVal :=NULLCOUNT;
 Result :=strOutVal;

 if min=0 then
  exit;


 if rndTyp=0 then
  strInVal :=unitFrm.minToStrTime(min,1)
 else
 begin
  strInval :=unitFrm.minToDeciStr(min,DOT);
 end;

 strOutVal :=formatFormulaValue(strInVal);



 Result :=strOutVal;
end;


function TunitFrm.formatFormulaValue(strMin: String): String;
var
 strOutVal: String;
begin

 strOutVal :=NULLCOUNT;
 Result :=strOutVal;

 if strMin=NUL then
  exit;

  // f.ekl. 6.00 blir 0600

 //OBS: Negative verdier skal egnentlig benevnes med minus bak f.eks. 1250-
 //Men av hensyn til bakoverkompabilitet er fortegn i eget felt
 //Derfor er ikke dett tatt hensyn til her
 strOutVal :=unitFrm.strReplace(Pchar(strMin),BLANK,NULLDIGIT);

 strOutVal :=format('%4s',[unitFrm.stripChars(strOutVal,DOT)]);
 //strOutVal :=unitFrm.strReplace(Pchar(strOutVal),BLANK,NULLDIGIT);

 Result :=strOutVal;
end;



{
function TunitFrm.checkMidNightPass(t1,t2:Integer): Integer;
begin

  if (t2>=DAY_MIN_LEN) then
  begin
   t2 :=t2-DAY_MIN_LEN;
   Result :=t2;
   exit;
  end;

    //Sjekk midnatt for t2 i forhold til t1
    //Returner modifisert t2     //09.00
  if((t2<t1) AND ((t2>0) AND (t2<DAY_BREAK))) then
   Result :=(t2+DAY_MIN_LEN)
  else
   Result :=t2;

end;


function TunitFrm.TimeLen(t1,t2: Integer): Integer;
begin

//Sjekk midnatt
if (t2<t1) AND ((t2>0) AND (t2<DAY_BREAK)) then
 Result :=(t2+DAY_MIN_LEN)-t1
else
 Result :=t2-t1;

end;
}




function TunitFrm.calcFrameTime(mediaLen: Real): Real;
var
 ftm: Real;
 frms: Integer;
begin

 ftm :=0;
 Result :=ftm;
 if mediaLen <=0 then
  Exit;

 //frms :=deciTimeToFrames(mediaLen);

 ftm :=(mediaLen/VIDEO_FRAME_RATE);


 Result :=ftm;
end;

initialization
  unitFrm :=TunitFrm.create(unitFrm);
  if unitFrm =nil then
   halt;

end.
