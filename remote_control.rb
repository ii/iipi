require 'libdevinput'
require 'pry'


def chassis(ip)
  puts "#{$action} #{ip}"
  IO.popen("ipmi-chassis -h #{ip} --chassis-control=#{$action}")
end

remote=DevInput.new '/dev/input/event0'
$action = 'power-up'
puts "ii tv remote ready"
puts "default action is #{$action}"
remote.each do |event|
  if event.type_str == 'Key' and event.value_str == 'Press'
    case event.code_str
    when 'Esc'
      #puts '1'
      chassis '1.1.0.1'
    when '1'
      #puts '2'
      chassis '1.1.0.2'
    when '2'
      #puts '3'
      chassis '1.1.0.3'
    when '3'
      #puts '4'
      chassis '1.1.0.4'
    when '4'
      #puts '5'
      chassis '1.1.0.5'
    when '5'
      #puts '6'
      chassis '1.1.0.6'
    when '6'
      puts '7'
    when '7'
      puts '8'
    when '8'
      puts '9'
    when 'F8'
      #puts '-'
      $action = 'power-down'
      puts "action set to #{$action}"
    when 'F7'
      #puts 'recycle'
      $action = 'power-cycle'
      puts "action set to #{$action}"
    when 'Minus'
      puts 'Vol Up'
    when 'P'
      puts 'Vol Down'
    when 'Tab'
      puts 'Ch Up'
    when 'Katakana'
      puts 'Ch Down'
    when 'KP2'
      puts 'MTS'
    when 'HIRAGANA'
      puts 'C.C'
    else
      if event.code == 255
        $action = 'power-up'
        puts "action set to #{$action}"
        next
      end
      puts "got event #{event}"
      puts <<-EOF
  #{event.time}: A Time object of the event time
  #{event.tv_sec}: An Integer with the number of seconds since epoch
  #{event.tv_usec}: An Integer with the sub-seconds value in milliseconds
  #{event.type}: An Integer with the type code
  #{event.type_str}: A String representation of the type if available
  #{event.code}: An Integer with the event code
  #{event.code_str}: A String representation of the code if available
  #{event.value}: An Integer with the event value
  #{event.value_str}: A String representation of the value if available
EOF
    end
  end
end
