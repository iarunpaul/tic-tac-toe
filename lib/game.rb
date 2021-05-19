# require "gosu"
require "./lib/position"

class Game
  attr_accessor :player1, :player2, :position

  def initialize(player1, player2, mode='n')
    @player1 = player1
    @player2 = player2
    @position = Position.new()
    @mode = mode
  end

  def self.game_startup
    puts "Lets play!!"
    puts "Type y if you want to play with computer(y/n): "
    mode = gets.chomp.downcase
    case mode
    when "y"
      print "Your Name: "
      player1 = gets.chomp
      player2 = "Computer"
      puts "which turn you would like to take (1/2)?"
      firstshot = gets.chomp.to_i
      player1, player2 = player2, player1 if firstshot == 2
      game = Game.new(player1, player2, 'y')
    when "n"
      print "Player1 Name: "
      player1 = gets.chomp
      print "Player2 Name: "
      player2 = gets.chomp
      game = Game.new(player1, player2)
    end
    game.display(game.position.board)
    game.game_on
  end

  def game_on
    player = position.xturn(player1, player2)
    if player == "Computer"
       puts comp_play
    else
      puts "#{player}: Enter your choice of index"
      index = gets.chomp.to_i
      puts play(index)
    end
    display(position.board)
    update
  end

  def play(index)
    return "invaild entry for index" unless position.possible_moves.include?index
    @position = position.move(index-1)
    return nil
  end

  def comp_play
    @position = position.move(position.best_move - 1)
    "computer played its best move"
  end

  def check_status
    return player1 if @position.win?("x")
    return player2 if @position.win?("o")
    return "draw!" if @position.possible_moves.empty?
    "continue"
  end

  def update
    case check_status
    when player1 then puts "#{player1} wins!!"
    when player2 then puts "#{player2} wins!!"
    when "draw!" then puts "its a stalemate!!"
    when "continue" then game_on
    end
  end

  def display(board)
    puts <<-HEREDOC
       #{board[0]} | #{board[1]} | #{board[2]}
      ---+---+---
       #{board[3]} | #{board[4]} | #{board[5]}
      ---+---+---
       #{board[6]} | #{board[7]} | #{board[8]}
    HEREDOC
  end

end
Game.game_startup
# puts "Enter the 1st player name"
# player1 = gets.chomp
# puts "the #{player1} uses x symbol"
# puts "Enter the 2nd player name"
# player2 = gets.chomp
# puts "the #{player2} uses o symbol"
# puts " "
# puts "Lets Begin!!"
# game.position = Position.new(['o', 'x', 'o', 'o', 'x', 'o', 'x', 'o', 9])
# game.display(game.position.board)
# puts game.check_status
# puts "Player1: Enter the index number to mark the move"
# index = gets.chomp.to_i
# game.play(index)
# game.display(game.position.board)
# puts game.position.xturn("#{player1} wins", "#{player2} wins")  if game.position.win?(game.position.turn)
# puts "Player2: Enter the index number to mark the move"
# index = gets.chomp.to_i
# game.play(index)
# game.display(game.position.board)
# puts game.position.xturn("#{player1} wins", "#{player2} wins")  if game.position.win?(game.position.turn)
# puts "Player1: Enter the index number to mark the move"
# index = gets.chomp.to_i
# game.play(index)
# game.display(game.position.board)
# puts game.position.xturn("#{player1} wins", "#{player2} wins")  if game.position.win?(game.position.turn)
# while true
#   puts ": Enter the index number to mark the move"
#   index = gets.chomp.to_i
#   game.play(index)
#   game.display(game.position.board)
#   puts game.position.xturn("#{player1} wins", "#{player2} wins")  if game.position.win?(game.position.turn)
#   puts "Draw!" if game.position.possible_moves.empty?
# end

# class Game < Gosu::Window
#   attr_accessor :width, :cell_width, :position
#   def initialize
#     @width = 600
#     @cell_width = @width/3
#     @position = Position.new
#     super(width, width, false)
#     @font = Gosu::Font.new(self, Gosu::default_font_name, @cell_width)
#     @mfont = Gosu::Font.new(self, Gosu::default_font_name, @cell_width/3)
#   end
#   def button_down(id)
#     case id
#     when Gosu::KbQ then close
#     when Gosu::MsLeft then
#       @position = @position.move((mouse_x/(@cell_width)).to_i + 3*(mouse_y/(@cell_width)).to_i)
#       if ! @position.possible_moves.empty? then
#         idx = @position.best_move
#         @position = @position.move(idx)
#       end
#     end
#   end
#   def needs_cursor?
#     true
#   end
#   def draw
#     # draw grid
#     [cell_width, cell_width * 2].each do |w|
#       draw_line(w, 0, Gosu::Color::WHITE, w, width, Gosu::Color::WHITE)
#       draw_line(0, w, Gosu::Color::WHITE, width, w, Gosu::Color::WHITE)
#     end

#     # draw position
#     position.board.each.with_index do |p,i|
#       if p != "-"
#         x = (i%3)*@cell_width + @font.text_width(p)/2
#         y = (i/3)*@cell_width
#         @font.draw_text(p, x, y, 0)
#       end
#     end

#     # display message
#     display_message("You won") if @position.win?("x")
#     display_message("Computer won") if @position.win?("o")
#     display_message("Draw") if @position.possible_moves.empty?
#   end
#   def display_message(txt)
#     black = Gosu::Color::BLACK
#     draw_quad(0,100,black,
#               width, 100, black,
#               width, 500, black,
#               0, 500, black)
#     @mfont.draw(txt, (width-@mfont.text_width(txt))/2, width/2 - 100, 0)
#   end
# end

# game = Game.new
# game.show
# game = Game.new("player1", "Computer", 'y')
# game.position = Position.new(['x', 'x', 'o', 'o', 'x', 'o', 7, 'o', 9])
# p game.position.move(game.position.best_move - 1)
