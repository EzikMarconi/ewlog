unit dmHamLib_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, uRigControl;

type

  { TdmHamLib }

  TdmHamLib = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    tmrRadio: TTimer;
    radio: TRigControl;
    procedure tmrRadioTimer(Sender: TObject);
    procedure SynTRX;

  public
    function InicializeHLRig(RIGid: integer): boolean;
    procedure FreeRadio;

  end;

type
  TRigThread = class(TThread)
  protected
    procedure Execute; override;
  public
    Rig_RigCtldPath: string;
    Rig_RigCtldArgs: string;
    Rig_RunRigCtld: boolean;
    Rig_RigId: word;
    Rig_RigDevice: string;
    Rig_RigCtldPort: word;
    Rig_RigCtldHost: string;
    Rig_RigPoll: word;
    Rig_RigSendCWR: boolean;
    Rig_ClearRit: boolean;
  end;

var
  dmHamLib: TdmHamLib;
  thRig: TRigThread;

implementation

uses
  InitDB_dm, dmCat, dmFunc_U, MainFuncDM, miniform_u, TRXForm_U,
  WSJT_UDP_Form_U, serverDM_u;

{$R *.lfm}

function TdmHamLib.InicializeHLRig(RIGid: integer): boolean;
var
  id: string;
begin
  if Assigned(radio) then
  begin
    FreeAndNil(radio);
  end;

  tmrRadio.Enabled := False;
  radio := TRigControl.Create;
  radio.RigId := RIGid;
  id := IntToStr(RIGid);

  radio.RigCtldPath := INIFile.ReadString('TRX' + id, 'RigCtldPath', '');
  radio.RigCtldArgs := CATdm.GetRadioRigCtldCommandLine(RIGid);
  radio.RunRigCtld := INIFile.ReadBool('TRX' + id, 'RunRigCtld', True);
  if INIFile.ReadString('TRX' + id, 'model', '') <> IntToStr(2) then
    radio.RigDevice := INIFile.ReadString('TRX' + id, 'device', '');
  radio.RigCtldPort := StrToInt(INIFile.ReadString('TRX' + id, 'RigCtldPort', '4532'));
  radio.RigCtldHost := INIFile.ReadString('TRX' + id, 'host', '127.0.0.1');
  if StrToInt(INIFile.ReadString('TRX' + id, 'Poll', '100')) < 3 then
    radio.RigPoll := 3
  else
    radio.RigPoll := StrToInt(INIFile.ReadString('TRX' + id, 'Poll', '3'));
  radio.RigSendCWR := INIFile.ReadBool('TRX' + id, 'CWR', False);
  tmrRadio.Interval := radio.RigPoll;
  tmrRadio.Enabled := True;

  Result := True;

  if not radio.Connected then
  begin
    Result := False;
    tmrRadio.Enabled := False;
    FreeAndNil(radio);
  end;
end;

procedure TdmHamLib.SynTRX;
var
  f: double;
  f_hz: integer;
  m: string;
  mode, submode: string;
begin
  m := '';
  mode := '';
  submode := '';
  if Assigned(radio) then
  begin
    f := radio.GetFreqMHz;
    m := radio.GetModeOnly;
    f_hz := radio.GetFreqHz;
    //{$IFDEF WIN64}
    // bwith := radio.GetBandwich(radio.GetRawMode);
    //{$ENDIF}
  end
  else
  begin
    f := 0;
    f_hz := 0;
  end;

  if Length(m) > 1 then
    dmFunc.GetRIGMode(m, mode, submode);
  FMS.Freq := f;
  FMS.Mode := mode;
  FMS.SubMode := submode;
  MiniForm.ShowInfoFromRIG;
  TRXForm.ShowInfoFromRIG(f_hz);
end;

procedure TdmHamLib.tmrRadioTimer(Sender: TObject);
begin
  if not WSJT_Run and not FldigiConnect then
    SynTRX;
end;

procedure TdmHamLib.DataModuleCreate(Sender: TObject);
begin
  tmrRadio := TTimer.Create(nil);
  tmrRadio.OnTimer := @tmrRadioTimer;
  tmrRadio.Enabled := False;
  Radio := nil;
  thRig := nil;
end;

procedure TRigThread.Execute;
var
  mRig: TRigControl;

  procedure ReadSettings;
  begin
    mRig.RigCtldPath := Rig_RigCtldPath;
    mRig.RigCtldArgs := Rig_RigCtldArgs;
    mRig.RunRigCtld := Rig_RunRigCtld;
    mRig.RigId := Rig_RigId;
    mRig.RigDevice := Rig_RigDevice;
    mRig.RigCtldPort := Rig_RigCtldPort;
    mRig.RigCtldHost := Rig_RigCtldHost;
    mRig.RigPoll := Rig_RigPoll;
    mRig.RigSendCWR := Rig_RigSendCWR;
  end;

begin
end;

procedure TdmHamLib.FreeRadio;
begin
  if Assigned(radio) then
    FreeAndNil(radio);
  if Assigned(thRig) then
    thRig.Terminate;
end;

procedure TdmHamLib.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(tmrRadio);
end;


end.