unit UnitAbout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.lfm}

{ TFormAbout }


procedure TFormAbout.FormActivate(Sender: TObject);
begin
     Label1.Caption := 'Version:'+#13#10+
                       'Author:'+#13#10+
                       'Contact:'+#13#10+
                       'Release Date:';
     Label2.Caption := '0.2'+#13#10+
                       'Paul Lipkowski'+#13#10+
                       'redthreat19@gmail.com'+#13#10+
                       'October 21, 2017';
     Label3.Caption := 'For better programming, '+#13#10+
                       'code editing and sharing,'+#13#10+
                       'since 10/4/2017.';
end;

end.

