{   MPlayer frontend for Windows

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShellAPI;

type
  TfrmAbout = class(TForm)
    PLogo: TPanel;
    ILogo: TImage;
    Version: TLabel;
    VersionMPlayer: TLabel;
    BClose: TButton;
    MCredits: TMemo;
    LVersionMPlayer: TLabel;
    LVersion: TLabel;
    MTitle: TMemo;
    LURL: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure URLClick(Sender: TObject);
    procedure ReadOnlyItemEnter(Sender: TObject);
  private
    { Private declarations }
  protected
  public
    { Public declarations }
  end;

procedure ShowAboutForm;

implementation

uses mainfrm, mplayer_lib;

{$R *.dfm}

function GetProductVersion(const FileName: string): string;
const
   BufSize = 1024 * 1024;
var
   Buf: array of char;
   VerOut: PChar;
   VerLen:cardinal;
begin
Result := '?';
SetLength(Buf, BufSize);
if not GetFileVersionInfo(PChar(FileName), 0, BufSize,@Buf[0]) then Exit;
if not VerQueryValue(@Buf[0], '\StringFileInfo\000004B0\ProductVersion', Pointer(VerOut), VerLen) then Exit;
Result := VerOut;
end;

function GetFileVersion(const FileName: string): string;
const
   BufSize = 1024 * 1024;
var
  Buf: array of char;
  VerLen: cardinal;
  Info: ^VS_FIXEDFILEINFO;
  Attributes:string;
begin
Result := '?';
SetLength(Buf, BufSize);
if not GetFileVersionInfo(PChar(FileName), 0, BufSize, @Buf[0]) then Exit;
if not VerQueryValue(@Buf[0], '\', Pointer(Info), VerLen) then Exit;
Result := IntToStr(Info.dwFileVersionMS SHR 16) + '.' +
          IntToStr(Info.dwFileVersionMS AND $FFFF) + '.' +
          IntToStr(Info.dwFileVersionLS SHR 16) + ' build ' +
          IntToStr(Info.dwFileVersionLS AND $FFFF);
Attributes := '';
if (Info.dwFileFlags AND VS_FF_PATCHED <> 0) then Attributes := Attributes + ' patched';
if (Info.dwFileFlags AND VS_FF_DEBUG <> 0) then Attributes := Attributes + ' debug';
if (Info.dwFileFlags AND VS_FF_PRIVATEBUILD <> 0) then Attributes := Attributes + ' private';
if (Info.dwFileFlags AND VS_FF_SPECIALBUILD <> 0) then Attributes := Attributes + ' special';
if (Info.dwFileFlags AND VS_FF_PRERELEASE <> 0) then Attributes := Attributes + ' pre-release';
if length(Attributes) > 0 then Result := Result + ' (' + Copy(Attributes, 2, 100) + ')';
end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
VersionMPlayer.Caption := GetProductVersion(frmMain.MPlayer.MPlayerPath + PathDelim + MPLAYEREXENAME);
Version.Caption := GetFileVersion(Application.ExeName);
ActiveControl := BClose;
end;

procedure TfrmAbout.BCloseClick(Sender: TObject);
begin
Close;
end;

procedure TfrmAbout.URLClick(Sender: TObject);
begin
ShellExecute(Handle, 'open', PChar((Sender as TLabel).Caption), nil, nil, SW_SHOW);
end;

procedure TfrmAbout.ReadOnlyItemEnter(Sender: TObject);
begin
ActiveControl := BClose;
end;

{ ShowAboutForm }

procedure ShowAboutForm;
var
   frmAbout: TfrmAbout;
begin
frmAbout := TfrmAbout.Create(nil);
try
frmAbout.ShowModal;

   finally
   frmAbout.Free;
   end;
end;

end.
