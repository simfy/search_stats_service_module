set :rails_env,   "staging"
ip = "stage.lw.simfy.com"

role :web, ip
role :app, ip

set :ssh_options,     {
  :forward_agent => true,
  :port          => 50123,
}
