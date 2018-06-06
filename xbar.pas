{
   ====================================================================
   xLib - xCrt                                                     xqtr
   ====================================================================

   This file is part of xlib for FreePascal
    
   https://github.com/xqtr/xlib
    
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

Unit xBar;
{$MODE objfpc}
{$H-}

Interface

Uses 
  xCrt,
  Classes;
  
Const
  RNoItems    = -1000;
  REnter      = -999;
  REsc        = -998;
  RBackSpace  = -997;
  RLeft       = -996;
  RRight      = -995;
  RPlus       = -994;
  RMinus      = -993;
  RAsterisk   = -992;
  RDiv        = -991;

Type
  
  TBItem = Record
    Text : String;
    Field1 : String;
  End;
  
  TBar = Class
    Protected
      BarPos : Integer;
      FBarOnC : String;
      FBarOffC: String;
      FX,FY   : Byte;
      FTotal  : Integer;
      FMore   : Boolean;
      FMoreX  : BYte;
      FMoreY  : BYte;
      FMoreCol:String;
      FKey    : Boolean;
      FSearch : String;
      FDoBar  : Boolean;
      FBarBgC : Char;
      FBarFgC : Char;
      FBarBgCl: Byte;
      FBarFgCl: Byte;
    
      FSearchX: BYte;
      FSearchY: BYte;
      FSearchA: BYte;
      search_idx : Integer;
    Public
    Items   : Array Of TBItem;
    OnSelect: Procedure(i:integer);
    OnEnter : Procedure(i:integer);
    OnOtherKey : Procedure(C:Char; i:integer);
    Constructor Create;
    Destructor  Destroy; Override;
    Procedure Add(S:String);
    Procedure Sort;
    Procedure Clear;
    //Procedure Delete(i:Integer);
    Function DrawMenu(x,y,w,h:Byte;Bar:Integer):Integer;
    Property BarOnCl   : String Read FBarOnc Write FBarOnc;
    Property BarOFFCl  : String Read FBarOffc Write FBarOffc;
    Property MoreCl    : String Read FMoreCol Write FMoreCol;
    Property Position : Integer read BarPos Write BarPos;
    Property Key : Boolean Read FKey write fkey;
    Property Search:String Read FSearch Write FSEarch;
    Property SearchX:Byte Read FSearchX write FsearchX;
    Property Searchy:Byte Read FSearchy write Fsearchy;
    Property SearchA:Byte Read FSearchA write FsearchA;
    Property DoBar  :Boolean Read FDoBar Write FDoBar;
    Property BarBgC: Char Read FBarBgC Write FBarBgC;
    Property BarFgC : Char Read FBarFgC Write FBarFgC;
    Property BarBgCl: Byte Read FBarBgCl Write FBarBgCl;
    Property BarFgCl: Byte Read FBarFgCl Write FBarFgCl;
  End;




Implementation

  Uses
    xStrings;

Constructor TBar.Create;
Begin
  Inherited Create;
  SetLength(Items,0);
  FBarOnC := '|23|00';
  FBarOFFC := '|07|16';
  FKey := False;
  Fmore := False;
  Fmorex:=1;
  fmorey:=1;
  ftotal:=0;
  fmorecol:='|08|16';  
  fx:=1;
  fy:=1;
  OnSelect:=nil;
  OnOtherKey := nil;
  OnEnter :=nil;
  FSearch :='';
  FSearchX:=0;
  FSearchY:=0;
  FSearchA:=7;
  search_idx:=0;
  FDoBar:=False;
  FBarBgC := Chr(176);
  FBarFgC := Chr(178);
  FBarBgCl := 8;
  FBarFgCl := 15;
  
End;

Destructor TBar.Destroy;
Begin
  SetLength(Items,1);
  Inherited Destroy;
End;

Procedure TBar.Add(S:String);
Begin
  SetLength(Items,Length(Items)+1);
  Items[High(Items)].Text:=S;
  Items[High(Items)].Field1:='';
  FTotal :=Length(Items);
ENd;
{
Procedure  TBar.Delete(i:Integer);
Begin
  Items.Delete(i);
  FTotal :=Items.Count;
ENd;}

Procedure TBar.Clear;
Begin
  SetLength(Items,0);
  Ftotal:=-1;
  BarPos:=0;
End;

Function TBar.DrawMenu(x,y,w,h:Byte;Bar:Integer):Integer;
Var
  Ch : Char;
  Ch2: Char;
  TopPage   :Integer = 0;
  More      :Integer;
  LastMore  :Integer;
  Temp      :Integer;
  Temp2     :Integer;
  Done      : Boolean;
  
  Procedure DrawBar;
  Var
    d : Byte;
  Begin
    If Length(Items)=0 Then Exit;
    For d:=0 to h-1 Do WriteXY(x+w-1,y+d,FBarBgCl,FBarBgC);
    if BarPos=0 Then d:=0 Else
      If BarPos=Length(Items)-1 Then D:=h-1 Else
        d:= BarPos * (h) Div Length(Items);
    WriteXY(x+w-1,y+d,FBarFgCl,FBarFgC);
  End;
      
  Procedure BarON;
  Begin
    If length(Items)=0 Then Exit;
    WriteXYPipe(x, y + BarPos - TopPage,7,fbaronc+StrPadR(Items[BarPos].text, w, ' '));
    If Assigned(OnSelect) Then OnSelect(BarPos);
  end;

  Procedure BarOFF;
  begin
    If Length(Items)=0 Then Exit;
    WriteXYPipe(x, y + BarPos - TopPage,7,fbaroffc+StrPadR(Items[BarPos].text, w, ' '))
  end;
  
  Procedure DrawPage;
  Var
    tmp: Integer;
  begin
    //If High(Items)=0 Then Exit;
    Temp2 := BarPos;
    For tmp := 0 to h - 1 do begin 
      //writexy(1,1,15,'toppage: '+int2str(toppage)+'/total:'+int2str(ftotal)+'/barpos:'+int2str(barpos));
      If Toppage+tmp<=fTotal-1 Then Begin
        BarPos := TopPage + tmp;
        BarOFF;
      End Else WriteXY(x,y+tmp,7,StrRep(' ',w));
    end;
    BarPos := Temp2;
    BarON;
  end;

  Procedure MakeSearch;
  Var
    i : Integer;
  Begin
    If Length(Items)=0 THen Exit;
    for I:=Search_idx to High(Items) do begin
      if Pos(FSearch,Upper(Items[i].Text))>0 then begin
        TopPage := i;
        BarPos  := i;
        search_idx:=i;
        DrawPage;
        break;
      end;
    end;
  End;
  
Begin
  {If FTotal=0 THen Begin
    Result:=RNoItems;
    exit;
  End;}
  If Bar > FTotal-1 Then Begin
    TopPage  := 0;
    BarPos   := 0;
  End Else
  If Bar > FTotal - h Then Begin
    TopPage  := FTotal - h ;
    if TopPage<0 Then TopPage:=0;
    BarPos   := Bar;
  End Else Begin
    TopPage  := Bar;
    BarPos   := Bar;
  End;
  
  Done     := False;
  More     := 0;
  LastMore := 0;
  Result := -1;
        
  DrawPage;
  
  Repeat
    More := 0;
    Ch   := ' ';
    Ch2  := ' ';
    
    If FMore THen Begin
      If TopPage > 1 Then begin
        More := 1;
        Ch   := Chr(244);
      End;

      If TopPage + h-1 < fTotal Then begin
        Ch2  := Chr(245);
        More := More + 2;
      End;

      If More <> LastMore Then begin
        LastMore := More;
        GotoXY (fMoreX, fMoreY);
        WritePipe (fmorecol+ Ch + Ch2 + ' more');
      End;
    End;
    
    If Fsearchx<>0 THen Begin
      Writexy(Fsearchx,fsearchy,fsearcha,fsearch);
    End;
    If FDoBar THen DrawBar;
    Ch := ReadKey;
    If Ch=#00 Then begin
      Ch := ReadKey;
      if ch = Home then begin
        TopPage := 0;
        BarPos  := 0;
        search_idx :=0;
        drawpage;
      end;
      if ch = EndKey then begin
        if fTotal > h then begin
          TopPage := fTotal - h; //+1;
          BarPos  := fTotal-1;
        end else begin
          BarPos  := fTotal-1 ;
        end;
        search_idx :=0;
        drawpage;
      end;
      
      If Ch = CursorLeft Then BEgin
        Result := RLeft;
        search_idx :=0;
        DOne:=true;
      End;
      
      If Ch = CursorRight Then BEgin
        Result := RRight;
        search_idx :=0;
        DOne:=true;
      End;
  
      If Ch = CursorUp Then begin
        search_idx :=0;
        If BarPos > TopPage Then begin
          BarOFF;
          BarPos := BarPos - 1;
          BarON;
          end
        Else
        If TopPage > 0 Then begin
          TopPage := TopPage - 1;
          BarPos  := BarPos  - 1;
          DrawPage;
        End;
      end;
  
      If Ch = PgUp Then begin
        If FKey Then Begin
            If Assigned(OnOtherKey) Then Begin
              OnOtherKey('[',BarPos);
              DrawPage;
            End;
          End Else Begin
          search_idx :=0;
          If TopPage - h >= 0 Then begin
            TopPage := TopPage - h;
            BarPos  := BarPos  - h;
            DrawPage;
            end
          Else begin
            TopPage := 0;
            BarPos  := 0;
            DrawPage;
          End;
        End;
      end;
  
    If Ch = CursorDown Then begin
      search_idx :=0;
      If BarPos < fTotal-1 Then
        If BarPos < TopPage + h - 1 Then begin
          BarOFF;
          BarPos := BarPos + 1;
          BarON;
          end
        Else
        If BarPos < fTotal-1 Then begin
          TopPage := TopPage + 1;
          BarPos  := BarPos  + 1;
          DrawPage;
        End;
      End;
      
      If Ch = PgDn Then begin //PGDN
        If FKey Then Begin
          If Assigned(OnOtherKey) Then Begin
            OnOtherKey(']',BarPos);
            DrawPage;
          End;
        End Else Begin
          search_idx :=0;
          If FTotal > h Then begin
            if toppage+h<ftotal-1 then begin
              toppage:=toppage+h;
              barpos:=toppage;
              drawpage;
            end else begin
              toppage:=ftotal-h;
              barpos:=ftotal-1;
              drawpage;
            end;
        End;
      end;
{        If FTotal  > h Then
          If TopPage + h < FTotal - h - 1 Then begin
            TopPage := TopPage + h-1;
            BarPos  := BarPos  + h-1;
            DrawPage;
            end
          Else
          begin
            TopPage := FTotal - h -1;
            BarPos  := FTotal-1;
            DrawPage;
          End
        Else
        begin
          BarOFF;
          BarPos := FTotal-1;
          BarON;
        End;}
     End;

  //ch:=#0
  End Else Begin
    If (Ch = Chr(27)) Then Begin
      Result:=REsc;
      Done := True;
    End Else
    If (Ch = Chr(13)) And (FTotal >= 0) Then Begin
      Result := BarPos;
      If Assigned(OnEnter) Then OnEnter(BarPos);
      Done := True;
    End;
    If Fkey Then Begin
      If (Ch = '+') Then Begin
          Result:=RPlus;
          Done := True;
      End Else
      If (Ch = '*') Then Begin
          Result:=RAsterisk;
          Done := True;
      End Else
      If (Ch = '-') Then Begin
          Result:=RMinus;
          Done := True;
      End Else
      If (Ch = '/') Then Begin
          Result:=RDiv;
          Done := True;
      End Else
      If (Ch = BackSpace) Then Begin
          Result:=RBackSpace;
          Done := True;
      End Else
      If Assigned(OnOtherKey) Then Begin
        OnOtherKey(Ch,BarPos);
        DrawPage;
      End;
    End Else Begin
      If Ch=Chr(1) THen Begin  //CTRL-A
        if Search_idx+1<=High(items) then
          search_idx:=search_idx+1 Else
          search_idx:=0;
        MakeSearch;
      End Else
      If (Ch>=Chr(32)) And (Ch<=Chr(128)) Then Begin
        FSearch:=FSearch+Upper(Ch);
        search_idx:=0;
        MakeSearch;
      End Else
      If (Ch = BackSpace) Then Begin
        Delete(FSearch,Length(FSearch),1);
        WriteXY(FSearchx,FSearchY,FSearchA,Upper(FSearch)+' ');
        Search_idx:=0;
        MakeSearch;
      End Else
      If Ch = Chr(25) then begin //CTRL-Y
        GotoXY(FSearchX,FSearchY);
        Write(StrRep(' ',Length(FSearch)));
        FSearch:='';
        search_idx:=0
      End;
    End;
  End;
  
     
      
  Until Done;
End;

Procedure TBar.Sort;
Var
  i, j:integer;
  temp : TBItem;
Begin
  If FTotal<=1 Then Exit;
	for j:=1 to FTotal do
    For i := 2 to Ftotal do begin
      if Items[i-1].Text>Items[i].Text then begin
        temp:=Items[i-1];
        Items[i-1]:=Items[i];
        Items[i]:=temp;
      end;
	end;
End;

End.
