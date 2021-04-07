require 'securerandom'

file_name = SecureRandom.uuid
File.open("#{file_name}","w") do |text|
  text.puts("Hello!!")
 end
