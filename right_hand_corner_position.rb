require 'pry'

class TypingTutor
  Reps = 10

  def initialize
    @score = 0
    @count = 0
  end

  def top_row_symbols
    @keys = %w(! @ # $ % ^ & *)
    self
  end

  def brackets
    @pairs = true
    @keys = [%w([ ]), %w({ }), %w(( ))]
    self
  end

  def top_left
    @keys = %w(- = \\ ` _ + | ~)
    self
  end

  def words
    @words ||= File.open('/usr/share/dict/words').readlines.map(&:strip).map(&:downcase).select{ |word| word.length < 10 }
  end

  def pick_a_word
    @word = words.sample
  end

  def say_it
    Thread.new { `say #{@word}` }
  end

  def wrap_a_word(q)
    # polymorphic way to do this?
    if @pairs
      [q.first, @word, q.last].join
    else
      [q, @word, q].join
    end
  end

  def next_question
    system('clear')
    pick_a_word
    @question = wrap_a_word(@keys.sample)
  end

  def prompt_question
    print "Score: #{@score}/#{@count}\t#{@question}\t" 
  end

  def take_user_down_a_peg
    Thread.new { `say nope` }
    puts "\anope! speak their names"
  end

  def receive_answer
    @answer = gets.strip
  end

  def hello
    puts "Welcome to the Woodshed"
    puts "use your middle and ring fingers for () [] {} <>"
    puts "use your Middle Finger EXCLUSIVELY for the symbols on the shifted number row, ^ right hand"
    print "press enter when ready...\t"

    gets
  end

  def correct?
    @question == @answer
  end

  def done
    puts "Congratulations! You got #{@score} out of #{@count} right"
  end

  def count_less_than_reps
    @count < Reps
  end

  def run
    hello
    next_question
    while count_less_than_reps
      begin
        prompt_question
        receive_answer
        if correct?
          @score += 1
          @count += 1
          next_question
        else 
          @count += 1
          take_user_down_a_peg
          redo unless !count_less_than_reps
        end
      end
    end
    done
  end
end

TypingTutor.new.top_row_symbols.run
