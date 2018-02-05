Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('faculty                       ,section                       ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('department                    ,section                       ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('department                    ,faculty                       ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('course                        ,room                          ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('course                        ,grant                         ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('faculty                       ,grad_student                  ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('department                    ,grant                         ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('department                    ,grad_student                  ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('course                        ,grad_student                  ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('grad_student                  ,grant                         ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('course                        ,faculty                       ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('room                          ,student                       ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('course                        ,student                       ');
Insert into ENTS_2HOPS
   (RESULT)
 Values
   ('course                        ,department                    ');
COMMIT;
