-- Query from the assessment

EXPLAIN ANALYZE
SELECT
    org_id,
    status,
    COUNT(*) AS total_bookings,
    SUM(amount) AS total_revenue
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;