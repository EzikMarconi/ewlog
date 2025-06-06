(***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License.        *
 *   Author Vladimir Karpenko (EW8BAK)                                     *
 *                                                                         *
 ***************************************************************************)

unit DownloadFilesThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, fphttpclient, ResourceStr, opensslsockets;

type
  TdataThread = record
    URLDownload: string;
    PathSaveFile: string;
    DownloadAllFileSize: int64;
    DownloadedFileSize: int64;
    DownloadedPercent: integer;
    StatusDownload: boolean;
    FromForm: string;
    Message: string;
    Error: boolean;
    ErrorString: string;
    ShowStatus: boolean;
    Other: string;
    Version: boolean;
  end;

type
  TDownloadFilesThread = class(TThread)
  protected
    procedure Execute; override;
  private
    Status: TdataThread;
    procedure DownloadFile(Data: TdataThread);
    procedure OnDataReceived(Sender: TObject; const ContentLength, CurrentPos: int64);
    procedure ClearStatus;
  public
    DataFromForm: TdataThread;
    constructor Create;
    procedure ToForm;
  end;

var
  DownloadFilesTThread: TDownloadFilesThread;

implementation

uses
  UpdateForm_U, ConfigForm_U;

constructor TDownloadFilesThread.Create;
begin
  FreeOnTerminate := True;
  inherited Create(True);
end;

procedure TDownloadFilesThread.Execute;
begin
  DownloadFile(DataFromForm);
end;

procedure TDownloadFilesThread.DownloadFile(Data: TdataThread);
var
  HTTP: TFPHttpClient;
  Document: TMemoryStream;
begin
  try
    ClearStatus;
    HTTP := TFPHttpClient.Create(nil);
    Document := TMemoryStream.Create;
    HTTP.AllowRedirect := True;
    HTTP.AddHeader('User-Agent', 'Mozilla/5.0 (compatible; EWLog)');
    HTTP.OnDataReceived := @OnDataReceived;
    Status.FromForm := Data.FromForm;
    Status.ShowStatus := Data.ShowStatus;
    Status.Other := Data.Other;
    Status.Version := Data.Version;
    if Data.Version then
    begin
      try
        Status.Message := HTTP.Get(Data.URLDownload);
        if HTTP.ResponseStatusCode = 200 then
        begin
          Status.StatusDownload := True;
          Synchronize(@ToForm);
        end;
      except
        on E: Exception do
        begin
          Status.ErrorString := E.Message;
          Status.Error := True;
          Synchronize(@ToForm);
          Exit;
        end;
      end;
      Exit;
    end;
    try
      HTTP.Get(Data.URLDownload, Document);
      if HTTP.ResponseStatusCode = 200 then
      begin
        if FileExistsUTF8(Data.PathSaveFile) then
          DeleteFileUTF8(Data.PathSaveFile);
        Document.SaveToFile(Data.PathSaveFile);
        Status.PathSaveFile := Data.PathSaveFile;
        Status.Message := rDone;
        Status.StatusDownload := True;
        Synchronize(@ToForm);
      end;
    except
      on E: Exception do
      begin
        Status.ErrorString := E.Message;
        Status.Error := True;
        Synchronize(@ToForm);
        Exit;
      end;
    end;
  finally
    FreeAndNil(HTTP);
    FreeAndNil(Document);
  end;
end;

procedure TDownloadFilesThread.ToForm;
begin
  if Status.FromForm = 'UpdateForm' then
  begin
    if Status.ShowStatus then
    begin
      Update_Form.DataFromDownloadThread(Status);
    end;

    if Status.Version then
    begin
      Update_Form.DataFromDownloadThread(Status);
    end;
  end;

  if Status.FromForm = 'ConfigForm' then
  begin
    if Status.ShowStatus then
    begin
      ConfigForm.DataFromDownloadThread(Status);
    end;

    if Status.Version then
    begin
      ConfigForm.DataFromDownloadThread(Status);
    end;
  end;

end;

procedure TDownloadFilesThread.OnDataReceived(Sender: TObject;
  const ContentLength, CurrentPos: int64);
begin
  Status.DownloadAllFileSize := ContentLength;
  Status.DownloadedFileSize := CurrentPos;
  Status.DownloadedPercent := integer((Trunc((CurrentPos / ContentLength) * 100)));
  Synchronize(@ToForm);
end;

procedure TDownloadFilesThread.ClearStatus;
begin
  Status.URLDownload := '';
  Status.PathSaveFile := '';
  Status.DownloadAllFileSize := 0;
  Status.DownloadedFileSize := 0;
  Status.DownloadedPercent := 0;
  Status.Error := False;
  Status.ErrorString := '';
  Status.StatusDownload := False;
  Status.Message := '';
  Status.FromForm := '';
  Status.ShowStatus := False;
  Status.Other := '';
  Status.Version := False;
end;

end.
