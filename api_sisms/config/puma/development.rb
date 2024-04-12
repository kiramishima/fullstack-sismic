threads 4, 4
workers 2
preload_app!

before_fork do
  ApiSisms::DB.disconnect if defined?(ApiSisms::DB)
end