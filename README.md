# M:N in Contests
### Short summary of the demo case:    
- Up to now, we have seen 23 International Contests, #24 is just running  
- We have seen 183 prizes assigned + 23 new ones in the actual contest   
- The prizes are split into categories e**X**perts and **C**ommunity
- These prizes are actually distributed to 35 Winners that I grouped into 5 regions    
I think this is a nice subject to be investigated in IRIS.    
And the numbers are small enough to follow easily.  
<img width="45%" src="https://community.intersystems.com/sites/default/files/inline/images/mn2.jpg">   

### Implementation   
- **B** is the Winner Table: It holds the region and a numeric as ID.    
    Short name is left empty for privacy protection in this Demo
- **A** is the table of all contests with dates
- **X,C** are the arrays of prizes. They are projected as SQL tables.   When assigned they refer to 1 winner

### Technology     
- It is all organized in standard object Classes / Tables   
- The whole interface is written in Object Script as CHUI (no Py, Java, Angular, ...)    
  not to distract from content by fancy graphic
- You see maintenance for Contests, Prizes, WInners, Assignments   
- For Statistics display of the generated SQL Queries is an option.    
 
### Disclaimer    
In the demo, all Personal Names have been anonymized for personal data protection.  
Information on contest dates and prizes are from public available OEX pages.   
The grouping of winners in regions is my personal approximation.   
### Sneek Previews    
*Total Prizes by Region*          
<img width="35%" src="https://community.intersystems.com/sites/default/files/inline/images/images/image(3863).png">    
*Winner's Profile (Shortened)*    
<img width="70%" src="https://community.intersystems.com/sites/default/files/inline/images/images/image(3865).png">   

### Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

### Installation 
Clone/git pull the repo into any local directory
```
git https://github.com/isc-at/M-N-Contests.git
```
Run the IRIS container with your project: 
```
docker-compose up -d --build
```
## How to Test it
```
docker-compose exec iris iris session iris
```
[or use Online Demo](https://m-n-contest.demo.community.intersystems.com/terminal/) :

```
USER>do ##class(dc.rcc.Main).Menue()

Welcome to OEX Contest Statistics
Select Contests, Prizes, Winners, Assign, Statistics, eXit (C,P,W,A,S,X) :
```
**Contests, Prizes, Winners**  have the same maintenance functions and show the    
data status before and after processing.
```
Contest List, Edit, New, Delete, eXit (L,E,N,D,X) :
Prizes List, Edit, New, Delete, eXit (L,E,N,D,X) :
Winners List, Edit, New, Delete, eXit (L,E,N,D,X) :
```
**List, Edit, Delete** ask for additional IDs of the records processed.     
A typical EDIT sequence for the actual Contest:  
```
Select Contests, Prizes, Winners, Assign, Statistics, eXit (C,P,W,A,S,X) :c

Contest List, Edit, New, Delete, eXit (L,E,N,D,X) :e

Contest ID :24
ID      Start_Date      End_Date        Title
24      2022-05-09      2022-05-29      InterSystems Grand Prix 2022

1 Rows(s) Affected

Change Start_Date (ODBC Format)[2022-05-09] :

Change End_Date (ODBC Format)[2022-05-29] :

Change Title [InterSystems Grand Prix 2022] :

ID      Start_Date      End_Date        Title
24      2022-05-09      2022-05-29      InterSystems Grand Prix 2022

1 Rows(s) Affected
```
**Assign** also allows Remove or (implicitly) Overload assignment of a prize.
```
Select Contests, Prizes, Winners, Assign, Statistics, eXit (C,P,W,A,S,X) :A
Assign or Remove Winner (A,R) :a
Winner's region (as,br,eu,ru,us) :us
ID      Region  RegID   Short
us||1   us      1       ?
us||2   us      2       ?
us||3   us      3       ?
us||4   us      4       ?

4 Rows(s) Affected
Winner's RegID :4
Contest ID :5
ID      Cat     Rank    Value   WinrID  Short   Title
5       C       1       1000    br||1   ?      InterSystems IRIS for Health FHIR
5       C       2       500     br||2   ?     InterSystems IRIS for Health FHIR
5       X       1       1500    br||1   ?      InterSystems IRIS for Health FHIR
5       X       2       1500    br||2   ?     InterSystems IRIS for Health FHIR
5       X       3       500     br||5   ?      InterSystems IRIS for Health FHIR

5 Rows(s) Affected
Category (C,X) :c Rank :1
ID      Cat     Rank    Value   WinrID  Short   Title
5       C       1       1000    br||1   ?      InterSystems IRIS for Health FHIR

1 Rows(s) Affected
Assign Winner us||4 (Y,N) [N]:y
ID      Cat     Rank    Value   WinrID  Short   Title
5       C       1       1000    us||4   ?      InterSystems IRIS for Health FHIR

1 Rows(s) Affected
Contest ID :
```
**Statistics** is a collection of pre-composed queries.     
You can always select the Category displayed:  (C=Community, X=eXperts, * =All)    
In order to inspire you for your own queries, you can also display the SQL statement used.    
```
Select Contests, Prizes, Winners, Assign, Statistics, eXit (C,P,W,A,S,X) :s

Prepared Statistics
 1 - Total prizes by contest
 2 - Total prizes by region
 3 - Total prizes by winners
 4 - Winner's ranking in contest
 5 - Winner's Profile
 X - eXit
  Select statistic [X]:2
Category (C=Community,X=eXperts,*=All) :*

Cat     Prizes  Value   Region
  *      88     68170   br
  *      40     42425   ru
  *      27     19700   eu
  *      13     15825   as
  *       8     9000    us

5 Rows(s) Affected
     Show SQL Statement (YN) [N] :y

     SELECT LPAD(cat,3) Cat, LPAD(count(*),3) Prizes, Sum(val) Value, Region
      FROM ( SELECT '*' Cat,
     C_value val, C_winner->Region FROM dc_rcc.Contest_C
      UNION ALL SELECT '*' Cat,
     X_value val, X_Winner->Region FROM dc_rcc.Contest_X
      ) WHERE val>1 AND NOT Region IS NULL
      GROUP BY Region ORDER BY 3 DESC
```
**or**   
```
Prepared Statistics
 1 - Total prizes by contest
 2 - Total prizes by region
 3 - Total prizes by winners
 4 - Winner's ranking in contest
 5 - Winner's Profile
 X - eXit
  Select statistic [X]:5
Category (C=Community,X=eXperts,*=All) :c

Cat     Contest Best    Winner  Value   ConCnt  ContestList - - - - - - - - - - - - - -         RankList
  C       1     1       ru||1   4750      7     1,11,13,16,21,22,23                             1,3,3,1,3,1,1
  C       1     1       br||4   1770      5     1,2,15,18,19                                    2,2,1,3,1
  C       2     1       br||1   7250     11     2,5,6,7,9,10,12,13,14,17,18                     1,1,1,2,1,2,2,1,2,2,2
  C       3     1       br||5   1750      3     3,4,14                                          2,1,4
  C       3     1       eu||3   1000      1     3                                               1
  C       4     1       br||2   4500     10     4,5,9,10,12,13,14,18,21,23                      2,2,2,3,3,2,1,1,1,2
  C       4     1       br||3   2950      6     4,7,9,17,18,19                                  3,1,3,1,4,2
  C       6     2       ru||2   1075      3     6,19,22                                         2,3,2
  C       6     3       ru||8   250       1     6                                               3
  C       7     3       eu||1   750       3     7,12,17                                         3,4,3
  C      10     1       as||2   4000      2     10,11                                           1,1
  C      11     2       as||3   1500      1     11                                              2
  C      12     1       eu||2   750       1     12                                              1
  C      13     4       br||6   250       1     13                                              4
  C      14     3       ru||5   500       1     14                                              3
  C      16     2       as||5   500       1     16                                              2
  C      16     3       ru||3   250       1     16                                              3
  C      21     2       as||1   1000      2     21,23                                           2,3
  C      22     3       as||4   625       1     22                                              3

19 Rows(s) Affected
     Show SQL Statement (YN) [N] :    
```
### Version 0.0.2
Improve statistic #5    
<img width="80%" src="https://community.intersystems.com/sites/default/files/inline/images/images/image(3944).png"> 

[Article #1 on DC](https://community.intersystems.com/post/mn-contest-1)    
[Article #2 on DC](https://community.intersystems.com/post/mn-contest-2)

[Demo Video](https://youtu.be/Q0MKr75xAQI)

[Demo Server SMP](https://m-n-contest.demo.community.intersystems.com/csp/sys/UtilHome.csp)   
[Demo Server WebTerminal](https://m-n-contest.demo.community.intersystems.com/terminal/)    
        
**Code Quality**   
<img width="85%" src="https://community.intersystems.com/sites/default/files/inline/images/images/image(3871).png">   
