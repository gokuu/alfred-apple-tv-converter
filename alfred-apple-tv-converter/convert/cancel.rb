require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))

status = read_status
status[:cancel] = true
write_status status

puts "Canceling process"