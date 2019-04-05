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



# `KNOWLEDGE BASE`
# {
#   CanRideBikeToWork F => Q CanGetToWork
#
#   CanDriveToWork G => Q CanGetToWork
#
#   CanWalkToWork H => Q CanGetToWork
#
#   HaveBike I + J Sunny => F CanRideBikeToWork
#
#   OwnCar K => G CanDriveToWork
#
#   RentCar L => G CanDriveToWork
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

def backchain($KB, query)
  stack = []
  stack.push(query)

  context = []
  backtrack($KB, stack, context)
end

BC(KB,stack,context) // the main recursive function
	# if stack.empty(), return True
  #
	# goal = stack.pop() // a known fact was popped, recurse on rest of goals in stack
  #
	# if goal "Є" KB, return BC(KB,stack,context)
  # context.push(goal)//add this to list of things trying to prove

  for each rule a1..an => goal in KB: // choice point, might have to backtrack to try other rules
		if any ai is in context: continue//skip this rule, circular
		for each ai in antecedents:
			stack = stack.push(ai) // push antecedents as subgoals
		result = BC(KB,stack,context) // recurse
		if result=True: return True
	return False

def kb_which_include_all_rules
  #   CanRideBikeToWork F => Q CanGetToWork
  #   CanDriveToWork G => Q CanGetToWork
  #   CanWalkToWork H => Q CanGetToWork
end

def backtrack($KB, stack, context)
  return true if stack.empty?

  goal = stack.shift
  return backtrack($KB,stack,context) if $KB.include? goal
  context.push(goal)

  kb_which_include_all_rules.each do |rule|
    next if context.include? rule


  end
end













# 
# Notes on Back-chaining Algorithm
#
# This is simpler version of the algorithm that backtracks over rules until each subgoal in the goal stack can be proved as a known fact.
#
# Backchain(KB,query) // wrapper function
# 	stack  new stack() // initialize
#   	stack.push(query)
# 	return BC(KB,stack)
#
# BC(KB,stack) // the main recursive function
# 	if stack.empty(), return True
# 	goal  stack.pop()
#    // a known fact was popped, recurse on rest of goals in stack
# 	if goal  KB, return BC(KB,stack)
# 	for each rule a1..angoal in KB:
# 		// choice point, might have to backtrack to try other rules
# 		for each ai in antecedents:
# 			stack  stack.push(ai) // push antecedents as subgoals
# 		result  BC(KB,stack) // recurse
# 		if result=True: return True
# 	return False
#
#
# This is a more sophisticated version of the algorithm that keeps track of the context of subgoals it is trying to prove, so it avoids circularities and getting stuck in infinite loops.
#
# Backchain(KB,query) // wrapper function
# 	stack  new stack() // initialize
#   	stack.push(query)
# 	context  new stack() // list of goals trying to prove
# 	return BC(KB,stack,context)
#
# BC(KB,stack,context) // the main recursive function
# 	if stack.empty(), return True
# 	goal  stack.pop()
#    // a known fact was popped, recurse on rest of goals in stack
# 	if goal  KB, return BC(KB,stack,context)
#    context.push(goal)//add this to list of things trying to prove
# 	for each rule a1..angoal in KB:
# 		// choice point, might have to backtrack to try other rules
# 		if any ai is in context: continue//skip this rule, circular
# 		for each ai in antecedents:
# 			stack  stack.push(ai) // push antecedents as subgoals
# 		result  BC(KB,stack,context) // recurse
# 		if result=True: return True
# 	return False
#
#
#
# example
# KB = {1. CanRideBikeToWork  CanGetToWork
# 	2. CanDriveToWork  CanGetToWork
# 	3. CanWalkToWork  CanGetToWork
# 	4. HaveBikeSunny  CanRideBikeToWork
# 	5. OwnCar  CanDriveToWork
# 	6. RentCar  CanDriveToWork
# 	HaveMoneyTaxiAvailable  CanDriveToWork
# 	Rainy
# 	HaveBike
# 	HaveMoney
# 	RentCar
# 	TaxiAvailable }
#
# query = CanGetToWork ?
#
# {CanGetToWork} initialize goal stack with query
# pop top goal, match with consequent of rule 1 (choicepoint*),push antecedents onto stack
# {CanRideBikeToWork}
# {HaveBike,Sunny} use rule 4
# {Sunny} pop HaveBike, is fact
# backtrack since Sunny in not a fact and can’t be proved
# 	make another choice at * above
# {CanDriveToWork} rule 2
# {OwnCar} rule 5
# backtrack, not provable, choose another rule to prove CanDriveToWork
# {RentCar} using rule 6
# known fact
# {} - success! empty goal stack, return True
#



Rainy = A
HaveBike = B
HaveMoney = C
RentCar = D
TaxiAvailable = E

CanRideBikeToWork = F
CanDriveToWork = G
CanWalkToWork = H
HaveBike = I
Sunny = J
OwnCar = K
RentCar = L
HaveMoney = M
TaxiAvailable = N
CanGetToWork = Q





















=
