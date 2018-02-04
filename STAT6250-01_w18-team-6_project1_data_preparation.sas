*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 

This file prepares the dataset described below for analysis.

[Dataset Name] 2016-17 NHL Skater Statistics

[Experimental Units] NHL Players in the 16-17 NHL Season

[Number of Observations] 888

[Number of Features] 28

[Data Source] https://www.hockey-reference.com/leagues/NHL_2017_skaters.html
The dataset ws obtained from Hockey Reference, website that provides the 
completesource for current and historical NHL players, teams, scores and 
leaders.

[Data Dictionary] On the dataset link, there is a button labeled Glossary, 
that pops out a Glossary of all variables in the dataset.

Column header key:
Age   Age
Pos   Position
Tm    Team Name
GP    Games Played
G     Goals
A     Assists
PTS   Points
+/-   Plus/Minus
PIM   Penalties in Minutes
PS    Point Shares (an estimate of the number of points contributed by the 
      player)
EV    Even Strength Goals
PP    Power Play Goals
SH    Short-Handed Goals
GW    Game-Winning Goals
EV    Even Strength Assists
PP    Power Play Assists
SH    Short-Handed Assists
S     Shots on Goal
S%    Shooting Percentage
TOI   Time on Ice (in minutes)
ATOI  Average Time On Ice
BLK   Blocks at Even Strength
HIT   Hits at Even Strength
FOW   Faceoff Wins at Even Strength
FOL   Faceoff Losses at Even Strength
FO%   Faceoff Win Percentage at Even Strength


[Unique ID Schema] The column "Player" is a primary key.
;


* Environmental setup;

* setup environmental parameters;
%let inputDatasetURL =
https://github.com/stat6250/team-6_project1/blob/master/NHL 16-17 data set.xlsx?raw=true
;


* load raw FRPM dataset over the wire;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    NHL1617_raw,
    &inputDatasetURL.,
    xlsx
)


* Check raw dataset for duplicates with primary key;
proc sort
        nodupkey
        data=NHL1617_raw
        dupout=NHL1617_raw_dups
        out=_null_
     ;
     by
        Player
     ;
 run;
 
 
* build analytic dataset from FRPM dataset with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;
data NHL1617_analytic_file;
    set NHL1617_raw;
    retain
        Player 
        Age 
        Pos 
        Tm 
        GP 
        G 
        PTS 
        HIT 
        PIM 
        TOI 
        Pp60_
        Useful
        Hp60_
        Pen60_
        Aggression
    ;
    keep
        Player 
        Age 
        Pos 
        Tm 
        GP 
        G 
        PTS 
        HIT 
        PIM 
        TOI 
        Pp60_
        Useful
        Hp60_
        Pen60_
        Aggression
    ;
    Pp60_ = PTS/(TOI)
    ;
    Useful = Pp60_*GP
    ;
    Hp60_ = HIT/(3*TOI)
    ;
    Pen60_ = PIM/(1.5*TOI)
    ;
    Aggression = (((Pp60_ * ((Hp60_ + Pen60_)/2))*GP)**2)/std(Pp60_,Hp60_,Pen60_)
    ;
    format 
        Pp60_ Useful 6.4 
        tm $5. 
        GP G PTS HIT PIM TOI 4.
    ;
run;

/* Setup for JC Question 1*/
proc sort 
        data=NHL1617_Analytic_File 
        out=temp1
    ;
    by 
        tm descending Useful
    ;
run;

proc means 
        data=temp1 
        noprint
    ;
    class 
        tm
    ;
    var 
        useful
    ;
    output 
        out=top3list(rename=(_freq_=NumberPlayers))
          idgroup( max(useful) out[3] (player
          useful)=)/autolabel autoname
    ;
run;

/* Setup for JC Question 2*/
proc sort 
      data=NHL1617_Analytic_File
      out=temp2
    ;
    by 
      descending age
    ;
run;

proc means 
        data=temp2 
        mean 
        noprint
    ;
    where 
        GP > 20
    ;
    class 
        age
    ;
    var 
        Pp60_
    ;
    output 
        out=mean1
    ;
run;

data nmean;
    set 
        mean1
    ;
    where 
        _stat_ = "MEAN"
    ;
    score = ((_FREQ_)/(100-_FREQ_))*(Pp60_)  + (Pp60_)
    ;
run;

proc sort 
        data=nmean
    ;
    by 
        age
    ;
run;

/* Setup for JC Question 3 */
proc sort 
        data=NHL1617_Analytic_File 
        out=temp3
    ;
    by 
        tm descending Aggression
    ;
run;

proc means 
        data=temp3
        noprint
    ;
    class 
        tm
    ;
    var 
        Aggression
    ;
    output 
        out=top3list2(rename=(_freq_=NumberPlayers))
          idgroup( max(Aggression) out[3] (player
          aggression)=)/autolabel autoname
    ;
run;

/* Setup for TB Question 2*/
proc sort
       data = NHL1617_raw
       out = GTOI_Desc
   ;
   by
       descending G
   ;
run;

/* Setup for TB Question 3*/
proc sort
       data = NHL1617_raw
       out = ATOI_Desc
   ;
   by
       descending A
   ;
run;
