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
	data=NHL1617_temp
    ;
    set 
    	goal_assist_raw
    ;
    gs_ratio = (G/A)
run;

proc sort 
	data=NHL1617_temp
    ;
    by  
    	ascending gs_ratio
    ;
run;
proc means 
	data=NHL1617_temp
    ;
    class 
	Player
    ;
    var  
    	goal_assist_raw
    ;
output 
	out=NHL1617_temp
    ;
run; 


    
title1 
'Research Question: What is the goal per minute ratio of each player on the list?'
;

title2
'Rationale: This helps us determine the players efficiency based off of their time on the ice.'
;

footnote1
'The goal per minute ratio should will help us futher breakdown the player statistics for comparison from the previous question.'
;
*
Methodology: We take the number of goals each player scored and divide it by 
the number of minutes they played.

Limitations: A player that has small number of goals and play time can have a 
high ratio which affects our results.

Possible Follow-up Steps: In addition to this, we can look at their point share 
to see how much they contribute to their team.
;
data=NHL1617_temp2
    ;
    set 
    	g_toi_raw
    ;
    g_toi_ratio = (G/TOI)
run;
    ; 
proc sort 
	data=NHL1617_temp2
    ;
    by  
    	ascending g_toi_ratio
    ;
run;
    ;
proc means 
	data=NHL1617_temp2
    ;
    class 
    	Player
    ;
    var  
    	goal_toi_raw
    ;
output 
	out=NHL1617_temp
    ;
run; 
    ;
proc print 
    noobs 
        data=NHL1617_temp2
    ;
     var
        Players
        G
        TOI
        goal_toi_raw
    ;
run;



title1
'Research Question: What is the ratio of assist per minute on the ice?'
;

title2
'Rationale: This examines each players efficiency based on the number of assists per their play time.'
;

footnote1
'The assist per minute ratio in addition to the goal per minute ratio should give us a detailed analysis offensive efficency.'
;
*
Methodology: We take the number of assists for each player and divide it by 
the number of minutes they played.

Limitations: A player with small number of assists and play time can have a 
high ratio which affects our results and conclusion.

Possible Follow-up Steps: We can take the average play time for all the players 
and eliminate the players with play time less than the average to clean up the 
results more.
;
data=NHL1617_temp3;
    set 
    	assist_toi_raw
    ;
    a_toi_ratio = (A/TOI)
    ;
run;
    ;
proc sort 
	data=NHL1617_temp3
    ;
    by  
    	ascending a_toi_ratio
    ;
run;
    ;
proc means 
	data=NHL1617_temp3
    ;
    class 
    	Player
    ;
    var  
    	assist_toi_raw
    ;
output 
	out=NHL1617_temp3
    ;
run; 
    ;
proc print 
    noobs 
        data=NHL1617_temp3
    ;
    var
        Players
        A
        TOI
        assist_toi_raw
    ;
run;


