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
'Research Question: What is the assist to goal ratio of each player on the list?'
;

title2
'Rationale: The goal to assist ratio will help us determine which player is effiecent in these statistical categories.'
;

footnote1
'The list of players with the most goals recorded coincidentally have a high number of assists recorded.'
;
*
Methodology: Calculate the goal to assist ratio by dividing the number of 
goals by assists per player. And sort data in descending order to organize 
the results from high to low assit to goal ratio. This ratio will help us 
distinguish how effective each player is on offense. 

Limitations: This ratio can be skewed because some players might have more 
goals than assists and vice versa .

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
'Research Question: How does the goal and minutes played between the top players compare? 

title2
'Rationale: This helps us determine the players efficiency based off of their time on the ice.
and the amount of goals they score'
;

footnote1
'The goal per minute ratio should will help us futher breakdown the player statistics for comparison from the previous question.'
;
*
Methodology: We organize the data to see the top goal scorers and look at the 
minutes leaders in among that list.

Limitations: A player that has small number of goals and play time can have a 
high ratio which affects our results.

Possible Follow-up Steps: In addition to this, we can look at their point share 
to see how much they contribute to their team.
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
        data = GTOI_Desc 
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
'Research Question: How do the assist rate to minutes played compare between the top players? 
;

title2
'Rationale: This examines each players efficiency based on the number of assists per their play time.'
;

footnote1
'The assist per minute ratio in addition to the goal per minute ratio should give us a detailed analysis offensive efficency.'
;
*
Methodology: We organzie the data to see the top assist leaders and see which 
of those players also lead in minutes played.

Limitations: A player with small number of assists and play time can have a 
high ratio which affects our results and conclusion.

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
        data = ATOI_Desc 
    ;
    var
   	Player
	A
	TOI
    ;
run;
title;
footnote;


