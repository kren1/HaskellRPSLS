#!/usr/bin/env ruby

require 'open3'

moves = ["@", "#", "8<", "C", "V"]


def report_crash bot
  $stderr.puts "Your bot (#{bot[:name]} has crashed!!"
  $stderr.puts "It's stderr is:\n"
  bot[:std_err].each {|line| $stderr.puts line}
  abort "\nGame can not continue!"
end

def how_beats(move1, move2)

  case move1
  when "@"
    return "crushed" if move2 == "8<" || move2 == "C"
  when "#"
    return "covered" if move2 == "@"
    return "disproved" if move2 == "V"
  when "8<"
    return "cut" if move2 == "#"
    return "decapitated" if move2 == "C"
  when "C"
    return "ate" if move2 == "#"
    return "poisoned" if move2 == "V"
  when "V"
    return "vaporised" if move2 == "@"
    return "smashed" if move2 == "8<"
  end

  return nil
end

def beats(move1, bot1, move2, bot2)
  method = how_beats(move1, move2)
  if method
    puts "#{bot1[:name]}'s #{move1} #{method} #{bot2[:name]}'s #{move2}"
    return 1
  elsif bot1[:index] < bot2[:index] && move1 == move2
    puts "#{bot1[:name]}'s #{move1} drew with #{bot2[:name]}'s #{move2}"
  end
  return 0
end


bots = ARGV.each_with_index.map do |arg, index|
  std_in, std_out, std_err = Open3.popen3(arg)
  {
    :name    => "Player #{index + 1} (#{arg})",
    :index   => index,
    :std_out => std_out,
    :std_in  => std_in,
    :std_err => std_err
  }
end

number_of_rounds = false

until number_of_rounds do
  puts "How many rounds would you like to be played?"
  number_of_rounds = STDIN.gets.match(/^([0-9]+)\n/)
end

bots.each do |bot|
  begin
    bot[:std_in].write("#{bots.size}\n" + number_of_rounds[0] + "\n")
  rescue
    report_crash bot
  end
end

scores = bots.map { 0 }

number_of_rounds[1].to_i.times do | i |

  puts "Round #{i}"

  round_moves = bots.map do |bot|
    begin
      move = bot[:std_out].gets.match(/([^\r\n]*)/)[1]
      abort("Your bot (#{bot[:name]} played an invalid move \"#{move}\"\n\nThe game cannot continue!") unless moves.include? move
    rescue
      report_crash bot
    end
    move
  end

  if bots.size > 1
    bots.each { |bot|
      bot[:std_in].puts("#{round_moves.take(bot[:index]).join("\n")}\n#{round_moves.drop(bot[:index] + 1).join("\n")}\n")
    }
  end

  round_moves.each_with_index {|round_move, index|
    scores[index] = scores[index] + round_moves.each_with_index.inject(0){|acc, (other_move, other_index)|
      acc = acc + beats(round_move, bots[index], other_move, bots[other_index])
    }
  }

end

puts "\n\nFinal Scores:\n\n"

bots.each_with_index { |bot, index|
  puts "#{bot[:name]} : #{scores[index]}"
}
