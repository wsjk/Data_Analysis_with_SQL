SELECT a.treatment_start,
       SUM(CASE
               WHEN a.experiment_group = 'control_group' THEN 1
               ELSE NULL
           END) AS control_group,
       SUM(CASE
               WHEN a.experiment_group = 'test_group' THEN 1
               ELSE NULL
           END) AS test_group
FROM
  ( SELECT ex.experiment,
           ex.experiment_group,
           ex.occurred_at AS treatment_start,
           u.user_id,
           u.activated_at
   FROM
       (SELECT user_id,
               experiment,
               experiment_group,
               occurred_at
      FROM tutorial.yammer_experiments
      WHERE experiment = 'publisher_update' ) ex
   JOIN tutorial.yammer_users u
     ON u.user_id = ex.user_id
   JOIN tutorial.yammer_events e
     ON e.user_id = ex.user_id
     AND e.occurred_at >= ex.occurred_at
     AND e.occurred_at < '2014-07-01'
     AND e.event_name = 'send_message' ) a
GROUP BY 1
ORDER BY 1