unit digi_record;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TDigiR = record
    DXCall: string;
    date: TDateTime;
    time: string;
    DXGrid: string;
    Freq: string;
    Mode: string;
    RSTr: string;
    RSTs: string;
    OmName: string;
    Comment: string;
  end;

implementation

end.