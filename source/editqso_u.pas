(***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License.        *
 *   Author Vladimir Karpenko (EW8BAK)                                     *
 *                                                                         *
 ***************************************************************************)

unit editqso_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateTimePicker, Forms, Controls,
  Dialogs, StdCtrls, ComCtrls, EditBtn, Buttons, DBGrids, DBCtrls,
  InformationForm_U, sqldb, Grids, ExtCtrls, prefix_record, qso_record;

type

  { TEditQSO_Form }

  TEditQSO_Form = class(TForm)
    BtClose: TButton;
    BtCancel: TButton;
    BtApply: TButton;
    Button4: TButton;
    CBNoCalcDXCC: TCheckBox;
    CBValidDXCC: TCheckBox;
    CBMarkQSO: TCheckBox;
    CBReceived: TCheckBox;
    CBReceivedEQSL: TCheckBox;
    CBReceivedLoTW: TCheckBox;
    CBSentLoTW: TCheckBox;
    CBMode: TComboBox;
    CBPropagation: TComboBox;
    CBSATMode: TComboBox;
    CBSat: TComboBox;
    CBBand: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    CBSubMode: TComboBox;
    DEDate: TDateEdit;
    DateEdit2: TDateEdit;
    DateEdit3: TDateEdit;
    DateEdit4: TDateEdit;
    DTTime: TDateTimePicker;
    DBGrid1: TDBGrid;
    EditCallSign: TEdit;
    EditContinent: TEdit;
    EditGrid: TEdit;
    EditCQ: TEdit;
    EditITU: TEdit;
    EditState: TEdit;
    EditIOTA: TEdit;
    Edit19: TEdit;
    EditRSTs: TEdit;
    Edit20: TEdit;
    EditRSTr: TEdit;
    EditName: TEdit;
    EditQTH: TEdit;
    EditDXCC: TEdit;
    Edit7: TEdit;
    EditPrefix: TEdit;
    GBCallInfo: TGroupBox;
    GBQSLReceived: TGroupBox;
    GBQSLSent: TGroupBox;
    LBCallsign: TLabel;
    LBDXCC: TLabel;
    LBPrefix: TLabel;
    LBCQ: TLabel;
    LBITU: TLabel;
    LBGrid: TLabel;
    LBContinent: TLabel;
    LBMode: TLabel;
    LBBand: TLabel;
    LBState: TLabel;
    LBDate: TLabel;
    LBIOTA: TLabel;
    LBSatelite: TLabel;
    LBSATMode: TLabel;
    LBPropagation: TLabel;
    LBRecVia: TLabel;
    LBQSLManager: TLabel;
    LBQSLSentVia: TLabel;
    LBQSLInfo: TLabel;
    LBRSTs: TLabel;
    LBRSTr: TLabel;
    LBName: TLabel;
    LBQTH: TLabel;
    LBNote: TLabel;
    MemoNote: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RBSent: TRadioButton;
    RBPrinted: TRadioButton;
    RBQueued: TRadioButton;
    RBWSent: TRadioButton;
    RBDSent: TRadioButton;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure BtCloseClick(Sender: TObject);
    procedure BtCancelClick(Sender: TObject);
    procedure BtApplyClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CBModeChange(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
  private
    function SearchCountry(CallSign: string): string;
    { private declarations }
  public
    { public declarations }
  end;

var
  EditQSO_Form: TEditQSO_Form;

implementation

uses miniform_u, DXCCEditForm_U, QSLManagerForm_U,
  dmFunc_U, IOTA_Form_U, STATE_Form_U,
  InitDB_dm, MainFuncDM, GridsForm_u, SatEditorForm_u;

  {$R *.lfm}

  { TEditQSO_Form }

function TEditQSO_Form.SearchCountry(CallSign: string): string;
var
  PFXR: TPFXR;
begin
  Result := '';
  if Length(CallSign) > 0 then
  begin
    PFXR := MainFunc.SearchPrefix(CallSign, '');
    Result := PFXR.Country;
  end;
end;

procedure TEditQSO_Form.SpeedButton11Click(Sender: TObject);
begin
  InformationForm.FromForm := 'EditForm';
  InformationForm.Callsign := dmFunc.ExtractCallsign(EditCallSign.Text);
  InformationForm.ShowModal;
end;

procedure TEditQSO_Form.SpeedButton12Click(Sender: TObject);
begin
  QSLManager_Form.ShowModal;
end;

procedure TEditQSO_Form.SpeedButton1Click(Sender: TObject);
begin
  CountryEditForm.CountryQditQuery.DataBase := InitDB.ServiceDBConnection;
  CountryEditForm.CountryQditQuery.Close;
  CountryEditForm.CountryQditQuery.SQL.Clear;
  CountryEditForm.CountryQditQuery.SQL.Text := 'SELECT * FROM CountryDataEx';
  CountryEditForm.CountryQditQuery.Open;
  CountryEditForm.Caption := 'ARRLList';
  CountryEditForm.DBGrid1.DataSource.DataSet.Locate('ARRLPrefix', Edit7.Text, []);
  CountryEditForm.ShowModal;
end;

procedure TEditQSO_Form.SpeedButton2Click(Sender: TObject);
begin
  CountryEditForm.CountryQditQuery.DataBase := InitDB.ServiceDBConnection;

  CountryEditForm.CountryQditQuery.Close;
  CountryEditForm.CountryQditQuery.SQL.Clear;
  CountryEditForm.CountryQditQuery.SQL.Text := 'SELECT * FROM Province';
  CountryEditForm.CountryQditQuery.Open;
  CountryEditForm.Caption := 'Province';
  CountryEditForm.DBGrid1.DataSource.DataSet.Locate('Prefix', EditPrefix.Text, []);
  CountryEditForm.ShowModal;
end;

procedure TEditQSO_Form.SpeedButton8Click(Sender: TObject);
begin
  SATEditorForm.FromForm := 'EditForm';
  SATEditorForm.Show;
end;

procedure TEditQSO_Form.SpeedButton9Click(Sender: TObject);
begin
  IOTA_Form.ShowModal;
end;

procedure TEditQSO_Form.BtCloseClick(Sender: TObject);
begin
  EditQSO_Form.Close;
end;

procedure TEditQSO_Form.BtCancelClick(Sender: TObject);
begin
  EditQSO_Form.Close;
end;

procedure TEditQSO_Form.BtApplyClick(Sender: TObject);
var
  UQSO: TQSO;
  FmtStngs: TFormatSettings;
  NameBand: string;
  DigiBand: double;
begin
  FmtStngs.TimeSeparator := ':';
  FmtStngs.LongTimeFormat := 'hh:nn';

  NameBand := MainFunc.ConvertFreqToShow(CBBand.Text);
  NameBand := MainFunc.ConvertFreqToSave(NameBand);
  DigiBand := dmFunc.GetDigiBandFromFreq(NameBand);

  UQSO.CallSing := EditCallSign.Text;
  UQSO.QSODate := DEDate.Date;
  UQSO.QSOTime := TimeToStr(DTTime.Time, FmtStngs);
  UQSO.QSODateTime := DEDate.Date + DTTime.Time;
  UQSO.QSOBand := NameBand;
  UQSO.QSOMode := CBMode.Text;
  UQSO.QSOSubMode := CBSubMode.Text;
  UQSO.QSOReportSent := EditRSTs.Text;
  UQSO.QSOReportRecived := EditRSTr.Text;
  UQSO.OMName := EditName.Text;
  UQSO.OMQTH := EditQTH.Text;
  UQSO.State0 := EditState.Text;
  UQSO.Grid := EditGrid.Text;
  UQSO.IOTA := EditIOTA.Text;
  UQSO.QSLManager := Edit19.Text;
  UQSO.QSLSent := BoolToStr(RBSent.Checked, '1', '0');
  if RBSent.Checked = True then
    UQSO.QSLSentAdv := 'T';
  if RBPrinted.Checked = True then
    UQSO.QSLSentAdv := 'P';
  if RBQueued.Checked = True then
    UQSO.QSLSentAdv := 'Q';
  if RBWSent.Checked = True then
    UQSO.QSLSentAdv := 'F';
  if RBDSent.Checked = True then
    UQSO.QSLSentAdv := 'N';
  if DateEdit3.Text = '' then
    UQSO.QSLSentDate := 0
  else
    UQSO.QSLSentDate := DateEdit3.Date;
  UQSO.QSLRec := BoolToStr(CBReceived.Checked, '1', '0');
  if DateEdit2.Text = '' then
    UQSO.QSLRecDate := 0
  else
    UQSO.QSLRecDate := DateEdit2.Date;
  UQSO.DXCC := EditDXCC.Text;
  UQSO.DXCCPrefix := Edit7.Text;
  UQSO.CQZone := EditCQ.Text;
  UQSO.ITUZone := EditITU.Text;
  UQSO.QSOAddInfo := MemoNote.Text;
  UQSO.Marker := BoolToStr(CBMarkQSO.Checked, '1', '0');
  UQSO.ManualSet := 0;
  UQSO.DigiBand := StringReplace(FloatToStr(DigiBand), ',', '.', [rfReplaceAll]);
  UQSO.Continent := EditContinent.Text;
  UQSO.ShortNote := MemoNote.Text;
  UQSO.QSLReceQSLcc := 0;
  if CBReceivedEQSL.Checked then
    UQSO.QSLReceQSLcc := 1;
  UQSO.LoTWRec := BoolToStr(CBReceivedLoTW.Checked, '1', '0');
  if DateEdit4.Text = '' then
    UQSO.LoTWRecDate := 0
  else
    UQSO.LoTWRecDate := DateEdit4.Date;
  UQSO.QSLInfo := Edit20.Text;
  UQSO.Call := EditCallSign.Text;
  UQSO.State1 := '';
  UQSO.State2 := '';
  UQSO.State3 := '';
  UQSO.State4 := '';
  UQSO.WPX := EditPrefix.Text;
  UQSO.ValidDX := BoolToStr(CBValidDXCC.Checked, '1', '0');
  UQSO.SRX := 0;
  UQSO.SRX_STRING := '';
  UQSO.STX := 0;
  UQSO.STX_STRING := '';
  UQSO.SAT_NAME := CBSat.Text;
  UQSO.SAT_MODE := CBSATMode.Text;
  UQSO.PROP_MODE := CBPropagation.Text;
  UQSO.LoTWSent := 0;
  if CBSentLoTW.Checked then
    UQSO.LoTWSent := 1;
  UQSO.NoCalcDXCC := 0;
  if CBNoCalcDXCC.Checked then
    UQSO.NoCalcDXCC := 1;
  UQSO.MainPrefix := EditPrefix.Text;
  UQSO.QSL_RCVD_VIA := 'NULL';
  UQSO.QSL_SENT_VIA := 'NULL';
  if ComboBox6.Text <> '' then
    UQSO.QSL_RCVD_VIA := ComboBox6.Text[1];
  if ComboBox7.Text <> '' then
    UQSO.QSL_SENT_VIA := ComboBox7.Text[1];
  MainFunc.UpdateEditQSO(UnUsIndex, UQSO);
  MainFunc.CurrPosGrid(GridRecordIndex, GridsForm.DBGrid1);
  UnUsIndex := GridsForm.DBGrid1.DataSource.DataSet.FieldByName('UnUsedIndex').AsInteger;
  GridsForm.DBGrid1.DataSource.DataSet.Locate('UnUsedIndex', UnUsIndex, []);
  GridsForm.DBGrid1CellClick(nil);
end;

procedure TEditQSO_Form.Button4Click(Sender: TObject);
var
  PFXR: TPFXR;
begin
  if Length(EditCallSign.Text) > 0 then
  begin
    PFXR := MainFunc.SearchPrefix(EditCallSign.Text, EditGrid.Text);
    GBCallInfo.Caption := PFXR.Country;
    Edit7.Text := PFXR.ARRLPrefix;
    EditPrefix.Text := PFXR.Prefix;
    EditCQ.Text := PFXR.CQZone;
    EditITU.Text := PFXR.ITUZone;
    EditContinent.Text := PFXR.Continent;
    EditDXCC.Text := IntToStr(PFXR.DXCCNum);
  end;
end;

procedure TEditQSO_Form.CBModeChange(Sender: TObject);
var
  i: integer;
begin
  CBSubMode.Items.Clear;
  for i := 0 to High(MainFunc.LoadSubModes(CBMode.Text)) do
    CBSubMode.Items.Add(MainFunc.LoadSubModes(CBMode.Text)[i]);
end;

procedure TEditQSO_Form.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
begin
  MainFunc.DrawColumnGrid(GridsForm.LOGBookDS.DataSet, Rect, DataCol,
    Column, State, DBGrid1);
end;

procedure TEditQSO_Form.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  EditCallSign.Text := '';
end;

procedure TEditQSO_Form.FormShow(Sender: TObject);
var
  SelQSO: TQSO;
begin
  MainFunc.LoadBMSL(CBMode, CBSubMode, CBBand);
  MainFunc.SetGrid(DBGrid1);

  CBSat.Items.Clear;
  CBSat.Items.AddStrings(MainFunc.LoadSATItems);
  CBPropagation.Items.Clear;
  CBPropagation.Items.AddStrings(MainFunc.LoadPropItems);

  SelQSO := MainFunc.SelectEditQSO(UnUsIndex);
  EditCallSign.Text := SelQSO.CallSing;
  DEDate.Date := SelQSO.QSODate;
  DTTime.Time := StrToTime(SelQSO.QSOTime);
  EditName.Text := SelQSO.OMName;
  EditQTH.Text := SelQSO.OMQTH;
  EditState.Text := SelQSO.State0;
  EditGrid.Text := SelQSO.Grid;
  EditRSTs.Text := SelQSO.QSOReportSent;
  EditRSTr.Text := SelQSO.QSOReportRecived;
  EditIOTA.Text := SelQSO.IOTA;
  if SelQSO.QSLSentDate <> 0 then
    DateEdit3.Date := SelQSO.QSLSentDate
  else
    DateEdit3.Clear;
  if SelQSO.QSLRecDate <> 0 then
    DateEdit2.Date := SelQSO.QSLRecDate
  else
    DateEdit2.Clear;
  if SelQSO.LoTWRecDate <> 0 then
    DateEdit4.Date := SelQSO.LoTWRecDate
  else
    DateEdit4.Clear;
  EditPrefix.Text := SelQSO.MainPrefix;
  Edit7.Text := SelQSO.DXCCPrefix;
  EditDXCC.Text := SelQSO.DXCC;
  EditCQ.Text := SelQSO.CQZone;
  EditITU.Text := SelQSO.ITUZone;
  CBMarkQSO.Checked := MainFunc.StringToBool(SelQSO.Marker);
  CBMode.Text := SelQSO.QSOMode;
  CBSubMode.Text := SelQSO.QSOSubMode;
  CBBand.Text := SelQSO.QSOBand;
  EditContinent.Text := SelQSO.Continent;
  Edit20.Text := SelQSO.QSLInfo;
  CBValidDXCC.Checked := MainFunc.StringToBool(SelQSO.ValidDX);
  Edit19.Text := SelQSO.QSLManager;
  MemoNote.Text := SelQSO.QSOAddInfo;
  CBNoCalcDXCC.Checked := MainFunc.IntToBool(SelQSO.NoCalcDXCC);
  CBReceivedEQSL.Checked := MainFunc.IntToBool(SelQSO.QSLReceQSLcc);
  CBReceived.Checked := MainFunc.StringToBool(SelQSO.QSLRec);
  CBReceivedLoTW.Checked := MainFunc.StringToBool(SelQSO.LoTWRec);
  CBSentLoTW.Checked := MainFunc.IntToBool(SelQSO.LoTWSent);
  CBSat.Text := SelQSO.SAT_NAME;
  CBSATMode.Text := SelQSO.SAT_MODE;
  CBPropagation.Text := SelQSO.PROP_MODE;

  case SelQSO.QSL_RCVD_VIA of
    '': ComboBox6.ItemIndex := 0;
    'B': ComboBox6.ItemIndex := 1;
    'D': ComboBox6.ItemIndex := 2;
    'E': ComboBox6.ItemIndex := 3;
    'M': ComboBox6.ItemIndex := 4;
    'G': ComboBox6.ItemIndex := 5;
  end;

  case SelQSO.QSL_SENT_VIA of
    '': ComboBox7.ItemIndex := 0;
    'B': ComboBox7.ItemIndex := 1;
    'D': ComboBox7.ItemIndex := 2;
    'E': ComboBox7.ItemIndex := 3;
    'M': ComboBox7.ItemIndex := 4;
    'G': ComboBox7.ItemIndex := 5;
  end;

  case SelQSO.QSLSentAdv of
    'P': RBPrinted.Checked := True;
    'T': RBSent.Checked := True;
    'Q': RBQueued.Checked := True;
    'F': RBWSent.Checked := True;
    'N': RBDSent.Checked := True;
  end;

  if CBMode.Text <> '' then
    CBModeChange(Self);

  GBCallInfo.Caption := SearchCountry(EditCallSign.Text);
end;

procedure TEditQSO_Form.SpeedButton10Click(Sender: TObject);
begin
  STATE_Form.ShowModal;
end;

end.
