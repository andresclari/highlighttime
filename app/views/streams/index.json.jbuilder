json.array! @records do |record|
  json.id               record.id
  json.start_time       record.start_time.strftime('%m/%d/%Y - %l:%M %p')
  json.stop_time        record.stop_time.strftime('%m/%d/%Y - %l:%M %p') rescue ''
end
