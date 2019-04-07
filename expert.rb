require 'readline'

# def right_side_includes? char
#   res = $FACTS.map{ |line| line.scan(/[^\=\>]+/)[1] }
#   res
# end
def rules_that_implies(goal)
  # CanRideBikeToWork F => Q CanGetToWork
  # CanDriveToWork G => Q CanGetToWork
  # CanWalkToWork H => Q CanGetToWork
  # [['F'], ['G'], ['H']]
    res = $FACTS.map{ |line| line.scan(/.+=>.*#{goal}.*/) }
    res.reject(&:empty?)
  # ['D']
end

def find_left_hand_goals_in(rule)
  res = rule.scan(/.*=/)[0]
  res = res.scan(/\w/).join('')
  res
end

def find_left_hand_expression_in(rule)
  res = rule.scan(/.*=/)[0]
  res.delete!('=')
end


def sole left_hand_expression
  # puts $TEMP_WORKING_MEM
  $TEMP_WORKING_MEM.each { |k,v| left_hand_expression.gsub!(k, v.to_s)}
  left_hand_expression = left_hand_expression.gsub(/\+/, '&&')
  left_hand_expression = left_hand_expression.gsub(/\|/, '||')
  left_hand_expression.gsub!(/[A-Z]/, 'false')
  # puts left_hand_expression
  begin # TODO: CHECK IF WORKS
    eval left_hand_expression
  rescue
    puts "I assume that you found an endless recursion so I'll say that it is false"
  end
end

def backtrack( stack, context)
  return true if stack.empty?

  goal = stack.shift
  if $WORKING_MEMORY.include? goal
    # puts "PRESENT IN WORKING_MEMORY: #{goal}"
    return backtrack(stack,context)
    # return true
  end
  context.unshift(goal)
  # puts "CONTEXT: #{context}"

  rules = rules_that_implies goal
  # puts "RULES THAT IMPLIES GOAL #{goal}"

  rules.each do |rule|
    # puts "RULE: #{rule}"
    left_hand_goals = find_left_hand_goals_in rule.first
    left_hand_expression = find_left_hand_expression_in rule.first
    # puts left_hand_expression
    # puts "left_hand_goals: #{left_hand_goals}"
    left_hand_goals.each_char do |rule_char|
      if context.include? rule_char
        # puts "CONTEXT MOVES NEXT: #{context}"
        # $TEMP_WORKING_MEM[rule_char] = false
        next
      end
      stack.unshift rule_char
      # puts "STACK IS #{stack}"
      result = backtrack(stack,context)
      $TEMP_WORKING_MEM[rule_char] = result
    end
    result = sole left_hand_expression
    if result == true
      puts "#{rule} is true, so #{goal} is true"
      return true
    end
    false
  end

  false
end

def backchain(query)
  stack = []
  stack.push(query)
  context = []
  $TEMP_WORKING_MEM = {}
  res = backtrack(stack, context)
  res
end

def solve(input)
    # puts 'solving input'
  puts input
  input.delete!('?').each_char do |char|
    puts "#{char}: #{backchain(char)}"
  #   if $WORKING_MEMORY.keys.include? char
  #     puts "#{char}: True"
  #   elsif right_side_includes? char
  #     prove input
  #   else
  #     puts "#{char}: False"
  #   end
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

# CASE 1 ==================================

# $FACTS = ['B=>A',
#           'D+E=>B',
#           'G+H=>F',
#           'I+J=>G',
#           'G=>H',
#           'L+M=>K',
#           'O+P=>L+N',
#           'N=>M']

# =DEIJOP # AFKP is true
# =DEIJP # AFP is true, K is false
# ?AFKP

# CASE 2 ==================================

# $FACTS = ['B+C=>A',
#           'D|E=>B',
#           'B=>C']

# = # A should be false.
# =D # A should be true.
# =E # A should be true.
# =DE # A should be true.
#
# ?A

# CASE 3 ==================================

# $FACTS = ['B+C=>A',
#           'D^E=>B',
#           'B=>C']

# = # A should be false.
# =D # A should be true.
# =E # A should be true.
# =DE # A should be false.
# ?A

# CASE 4 ==================================

# $FACTS = ['B+!C=>A']

# = # A should be false.
# =B # A should be true.
# =C # A should be false.
# =BC # A should be false.

# CASE 5 ==================================

# $FACTS = ['B=>A',
#           'C=>A']

# = # A should be false.
# =B # A should be true.
# =C # A should be true.
# =BC # A should be true.
#
# ?A

# CASE 6 ==================================

# $FACTS = ['A|B+C=>E',
#           '(F|G)+H=>E']

# ?E
#
#
# =A #, E should be true.
# =B #, E should be false.
# =C #, E should be false.
# =AC #, E should be false.
# =BC #, E should be true.
#
# =F #, E should be false.
# =G #, E should be false.
# =H #, E should be false.
# =FH #, E should be true.
# =GH #, E should be true.

# CASE 7 ==================================

# $FACTS = ['A+B|C=>E',
#           '(F|G)+H=>E']

# CASE 8 ==================================

# $FACTS = ['F=>Q',
#           'G=>Q',
#           'H=>Q',
#           'B^I=>F',
#           'J=>G',
#           'D=>G',
#           'C+E=>G']

#   `=ABCDE`
# `?QA`

# CASE 9 ==================================

# $FACTS = ['B=>A',
#           'A=>B', #==========================================================> ERROR
#           'C=>A']

# CASE 10 ==================================

# $FACTS = ['(C+D)|(V+M)=>S',
#           'S+!A=>E']

# =CD
# ?SE # S - true, E - true

# CASE 11 ==================================

# $FACTS = ['S|E|V=>V',
#           'V+!V=>C']

# =S
# ?VC # V - true, C - false

# CASE 12 ==================================

# $FACTS = ['A+B=>A+B',
#           '!C=>C',
#           'D+!A=>D']

# =C
# ?A

# CASE 13 ==================================

# $FACTS = ['A+(C|B)=>D']

# =AB
# ?D # D - true

# CASE 14 ==================================

# $FACTS = ['!X=>Y',
#           '!X+X=>Y',
#           'X^X=>Y',
#           'X+X+X+X=>Y']
# =X
# ?Y # Y - true

# CASE 15 ==================================

# $FACTS = ['!(A+!A)=>C']

# =A
# ?C # C - true

# CASE 16 ==================================

# $FACTS = ['A^A=>A',
#           'B^!B=>B']

# =
# ?AB # A - false, B - true

# CASE 17 ==================================

# $FACTS = ['A^(X|Y)=>V',
#           'N+(B^V)^!V=>S']

# =XBN
# ?SV # S - false, V - true

# CASE 18 ==================================

# $FACTS = ['X=>A+B',
#           'C+D+E=>C+V']

# =XCD
# ?ABCV # A - true, B - true, C - true, V - false




# $HASH_FACTS = Hash[$FACTS.collect{ |line| [line.scan(/[^\=\>]+/)[0], line.scan(/[^\=\>]+/)[1]] }]
# puts $HASH_FACTS
puts "Welcome to Expert System"
while input = Readline.readline("-> ", true)
  print("-> ", check_commands(input), "\n")
  parse_string(input.gsub(/ /, '')) unless input.empty?
end

#------------------------------------------------------#


# Rainy = A
# HaveBike = B
# HaveMoney = C
# RentCar = D
# TaxiAvailable = E
#
# CanRideBikeToWork = F
# CanDriveToWork = G
# CanWalkToWork = H
# Sunny = I
# OwnCar = J
# CanGetToWork = Q


# `KNOWLEDGE BASE`
# {
#   CanRideBikeToWork F => Q CanGetToWork
#
#   CanDriveToWork G => Q CanGetToWork
#
#   CanWalkToWork H => Q CanGetToWork
#
#   HaveBike B + I Sunny => F CanRideBikeToWork
#
#   OwnCar J => G CanDriveToWork
#
#   RentCar D => G CanDriveToWork
#
#   HaveMoney C + E TaxiAvailable => G CanDriveToWork
#
#   `=ABCDE`
# }
#
# `QUERY`
# {
#   `?QA`
# }

# Backchain(KB,query) // wrapper function
# 	stack = new stack() // initialize
#   	stack.push(query)
# 	context = new stack() // list of goals trying to prove
# 	return BC(KB,stack,context)






















# =
