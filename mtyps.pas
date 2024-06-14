unit mtyps;

interface

uses

 {$IFNDEF SIGN}
  //Ole2,
 {$ENDIF}

 {$IFNDEF DVC}

  DB,
 // BDE,
  DBTables,
  DBGrids,

  //InfoPower
 {
  Wwtable,
  wwdatsrc,
  Wwdbigrd,
  Wwdbgrid,
 }
 // VCFrmla1,

 {$ENDIF}

  menus,
  stdCtrls,
  printers,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  ComCtrls,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  Grids,
  CommCtrl;
type

 //driveLetters = array [1..32] of Char;

 driveLetters = array  [0..32] of Char;

  SizeInt = Integer;
  // string types
  TUTF8String = AnsiString;
  TUTF16String = WideString;
  TUCS2String = WideString;

  PUTF7 = ^UTF7;
  UTF7 = Char;
  PUTF8 = ^UTF8;
  UTF8 = Char;
  PUTF16 = ^UTF16;
  UTF16 = WideChar;
  PUTF32 = ^UTF32;
  UTF32 = Cardinal;

  // UTF conversion schemes (UCS) data types
  PUCS4 = ^UCS4;
  UCS4 = Cardinal;
  PUCS2 = PWideChar;
  UCS2 = WideChar;


 //Data for lokalisering av nrkxfrm.DB
{
 xtblLocData = record
  //db: TdataBase;
  path: String;
  dbAlias: String;
  dbPath: String;
  tblName: String;
  dep: String;
  id: Integer;
 end;
}

// driveLetters = (_,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z);

 btnColors = record

   Active: TColor;
   Busy: Tcolor;
   Inactive: Tcolor;
   Rec: Tcolor;
  end;


  TtypFrm = class(TForm)
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
//    procedure localeTimerTimer(Sender: TObject);
  private
    { Private declarations }
   triggFlag: Integer;   //Settes til ONX for å forhindre uønsket event-trigg
   recInhibitFlag: Integer; //Settes ti ONX når record ikke må lagres
  public
    { Public declarations }

   msgRet: Integer;     //Resultat fra messageProcess
   btnCol: btnColors;
   tmp: String;
   drives: driveLetters;
   //xtblLoc: xtblLocData;
   numberSep: Char;   //Decimal-separator fra BDE setting
   userMode: Integer; //Tilgangsrettigheter
   operation: Integer; //Aktuell operasjon
   progrVer: String;   //Program versjon
   inhibit_db: Boolean;  //Forhindrer alle databaseoperasjoner

   procedure setProgramVersion(prgver: String);

   function  triggInhibit(cmd: Integer): Integer;
   function  recInhibit(cmd: Integer): Integer;
   procedure drawRect(canv: Tcanvas;x,y,w,h: Integer; width: Integer;color: Tcolor);
   procedure setCursorState(cmd: Integer);
   function  setLocaleFormats(fmt: String): String;
   function  refreshLocaleFormats: Boolean;

  end;

const


 //Program versjoner
 //X98_VER ='12.29.09.04';
 //XP_VER ='7.01.10.04';
 //PL2_VER ='12.18.10.04b';
 //ROAD_VER ='12.07.04.04';

 ALL_ACCESS_USER ='mar';

 MAC_DBOWNER ='NRKLIVE';
 X_DBOWNER ='XNRK';
 POB_DBOWNER ='WENDIA';
 USER_PROFILE_TBL =X_DBOWNER+'.X_USER_PROFILES';

 MAC_EXP_ERR_FILE ='exp_errs.txt';

 BMP_EXTENSION ='BMP';
 RTF_EXTENSION ='RTF';
 PDF_EXTENSION ='PDF';
 JPG_EXTENSION ='JPG';

 DB_EXTENSION ='DB';

 KOLON =':';

 PRIVATE_DRIVE ='L';
 X98_LOCAL_PATH ='C:\XNRK';

 LOCALHOST ='localhost';

 //FRAMES_PR_SEC =25;

 //System typer
 FILE_DB =(-1);
 X98_DB =1;
 XY_DB =2;
 MAC_DB =3;
 FM_DB  =4;
 PRINS_DB =5;
 ROAD_DB =6;
 POB_DB =7;

 HalfShift: Integer = 10;
 HalfBase: UCS4 = $0010000;
 HalfMask: UCS4 = $3FF;

 FNUL = #13#10;   //#$D#$A;
 CRLF = #$D#$A;
 LFLF = #$A#$A;
 CRCR = #$D#$D;

 HEX_PREFIX      = '$';
 FILE_SUFFIX ='$';


//encoded in UTF-8, which is what the web service is expecting.
//So, for example the Unicode char "å" is represented as "C3 A5" in Hex
//("Ã¥" being the Latin1 interpretation).  

 AA_LO_8 =#$C3#$A5;

 AE_LO ='&#230;'; //æ
 AE_HI ='&#198;'; //Æ
 OE_LO ='&#248;'; //ø
 OE_HI ='&#216;'; //Ø
 AA_LO ='&#229;'; //å
 AA_HI ='&#197;'; //Å


 //ä, ö, ü, é
 A_LO ='&#228;'; //ä
 A_HI ='&#196;'; //Ä
 O_LO ='&#246;'; //ö
 O_HI ='&#214;'; //Ö
 U_LO  ='&#252;'; //ü
 U_HI  ='&#220;'; //Ü
 E_LO  ='&#233;'; //é
 E_HI  ='&#201;'; //É

 //samisk tegn
 AS_LO ='&#225;'; //á
 AS_HI ='&#193;'; //Á


 NOR_HEX =#$c3;
 HEX_AA_HI =#$85;
 HEX_OE_HI =#$98;
 HEX_AE_HI =#$86;


 XML_LF ='&#10&#13';

 AMP_CODE ='&amp;';
 AMP_CHAR ='&';

 LT_CODE ='&lt;';
 LT_CHAR ='<';

 GT_CODE ='&gt;';
 GT_CHAR ='>';


 SYS_MSG_ ='Kontakt systemansvarlig';
 HTTP_REF ='http://torget/x98/index.htm';

 DELPHI_TABLE = 'TTable';
 IP_TABLE = 'TwwTable';
 DELPHI_QUERY = 'TQuery';
 IP_QUERY = 'TwwQuery';

 DELPHI_GRID = 'TDBGrid';
 IP_GRID = 'TwwDBGrid';
 IP_GRID_COL_SCALE = 5;

 SEQ_RANGE_TBL ='XSEQ';
 TXT_EXTENSION ='TXT';

 CONFIRM_STR_ ='Sikker på';
 NULL_LIST_ ='Liste er blank';
 NULL_SORTS_ ='0 Sortering i Personell';

 NO_ACCESS_ ='Ingen tilgang';
 NO_ACTIVATE_ =' kan ikke aktiveres';
 NO_CALC_ ='Feil ved beregning';
 NO_CREATE_ ='Kan ikke opprette';
 NO_DEF_ ='Udefinert';
 NO_GENERATE_ ='Feil ved generering';
 NO_LOAD_ ='Feil ved innlasting';
 NO_MATCH_ ='Finner ikke';
 NO_MATCH_TXT_ ='Ingen funnet';
 NO_OPEN_ ='Kan ikke åpne';
 NO_UPDATE_ ='Feil ved oppdatering';
 NO_SAVE_ ='Feil ved registrering';
 NO_SORT_ ='Feil ved sortering';
 NO_RECS_ ='Ingen records';

 NOT_AVAIL_ =' er ikke tilgjengelig';
 NOT_DEF_ =' er ikke definert';
 NOT_VALID_ ='Ugyldig';

 NO_DBCONNECT_ ='Ingen forbindelse til database';
 NO_DBNAME_ ='Tabell/database-navn mangler';
 NO_DBOPEN_ ='Kan ikke åpne';
 NO_MODULE_ ='Uspesifisert modul';

 NO_NORCHARS_ ='kan ikke inneholde særnorske tegn';

 NO_PRIV_ ='Manglende tilgangs-rettighet';
 NO_WRITE_PRIV_ ='Ingen skrivetilgang';
 NO_DELETE_PRIV_ ='Ingen slettetilgang';

 NULL_LOAD_ ='Ingen data er lastet inn';
 NULL_XFER_ ='Ingen records å overføre';

 BAD_DATE_ ='Ugyldig dato';
 BAD_DATE_RANGE_ ='TilDato kan ikke være lavere enn FraDato';
 BAD_DATETIME_RANGE_ ='Til-dato/tid kan ikke være lavere enn Fra-dato/tid';
 BAD_TIME_ ='Feil syntaks eller ugyldig tid';
 BAD_XFER_ ='Feil dataoverføring';

 NO_TO_DATE_ ='TilDato er ikke utfylt';
 NO_FROM_DATE_ ='FraDato er ikke utfylt';
 NO_PERIOD_    ='Periode ikke spesifisert';

 DATA_MISS_ ='Ugyldig eller manglende ';

 REC_OK_MSG_ ='Denne record har status "Godkjent" '+FNUL+
              'og kan derfor ikke endres';

 REC_RESERVED_ ='Reservert kode kan ikke slettes';
 REC_EXIST_     ='finnes fra før';
 IT_EXISTS_     ='Det eksisterer';

 VKSPACE_NARROW_ ='Det er for liten avstand mellom vakter';

 ENTER_REQ_ =' må fylles ut';
 SAVE_ANYWAY_ ='Lagre likevel ?';
 UPDATE_ANYWAY_ ='Vil du oppdatere likevel ?';

 ACT_REQ_ ='Aktivitet'+ENTER_REQ_;
 ANS_REQ_ ='Ansatt-Nr'+ENTER_REQ_;
 CODE_REQ_ ='Kode'+ENTER_REQ_;
 DATE_REQ_ ='Dato'+ENTER_REQ_;
 DEP_REQ_ ='Avdeling'+ENTER_REQ_;
 FUNK_REQ_ ='Funksjon'+ENTER_REQ_;
 GRP_REQ_ ='Gruppe'+ENTER_REQ_;
 NAME_REQ_ ='Navn'+ENTER_REQ_;
 SIGN_REQ_ ='Signatur'+ENTER_REQ_;
 TURN_REQ_ ='Turnusnavn'+ENTER_REQ_;
 PRODNR_REQ_ ='ProdNr'+ENTER_REQ_;
 PRODUCT_REQ_ ='Produkt-Nr'+ENTER_REQ_;
 VK_REQ_ ='Vaktkode'+ENTER_REQ_;

// NO_BOOK_REQUEST_OVERWRITE_ ='Ubekreftet bestilling kan ikke overskrives';
// NO_BOOK_NEW_OVERWRITE_ ='Nye bookinger kan ikke overlappe på samme linje';
// BOOK_PERIOD_EXCEED_ ='Periode ligger utenfor visningsområdet.'+FNUL+
//                      'Dobbelklikk for endring via skjermbilde.';

// NEW_LOAD_ ='Utvalgskriteria er endret. Last inn påny ?';

// PRINS_NOT_AVAIL_ ='PRiNS-data er ikke tilgjengelig i denne versjonen.';

 //REVERT_VK_ ='Disse må først settes tilbake til originalvakter.';

 //PIF_NO_UPD ='Oppdatering av PiF transaksjon er avbrutt';

 XYTECH ='Xytech';
 XY_OWNER ='PIF';
 PIF_NAME ='PiF';
 //PRINS_NAME ='PRiNS';

 VIDEO ='Video';
 AUDIO ='Lyd';
 IMAGE_ ='Bilde';
 AUDIO_ ='Audio';

 STREAM_AUDIO ='audio';
 STREAM_VIDEO ='video';

 PROXY_FILE =1;
 STREAM_FILE =2;


 ASPECT_16_9 =169;
 ASPECT_4_3 =43;


 AUDIO_RATE_FACTOR =40;
 VIDEO_RATE_FACTOR =3600;
 VIDEO_FRAME_RATE =25;
 MZ_FRAME_RATE =24.45;

 AVI_VIDEO ='AVI';
 MPG_VIDEO ='MPG';
 MP4_VIDEO ='MP4';

 MPEG_VIDEO ='MPEG';
 WMV_VIDEO ='WMV';
 WMF_VIDEO ='WMF';

 IMG_BMP ='BMP';
 IMG_JPG ='JPG';
 IMG_TIF ='TIF';
 IMG_GIF ='GIF';
 IMG_WMF ='WMF';

 FLASH_SWF ='SWF';

 MOV_VIDEO ='MOV';
 QT_VIDEO ='QT';

 WAV_AUDIO ='WAV';
 WMA_AUDIO ='WMA';
 MP3_AUDIO ='MP3';
 MIDI_AUDIO ='MIDI';
 AIFF_AUDIO ='AIFF';
 AU_AUDIO ='AU';

 JPG_IMG ='JPG';
 TIF_IMG ='TIF';
 BMP_IMG ='BMP';
 GIF_IMG ='GIF';
 PNG_IMG ='PNG';
 WMF_IMG ='WMF';

 UNDF_CODEC_ ='Ukjent kodingsformat';

 WORD_ ='DOC';
 EXCEL_ ='XLS';
 POWERPOINT_ ='PPT';
 PDF_ ='PDF';


{
 MEDIA_TABLE ='MEDIA.M_MEDIA';
 MEDIA_SERIES ='MEDIA.M_MEDIA_CAT';
 MEDIA_TYPES ='MEDIA.M_MEDIA_TYPE';
 MEDIA_FORMATS ='MEDIA.M_MEDIA_FORMAT';
}


MID_FNAME ='MID';
MID_LINK_FNAME ='MID_LINK';

SIFT_FNAME ='SIFT_ID';
PB_FNAME ='PB_NAME';
PBID_FNAME ='PB_ID';

MODULES_TBL ='M_MODULES';
STAT_FLD ='CLIP_STAT';
RIGTHS_FLD ='RETTIGHET';
PUBLISH_FLD ='PUBLISER';

DUMMY_PRODNR ='XXXX000000';
DUMMY_PRF_PRODNR ='XXXX00000000';

clOrange =$004080FF;

MEDIA_READY_COLOR =clLime;
MEDIA_NOTUSE_COLOR =clRed;
MEDIA_STREAMED_COLOR =clTeal;
MEDIA_CONDITIONAL_COLOR =clOrange;
MEDIA_PB_COLOR =clAqua;
MEDIA_ON_HOLD_COLOR =clSilver;

MERDIA_CONFIRM_COLOR =clPurple;
MERDIA_CONFIRMED_COLOR =clMoneyGreen; //clFuchsia;

RIGTHS_NONE ='Ingen';
RIGTHS_ALL ='Fri bruk';
RIGTHS_CHECK ='Sjekk';
RIGTHS_CONDITIONAL ='Begrenset';
RIGTHS_MAYBE ='Kanskje';

MEDIA_PUBLISHED ='Aktiv';
MEDIA_NOT_PUBLISHED ='Inaktiv';
MEDIA_TIME_PUBLISHED ='Klar';
MEDIA_TARNSFERED ='Overført';


MEDIA_READY ='Ferdig';
MEDIA_STREAMED ='Streamet';
MEDIA_CONFIRM ='Til godkjenning';
MEDIA_CONFIRMED ='Godkjent';


MEDIA_NOTUSE ='Ikke bruk';

MEDIA_BLOCKED ='Sperret';

MEDIA_ON_HOLD ='På vent';

INI_FILE_NAME ='mediadb.ini';
GRID_FILE_NAME ='listgrid.ini';

VIDEO_AVI ='AVI';
IDX_NAME ='midIdx';

IMG_AUDIO_IDX =0;
IMG_TAPE_IDX =1;
IMG_VIDEO_UNDF_IDX =12;
IMG_VIDEO_IDX =5;
IMG_PICT_IDX =8;
IMG_WORD_IDX =9;
IMG_EXCEL_IDX =10;
IMG_PPT_IDX =11;
IMG_PDF_IDX =13;


 VK_0 = 48;
 VK_1 = 49;
 VK_2 = 50;
 VK_3 = 51;
 VK_4 = 52;
 VK_5 = 53;
 VK_6 = 54;
 VK_7 = 55;
 VK_8 = 56;
 VK_9 = 57;

 VK_A = 65;
 VK_B = 66;
 VK_C = 67;
 VK_D = 68;
 VK_E = 69;
 VK_F = 70;
 VK_G = 71;
 VK_H = 72;
 VK_I = 73;
 VK_J = 74;
 VK_K = 75;
 VK_L = 76;
 VK_M = 77;
 VK_N = 78;
 VK_O = 79;
 VK_P = 80;
 VK_Q = 81;
 VK_R = 82;
 VK_S = 83;
 VK_T = 84;
 VK_U = 85;
 VK_V = 86;
 VK_W = 87;
 VK_X = 88;
 VK_Y = 89;
 VK_Z = 90;
 VK_AE = 222;  //Æ
 //VK_OE =;  //Å

 VK_BS = 8;    //Backspace
 VK_PIPE = 124;
 VK_ESC =27;

 YES_ ='Y';
 NO_ ='N';

 ONX = 1;
 OFF = 0;
 ERROR_ = -1;
 CANCEL_ = -2;
 WARNING_ = -3;
 OK = 1;

 ZERO_FLOAT =0.00;
 MAX_FLOAT_PRECISION =3;

 MAX_PATH_LEN =254;

 NULLFLOAT =0.01;
 NULLTIME = '00.00';
 NULLCOUNT ='0000';

 MINUSONEDIGIT = '-1';
 NULLDIGIT = '0';
 ONEDIGIT = '1';

 NULLKL ='00:00';
 BLANKTIME ='  .  ';  //Blankt tids-felt
 UNDFTIME ='99.99';

 NUL = '';
 S_NUL = #0;
 PNUL = '\0';
 MNUL = '#13#10';  //Null terminate for memo-felt
// FNUL = #13#10;   //#$D#$A;
 CR_C ='#$D';
 LF_C ='#$A';
 BS_C =#8;

 PIPE = '|';
 TILDE = '~';
 CR = '\r';
 LF = '\n';
 BLANK = ' ';
 BLANK_ORD = 160;   //ord(' ')
 SPACE = #32;
 BACK_SPACE =#08;
 DOT = '.';
 COMMA = ',';
 COLON =':';
 SEMICOLON =';';
 TAB = #09;
 ENTER =#13;
 FLDSEP = ';';
 QUEST ='?';
 STAR ='*';
 BRACK_L = '(';
 BRACK_R = ')';
 INFO_MARK ='!';
 CONCAT ='||';

 
 GREY_PLUS = 107;
 GREY_MINUS = 109;
 MINUS_     ='-';
 PLUS_      ='+';
 EQ_        ='=';

 NA = -3;
 LSLASH = '\';
 RSLASH ='/';
 
 NR = '#';
 ID = '&';
 AT = '@';
 SELECT_MARK = '>';
 PAGE_BREAK_ID ='>';
 MARK = 'X';
 WILD_CHAR = '_';     //Wild-card for erstattning av enkelt tegn

 XON = 'X';
 ZON = 'Z';

 GENERIC_PREFIX ='_';

 FILE_NAME_SEP ='_';

 LEFT_CONT ='<';
 RIGHT_CONT ='>';
 BOTH_CONT ='<>';
 
 REMARK_PREFIX =':';

 MAX_DIRECTORY_LEN =64;
 MAX_DIRS =8;

 MAXDB = 4;   //Max antall databaser som kan kjøre transactions
 MAX_EDIT_CLASS = 4;   //Klassetyper for input-felt

 MAXKEYS = 12;    //Max kombinasjons-key
 MAXSORT = 4;   //Max antall felt i sorteringer

 MAXFLDS = 96;  //Max felt i et skjema. Utvidet fra 80 til 96 (09.03.2011)
 MAXCOLS = 24;   //Max kolonner i print av lister
 MAX_GRID_COLS = 48;

 MAX_BROWSE_MATCH = 256;
 MAX_MATCH = 32000;
 MAX_OBJECTS = 255;
 MAX_BOOK_ITEMS = 256;  //max antall booking-items pr liste
 MAX_BOOK_ROWS =1000;

 MAX_SELECT_BARS =32;

 MAX_VTD =6;
 //MAX_DATASET_FIELDS =255;

 MAX_PCHAR_LEN = 32000; //255; //Size for StrAlloc av PChar

 MATCH_START  = 501;
 MATCH_INSIDE = 502;
 MATCH_END    = 503;

 //Søke-metoder
 COMBINE_ = 103;
 SINGLE_ = 104;
 COMPLEX_ = 105;  //Kan inkludere ! < >
 EXACT_ = 106;     //Denne verdien kan også dette som tag-property i Tfld
 COMPOSITE_ =107;  //Brukes for å skille mellom key fra felt og key fra composite

 DOWN_    =3;
 UP_      =4;
 DISPLAY_ =5;
 WRITE_   =6;
 READ_    =7;
 DELETE_  =8;
 UPDATE_  =9;
 REPLACE_ =10;
 REUSE_   =11;
 SEARCH_  =12;
 STORE_   =13;
 RESTORE_ =14;
 FIRST_   =15;
 LAST_    =16;
 LOAD_    =17;
 HEAD_    =18;
 INIT_    =19;
 COMPARE_ =20;
 COUNT_   =21;
 CREATE_ =22;
 COPY_    =23;
 CLEAR_   =24;
 CHECK_   =25;
 ALL_     =26;
 ACTIVE_  =27;
 MANUAL_  =28;
 SELECT_  =29;
 EDIT_    =30;
 LOWER_   =31;
 UPPER_   =32;
 WIDE_    =33;
 NEXT_    =34;
 EXTERN_  =35;
 RECORD_  =36;
 TRANSMITT_ =37;
 RECEIVE_   =38;
 TERMINATE_ =39;
 TRANSFER_  =40;
 PRINT_     =41;
 INCLUDE_   =42;
 EXCLUDE_   =43;
 LEFT_      =44;
 RIGHT_     =45;
 CENTER_    =46;
 PRESS_     =47;
 RELEASE_   =48;
 START_     =49;
 STOP_      =50;
 ERASE_     =51;
 INSERT_    =52;
 FWD_       =53;
 REW_       =54;

 ADD_       =55;
 SUBTRACT_  =56;
 DIVIDE_    =57;
 MULTIPLY_  =58;

 STATUS_    =59;
 REPLY_     =60;
 DIRECT_    =61;

 TABLE_     =62;
 INDEX_    =63;
 MAP_       =64;
 MSG_       =65;
 GENERATE_  =66;
 PROGRES_   =67;
 RESULT_    =68;

 NORMAL_KEY_   =69;
 MULTI_KEY_    =70;
 ONE_KEY_      =71;
 WILD_KEY_     =72;
 STAR_KEY_     =73;
 MATCH_ALL    =74;

 EXIST_        =75;
 SKIPPED_      =76;

 ONE_IDX_      =77;
 ALL_IDX_      =78;
 PRIOR_	      =79;

 ESCAPE_   =81;
 PAUSE_    =82;
 END_POS_  =83;
 ADJUST_   =84;
 REFRESH_  =85;
 INPUT_    =86;
 TEXT_     =87;
 GET_      =88;
 GET_SIZE_ =89;
 RESET_    =90;
 PREPARE_  =91;
 RECALL_   =92;
 SCREEN_GRAB_  =93;

 FILEPOINTER_ =95;
 SWAP_        =96;
 LIST_        =97;

 ORDER_       =98;
 RETUR_       =99;
 OUT_         =100;
 RUN_         =101;
 KEEP_        =102;
 BETWEEN_     =103;
 PRIOR_SET_   =104;
 NEXT_SET_    =105;
 COMMIT_      =106;
 OPEN_        =107;
 CLOSE_       =108;
 DISABLE_     =109;
 ENABLE_      =110;
 INFO_        =111;

 MAX_SIZE     =112;
 MIN_SIZE     =113;
 DESIGNED_SIZE =114;
 NORMAL_SIZE   =115;
 GET_MASK_     =116;
 SET_FOCUS_    =117;
 QUESTION_     =118;
 YESNOCANCEL_  =119;
 SILENT_       =120;
 ATTACH_       =121;
 PREVIEW_      =122;
 SET_          =123;
 SAVE_         =124;
 LOW_          =125;
 HIGH_         =126;
 REVERS_       =127;
 GETLOG_       =128;
 SYNC_         =129;
 GROUP_        =130;
 REDUCED_      =131;
 FULL_         =132;
 SET_READY_    =133;
 SET_OK_       =134;
 CONFIG_       =135;
 SUM_          =136;
 SET_XFER_     =137;   
 PRINS_        =138;   //Overføring fra PRiNS til Overtid
 EXECUTE_      =139;

 SQL_BASED     =139;
 YEAR_2_4      =140;  //utgått
 YEAR_4        =141;
 YEAR_2        =142;
 NORMAL_       =143;
 DISABLED_     =144;
 FOCUSED_      =145;

 CUT_          =150;
 QUESTION_NO_  =151;
 QUESTION_YES_ =152;

 ROUND_ONE      =154;
 ROUND_HALF     =155;
 PDOX_BASED     =156;

 SUM_ALL_           =157;
 SUM_SKIP_HOLY_     =158;
 RECOVER_           =159;
 SUM_ONLY_HOLY_     =160;
 SUM_LOCAL_         =161;

 GROUP_PRODNR_      =162;
 GROUP_ANSATT_      =163;
 SPLIT_HOLY_        =164;
 SET_LOCK_          =165;
 NEED_COMMIT_       =166;
 SHOW_              =167;
 AVG_               =168;
 SCALED_            =169;
 MACONOMY_          =170;

 RANGE_               =171;
 RANGE_NOT_FREELANCE_ =172;
 RANGE_CHECK_         =173;
 SLIDE_               =174;
 INHIBIT_             =175;
 CALC_MOVE_           =176;
 CLEAR_MOVE_          =177;
 CALC_Y_MOVE_         =178;
 LOCAL_               =179;
 EXTERNAL_            =180;
 FREELANCE_           =181;
 NEW_                 =182;
 FINISH_              =183;

 INSIDE_OVERLAPPED_   =184;
 LEFT_OVERLAPPED_     =185;
 RIGHT_OVERLAPPED_    =186;
 TOTAL_OVERLAPPED_    =187;


 CONT_LEFT_           =188;
 CONT_RIGHT_          =189;
 REMOVE_              =190;
 PERSONS_ONLY_        =191;
 ITEMS_ONLY_          =192;

 END_                 =193;
 CALCULATE_           =194;
 DRAGDROP_            =195;
 AUTO_                =196;
 EXCLUDE_WEEKEND_     =197;
 JOIN_                =198;
 SPLIT_               =199;
 RELOAD_              =200;

 UPDATE_ONLY_         =201;
 UPDATE_APPEND_       =202;
 APPEND_ONLY_         =203;

 VIEW_BY_SIGN_        =204;
 VIEW_BY_DATE_        =205;
 UPDATE_NOT_LOCKED_   =206;
 LINK_PRODUCTID_      =207;

 NEED_COMMIT_NEW_     =208;
 NEED_COMMIT_UPDATE_  =209;
 NEED_COMMIT_DELETE_  =210;

 DRAG_VK_             =211;
 DRAG_SIGN_           =212;
 DRAG_FACILITY_       =213;
 DRAG_FUNC_           =214;
 DRAG_PRODNR_         =215;


 MOVE_                =216;
 RESIZE_              =217;
 RESIZE_LEFT_         =218;
 RESIZE_RIGHT_        =219;
 DRAG_VK_ONLY_        =220;
 NO_MOVE_             =221;

 INVOICE_             =222;

 DOMESTIC_            =223;
 INTERNATIONAL_       =224;
 EMPTY_               =225;
 STREAM_              =226;
 NOT_STREAM_          =227;
 SET_TC_DUR_          =228;
 DUP_                 =229;
 LOG_                 =230;
 ADD_PLUS_            =231;
 ADD_MINUS_           =232;
 RESTART_             =233;
 PLAY_                =234;
 RETRY_               =235;

 //BREAK_BY_SIGN       =233;
 //BREAK_BY_DATE        =234;

 LANDSCAPE_    =300;
 PORTRAIT_     =301;

 OPEN_FILE_	=1;
 CLOSE_FILE_	=2;
 DELETE_FILE    =3;

 DDMMYY_      =200;
 DDMONYY_     =201;
 Y0DAY_       =202;

 AUTO_DB      ='AUTO';

 READONLY_    =410;
 ORDERONLY_   =415;
 RESTRICTED_  =420;
 ALL_ACCESS_  =430;
 ADMIN_       =440;
 LOCKED_      =400;
 PRINSONLY_   =405;

 READONLY_PROFILE ='READONLY';
 ORDERONLY_PROFILE ='ORDERONLY';
 RESTRICTED_PROFILE ='RESTRICTED';
 ADMIN_PROFILE ='ADMIN';
 FULL_PROFILE ='FULL';
 LOCKED_PROFILE ='LOCKED';
 PRINSONLY_PROFILE ='PRINSONLY';

 MOVE_OFFSET = 6;    //Antall linjer opp/ned ved PgUp og PgDn

 ACTIVE_FLD = 0;
 LAST_FLD = 1;

 TEXT_KEY = 1;
 INTEGER_KEY = 2;
 DATETIME_KEY = 3;
 MEMO_KEY = 4;
 GRAPHIC_KEY = 5;
 FLOAT_KEY =6;
 CURRENCY_KEY =7;
 DATE_KEY =8;

 //DATE_REF_MILENIUM = 1990;

 DATE_FLD_LEN = 8;
 SHORT_DATE_LEN = 8;
 LONG_DATE_LEN =10;
 PROD_KEY_LEN =4;      //4 første tegn i prodnr

 SHORT_DATE_FMT ='dd.MM.yy';
 LONG_DATE_FMT ='dd.MM.yyyy';

 //Brukes i Orpheus picture-field
 //Hvis dd.MM.yy brukes, vises ikke 0 foran måned.
 SHORT_DATE_FLDMASK ='dd.mm.yy';
 LONG_DATE_FLDMASK ='dd.mm.yyyy';

 SHORT_NULL_DATE ='00.00.00';
 LONG_NULL_DATE ='00.00.0000';

 PB_DATE_FORMAT ='YYYY-MM-DD';


 MAX_YEAR_DAYS = 366;
 SHORT_YEAR_REF =50;
 LONG_YEAR_REF =1950;
 WEEK_YEAR_REF =1996;
 FUTURE_DATE_REF =2049;

 YEAR1900 =1900;
 YEAR2000 =2000;

 FUTURE_DATE_2 ='31.12.49';
 FUTURE_DATE = '31.12.2049';
 FIRST_DATE_REF = '01.01.1950';
 WEEK_REF_DATE ='04.01';
 XREM_BACK_DAYS =60;  //last inn merknader bare de siste 60 dager
 DATE_290200 ='29.02.2000';
 DATE_2000 ='01.01.2000';
 LART_DATE_2003='05.09.2003'; //tidspunkt for overgang til nytt oppsett

 MS_datetime ='datetime';
 MS_ddmmyyyy =104;

 //Versjon av vcf132.ocx
 VCF_FILE_DATE ='22.07.96';
 FORMULA_VCF ='vcf132.ocx';
 CLEAR_TYPE = 3;

 //Ved generering av records lokalt, settes SeqID 10 fram
 //i tilfelle andre brukere har lagt inn nye records
 //før liste overføres (Commit)
 SEQID_INC =10;

 CUSTNO_LEN = 5;

 ASC = 'ASC';
 DSC = 'DSC';
 DESC = 'DESC';

 SEQ_FLD ='Seq';


 ID_CODE_LEN =7;   //F.eks 012.002

 SQL_RESULT =1;
 LOCAL_RESULT =2;

ASCII_HIGH        = 230;
ASCII_OFFSET      = 170;
ASCII_DIF         = 60;
ASCII_NUM_HIGH    = 57;
ASCII_NUM_LOW     = 48;
ASCII_LETTER_LOW  = 65;
ASCII_LETTER_HIGH = 122;
ASCII_CASE_DIF    = 32;

TWIPS_RATIO = 20;
TWIPS_RATIO_VCF =15;
VCF_XLS_RATIO =115;   //Excel kolonne-bredder må multipliseres med denne verdien

OS_WIN95 = 95;
OS_NT =40;

 //Messages

  PCB_BROWSE_RUN = WM_USER+1;  //Viser browser for felt
  PCB_DATE_VALID = WM_USER+2;
  PCB_TIME_VALID = WM_USER+3;
  PCB_RECORD_VALID = WM_USER+4;
  PCB_SEQ_VALID = WM_USER+5;

  MNU_FILE =WM_USER+50;
  MNU_TRANS =WM_USER+51;
  MNU_REC =WM_USER+52;
  MNU_QRY =WM_USER+53;
  MNU_PRINT =WM_USER+54;
  MNU_SORT =WM_USER+55;

  //Nr på 'panels' i mainForm
  PNL_STAT = 0;
  PNL_FIELD = 1;
  PNL_MSG = 2;
  PNL_INFO = 3;

  PNL_INIT =10;

  //Hva som skal bookes
ITEMS = 0;
ARTIST = 1;

SELECT_INSIDE =1;
SELECT_OUTSIDE =2;
SELECT_ALL_OUTSIDE =3;
SELECT_ALL_INSIDE =4;
SELECT_ALL = 5;

MAXINISECTIONS = 64;

SECT_PATHS =1;
SECT_ALIAS =2;
SECT_DATABASE =3;
SECT_PROGRAM =4;
SECT_PACK =5;
SECT_DEFS =6;
SECT_PICTURE =7;
SECT_DATA =8;
SECT_SQL =9;
SECT_ODBC =10;
SECT_BROWSER =11;
SECT_SYSTEM =12;
SECT_PRINT =13;
SECT_THREADS =14;
SECT_MODULES =15;
SECT_WIN95 =16;
SECT_WINNT =17;
SECT_NETWORK =18;
SECT_USER =19;
SECT_EVENT =20;
SECT_MSG =21;
SECT_COLORS =22;

SECT_NRK = 29;

SECT_PROD =30;
SECT_BOOKING =31;
SECT_ITEM =32;
SECT_ITEMGROUP=33;
SECT_SIGN =34;
SECT_CATEGORY =35;
SECT_VENUE =36;
SECT_OVRN =37;
SECT_TOUR =38;
SECT_INVOICE =39;
SECT_ARTIST = 40;

SECT_PB =42;
SECT_G4 =43;


SQL_SQUOTE ='''||chr(39)||''';
SQL_DQUOTE ='''||chr(34)||''';


SQL_LIKE = ' LIKE ';
SQL_EQ = ' = ';
SQL_GT = ' > ';
SQL_LT = ' < ';
SQL_NOT = ' <> ';
SQL_GTE = ' >= ';
SQL_LTE = ' <= ';
SQL_ORDER_BY = 'ORDER BY';
SQL_GROUP_BY = 'GROUP BY';

IS_NULL ='IS NULL';
IS_NOT_NULL ='IS NOT NULL';

SORT_ASC ='ASC';
SORT_DSC ='DESC';

ORA_RR = 'RR'; //brukes i ORACLE to_date() for å skille 19. og 20. century
ORA_DATE_FORMAT ='dd.mm.RR';
ORA_DATE_NLS_FORMAT ='dd.mm.RR';
ORA_DATE_FUNC ='to_date';

MS_DATE_FORMAT ='dd.mm.yy';
MS_DATE_NLS_FORMAT ='dd.mm.yy';
MS_DATE_FUNC ='convert';


//Printer const
SUM_OFF=0;
SUM_ON =1;

RECNO_OFF =0;
RECNO_ON =1;


MAX_ARTISTS = 32;
MAX_DATE_PERIOD = 96;

crAtom = 1;
crCounter =2;

sf_UnKnown = 0;
sf_String  = 1;
sf_Memo    = 2;

TIME_FLD = 1;
STR_FLD = 2;
NUM_FLD = 3;
MEM_FLD = 4;
DATE_FLD = 5;
FLOAT_FLD = 6;
HOUR_FLD = 7;
ONOFF_FLD = 8;

//Felt som kan inneholde komma i skjermbildet,
//men lagres som heltall ganger 100
DECI_FLD = 9;
DECI_FACTOR = 100;
DECI_FACTOR_HALF =50;

PERSISTENT_FLD = -1;
DROPPED_DOWN = 100;

//Brukes i Artist-booking
MSG_OVERBOOK       ='Overbooking';
STAT_REQUEST       ='Forespurt';
STAT_CANCELED      ='Kansellert';
STAT_ALLOC         ='Fastsatt';

//Brukes i Faktura
 REGNING_SENDT ='Regning sendt';
 BELOP_MOTTATT ='Beløp mottatt';
 PURRING_1     ='1. purring';
 PURRING_2     ='2. purring';
 INKASSO       ='Inkasso varsel';
 KREDIT_NOTA   ='Kredit nota';

//Brukes i NRK
NRK ='NRK';
NRK_ID ='NRK ';
BTX_REC_SIZE = 220;
FRV_REC_SIZE = 225;  //80 i gammel versjon

URL_FILE = 'xhtml.url';
UNKNOWN ='?';
UNDF ='Undf';

N_A   ='N/A';

AM_  ='AM';
PM_  ='PM';
AMTID ='A';


//200 ms interval i mzplayer er et bra kompromiss
//Burde ha vært 40 ms (1 rute), men da henger ikke oppdateringene med
MP_CLOCK_INTERVAL =200;

DAY_MIN_LEN = 1440;  //Antall minutter pr dag

TIME_235959 ='23:59:59';
TIME_235959_DOT ='23.59.59';
TIME_2359_DOT ='23.59';

TIME_24 ='24:00:00';
TIME_24_DOT ='24.00.00';

TIME_00 ='00:00:00';
TIME_00_DOT ='00.00.00';

ONE_DTM_SEC =0.0000115740; //0.00001157407678; //0.000011583;  //1 sekund i TdateTime
ONE_DTM_MIN =ONE_DTM_SEC*60; //0.000695;

TIME_FLD_LEN =5;


//NIGHT_BREAK =120;   //kl 02.00
//DAY_BREAK = 540;  //09.00 (60*9) er dagskille
//FM_EM_BREAK = 840;   //kl 14.00 skille F/E i vaktplaner

MAX_DATA_XROWS = 40;
MAX_TURNUS_COUNT = 1200;
MAX_LART_VALUE =9999;

MAX_LARTS = 32;

MAX_LART_TYPS =6;
MAX_PNLS = 6;

MAX_VCODE_LEN =4;
MAX_VK_LEN =MAX_VCODE_LEN+1;

MAX_AVSPTEXT_LEN =47;

ERROR_SUM = -99999;
PRODNR_LEN = 12;
PROD_LEN = 10;

SIGN_LEN = 3;     //Default lengde på signaturer
SIGN_LEN_ITEMS =8;
AVD_LEN =4;
FIRM_LEN =6;  //Firma i Maconomy
FRV_KODE_LEN =3;
ANSATT_LEN =5;
VKODE_LEN =4;
LART_LEN =4;  //Antall tegn (minimum) i lønnarter
PRODUKT_LEN =10;
RESGRP_LEN =8;

WEEKEND_COLOR = clRed;
HOLY_COLOR = clPurple;
NORMAL_COLOR = clBlack;
ERROR_COLOR =4227327;
YELLOW_MARK_COLOR = 8454143;
INFO_COLOR = $00B9FFFF;  //Lys gul

               //B G R
LIGHT_YELLOW =$00A8FFFF;
DARK_RED =$00805FEC;
LIGHT_RED =$009070F5; //$00C4B3F7;

{$IFDEF XPRINT}
 LIGHT_SILVER = $00E2E2E2;

//Overtidslister som blir splittet starter med dette f.eks Xprt_1.DB
 XKOMP_TBL_FILE ='Xprt_';
 
{$ENDIF}

{$IFDEF XNRK}
//LIGHT_SILVER = $00E1E1E1;
// LIGHT_SILVER =$00CACACA;
 LIGHT_SILVER = $00E2E2E2;

 DARK_SILVER =$00A4A4A4;
 // LIGHT_SILVER = $00E8E8E8;
{$ENDIF}

ON_COLOR = clYellow;
OFF_COLOR = clSilver;

VCF_DOTTED_LINE = 4;
VCF_SOLID_LINE =1;

MONDAY_CODE = 'Man';
TUESDAY_CODE ='Tir';
WEDNESDAY_CODE ='Ons';
THURSDAY_CODE ='Tor';
FRIDAY_CODE = 'Fre';
SATURDAY_CODE = 'Lør';
SUNDAY_CODE = 'Søn';

FRE_CODE='F';
SAT_CODE='L';
SUN_CODE='S';


HYPP_BACK_DAYS =8; //Antall dager som må sjekkes foran en periode

FRV_PREFIX ='F';  //Prefiks kode for fravær

MTID_TEXT ='+/- tid';
YVK_TEXT  ='Y-vakt';

SRC_KOMP =1;
SRC_BOOK =2;

X_CODE = 'X';
XALL_CODE = '0X';
ZALL_CODE = '0Z'; //ny 24.10.02

OX_CODE = 'OX';   //pgr skrivefeil o istedenfor 0

Y_CODE = 'Y';
Z_CODE = 'Z';  //Brukes som X, men gir ikke overtidsfakturering
W_CODE = 'W';  //Ny 24.10.02. Samme egenskap som tidligere Z
D_CODE = 'D';
G_CODE = 'G';  //Ny 03.09.03. Kode for gjennomsnittsberegnet vakt

//Reisekoder
R_CODE = 'R';
R1_CODE = 'R1';
R2_CODE = 'R2';
R3_CODE = 'R3';
RH_CODE = 'RH';  //reise på høytid
RN_CODE = 'RN'; //reise på normaldag for gj.snitt beregnede
RMTX ='RMTX'; //Overtid fra mertid på reise

RTIL_LEN =960; //En reise må være minst 16 timer for å få reisetillegg
RTIL_STEP =360;
RTIL_FROMKL =1320; //kl 22
RTIL_TOKL = 420; //07
RTIL_NIGHT_HRS =180; // 3 timer


//Eller minst 3 timer mellom 22 og 07 ved losji
//Neste reistillegg kommer etter mer enn 24 timer + 6 timer dvs. 30.01

//S_CODE = 'S';

RFRI = 'RFRI';
YFRI ='YFRI';
TFRI ='TFRI';
TF   ='TF'; //samme som TFRI
FRI  ='FRI';
FRID ='FRID'; //Ny 23.12.2002 Turnusfridag for deltidsansatte
TFRI_ ='TURNUSFRI';
KFRI  ='KFRI'; //Kompensert fridag

PERM ='PERM';
PRMU ='PRMU'; //perm uten lønn

KURS ='KURS';
UVI  ='UVI';   //Undervining
VEDL ='VEDL';
DIVE ='DIV';
FORA ='FORA'; //forarbeid
ADM  ='ADM';
KRAN ='KRAN';
SCAM ='SCAM';
ANSV ='ANSV';
FAGF ='FAGF';
LEDE ='LEDE';
TRAN ='TRAN';
EVAL ='EVAL';
IKKE ='IKKE';
PROD ='PROD';
UTLN ='UTLN';

FERIE ='FERI';
FERI = FERIE;

FERIE_='FERIE';
REISE ='REISE';
DIVERSE ='DIVERSE';

DISP  ='DISP';
KLAR ='KLARGJØR';
SYK = 'SYK'; //'SYKDOM';
SYK2 = 'SYK2'; 
F110 ='F110';
F115 ='F115';
F120 ='F120';

SYK_='SYKDOM';
LEIE ='LEIE';
SERVICE ='SERVICE';
VSJEF   ='VSJEF';


TIME_SLACK =5;   //5 min tidsslakk for å finne vaktkoder

REISETILLEGG ='REISETILLEGG';
REISETILLEG ='REISETILLEG';
REISETILEGG ='REISETILEGG';
REISETILEG ='REISETILEG';


MACONOMY ='Maconomy';
MAC_PRISLISTE ='NRKPRIS';

{$IFDEF MAC_DK}
MAC_SPERRET ='SPAERRET';           //ISBLOCKED

MAC_PRODNR ='SAGSNUMMER';          //JOBNUMBER
MAC_PROD_NAVN ='SAGSNAVN';         //JOBNAME
MAC_PROD_TEKST ='BESKRIVELSE1';    //DESCRIPTION1
MAC_PROD_INT ='INTERNSAG';         //INTERNALJOB
MAC_PROD_STAT ='STATUS';           //STATUS
MAC_PROD_START ='DATO1';           //DATE1
MAC_PROD_SLUTT ='DATO2';           //DATE2

MAC_DATO ='POSTERINGSDATO';        //DATEOFENTRY
MAC_SEKVNR ='POSTERINGSNUMMER';    //ENTRYNUMBER
MAC_TEKST ='TEKST';                //TEXT
MAC_ANT_REG ='ANTALREGISTRERET';   //NUMBERREGISTERED

MAC_ANT_BUDGET ='ANTALBUDGET';     //QUANTITYBUDGET
MAC_SUM_REG ='KOSTPRISREGISTRERET'; //COSTPRICEREGISTERED
MAC_SUM_BUDGET ='KOSTPRISBUDGET';   //COSTPRICEBUDGET

MAC_BOKFOERT ='BOGFOERINGSDATO';    //POSTINGDATE
MAC_JOURNALNR ='JOURNALNUMMER';     //THEJOURNALNUMBER
MAC_BILAGSNR ='BILAGSNUMMER';       //VOUCHERNUMBER

MAC_FIRMA ='FIRMANUMMER';           //COMPANYNUMBER
MAC_PRIS_LISTE ='SAGSPRISLISTENAVN'; //JOBPRICELISTNAME
MAC_PRIS_VER ='UDGAVE';              //ISSUE
MAC_PRIS ='KOSTPRIS';                //COSTPRICE
MAC_MPRIS ='MELLEMREGNINGSPRIS';     //INTERCOMPANYPRICE
MAC_PRDAG ='MAXTIMETALPRDAG';        //MAXHOURSPERDAY
MAC_BET_KUNDE ='BETALINGSKUNDE';     //THEPAYMENTCUSTOMER
MAC_AFIRMA ='AFREGNINGSFIRMA';       //SETTLINGCOMPANY

MAC_AKTIVITET ='AKTIVITETSNUMMER';   //ACTIVITYNUMBER
MAC_AKT_X98 ='FORMAALNAVN';          //PURPOSENAME
MAC_AKT_TEKST ='AKTIVITETSTEKST';    //ACTIVITYTEXT
MAC_AKT_TYPE ='AKTIVITETSTYPE';      //ACTIVITYTYPE
MAC_KATEGORI ='SPECIFIKATION1NAVN';  //SPECIFICATION1NAME
MAC_SEKSJON ='SPECIFIKATION2NAVN';   //SPECIFICATION2NAME

MAC_ANSATT ='MEDARBEJDERNUMMER';     //EMPLOYEENUMBER
MAC_AVDELING ='BEMAERKNING1';        //NOTE1
MAC_SIGN ='BEMAERKNING2';            //NOTE2
MAC_NAVN1 ='NAVN1';                  //NAME1
MAC_NAVN2 ='NAVN2';                  //NAME2
MAC_GRUPPE ='FAGGRUPPE';             //PROFESSION

MAC_UPD_DATO ='RETTELSESDATO';       //CHANGEDDATE
MAC_AV_SIGN ='OPRETTETAF';           //CREATEDBY
MAC_AV_DATO ='OPRETTELSESDATO';      //CREATEDDATE

{$ENDIF}


{$IFDEF MAC_US}

MAC_SPERRET ='ISBLOCKED';

MAC_PRODNR ='JOBNUMBER';
MAC_PROD_NAVN ='JOBNAME';
MAC_PROD_TEKST ='DESCRIPTION1';
MAC_PROD_INT ='INTERNALJOB';
MAC_PROD_STAT ='STATUS';
MAC_PROD_START ='DATE1';
MAC_PROD_SLUTT ='DATE2';

MAC_DATO ='DATEOFENTRY';
MAC_SEKVNR ='ENTRYNUMBER';
MAC_TEKST ='TEXT';
MAC_ANT_REG ='NUMBERREGISTERED';

MAC_ANT_BUDGET ='QUANTITYBUDGET';
MAC_SUM_REG ='COSTPRICEREGISTERED';
MAC_SUM_BUDGET ='COSTPRICEBUDGET';

MAC_BOKFOERT ='POSTINGDATE';
MAC_JOURNALNR ='THEJOURNALNUMBER';
MAC_BILAGSNR ='VOUCHERNUMBER';

MAC_FIRMA ='COMPANYNUMBER';
MAC_PRIS_LISTE ='JOBPRICELISTNAME';
MAC_PRIS_VER ='ISSUE';
MAC_PRIS ='COSTPRICE';
MAC_MPRIS ='INTERCOMPANYPRICE';
MAC_PRDAG ='MAXHOURSPERDAY';
MAC_BET_KUNDE ='THEPAYMENTCUSTOMER';
MAC_AFIRMA ='SETTLINGCOMPANY';

MAC_AKTIVITET ='ACTIVITYNUMBER';
MAC_AKT_X98 ='PURPOSENAME';
MAC_AKT_TEKST ='ACTIVITYTEXT';
MAC_AKT_TYPE ='ACTIVITYTYPE';
MAC_KATEGORI ='SPECIFICATION1NAME';
MAC_SEKSJON ='SPECIFICATION2NAME';

MAC_ANSATT ='EMPLOYEENUMBER';
MAC_AVDELING ='NOTE1';
MAC_SIGN ='NOTE2';
MAC_NAVN1 ='NAME1';
MAC_NAVN2 ='NAME2';
MAC_GRUPPE ='PROFESSION';

MAC_UPD_DATO ='CHANGEDDATE';
MAC_AV_SIGN ='CREATEDBY';
MAC_AV_DATO ='CREATEDDATE';

 {$ENDIF}


//Y-vakter for automatisk overtid
Y6      = 'Y6';
Y65     = 'Y65';
Y7      = 'Y7';
Y75     = 'Y75';
Y8      = 'Y8';
Y85     = 'Y85';  //8,5 timer
Y9      = 'Y9';
Y95     = 'Y95';
Y10      = 'Y10';

XFRA_INP_ =1;
XTIL_INP_ =2;


LTRK = 'LTRK'; //Lønnstrekk
AVSP = 'AVSP';
RAVS = 'RAVS';  //Reise-avspasering
PLUS = 'PLUS';
ULMP = 'ULMP';  //Korreksjon for ulempevakter
//UVI  ='UVI';

XLEN_FLD = 'Xlen';
VLEN_FLD = 'Vlen';

//SYK_KODE ='SYK';
//PERM_KODE ='PERM';

INT_DEP ='XXXX';  //Ny 13.12.2001 intern avdelingskode
INT_VK_SEP ='-';

LART_REF_PREFIX ='L';
LART_REF_MIN =1;
LART_REF_MAX =MAX_LARTS;   //24 er reservert mertid

LART_N   =0; //Normal
LART_H1   =1; //Lønnart for alle høytidsdager unntatt jul og nyttår
LART_H2   =2; //Lønnart for jul og nyttår
//LART_D1   =3; //Lønnart for annet sats lav
//LART_D2   =4; //Lønnart for annet sats høy
LART_YY   =5; //Lønnart for fjoråret

//Koder for link mellom tabell for helligdager og lønnarter
N_TYP    ='N'; //Normal
H1_TYP    ='H1';
H2_TYP    ='H2';
//D1_TYP    ='D1';
//D2_TYP    ='D2';
YY_TYP    ='YY';
H_TYP     ='H';   //H 'Bevegelig' på høytidsdager forhindrer at denne bryter hypp-rekke

N_FIELD   ='LART';
H1_FIELD  ='LART_H1';
H2_FIELD  ='LART_H2';
//D1_FIELD  ='LART_D1';
//D2_FIELD  ='LART_D2';
YY_FIELD  ='LART_YY';

//Felt-referanser i tabell
DELTID_LART_REF ='L01';
X50_LART_REF = 'L02';
X100_LART_REF = 'L03';

VSJEF_LART_REF ='L04';  //vaktsjef fungering

O50_LART_REF = 'L09';   //50% ordning
O100_LART_REF = 'L10';  //100% ordning

E50_LART_REF = 'L07';   //50% endring
E100_LART_REF = 'L08';  //100% endring

HYPP_LART_REF = 'L12';
REISE_LART_REF ='L13';
LTRK_LART_REF = 'L14';

UVI_LART_REF = 'L17';  //Undervisningstillegg

X250_LART_REF = 'L18';
X275_LART_REF = 'L19';

X150_LART_REF = 'L20';
X200_LART_REF = 'L21';

EM_LART_REF ='L22';

KFRI_LART_REF ='L23'; //Ny 28.02.2001

//DIV_MTID_LREF = 'L24';   //reservert

//Nye lønnarter etter lønnsoppgjør 2003
KVELD1_REF ='L25';
KVELD2_REF ='L26';
NATT1_REF ='L27';
NATT2_REF ='L28';
MORGEN1_REF ='L29';
MORGEN2_REF ='L30';

MTIDFRV_REF='MTIDFRV';

//Lønnarter for TV2
{
U1_LART2_REF ='L20';
U2_LART2_REF ='L21';
X70_LART2_REF ='L18';
X100_LART2_REF ='L19';
}


LTRK_LART_CODE = '1720';
LTRK_LART_CODE_YY = '1266';

HYPP_LART_CODE = '1455';
HYPP_LART_CODE_YY = '1264';

REISE_LART_CODE = '1416';
REISE_LART_CODE_YY = '1268';


TID_ENHET ='T'; //tid
STK_ENHET ='A'; //Antall
RESERVED_TEXT ='RESERVERT';

EMP_LART = 'L';
EMP_TREG = 'T';
K_SPLIT  ='K';

EMP_AVG_VLEN =426; //7.06 pr dag (35,5 timers uke)

//Verdi for disse lønnart-referanser MÅ stemme med
//overstående _REF (X50_LART_REF (L03) =X100_LART (3) )
//Alle disse verdiene refererer til tabell 'nrklarts.DB'
//En del hardcoding pgr. speed, sorry ...
MTID_LART_CODE = '0000';
FRV_START =100;
FRV_END =999;

LART_GRP_RESERVED = 9;  //reservert lønnart gruppe

MAX_SGN_LEN =5;
MIN_SGN_LEN =2;
MAX_NAME_LEN =32;
MAX_TEAM_LEN =16;

NORMAL_LART =0;    //???
DELTID_LART =1;
X50_LART =2;
X100_LART =3;
VSJEF_LART =4;
NATT_LART =5;
HELG_LART =6;
ENDR50_LART =7;
ENDR100_LART =8;
ORDN50_LART = 9;
ORDN100_LART =10;
MORGEN_LART =11;    //05 - 07
HYPP_LART =12;
REISE_LART =13;
AVSP_LART =14;
MORGEN_1_LART =15;   //før 05
MORGEN_2_LART =16;   //Morgennytt 05-06
UVI_LART=17;        //Ny 02.05.00
X250_LART =18;
X275_LART =19;
X150_LART=20;
X200_LART=21;
EM_LART =22;        //Ny 16.05.00
KFRI_LART =23;    //Ny 28.02.2001

//RESERVED_LART =24;  //Reservert

//Nye lønnarter etter lønnsoppgjør 2003
KVELD1_LART =25;
KVELD2_LART =26;
NATT1_LART  =27;
NATT2_LART  =28;
MORGEN1_LART=29;
MORGEN2_LART=30;


{
X70_LART2 =18;  //Overtid Mandag-fredag
X100_LART2 =19;  //Overtid på helg
U1_LART2 =20;   //Kvelds-tillegg 18-22
U2_LART2 =21;   //Natt-tillegg 22-06
H_LART2 =22;   //Helg-frmmøte
}

PSEQID_FLD = 'PSEQID';  //SeqID fra X98 booking

XSEQID_FLD = 'XSEQID';    //fra Overtid/komp
SEQID_FLD ='SeqID';       //Normal SeqID
XYSEQID_FLD = 'XYSEQID';  //fra Xytech (PIF)
RSEQID_FLD = 'RSEQID';    //fra ROAD
POBSEQID_FLD = 'POBSEQID'; //Fra Helpdesk-system


Y_INPUT = 1;
X_INPUT =2;
ENDR_INPUT = 3;
MTID_INPUT = 4;
VLEN_INPUT =5;

TURNUS_ =1;
OVERTID_ =2;
TURNUS_OVERTID =3;

X_END =1;
X_FRONT =2;
X_SPLIT =3;

PROD_NODE =1;
DEP_NODE  =2;
ID_NODE   =3;
SGN_NODE  =4;
DATE_NODE =5;
V_NODE    =6;

EXCEL_4 = 2;
EXCEL_5 = 4;


SYK_KODE_START =100;
SYK_KODE_END =199;

FERIEKODE_START =200;
FERIEKODE_END =300;
FERIE_AR_DAGER =25;

HOUR_RATE_ID = 900;

DUMMY_ANSATT = '00000';
MIN_ANSATT   =10000;
MAX_ANSATT   =20000;

ULMP_PERIOD =70; //10 uker
ULMP_PRC_LIMIT =60; //60% ulempe

MIN_OFFTIMELIMIT =270; //Minimum tid før pause tilslag 4,5 timer

MAX_FRV_DAYS =100;

LOOP_LIMIT   =9999;

//ROAD
STAT_RETURNED       ='Returnert';
STAT_OUT            ='Utlevert';
STAT_RESERVED       ='Tildelt';
STAT_INVOICED       ='Fakturert';
STAT_EXP            ='Eksportert';
STAT_FAK_READY      ='Faktureres';

ITEM_MISSING ='Mangler';
ITEM_APPEARED ='Funnet';
ROAD_ID ='ROAD';
POB_SIGN ='POB';


//Utskrifter
FM_AVAIL = 1;
EM_AVAIL = 2;
FRI_AVAIL =3;
FERIE_AVAIL =4;

AVSP_AVAIL =5;
SYK_AVAIL =6;
REISE_AVAIL=7;
DIV_AVAIL =8;


//MACONOMY
RATE_OVERRIDE ='RO'; //Romeo Oscar

XRATE_NORMAL =1; //f.eks. TFFF104566 (første siffer endres fra 0)
XRATE_HIGH   =2; //f.eks. TFFF204566
RES_TYPE_PERSON =0;  //Personer
RES_TYPE_ITEM   =1;  //Utstyr

PRODUCT_TIME =0;  //Tidsaktivitet
PRODUCT_AMOUNT =1;  //Beløps-ativitet

PRODUCT_TIME_STR ='Tid';  //Tidsaktivitet
PRODUCT_AMOUNT_STR ='Beløp';  //Beløps-ativitet

EXP_DUMMY_VAL ='#BEVAR';

HIDE_TIMES =300;
SHOW_TIMES =301;
HIDE_PROD_LOCATION = 302;

 //Nye 11.02.2001
INVALID_PRODNR_ =175;
INVALID_IDNR_ =571;
INVALID_ACT_ =572;

//ny 27.02.2004
LOCKED_PRODNR_ =573;

//PRINS
DEP_CHARS = 4;
PROJ_DIGS =2;
PROD_DIGS =2;
YEAR_DIGS =2;
YEAR_SEP_POS =9;
ALOC_ =1;
REQS_ =2;

//FORMULA
OBJ_PRODNR    ='PRODNR';
OBJ_PERSON    ='PERSON';
OBJ_FORETAK   ='NRK';
OBJ_KSTED     ='tobjvd4';


KFRI_FM_TBL   ='LPDBA.L7INDVE';
KFRI_FM_VERNR =9200;

FM_TRANS_TYP  ='F0230';
FM_TRANS_HEAD ='#'+OBJ_FORETAK+BLANK+'LP'+FM_TRANS_TYP;

//Booking
BOOK_REQUEST_DIGITS =6;
BOOK_RESERVATION_DIGITS =6;
BOOK_REQUEST_OVERLAPPED = -3;

BOOK_REQUEST =1;
BOOK_ORDER   =2;

BOOK_RESERVERT ='RESERVERT';
BOOK_FRI       ='FRI';
BOOK_UBEMANNET ='UBEMANNET';
BOOK_KLADD     ='KLADD';
BOOK_MASTER    ='MASTER';
BOOK_LINK      ='LINK';
BOOK_NYPIF     ='TEST';

MAX_FACILITY_GROUP =900;  //max antall fasiliteter pr gruppe

VIEW_SIGN          ='PERSON';
VIEW_FAC           ='FASILITET';
VIEW_PROD          ='PRODUKSJON';
VIEW_FUNC          ='JOBBFUNKSJON';
VIEW_VK            ='VAKTKODE';
VIEW_GRPS          ='[GRUPPER]';

BAR_SIGN_          =1;
BAR_FAC_           =2;

MIRROR_ROW =1;

MAX_VCF_COLS =256;  //VcfFormula begrensning dessverre ...
MAX_VCF_ROWS =2048; //Kan være max 16000

//VCFPLAN_SEQID_COL =20; //Kolonne utenfor arket for SeqID

ROW_HEIGHT_STEP =16;

NULL_PRICE =0.01234;  //Dummy pris for å indikere fastpris

OBJ_BTN_PREFIX ='$';

NODE_EKSPAND     =1;
NODE_COLLAPSE  =2;

NODE_EKSPAND_CHAR =COLON;
NODE_COLLAPSE_CHAR =SEMICOLON;

NODE_FILLED_COLOR =clGreen;
NODE_EMPTY_COLOR =clNavy;

//PRODNR_LEN =11;

//LNRK
 UP_LN =1;
 DOWN_LN =2;

//HTML
HBLANK ='&nbsp;';
VSPACE ='<p>'+HBLANK+'</p>';
IP_GRID_SCALE =15;
DELPHI_GRID_SCALE =(-2);//Kolonnebredder i Delphi i forhold til HTML

FILL_ZEROS ='000000000000000000000000000000000000000';  //39 stk

//PiF
XY_VK_DELIM = '#';
XY_INVOICED ='Inv';  //Hardkodet i xytech for Fakturert
XY_BILL     ='Bill';
XY_VOID     ='Void';  //Slettet
XY_APROVED  ='Aprv';
XY_UPDATE  ='Upd';  //Oppdatert
XY_INHIBIT  ='SPER';  //sperret
XY_INTERNAL ='TIL';   //Interntid
XY_OFFTIME  ='FRI';   //Fri
//XY_XFER     ='XFER';  //Overført
XY_APRV       ='Aprv';
XY_RESERVED   ='RESE';
XY_RESERVED_NOCON   ='KON';  //Reservert uten konflikt. Ny 02.05.04


XY_ITEM =1;
XY_EDITROOM =3;
XY_STUDIO =5;
XY_EMP =8;
XY_TOM =15;
XY_VTEDITORS =25;
XY_PHASE_OFF ='OFF';
XY_BLANK_ACT ='TIMER';
XY_TIMEOFF_ID = 1003;
XY_VK_ID = 1001;
XY_VK_TBL =109;


TOPIC_CODE_LEN =3;
ASPECT_CODE_LEN =2;

STREAM_BASE ='Streambase';
G4 ='G4';

G4_MDB_ID =2;  //MediaDB ID i G4
G4_TYP_ID =2;  //live = 1, 2 = On Demand
G4_CAT_ID =17; //Vitenskap og kunnskap
G4_GEO_ID =1; //1 = Norge, 3 = Verden

G4_WHAT = 'Hva';
G4_WHO  = 'Hvem';
G4_WHERE = 'Hvor';

STREAM_Q_PREFIX ='-';
STREAM_MAX_Q_SIZE =4;


STREAM_H264 ='800';
STREAM_Q1 ='1000';
STREAM_Q2 ='600';
STREAM_Q3 ='200';
STREAM_QA ='160';  //lyd
STREAM_MP4 ='mp4';

STREAM_NETSRV_1 ='Maweb12\streambase\video';
STREAM_NETSRV_2 ='';

MAX_STREAM_FILES = 3;
STREAM_XML_FILENAME ='imp';

STREAM_FILE_TABLE ='wc_file';
STREAM_CAT_TABLE ='wc_categories';
STREAM_BROADCAST_TABLE ='wc_broadcast';
//STREAM_KANAL_TABLE ='wc_kanal';
STREAM_PROJECT_TABLE ='wc_accounts';
                                                             // =222561
STREAM_WMGEN ='http://www1.nrk.no/nett-tv/wmgenerator.aspx?klipp';

WMV_EXT ='wmv';
WMA_EXT ='wma';
MP3_EXT ='mp3';
MP4_EXT ='mp4';
XML_EXT ='xml';   

XML_HEAD_ISO ='<?xml version="1.0" encoding="ISO-8859-1"?>';
XML_HEAD_UTF8 ='<?xml version="1.0" encoding="utf-8"?>';
XML_HEAD_UTF16 ='<?xml version="1.0" encoding="utf-16"?>';

XML_IMPORT ='IMPORT';
XML_BROADCAST ='BROADCAST';
XML_BROADCAST_ID ='BROADCAST_ID';

XML_PROJECT_ID ='PROJECT_ID';
XML_TITLE='TITLE';
XML_DESCRIPTION ='DESCRIPTION';
XML_METADATA ='METADATA';
XML_MEDIA ='MEDIA';
XML_CATEGORIES ='CATEGORIES';
XML_CATEGORY_ID ='CATEGORY_ID';
XML_ACTIVE ='ACTIVE';
XML_FILES ='FILES';
XML_FILE ='FILE';
XML_QUALITY ='QUALITY';
XML_FILENAME ='FILENAME';
XML_SOURCEFOLDER ='SOURCEFOLDER';
XML_DISTRIBUTION_ID ='DISTRIBUTION_ID';

XML_ZERO_DATE ='0001-01-01T00:00:00.0000000+01:00';

//<DISTRIBUTION_ID>24</DISTRIBUTION_ID>

NRK_SKOLE ='NRKskole';
STREAM_DISTRIBUTION_ID =42; //DS-Mastream100 f.o.m. 22.01.08  //tidligere mastream10 '24';
STREAM_DISTRIBUTION_ID_MP =41;   //For mp3 og mp4

STREAM_FLD ='StreamID';
STREAM_FLD2 ='Stream_ID';
G4_FLD ='G4_ID';

THEME_SEP =COMMA; //seprarator mellom emner
THEME_SEP2 =SEMICOLON; //seprarator mellom emner

MAX_THEMES_LEN =128;

THEME_NAME ='Emne';
MIN_THEME_LEN =2;
MAX_THEME_LEN =32;
MAX_THEME_LEVELS =16;
THEME_PATH_SEP =' \ ';
THEME_FLD ='Emne';

SIFT ='SIFT';
SIDK ='SIDK';

SIFT_LINE_LEN =80;

SIFT_FLD_PREFIX ='S_';
SIFT_ID_FLD ='SIFT_ID';
SIFT_REGNR_FLD ='REGNR';
//SIFT_DB_OWNER='SIFT';

SIFT_MEDIA ='SIFT_MEDIA';
SIDK_MEDIA ='SIDK_MEDIA';

//SIFT_MEDIA_TBL =SIFT_DB_OWNER+'.S_MEDIA';


SIFT_MAX_CONTENT =4000;

PB_BR_VBINGEST_MPRO_OPRO ='BR_VBINGEST_MPRO_OPRO';
PB_ARKIVERES_NARK_OPRO ='ARKIVERES_NARK_OPRO';  //13841
//PB_ARKIVERES_NARK_OPRO_ID =13841;
PB_BESTILT_OPRO ='BESTILT_OPRO';

PB_BR_NRKSKOLE_MDOL_OPRO ='BR_NRKSKOLE_MDOL_OPRO';

PB_TIL_AM_NARK_OPRO ='TIL_AM_NARK_OPRO';
LAGRES_NARK_OPRO ='LAGRES_NARK_OPRO';

MAX_SQL_VCHARS =3998;


XML_UTF16 ='UTF-16';
XML_ISO8859 ='ISO-8859-1';

FMT_NORMAL_CODE ='N';
FMT_WIDE_CODE ='W';

MAI_TAPE ='MAI';
URIKS_TAPE ='URIKS';
SPO_TAPE ='SPO';
DIGS_TAPE ='DIGS';
UMAG_TAPE ='UMAG';

TAPE_SOURCE_ID ='r';

FMT_NORMAL =FILE_NAME_SEP+FMT_NORMAL_CODE;
FMT_WIDE =FILE_NAME_SEP+FMT_WIDE_CODE;


TC_SEEK_PRC =99.7;

TC_LEN_F =11;
TC_LEN =8;
NULL_LEN ='0.00';
TC_NULL ='00:00:00:00';
TC_NULL_HMS ='00:00:00';
TC_SEP =':';

TC_ONE_SEC ='00:00:01:00';
TC_ZERO ='00';
PAL ='PAL';

FMT_16_9 ='16:9';
FMT_4_3 ='4:3';

FMTA_16_9 ='16-9';
FMTA_4_3 ='4-3';

PRF ='PRF';

Utf8ByteOrderMark=#$EF#$BB#$BF;

PB_XML_FLNAME ='PB_xml.xml';


PB_TRUE ='true';
PB_FALSE ='false';
PB_RESERVED ='Reserved';
PB_NORMAL ='Normal';
PB_REGION ='Pass Through';
PB_ALWAYS ='Always';

PB_FMT_NORMAL ='4:3 PAL';
PB_FMT_WIDE ='16:9 PAL';

PB_FMT_AUDIO ='A1/A2';

PB_SRCFMT_NORMAL ='4x3 PAL';
PB_SRCFMT_WIDE ='16x9 PAL';

PB_DIGIBETA ='Digital Beta';
PB_BETA ='Analogue Beta';
PB_TAPE ='One Inch';
PB_DVC ='DVC Pro-25';
PB_ANY_TAPE ='Any';

PB_BLANK_TAPE ='Blank';
PB_SOURCE_TAPE ='Original';
PB_MULTI_TAPE ='Multi Segment';


PB ='Programbank';
PB_EXP ='Til Programbank';
PB_REG ='Oppdater Programbank';
PB_NOT ='Ikke i Programbank';

PB_CODE ='PB';
PB_ARK_CODE ='PB';
PB_ERROR ='PB_FEIL';

PB_CLIP_FULL ='clip_full';
PB_EVENT_META ='Hvem-Hva-Hvor';
PB_EVENT_OCCUR ='Hendelse';


ID_TAG ='id';
ID_TAG_START ='<'+ID_TAG+'>';
ID_TAG_END ='</'+ID_TAG+'>';

META_TAG ='metadata';
META_TAG_START ='<'+META_TAG+'>';
META_TAG_END ='</'+META_TAG+'>';

EXT_TAG ='Eksternkoder';
EXT_TAG_START ='<'+EXT_TAG+'>';
EXT_TAG_END ='</'+EXT_TAG+'>';


EVENT_TAG ='event';
EVENT_TAG_START ='<' + EVENT_TAG +'>'; //'<event>';
EVENT_TAG_END ='</' + EVENT_TAG +'>'; //'<event>';

CLIP_KEY ='<clip_key>';
UNIQUE_NAME ='<unique_name>';


PB_MAX_NAME =25;  //Maks antall tegn i unique name. Var 29
PB_MAX_TITLE =58;  //Maks antall tegn i unique name

// \\OPRO\OMN\A\Q\63\56
MIN_PBID_LEN =16;
PBID_PREFIX ='\\';

PB_SIFT ='SIFT';

PB_ARKIVSTOFF ='49'; //Arkivstoff
PB_SOURCE ='20'; //Råstoff
PB_SKOLE ='16';  //Skole

PB_ARK_DOMAIN ='NARK';
PB_GRID_DOMAIN ='OPRO';
PB_TEST_DOMAIN ='XPRO';

PB_SKOLE_ID ='UV';
PB_SIFT_ID ='AR';
PB_BESTILT ='BESTILT';
PB_CAT_TAPE='TAPE';
PB_CAT_TAPE_ID='36';

PB_INTERCHANGE_ADR ='PB_INTERCHANGE';

TAPELEN_MIN =5;

SKOLE ='SKOLE';

PRODNR_WIDE =12;
PRODNR_NORMAL =10;

XML_OMNIBUS_SCHEMA ='http://www.omnibus.tv/omnibus.g3.sig/omnibus.g3.sig.clip.xsd';
XML_HEAD_VER ='<?xml version="1.0"?>';
XML_HEAD_ENCODE_UTF16 ='<?xml version="1.0" encoding="utf-16"?>';
XML_HEAD_ENCODE_ISO8859 ='<?xml version="1.0" encoding="iso-8859-1"?>';

XML_HEAD_CLIP_CREATE ='<clip_for_creation xmlns="http://www.omnibus.tv/omnibus.g3.sig/omnibus.g3.sig.clip.xsd" >';
XML_CLIP_CREATE_END ='</clip_for_creation>';


XML_PRF_TYPE ='<type>PRF</type>';

OMNIBUS_URL ='http://160.68.109.204/Omnibus.G3.SIG/ClipInterface.asmx';
OMNIBUS_ARKIV_URL ='http://160.67.181.104/Omnibus.G3.SIG/ClipInterface.asmx';

OMNIBUS_MEDIA_GRID =NUL;
OMNIBUS_EXPFILE_UTF ='create_clip.xml';
OMNIBUS_EXPFILE ='exportToOmnibus.XML';
OMNIBUS_LOCAL_DIR ='C:\XNRK\XML';
OMNIBUS_BROWSER_DIR ='\\oprobrowser\'; //media\';
OMNIBUS_ARK_BROWSER_DIR ='\\narkbrowser\'; //media\';

OMNIBUS_LOKAL_GRID ='OPROMGRID';
OMNIBUS_ARKIV_GRID ='NARKDIVA';

OMNIBUS_LOKAL_BROWSE ='OPRPBROWSER';
OMNIBUS_ARK_BROWSE ='NARKBROWSER';


MEDIADB_NAME ='MediaDB';
MEDIADB_DIR ='X:\MediaDB';
MEDIADB_IMG_DIR ='X:\MediaDB\IMG';
MEDIADB_DOC_DIR ='X:\MediaDB\DOC';
MEDIADB_DOC_DIR_BCKP ='X:\MediaDB\DOC\BCKP';
//MEDIADB_DOC_DIR_BCKP ='\\madata02\program\XNRK\medieskolen\db\hrut\doc'


DOC_DIR ='DOC_DIR';
IMG_DIR ='IMG_DIR';
MEDIA_DIR ='MEDIA_DIR';


PB_DUB_DIR ='\\maffdrop01\dropmedia\NRKskole';
//FCP_DIR ='\\oproedl01\OPUSlist_Export\SKOLE';

FCP_DIR ='\\oproedl01\FCP_XML';

STREAM_DIR ='X:\Stream';
STREAM_XML_DIR ='X:\Stream\XML';
STREAM_IMPORT_DIR ='\\maweb12\streambase\video\';
STREAM_AUTOIMPORT_DIR ='\\maweb12\streambase\autoimport';

POLOPOLY_URL ='http://nrk.no/contentfile/imagecrop/';
POLOPOLY_PARAM ='?cropid=f169w734';

BLANK_FLD ='<BLANK>';

FCP_SAVED ='Saved FCP project';


FCP_CLIP_NAME ='FCP_CLIP_NAME';
FCP_CLIP_TITLE ='FCP_CLIP_TITLE';
FCP_CLIP_DUR ='FCP_CLIP_DUR';
FCP_SOURCE_NAME ='FCP_SOURCE_NAME';

FCP_SOURCE_TITLE ='FCP_SOURCE_TITLE';
FCP_SOURCE_DUR ='FCP_SOURCE_DUR';
FCP_SOURCE_START ='FCP_SOURCE_START';
FCP_SOURCE_END ='FCP_SOURCE_END';
FCP_CAT ='FCP_CAT';
FCP_REMARK ='FCP_REMARK';

{
fsBoldOff =4;
fsItalicOff =5;
fsUnderlineOff =6;
fsStrikeOutOff =7;
}

//JEDI konstanter

  UCS4ReplacementCharacter: UCS4 = $0000FFFD;
  MaximumUCS2: UCS4 = $0000FFFF;
  MaximumUTF16: UCS4 = $0010FFFF;
  MaximumUCS4: UCS4 = $7FFFFFFF;

  SurrogateHighStart = UCS4($D800);
  SurrogateHighEnd = UCS4($DBFF);
  SurrogateLowStart = UCS4($DC00);
  SurrogateLowEnd = UCS4($DFFF);



    { Flags for dwICC bitmask in TICCEx record }

    ICC_ListView_Classes	=     $00000001;
    ICC_TreeView_Classes        =     $00000002;
    ICC_Bar_Classes             =     $00000004;
    ICC_TAB_Classes		=     $00000008;
    ICC_UpDown_Class		=     $00000010;
    ICC_Progress_Class		=     $00000020;
    ICC_HotKey_CLASS		=     $00000040;
    ICC_Animate_CLASS		=     $00000080;
    ICC_Win95_Classes		=     $000000FF;
    ICC_Date_Classes		=     $00000100;
    ICC_UserEx_Classes		=     $00000200;
    ICC_Cool_Classes		=     $00000400;

    // Common Control Styles

    CCS_Vert                	=     $00000080;
    CCS_Left                	=     (CCS_VERT or CCS_TOP);
    CCS_Right               	=     (CCS_VERT or CCS_BOTTOM);
    CCS_NoMoveEx             	=     (CCS_VERT or CCS_NOMOVEY);

    RBIM_Style			=     $00000001;
    RBIM_ImageList		=     $00000002;
    RBIM_Background		=     $00000004;
    RBS_ToolTips		=     $00000100;
    RBS_VarHeight		=     $00000200;
    RBS_BandBorder		=     $00000400;
    RBS_FixedOrder		=     $00000800;

    RBBS_Break	    		=     $00000001;
    RBBS_FixedSize		=     $00000002;
    RBBS_KeepHeight		=     $00000004;
    RBBS_ChildEdge		=     $00000004;
    RBBS_Hidden	    		=     $00000008;
    RBBS_NoVert	    		=     $00000010;
    RBBS_FixedBmp		=     $00000020;

    RBBIM_Style			=     $00000001;
    RBBIM_Colors		=     $00000002;
    RBBIM_Text			=     $00000004;
    RBBIM_Image			=     $00000008;
    RBBIM_Child			=     $00000010;
    RBBIM_ChildSize		=     $00000020;
    RBBIM_Size			=     $00000040;
    RBBIM_Background		=     $00000080;
    RBBIM_Id			=     $00000100;

    RB_InsertBandA		=     wm_User +1;
    RB_DeleteBand		=     wm_User +2;
    RB_GetBarInfo		=     wm_User +3;
    RB_SetBarInfo		=     wm_User +4;
    RB_GetBandInfo		=     wm_User +5;
    RB_SetBandInfoA		=     wm_User +6;
    RB_SetParent		=     wm_User +7;
    RB_EraseDark		=     wm_User +8;
    RB_Animate			=     wm_User +9;
    RB_InsertBandW		=     wm_User +10;
    RB_SetBandInfoW		=     wm_User +11;
    RB_GetBandCount		=     wm_User +12;
    RB_GetRowCount		=     wm_User +13;
    RB_GetRowHeight		=     wm_User +14;
    RB_InsertBand		=     RB_InsertBandA;
    RB_SetBandInfo		=     RB_SetBandInfoA;
    RBN_HeightChange		=     -831;

    ReBarClassName              =     'ReBarWindow32';


type

//<body bgcolor="#ffffe3" text="#000000" link="#0000ff" vlink="#669966" alink="#990000">
{$IFNDEF DVC}

HTMLcellData = record
 grid: TDBgrid;
 fname: String;
 fdata: String;
 fontColor: String;
 bkgColor: String;
// fontSize: Integer;
 cellAlign: String;

 Bcolor: boolean;
 Balign: boolean;

end;

pHTMLcellData = ^HTMLcellData;


HTMltableCellFunction = function (pHC: pHTMLcellData): Integer of object;


HTMLfileData = record

 dset : TDBdataset;
 grid: TcustomGrid;

 unitCellFunc: HTMLtableCellFunction;
 defaultCellFunc: HTMLtableCellFunction;

 fldName: array [0..MAX_GRID_COLS] of String;
 fldNo: array [0..MAX_GRID_COLS] of Integer;
 fldType: array [0..MAX_GRID_COLS] of TfieldType;

 colTitle: array [0..MAX_GRID_COLS] of String;
 colWidth: array [0..MAX_GRID_COLS] of Integer;
 colAlign: array [0..MAX_GRID_COLS] of Talignment;

 totWidth: Integer;
 totColCnt: Integer;

 fieldCount: Integer;

 fil: TextFile;
 fileName: String;

 title: String;
 editor: String;
 head: String;
 info: String;

 bkgColor: String;
 textColor: String;
 linkColor: String;
 vlinkColor: String;
 alinkColor: String;

 tableColor: String;
 tableBorder: Integer;
 tableFont: String;

 lineColor: String;
 borderColor: String;

 pageBorder: Integer;
 pageWidth: Integer;
 pageColor: String;
 pageFont: String;

 lineHeight: Integer;
 leftMargin: Integer;

 colHeadFont: String;
 recordFont: String;

 colHeadColor: String;
 cellColor: String;

end;

pHTMLfileData = ^HTMLfileData;

{$ENDIF}

//  procedure GetFont(var pName: string; var pSize: Smallint; var pBold, pItalic, pUnderline, pStrikeout: TOleBool;
//     var pcrColor: TColor; var pOutline, pShadow: TOleBool); stdcall;

dateVars = record
 dat: TdateTime;
 fromDate: TdateTime;
 toDate: Tdatetime;

 firstDay: Word;
 lastDay: Word;

 yearDays: Word;
 dayOfYear: Word;

 weekNo: Word;
 weekNoStr: String;
 weeksInYear: Word;
 weekDay: Word;

 leapYear: Word;
 year: Word;
 overDays: Word;  //Antall dager i uke 1 ved passering 31/12
 firstDate,lastDate: TdateTime;

 thisYearStartWeekNo: Integer;

end;

pDates =^dateVars;

hyppVars = record

 holyDtm: TdateTime;
 lastHolyDtm: TdateTime;
 weekEndDtm: TdateTime;
 lastWeekEndDtm: TdateTime;
 prevHyppDtm: TdateTime;

 hyppOnDate: Boolean;  //TRUE hvis hypp er utløst på aktuell dato

 hyppOnLastHoly: Boolean;
 hyppOnlastSaturday: Boolean;
 hyppOnlastSunday: Boolean;

 hyppCntOnLastWeekEnd: Integer;
 qualifCntOnLastWeekEnd: Integer;

 qualifOnLastHoly: Boolean;
 qualifOnlastSaturday: Boolean;
 qualifOnlastSunday: Boolean;

 prevhyppCnt: Integer;
 hyppTotCnt :Integer;         //totalt antall hyppig helg
 hyppInhibit :Boolean; //Forhindrer flere hypp på samme dato
 hyppHolyInhibit:Boolean; //Forhindrer hypp på høytidsdager
 hyppQualif :Integer;
 hyppQualifCnt : Integer;
 hyppHits: Integer;
 hyppOnHoly: Boolean;
 skipHoly: Boolean;

 dayIsSunday: Boolean;
 hyppDayTyp: String;  //Ny 03.06.2002

end;

pHypp = ^hyppVars;

{$IFNDEF SIGN}
{
vfCell = record
 cellData: String;
 oldCellData: String;
 exitCellData: String;
 pFont: String;
 pSize: Smallint;
 pBold,pItalic,pUnderLine,pStrikeOut: ToleBool;
 pcrColor: Tcolor;
 pOutline,pShadow: ToleBool;
 fillPattern: Smallint;
 row,col: Integer;
 lastRow,lastCol: Integer;
 tr,tc,lr,lc: Integer;
 firstAvailRow,lastAvailRow,totAvailRows: Integer;

end;

pVfcell = ^vfCell;

cellStyle = (regular,
             boldOn,italicOn,underlineOn,strikeOutOn,
             boldOff,italicOff,underlineOff,strikeOutOff);

TcellStyles = set of cellStyle;
}

signData = record

 sgn: String;
 sgnName: String;
 dep: String;
 id: String;
 ans: String;

 resGrp: String;
 productID: String;
 prodNr: String;

 vk: String;
 vst: Integer;
 vend: Integer;
 vlen: Integer;
 xst: Integer;
 xend: Integer;
 xlen: Integer;

 xSeqID: Longint;  //SeqID i Overtid/komp
 //pSeqID: Real;  //ID i plan-bestilling

 //requestID: String;  //Bestillingsnr

 stat: Integer;
end;

pSignData =^signData;


allocs = record

 sgn:  String;  //Egentlig resource name
 sgnName: String; //Fullt navn
 ansatt: Longint;

 resName: String;  //Sign
 resID: Integer;
 resGrp: String;  //res. gruppe
 resGrpID: Integer;

 sgnResGrpID: Integer; //ressursgruppe for aktuell signatur
 sgnProductID: String;
 sgnRate: Real;
 sgnCnt: Real;
 sgnSum: Real;
 sgnNormVkLen: Integer; //Normal-arbeidstid

 resCnt: Integer;
 resGrpCnt: integer;
 activity: String;
 avpl: Boolean;     //Avplanlagt


 xtblSeqID: Longint;

 location: String;
 dep: String;   //Avdelingskode
 ID: String;   //Avdelings ID
 facility: String;
 facGrp: String;

 prodNr: String;
 prodName: String;
 prodLoc: String;
 prodSname: String;
 prodID: Longint;
 prodResp: String;
 prodFirm: String;

 projNo: Integer;
 prodNo: Integer;
 projYear: Integer;
 prodMet: String;      //Produksjonsmetode
 prodMetID: Longint;
 prodCnt: Integer;

 actID: Longint;
 actCode: String;
 actfromKl,actToKl: Integer;

 productID: String;
 productText: String;
 productFirm: String;

 jobs: Integer; //Bemanning

 dat: String;  //Dato
 loopDate: String;
 fromDate: String;
 toDate: String;
 fromYrVk: String;
 toYrWk: String;

 fromDtm,toDtm: TdateTime;

 yrwkSt,yrwkEnd: String;
 weekNo: Integer;
 wdayno: Integer;
 days: Integer;
 periodMins: Integer; //Totalt antall minutter i valgt periode

 vk: String;
 stdVk: String;
 sxVk: String;
 oVk: String;
 xVk: String;
 yVk: String;
 pVk: String; //Kostnadsfordelt kode. Ny 18.05.04

 vcode: String;  //Aktuell vaktkode
 ocode: String;  //Opprinnelig vaktkode
 rem: String; //Merknad

 pat: String; //14 tegn roster-pattern (aktuell vakt)
 oPat: String; //14 tegn opprinnelig kode
 sxPat: String; //Inneholder S og X koder
 rosPatVk: String; //Dekodet 2 bokstav vaktkode fra WK_RES_WKS

 Pst,Pend,plen: Integer;
 Vst,Vend,vlen: Integer;
 Xst,Xend,xlen: Integer;
 fromKl,toKl: Integer;

 //prDay: Integer;
 //total: Integer;
 //totPrice: Longint;

 mtime: Integer;
 qryFld: String;   //Navn på felt som søk er startet fra
 sgnQry: TQuery;

 selectType: Integer;

 orderFlds: String;
 tblName: String;

 deleteDate: String;
 bookTyp: Integer;
 requestID: String;
 orderID: String;
 remark: String;

 updDateTime: String;
 updDtm: TdateTime;
 updSign: String;

 funcID: String;
 funcName: String;

 timeCnt: Real; //Antall tidsenhter (tid som desimal)

 cnt: Real;  //antall
 rate: Real; //Pris
 sum: Real; //Beløp
 total: Real; //Totalt person + fasilitet/produkt

 requestCnt: Integer; //Antall bestilt

 recStat: Integer;  //ADD,INSERT,UPDATE osv
 //newRec: Integer;  //Brukes ved commit av lokale data

 locked: Integer;
 master: Integer;

 link_SeqID: Integer;
 txtlink: Longint;  //Link til tekst/info
 xSeqID: Longint;   //SeqID i original fra Overtid/komp
 pSeqID: Real;   //ID i X98 booking
 xySeqID: Longint; //Ref til PiF trans.

 fltResGrp,fltFacility,fltSgn,fltDep,fltProdNr,fltFunc: String;

 stat : Integer;
 dragTyp : Integer;
 phid: Integer; //fase ID
 phase: String;  //Fase beskrivelse
 phaseCode: String; //Fase kode
end;

pAllocs =^allocs;


 barFldNo = record
  seqid,resid,sign,avdeling,id: Integer;
  fradato,tildato,frakl,tilkl: Integer;
  vfra,vtil,vlen,xfra,xtil,xlen,tidantall,vkode: Integer;
  prodnr,produktid,fasilitet: Integer;
  antall,pris,totalt,belop: Integer;
  resgrp,funkid,merknad,updatetime,updatesign: Integer;
  booktyp,bestnr,ordrenr,recstat,slettet: Integer;
  trxid,stat,newrec,linkseqid,locked: Integer;
  master,txtlink,xseqid,pseqid,phid: Integer;

 end;

 pBarFldNo =^barFldNo;

 barSelect = record
  objid: Integer;
  barid: String;
  startCol,endCol: Integer;
  origStartCol,origEndCol: Integer;
  rowno: Integer;
  origRowNo: Integer;
  stat: Integer;
 end;

 barSelAr = array [1..MAX_SELECT_BARS] of barSelect;

 pBarSel =^barSelAr;

 
 barData = record

  sgn: String;  //Signatur
  sgnProductID: STring;
  sgnRate: Real;
  sgnCnt: Real;
  sgnSum: Real;

  dep: String;
  fltDep: String;  //Avdelingskode i filter
  prodNr: String;
  productID: String;
  prodTyp: String;
  facility: String;   //Kode for produksjonssted f.eks VB5
  resGrp : String;
  fltResGrp: String;
 // prodLoc: String;   //prodsted

  funcID: String;

  //fromDate,toDate: String;  //Aktuell bar fra/til
  //minDate,maxDate: StrinG;  //Kalenderens grenser
  minDtm,maxDtm: TdateTime;

  fromDtm,toDtm: TdateTime;
  selFromDtm,selToDtm: TdateTime;  //datoer iflg.selection
  selStartCol,selEndCol: Integer;

  fromKl,toKl: Integer;   //Kolokkeslett
  maxKl,minKl: Integer;
  selFromKl,selToKl: Integer;

  vst,vend,vlen: Integer;
  xst,xend,xlen: Integer;
  vk: String;    //vaktkode
  clearVk: Boolean;   //TRUE hvis vaktkode skal slettes


  timeCnt: real; //Antall tidsenhter (tid som desimal)

  cnt: Real;
  rate: Real;
  sum: Real;
  total: Real;

  mins: Integer; //antall minutter
  //days: Integer; //antall dager
  offset: Integer; //antall celler fram til startcelle

  fromDateFldName,toDatefldName: String;
  fromKlFldName,toKlfldName: String;

  startCol,endCol: Integer;
  oldStartCol,oldEndCol: Integer;
  startColObj,endColObj: Integer;
  //finishStartCol,finishEndCol: Integer;


  width: Integer; //bredde i celler
  actualWidth: Integer;

  height: Integer;  //høyde
  actualHeight: Integer;

  rowPos,colPos: Integer;
  lastRowPos,lastColPos: Integer;

  rowIDcol: Integer;
  rowTxtCol: Integer;

  rowFldName: String;  //heading i start av linje
  rowTxt: String;

  rowIDFldName: String;
  rowID: String;

  dset,bkgDset: TDBdataset;

  barFldName: String;   //Felt-navn i 'dset' som skal vises i bar
  barFldTxt: String;    //Kode i bar

  barIDfldName: String; //Felt-navn for beskrivelse i bar
  barIDtxt: String;  //beksrivelse

  IDfldName: String;
  barID: String;      //SeqID
  IDcol: Integer;

  //funkIDfldName: String;
  funcIDtxt: String;

  remark: String;
  remfldName: String;

  requestID: String;
  orderID: String;

  requestIDfldName: String;
  orderIDfldName: String;

  contLeft,contRight: Boolean; //merker for kontinuitet ut over "vindu"

  sheetname: String;

  bgColor,fgColor,txtColor: Tcolor;
  pattern: Integer;
  font: Tfont;
  border: Integer;  //Bredde på border
  borderColor: Tcolor;

  R1,C1,R2,C2: Integer;   //selection
  R1X,C1X,R2X,C2X: Integer;   //selection til posisjon


  objID: Integer;
  objVisible: Boolean;

  x,y: Integer; //popup meny pos

  moveMode: Integer;
  persistentRowID: Boolean; //Hvis FALSE, skifter "eier" ved flytting
  forceRowDescription: Boolean;
  forceBarDescription: Boolean;

  requestCnt: Integer; //Antall bestilt

  bookTyp: Integer;
  //newRec: Integer;
  recTyp: Integer;   //ADD,INSERT,UPDATE osv.
  locked: Integer; //Låst i tid
  link_SeqID: Integer; //Link til parallel fasilitet
  stat: Integer;    //Godkjent,Overført,Feil

  fromPkg: Boolean;  //TRUE hvis record kommer fra resPkg
  recIsExternal: Boolean;  //TRUE hvis bar-record er fra lokal bar.dset
  isConfirming: Boolean; //TRUE når bar bekreftes (for å unngå overlappsjekk)
  master: Integer;   //TRUE hvis andre record er linket til denne
  txtlink: Longint;  //Link til tekst/info
  xSeqID: Longint;   //SeqID i original fra Overtid/komp
  pSeqID: Real;   //ID i PRiNS bestilling

  dragTyp: Integer; //drag fra vaktkode,person eller fasilitet

  phid: Integer;   //fase/status
 end;

  pBar =  ^barData;

  barColorItem = record
   color: Tcolor;
   txt: String;
  end;

  barColors =array[1..4] of barColorItem;

  pBarColors =^barColors;

 //Disse brukes for å fylle/leggetilbake bakgrunssdata i bar
 restoreFunction = function (rs: pAllocs; bar: pBar; cmd: Integer): Integer of Object;
 fillFunction = function (rs: pAllocs; bar: pBar; cmd: Integer): Integer of Object;
 verticalFunction = function (rs: pAllocs; bar: pBar; cmd: Integer): Integer of Object;

  //Brukes i booking for å tegne bar i kalender
 calDataDisp = record

  //vcf: TVCformulaOne;

  maxrows,maxcols: Integer;
  datarows: Integer;   //antall linjer mellom first og last
  rowIDcnt: Integer; //Antall aktuell linjer med rowID

  R1,C1,R2,C2: Integer;   //selection
  R0,C0:  Integer;  //aktiv celle

  firstHeadRow,lastHeadRow: Integer;

  firstDataRow: Integer;
  firstDataCol: Integer;

  lastDataRow: Integer;
  lastDataCol: Integer;

  fixedRows: Integer;
  fixedCols: Integer;
  hiddenCols: Integer;   //Skjulte kolonner ytterst til høyre

  scalepos: Integer;
  initColWidth: Integer;

  fromDate,toDate: String;
  fromKl,toKl: Integer;
  fromDtm,toDtm: TdateTime;
  periodMins: Integer;
  days: Integer; //antall dager
  
  sheetName: String;
  sheetHead: String;

  barRestoreFunction: restoreFunction;
  barFillFunction: fillFunction;
  verticalFillFunction: verticalFunction;

  bkgOnEntireRow: Boolean;  //Brukes bl.a. når vaktkoder skal legges over hele linjen 

  scaleMinsPrUnit: Integer; //Antall minutte pr kolonne
  scaleUnitsPrDay: Integer; //Antall enheter/kolonner pr dag

  grpsView: Boolean;
 end;


 pCalDisp =^calDataDisp;


 resInfo = record
  seqid: Longint;
  dtm: TdateTime;
  prd: String;
  prodName: String;
  sgn: String;
  sgnName: String;
  dep: String;
  fac: String;
  fromKl,toKl: Integer;
  stat: Integer;
 end;

 pResInfo =^resInfo;

//




{$ENDIF SIGN}

 ARFLDS = array [1..MAXFLDS] of String;
 ARFLDI = array [1..MAXFLDS] of integer;
 ARKEYS = array [1..MAXKEYS] of String;

 pARFLDS = ^ARFLDS;
 pARFLDI = ^ARFLDI;


{$IFNDEF DVC}

hnrData = record
 dat: String;
 prd: String;
 dep: String;
 orgNr: String;
 IDnr: Integer;
 katID,kategori: String;
 vst,vend,vlen: Integer;
 mlen,vlim: Integer;

 vsats,msats,tsats: Integer;
 vsum,msum: Integer;
 totSum: Longint;
 depQry: Tquery;
end;

pHnr = ^hnrData;

//OBS: Denne kan ikke hete 'lartTyp' ! Da chrasher debugger !!!
lartTypDefs = record

 fldName: String;     //'LART_H1'
 code: String;        //1555
 refLart: String;     //1455
 lartTyp: String;      //H1
 lartTypID: Integer;  //1
 lrtPos: Integer;     //1

 value: Integer;
end;

pLartTyp = ^lartTypDefs;

lartTyps = array [0..MAX_LART_TYPS] of lartTypDefs;
pLartTyps = ^lartTyps;


lartDef = record
 code: String;   //Lønnartkode f.eks 1320
 desc: String;   //Beskrivelse
 units: String;  //Enehet (timer.minutt eller antall)
 rounds: String; //X hvis denne skal avrundes
 fname: String;  //Navn på felt i tabell L1,L2 osv
 fno: Integer;   //Felt-nummer i tabell
 rate: Integer;  //Ikke i bruk
 value: Integer; //Ikke i bruk
 stats: String;   //Settes til X for overtids-lønnarter
 colNo: Integer;  //Kolonne-nr på skjema
 group: Integer;  //Lønnart-gruppe. Settes til 1 for NRK og 2 for TV2
// lartTyp: Integer; //Lønnarttype H1,H2,D1,D2,YY = 1,2,3,4,5
 code_h1: String;  //alle høytidsdager unntatt jul og nyttår
 code_h2: String;  //jul og nyttår
 //code_d1: String;  //Lønnart for annet sats lav
 //code_d2: String;  //Lønnart for annet sats høy
 code_yy: String;  //Lønnart for fjoråret
 fromdate_yy: TdateTime;  //FraDato som 'code_yy' skal gjelde
 todate_yy: TdateTime;    //TilDato som 'code_yy' skal gjelde

 fromdate: TdateTime;  //Gyldig fra
 todate: TdateTime;    //Gyldig til

 fromkl: Integer;
 tokl: Integer;
end;


lartdefs = array [0..MAX_LARTS+1] of lartDef;
pLarts = ^lartdefs;

prodInfo = record

 dep: String;   //Avdelingskode

 prodNr: String;
 prodName: String;
 prodLoc: String;
 prodSname: String;
 prodID: Longint;
 prodResp: String;
 prodFirm: String;
 prodSeq: String;   //Episode

 producer: String;
 orderedBy: String;

 startDate: String;
 onAirDate: String;

 remark: String;

 projNo: Integer;
 prodNo: Integer;
 projYear: Integer;
 prodMet: String;      //Produksjonsmetode
 prodMetID: Longint;
 prodCnt: Integer;

 updDateTime: String;
 updDtm: TdateTime;
 updSign: String;

 requestID: String;  //Bestillingsnr
 bookID: String;     //Ordrenr

 recstat: Integer;  //Blir NEED_COMMIT_ på oppdaterte records hvis angrepunkt er satt
 stat: Integer;
end;


pProdInfo =^prodInfo;


lartStats = record

  Vk1: String;
  Vk2: String; //Mulig med 2 vaktkoder i filter for statistikk
  Code: String;
  Sign: String;

  Asum: Longint;  //Antall timer AVSP eller LTRK
  Vsum: Longint;  //Antall vakt-timer
  Xsum: Longint;  //Antall timer overtid
  Lsum: Longint;  //Antall timer for en bestemt lønnart

  VsumStd: Longint; //Antall vakttimer iflg. timer pr dag i en periode
  VsumTurnus: Longint; //Vakttimer i følge liste
  VsumDif: Longint; //Dif. VsumTurnus og aktuelt antall vakttimer

  prodNr: String;
  fromDate: String;
  toDate: String;
  days: Integer;
  weeks: Integer;

end;

pLstats =^lartStats;


timeDefs = record

  vk: String;
  stdVk: String; //Standard vakt
  yVk: String;  //Y-vakt
  xVk: String;  //X-vakt
  oVk: String;  //Opprinnelig vakt ved endring og ferie
  //lastVk: String; //Vaktkode før browser-valg av fraværs-kode
  dbVk: String;  //vaktkode i database før endring av Vkode
  dboVk: String;  //vaktkode i Okode ny 02.02.04
  pVk: String; //Kostnadsfordelt kode. Ny 18.05.04

  frvCode: String;  //Fraværskode
  frvCnt: Integer;  //Antall fravær pr dato

  //normLen: Integer; //Normalvakt lengde
  prc: Integer;  //Prosent av full stilling (normalt 100)
  vklen: Integer;
  offlen: Integer; //Pause. Ny 21.09.02

  vst: Integer;
  vend: Integer;
  vlen: Integer;
  vsum: Single;

  xst: Integer;
  xend: Integer;
  xlen: Integer;
  xsum: Single;
  xtype: Integer;   //X_FRONT,X_END eller X_SPLIT

  pst,pend,plen: Integer;  //Total arbeidstid inkludert overtid

  yst,yend,ylen: Integer;  //Brukes bare i PRiNS modul ved splittede Y-vakter

  rst: Integer;
  rend: Integer;

  mtime: Integer;
  ymtime: Integer; //Ny 05.09.03
  startSumY: Boolean; //Ny 05.09.03

  mInterval: Integer; //Hvis 0 skal det ikke beregnes mertid pr vakt
  mdate: String;   //Start beregning mertid
  mxfer: Integer; //Overført mertid
  inhibitMtime: Boolean; //TRUE hvis mertid ikke skal beregnes for aktuell vakt


  minPrDay: Integer;
  minPrWeek: Integer;
  fulltimeWeek: Integer; //Alltid 100% tid uansett prosent
  fulltimeDay: Integer;
  vtimeInWeek: Integer;  //Total tid i uke på liste
  notFullTimeByMove: Integer;  //Deltids-timer istedenfor overtid

  totSum: Longint;
  totmove: Integer;
  totx: Integer;
  xlimit: Integer;  //Brukes i endring for personer i redusert stilling
  scaledVlen: Integer; //Skalert vaktlengde der lønnarter er omregnet til minutter
  exprStr: String;     //Skalerings-formel
  cntStr: String;      //Antall som string
  txtStr: String;      //Tekst i Maconomy transaksjoner

  actCnt: Single;      //Antall som float
  actualCnt: Single;   //Actual fra PiF

  activity: String;     //Aktivitetskode f.eks. VBRED
  sgnActivity: String;  //Aktivitetskode i X98's Personell

  activityID: Integer;  //Aktivitets-ID  (AC_ID) = SeqID i X_PRODUKT
  actDesc: String;      //Beskrivelse av aktivitetskode
  phase: String;

  productID: String;  //Produkt-nr f.eks. TFBV000166
  productText: String;
  productRate: Real;   //Pris
  productFirm: String;       //Firma for produkt

  category: String;    //Produkt-kategori
  section: String;     //Produkt-seksjon

  firm: String;          //Filter firma
  prodNrfirm: String;    //Firma for prodnr

  dat: String;        //Aktuell dato
  regDate: TdateTime; //Registrert dato
  dayName: String;
  dep: String;
  id,id2,id3: String;
  sgn: String;
  ans: String;
  ansatt: Integer;
  ltrin: Integer;
  name: String;

  resID: Longint;     //Ressurs-ID
  resGrp: String;     //Ressurs-gruppe
  resIDstr: String;   //Ressurs-ID som string
  resLinked: Integer;
  resType: Integer; //Blir >0 hvis ressurs er utstyr

  vkLinked: Integer; //Blir >0 hvis vaktkode er splittet

  srtPos: Integer; //Sorterings-rekkefølge
  orgNr: String; //Organisasjons-nummer

  freeLance: String;
  nullEmpLart: Boolean;  //Ikke variabel lønn 08.10.2002
  nullEmpTreg: Boolean;  //Ikke timereg 08.10.2002
  avgturn: Boolean;      //TRUE hvis gjennomsnittberegnet

  item: Boolean; //blir TRUE hvis utstyr
  rateBased: Boolean;  //TRUE hvis bare timebetalt
  rateBasedX: Boolean;  //TRUE hvis timebetalte skal ha X etter full dag

  rate: Integer;
  artNr: Integer; //Kostnadsted i Honorar

  katID,kat: String;
  tsats,vsats: Integer;

  x50sum: Longint;
  x100sum: Longint;

  fromDate: String;
  toDate: String;

  //Disse tilhører alltid aktuell signatur
  sgnFromDate: TdateTime;
  sgnToDate: TdateTime;
  sgnDep: String;
  sgnID: String;

  filterDate: String;
  nearestDate: String;  //Settes til nærmeste Fra_Dato i xdm.getPersonData()

  fltFromDate: String;  //Periode fra
  fltToDate: String;    //Periode til
  fltSgn: String;       //Filter-sign
  fltDep: String;       //Filter-avdeling
  fltID: String;

  wdate: String;    //Siste helligdag før start på aktuell liste

  turnName: String;   //Turnus-navn
  turnStartDayNo: Integer;
  turnStartDate: String;
  turnEndDate: String;

  turnID: String;
  turnSort: Integer;
  turnSeqID: Longint;
  turnProdNr: String;     //ProdNr i turnus-møsnter. Ny 21.11.98

  funkSeqID: Integer;
  funkname: String;
  funk: String;

  showNullSort: Boolean;  //Ny 7/4-98

  signFlag: String; //blir + eller - for PLUS eller AVSP
  vkColor: Tcolor;

  range: Integer; //HIGH_ for helg/høytid og LOW_ for hverdager

  //frvNotExp: Boolean;  //TRUE hvis bare ikke eksportert fravær skal vises
  trxvk: Boolean;  //blir TRUE hvis kode gir lønnarter
  spec: Boolean;   //blirTRUE hvis kode skal spesifiseres
  fak: Boolean ; //TRUE hvis vaktkode skal telles opp i regnskap
  hypp: Integer;  //1 hvis vakt kvalifiserer for hyppig helg
  plusAvsp: Longint; //Antall minutter tilgode/skyldig

  fldColor,fontColor: Tcolor;

  s1,s2,s3: Single;
  seqID,xSeqID,xySeqID,pSeqID,rSeqID,pobSeqID: Longint;
  empSeqID: Longint;   //SeqID for aktuell record i Personell
  remSeqID: Longint;

  prodNr: String;
  prodName: String;
  ksted: String;
  intKsted: String;
  rem: String;

  lartTotSum: Longint;
  lartVsum: Longint;
  lartCode: String;
  lartTyp: String;   //Lønnart-type f.eks H1,H2
  lartStat: Integer;  //Brukes i avsp-konto for å signalisere 0-sum

  sgnQry: TQuery;   //Signaturdata
  vkQry: TQuery;    //Vaktkoder
  timeQry: TQuery;  //Vakttider
  xQry: Tquery;     //Overtids-oppgave
  codeQry: Tquery;  //Vaktkoder
  //depQry: Tquery;   //Avdelingskoder med rammetider. Flyttet til lartUnit 31.01.03
  turnQry: Tquery;  //Turnus-møsnter for aktuell person

  mode: Integer;  //Normalt 0, men settes til PRINS_ ved overføringer
  stat: Integer;  //Klar, Godkjent eller Inhibit
 end;


timeLimits = record

  limMorning: Integer;  //07.00

  limMorning_1: Integer;  //05.00 Ny 12.08.99
  limMorning_2: Integer;  //06.00 Ny 12.08.99

  limDayBreak: Integer; //09.00
  limEm: Integer;       //17.00
  limEvening: Integer;  //20.00
  limNight: Integer;    //23.00
  limWendStart: Integer; //18.00
  limMinWendX: Integer; // 2 t
  limMidNight: Integer;  //02.00
  limLangvakt: Integer;

  langVaktAvd: String;    //F.eks FTNE,FTSE, ...

  limU1: Integer;   //TV2 18.00-22.00
  limU2: Integer;   //TV2 22.00-06.00

  stepU: Integer;  //TV2 start ulempe etter 16 min

  limX1: Integer;   //TV2 overtid start mandag kl 00.01
  limX2: Integer;   //TV2 overtid start lørdag kl 00.01
  stepX1: Integer;  //TV2 X etter første 31 min
  stepX2: Integer;   //TV2 X hver 16 påbeynnte min

  limH: Integer;  //Tilslag for høytidssatser kl 13:00
  stepH: Integer; //Antall minutter etter 'limH' for at alt skal bli 100%

  rtil_len: Integer; //Minimum legnde for på reise for å få reisetillegg
  rtil_step: Integer; //Antall timer etter 24 t for å få nytt reisetillegg
  rtil_fromkl: Integer;  //
  rtil_tokl: Integer;  //
  rtil_night_hrs: Integer; //Minimum antall timer mellom 22 - 07 

  //Nye tillegg etter lønnsoppgjør 2003
{
  kveld1_fromkl: Integer;
  kveld1_tokl: Integer;
  kveld2_fromkl: Integer;
  kveld2_tokl: Integer;

  natt1_fromkl: Integer;
  natt1_tokl: Integer;
  natt2_fromkl: Integer;
  natt2_tokl: Integer;

  morgen1_fromkl: Integer;
  morgen1_tokl: Integer;
  morgen2_fromkl: Integer;
  morgen2_tokl: Integer;
}

 end;


 rateDefs = record

  factorNormal: Single;
  factorEvening: Single;
  factorNight: Single;
  factorOvertime: Single;
  factorWeekend: Single;
  factorHoly: Single;

 end;

 pTimes =^timeDefs;
 pRdefs =^rateDefs;
 pLimits = ^timeLimits;


 vTimeData = record
  vk: String;
  pid: String;
  prd: String;

  vst: Integer;
  vend: Integer;
  vlen: Integer;

  xst: Integer;
  xend: Integer;
  xlen: Integer;

  offlen: Integer; //Pause

  stat: Integer;
 end;

vtd = array [1..MAX_VTD] of vTimeData;

pVtd =^vtd;

moveDefs = record

 origV1st,origV1end,origV2st,origV2end: Integer;
 v1St,v1End,v2St,v2End: Integer;   //Fra/til-vakt tider
 v1Len,v2len,ovLen: Integer;
 endrSt,endrEnd,endrLen: Integer;
 xSt,xEnd: Integer;
 xSplit: Integer; //Blir ONX hvis X skal splittes i for- og bakkant
 vdif,moveType: Integer;
 ovSt,ovEnd: Integer;    //Overlapp

 epos50st,epos100st,xpos50st,xpos100st: Integer;
 epos50end,epos100end,xpos50end,xpos100end: Integer;
 end50,end100,xx50,xx100,xlen: Integer;

 range: Integer; //HIGH_ for helg/høytid og LOW_ for hverdager
end;

pMoves =  ^moveDefs;


pnlObj = record

 pnlRect: Tshape;
 pnl: Tpanel;
 x,y: Integer;
 pos: Integer;
 color: Tcolor;
 text: String;
 mode: Integer;
 width: Integer;
 height: Integer;
 left: Integer;
 top: Integer;

 difFromKl,fromKl: Integer;
 difToKl,toKl: Integer;
 dif: Integer;

 offset: Integer;
 scale: Single;
 id: Integer;
end;

pPnlObj = ^pnlObj;


// pXtblLoc = ^xtblLocData;

 names = array[1..MAX_ARTISTS,1..2] of String;



  BrowserDef = record
   defTableName: String;  //Navn på tabell med browser defs (BROWSERS.DB)
   fldTableName: String;  //Navn på tabell med felt som har browsere
   SQL: string;
   QdataBase: String;   //Database som Qtable ligger i
   QTable: String;    //Søk fra QTable
   QFields: String;  //Hvilke felt som returneres i SELECT
   Keyflds: String;  //Hvilke felt som det søkes i
   Keys: String;      //Søkekrav
   Seqfld: Integer;     //Kolonne-nr på felt med SeqID
   SeqIDfld: String;            //Navn på felt med SeqID
   SeqID: LongInt;       //SeqID verdi/key
   orderFld: String;  //Sorteringsfelt
   recnr: Longint;        //Aktuell recordnr/pos.
   match: Longint;        //Antall forekomster
   gridOffset: Integer;   //Antall grid-rows i forhold til match
   visibleColWidth: Integer;
   selectCount: Integer;      //Antall valgte records
   fldcnt: Byte;      //Antall felt i match-tabell/query
   destFldCnt: Integer;     //Antall felt i retur
   browserNo: Integer;      //Browser-no i BROWSERS.DB
   selected: Integer;   //ONX etter valg i browser med ENTER el. dobbelclick
   colwidth: string;  //Kolonne bredder (f.eks 200,200,150)
   x,y,w,h: Integer;     //Posisjon for browser-form
   stat: Integer;        //Div
  end;


 browserData = record

   flds:  ARFLDS;     //Felt-data innhold
   fld:   ARFLDS;  //Navn på felt fra SELECT
   dest:  ARFLDS; //Navn på felt som 'flds' skal til
   width: ARFLDI; //Bredde på kolonner
  stat: Integer;   //Div
 end;

    //Record buffer pr felt ( trx[] )
  recbuf = record
   fname: String;    //Felt-navn (som også ligger i fieldDef.items[].name
   data: String;    //verdi
   typ: TfieldType;

   dspObj: Tobject;  //Felt-object i skjema
   dspTyp: Integer;      //TIME_FLD, STR_FLD,NUM_FLD eller MEM_FLD
   dspFld: Integer;   //ONX hvis felt finnes i skjema
   tag: Integer;
  end;

  cpybuf = record
   fname: String;    //Felt-navn (som også ligger i fieldDef.items[].name
   data: String;       //verdi
   typ: TfieldType;

   dspObj: Tobject;
   dspTyp: Integer;
   dspFld: Integer;
   tag: Integer;
  end;

  compositeKeyData = record
   fname: String;    //Felt-navn (som også ligger i fieldDef.items[].name
   data: String;    //verdi
   typ: TfieldType;  //datatype
   opr: String;     //operator
   lnk: String;     //AND, OR
   stat: Integer;   //Diverse tag
  end;


{
sortData = record

 fname: ARKEYS;
 Pflds:  PWORD; //array [1..MAXKEY] of Word;
  flds: array [1..MAXKEYS] of Word; //OBS: MÅ være Word, hvis ikke feiler sortering
 PinCase: PBOOL; //array [1..MAXKEY] of BOOL;
  inCase: array [1..MAXKEYS] of BOOL;
 Porder:  pSortOrder; //array [1..MAXKEY] of Integer;
  order: array [1..MAXKEYS] of sortOrder;
 Pfns: ppfSORTCompFn;
  fns: array [1..MAXKEYS] of pfSORTCompFn;
 srtRecCnt: Longint;
 srtFldCnt: Integer;
 srcTbl: TDBdataSet;
 destTbl: TTable;
 pTblDesc: pCRTblDesc;
end;
}

 qrData = Record

  fld: ARKEYS;  //Felt-navn
  key: ARKEYS;  //Key-data
  srt: ARKEYS;  //Sorterings-felt
  opr: ARKEYS;   //operator
  lnk: ARKEYS;  //Kominasjon (AND,OR,NOT)
  qryTyp: ARFLDI;   //hvis EXACT_ (106) i feltets tag-property, ikke bruk LIKE
  keyMode: ARFLDI; //1 hvis compositeKey, ellers 0

  fdef: array [1..MAXKEYS] of Tfield;

  flds: String;   //Komma-separert felt-string
  keys: String;        //Komma-separert key-string
  keyCnt: Byte;    //Antall utfyllte keyfelt
  totMatch: Longint;      //Antall forekomster

  onTbl: TDBdataSet;     //Hvilken tabell det skal søkes fra
  toTbl: TDBdataSet;     //Hvilken tabell som result-set skal til
  stat:  Integer;   //Div. Skal ikke brukes logikk.
 end;

//OBS: denne data-strukturen brukes bare som bindeledd mellom
// tabellen med key-data (#+<tablename>) og struktur qr.[] (query).
// keyData er strengt tatt ikke nødvendig annet enn for bekvemlighet ....
 keyData = Record

  fname: String;
  keys: String;
  opr:  String;
  lnk:  String;
  fno: Byte;
  stat: Integer;
 end;


  //navn og innhold i felt Tfld,Tlbfld og TmemoFld;
  wctrls = Record

   ctrl: array [0..2] of Twincontrol;
   idx: Integer;
   data: String;          //Data innhold som text
   fldName: String;  //Felt-navn
  end;
{
  colors = Record

   Active: TColor;
   Busy: Tcolor;
   Inactive: Tcolor;
   Rec: Tcolor;
  end;
 }

  formFlds = record
   fname: String;      //Felt-navn
   comp: Tobject; //Component-type (Tfld,TcomboFld,TmemoFld)
   no: Integer;          //Felt-nr i tabellstruktur
   fDef: Tfield; //Pointer til feltdata ( fra fieldDefs)
   fld: Tedit;
  end;

selectdata = record
 fldName: String;
 colw: Integer;
 colTitle: String;
 fno: Integer;
 fldType: TfieldType;
 dset: TDBdataset;
end;

pSelectData = ^SelectData;


PFLDS = array [1..MAXFLDS] of formFlds;
pPFLDS = ^PFLDS;
QRYKEY   = array [1..MAXKEYS] of compositeKeyData;
pQRYKEY = ^QRYKEY;


formDef = record
 frm: Tform;      //self
 fields: PFLDS;   //Array for felt-navn
 fldCnt: Byte;    //Antall felt i skjermbilde
 tblFldCnt: Byte;    //Antall felt i liste/match-tabell
 fname: String;   //Aktivt felt-navn
 fdata: String;   //Aktiv felt-data som text
 tblname: String;  //SQL-tabellnavn
 grid: TcustomGrid;  //Delphi grid
 lSrc: TdataSource;
 //lTbl: TDBdataSet;    //Liste-tabell
 //mTbl: TDBdataSet;    //Master-tabell
 dset: Tdataset;

 //wwTbl: TwwTable;
 //wwSrc: TwwDataSource;

 compositeKeyCnt: Integer;   //Antall felt som alltid kombineres i søk
 compositeKeys: QRYKEY;       //Array med feltdat-records
 cnctDisable: Integer;      //ONX hvis forms connectFrm() skal utføres
 sumFldCnt: Integer;  //Antall sum felt
 mnuItem: TmenuItem;
 deleteInhibit: Boolean; //Ctrl-Delete utkoblet

 cols: array [0..MAX_GRID_COLS] of selectData;

 datamodified: Boolean;  //TRUE hvis noe er endret
 newrec: Boolean;  //Hvis ny record er lagt inn

 stat: Integer;
end;

FRMS = formDef;
pFRMS =^formDef;

//connectFn = function (cmd: Integer): Integer of Object;

//etter blank liste (F9)
blankProcedure =  procedure (Sender: TObject; cmd: Integer) of Object;

//etter søk og lagre
refreshFunction = function (cmd: Integer): Integer of Object;

//etter bekreft
afterCommitFunction = function (cmd: Integer): Integer of Object;

//henter default data i skjermbilde
getDefaultProcedure = procedure of object;

//viser default data i skjermbilde
showDefaultProcedure = procedure of object;

//browser-funksjon. Ikke i bruk for X98
browseProcessFunction = function (str: String; value: Longint): Integer of Object;

//valideringsfunksjon FØR lagre
validCheckFunction = function (cmd: Integer): Integer of object;

//ETTER lagre og slette
updateFunction = function (cmd: Integer): Integer of Object;

//FØR slette
deleteFunction = function (cmd: Integer): Integer of object;

//etter visning av data i felt fra aktuell record (listSrcDataChange)
displayProcedure = procedure (fname,fdata: string) of object;

//Innlasting av felt fra skjermbilde i copyFldsToTrx
recordFieldFunction = function (fname,fdata: string): String of object;

//Etter copyFldsToTbl i recFrm.processMasterTbl
//Brukes for å lagre data som ikke ligger i felt for valgt skjermbilde
tableDataFunction = function (dset: TDBdataSet; cmd: Integer): Integer of object;

recordProcedure = procedure (fname,fdata: string) of object;

//FØR søk. Brukes for å sette opp tilleggsparameter eller formattering
beforeQueryFunction = function (fname,fdata: String; cmd: Integer): Integer of object;
afterQueryFunction = function (cmd: Integer): Integer of object;


gridTitles = array [0..MAX_GRID_COLS] of String;
gridColumns = array [0..MAX_GRID_COLS] of Tcolumn;
gridFields =array [0..MAX_GRID_COLS] of Tfield;

gridData = record
 columns: TDBgridColumns;
 colw: ARFLDI;
 dataSource: TdataSource;
 selectedIndex: Integer;
 selectedField: Tfield;
 fields: gridFields;
 fieldCount: Integer;
 color: Tcolor;
 font: Tfont;
 titleFont: Tfont;

 //Ny 14/4-98
 gridColCnt: Integer;
end;

pGridData =^griddata;



//********* lnk. *********************
//Brukes til inerface mellom MDI-main og MDI-child
frmInterFace = Record

  sessionName: String;     //main-session
  moduleName: String;  //Navn på aktiv modul
  mappingModule: String;  //Navn modul i mapping tabell

  pForms:  pFRMS;        //pointer til aktuell forms's frmDef
  frm: Tform;            //Aktuell form
  topFrm: Tform;     //Aktiv modal-form

  lTableName: String;  //Match-tabell
  mTableName: String;  //Master-tabell
  tbl_name: String;      //SQL-tabellnavn

  pos: Longint;         //Pos i liste
  match: Longint;       //Antall match etter søk. Blir IKKE 0 hvis søk gir 0
  qryMatch: Longint;    //Match etter søk. Kan bli 0
  resultMode: Integer;   //Om resultat-set skal ligge på local tabell eller fra SQL-server

  brMatch: Longint;    //Match i browser
  loaded: Integer;   //Blir ONX etter at record er lastet inn
  blankMode: Integer;  //Blir ONX ved F9 (blank)

  seqID: Longint;
  //seqIDfname: String;

  dat: String;    //Dato
  sgn: String;   //Signatur for aktiverig av søk

  lTblSize: LongInt;   //Size i byte for pforms.lTbl
  lTblPath: String;    //Full path med tabell-navn

  eof: Boolean;     //Settes til TRUE når fokus er utenfor siste record

  dataType: TfieldType;    //Data-type f.eks ftString,ftDate
  activeFld: Tcomponent;  //Aktivt felt
  defaultFieldName: String;   //felt som har focus ved start og etter save
  frmCnt: Integer;    //Antall forms aktiv

  mnuItem: TmenuItem;    //Pointer til meny for valgt modul
  mnuRepItem: TmenuItem;    //Pointer til rapport-meny for valgt modul

  touched: Boolean;         //ONX hvis et av feltene er endret
  keyChar: Char;   //Tegn ved siste tastetrykk
  keyWord: Integer;    //Siste tastetrykk (key)
  keyState: TshiftState; //shift-state ved siste tastetrykk
 // keyDirect:  Byte;   //ONX hvis mapKeyStroke() har utført "noe" via Ctrl aller ALt

  changedData: Boolean;     //ONX hvis records er nye/endret
  keyMapped: Boolean;   //ONX hvis tasterykk er mappet til noe annet
  noConfirm: Boolean;   //Hvis ONX kommer ikke varsel ved sletting
  noValidCheck: Boolean;  //Sjekker ikke validFunc
  forceEventLog: Boolean; //Skriver til event logg uansett
  closing: Boolean; //ONX etter trykk på ESC i hver modul

  bookMode: Integer;   //ARTIST eller ITEMS

  secOrder: String;  //Ekstra sorteringsfelt satt i aktuell modul

  blankProc: blankProcedure;    //Blanker div data i aktuell form
  refreshFunc: refreshFunction; //Refresh data i andre forms
  afterCommitFunc: afterCommitFunction; //Refresh data i andre forms

  getDefProc: getDefaultProcedure;  //laster inn default data
  showDefProc: showDefaultProcedure;//viser default data
  browseFunc: browseProcessFunction;  //Intern prosessering av browser-data
  validFunc: validCheckFunction;      //Valideringssjekk
  updateFunc: updateFunction;     //Oppdaterer div data
  deleteFunc: deleteFunction;     //Sletter bl.a. link-data
  displayProc: displayProcedure;  //Viser f.eks tids-felt (lagret som min) som hh.mm
  recordFieldFunc: recordFieldFunction;
  recordProc: recordProcedure;
  tableDataFunc: tableDataFunction;
  HTMLcellFunc: HTMLtableCellFunction;
  beforeQueryFunc: beforeQueryFunction;
  afterQueryFunc: afterQueryFunction;

  bMode: TbatchMode;
  qry: Tquery;
  grid: TcustomGrid;
  pgCtrl: TpageControl;
  dset,dbset,navigSet: TDBdataset;
  errors: Integer;
  localMode: Boolean;

  droppedDown: Boolean;
  dropDown: Boolean;   //ONX når drop Down lister vises

  xt: pTimes;   //Pointer til struktur for persondata

  previewDset: TDBdataset;   //Dataset som går til preview


  //Prod-navn eller person-navn fra Formula
  fmTxt,fmDesc: String;
  fmFromDate,fmToDate: String;
  prodName: String;

  tmpString: String;
 end;


 mapTableData = record
  lTblName: String;  //Match-tabell
  mTblName: String;  //Master-tabell
  dbName: String;      //Database-navn
  synonym: String;     //For SQL-tabeller
  //batchMode: Integer;       //Brukes ved batchMove til master
  SQLbased: Integer;    //1 for SQL-tabeller, ellers 0
  tblTyp: Integer; //tabell-type Paradox/ORACLE
 end;

 sumStruct = record
  fname: String;
  fno: Integer;
  sum: Single;
  prec: Integer;    //Antall siffer etter komma
 end;

 SumData = array [1..MAXFLDS] of SumStruct;
 pSumData = ^SumData;

 bookData = record
  id: String;
  item: String;

  errCnt: Integer;
  pos: Integer;

  requestCnt: Integer;
  totCnt: Integer;
  reservedCnt:Integer;
  outCnt: Integer;
  difCnt: Integer;

  sumReserved: Integer;
  sumOut: Integer;
  sumHooked: Integer;     //Sum tildelt + utlevert
  sumAvail: Integer;  //Tilgengelig av ID for ny booking
  lockedCnt: Integer; //Antall records som allerede er tildelt/ute
  processed: Integer; //Antall behandlet på liste

  listIdFldno: Integer;
  listItemFldno: Integer;
  listRequestFldno: Integer;
  listReservedFldno: Integer;
  listOutFldno: Integer;
  listReturnFldno: Integer;
  listStatusFldno: Integer;

  itemIdFldno: Integer;
  itemItemFldno:Integer;
  itemTypsFldno: Integer;
  itemCountFldno: Integer;
  itemInhibitFldno: Integer;
  itemInhibit: Integer;

  dateQryRequestFldno: Integer;
  dateQryReservedFldno: Integer;
  dateQryOutFldno: Integer;
  dateQryReturnFldno: Integer;
  dateQryIdFldno: Integer;

  fromDate: String;
  toDate: String;
  prodNr: String;
  prodName: String;


  mode: Integer;   //1 ved InsideDates, 2 ved OutsideDates
 end;

  bookCnt = record
   id: String;
   //total: Integer;
   //avail: Integer;
   request: Integer;
   reserved: Integer;
   out: Integer;
   //ret: Intger;

  end;

 {$ENDIF}


 iniFileSections = array [1..MAXINISECTIONS] of String;

 printSetups = record
  repTitle: String;
  repInfo: Tmemo;
  repFoot: String;
  repName: String;
  repDate: String;
  repTime: String;
  repUser: String;

  topMargin: Integer;
  leftMargin: Integer;
  rightMargin: Integer;
  bottomMargin: Integer;
  lineSpace: Integer;
  colSpace: Integer;

  maxWidth: Integer;
  maxHeight: Integer;
  maxLines: Integer;
  actualWidth: Integer;

  orient:  TPrinterOrientation;
  orientMode: Integer;   //Hvis 0 brukes setting i ini-fil
  copies: Integer;

  titleFont: Tfont;
  infoFont: Tfont;
  colFont: Tfont;
  recFont: Tfont;
  sumFont: Tfont;
  footFont: Tfont;

  bkgColor: Tcolor;

  sumEnable: Integer;
  recNoEnable: Integer;
  colCnt: Integer;    //Antall kolonner ved listeprint

  recOffset: Integer;    //Ofsett fram til felt pgr recNo først

  sumfldStr: String; //Ny 02.02.04
  sumFlds: ARFLDS;   //Ny 02.02.04

  stat: Integer;
end;

  pPrtSets = ^printSetups;


  //For pbar paneler
    TICCEx = record
                 dwSize: DWord;
                 dwFlags: DWord;
             end;

    TRebarInfo = record
                     cbSize: UInt;
                     fMask: UInt;
                     fStyle: UInt;
                     himl: HImageList;
                     hbmBack: HBitmap;
                 end;

    TRebarBandInfo = record
                         cbSize: UInt;
                         fMask: UInt;
                         fStyle: UInt;
                         clrFore: TColorRef;
                         clrBack: TColorRef;
                         lpText: PChar;
                         cch: UInt;
                         iImage: Integer;
                         hWndChild: hWnd;
                         cxMinChild: UInt;
                         cyMinChild: UInt;
                         cx: UInt;
                         hbmBack: hBitmap;
                         wID: UInt;
                     end;

//Repetisjons-buffer 
  repeatBuf = record
   dat: String;
   fraDato,tilDato: STring;
   fraKl,tilKl: String;
   vfra,vtil,xfra,xtil: String;
   vkode: String;
   fasilitet: String;

   sgn: String;
   res: String;
   prodNr: String;
   act: String;
   actID: String;
   cnt: String;
   txt: String;

  end;


 {$IFDEF LNRK}

  lnSumData = record
   Aln: Longint;
   Aplus: Longint;
   AtotLn: Longint;

   Bln: Longint;
   Bansplus: Longint;
   BansLn: Longint;
   BStPlus: Longint; //Tillegg iflg. stillingskode
   Btotln: Longint;
   Pln: Longint;   //Personlig tillegg pr år

   Xdif: Longint;
   totXdif: Longint;
   minusXdif: Longint;
   plusXdif: Longint;
   plusXdifCnt: Integer;
   minusXdifCnt: Integer;

   ABXsum: Longint;   //Lokal variable
   //ABplusSum: Longint;

   qry: Tquery;
  end;

  pLnSumData = ^lnSumData;

  lnListData = record
   checked: Boolean;
   data: String;
  end;


  lnLists = array[0..8] of lnListData;


{$ENDIF}


//*************** OBS OBS ******************************
//Her er ekstern variable for ALLE moduler !!!
//******************************************************
var
  typFrm: TtypFrm;
{$IFNDEF DVC}
  lnk: frmInterFace;   //Inerface mellom MDI-main og MDI-child
  mtd: mapTableData;   //Variable i forbindelse med tabell-mapping
{$ENDIF}
  tobj: Tobject;



  {$R *.DFM}

implementation


procedure TtypFrm.setProgramVersion(prgver: String);
begin

 //'progrVer' er global variabel
 progrVer :=prgVer;

end;

procedure TtypFrm.drawRect(canv: Tcanvas;x,y,w,h: Integer; width: Integer;color: Tcolor);
begin
  Canv.Pen.Width := width;
  Canv.Pen.Style := psSolid;
  Canv.Pen.Color := color;

  Canv.PolyLine([Point(x, y), Point((x+w),y), Point((x+w), (y+h)),
    Point((x),(y+h)), Point(x,y)]);

end;

procedure TtypFrm.setCursorState(cmd: Integer);
begin

 if cmd=PROGRES_ then
  screen.cursor :=crHourGlass;

 if cmd=OFF then
  screen.cursor :=crDefault;


end;



function TtypFrm.triggInhibit(cmd: Integer): Integer;
begin

case cmd of

 ONX:
  triggFlag :=ONX;

 OFF:
  triggFlag :=OFF;

end;

  Result :=triggFlag;

end;



function TtypFrm.recInhibit(cmd: Integer): Integer;
begin

case cmd of

 ONX:
  recInhibitFlag :=ONX;

 OFF:
  recInhibitFlag :=OFF;

end;

  Result :=recInhibitFlag;

end;

function TtypFrm.refreshLocaleFormats: Boolean;
begin
 Result :=FALSE;


 if dateSeparator<>DOT then
 begin
  dateSeparator :=DOT;
  Result :=TRUE;
 end;

 if shortDateFormat<>SHORT_DATE_FMT then
 begin
  shortDateFormat :=SHORT_DATE_FMT;
  Result :=TRUE;
 end;

 if decimalSeparator<>COMMA then
 begin
  decimalSeparator :=COMMA;
  Result :=TRUE;
 end;


end;


function TtypFrm.setLocaleFormats(fmt: String): String;
var
 oldStrFmt: String;
 //newFmt: Pchar;
 //oldFmt: array [0..16] of char;
 //rt: Boolean;
begin
 oldStrFmt :=NUL;
 //Result :=oldStrFmt;

 //Delphi-variable i SysUtils
 dateSeparator :=DOT;
 shortDateFormat :=SHORT_DATE_FMT;  //Definert lenger opp
 decimalSeparator :=COMMA;

{
 oldFmt :=#0;
 newFmt :=#0;

 newFmt :=DOT;
 //Dato-separator må være punktum
 rt :=setLocaleInfo(LOCALE_USER_DEFAULT,
               LOCALE_SDATE,
               newFmt);


 //Sjekk gammel verdi
 getLocaleInfo(LOCALE_USER_DEFAULT,
               LOCALE_SSHORTDATE,
               oldFmt,12);



 //Pass på at det er riktig datoformat
 oldStrFmt :=strPas(oldFmt);
 if (pos('å',oldStrFmt)>0) OR (pos('Å',oldStrFmt)>0) then
  newFmt :='dd.MM.åå'
 else
  newFmt :=SHORT_DATE_MASK;



 //Dato-format
 rt :=setLocaleInfo(LOCALE_USER_DEFAULT,
               LOCALE_SSHORTDATE,
               newFmt);

 newFmt :=COMMA;
 //Desimal-separator må være komma !
 rt :=setLocaleInfo(LOCALE_USER_DEFAULT,
               LOCALE_SDECIMAL,
               newFmt);

}



 Result :=oldStrFmt;
end;



procedure TtypFrm.FormCreate(Sender: TObject);
begin
 inhibit_db :=FALSE;

 operation :=0;

 userMode :=READONLY_;

 btnCol.Active :=clTeal;
 btnCol.InActive :=clBtnFace;
 btnCol.Busy :=clBlue;
 btnCol.Rec :=clRed;


 {$IFNDEF DVC}
 lnk.touched :=FALSE;
 //lnk.seqIDfname :=SEQID_FLD;
 lnk.pos :=0;
 lnk.match :=0;
 {$ENDIF}

// drives[0] :='C';

 drives[0] :=':';
 drives[1] :='A';
 drives[2] :='B';
 drives[3] :='C';
 drives[4] :='D';
 drives[5] :='E';
 drives[6] :='F';
 drives[7] :='G';
 drives[8] :='H';
 drives[9] :='I';
 drives[10] :='J';
 drives[11] :='K';
 drives[12] :='L';
 drives[13] :='M';
 drives[14] :='N';
 drives[15] :='O';
 drives[17] :='P';
 drives[18] :='Q';
 drives[19] :='R';
 drives[20] :='S';
 drives[21] :='T';
 drives[22] :='U';
 drives[23] :='V';
 drives[24] :='W';
 drives[25] :='X';
 drives[26] :='Y';
 drives[27] :='Z';
 drives[28] :=' ';
 {
 with  xtblloc.db do
 begin
  sessionName :='MS1';
  loginPrompt :=FALSE;
  connected :=FALSE;
 end;
 }
end;



initialization
  typFrm :=TtypFrm.create(typFrm);
  if typFrm =nil then
   halt;


end.
