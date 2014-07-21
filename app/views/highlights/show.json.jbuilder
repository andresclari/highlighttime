json.id               @record.id
json.start_time       get_calculate_offset(@record.start_time, @record.stream.start_time)
