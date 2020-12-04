require 'pry'

class Game
  attr_accessor :board, :player_1, :player_2
  
  WIN_COMBINATIONS_GAME = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [6,4,2],
    ]
  
  def initialize(player_1 = Human.new("X"), player_2 = Human.new("O"),board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end
  
  def player_1
    @player_1
  end
  
  def player_2
    @player_2
  end
  
  def current_player
    @board.turn_count % 2 == 0 ? @player_1 : @player_2
  end
  
  def over?
    self.won?||self.draw?
  end
  
  def won?
    if self.winner == "X" || self.winner == "O"
      return true
    else
      return false
    end
  end
  
  def draw?
    !self.won? && !@board.cells.any?{ |x| x == " " || x == ""}
  end
  
  def winner
    WIN_COMBINATIONS_GAME.each do |x|
      win_index_1 = x[0]
      win_index_2 = x[1]
      win_index_3 = x[2]

      position_1 = @board.cells[win_index_1]
      position_2 = @board.cells[win_index_2]
      position_3 = @board.cells[win_index_3]
      
      if position_1 == "X" && position_2 == "X" && position_3 == "X"
        return "X"
      elsif position_1 == "O" && position_2 == "O" && position_3 == "O"
        return "O"
      end
    end
    return nil
  end
  
#turn method that displays both guide and board every iteration
  def turn
    puts "## GUIDE ##"
    @board.display_intro
    puts "#GAMEBOARD#"
    @board.display
    puts "#########"
    puts "It's #{self.current_player.token}'s turn. Please enter location: "
    x = self.current_player.move
    if @board.valid_move?(x)
      @board.update(x,current_player)
    else
      puts "Invalid move. Please try again"
      self.turn
    end
  end
  
#play method taht allows the turn method to run until the game is over
  def play
    while !self.over?
      self.turn
    end
    
    if self.won?
      puts "Congratulations #{self.winner} !"
      puts "########"
      @board.display
      puts "#GAME OVER#"
    elsif self.draw?
      puts "Cats Game!"
      puts "########"
      @board.display
      puts "#GAME OVER#"
    end 
  end
  
#reset the players as we start a new game
  def reset_game
    @players_1 = Human.new("X")
    @players_2 = Human.new("O")
  end
  
#again method to call at the end of each game
  def again?
    puts "DO you want to play a new game? (Y/N)"
    ans = gets.chomp
    if ans == "Y"
      self.reset_game
      self.start
    elsif ans == "N"
      puts "Okay then, have a nice day! Thanks fo playing."
    else 
      puts "Invalid answer. Answer with Y or N !"
      self.again?
    end
  end
  
#method taht is called for 2 human players
  def play_two_humans
    puts "Let's begin"
    self.play
    self.again?
  end
  
  def start
    puts "Welcome to Tic Tac Toe"
    self.play_two_humans
  end
  
end