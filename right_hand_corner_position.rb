system('clear')

keys = %w(- = \\ ` _ + | ~)
def words
  @words ||= File.open('/usr/share/dict/words').readlines.map(&:strip).map(&:downcase)
end

def pick_a_word_and_say_it
  word = words.sample
  Thread.new { `say #{word}` }
  word
end

def wrap_a_word(q)
  q + pick_a_word_and_say_it + q
end

q = wrap_a_word(keys.sample)

loop do
  begin
    print "#{q}\t" 
    a = gets.strip
    if q == a
      system('clear')
      q = wrap_a_word(keys.sample)
    else
      Thread.new { `say nope` }
      puts "\anope! speak their names"
      redo
    end
  end
end
