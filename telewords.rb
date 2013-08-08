#! /usr/bin/env ruby

# This is how this script is ran
# > ruby telewords.rb
# ^ Will run the default values, which are 1number.txt for the number file and words.txt for the dictionary file

# If you'd like to add other files, just put them after the script's filename
# > ruby telewords.rb FILE_NAME FILE_NAME
# Like the above, for instance with the attached files it would be
# > ruby telewords.rb numbers.txt numbers2.txt

# If you'd like to run with a specific dictionary, it MUST BE AT THE END OF THE COMMAND
# It's ran with a '-d' in front of the file name
# > ruby telewords.rb -d DICT_FILE
# This will run the default number file with your specified dictionary
# > ruby telewords.rb -d dict.txt

# To add them all together it would be like
# > ruby telewords.rb FILE_NAME FILE_NAME -d DICT_FILE
# Or....
# > ruby telewords.rb numbers.txt numbers2.txt -d dict.txt

# At the end, it will then output the answers to a file called "perm.txt"

require 'csv'

def open_options
  @number_files = []
  @number_file = "1number.txt"
  @dictionary_file = "words.txt"
  unless ARGV[0].nil?
    ARGV.each_with_index do |arg, index|
      argfollow = ARGV[index +1].to_s
      case arg
      when '-d'
        @dictionary_file = argfollow
        break
      else
        @number_files << arg
      end
    end
  end
end

def keypad
  {
    '0' => ['0'],
    '1' => ['1'],
    '2' => ['A', 'B', 'C'],
    '3' => ['D', 'E', 'F'],
    '4' => ['G', 'H', 'I'],
    '5' => ['J', 'K', 'L'],
    '6' => ['M', 'N', 'O'],
    '7' => ['P', 'Q', 'R', 'S'],
    '8' => ['T', 'U', 'V'],
    '9' => ['W', 'X', 'Y', 'Z']
  }
end

def keypad_return
  {
    '0' => '0', '1' => '1', 
    'A' => '2', 'B' => '2', 'C' => '2',
    'D' => '3', 'E' => '3', 'F' => '3',
    'G' => '4', 'H' => '4', 'I' => '4',
    'J' => '5', 'K' => '5', 'L' => '5',
    'M' => '6', 'N' => '6', 'O' => '6',
    'P' => '7', 'Q' => '7', 'R' => '7', 'S' => '7',
    'T' => '8', 'U' => '8', 'V' => '8',
    'W' => '9', 'X' => '9', 'Y' => '9', 'Z' => '9'
  }
end

def dictionary
  CSV.read(@dictionary_file).flatten.map(&:downcase).uniq
end

def numbers
  if @number_files.size > 0
    comb_num = []
    @number_files.each do |num_file|
      comb_num += CSV.read(num_file).flatten.map{|n| clean_numbers(n)}
    end
    return comb_num
  else
    CSV.read(@number_file).flatten.map{|n| clean_numbers(n)}
  end
end

def clean_numbers(number)
  number.gsub(/\D/, '').strip
end

def numbers_array(number)
  number.to_s.split(//)
end

def partitions(arr)
  (0...arr.length).flat_map{|i| (1...arr.length).to_a.combination(i).to_a }.map{|cut| i = -1; arr.slice_before{cut.include?(i += 1)}.to_a }
end

def permutations
  dict = dictionary
  numbers.collect do |phone_number|
    partit = partitions(numbers_array(phone_number))
    partit.map do |partition|
      partition.map do |numbers|
        numbers.map do |number|
          keypad[number]
        end.inject(&:product).map do |perms|
          numbers.one? ? perms : perms.join
        end.select do |word|
          dict.include?(word.downcase) || word.length == 1
        end.collect do |word|
          dict.include?(word.downcase) ? word: keypad.select{|k,v| v.include?(word)}.first[0]
        end
      end.inject(&:product).collect do |word_option|
        word_option.is_a?(Array) ? word_option.join('-') : word_option
      end
    end.reject(&:empty?).flatten.reject do |word_option|
      word_option.length < numbers_array(phone_number).length || word_option =~ /[0-9]-[0-9]/
    end.uniq
  end
end

def return_singles(arr)
  arr.each do |num|
    while ((num =~ /(^[A-Z](-)|(-)[A-Z]$|(-)[A-Z](-))/)) != nil do
      regex_place = (num =~ /(^[A-Z](-)|(-)[A-Z]$|(-)[A-Z](-))/)
      if regex_place
        regex_place = regex_place == 0 ? 0 : regex_place + 1
        if keypad_return[num[regex_place]]
          num[regex_place] = keypad_return[num[regex_place]]
        else
          break
        end
      end
    end
  end
end

open_options

puts "This takes a bit..."

permu = permutations.each{ |p| p.reject!{ |num| num =~ /(^[A-Z\d](-)[A-Z\d](-)|(-)[A-Z\d](-)[A-Z\d]$|(-)[A-Z\d](-)[A-Z\d](-))/ }}
permu.each{ |p | return_singles(p) }

File.open("perm.txt", 'w') do |line|
  permu.each_with_index do |phone_number, index|
    line.write(numbers[index])
    line.write("\n")
    line.puts(phone_number)
    line.write("\n")
  end
  puts "Done!"
end