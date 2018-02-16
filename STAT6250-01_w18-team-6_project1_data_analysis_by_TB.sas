*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research 
questions regarding NHL16-17 player statistics.

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
'Research Question: Who are the top players leading in both assists and goals? 
And how do they compare among one another?
;

title2
'Rationale: The goal and assist rate will help us determine which player is 
effiecent in these statistical categories.'
;

footnote1
'The list of players with the most goals recorded coincidentally have a high 
number of assists recorded.'
;
*
Methodology: Calculate the goal to assist numbers among the top players. 
And sort data in descending order to show the top 20 players that lead in
assist and goals category.

Limitations: This only gives us the players output in terms of two variables.

Possible Follow-up Steps: We would need to calulate the number of shots taken 
and take the goal to shot ratio. For example, a player with 20 goals and 10 
assists will have a the same goal to assist ratio as a player with 40 
goals and 20 assists. 
;
proc print
	noobs
        data=NHL1617_raw (obs=20)
    ;
    var
    	Player
	A
	G
    ;
run;
title;
footnote;


    
title1 
'Research Question: How does the goal and minutes played between the top 
players compare?' 

title2
'Rationale: This helps us determine the players efficiency based off of 
their time on the ice and the amount of goals they score.'
;

footnote1
'The goal and minutes played will help us futher breakdown the player 
statistics for different comparisons.'
;
*
Methodology: We organize the data to see the top goal scorers and look 
at the minutes leaders in among that list.

Limitations: Having more time on the ice can have a positive impact on 
a team even if the player is not scoring.

Possible Follow-up Steps: In addition to this, we can look at their 
point share to see how much they contribute to their team.
;
proc print
	noobs
        data=NHL1617_raw(obs=20)
    ;
    var
    	Player
	G
	TOI
    ;
run;

proc sort
       data = NHL1617_raw
       out = GTOI_Desc
   ;
   by
       descending G
   ;
run;

proc print
        data = GTOI_Desc (obs=20) 
    ;
    var
   	Player
	G
	TOI
    ;
run;
title;
footnote;



title1
'Research Question: How do the assist rate to minutes played compare 
between the top players?' 
;

title2
'Rationale: This examines each players efficiency based on the number of 
assists per their play time.'
;

footnote1
'The assist and minutes played in addition to the goal and minutes played 
should give us a detailed analysis offensive efficency.'
;
*
Methodology: We organzie the data to see the top assist leaders and see which 
of those players also lead in minutes played.

Limitations: A player with small number of assists but longer play time can 
still have a positive effect on a teams other stats.

Possible Follow-up Steps: We can take the average play time for all the players 
and eliminate the players with play time less than the average to clean up the 
results more.
;
proc print
	noobs
        data=NHL1617_raw(obs=20)
    ;
    var
    	Player
	A
	TOI
    ;
run;

proc sort
       data = NHL1617_raw
       out = ATOI_Desc
   ;
   by
       descending A
   ;
run;

proc print
        data = ATOI_Desc (obs=20) 
    ;
    var
   	Player
	A
	TOI
    ;
run;
title;
footnote;


