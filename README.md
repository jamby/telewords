# Telewords
=========

Change a list of telephone numbers to potential words from a dictionary.

=========

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
