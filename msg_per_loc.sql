-- number of messages from each device for each experiment group
SELECT 
       a.location,
       SUM(CASE WHEN a.experiment_group = 'control_group' THEN 1 ELSE NULL END) AS control_users,
       SUM(CASE WHEN a.experiment_group = 'test_group' THEN 1 ELSE NULL END) AS test_users,
       SUM(CASE WHEN a.experiment_group = 'control_group' THEN a.msgs ELSE NULL END) control_msgs,
       SUM(CASE WHEN a.experiment_group = 'test_group' THEN a.msgs ELSE NULL END) test_msgs,
       
       SUM(CASE WHEN a.experiment_group = 'control_group' THEN a.msgs ELSE NULL END) / 
       SUM(CASE WHEN a.experiment_group = 'control_group' THEN 1 ELSE NULL END) AS avg_control_msgs,
       
       SUM(CASE WHEN a.experiment_group = 'test_group' THEN a.msgs ELSE NULL END) / 
       SUM(CASE WHEN a.experiment_group = 'test_group' THEN 1 ELSE NULL END) AS avg_test_msgs
       
FROM (
        SELECT ex.experiment_group,
               u.user_id,
               e.location,
               COUNT(*) AS msgs
        FROM (
                SELECT *
                  FROM tutorial.yammer_experiments
                 WHERE experiment = 'publisher_update'
               ) ex
          JOIN tutorial.yammer_users u
            ON u.user_id = ex.user_id
          JOIN tutorial.yammer_events e
            ON e.user_id = ex.user_id
           AND e.occurred_at BETWEEN ex.occurred_at AND '2014-07-01'
           AND e.event_name = 'send_message'
          GROUP BY 1,2,3
          ORDER BY 1,2
          ) a
GROUP BY 1
ORDER BY 1

