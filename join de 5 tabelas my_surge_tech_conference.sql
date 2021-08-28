select presentation.PRESENTATION_ID,start_time,end_time,
floor_number,seat_capacity,
name,description,
ticket_id,
first_name,last_name,vip
from presentation
inner join room
on room_id = booked_room_id
inner join company
on company_id = booked_company_id
inner join presentation_attendance
on presentation.PRESENTATION_ID = presentation_attendance.PRESENTATION_ID
inner join attendee
on attendee.ATTENDEE_ID = presentation_attendance.ATTENDEE_ID;