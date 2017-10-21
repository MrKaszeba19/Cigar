unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, pqconnection, FileUtil, UTF8Process, SynEdit,
  SynHighlighterSQL, SynHighlighterMulti, SynCompletion, SynHighlighterJava,
  SynHighlighterCpp, SynHighlighterPas, synhighlighterunixshellscript,
  SynHighlighterAny, SynPluginSyncroEdit, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, Menus, SynEditKeyCmds, SynHighlighterHTML,
  SynHighlighterXML, SynHighlighterCss, SynHighlighterPHP;

type

  { TForm1 }

  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    FontDialog1: TFontDialog;
    LabelOnlineStatus: TLabel;
    LabelFileName: TLabel;
    MainMenu1: TMainMenu;
    MenuFile: TMenuItem;
    MenuItemFont: TMenuItem;
    MenuItemView: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemLogOut: TMenuItem;
    MenuItemAccountInfo: TMenuItem;
    MenuItemMyWorkgroups: TMenuItem;
    MenuItemMyPersonalStorage: TMenuItem;
    MenuItemLogin: TMenuItem;
    MenuItemSignUp: TMenuItem;
    MenuItemSignIn: TMenuItem;
    MenuItemMyAccount: TMenuItem;
    MenuItemCopy: TMenuItem;
    MenuItemPaste: TMenuItem;
    MenuEdit: TMenuItem;
    MenuItemNew: TMenuItem;
    MenuItemSelectAll: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemSaveAs: TMenuItem;
    MenuItemQuit: TMenuItem;
    MenuItemCut: TMenuItem;
    OpenDialog1: TOpenDialog;
    PlainHighlight: TSynAnySyn;
    SaveDialog1: TSaveDialog;
    SynAutoComplete1: TSynAutoComplete;
    CppHighlight: TSynCppSyn;
    AutoCompletion: TSynCompletion;
    CSSHighlight: TSynCssSyn;
    SynEdit1: TSynEdit;
    JavaHighlight: TSynJavaSyn;
    SQLHighlight: TSynSQLSyn;
    FPCHighlight: TSynFreePascalSyn;
    HTMLHighlight: TSynHTMLSyn;
    PHPHighlight: TSynPHPSyn;
    XMLHighlight: TSynXMLSyn;
    UnixHighlight: TSynUNIXShellScriptSyn;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemCopyClick(Sender: TObject);
    procedure MenuItemCutClick(Sender: TObject);
    procedure MenuItemFontClick(Sender: TObject);
    procedure MenuItemNewClick(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MenuItemPasteClick(Sender: TObject);
    procedure MenuItemQuitClick(Sender: TObject);
    procedure MenuItemSaveAsClick(Sender: TObject);
    procedure MenuItemSaveClick(Sender: TObject);
    procedure MenuItemSelectAllClick(Sender: TObject);
    procedure MenuItemSignInClick(Sender: TObject);

    procedure SetFileName(x : String);
    function GetFileName() : String;
    procedure SetOnlineStatus(x : Boolean);
    function GetOnlineStatus() : Boolean;
    procedure SetUserLogin(x : String);
    function GetUserLogin() : String;

    procedure UpdateOnlineStatus();
    procedure OpenOfflineFile();
    procedure BootOfflineFile(path : String);
    procedure SetStyles();
    procedure SetHighlighter();
    procedure InitializeNewFile();
    procedure LoadFPCCompleters;
    procedure LoadCPPCompleters;

  private
    LeerNaam      : String;
    OnlineStatus  : Boolean;
    UserLogin     : String;
  public

  end;

var
  Form1: TForm1;

implementation

uses UnitAbout;

{$R *.lfm}

{ TForm1 }

procedure TForm1.SetFileName(x : String);
begin
     LeerNaam := x;
end;

function TForm1.GetFileName() : String;
begin
     GetFileName := LeerNaam;
end;

procedure TForm1.SetOnlineStatus(x : Boolean);
begin
     OnlineStatus := x;
end;

function TForm1.GetOnlineStatus() : Boolean;
begin
     GetOnlineStatus := OnlineStatus;
end;

procedure TForm1.SetUserLogin(x : String);
begin
     UserLogin := x;
end;

function TForm1.GetUserLogin() : String;
begin
     GetUserLogin := UserLogin;
end;

procedure TForm1.UpdateOnlineStatus();
begin
     if (GetOnlineStatus()) then
     begin
          LabelOnlineStatus.Caption := concat('You are online as "', GetUserLogin(), '".');
     end else begin
         LabelOnlineStatus.Caption := 'You are offline.';
     end;

end;

procedure TForm1.OpenOfflineFile();
begin
     if OpenDialog1.Execute then
     begin
          try
             SetFileName(OpenDialog1.FileName);
             SynEdit1.Lines.LoadFromFile(GetFileName());
             LabelFileName.Caption := GetFileName();
             SynEdit1.Modified := false;
             SetStyles();
          except
                ShowMessage('Error when loading a file.');
          end;
     end;
end;

procedure TForm1.BootOfflineFile(path : String);
begin
     //if OpenDialog1.Execute then
     //begin
          try
             SetFileName(path);
             SynEdit1.Lines.LoadFromFile(GetFileName());
             LabelFileName.Caption := GetFileName();
             SynEdit1.Modified := false;
             SetStyles();
          except
                InitializeNewFile();
                ShowMessage('Error when loading a file.'+#13#10+
                'The file either doesn''t exist or is damaged.'+#13#10+
                'I am opening a new blank file.');
          end;
     //end;
end;

procedure TForm1.SetStyles();
begin
     ComboBox1.Caption := 'Plain Text';
     if RightStr(GetFileName(), 2) = '.c' then ComboBox1.Caption := 'C/C++';
     if RightStr(GetFileName(), 2) = '.h' then ComboBox1.Caption := 'C/C++';
     if RightStr(GetFileName(), 3) = '.sh' then ComboBox1.Caption := 'Unix';
     if RightStr(GetFileName(), 4) = '.pas' then ComboBox1.Caption := 'FreePascal';
     if RightStr(GetFileName(), 4) = '.lpr' then ComboBox1.Caption := 'FreePascal';
     if RightStr(GetFileName(), 4) = '.dpr' then ComboBox1.Caption := 'FreePascal';
     if RightStr(GetFileName(), 4) = '.dpk' then ComboBox1.Caption := 'FreePascal';
     if RightStr(GetFileName(), 4) = '.cpp' then ComboBox1.Caption := 'C/C++';
     if RightStr(GetFileName(), 4) = '.hpp' then ComboBox1.Caption := 'C/C++';
     if RightStr(GetFileName(), 4) = '.sql' then ComboBox1.Caption := 'SQL';
     if RightStr(GetFileName(), 4) = '.css' then ComboBox1.Caption := 'CSS';
     if RightStr(GetFileName(), 4) = '.xml' then ComboBox1.Caption := 'XML';
     if RightStr(GetFileName(), 4) = '.xsd' then ComboBox1.Caption := 'XML';
     if RightStr(GetFileName(), 4) = '.lpi' then ComboBox1.Caption := 'XML';
     if RightStr(GetFileName(), 4) = '.lps' then ComboBox1.Caption := 'XML';
     if RightStr(GetFileName(), 4) = '.htm' then ComboBox1.Caption := 'HTML';
     if RightStr(GetFileName(), 4) = '.php' then ComboBox1.Caption := 'PHP';
     if RightStr(GetFileName(), 5) = '.java' then ComboBox1.Caption := 'Java';
     if RightStr(GetFileName(), 5) = '.html' then ComboBox1.Caption := 'HTML';
     if RightStr(GetFileName(), 5) = '.php3' then ComboBox1.Caption := 'PHP';
     if RightStr(GetFileName(), 6) = '.phtml' then ComboBox1.Caption := 'PHP';
     SetHighlighter();
end;

procedure TForm1.SetHighlighter();
begin
     case (ComboBox1.Caption) of
       'Plain Text' : begin SynEdit1.Highlighter := PlainHighlight; AutoCompletion.ItemList.Clear; end;
       'C/C++' : begin SynEdit1.Highlighter := CppHighlight; LoadCPPCompleters; end;
       'FreePascal' : begin SynEdit1.Highlighter := FPCHighlight; LoadFPCCompleters; end;
       'Java' : begin SynEdit1.Highlighter := JavaHighlight; AutoCompletion.ItemList.Clear; end;
       'SQL' : begin SynEdit1.Highlighter := SQLHighlight;  AutoCompletion.ItemList.Clear; end;
       'Unix' : begin SynEdit1.Highlighter := UnixHighlight; AutoCompletion.ItemList.Clear; end;
       'XML' : begin SynEdit1.Highlighter := XMLHighlight; AutoCompletion.ItemList.Clear; end;
       'HTML' : begin SynEdit1.Highlighter := HTMLHighlight; AutoCompletion.ItemList.Clear; end;
       'CSS' : begin SynEdit1.Highlighter := CSSHighlight; AutoCompletion.ItemList.Clear; end;
       'PHP' : begin SynEdit1.Highlighter := PHPHighlight; AutoCompletion.ItemList.Clear; end;
     end;
end;

procedure TForm1.InitializeNewFile();
begin
     SynEdit1.Text := '';
     SynEdit1.CommandProcessor(TSynEditorCommand(ecSelectAll), ' ', nil);
     SynEdit1.CommandProcessor(TSynEditorCommand(ecCopy), ' ', nil);
     SynEdit1.CommandProcessor(TSynEditorCommand(ecCut), ' ', nil);
     SynEdit1.CommandProcessor(TSynEditorCommand(ecPaste), ' ', nil);
     SynEdit1.Text := '';
     SetFileName('./Unnamed.txt');
     LabelFileName.Caption := GetFileName();
     SetStyles();
     SynEdit1.Modified := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     if Paramcount = 1 then
     begin
          //LoadAutoCompleters;
          BootOfflineFile(ParamStrUTF8(1));
          SetOnlineStatus(false);
          UpdateOnlineStatus();
          SynEdit1.Modified := false;
     end else begin
         //LoadAutoCompleters;
         InitializeNewFile();
         SetOnlineStatus(false);
         UpdateOnlineStatus();
         SynEdit1.Modified := false;
     end;
end;

procedure TForm1.MenuItemAboutClick(Sender: TObject);
begin
     FormAbout.Show;
end;

procedure TForm1.MenuItemCopyClick(Sender: TObject);
begin
     SynEdit1.CommandProcessor(TSynEditorCommand(ecCopy), ' ', nil);
end;

procedure TForm1.MenuItemCutClick(Sender: TObject);
begin
     //SynEdit1.CommandProcessor(TSynEditorCommand(ecCopy), ' ', nil);
     SynEdit1.CommandProcessor(TSynEditorCommand(ecCut), ' ', nil);
end;

procedure TForm1.MenuItemFontClick(Sender: TObject);
begin
     FontDialog1.Font := SynEdit1.Font;
     if FontDialog1.Execute then
     begin
          SynEdit1.Font := FontDialog1.Font;
     end;
end;

procedure TForm1.MenuItemNewClick(Sender: TObject);
begin
     if SynEdit1.Modified then begin
        if mrOK=MessageDlg('Are you sure you want to exit without saving a file?',mtConfirmation,[mbOK,mbCancel],0) then
        begin
             InitializeNewFile();
        end;
     end else begin
         InitializeNewFile();
     end;
end;

procedure TForm1.MenuItemOpenClick(Sender: TObject);
begin
     if SynEdit1.Modified then begin
        if mrOK=MessageDlg('Are you sure you want to exit without saving a file?',mtConfirmation,[mbOK,mbCancel],0) then
        begin
             OpenOfflineFile();
             SetStyles();
        end;
     end else begin
         OpenOfflineFile();
         SetStyles();
     end;
end;

procedure TForm1.MenuItemPasteClick(Sender: TObject);
begin
     SynEdit1.CommandProcessor(TSynEditorCommand(ecPaste), ' ', nil);
end;

procedure TForm1.MenuItemQuitClick(Sender: TObject);
begin
     if SynEdit1.Modified then begin
        if mrOK=MessageDlg('Are you sure you want to exit without saving a file?',mtConfirmation,[mbOK,mbCancel],0) then
        begin
          Application.Terminate;
          Exit;
        end;
     end else begin
         Application.Terminate;
         Exit;
     end;
end;

procedure TForm1.MenuItemSaveAsClick(Sender: TObject);
begin
     if SaveDialog1.Execute then begin
        SynEdit1.Lines.SaveToFile(SaveDialog1.FileName);
        SetFileName(SaveDialog1.FileName);
        LabelFileName.Caption := GetFileName();
        SynEdit1.Modified := false;
        SetStyles();
     end else begin
         Abort;
     end;
end;

procedure TForm1.MenuItemSaveClick(Sender: TObject);
var
   FFileName : String;
begin
     if SynEdit1.Modified then begin
     try
        SynEdit1.Lines.SaveToFile(GetFileName());
        SynEdit1.Modified := false;
        SetStyles();
     except
           MenuItemSave.Click;
     end;
end;
end;

procedure TForm1.MenuItemSelectAllClick(Sender: TObject);
begin
     SynEdit1.CommandProcessor(TSynEditorCommand(ecSelectAll), ' ', nil);
end;

procedure TForm1.MenuItemSignInClick(Sender: TObject);
begin

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
     SetHighlighter();
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
end;

procedure TForm1.LoadFPCCompleters;
begin
     AutoCompletion.ItemList.Clear;
     AutoCompletion.ItemList.Add('assignfile(file, path);');
     AutoCompletion.ItemList.Add('begin');
     AutoCompletion.ItemList.Add('begin {instructions} end;');
     AutoCompletion.ItemList.Add('Boolean');
     AutoCompletion.ItemList.Add('case x of');
     AutoCompletion.ItemList.Add('Char');
     AutoCompletion.ItemList.Add('end;');
     AutoCompletion.ItemList.Add('end.');
     AutoCompletion.ItemList.Add('except');
     AutoCompletion.ItemList.Add('Extended');
     AutoCompletion.ItemList.Add('File');
     AutoCompletion.ItemList.Add('finally');
     AutoCompletion.ItemList.Add('for (i in varset) do');
     AutoCompletion.ItemList.Add('for i := 1 to n do');
     AutoCompletion.ItemList.Add('for i := n downto 1 do');
     AutoCompletion.ItemList.Add('function f(x : type): type;');
     AutoCompletion.ItemList.Add('if ({condition}) then');
     AutoCompletion.ItemList.Add('Integer');
     AutoCompletion.ItemList.Add('procedure proc;');
     AutoCompletion.ItemList.Add('program prg_name;');
     AutoCompletion.ItemList.Add('read(var);');
     AutoCompletion.ItemList.Add('readln(var);');
     AutoCompletion.ItemList.Add('Real');
     AutoCompletion.ItemList.Add('repeat');
     AutoCompletion.ItemList.Add(concat('repeat {commands}', #13#10, 'until ({condition});'));
     AutoCompletion.ItemList.Add('String');
     AutoCompletion.ItemList.Add('then');
     AutoCompletion.ItemList.Add('try');
     AutoCompletion.ItemList.Add('until');
     AutoCompletion.ItemList.Add('until ({condition});');
     AutoCompletion.ItemList.Add('uses');
     AutoCompletion.ItemList.Add('var');
     AutoCompletion.ItemList.Add('while ({condition}) do');
     AutoCompletion.ItemList.Add('write(''text'');');
     AutoCompletion.ItemList.Add('writeln(''text'');');
end;

procedure TForm1.LoadCPPCompleters;
begin
     AutoCompletion.ItemList.Clear;
     AutoCompletion.ItemList.Add('#include <');
     AutoCompletion.ItemList.Add('#include <library>');
     AutoCompletion.ItemList.Add(concat('#include <stdio.h>', #13#10#13#10, 'int main() {', #13#10#9, '/*your code here*/', #13#10#9,'return 0;', #13#10, '}'));
     AutoCompletion.ItemList.Add(concat('#include <stdio.h>', #13#10#13#10, 'int main(int argc, char** argv) {', #13#10#9, '/*your code here*/', #13#10#9,'return 0;', #13#10, '}'));
     AutoCompletion.ItemList.Add('bool');
     AutoCompletion.ItemList.Add('break');
     AutoCompletion.ItemList.Add('case x : ');
     AutoCompletion.ItemList.Add('continue');
     AutoCompletion.ItemList.Add('default');
     AutoCompletion.ItemList.Add('define');
     AutoCompletion.ItemList.Add('do');
     AutoCompletion.ItemList.Add(concat('do {/*commands*/', #13#10, '} while (/*condition*/);'));
     AutoCompletion.ItemList.Add('double');
     AutoCompletion.ItemList.Add('else');
     AutoCompletion.ItemList.Add('float');
     AutoCompletion.ItemList.Add('for');
     AutoCompletion.ItemList.Add('for (int i = 0; i < n; i++)');
     AutoCompletion.ItemList.Add('if');
     AutoCompletion.ItemList.Add('if (/*condition*/)');
     AutoCompletion.ItemList.Add('if (/*condition*/) {/*commands*/}');
     AutoCompletion.ItemList.Add('include');
     AutoCompletion.ItemList.Add('int');
     AutoCompletion.ItemList.Add('int main()');
     AutoCompletion.ItemList.Add('int main(int argc, char** argv)');
     AutoCompletion.ItemList.Add(concat('int main() {', #13#10#9, '/*your code here*/', #13#10#9,'return 0;', #13#10, '}'));
     AutoCompletion.ItemList.Add(concat('int main(int argc, char** argv) {', #13#10#9, '/*your code here*/', #13#10#9,'return 0;', #13#10, '}'));
     AutoCompletion.ItemList.Add('long');
     AutoCompletion.ItemList.Add('long int');
     AutoCompletion.ItemList.Add('long double');
     AutoCompletion.ItemList.Add('pragma');
     AutoCompletion.ItemList.Add('printf("text");');
     AutoCompletion.ItemList.Add('return');
     AutoCompletion.ItemList.Add('return 0;');
     AutoCompletion.ItemList.Add('scanf("text");');
     AutoCompletion.ItemList.Add('short');
     AutoCompletion.ItemList.Add('short int');
     AutoCompletion.ItemList.Add('string');
     AutoCompletion.ItemList.Add('switch (x)');
     AutoCompletion.ItemList.Add('using');
     AutoCompletion.ItemList.Add('using namespace std;');
     AutoCompletion.ItemList.Add('void');
     AutoCompletion.ItemList.Add('while');
     AutoCompletion.ItemList.Add('while (/*condition*/) {/*commands*/}');
end;


end.

