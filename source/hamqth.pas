(***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License.        *
 *   Author Vladimir Karpenko (EW8BAK)                                     *
 *                                                                         *
 ***************************************************************************)

unit hamqth;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}
  CThreads,
  {$ENDIF}
  Classes, SysUtils, strutils, qso_record, fphttpclient;

resourcestring
  rAnswerServer = 'Server response:';
  rErrorSendingSata = 'Error sending data';
  rRecordAddedSuccessfully = 'Record added successfully';
  rNoEntryAdded = 'No entry added! Perhaps a duplicate!';
  rUnknownUser = 'Unknown user! See settings';

const
  UploadURL = 'http://www.hamqth.com/qso_realtime.php';

type
  THamQTHSentEvent = procedure of object;

  TSendHamQTHThread = class(TThread)
  protected
    procedure Execute; override;
    procedure ShowResult;
    function SendHamQTH(SendQSOr: TQSO): boolean;
  private
    result_mes: string;
    uploadok: boolean;
  public
    SendQSO: TQSO;
    user: string;
    password: string;
    callsign: string;
    OnHamQTHSent: THamQTHSentEvent;
    constructor Create;
  end;

function StripStr(t, s: string): string;

var
  SendHamQTHThread: TSendHamQTHThread;

implementation

uses Forms, LCLType, dmFunc_U;

function StripStr(t, s: string): string;
begin
  Result := StringReplace(s, t, '', [rfReplaceAll]);
end;

function TSendHamQTHThread.SendHamQTH(SendQSOr: TQSO): boolean;
var
  logdata, url, appname: string;
  res: TStringList;
  HTTP: TFPHttpClient;
  Document: TMemoryStream;

  procedure AddData(const datatype, Data: string);
  begin
    if Data <> '' then
      logdata := logdata + Format('<%s:%d>%s', [datatype, Length(Data), Data]);
  end;

  function UrlEncode(s: string): string;
  var
    i: integer;
  begin
    Result := '';
    for i := 1 to Length(s) do
      case s[i] of
        ' ':
          Result := Result + '+';
        '0'..'9', 'A'..'Z', 'a'..'z', '*', '@', '.', '_', '-', '$', '!', #$27, '(', ')':
          Result := Result + s[i];
        else
          Result := Result + '%' + IntToHex(Ord(s[i]), 2);
      end;
  end;

begin
  try
    HTTP := TFPHttpClient.Create(nil);
    res := TStringList.Create;
    Document := TMemoryStream.Create;
    HTTP.AllowRedirect := True;
    HTTP.AddHeader('User-Agent', 'Mozilla/5.0 (compatible; fpweb)');
    Result := False;
    appname := 'EWLog';
    AddData('CALL', SendQSOr.CallSing);
    AddData('QSO_DATE', FormatDateTime('yyyymmdd', SendQSOr.QSODate));
    SendQSOr.QSOTime := StringReplace(SendQSOr.QSOTime, ':', '', [rfReplaceAll]);
    AddData('TIME_ON', SendQSOr.QSOTime);
    AddData('BAND', dmFunc.GetBandFromFreq(SendQSOr.QSOBand));
    AddData('MODE', SendQSOr.QSOMode);
    AddData('SUBMODE', SendQSOr.QSOSubMode);
    AddData('RST_SENT', SendQSOr.QSOReportSent);
    AddData('RST_RCVD', SendQSOr.QSOReportRecived);
    AddData('NAME', SendQSOr.OmName);
    AddData('QTH', SendQSOr.OmQTH);
    AddData('MY_GRIDSQUARE', SendQSOr.My_Grid);
    AddData('CONT', SendQSOr.Continent);
    AddData('SAT_NAME', SendQSOr.SAT_NAME);
    AddData('SAT_MODE', SendQSOr.SAT_MODE);
    AddData('PROP_MODE', SendQSOr.PROP_MODE);
    AddData('QSLMSG', SendQSOr.QSLInfo);
    AddData('GRIDSQUARE', SendQSOr.Grid);
    Delete(SendQSOr.QSOBand, length(SendQSOr.QSOBand) - 2, 1);
    AddData('FREQ', SendQSOr.QSOBand);
    AddData('LOG_PGM', 'EWLog');
    logdata := logdata + '<EOR>';
    url := 'u=' + user + '&p=' + password + '&c=' + '&prg=' + appname +
      '&cmd=INSERT' + '&adif=' + UrlEncode(logdata);

    try
      HTTP.FormPost(UploadURL, url, Document);
      if HTTP.ResponseStatusCode = 200 then
        uploadok := True;
    except
      on E: Exception do
        result_mes := E.Message;
    end;

    if uploadok then
    begin
      Document.Position := 0;
      res.LoadFromStream(Document);
      if Pos('QSO inserted', Trim(res.Text)) > 0 then
        Result := True
      else
      begin
        Result := False;
        result_mes := res.Text;
      end;
    end;
  finally
    res.Destroy;
    FreeAndNil(HTTP);
    FreeAndNil(Document);
  end;
end;

constructor TSendHamQTHThread.Create;
begin
  FreeOnTerminate := True;
  OnHamQTHSent := nil;
  inherited Create(True);
end;

procedure TSendHamQTHThread.ShowResult;
begin
  if Length(result_mes) > 0 then
    Application.MessageBox(PChar(rAnswerServer + result_mes),
      'HamQTH', MB_ICONEXCLAMATION);
end;

procedure TSendHamQTHThread.Execute;
begin
  if SendHamQTH(SendQSO) then
    if Assigned(OnHamQTHSent) then
      Synchronize(OnHamQTHSent);
  Synchronize(@ShowResult);
end;

end.
