Class dc.rcc.Main [ Not ProcedureBlock ]
{

ClassMethod Menue()
{
  Write #!!,"Welcome to OEX Contest Statistics",!
m Read !,"Select Contests, Prizes, Winners, Assign, Statistics, eXit (C,P,W,A,S,X) :",m#1,!
  set m=$ZCVT(m,"U")
  Do $case(m  ,"C":..Con()
              ,"P":..Prz()
              ,"W":..Win()
              ,"A":..Ass()
              ,"S":..Sta()
              ,:q)
 If "X"'=$ZCVT(m,"U") Goto m       
q Quit
}

ClassMethod SQL(sql)
{
  Set st=##class(%SQL.Statement).%New()
  Set st.%SelectMode=1  ;ODBC
  Set sc=st.%Prepare(.sql)
  If 'sc Write ! for i=1:1:sql Write sql(i),! If i=sql b
  Set sr=st.%Execute()
  Do sr.%Display()
  If m="S" {
	Read !?5,"Show SQL Statement (YN) [N] :",yn#1,!
	If $l(yn),"yY"[yn Write ! For i=1:1:sql Write ?5,sql(i),!
  	}
  Write !	
  Quit
}

ClassMethod Con()
{
c Read !,"Contest List, Edit, New, Delete, eXit (L,E,N,D,X) :",c#1,!
  Do $case($ZCVT(c,"U")
              ,"L":cl(0)
              ,"E":ce
              ,"N":cn
              ,"D":cd
              ,:cq)
 If "lendLEND"[c Goto c       
cq Quit
cl(cid) 
  Set sql="SELECT * FROM dc_rcc.Contest"
  If cid Set sql=sql_" WHERE ID="_+cid
  Do ..SQL(sql)
  Quit
cd
  Read !,"Contest ID :",cid,!
  If '+cid Quit
  If '##class(dc.rcc.Contest).%ExistsId(+cid) Goto cd
  Do cl(+cid)
  Read !,"Confirm Delete (Y,N) [N] :",cd#1,!
  If $l(cd),"yY"[cd do ##class(dc.rcc.Contest).%DeleteId(+cid)
  Goto cd
ce
  Read !,"Contest ID :",cid,!
  If '+cid Quit
  If '##class(dc.rcc.Contest).%ExistsId(+cid) Goto ce
  Do cl(+cid)
  Set con=##class(dc.rcc.Contest).%OpenId(+cid)
  Do ce1("Change")
  Goto ce
ce1(what)  
  Set txt=what_" Start_Date (ODBC Format)["_$zd(con.Start,3)_"] :"
  Write !,txt Read chg,!
  If $L(chg) {
    Set new=$zdh(chg,3,,,,,,,0) 
    If 'new Goto ce1
    set con.Start=new 
    }
ce2   
  Set txt=what_" End_Date (ODBC Format)["_$zd(con.End,3)_"] :"
  Write !,txt Read chg,!
  If $L(chg) {
    Set new=$zdh(chg,3,,,,,,,0) 
    If 'new Goto ce2
    set con.End=new 
    }
ce3
  Set txt=what_" Title ["_con.Title_"] :"
  Write !,txt Read !,chg,!
  If $L(chg) set con.Title=chg    
  Do con.%Save()
  Do cl(con.%Id())
  Quit
cn
  set con=##class(dc.rcc.Contest).%New()
  do ce1("New")
  Quit
}

ClassMethod Ass()
{
  Kill (m)
  Set rl=""
  &SQL(select List(distinct Region) into :rl from dc_rcc.Winner)

a0 Read "Assign or Remove Winner (A,R) :",act#1,!
  If '$l(act) Quit
  Set act=$ZCVT(act,"L")  
  IF "ar"[act Goto @act
  Goto a0
a
  Write "Winner's region ("_rl_") :" Read reg,!
  Do ..WList(reg)
  Read !,"Winner's RegID :", wid,!
  If $l(reg)*$l(wid)=0 Quit
  Set win=##class(dc.rcc.Winner).%OpenId(reg_"||"_+wid)
  If 'win Goto a
r 
  Read "Contest ID :",cid,!
  If '$l(cid) Goto a0
  Do ..PList(cid,0,0)
  If 'cid Goto r
  Read !,"Category (C,X) :",cat," Rank :",rnk,!
  If $l(cid)*$l(cat)*$l(rnk)=0 Quit
  Set cat=$ZCVT(cat,"U")
  Set obj=##class(dc.rcc.Contest).%OpenId(cid)
  If 'obj Goto r
  do ..PList(cid,cat,rnk)
  Try {
    Set array=$Property(obj,cat) 
    }
  Catch e { Set array="" }
  If 'array Goto r
  Set rank=array.GetAt(rnk) 
  If 'rank Goto r
  if act="r" {
r1  Write "Remove Winner "_rank.Winner.%Id() 
    Read " (Y,N) [N]:",yn#1,!
    If "nN"[yn Goto r
    If "yY"[yn set rank.Winner=""
    Else  Goto r1  
    }
  If act="a" {
a1  Write "Assign Winner "_win.%Id()
    Read " (Y,N) [N]:",yn#1,!
    If "nN"[yn Goto r
    If "yY"[yn set rank.Winner=win
     Else  Goto a1  
     }
  Do obj.%Save()
  Do ..PList(cid,cat,rnk)
  Goto r
}

ClassMethod Prz()
{
p Read !,"Prizes List, Edit, New, Delete, eXit (L,E,N,D,X) :",c#1,!
  Do $case($ZCVT(c,"U")
              ,"L":..PList(0,"",0)
              ,"E":pe
              ,"N":pn
              ,"D":pd
              ,:pq)
 If "lendLEND"[c Goto p
 Quit
pe
  If '$$pend() Quit   
  Write "Change Prize of "_rank.Value_" to New Prize value [0] :" Read val,!
  If '$l(val) Quit
  Set rank.Value=+val
  Do psv  
  Quit
pn
  If $$pend() Quit
  If '(obj*array) Quit
  Read "New Prize value [0]:",val,!
  Set rank=##class(dc.rcc.Prize).%New()
  Set rank.Value=+val
psv
  Do array.SetAt(rank,rnk)
  Do obj.%Save()
  Do ..PList(cid,cat,rnk)
  Quit
pd
  If '$$pend() Quit
  Read !,"Confirm Delete (Y,N) [N] :",pd#1,!
  If $l(pd),"yY"[pd {
    Do array.RemoveAt(rnk)
    do obj.%Save()
    }
 Do ..PList(cid,cat,rnk)
 Quit
pend()
  set (cid,cat,rnk,obj,array,rank)=""
  Read "Contest ID :",cid,!
  If cid="" Quit 0
  Read "Prize Category (C=Community,X=eXperts) :",cat#1,!
  If cat="" Quit 0
  Set cat=$ZCVT(cat,"U")
  Read "Prize Ranking (1=First, ...) :",rnk,!
  If rnk="" Quit 0
  Do ..PList(cid,cat,rnk)
  Set obj=##class(dc.rcc.Contest).%OpenId(cid)
  If 'obj Write " Contest not found",! Quit 0
  Try {
    Set array=$Property(obj,cat) 
    }
   Catch e {
     Write " Category not found",!
      Set array="" 
      }
  If 'array Quit 0    
  Set rank=array.GetAt(rnk) 
  If 'rank Write " Rank not found",! Quit 0
  Quit 1
  
pq Quit
}

ClassMethod PList(
	cid,
	cat,
	rnk)
{
  If cid<1 Read "Contest ID (0=All) :",cid,!
  If cid="" Quit
  If '$l(cat) Read "Prize Category (C=Community,X=eXperts,0=All) :",cat#1,!
  If cat="" Quit
  Set cat=$ZCVT(cat,"U")
  If '$l(rnk) Read "Prize Ranking (0=All, 1=First, ...) :",rnk,!
  If rnk="" Quit
  Set sql="SELECT * FROM ("_
    "SELECT c.ID, 'C' Cat, element_key Rank, C_Value Value , "_
    " C_Winner WinrID, C_Winner->Short, Title "_
    " FROM dc_rcc.Contest c LEFT OUTER JOIN dc_rcc.Contest_C p ON p.Contest= c.ID "_
    " UNION ALL "_
    "SELECT c.ID, 'X' , element_key, X_Value, "_
    " X_Winner WinrID, X_Winner->Short, Title "_
    " FROM dc_rcc.Contest c LEFT OUTER JOIN dc_rcc.Contest_X p ON p.Contest= c.ID "_
    " ) WHERE 1=1 "
  If cid Set sql=sql_" AND id = "_cid 
  If cat'="0" Set sql=sql_" AND cat = '"_cat_"' "
  If rnk Set sql=sql_" AND rank = "_rnk_" "
  Set sql= sql_" ORDER BY 1,2,3 "
  Do ..SQL(sql)
  Quit
}

ClassMethod WList(wid = 0)
{
  Set sql="SELECT TOP ALL * FROM dc_rcc.Winner WHERE 1=1"
  If wid Set sql=sql_" AND RegId = "_wid
  If $e(reg)'="*" Set sql=sql_" AND Region = '"_reg_"'"
  Set sql=sql_" ORDER BY Region desc, RegId "
  Do ..SQL(sql)
  Quit
}

ClassMethod Win(reg = "")
{
  Set rl=""
  &SQL(select List(distinct Region) into :rl from dc_rcc.Winner)
  Set rlist=$lfs(rl)_$lb("*","**")
rg If '$lf(rlist,reg) {
    write !,"Winner's Region ("_rl_",*) [*] :" Read reg#2,!
    If reg="" set reg="*" 
    Goto rg 
    }      
w Read !,"Winners List, Edit, New, Delete, eXit (L,E,N,D,X) :",w#1,! 
  Do $case($ZCVT(w,"U")
              ,"L":..WList(0)
              ,"E":we
              ,"N":wn
              ,"D":wd
              ,:wq)
 If "lendLEND"[w Goto w       
wq Quit
wd
  If '$lf($lfs(rl),reg) w !,"No distinct Region ",! Quit
  Read !,"Winner's RegID :",wid,!
  If '+wid Quit
  If '##class(dc.rcc.Winner).%ExistsId(reg_"||"_+wid) Goto wd
  Do ..WList(wid)
  Read !,"Confirm Delete (Y,N) [N] :",cd#1,!
  If $l(cd),"yY"[cd do ##class(dc.rcc.Winner).%DeleteId(reg_"||"_+wid)
  Goto wd
we
  If '$lf($lfs(rl),reg) w !,"No distinct Region ",! Quit
  Read !,"Winner's RegID :",wid,!
  If '+wid Quit
  If '##class(dc.rcc.Winner).%ExistsId(reg_"||"_+wid) Goto we
  Do ..WList(wid)
  Set win=##class(dc.rcc.Winner).%OpenId(reg_"||"_+wid)
  Do we1("Change")
we1(what) 
  Set txt=what_" ShortName ["_win.Short_"] :"
  Write !,txt Read chg,!
  If $L(chg) set win.Short=chg    
  Do win.%Save()
  Do ..WList(win.Rid)
  Quit
wn
 Set wid=##class(dc.rcc.Winner).NextRid(reg)
 Set win=##class(dc.rcc.Winner).%New()
 Set win.Rid=wid
 Set win.Reg=reg
 Do we1("New")
 Quit
}

ClassMethod Sta()
{
s Write !,"Prepared Statistics",!,
        " 1 - Total prizes by contest",!,
        " 2 - Total prizes by region",!,
        " 3 - Total prizes by winners",!,
        " 4 - Winner's ranking in contest",!,
        " 5 - Winner's Profile",!,
        " X - eXit",!,
        "  Select statistic [X]:"
  Read sta#1,!         
  If ("xX"[sta) Quit
  If (sta<1)!(sta>5) Goto s
s1 
  Read "Category (C=Community,X=eXperts,*=All) :",cat#1,!!
  If cat="" Goto s
  Set cat=$ZCVT(cat,"U")
  If "CX*"'[cat Goto s1 
  Kill sql
  Do @sta
  Do ..SQL(.sql)
  Goto s
1
  Set sql=0
     ,sql($i(sql))="SELECT LPAD(cat,3) Cat, Contest Nbr, LPAD(count(*),3) Prizes, "
     ,sql($i(sql))="LPAD(Sum(val),5) Value, Title "
     ,sql($i(sql))=" FROM ( SELECT '"_cat_"' Cat, contest, contest->Title, " 
   If "C*"[cat {
    Set sql($i(sql))="C_value val FROM dc_rcc.Contest_C " 
    }
  If cat="*" {
    Set sql($i(sql))=" UNION ALL  " 
     ,sql($i(sql))=" SELECT '"_cat_"' Cat, contest, contest->Title, "
    }
  If "X*"[cat {
    Set sql($i(sql))="X_value val FROM dc_rcc.Contest_X "
    }  
  Set sql($i(sql))=" ) GROUP BY contest ORDER BY 2 "
  Quit

  set sql="SELECT '  ' "" --- "" ,contest ""##"" , count(*) Prizes, sum(value) value, cat, title "_
    " FROM (SELECT "_
    " contest, C_Value value, contest->title, '"_$s(cat="*":"*",1:"C")_
    "' Cat FROM dc_rcc.Contest_C "_"UNION ALL SELECT "_
    " contest, X_Value value, contest->title, '"_$s(cat="*":"*",1:"X")_
    "' Cat FROM dc_rcc.Contest_X  ) WHERE Cat='"_cat_
    "' GROUP BY contest ORDER BY 2 "
  Quit
2
  Set sql=0
     ,sql($i(sql))="SELECT LPAD(cat,3) Cat, LPAD(count(*),3) Prizes, Sum(val) Value, Region "
     ,sql($i(sql))=" FROM ( SELECT '"_cat_"' Cat, " 
   If "C*"[cat {
    Set sql($i(sql))="C_value val, C_winner->Region FROM dc_rcc.Contest_C " 
    }
  If cat="*" {
    Set sql($i(sql))=" UNION ALL SELECT '"_cat_"' Cat, "
    }
  If "X*"[cat {
    Set sql($i(sql))="X_value val, X_Winner->Region FROM dc_rcc.Contest_X "
    }  
  Set sql($i(sql))=" ) WHERE val>1 AND NOT Region IS NULL "
     ,sql($i(sql))=" GROUP BY Region ORDER BY 3 DESC "
  Quit
3
  Set sql=0
     ,sql($i(sql))="SELECT LPAD(cat,3) Cat, LPAD(count(*),3) Prizes, Sum(val) Value, Winner "
     ,sql($i(sql))=" FROM ( SELECT '"_cat_"' Cat, " 
  If "C*"[cat {
    Set sql($i(sql))="C_Winner Winner, C_value val FROM dc_rcc.Contest_C " 
    }
  If cat="*" {
    Set sql($i(sql))=" UNION ALL SELECT '"_cat_"' Cat, "
    }
  If "X*"[cat {
    Set sql($i(sql))="X_Winner Winner, X_value val FROM dc_rcc.Contest_X "
    }  
  Set sql($i(sql))=" ) WHERE val>1 AND NOT Winner IS NULL"
     ,sql($i(sql))=" GROUP BY Winner ORDER BY 3 DESC "
  Quit
4
  Set sql=0
     ,sql($i(sql))="SELECT LPAD(cat,3) Cat, Sum(val) Value, Winner, "
     ,sql($i(sql))="LPAD(count(*),3) cnt, List(rank) Ranks FROM ("
     ,sql($i(sql))="SELECT '"_cat_"' Cat,  "
  If "C*"[cat {
    Set sql($i(sql))="C_Winner Winner, C_value val, element_key rank  "
       ,sql($i(sql))=" FROM dc_rcc.Contest_C " 
    }
  If cat="*" {
    Set sql($i(sql))=" UNION ALL "
       ,sql($i(sql))="SELECT '"_cat_"' Cat, "
    }
  If "X*"[cat {
    Set sql($i(sql))="X_Winner Winner, X_value val, element_key rank  "
       ,sql($i(sql))=" FROM dc_rcc.Contest_X "
    } 
  Set sql($i(sql))=")  WHERE val>1 AND NOT Winner IS NULL "
     ,sql($i(sql))=" GROUP BY cat, Winner ORDER BY 2 DESC"  
  Quit
5
  Set sql=0
     ,sql($i(sql))="SELECT LPAD(Cat,3) Cat ,"
     ,sql($i(sql))="LPAD(Contest,3) Contest, Best, Winner, Value, LPAD(CCnt,3) ConCnt,"
     ,sql($i(sql))="RPAD(CL,40) ""ContestList - - - - - - - - - - - - - - "", RankList "
     ,sql($i(sql))=" FROM ( SELECT "
     ,sql($i(sql))="MIN(Contest) Contest, "
     ,s1=sql
     ,sql($i(sql))="MIN(element_key) Best, "
     ,sql($i(sql))="COUNT(*) CCnt, "
     ,sql($i(sql))="LIST(Contest) CL, "
     ,sql($i(sql))="LIST(element_key) RankList, "
     ,s2=sql
  If "C*"[cat {
    Set sql($i(sql))="C_Winner Winner, 'C' Cat, " 
       ,sql($i(sql))="SUM(C_Value) Value "
       ,sql($i(sql))="FROM dc_rcc.Contest_C WHERE C_Value>1 GROUP BY C_Winner "
    } 
  If cat="*" {
    Set sql($i(sql))="UNION ALL SELECT "
    For i=s1:1:s2 Set sql($i(sql))=sql(i)
    }
  If "X*"[cat {        
      Set sql($i(sql))="X_Winner Winner, 'X' Cat, "
       ,sql($i(sql))="SUM(X_Value) Value "
       ,sql($i(sql))="FROM dc_rcc.Contest_X WHERE X_Value>1 GROUP BY X_Winner "
    } 
  Set sql($i(sql))=") WHERE NOT Winner IS NULL "
     ,sql($i(sql))="ORDER BY 2, 1 DESC, 3 , 5 DESC"
       
  Quit
}

}
