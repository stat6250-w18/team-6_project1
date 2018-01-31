
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to 
Dataset Name: NHL 16-17 data set.xlsx created in external file
STAT6250-01_w18-team-6_project1_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset NHL 16-17 data set.xlsx;
%include '.\STAT6250-01_w18-team-6_project1_data_preparation.sas';


title1 
'Research Question: Who are the most useful players in the league in terms of scoring?'
;

title2 
'Rationale: Determining which players are critical to team success.'
;


*
Methodology: Using a datastep to create Pp60_ and Useful variables.
Then proc means is used to create data set of top 3 players per team.

Limitations: The data does not take into account Points relative to Team.

Possible Follow-up Steps: Taking points relative to each team into account.

;


proc import 
          datafile='C:\Users\JohnJr\Documents\hold.xlsx' 
          dbms=xlsx 
          out=data1
    ; 
run;


data quest1;
    set 
       data1
    ;
    Pp60_ = PTS/(TOI)
    ;
    Useful = Pp60_*GP
    ;
    format 
        Pp60_ Useful 6.4 
        tm $5. 
        GP G PTS TOI 4.
    ;
    keep 
        player pos tm GP G PTS TOI Pp60_ Useful
   ;
run;
title;
footnote;

proc sort 
        data=quest1 
        out=temp2
    ;
    by 
        tm descending Useful
    ;
run;


proc means 
        data=quest1 
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


proc print 
        data=top3list 
        noobs 
        label
    ;
    var 
        tm player_1 useful_1 player_2 useful_2 player_3 useful_3
    ;
    label 
        player_1 = "#1 Player" 
        player_2 = "#2 Player" 
        player_3 = "#3 Player"
    ;
    label 
        useful_1 = "Useful" 
        useful_2 = "Useful" 
        useful_3 = "Useful"
    ;
run;



title1 
'Research Question: Does age affect team scoring?'
;

title2 
'Rationale: Determine if younger players are more valuable than proven veterans.'
;


*
Methodology: Create Pp60_ and score variables, assuming current _freq_ is 
top _freq_% of age. Using proc sort to sort by score.

Limitations: Only one season worth of data, using more would 
reduce single season effects.

Possible Follow-up Steps: Using multiple seasons worth of data to refine "score".

;

data quest2;
    set 
        data1
    ;
    Pp60_ = PTS/(TOI)
    ;
    format 
        Pp60_ 6.4 
        tm $5. 
        GP G PTS TOI age 4.
    ;
    keep 
        age player pos tm GP G PTS TOI Pp60_
    ;
run;
title;
footnote;

proc sort 
      data=quest2 
      out=temp1
    ;
    by 
      descending age
    ;
run;

proc means 
        data=quest2 
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

proc print 
        data=nmean 
        noobs
    ;
    where 
        age>16
    ;
    var 
        age _FREQ_ pp60_ score
    ;
    format 
        pp60_ score 5.3
    ;
run;


title1 
'Research Question: Who are the most aggressive players?'
;

title2 
'Rationale: Determine which players are most dangerous for teams both physically and offensively.'
;


*
Methodology: Creating Aggression variable weighting offense and physicality equally, 
while also valuing decreased variability.

Limitations: Teams and refs count hits and penalties differently 
based on arena or ref respectively.

Possible Follow-up Steps:  Accounting for arena scoring in hits, 
to readjust to a more accurate hit count.

;

data quest3;
    set 
         data1
    ;
    Pp60_ = PTS/(TOI)
    ;
    Hp60_ = HIT/(3*TOI)
    ;
    Pen60_ = PIM/(1.5*TOI)
    ;
    Aggression = (((Pp60_ * ((Hp60_ + Pen60_)/2))*GP)**2)/std(Pp60_,Hp60_,Pen60_)
    ;
    format 
        tm $5. 
        GP G PTS HIT PIM TOI 4.
    ;
    keep 
        player pos tm GP G PTS TOI Pp60_ HIT PIM Hp60_ Pen60_ Aggression
   ;
run;
title;
footnote;

proc sort 
        data=quest3 
        out=temp1
    ;
    by 
        tm descending Aggression
    ;
run;

proc means 
        data=quest3 
        noprint
    ;
    class 
        tm
    ;
    var 
        Aggression
    ;
    output 
        out=top3list(rename=(_freq_=NumberPlayers))
          idgroup( max(Aggression) out[3] (player
          aggression)=)/autolabel autoname
    ;
run;

proc print 
        data=top3list 
        noobs 
        label
    ;
    var 
        tm player_1 aggression_1 player_2 aggression_2 player_3 aggression_3
    ; 
    format aggression_1 
           aggression_2 
           aggression_3 6.3
    ;
    label player_1 = "#1 Player" 
          player_2 = "#2 Player" 
          player_3 = "#3 Player"
    ;
    label aggression_1 = "aggression" 
          aggression_2 = "aggression" 
          aggression_3 = "aggression"
    ;
run;
