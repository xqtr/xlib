{
   ====================================================================
   xLib - xJAM                                                     xqtr
   ====================================================================
   This file is part of xlib for FreePascal
   
   This unit is based on code from MysticBBS 1.10 source code and also
   the MK Source for Msg Access v1.06 - Mark May's.
   
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

Unit xJAM;
{$Mode objfpc}
{$warnings off}
{$packrecords default}

Interface

Uses SysUtils,Classes,xstrings;

Const
  JamIdxBufSize = 200;
  JamSubBufSize = 4000;
  JamTxtBufSize = 4000;
  TxtSubBufSize = 2000;
  
  Const
  CRC_32_TAB: Array[0..255] of LongInt = (
    $00000000, $77073096, $ee0e612c, $990951ba, $076dc419, $706af48f, $e963a535, $9e6495a3,
    $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988, $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91,
    $1db71064, $6ab020f2, $f3b97148, $84be41de, $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7,
    $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec, $14015c4f, $63066cd9, $fa0f3d63, $8d080df5,
    $3b6e20c8, $4c69105e, $d56041e4, $a2677172, $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b,
    $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940, $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59,
    $26d930ac, $51de003a, $c8d75180, $bfd06116, $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f,
    $2802b89e, $5f058808, $c60cd9b2, $b10be924, $2f6f7c87, $58684c11, $c1611dab, $b6662d3d,
    $76dc4190, $01db7106, $98d220bc, $efd5102a, $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433,
    $7807c9a2, $0f00f934, $9609a88e, $e10e9818, $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01,
    $6b6b51f4, $1c6c6162, $856530d8, $f262004e, $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457,
    $65b0d9c6, $12b7e950, $8bbeb8ea, $fcb9887c, $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65,
    $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2, $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb,
    $4369e96a, $346ed9fc, $ad678846, $da60b8d0, $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9,
    $5005713c, $270241aa, $be0b1010, $c90c2086, $5768b525, $206f85b3, $b966d409, $ce61e49f,
    $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4, $59b33d17, $2eb40d81, $b7bd5c3b, $c0ba6cad,
    $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a, $ead54739, $9dd277af, $04db2615, $73dc1683,
    $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8, $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1,
    $f00f9344, $8708a3d2, $1e01f268, $6906c2fe, $f762575d, $806567cb, $196c3671, $6e6b06e7,
    $fed41b76, $89d32be0, $10da7a5a, $67dd4acc, $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5,
    $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252, $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
    $d80d2bda, $af0a1b4c, $36034af6, $41047a60, $df60efc3, $a867df55, $316e8eef, $4669be79,
    $cb61b38c, $bc66831a, $256fd2a0, $5268e236, $cc0c7795, $bb0b4703, $220216b9, $5505262f,
    $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04, $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d,
    $9b64c2b0, $ec63f226, $756aa39c, $026d930a, $9c0906a9, $eb0e363f, $72076785, $05005713,
    $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38, $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21,
    $86d3d2d4, $f1d4e242, $68ddb3f8, $1fda836e, $81be16cd, $f6b9265b, $6fb077e1, $18b74777,
    $88085ae6, $ff0f6a70, $66063bca, $11010b5c, $8f659eff, $f862ae69, $616bffd3, $166ccf45,
    $a00ae278, $d70dd2ee, $4e048354, $3903b3c2, $a7672661, $d06016f7, $4969474d, $3e6e77db,
    $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0, $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,
    $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6, $bad03605, $cdd70693, $54de5729, $23d967bf,
    $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94, $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d
  );

  Jam_Local =        $00000001;
  Jam_InTransit =    $00000002;
  Jam_Priv =         $00000004;
  Jam_Rcvd =         $00000008;
  Jam_Sent =         $00000010;
  Jam_KillSent =     $00000020;
  Jam_AchvSent =     $00000040;
  Jam_Hold =         $00000080;
  Jam_Crash =        $00000100;
  Jam_Imm =          $00000200;
  Jam_Direct =       $00000400;
  Jam_Gate =         $00000800;
  Jam_Freq =         $00001000;
  Jam_FAttch =       $00002000;
  Jam_TruncFile =    $00004000;
  Jam_KillFile =     $00008000;
  Jam_RcptReq =      $00010000;
  Jam_ConfmReq =     $00020000;
  Jam_Orphan =       $00040000;
  Jam_Encrypt =      $00080000;
  Jam_Compress =     $00100000;
  Jam_Escaped =      $00200000;
  Jam_FPU =          $00400000;
  Jam_TypeLocal =    $00800000;
  Jam_TypeEcho =     $01000000;
  Jam_TypeNet =      $02000000;
  Jam_NoDisp =       $20000000;
  Jam_Locked =       $40000000;
  Jam_Deleted =      $80000000;
  
Type  
  
  RecFileList = Record
    FileName  : String[70];
    Size      : LongInt;
    DateTime  : LongInt;
    Uploader  : String[30];
    Flags     : Byte;
    Downloads : LongInt;
    Rating    : Byte;
    DescPtr   : LongInt;
    DescLines : Byte;
  End;
  
  RecEchoMailAddr = Record
    Zone,
    Net,
    Node,
    Point : Word;
  End;

  MsgMailType = (mmtNormal, mmtEchoMail, mmtNetMail);

  JamHdrType = Record
    Signature  : Array[1..4] of Char;
    Created    : LongInt;
    ModCounter : LongInt;
    ActiveMsgs : LongInt;
    PwdCRC     : LongInt;
    BaseMsgNum : LongInt;
    Extra      : Array[1..1000] of Char;
  End;

  JamMsgHdrType = Record
    Signature   : Array[1..4] of Char;
    Rev         : Word;
    Resvd       : Word;
    SubFieldLen : LongInt;
    TimesRead   : LongInt;
    MsgIdCrc    : LongInt;
    ReplyCrc    : LongInt;
    ReplyTo     : LongInt;
    ReplyFirst  : LongInt;
    ReplyNext   : LongInt;
    DateWritten : LongInt;
    DateRcvd    : LongInt;
    DateArrived : LongInt;
    MsgNum      : LongInt;
    Attr1       : Cardinal;
    Attr2       : LongInt;
    TextOfs     : LongInt;
    TextLen     : LongInt;
    PwdCrc      : LongInt;
    Cost        : LongInt;
  End;
  
  SubFieldType = Record
    LoId    : Word;
    HiId    : Word;
    DataLen : LongInt;
    //Data    : Array[1..1000] of Char;
  End;

  JamIdxType = Record
    MsgToCrc : LongInt;
    HdrLoc   : LongInt;
  End;

  JamLastType = Record
    NameCrc  : LongInt;
    UserNum  : LongInt;
    LastRead : LongInt;
    HighRead : LongInt;
  End;
  
  TJamBase = Class
    Filename    : String;
    HeaderFile  : TFileStream;
    IndexFile   : TFileStream;
    TxtFile     : TFileStream;
    
    Header      : JamHdrType;
    MsgHeader   : JamMsgHdrType;
    
    MsgCount    : LongInt;
    MsgText     : TStringList;
    MsgNo       : LongInt;
    
    Dest        : RecEchoMailAddr;
    Orig        : RecEchoMailAddr;
    From        : String[65];
    Receipient  : String[65];
    Subject     : String[100];
    MsgDate     : String[8];
    MsgTime     : String[5];
    
    SubMSGID    : String[100];
    SubReplyID  : String[100];
    SubPID      : String[40];
    SubTrace    : String[100];
    EmbinDat    : Boolean;
    SubKludge   : String[255];
    SeenBy      : String;
    Path2d      : String;
    ZUTCINFO    : String;
    SubFlags    : String;
    
    Constructor Create;
    Destructor  Destroy; Override;
    
    Function Init:Boolean;
    
    Function LoadMsg(N:LongInt):Boolean;
    Function FirstMsg:Boolean;
    Function LastMsg:Boolean;
    Function GetMsgCount:LongInt;
    Function GetMsgText(N:LongInt):Boolean;
    Function NextMsg:Boolean;    
    
    Function IsLocal        : Boolean; 
    Function IsCrash        : Boolean; 
    Function IsKillSent     : Boolean; 
    Function IsSent         : Boolean; 
    Function IsFAttach      : Boolean; 
    Function IsFileReq      : Boolean; 
    Function IsRcvd         : Boolean; 
    Function IsPriv         : Boolean; 
    Function IsDeleted      : Boolean; 
    Function IsEncrypted    : Boolean; 
    Function IsCompressed   : Boolean; 
    Function IsEscaped      : Boolean; 
    Function IsLocked       : Boolean;     
  End;  

Implementation

Constructor TJamBase.Create;
Begin
  Inherited Create;
  MsgText := TStringList.Create;
End;

Function TJamBase.Init:Boolean;
Begin
  Result := False;
  If Filename='' Then Exit;
  Try
    HeaderFile := TFileStream.Create(Filename+'.jhr',fmOpenRead or fmShareDenyNone);
    HeaderFile.Seek(0,0);
    IndexFile := TFileStream.Create(Filename+'.jdx',fmOpenRead or fmShareDenyNone);
    IndexFile.Seek(0,0);
    TxtFile := TFileStream.Create(Filename+'.jdt',fmOpenRead or fmShareDenyNone);
    TxtFile.Seek(0,0);
  Except
    System.Writeln;
    System.Writeln;
    System.Writeln;
    System.Writeln('Error on Init');
    Exit;
  End;
  HeaderFile.ReadBuffer(Header,SizeOf(Header));
  If (Header.Signature[1] = 'J') And
      (Header.Signature[2] = 'A') And
      (Header.Signature[3] = 'M') And
      (Header.Signature[4] = #0) Then Begin
    MsgCount:=GetMsgCount;
    Result:=True;
  End;
End;

Destructor  TJamBase.Destroy;
Begin
  HeaderFile.Free;
  IndexFile.Free;
  TxtFile.Free;
  MsgText.Free;
  Inherited Destroy;
End;

Function TJamBase.GetMsgCount:LongInt;
Var
  i   : LongInt;
  idx : JamIdxType;
Begin
  IndexFile.Seek(0,0);
  i:=0;
  While IndexFile.Position < IndexFile.Size Do Begin
    IndexFile.Read(idx,Sizeof(idx));
    i:=i+1;
  End;
  Result:=i;
End;

Function TJamBase.LoadMsg(N:LongInt):Boolean;
Var
  i   : LongInt;
  idx : JamIdxType;
  SubLength : LongInt;
  SubEnd    : LongInt;
  SubF      : SubFieldType;
  Data      : String;
Begin
  Result:=False;
  If N>MsgCount Then Exit;
  IndexFile.Seek(0,0);
  i:=0;
  While (i<=N) Do Begin
  //While (IndexFile.Position < IndexFile.Size) And (i<=N) Do Begin
    IndexFile.Read(idx,Sizeof(idx));
    i:=i+1;
  End;
  
  If Idx.HdrLoc = -1 Then Exit;
  
  HeaderFile.Seek(Idx.HdrLoc,0);
  FillChar(MsgHeader,Sizeof(MsgHeader),#0);
  HeaderFile.Read(MsgHeader,SizeOf(MsgHeader));
  
  //SubFields
  SubLength := MsgHeader.SubFieldLen;
  If SubLength<>0 Then Begin
    SubEnd := HeaderFile.Position+SubLength;
    While HeaderFile.Position < SubEnd Do Begin
      //SetLength(Data,0);
      Data:='';
      HeaderFile.Read(SubF,SizeOf(SubFieldType));
      SetLength(Data,SubF.DataLen);
      HeaderFile.Read(Data[1],SubF.DataLen);
      //Writeln('LoID:'+Int2Str(SubF.LoID));
      //Writeln('Length:'+Int2Str(SubF.DataLen));
      Case SubF.LoID Of
        0:  Begin {Orig}
              FillChar(Orig, SizeOf(Orig), #0);
              Move(Data, Orig, SubF.DataLen);
            End;
        1:  Begin {Dest}
              FillChar(Dest, SizeOf(Dest), #0);
              Move(Data, Dest, SubF.DataLen);
            End;
        2:  Begin {From}
              //SetLength(From,SubF.DataLen);
              //Move(Data, From, SubF.DataLen);
              From:=Data;
            End;
        3:  Begin
              Receipient:=Data;
            End;
        6:  Begin
              Subject:=Data;
            End;
        9:  Begin
              If IsFAttach Then Begin
                Subject:=Data;
              End;
            End;
        11: Begin
              If IsFileReq Then Begin
                Subject:=Data;
              End;
            End;
        1000:
            Begin
              EmbinDat:=True;
            End;
        2000:
            Begin
              SubKludge:=Data;
            End;
        2001:
            Begin
              SeenBy:=Data;
            End;
        2002:
            Begin
              Path2d:=Data;
            End;
        2003:
            Begin
              SubFlags:=Data;
            End;
        2004:
          Begin
            ZUTCINFO:=Data;
          End;
      End;
    End;
  End;
  MsgNo := N;
  Result:=True;
End;

Function TJamBase.GetMsgText(N:LongInt):Boolean;
Var
  C   : Char;
  r,i : Integer;
  L   : String;
Begin
  Result:=False;
  If LoadMsg(N)= False Then Exit;
  
  TxtFile.Seek(MsgHeader.TextOfs,0);
  MsgText.Clear;
  c:=#0;
  While (TxtFile.Position < MsgHeader.TextOfs+MsgHeader.TextLen) Do Begin
    TxtFile.Read(C,1);
    If C<>#13 Then L:=L+C
        Else Begin
          MsgText.Add(L);
          L:='';
        End;
  End;
  MsgNo := N;
  Result:=True;
End;

Function TJamBase.FirstMsg:Boolean;
Begin
  Result:=False;
  If Not LoadMsg(0) Then Exit;
  MsgNo := 0;
  Result:=True;
End;

Function TJamBase.LastMsg:Boolean;
Begin
  Result:=False;
  If Not LoadMsg(Header.ActiveMsgs-1) Then Exit;
  MsgNo := Header.ActiveMsgs-1;
  Result:=True;
End;

Function TJamBase.NextMsg:Boolean;
Begin
  Result:=False;
  If MsgNo+1 <= Header.ActiveMsgs-1 Then MsgNo := MsgNo + 1;
  If Not LoadMsg(MsgNo) Then Exit;
  Result:=True;
End;

Function TJamBase.IsLocal        : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Local) <> 0;
End;

Function TJamBase.IsCrash        : Boolean;
Begin
  Result := (MsgHeader.Attr1 and Jam_Crash) <> 0;
End;

Function TJamBase.IsKillSent     : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_KillSent) <> 0;
End;

Function TJamBase.IsSent         : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Sent) <> 0;
End;

Function TJamBase.IsFAttach      : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_FAttch) <> 0;
End;

Function TJamBase.IsFileReq      : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_FReq) <> 0;
End;

Function TJamBase.IsRcvd         : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Rcvd) <> 0;
End;

Function TJamBase.IsPriv         : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Priv) <> 0;
End;

Function TJamBase.IsDeleted      : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Deleted) <> 0;
End;

Function TJamBase.IsEncrypted    : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Encrypt) <> 0;
End;

Function TJamBase.IsCompressed   : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Compress) <> 0;
End;

Function TJamBase.IsEscaped         : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Escaped) <> 0;
End;

Function TJamBase.IsLocked         : Boolean; 
Begin
  Result := (MsgHeader.Attr1 and Jam_Locked) <> 0;
End;


Begin
End.
