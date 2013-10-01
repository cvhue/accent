# ACCENT THERAPIST ASSIGNMENT
#
# Mathprog model
#
#  Christophe Van Huele


set I;
/* therapists */

set J;
/* patients */

set T := 1..5;
/* set of time blocks per day */

set D := 1..5;
/* set of days */

set W := 1..1;
/* set of weeks */

set S := 1..3;
/* set of skills */

set PS dimen 2;
set TS dimen 2;
set PM;

set PP dimen 3;
set TP dimen 3;
set PU dimen 3;
set TU dimen 3;
 

param par_values{p in PM};
param tmp{i in I};

table tab_patients IN "CSV" "{{patients}}" :
    J <- [patient];
    
table tab_therapists IN "CSV" "{{therapists}}" :
    I <- [therapist], tmp ~ skill;

table tab_patientskills IN "CSV" "{{patientskills}}" :
  PS <- [patient,skill];

table tab_parameters IN "CSV" "{{parameters}}" :
  PM <- [parameter], par_values ~ value;
display PM;

table tab_patientpreferences IN "CSV" "{{patientpreferences}}" :
  PP <- [patient,day,time];

table tab_patientunavailabilities IN "CSV" "{{patientunavailabilities}}" :
  PU <- [patient,day,time];

table tab_TU IN "CSV" "{{therapistunavailabilities}}" :
  TU <- [therapist,day,time];

table tab_therapistpreferences IN "CSV" "{{therapistpreferences}}" :
  TP <- [therapist,day,time];


param p_pref{j in J, d in D, t in T} := 
  if (j,d,t) in PP then 1 else 0;

param t_pref{i in I, d in D, t in T} := 
  if (i,d,t) in TP then 1 else 0;

param p_un{j in J, d in D, t in T} := 
  if (j,d,t) in PU then 1 else 0;

param t_un{i in I, d in D, t in T} := 
  if (i,d,t) in TU then 1 else 0;


param skill_patient{j in J, s in S} := 
  if (j,s) in PS then 1 else 0;

param skill_therapist{i in I, s in S} :=
  if tmp[i] == s then 1 else 0;

## START OF MATHEMATICAL MODEL


var x{i in I, j in J, t in T, d in D}, binary;
/* assignment var */

maximize assignments:   sum{i in I, j in J, t in T, d in D}  par_values["preference"]  *t_pref[i,d,t] * x[i,j,d,t] 
   +  sum{i in I, j in J, t in T, d in D} (1 - par_values["preference"]) * p_pref[j,d,t] * x[i,j,d,t];

s.t. week{j in J,s in S}: sum{i in I, d in D, t in T} skill_therapist[i,s] * x[i,j,d,t] == skill_patient[j,s];
/* weekly schedule every patient once i */


s.t. samedaypatient{d in D, t in T, j in J}: sum{i in I} x[i,j,d,t] <= 1;
/* maximally one assignment per day-time for a therapist*/

s.t. samedaytherapist{d in D, t in T, i in I}: sum{j in J} x[i,j,d,t] <= 1;
/* maximally one assignment per day-time for a therapist*/

s.t. minhours{i in I}: sum{j in J, t in T, d in D} x[i,j,d,t] >= par_values["minhours"];
/* devide the number of assignments to minimum 3 per therapist */

s.t. unavailable{(i,d,t) in TU}: sum{j in J} x[i,j,d,t] == 0;

#s.t. skills{(s,j) in PS}: sum{i in I, t in T, d in D} x[i,j,d,t] == 1;

solve;

table tab_result{i in I, j in J, t in T, d in D: x[i,j,d,t] = 1} OUT "CSV" "{{solution}}" :
    if x[i,j,d,t] = 1 then i ~ therapist, j ~ patient, d ~ day, t ~ time ;

end;
