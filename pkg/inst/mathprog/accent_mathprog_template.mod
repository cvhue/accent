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

param par_values{p in PM};
param tmp{i in I};

table tab_patients IN "CSV" "{{patients}}" :
    J <- [patient];
    
table tab_therapists IN "CSV" "{{therapists}}" :
    I <- [therapist], tmp ~ skill;

table tab_patientskills IN "CSV" "{{patientskills}}" :
  PS <- [patient,skill];

table tab_preferences IN "CSV" "{{parameters}}" :
  PM <- [parameter], par_values ~ value;


param skill_patient{j in J, s in S} := 
  if (j,s) in PS then 1 else 0;

param skill_therapist{i in I, s in S} :=
  if tmp[i] == s then 1 else 0;

## START OF MATHEMATICAL MODEL


var x{i in I, j in J, t in T, d in D}, binary;
/* assignment var */

maximize assignments: sum{i in I, j in J, t in T, d in D} x[i,j,d,t];

s.t. week{j in J,s in S}: sum{i in I, d in D, t in T} skill_therapist[i,s] * x[i,j,d,t] == skill_patient[j,s];
/* weekly schedule every patient once i */

s.t. samedaytherapist{d in D, t in T, i in I}: sum{j in J} x[i,j,d,t] <= 1;
/* maximally one assignment per day-time for a therapist*/

s.t. minhours{i in I}: sum{j in J, t in T, d in D} x[i,j,d,t] >= par_values["minhours"];
/* devide the number of assignments to minimum 3 per therapist */

#s.t. skills{(s,j) in PS}: sum{i in I, t in T, d in D} x[i,j,d,t] == 1;

solve;

table tab_result{i in I, j in J, t in T, d in D: x[i,j,d,t] = 1} OUT "CSV" "{{solution}}" :
    if x[i,j,d,t] = 1 then i ~ therapist, j ~ patient, d ~ day, t ~ time ;

end;
