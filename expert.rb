require 'readline'
# def parse_string(input)
#
#   if input[0] == '='
#     input.delete!('=').each_char do |char|
#       $WORKING_MEMORY[char] = true
#     end
#   elsif input[0] == '?'
#     input.delete!('?').each_char do |char|
#       if $WORKING_MEMORY[char]
#         puts "#{char} is #{$WORKING_MEMORY[char]}"
#       else
#         puts "#{char} is false"
#       end
#     end
#   else
#     res = ''
#     flag = 0
#     input.each_char do |char|
#       if char == '='
#         next
#       elsif $WORKING_MEMORY[char]
#         res += $WORKING_MEMORY[char].to_s
#       elsif char == "+"
#         res += '&&'
#       elsif char == "|"
#         res += '||'
#       elsif char == ">"
#         flag = 1
#         next
#       else
#         if flag == 0
#           res += 'false'
#         else
#           if (eval res).to_s == 'true'
#             $WORKING_MEMORY[char] = true
#           end
#         end
#       end
#     end
#   end
# end

def prove char
  puts 'proving char'
end


def right_side_includes? char
  res = $FACTS.map{ |line| line.scan(/[^\=\>]+/)[1] }
  res.include? char
end

def solve(input)
  input.delete!('?').each_char do |char|
    if $WORKING_MEMORY.keys.include? char
      puts "#{char}: True"
    elsif right_side_includes? char
      prove char
    else
      puts "#{char}: False"
    end
  end
end

def parse_string(input)
  if input[0] == '='
    input.delete!('=').each_char do |char|
      $WORKING_MEMORY[char] = true
      puts $WORKING_MEMORY
    end
  elsif input.include? '=>'
    unless $FACTS.include? input
      $FACTS.push input
      # $HASH_FACTS[input.scan(/[^\=\>]+/)[0]] << input.scan(/[^\=\>]+/)[1]
      puts "  #{$FACTS}"

    end
  elsif input[0] == '?'
    solve input
  end
end

def check_commands(input)
  case input
  when 'Exit', 'exit', 'e', '\e', 'q', 'quit', 'Quit'
    abort("Exiting... Bye bye")
  when 'rm f'
    $FACTS.clear
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
$WORKING_MEMORY = {}
$FACTS = ['B=>A',
          'D+E=>B',
          'G+H=>F',
          'I+J=>G',
          'G=>H',
          'L+M=>K',
          'O+P=>L+N',
          'N=>M']
# $HASH_FACTS = Hash[$FACTS.collect{ |line| [line.scan(/[^\=\>]+/)[0], line.scan(/[^\=\>]+/)[1]] }]
# puts $HASH_FACTS
puts "Welcome to Expert System"
while input = Readline.readline("-> ", true)
  print("-> ", check_commands(input), "\n")
  parse_string(input.gsub(/ /, '')) unless input.empty?
end

#------------------------------------------------------#
