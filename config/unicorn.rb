#
# Unicorn configuration.
#

# Listening port. Make sure this is unique and doesn't
# conflict with any other simfy listener. This must also be
# configured in nginx (proxy).
PORT = 40002

# Number of unicorn workers
WORKERS = 4

# Unicorn before_fork hook
before_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  ### put extra before_fork stuff --> here <-- ###
  ### put extra before_fork stuff --> here <-- ###
  ### put extra before_fork stuff --> here <-- ###

  # rolling restart (DO NOT EDIT THIS, this is boilerplate!)
  old_pid =  "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
  # /rolling restart
end

# Unicorn after_fork hook
after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  #R.client.reconnect

  ### put extra after_fork stuff --> here <-- ###
  ### put extra after_fork stuff --> here <-- ###
  ### put extra after_fork stuff --> here <-- ###
end

#############################################################################
#############################################################################
#############################################################################
#############################################################################

# CONFIGURATION END
# (you don't normally need to edit below this line)

#############################################################################
#############################################################################
#############################################################################
#############################################################################

RAILS_HOME = File.join(ENV['RAILS_HOME'])

require 'syslog-logger'

app_id = begin 
  File.read('config/unicorn.id').chomp
rescue
  'unknown'
end

class NoCrapFormatter < Logger::SyslogFormatter
  def call(severity, time, progname, msg)
    msg2str(msg)
  end
end

log = Logger::Syslog.new("unicorn-#{app_id}/#{ENV['RAILS_ENV']}", Syslog::LOG_DAEMON)
log.formatter = NoCrapFormatter.new
logger log

# pipe stderr/stdout to syslog
class StdioToLog
  def initialize(logger)
    @log = logger
  end

  def method_missing(name)
    @log.error "FIXME: #{name} was called on StdioToSyslog!"
  end

  def write(msg)
    @log.error msg
  end

  def nop
  end

  alias :puts :write
  alias :flush :nop
  alias :rewind :nop
end

$stdout = StdioToLog.new(log)
$stderr = StdioToLog.new(log)
Unicorn::HttpRequest::DEFAULTS["rack.errors"] = StdioToLog.new(log)

# Auto-detect a reasonable worker-count if it was set to nil.
workers = WORKERS
if workers.nil?
  require 'ohai'
    
  ohai = Ohai::System.new
  ohai.all_plugins

  workers = ohai.cpu["total"]
  (0..soft_cores-1).each do |n|
    workers += 1 if ohai.cpu[n.to_s]["flags"].include? "ht"
  end
end

worker_processes workers

mode = ENV['RAILS_ENV']
working_directory RAILS_HOME

listen PORT, :tcp_nopush => true

timeout 30

pid ENV['UNICORN_PIDFILE']
preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true