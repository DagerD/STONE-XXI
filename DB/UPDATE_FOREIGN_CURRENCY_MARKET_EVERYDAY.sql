BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"USER_MARKELOV".""',
            job_type => 'STORED_PROCEDURE',
            job_action => 'USER_MARKELOV.STONE_XXI.FILL_CURRENCY',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2020-11-30 12:00:00.943000000 EUROPE/MOSCOW','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'get new data into table from cbr');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"USER_MARKELOV".""', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"USER_MARKELOV".""', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
   
  
    
    DBMS_SCHEDULER.enable(
             name => '"USER_MARKELOV".""');
END;
