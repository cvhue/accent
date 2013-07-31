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


param skill_therapist{i in I};
/* if therapist i has skill s  */

param skill_patient{j in J, s in S};
/* if patient j needs skill s  */

set PS dimen 2;


table tab_patients IN "CSV" "patients.csv" :
    J <- [patient];
    
table tab_therapists IN "CSV" "therapists.csv" :
    I <- [therapist], skill_therapist ~ skill;

table tab_patientskills IN "CSV" "patientskills.csv" :
  PS <- [patient,skill];

#param skill_patient{j in J, s in S} := 
 #   if exists((j,s) in PS) then 1 else 0;

var x{i in I, j in J, t in T, d in D}, binary;
/* assignment var */

maximize assignments: sum{i in I, j in J, t in T, d in D} x[i,j,d,t];

s.t. week{j in J}: sum{i in I, d in D, t in T} x[i,j,d,t] == 1;
/* weekly schedule every patient once i */

s.t. samedaytherapist{d in D, t in T, i in I}: sum{j in J} x[i,j,d,t] <= 1;
/* maximally one assignment per day-time for a therapist*/

s.t. minhours{i in I}: sum{j in J, t in T, d in D} x[i,j,d,t] >= 3;
/* devide the number of assignments to minimum 3 per therapist */

s.t. skills{(s,j) in PS}: sum{i in I, t in T, d in D} x[i,j,d,t] == 1;

solve;

table tab_result{i in I, j in J, t in T, d in D: x[i,j,d,t] = 1} OUT "CSV" "solution.csv" :
    if x[i,j,d,t] = 1 then i ~ therapist, j ~ patient, d ~ day, t ~ time ;

end;
