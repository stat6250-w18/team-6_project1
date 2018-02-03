
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

footnote1
'Above we can see that our 2 of our top players, were part of the 3 finalists last season for the Hart Trophy (player deemed MVP of the season).'
;

footnote2
'We can also see that my results winner matches the actual Hart Trophy Winnner: Connor McDavid, thus showing my analysis has some merit.'
;

footnote3
'Looking through the team-by-team results, the listed top 3 matches my intuition.'
;

footnote4
'Further analysis would be useful in seeing different rankings among position or taking team strength as an adjustment factor.'
;

*
Methodology: Using a datastep to create Pp60_ (Points per minute of Ice Time)and Useful variables (PP60_ * Games Played).
Then proc means is used to create data set of top 3 players per team.

Limitations: The data does not take into account Points relative to Team.

Possible Follow-up Steps: Taking points relative to each team into account.

;


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

title;
footnote;

title1 
'Research Question: Does age affect team scoring?'
;

title2 
'Rationale: Determine if younger players are more valuable than proven veterans.'
;

footnote1
'Looking at the chart above I have each age listed, the number of players (with 20+ games), their avg Pp60_, and avg score.';
;

footnote2
'Looking at Pp60_ we do not see much of change at all as players get older usually hovering around .25'
;

footnote3
'However that variable does not take into account that only the best players of that age are still playing in the NHL, thus the average skill should not change due to those with lower scores retiring.'
;

footnote4
'Thus the score variable was created to take into account the players listed are the best of their age group'
;

footnote5
'This results matches my intuition of players gaining skill up till around age 25/26 where they peak, followed by a downward trend afterwards.'
;

*
Methodology: Create Pp60_ and score variables, assuming current _freq_ is 
top _freq_% of age. Using proc sort to sort by score.

Limitations: Only one season worth of data, using more would 
reduce single season effects.

Possible Follow-up Steps: Using multiple seasons worth of data to refine "score".

;

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

title;
footnote;

title1 
'Research Question: Who are the most aggressive players?'
;

title2 
'Rationale: Determine which players are most dangerous for teams both physically and offensively.'
;

footnote1
'Above a made a chart similar to question 1, ranking top offensive and physical players in the NHL';
;

footnote2
'I adjusted each used stat (Hits, Penalties Mins, and Pts) to be equally balanced, so the results produce players that are physical and have offensive talent (not just those skilled in one of the 3 areas).'
;

footnote3
'These players (typically called Power Forwards), match my intuition on a team-by-team level.'
;

*
Methodology: Creating Aggression variable weighting offense and physicality equally, 
while also valuing decreased variability.

Limitations: Teams and refs count hits and penalties differently 
based on arena or ref respectively.

Possible Follow-up Steps:  Accounting for arena scoring in hits, 
to readjust to a more accurate hit count.

;

proc print 
        data=top3list2 
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

title;
footnote;
