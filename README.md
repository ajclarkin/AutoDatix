# AutoDatix
Create summary reports from a datix extract for use in local governance process

## Background ##
This is used for the morbidity and mortality reports recorded in the Datix system at work. There is a report set up within the system to output the records with the required fields as a csv. This then processes it to create the summary reports for dissemination.

## Process ##
- Convert UTF-8 into ascii
- Create a blank database in sqlite
- Import the data into the database
- Select the required data for the report into report files
- Add the header rows to the report files.

## Requirements ##
Needs SQLite in path or in working directory.
Must be able to run batch files.

## Status ##
This is not maintained and no longer used.
Feel free to reuse the code.
