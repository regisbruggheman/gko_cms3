if Rails.env.development?
  # Clears all log files and directories in tmp/cache
  $stdout.puts "Runing rake log:clear"
  `rake log:clear`
  # Clears all files and directories in tmp/cache
  $stdout.puts "Runing rake tmp:clear"
  `rake tmp:clear`
end