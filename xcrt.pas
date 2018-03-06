{
   ====================================================================
   xLib - xCrt                                                     xqtr
   ====================================================================

   This file is part of xlib for FreePascal
    
   To use this Unit you need the source code of MysticBBS from here:
   https://github.com/fidosoft/mysticbbs, which is shared under GPL
    
   For contact look at Another Droid BBS [andr01d.zapto.org:9999],
   FSXNet and ArakNet.
   
   --------------------------------------------------------------------
   
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
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
}

{$IFDEF FPC}
  {$mode objfpc}
  {$PACKRECORDS 1}
  {$H-}
  {$V-}
{$EndIF}

Unit xcrt;

interface

{$IFDEF WIN32}
  uses
    Windows,
{$EndIF}
{$IFDEF UNIX}
  uses
    Unix,
{$EndIF}
  m_output,
  m_input,
  m_types;

const
  {$IFDEF UNIX}
    PathSep = '/';
    PathChar = '/';
  {$ELSE}
    PathSep = '\';
    PathChar = '\';
  {$EndIF}
  EOL = #13#10;
  AnsiColours: Array[0..7] of Integer = (0, 4, 2, 6, 1, 5, 3, 7);
  CHARS_ALL = '`1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,./~!@#$%^&*()_+|'+
              'QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>? ';
  CHARS_ALPHA = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  CHARS_NUMERIC = '1234567890.,+-';
  CHARS_FILENAME = '1234567890-=\/qwertyuiop[]asdfghjkl;''zxcvbnm,.~!@#$%^&()_+'+
                   'QWERTYUIOP{}ASDFGHJKL:ZXCVBNM ';
  
  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;
  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;


  Home          = #71;      
  CursorUp      = #72;     
  PgUp          = #73;
  CursorLeft    = #75;      
  Num5          = #76;     
  CursorRight   = #77;
  EndKey        = #79;
  CursorDown    = #80;
  PgDn          = #81;
  Ins           = #82;
  Del           = #83;
  BackSpace     = #8;
  Tab           = #9;
  Enter         = #13;
  Esc           = #27;
  forwardslash  = #47;
  asterisk      = #42;
  minus         = #45;
  plus          = #43;
  F1            = #59;
  F2            = #60;
  F3            = #61;
  F4            = #62;
  F5            = #63;
  F6            = #64;
  F7            = #65;
  F8            = #66;
  F9            = #67;
  F10           = #68;
  F11           = #69;
  F12           = #70;
  
  CtrlA  = #1; 
  CtrlB  = #2; 
  //CtrlC  = #3; 
  CtrlD  = #4; 
  CtrlE  = #5; 
  CtrlF  = #6; 
  CtrlG  = #7; 
  CtrlH  = #8; 
  CtrlI  = #9; 
  CtrlJ  = #10;
  CtrlK  = #11;
  CtrlL  = #12;
  CtrlM  = #13;
  CtrlN  = #14;
  CtrlO  = #15;
  CtrlP  = #16;
  CtrlQ  = #17;
  CtrlR  = #18;
  CtrlS  = #19;
  CtrlT  = #20;
  CtrlU  = #21;
  CtrlV  = #22;
  CtrlW  = #23;
  CtrlX  = #24;
  CtrlY  = #25;
  CtrlZ  = #26;
  
  Alt1 = #248;
  Alt2 = #249;
  Alt3 = #250;
  Alt4 = #251;
  Alt5 = #252;
  Alt6 = #253;
  Alt7 = #254;
  Alt8 = #255;
  Alt9 = #134;
  Alt0 = #135;
  
type
  
    SmallWord = System.Word;
    TCharInfo = packed record
      Ch:   char;
      Attr: byte;
    End;
  
  
  TScreenBuf = TConsoleImageRec;
  
  var
    FileModeReadWrite: Integer;
    TextModeRead: Integer;
    TextModeReadWrite: Integer;
    Screen : TOutput;
    Keyboard : TInput;
    WindMax:Byte;
    WindMin:Byte;
    ScreenHeight:Byte;
    ScreenWidth:Byte;


Procedure RestoreScreen(var screenBuf: TConsoleImageRec);
Procedure SaveScreen(var screenBuf: TConsoleImageRec);
Function  GetAttrAt(AX, AY: Byte): Byte;
Function  GetCharAt(AX, AY: Byte): Char;
Procedure SetAttrAt(AAttr, AX, AY: Byte);
Procedure SetCharAt(ACh: Char; AX, AY: Byte);
Procedure ClearEOL;
Procedure Delay (MS: Word);
Procedure LowVideo;
Procedure NormVideo;
Function  CurrentFG: Byte;
Function  CurrentBG: Byte;
Procedure TextBackground(CL: Byte);
Procedure HighVideo;
Procedure TextColor(CL: Byte);
Function FgColor(Attr:Byte):Byte;
Function BgColor(Attr:Byte):Byte;
Procedure GotoXY(X,Y:Byte);
Procedure GotoX(X:Byte);
Procedure GotoY(Y:Byte);
Procedure ClrScr;

Procedure WriteXY (X, Y, A: Byte; Text: String);
Procedure WriteXYPipe (X, Y, Attr:Byte; Text: String);
Procedure WritePipe (Str: String);
Procedure WriteLn; Overload;
Procedure WriteLn(S:String); Overload;
Procedure Write(S:String);

Procedure CenterLine(S:String; L:byte);

Procedure HalfBlock;
Procedure CursorBlock;
Procedure BufFlush;
Procedure BufAddStr (Str: String);

Procedure ClearArea(x1,y1,x2,y2:Byte;C:Char);

Function CTRLC:Boolean;
Function WhereY:Byte;
Function WhereX:Byte;
Procedure SetTextAttr(A:Byte);
Function GetTextAttr:Byte;
Function AttrToAnsi (Attr: Byte) : String;

Function    KeyWait (MS: LongInt) : Boolean;
Function    KeyPressed : Boolean;
Function    ReadKey : Char;
Function    FAltKey (Ch : Char) : Byte;

procedure enable_ansi_unix;


implementation

{$IFDEF FPC}
  uses
    crt,baseunix;
{$EndIF}

{$IFDEF WIN32}
  var
    StdOut: THandle;
{$EndIF}

Function strMCILen (Str: String) : Byte;
Var
  A : Byte;
Begin
  Repeat
    A := Pos('|', Str);
    If (A > 0) and (A < Length(Str) - 1) Then
      Delete (Str, A, 3)
    Else
      Break;
  Until False;

  strMCILen := Length(Str);
End;

Function AttrToAnsi (Attr: Byte) : String;
Begin
  Screen.AttrToAnsi(Attr);
End;

Procedure WriteLn; Overload;
Begin
  Screen.WriteLine('');
End;

Procedure WriteLn(S:String); Overload;
Begin
  Screen.WriteLine(S);
End;

Procedure Write(S:String);
Begin
  Screen.WriteStr(S);
End;

Procedure ClrScr;
Begin
  Screen.ClearScreen
End;

Function GetAttrAt(AX, AY: Byte): Byte;
Begin
  Result:=Screen.ReadAttrXY (AX, AY);
End;

Function GetCharAt(AX, AY: Byte): Char;
Begin

  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  Begin
    GetCharAt := ' ';
    Exit;
  End;

  GetCharAt := Screen.Buffer[AY][AX].UnicodeChar;
End;

Procedure GotoXY(X,Y:Byte);
Begin
  Screen.CursorXY(x,y);
End;

Procedure GotoX(X:Byte);
Begin
  Screen.CursorXY(x,Screen.CursorY);
End;

Procedure GotoY(Y:Byte);
Begin
  Screen.CursorXY(Screen.CursorX,y);
End;

Function WhereX:Byte;
Begin
 Result := Screen.CursorX;
End;

Function WhereY:Byte;
Begin
 Result := Screen.CursorY;
End;

Procedure RestoreScreen(var screenBuf: TConsoleImageRec);
Begin
  Screen.PutScreenImage(Screenbuf);
End;

Procedure SaveScreen(var screenBuf: TConsoleImageRec);
Begin
  Screen.GetScreenImage (1, 1, 80, 25, screenBuf);
End;

Procedure SetAttrAt(AAttr, AX, AY: Byte);
Begin
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;
  Screen.Buffer[AY][AX].Attributes := AAttr;
End;


Procedure SetCharAt(ACh: Char; AX, AY: Byte);
Begin
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;
  Screen.Buffer[AY][AX].UnicodeChar := ACh;
End;

Function CurrentFG: Byte;
Begin
  CurrentFG := Screen.TextAttr and $0f
End;

Function CurrentBG: Byte;
Begin
  CurrentBG := (Screen.TextAttr and $f0) shr 4     { shift right beyotch }
End;

Procedure TextColor(CL: Byte);
  Begin
  With Screen Do Begin
  TextAttr := TextAttr and $F0;
  TextAttr := TextAttr or (CL and $0F);
  End;
End;

Procedure TextBackground(CL: Byte);
  Begin
  With Screen Do Begin
  TextAttr := TextAttr and $0F;
  TextAttr := TextAttr or (CL shl 4);
  End;
End;
  
Function BgColor(Attr:Byte):Byte;
Begin
  BgColor:=Attr div 16;
End;

Function FgColor(Attr:Byte):Byte;
Begin
  FgColor:=Attr mod 16;
End;

Procedure WriteXY (X, Y, A: Byte; Text: String);
Begin
  Screen.WriteXY(X,Y,A,Text);
End;

Procedure WriteXYPipe (X, Y, Attr: Byte; Text: String);
Begin
  Screen.WriteXYPipe(x,y,attr,strMCILen(text),text);
End;

Procedure ClearEOL;
Begin
  Screen.ClearEOL;
End;

Procedure SetWindow (X1, Y1, X2, Y2: Byte; Home: Boolean);
Begin
  Screen.SetWindow(x1,y1,x2,y2,home);
End;

Procedure CenterLine(S:String; L:byte);
Begin
 Screen.WriteXYPipe((40-strMCILen(s) div 2),L,7,strMCILen(s),S);
End;

Procedure CursorBlock;
Begin
  {$IFDEF Linux}
  Writeln (#27 + '[?112c'+#7);
  {$ENDIF}
End;

Procedure HalfBlock;
Begin
  {$IFDEF Linux}
  Writeln (#27 + '[?2c'+#7);
  {$ENDIF}
End;

Procedure SetTextAttr(A:Byte);
Begin
  Screen.TextAttr:=A;
End;

Function GetTextAttr:Byte;
Begin
  Result:=Screen.TextAttr;
End;

Function CTRLC:Boolean;
Begin
  CTRLC := False;
  if KeyPressed then            //  <--- CRT function to test key press
    if ReadKey = ^C then        // read the key pressed
      begin
        writeln('Ctrl-C pressed');
        CTRLC := True;
      end;
End;

Procedure BufFlush;
Begin
  Screen.BufFlush;
End;

Procedure BufAddStr (Str: String);
Begin
  Screen.BufAddStr (Str);
End;

Procedure WritePipe (Str: String);
Begin  
  Screen.WritePipe(Str);
End;

Procedure ClearArea(x1,y1,x2,y2:Byte;C:Char);
Var
  i,d:Byte;
Begin
  For i := y1 to y2 Do
    Screen.WriteXY(x1,i,Screen.TextAttr,StringOfChar(c,x2-x1));
End;

Function KeyPressed : Boolean;
Begin
  Result:=Keyboard.KeyPressed
End;

Function KeyWait (MS: LongInt) : Boolean;
Begin
  Result:=Keyboard.KeyWait(MS);
End;

Function ReadKey : Char;
Begin
  Result:=Keyboard.ReadKey
End;

Function    FAltKey (Ch : Char) : Byte;    
Begin
  Result:=Keyboard.FAltKey(Ch);
End;

Procedure Delay (MS: Word);
Begin
  {$IFDEF WIN32}
    Sleep(MS);
  {$ENDIF}

  {$IFDEF UNIX}
    fpSelect(0, Nil, Nil, Nil, MS);
  {$ENDIF}
End;

Procedure HighVideo;
Begin
  TextColor(Screen.TextAttr Or $08);
End;

Procedure LowVideo;
Begin
  TextColor(Screen.TextAttr And $77);
End;

Procedure NormVideo;
Begin
  TextColor(7);
  TextBackGround(0);
End;

procedure enable_ansi_unix;
begin
  Write(#27 + '(U' + #27 + '[0m');
end; 
    

Initialization
Begin
  Screen := TOutput.Create(True);
  Keyboard := TInput.Create;
  ScreenHeight:=Crt.ScreenHeight;
  ScreenWidth:=Crt.ScreenWidth;
  WindMax:=Crt.WindMax;
  WindMin:=crt.WindMin;

End;

Finalization
Begin
  Screen.Free;
  KeyBoard.Free;
End;


End.
