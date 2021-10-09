-- Called by main.bat (which also does file handling, deletes temp files and so on)
-- Given correctly formatted csv dumps from Datix it creates summary tables for M&M report
-- ACTION REQUIRED: need to change month and year in select for filtering report 3 (search for X1)


.mode csv
-- These are the two data files from Datix
.import newmortality.csv mortality
.import newaction.csv actions

-- Report1 is the summary table
create table report1 (description varchar(50), counter text);

insert into report1 (description) values ("Deaths"), ("Admitted for palliative care"), ("Readmission with 48h");
update report1 set counter = (select count(*) from mortality) where description = "Deaths";
update report1 set counter = (select count(*) from mortality where palliative = "Y") where description = "Admitted for palliative care";
update report1 set counter = (select count(*) from mortality where readmission= "Y") where description = "Readmission with 48h";

insert into report1 (description) values (""), ("Procurator Fiscal Referrals");
insert into report1 select pf, count(*) from mortality group by pf;

insert into report1 (description) values (""), ("Post-Mortem Requests");
insert into report1 select pm, count(*) from mortality group by pm;

insert into report1 (description) values (""), ("Organ Donation");
insert into report1 select donation, count(*) from mortality group by donation order by donation desc;
insert into report1 (description) values ("Other - reasons");
insert into report1 (description) select nodonation from mortality where donation = "No - other (specify reason)";

insert into report1 (description) values (""), ("Mode of Death");
insert into report1 select modedeath, count(*) from mortality group by modedeath;

insert into report1 (description) values (""), ("CPR at Time of Death");
insert into report1 select cpr, count(*) from mortality group by cpr order by cpr;

.mode csv
.output report1.csv
select * from report1;

.output nodonation.csv
select id, nodonation from mortality where donation = "No - other (specify reason)";


-- Report 4 lists all discussions this month
create table report4 (mmdate varchar(12), chi varchar(10), discussion text, lessons text);
insert into report4 select mmdate, chi, discussion, lessons from mortality order by mmdate;

.output report4.csv
select * from report4;

-- Now create the action reports
delete from actions where action = "";
-- Date exported from Datix is dd/mm/yyyy - need to convert to yyyy-mm-dd in order to use date functions for select and order
create table report2 (mmdate varchar(12), chi varchar(10), discussion text, lessons text, action text, closed varchar(12), mmDT varchar(12), closedDT varchar(12));
insert into report2 select mmdate, chi, discussion, lessons, action, closed, substr(mmdate,7)||'-'||substr(mmdate,4,2)||'-'||substr(mmdate,1,2),
   substr(closed,7)||'-'||substr(closed,4,2)||'-'||substr(closed,1,2) from actions;

.output report2.csv
select mmdate, chi, discussion, lessons, action from report2 where closed = "" order by mmDT;

-- Make date changes in this select. X1
.output report3.csv
select mmdate, chi, discussion, lessons, action, closed from report2 where strftime('%m', closedDT) = '09' and strftime('%Y', closedDT) = '2016' order by mmDT;


-- Alert user to unclassified donations; the csv can be used to search datix and update records if required
.output stdout
.separator " "
.mode list
select "No of organ donations with other reasons:", count(*) from mortality where donation = "No - other (specify reason)";
.quit
