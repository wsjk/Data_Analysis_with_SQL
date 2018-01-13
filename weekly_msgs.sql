-- weekly total of users sending and messages and amt of messages sent by users split by experiment_group
SELECT b.week, 
      SUM(CASE WHEN b.experiment_group = 'control_group' THEN 1 ELSE NULL END) AS total_control_users,
      SUM(CASE WHEN b.experiment_group = 'control_group' THEN b.count ELSE NULL END) AS total_control_msgs,
      SUM(CASE WHEN b.experiment_group = 'control_group' THEN b.count ELSE NULL END) / SUM(CASE WHEN b.experiment_group = 'control_group' THEN 1 ELSE NULL END) AS avg_control_msg,
      SUM(CASE WHEN b.experiment_group = 'test_group' THEN 1 ELSE NULL END) AS total_test_users,
      SUM(CASE WHEN b.experiment_group = 'test_group' THEN b.count ELSE NULL END) AS total_test_msgs,
      SUM(CASE WHEN b.experiment_group = 'test_group' THEN b.count ELSE NULL END) / SUM(CASE WHEN b.experiment_group = 'test_group' THEN 1 ELSE NULL END) AS avg_test_msg
FROM (
SELECT DATE_TRUNC('week',a.occurred_at) AS week, a.experiment_group, a.user_id , COUNT(*)
FROM (
SELECT ex.experiment,
       ex.experiment_group,
       e.occurred_at,
       e.user_id,
       COUNT(*)
        FROM (SELECT user_id,
                     experiment,
                     experiment_group,
                     occurred_at
                FROM tutorial.yammer_experiments
               WHERE experiment = 'publisher_update'
             ) ex
        JOIN tutorial.yammer_events e
              ON e.user_id = ex.user_id
             AND e.event_name = 'send_message'
         GROUP BY 1,2,3,4
) a
GROUP BY 1,2,3
) b
GROUP BY 1

