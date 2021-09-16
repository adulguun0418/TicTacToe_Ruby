require 'dxruby'
require 'win32ole'

Window.width = 300
Window.height = 300

$x_icon = Image.load("x.png")
$o_icon = Image.load("o.png")

$turn = 0
$turn_count = 0

$board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]

$result = ""

WIN_COMBINATIONS = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [6, 4, 2],
      [0, 4, 8],
    ]

def draw_board
    Window.draw(100, 0, Image.new(1, 300, C_WHITE))
    Window.draw(200, 0, Image.new(1, 300, C_WHITE))
    Window.draw(0, 100, Image.new(300, 1, C_WHITE))
    Window.draw(0, 200, Image.new(300, 1, C_WHITE))
end

def get_mouse_input(x,y)
    x/100 + (y/100)*3
end

def position_taken?(input)
    $board[input] == "X" || $board[input] == "O"
  end

def valid_move?(input)
    input.between?(0, 8) && !position_taken?(input)
end

def won?
    WIN_COMBINATIONS.detect do |combo|
      $board[combo[0]] == $board[combo[1]] &&
      $board[combo[1]] == $board[combo[2]] &&
      position_taken?(combo[0])
    end
end

def full?
    $turn_count == 9
end

def draw?
    !won? && full?
end

def update_board
    for n in 0..8
        if $board[n]=='X'
            Window.draw((n%3)*100, (n/3)*100, $x_icon)
        elsif $board[n]=='O'
            Window.draw((n%3)*100, (n/3)*100, $o_icon)
        end
    end
end

Window.loop do
   draw_board

   if Input.mouse_push?(M_LBUTTON) 
      input = get_mouse_input(Input.mouse_pos_x, Input.mouse_pos_y)
      if $turn == 0 && valid_move?(input)
        $board[input] = "X"
        $turn_count += 1
        $turn = 1
      elsif $turn == 1 && valid_move?(input) 
        $board[input] = "O"
        $turn_count += 1
        $turn = 0
      end
   end

   update_board

   if won?
    if $turn == 1
        $result = "X wins"
    else
        $result = "O wins"
    end

    break;
   end

   if draw?
    $result = "Draw"
    break;
   end

end

 
wsh = WIN32OLE.new('WScript.Shell')
wsh.Popup("#{$result}")