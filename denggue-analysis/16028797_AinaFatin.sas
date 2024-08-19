*The Excel file is renamed to denggue.xlsx;

*Reading from Excel spreadsheet;
filename fileimp '/home/n160287970/Analytics Engineering/denggue.xlsx';
proc import datafile = fileimp
	dbms = xlsx
	out = work.denggue1 replace;
	*Adding a replace option to overwrite if data set already exists;
	range = 'HOT SPOTS$B2:H9859';
	getnames = yes;
run;

*Viewing summary information of contents of the data set;
proc contents data=work.denggue1;
run;

*Cleaning and Validating Data;

*Changing data type from character data type to numeric data type;
data work.denggue;
	set work.denggue1;
	JumlahKesTerkumpul = input('Jumlah Kes Terkumpul'n, 8.);
	drop 'Jumlah Kes Terkumpul'n;
	*To retain 'Jumlah Kes Terkumpul'n as the variable name;
	rename JumlahKesTerkumpul = 'Jumlah Kes Terkumpul'n;
run;

*Viewing updated summary information of contents of the data set;
proc contents data=work.denggue;
run;

*Listing frequency of Tahun, Minggu, Negeri and Daerah/Zon/PBT
 -to check if any negative, invalid or missing variables
 -to check for missing values and if exist, repeating variables
 -to check if all cumulative 9857 observations is listed;
proc freq data=work.denggue;
	tables Tahun Minggu Negeri 'Daerah/Zon/PBT'n / missing nopercent;
run;

*Upcase Negeri, Daerah/Zon/PBT and Lokaliti to standardize the case type;

*From frequency, discovered: 
 1) Same variables that are not grouped together:
 Negeri: -P. Pinang and P.Pinang
 		 -Selangor and selangor
 Daerah/Zon/PBT: -Hulu Selangor and Hulu Selangor
 				 -Zon Setapak and Setapak
 				 -Seberg Perai Selatan and Seberang Perai Selatan
 				 -Kota and Kota Kinabalu
 2) Misclassification:
 Daerah/Zon/PBT: -Perak (Changed to Ipoh: identified by Lokaliti through proc step)
 				 -Selangor (Changed to Semenyih, Bandar Baru Bangi, Sungai Buloh, Petaling: identified by Lokaliti through proc step);
 
data work.denggue;
	set work.denggue;
	Negeri = upcase(Negeri);
	'Daerah/Zon/PBT'n = upcase('Daerah/Zon/PBT'n);
	Lokaliti = upcase(Lokaliti);
	if Negeri = 'P.PINANG' then Negeri = 'P. PINANG';
	if find('Daerah/Zon/PBT'n, 'HULU SELANGOR') then 'Daerah/Zon/PBT'n = 'HULU SELANGOR';
	if 'Daerah/Zon/PBT'n = 'ZON SETAPAK' then 'Daerah/Zon/PBT'n = 'SETAPAK';
	if 'Daerah/Zon/PBT'n = 'SEBERG PERAI SELATAN' then 'Daerah/Zon/PBT'n = 'SEBERANG PERAI SELATAN';
	if 'Daerah/Zon/PBT'n = 'KOTA' then 'Daerah/Zon/PBT'n = 'KOTA KINABALU';
	if 'Daerah/Zon/PBT'n = 'PERAK' then 'Daerah/Zon/PBT'n = 'IPOH';
	if Lokaliti = 'APPT TAMAN ANGGERIK VILLA 2' then 'Daerah/Zon/PBT'n = 'SEMENYIH';
	if Lokaliti = 'JALAN 5/1-10 TAMAN WEST COUNTRY' then 'Daerah/Zon/PBT'n = 'BANDAR BARU BANGI';
	if Lokaliti = 'SERI PRISTANA (FASA 1)' then 'Daerah/Zon/PBT'n = 'SUNGAI BULOH';
	if Lokaliti = 'SRI KEMBANGAN 7' then 'Daerah/Zon/PBT'n = 'PETALING';
run;

proc print data=work.denggue;
	where 'Daerah/Zon/PBT'n = 'SELANGOR';
run;

proc print data=work.denggue;
	where 'Daerah/Zon/PBT'n = 'PERAK';
run;

*To observe changes from previous step;
proc freq data=work.denggue;
	tables Tahun Minggu Negeri 'Daerah/Zon/PBT'n / missing nopercent;
run;

*Listing number of variables, missing variables, mean, minimum and maximum;
proc means data=work.denggue n nmiss mean min max maxdec=2;
run;

*Two missing values for Jumlah Kes Terkumpul;

*Checking if any duplication exists;
*In a week of a year, there should only be one report per Lokaliti;
proc sql;
	select *, count(*) as count
	from work.denggue
	group by Tahun, Minggu, Negeri, 'Daerah/Zon/PBT'n, Lokaliti
	having count(*) > 1;
quit;
	
*Five observations are duplicated;

*Removing the missing values by sorting in a new data set;
proc sort data=work.denggue out=work.dengguesorted nodupkey;
	where 'Jumlah Kes Terkumpul'n is not missing;
	by Tahun Minggu Negeri 'Daerah/Zon/PBT'n Lokaliti;
run;

*Viewing summary information of contents of the new sorted data set;
proc contents data=work.dengguesorted;
run;

*Number of observations has changed from 9857 to 9850;

*Preliminary Analysis;

*Graph 1;
title 'The Number of Cases in Each State';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Negeri / response='Jumlah Kes Terkumpul'n stat=sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - Selangor has the highest number of cases while Perlis has the lowest number of cases;

*Graph 2;
title 'The Average Number of Cases in Each State';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Negeri / response='Jumlah Kes Terkumpul'n stat=mean name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - Kelantan has the highest average number of cases while Perlis has the lowest average number of cases;

*Graph 3;
title 'The Number of Cases in Each Year';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Tahun / response='Jumlah Kes Terkumpul'n stat=Sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - 2014 is the year with the most number of cases, 2012 is the year with the least number of cases;

*Graph 4;
title 'The Number of Cases against The Period of Denggue (Days)';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	scatter x='Tempoh Wabak Berlaku (Hari)'n y='Jumlah Kes Terkumpul'n / transparency=0.0 name='Scatter';
	xaxis grid;
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - There is a moderately weak positive relationship between the number of cases and the period of denggue in days;

*Graph 5;
title 'The Period of Denggue (Days) in Each Year';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Tahun / response='Tempoh Wabak Berlaku (Hari)'n stat=Sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - 2014 is the year with the longest period of denggue in days, 2012 is the year with the shortest period of denggue in days;

*Graph 6;
title 'The Number of Cases in Each Year and Week';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Minggu / response='Jumlah Kes Terkumpul'n group=Tahun groupdisplay=Cluster stat=Sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - The highest number of cases is in week 7 of the year 2015;

*Graph 7;
title 'The Number of Cases in Each State in Each Year';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Negeri / response='Jumlah Kes Terkumpul'n group=Tahun groupdisplay=Cluster stat=sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - Selangor has the highest number of cases in the year 2014 with 88172 cases;

*Graph 8;
title 'The Average Number of Cases in Each State in Each Year';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Negeri / response='Jumlah Kes Terkumpul'n group=Tahun groupdisplay=Cluster stat=mean name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - Kelantan has the highest average number of cases in the year 2014 with an average of 38.895 cases;

*Graph 9;
title 'The Number of Cases in Each District';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar  'Daerah/Zon/PBT'n / response='Jumlah Kes Terkumpul'n group=Tahun groupdisplay=Cluster stat=Sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - Petaling has the highest number of cases in 2014 with 63066 cases;

*Graph 10;
title 'The Period of Denggue (Days) in Each State';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Negeri / response='Tempoh Wabak Berlaku (Hari)'n group=Tahun groupdisplay=Cluster stat=Sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - Selangor has the longest period of denggue in days in 2014 with 253956 days;

*Graph 11;
title 'The Period of Denggue (Days) in Each District';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar 'Daerah/Zon/PBT'n / response= 'Tempoh Wabak Berlaku (Hari)'n group=Tahun groupdisplay=Cluster stat=Sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - Petaling has the longest period in days in 2014 with 169027 days;

*Graph 12;
title 'The Period of Denggue (Days) in Each State and District';
ods graphics / reset imagemap;
proc sgplot data=work.dengguesorted;
	vbar Negeri / response='Tempoh Wabak Berlaku (Hari)'n group='Daerah/Zon/PBT'n groupdisplay=Cluster stat=Sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;
*Result - Petaling in Selangor has the longest period of denggue in days with 263833 days;

*Manipulating Data;

ods pdf file='/home/n160287970/Analytics Engineering/16028797_AinaFatin.pdf';

*Adding a new variable based on monsoon in each negeri, which is most prone to flood:
 -If it is possible to flood in the current week of year, the variable will be yes
 -If it is not possible to flood in the current week of year, the variable will be no;

*Source: http://bencanaalam.jkr.gov.my/v2/index.php?ida=STAT-20080101233352
 -Northeast monsoon: week 44 - week 10
 -Southwest monsoon: week 21 - week 36;
 
data work.denggueflood;
	set work.dengguesorted;
	if Negeri = 'KELANTAN' and Minggu>=44 or Minggu<=10 then
		Flood='YES';
	else if Negeri = 'TERENGGANU' and Minggu>=44 or Minggu<=10 then
		Flood='YES';
	else if Negeri = 'PAHANG' and Minggu>=44 or Minggu<=10 then
		Flood='YES';
	else if Negeri = 'SABAH' and Minggu>=44 or Minggu<=10 then
		Flood='YES';
	else if Negeri = 'SARAWAK' and Minggu>=44 or Minggu<=10 then
		Flood='YES';
	else if Negeri = 'PERLIS' and Minggu>=21 and Minggu<=36 then
		Flood='YES'; 
	else if Negeri = 'KEDAH' and Minggu>=21 and Minggu<=36 then
		Flood='YES';
	else
		Flood='NO';
run;

*Viewing summary information of contents of the new data set;
proc contents data=work.denggueflood;
run;

*Viewing frequency of Yes and No to flood;
proc freq data=work.denggueflood;
	tables flood / nocum;
run;

*Represents the proc step above;
title 'The Frequency of Flood According to The Number of Cases';
ods graphics / reset imagemap;
proc sgplot data=work.denggueflood;
	vbar Flood / response='Jumlah Kes Terkumpul'n stat=freq name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;

*-67.72% of Negeri are not prone to flood while 32.28% of Negeri is prone to flood
 -Find if Kelantan or Selangor are related to the flood prone areas because
  Selangor has the highest number of cases while Kelantan has the highest average number of cases;

title 'Number of Cases in Kelantan Related to Flood';
proc sql;
	select count(Flood) 
	from work.denggueflood
	where Negeri='KELANTAN'
	and Flood='YES';
quit;
title;
*There are 25 cases in Kelantan that happens when it is flooding;

title 'Number of Cases in Selangor Related to Flood';
proc sql;
	select count(Flood) 
	from work.denggueflood
	where Negeri='SELANGOR'
	and Flood='YES';
quit;
title;
*There are 2568 cases in Selangor that happens when it is flooding;

*Since Selangor has the highest number of cases, it is suspected to be related to flooding 
 because out of 149066 of the cases, 2568 of it happened during flood;

*Sorting 2014 into a new data set because it has the most number of cases and the longest period of denggue in days;
proc sort data=work.dengguesorted out=work.denggue2014;
	where Tahun=2014;
	by Tahun Minggu Negeri 'Daerah/Zon/PBT'n Lokaliti;
run;

*Viewing summary information of contents of new data set;
proc contents data=work.denggue2014;
run;

*Viewing which Negeri contributes to the high number of cases in the year 2014;
proc freq data=work.denggue2014;
	tables Negeri / nocum;
run;
*Kelantan contributes 20.83% of cases in 2014 while Selangor contributes 73.49% of cases in 2014;

*Graph to support the above statement;
title 'Number of Cases in Each State by District in 2014';
ods graphics / reset imagemap;
proc sgplot data=work.denggue2014;
	vbar Negeri / response='Jumlah Kes Terkumpul'n group='Daerah/Zon/PBT'n groupdisplay=Cluster stat=Sum name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;

*However, when looking at average, Kelantan has the highest number of caess;

*Graph to support the above statement;
title 'Number of Average Cases in Each State by District in 2014';
ods graphics / reset imagemap;
proc sgplot data=work.denggue2014;
	vbar Negeri / response='Jumlah Kes Terkumpul'n group='Daerah/Zon/PBT'n groupdisplay=Cluster stat=mean name='Bar';
	yaxis grid;
run;
ods graphics / reset;
title;

*This may be due to the difference in number of districts in Selangor and Kelantan;
proc sql;
	select Negeri, count(distinct 'Daerah/Zon/PBT'n) AS 'Number of Districts'n
	from work.denggue2014
	where Negeri='SELANGOR'
	or Negeri='KELANTAN'
	group by Negeri;
quit;
*Selangor has 13 districts while Kelantan has 4 districts;

*Selangor has a higher number of case since it is distributed over 13 districts. Meanwhile, Kelantan has the highest average as it is only distributed over 4 districts;

ods pdf close;

*The findings from manipulation are also produced in a pdf format called 16028797_AinaFatin.pdf;
