unit UPDATE_LOG_FORM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Windows, LazUTF8, LazFileUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function FileVersion(AFileName: string): string;
  private
    { private declarations }
  public
    updatePATH: String;
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

function GetFileVersion(FileName: String; var VerInfo: TVSFixedFileInfo): boolean;
var
  InfoSize, puLen: DWORD;
  Pt, InfoPtr: Pointer;
begin
  InfoSize := GetFileVersionInfoSize (PChar(FileName), puLen);
  FillChar(VerInfo, SizeOf(TVSFixedFileInfo), 0);
  if InfoSize > 0 then
  begin
    GetMem(Pt, InfoSize);
    GetFileVersionInfo(PChar(FileName), 0, InfoSize, Pt);
    VerQueryValue(Pt, '\', InfoPtr, puLen);
    Move(InfoPtr^, VerInfo, sizeof(TVSFixedFileInfo));
    FreeMem(Pt);
    Result := True;
  end
  else
    Result := False;
end;

function ShowVersion(FileName: String): String;
var
  VerInfo: TVSFIXEDFILEINFO;
begin
  if GetFileVersion((FileName), VerInfo) then
    Result := Format ('%u.%u.%u.%u', [HiWord(VerInfo.dwProductVersionMS),
      LoWord(VerInfo.dwProductVersionMS), HiWord(VerInfo.dwProductVersionLS),
      LoWord(VerInfo.dwProductVersionLS)])
  else
    Result := '------';
end;

function TMainForm.FileVersion(AFileName: string): string;
var
  szName: array[0..255] of Char;
  P: Pointer;
  Value: Pointer;
  Len: UINT;
  GetTranslationString: string;
  FFileName: PChar;
  FValid: boolean;
  FSize: DWORD;
  FHandle: DWORD;
  FBuffer: PChar;
begin
  try
    FFileName := StrPCopy(StrAlloc(Length(AFileName) + 1), AFileName);
    FValid := False;
    FSize := GetFileVersionInfoSize(FFileName, FHandle);
    if FSize > 0 then
    try
      GetMem(FBuffer, FSize);
      FValid := GetFileVersionInfo(FFileName, FHandle, FSize, FBuffer);
    except
      FValid := False;
      raise;
    end;
    Result := '';
    if FValid then
      VerQueryValue(FBuffer, '\VarFileInfo\Translation', p, Len)
    else
      p := nil;
    if P <> nil then
      GetTranslationString := IntToHex(MakeLong(HiWord(Longint(P^)),
        LoWord(Longint(P^))), 8);
    if FValid then
    begin
      StrPCopy(szName, '\StringFileInfo\' + GetTranslationString +
        '\FileVersion');
      if VerQueryValue(FBuffer, szName, Value, Len) then
        Result := StrPas(PChar(Value));
    end;
  finally
    try
      if FBuffer <> nil then
        FreeMem(FBuffer, FSize);
    except
    end;
    try
      StrDispose(FFileName);
    except
    end;
  end;
end;


{ TMainForm }

procedure TMainForm.FormShow(Sender: TObject);
begin
{$IFDEF UNIX}
  updatePATH := '/etc/EWLog/';
    {$ELSE}
  updatePATH := 'C:' + SysUtils.GetEnvironmentVariable('HOMEPATH') + '\EWLog\';
    {$ENDIF UNIX}
  Label4.Caption := ShowVersion('EWLog.exe');

  Label5.Caption := ShowVersion(UTF8ToWinCP(updatePATH+'updates\EWLog.exe'));

  if (Label4.Caption <> Label5.Caption) and (Label5.Caption <> '------') then
  begin
    Label7.Caption := 'Требуется обновление';
    Button1.Caption := 'Обновить';
  end
  else
  begin
    Label7.Caption := 'Обновление не требуется';
    Button1.Caption := 'Выход';
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if Button1.Caption = 'Обновить' then
  begin
    WinExec(PAnsiChar('TASKKILL /F /IM EWLog.exe'), SW_HIDE);
    Sleep(1000);
    if (FileUtil.CopyFile(updatePATH+'updates\EWLog.exe', 'EWLog.exe', True, True)) and (FileUtil.CopyFile(updatePATH+'updates\serviceLOG.db', updatePATH+'serviceLOG.db', True, True)) then
    begin
      label7.Caption := 'Успешно';
      Button1.Caption := 'Выход';
      DeleteFileUTF8(updatePATH+'updates\EWLog.exe');
      DeleteFileUTF8(updatePATH+'updates\serviceLOG.db');
      Label4.Caption := ShowVersion('EWLog.exe');
    end
    else
      label7.Caption := 'Что то пошло не так...';
  end
  else
    MainForm.Close;
end;

end.