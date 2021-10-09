cls
@echo AutoDatix - Andrew J Clarkin
@echo.
@echo This will generate 4 reports for use in the monthly ICU M^&M summary
@echo Required files:
@echo  - mortality.csv - Datix report with all cases discussed this month
@echo  - action.csv - Datix report with all actions (not just this month)
@echo.
@echo Ensure month and date are set in DBcommands.sql in the select for report3
@echo.
@echo Outputs:
@echo  - report1.csv - summary of the month
@echo  - report2.csv - all open actions
@echo  - report3.csv - actions completed this month
@echo  - report4.csv - all discussions this month
@echo.
@echo Use reset.bat to delete old reports and temporary files before running
@echo.
@echo.
@echo Generating reports...
@echo.
@echo off

powershell -command "(gc -en utf8 mortality.csv) -replace'[^ -x7e]', ' ' | Out-File -en ascii mortality.csv"
powershell -command "(gc -en utf8 action.csv) -replace'[^ -x7e]', ' ' | Out-File -en ascii action.csv"

> newmortality.csv (
   echo id,chi,forename,surname,palliative,pf,pm,donation,nodonation,modedeath,cpr,issues,mmdate,timing,delay,readmission,incidents,discussion,lessons,action1,action2,status,closeddate
   more +1 mortality.csv
)

> newaction.csv (
   echo id,mmdate,chi,discussion,lessons,actionold1,actionold2,action,start,closed
   more +1 action.csv
)


sqlite3 db < DBcommands.sql
@echo These can be viewed in nodonation.csv
@echo.


echo "M&M Date", CHI, Discussion, Lessons, Action > temp.csv
type report2.csv >> temp.csv
del report2.csv
ren temp.csv report2.csv

echo "M&M Date", CHI, Discussion, Lessons, Action, Closed > temp.csv
type report3.csv >> temp.csv
del report3.csv
ren temp.csv report3.csv

echo "M&M Date", CHI, Discussion, Lessons > temp.csv
type report4.csv >> temp.csv
del report4.csv
ren temp.csv report4.csv

del newmortality.csv
del newaction.csv
del db
