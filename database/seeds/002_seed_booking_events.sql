INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,

    CASE (row_number() OVER ())
        % 5
        WHEN 0 THEN 'BOOKING_CREATED'
        WHEN 1 THEN 'PAYMENT_SUCCESS'
        WHEN 2 THEN 'CHECK_IN'
        WHEN 3 THEN 'CHECK_OUT'
        ELSE 'BOOKING_CANCELLED'
    END,

    jsonb_build_object(
        'source', 'system',
        'status', 'processed'
    ),

    created_at

FROM hotel_bookings

LIMIT 80;