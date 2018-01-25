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
The dataset ws obtained from Hockey Reference, website that provides the complete source for current and 
historical NHL players, teams, scores and leaders.

[Data Dictionary] On the dataset link, there is a button labeled Glossary, that pops out a Glossary of all variables in the dataset.

[Unique ID Schema] The column "Player" is a primary key.

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
PS    Point Shares (an estimate of the number of points contributed by the player)
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

;

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
    xls
)

* build analytic dataset from FRPM dataset with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;


data NHL1617_analytic_file;
    retain
        Player Age Pos Tm GP G PTS HIT PIM TOI Pp60_;
    ;
    keep
        Player Age Pos Tm GP G PTS HIT PIM TOI Pp60_;
    ;
    Pp60_ = PTS/(TOI);
    set NHL1617_raw;
run;


