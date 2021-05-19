class Position
    attr_reader :board, :turn

    DIM = 3
    SIZE = DIM*DIM

    def initialize(board=nil, turn="x")
        @board = board || Array(1..SIZE)
        @turn = turn
    end

    def move(idx)
        position = Position.new(@board.dup, xturn("o", "x"))
        position.board[idx] = turn
        position
    end

    def xturn(x, o)
        self.turn == "x" ? x : o
    end

    def possible_moves
        @board.map { |e| e if e.is_a?Integer }.compact
    end

    def win?(turn)
        rows = @board.each_slice(DIM).to_a
        rows.any? { |row| row.all? { |e| e == turn } } ||
        rows.transpose.any? { |col| col.all? { |e| e == turn } } ||
        rows.map.with_index.all? { |row, i| row[i] == turn } ||
        rows.map.with_index.all? { |row, i| row[DIM-1-i] == turn }
    end

    def minimax(depth=1)
        return 100 if win?("x")
        return -100 if win?("o")
        return 0 if possible_moves.empty?
        @@minimax ||= {}
        value = @@minimax[@board]
        return value if value
        @@minimax[@board] =
        possible_moves.map { |idx|
        move(idx-1).minimax(depth+1)
        }.send(xturn(:max, :min)) + xturn(-depth, depth)
    end

    def best_move
        possible_moves.send(xturn(:max_by, :min_by)) { |index| move(index-1).minimax }
    end
end
