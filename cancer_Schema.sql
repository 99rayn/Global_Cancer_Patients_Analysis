use cancer_schema;

drop table if exists cancer_analysis;

create table cancer_analysis(
Patient_ID	varchar(30) not null,
Age	int not null,
Gender varchar(10) not null,	
Country_Region	varchar(30) not null,
Years	int not null,
Genetic_Risk	decimal(10,5) not null,
Air_Pollution	decimal(10,5) not null,
Alcohol_Use	decimal(10,5) not null,
Smoking	decimal(10,5) not null,
Obesity_Level	decimal(10,5) not null,
Cancer_Type	varchar(30) not null,
Cancer_Stage	varchar(30) not null,
Treatment_Cost_USD	decimal(10,5) not null,
Survival_Years	decimal(10,5) not null,
Target_Severity_Score decimal(10,5) not null
);