INSERT INTO hotel_bookings (
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT

CASE (gs % 4)
    WHEN 0 THEN '11111111-1111-1111-1111-111111111111'::uuid
    WHEN 1 THEN '22222222-2222-2222-2222-222222222222'::uuid
    WHEN 2 THEN '33333333-3333-3333-3333-333333333333'::uuid
    ELSE '44444444-4444-4444-4444-444444444444'::uuid
END,

'HOTEL-' || ((gs % 10) + 1),

CASE (gs % 6)
    WHEN 0 THEN 'delhi'
    WHEN 1 THEN 'mumbai'
    WHEN 2 THEN 'bengaluru'
    WHEN 3 THEN 'hyderabad'
    WHEN 4 THEN 'pune'
    ELSE 'chennai'
END,

CURRENT_DATE + (gs % 15),

CURRENT_DATE + ((gs % 15) + 2),

ROUND((1000 + random()*9000)::numeric,2),

CASE (gs % 4)
    WHEN 0 THEN 'confirmed'
    WHEN 1 THEN 'completed'
    WHEN 2 THEN 'pending'
    ELSE 'cancelled'
END,

NOW() - ((gs % 45) || ' days')::interval

FROM generate_series(1,120) gs;