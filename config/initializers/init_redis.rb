begin
  R = Redis.new
  R.info
rescue => err
  puts "REDIS_CONFIG: #{redis_config.inspect}"
  puts "ERROR: error connecting redis #{err.message}"
end