module HighlightsHelper

  def get_calculate_offset(end_time, start_time)
    diff = (end_time - start_time).to_i
    t = Time.parse('00:00:00')
    t = t + diff.second
    t.strftime('%H:%M:%S')
  end

end
