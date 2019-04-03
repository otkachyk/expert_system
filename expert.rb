require 'readline'
def parse_string(input)

  if input[0] == '='
    input.delete!('=').each_char do |char|
      $KB[char] = true
    end
  elsif input[0] == '?'
    input.delete!('?').each_char do |char|
      if $KB[char]
        puts "#{char} is #{$KB[char]}"
      else
        puts "#{char} is false"
      end
    end
  else
    res = ''
    flag = 0
    input.each_char do |char|
      if char == '='
        next
      elsif $KB[char]
        res += $KB[char].to_s
      elsif char == "+"
        res += '&&'
      elsif char == "|"
        res += '||'
      elsif char == ">"
        flag = 1
        next
      else
        if flag == 0
          res += 'false'
        else
          if (eval res).to_s == 'true'
            $KB[char] = true
          end
        end
      end
    end
  end
end

def check_commands(input)
  case input
  when 'Exit', 'exit', 'e', '\e', 'q', 'quit', 'Quit'
    abort("Exiting... Bye bye")
  when ''
    '-----------'
  end
end

#-------------------------------------------------------#
#-------------------------------------------------------#
#-------------------------------------------------------#
#-------------------------------------------------------#
#----------------------MAIN PART------------------------#
#-------------------------------------------------------#
#-------------------------------------------------------#
#-------------------------------------------------------#
#-------------------------------------------------------#


#------------------ Catches Ctrl + C ------------------#
stty_save = `stty -g`.chomp
trap("INT") { system "stty", stty_save; exit }
#------------------ ---------------- ------------------#

#-------------------- Main loop -----------------------#
$KB = {}
puts "Welcome to Expert System"
while input = Readline.readline("-> ", true)
  print("-> ", check_commands(input), "\n")
  parse_string(input.gsub(/ /, '')) unless input.empty?
end

#------------------------------------------------------#
