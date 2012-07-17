begin
  R = Redis.new
  R.info
rescue => err
  puts "ERROR: error connecting redis #{err.message}"
end