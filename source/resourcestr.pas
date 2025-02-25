(***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License.        *
 *   Author Vladimir Karpenko (EW8BAK)                                     *
 *                                                                         *
 ***************************************************************************)

unit ResourceStr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, const_u;

resourcestring
  rEWLogHAMJournal = 'EWLog - HAM Journal';
  rQSL = 'QSL';
  rQSLs = 'QSLs';
  rQSODate = 'Date';
  rQSOTime = 'Time';
  rQSOBand = 'Band';
  rQSOBandFreq = 'Frequency';
  rCallSign = 'Callsign';
  rQSOMode = 'Mode';
  rQSOSubMode = 'SubMode';
  rOMName = 'Name';
  rOMQTH = 'QTH';
  rState = 'State';
  rGrid = 'Grid';
  rQSOReportSent = 'RSTs';
  rQSOReportRecived = 'RSTr';
  rIOTA = 'IOTA';
  rQSLManager = 'Manager';
  rQSLSentDate = 'QSLs Date';
  rQSLRecDate = 'QSLr Date';
  rLoTWRecDate = 'LOTWr Date';
  rMainPrefix = 'Prefix';
  rDXCCPrefix = 'DXCC';
  rCQZone = 'CQ Zone';
  rITUZone = 'ITU Zone';
  rManualSet = 'Manual Set';
  rContinent = 'Continent';
  rValidDX = 'Valid DX';
  rQSL_RCVD_VIA = 'QSL r VIA';
  rQSL_SENT_VIA = 'QSL s VIA';
  rUSERS = 'User';
  rNoCalcDXCC = 'No Calc DXCC';
  rMySQLHasGoneAway =
    'NO connection to MySQL database! Check the connection or connection settings. Connect to SQLite';
  rWelcomeMessageMySQL = 'MySQL database selected! Welcome!';
  rWelcomeMessageSQLIte = 'SQLite database selected! Welcome!';
  rCheckSettingsMySQL = 'Check MySQL DB Settings';
  rCheckSettingsSQLIte = 'Check SQLite DB Settings';
  rDataBaseFault = 'Something went wrong ... Check the settings';
  rWarning = 'Warning!';
  rQSONotSave = 'QSO not saved, quit anyway ?!';
  rDXClusterDisconnect = 'You are disconnected from the DX cluster';
  rSwitchDBSQLIte = 'Switch base to SQLite';
  rSwitchDBMySQL = 'Switch base to MySQL';
  rDBNotInit = 'The database is not initialized, go to the settings?';
  rClientConnected = 'Client Connected:';
  rPhotoFromQRZ = 'Photo from QRZ | HAMQTH';
  rDeleteRecord = 'Delete Record ';
  rDuplicates = 'Duplicates';
  rSyncOK = 'Done! Number of duplicates ';
  rSync = ', in sync ';
  rQSOsync = 'QSO';
  rDBError = 'Error while working with the database. Check connection and settings';
  rMySQLNotSet = 'MySQL database settings not configured';
  rNotCallsign = 'No callsign entered to view';
  rDXClusterConnecting = 'Connect to Telnet Cluster';
  rDXClusterDisconnecting = 'Disconnect from Telnet Cluster';
  rDXClusterWindowClear = 'Clear DX Cluster window';
  rSendSpot = 'Send spot';
  rEnCall = 'You must enter a callsign';
  rSaveQSO = 'Save QSO';
  rSave = 'Save';
  rClearQSO = 'Clear QSO input window';
  rLogConWSJT = 'EWLog connected to WSJT';
  rLogNConWSJT = 'EWLog not connected to WSJT';
  rQSOTotal = ' Total ';
  rLanguageComplite = 'Translation files download successfully';
  rCleanUpJournal = 'Are you sure you want to clear all entries?';
  rErrorXMLAPI = 'Error XML API:';
  rNotConfigQRZRU =
    'Specify the Login and Password for accessing the XML API QRZ.RU in the settings';
  rNotConfigQRZCOM =
    'Specify the Login and Password for accessing the XML API QRZ.COM in the settings';
  rNotConfigSprav =
    'Default reference book is not specified. Go to the program settings and select the QRZ.RU or QRZ.COM reference book';
  rInformationFromQRZRU = 'Information from QRZ.ru';
  rInformationFromQRZCOM = 'Information from QRZ.com';
  rInformationFromHamQTH = 'Information from HAMQTH';
  rDeleteLog = 'Are you sure you want to delete the log ?!';
  rCannotDelDef = 'Cannot delete default or current log';
  rDefaultLogSel = 'Default log selected';
  rNotDataForConnect =
    'The log configuration, do not specify the data to connect to eQSL.cc';
  rNotDataForConnectLoTW =
    'The log configuration, do not specify the data to connect to LoTW';
  rStatusConnecteQSL = 'Connceting to eQSL.cc';
  rStatusConnectLotW = 'Connceting to LoTW';
  rStatusDownloadeQSL = 'Download eQSL.cc';
  rStatusSaveFile = 'Saving file';
  rStatusNotData = 'Not data';
  rStatusIncorrect = 'Username/password incorrect';
  rProcessedData = 'Processed data:';
  rDone = 'Done';
  rImport = 'Import';
  RImported = 'Imported';
  rImportRecord = 'Imported Records';
  rFileError = 'Error file:';
  rImportErrors = 'Import Errors';
  rNumberDup = 'Number of duplicates';
  rNothingImport = 'Nothing to import';
  rProcessing = 'Processing';
  rSetAsDefaultJournal = 'Set as default journal?';
  rAllfieldsmustbefilled = 'All fields must be filled!';
  rLogaddedsuccessfully = 'Log added successfully';
  rHaltLog = 'The program will be completed, restart it!';
  rSwitchToANewLog = 'Switch to a new log?';
  rFailedToLoadData = 'Failed to load data';
  rUpdateStatusCheckUpdate = 'Update status: Check version';
  rUpdateRequired = 'Update required';
  rUpdateStatusDownload = 'Update status: Download?';
  rButtonDownload = 'Download';
  rUpdateStatusActual = 'Update status: Actual';
  rButtonCheck = 'Check';
  rSizeFile = 'File size: ';
  rUpdateStatus = 'Update status: ';
  rUpdateStatusDownloads = 'Update status: Downloads';
  rUpdateStatusDownloadBase = 'Update status: Download Database';
  rUpdateStatusDownloadCallbook = 'Update status: Download CallBook';
  rUpdateDontCopy = 'Do not copy';
  rUpdateStatusDownloadChanges = 'Update status: Download Changes';
  rUpdateStatusRequiredInstall = 'Update status: Installation required';
  rButtonInstall = 'Install';
  rBytes = ' bytes';
  rKBytes = 'KB';
  rMBytes = 'MB';
  rFileExist = 'File exists! Overwrite? All data from this file is destroyed';
  rFileUsed = 'File is used. Removal is not possible';
  rErrorServiceDB =
    'Service database not found! Verify program installation integrity. File serviceLOG.db';
  rSyncErrCall = 'Sync Error: Call Not Found';
  rNoLogFileFound = 'No log file found! Check settings';
  rOnlyWindows = 'The function is available only in the Windows system';
  rCreateTableLogBookInfo = 'Create table LogBookInfo';
  rIchooseNumberOfRecords = 'I choose the number of records';
  rFillInLogTable = 'Fill in the Log_Table_';
  rFillInlogBookInfo = 'Fill in the LogBookInfo table';
  rAddIndexInLogTable = 'Add index in Log_TABLE_';
  rAddKeyInLogTable = 'Add key in Log_TABLE_';
  rSuccessful = 'Successful';
  rWait = 'Wait';
  rNotConnected =
    'No connection to the server. Go back to the connection settings step and check all the settings';
  rNotUser =
    'No database was found for this user. Check the user and database settings in the connection settings step';
  rSuccessfulNext = 'Successful! Click NEXT';
  rValueEmpty = 'One or more values are empty! Check';
  rCheckPath = 'Check SQLite database path';
  rPath = 'Path';
  rValueCorr =
    'One or more fields are not filled or are filled incorrectly! All fields and the correct locator must be filled. Longitude and latitude are set automatically';
  rUpdateSQLiteDLL = 'Update sqlite3.so to version ' + min_sqlite_version +
    ' or higher.' + #10#13 + 'Current Latest Version ' + curr_sqlite_version + #10#13 +
    'Full work program can not be guaranteed';
  rSQLiteCurrentVersion = 'Installed version of sqlite3.so';
  rMHZ = 'MHz';
  rConnectedToFldigi = 'Fldigi connected to EWLog';
  rDisconnectedFromFldigi = 'Fldigi disconnected from EWLog';
  rNewDXCCInBM = 'A new country in BM';
  rNeedQSL = 'QSL is needed';
  rCheckBand = 'Band is empty. Check';
  rCheckMode = 'Mode is empty. Check';
  rLogEntryExist = 'Log entry already exists';
  rTableLogDBError = 'Log table ERROR';
  rCheckBoxFormMain = 'Default form: MAIN';
  rCheckBoxFormMini = 'Default form: MULTI';
  rCallsignNotEntered = 'Recipient callsign not entered';
  rOf = ' of ';
  rCopyQSO = 'Copy QSO';
  rUseWSJT = 'Use WSJT-X with EWLog?';
  rUseFldigi = 'Use Fldigi with EWLog?';
  rTheNameFieldCannotBeEmpty = 'The "Name" field cannot be empty';
  rNewProgram = 'New Program';
  rGoToSettings = 'Go to settings?';
  rDatabaseNotConnected =
    'Check the correctness of the entered data. Possibly a non-existing database has been entered (it must be created first). Or Invalid username and password.';
  tNotFoundTableToCopy =
    'No table found to copy. Possible callsign mismatch in databases';
  rNotDatabaseSettings =
    'You cannot switch the Database to another because one of the databases is not configured. Check your settings. Go to the settings window?';
  rShowNextStart =
    'Show this window next start? The settings can be changed in the menu item View';
  rFileDBExist =
    'Found an existing database file. Do you want to use it? If you press NO, the existing file will be deleted and a new one will be created';
  rDeleteDBFile = 'Are you sure you want to delete the existing database file?';
  rPleaseQSLInfo = 'Please enter a message in the QSL Info field';
  rEnterMesQSLInf = 'Please enter your message';
  rSentRecord = 'Record sent';
  rNotefldigi =
    'Please enable N3FJP logs support in Fldigi settings. (In Fldigi - Configure / Config dialog / Logging / N3FJP Logs / Connect)';
  rImportCompl = 'Import completed';
  rProgramAgain = 'You are trying to run the program again. You cannot do this';
  rExport = 'Export';
  rError = 'Error';
  rExportCompl = 'Export completed';
  pPleaseFile = 'Please specify a file for export!';
  rNoMethodExport = 'No export method selected!';
  rNumberOfQSO0 = 'Number of QSO: 0';
  rNumberOfQSO = 'Number of QSO';
  rErrorOpenFile = 'Error opening file';
  rAddress = 'Address';
  rCOMPort = 'COM Port';
  rLibHamLibNotFound = 'HamLib library not found';
  rThisNameAlreadyExists = 'This name already exists';
  rDBNeedUpdate = 'The database structure needs to be updated to version:';
  rInputMySotaRef = 'Please input My SOTA summit Reference';
  rNothingtosave = 'Nothing to save';
  rERRORFieldnotentered = 'ERROR Field not entered';
  rCallsignNotRnteredOrDuplicateOnTourTime = 'Callsign not entered or Duplicate on Tour Time';
  rEnabled = 'Enabled';
  rDisabled = 'Disabled';
  rNone = 'None';
  rDownloadingFile = 'Downloading file';
  rNeedUpload = 'Need to upload';
  rAllQSOsuploadedtoeQSLcc = 'All QSOs uploaded to eQSLcc';
  rAllQSOsuploadedtoLoTW = 'All QSOs uploaded to LoTW';
  rGenerate = 'Generate';
  rUpload = 'Upload';

implementation

end.
