require_relative '../lib/position'
require 'timeout'

RSpec.describe "Class Position Tests" do
  describe Position do
    context "when Postion object instantiates" do
      subject { Position.new(board, turn) }
      let(:board) { Array(1..9) }
      let(:turn) { "x" }

      it "checks object variables `board` and `turn`" do
        expect(subject.board).to eq(Array(1..9))
        expect(subject.turn).to eq("x")
      end
    end

    context "when Postion object instantiates with no arguments" do
      subject { Position.new }

      it "ensures object variable `board` is Array(1..9) and `turn` is x" do
        expect(subject.board).to eq(Array(1..9))
        expect(subject.turn).to eq("x")
      end
    end

    context "when Postion object makes a move" do
      subject { Position.new(board, turn).move(idx) }
      let(:board) { Array(1..9) }
      let(:turn) { "o" }
      let(:idx) { 3 }

      it "gives back a new Position object with board index updated" do
        expect(subject).to be_instance_of(Position)
        expect(subject.board).to eq([1, 2, 3, "o", 5, 6, 7, 8, 9])
      end
    end

    context "checks the possible moves left" do
      subject { Position.new.move(0).move(1) }

      it "gives back a array of possible moves' indices" do
        expect(subject.possible_moves).to eq(Array(3..9))
      end
    end
    describe "#win?"  do
      subject { Position.new(board, turn) }

      context "x turn all first row xxx" do
        let(:board) { (%w(x x x
                          4 5 6
                          7 8 9)) }
        let(:turn) { "x" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "o turn all first row ooo" do
        let(:board) { ['o', 'o', 'o',
                        4,   5,   6,
                        7,   8,   9] }
        let(:turn) { "o" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "x turn all 2nd row xxx" do
        let(:board) { (%w(- - -
                          x x x
                          - - -)) }
        let(:turn) { "x" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "o turn all 2nd row ooo" do
        let(:board) { (%w(- - -
                          o o o
                          - - -)) }
        let(:turn) { "o" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "x turn all 3rd row xxx" do
        let(:board) { (%w(- - -
                          - - -
                          x x x)) }
        let(:turn) { "x" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "o turn all 3rd row ooo" do
        let(:board) { (%w(- - -
                          - - -
                          o o o)) }
        let(:turn) { "o" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "x turn all first col xxx" do
        let(:board) { (%w(x - -
                          x - -
                          x - -)) }
        let(:turn) { "x" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "o turn all first col ooo" do
        let(:board) { (%w(o - -
                          o - -
                          o - -)) }
        let(:turn) { "o" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "x turn all 2nd col xxx" do
        let(:board) { (%w(- x -
                          - x -
                          - x -)) }
        let(:turn) { "x" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "o turn all 2nd col ooo" do
        let(:board) { (%w(- o -
                          - o -
                          - o -)) }
        let(:turn) { "o" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "o turn all ooo on major diagonal" do
        let(:board) { (%w(o - -
                          - o -
                          - - o)) }
        let(:turn) { "o" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "x turn all major diagonal" do
        let(:board) { (%w(x - -
                          - x -
                          - - x)) }
        let(:turn) { "x" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "x turn all minor diagonal" do
        let(:board) { (%w(- - x
                          - x -
                          x - -)) }
        let(:turn) { "x" }

        it { expect(subject.win?(turn)).to be_truthy }
      end

      context "o turn all minor diagonal" do
        let(:board) { (%w(- - o
                          - o -
                          o - -)) }
        let(:turn) { "o" }

        it { expect(subject.win?(turn)).to be_truthy }
      end
    end

    describe '#minimax algorithm' do
      subject { Position.new(board, turn='x') }

      context "examples from github" do
        it { expect(Position.new(['o', 'o', 3, 4, 5, 6, 7, 8, 9], "o").minimax).to eq(-99) }

        it { expect{ timeout(2) { Position.new.minimax } }.not_to raise_error }
      end

      context 'when x wins' do
        let(:board) { ['x', 'x', 'x', 4, 5, 'o', 7, 8, 'o'] }

        it 'returns 100' do
          expect(subject.minimax).to eq(100)
        end
      end

      context 'when o wins' do
        let(:board) { ['o', 2, 'x', 4, 'o', 'x', 7, 8, 'o'] }
        let(:turn) { 'o' }

        it 'returns -100' do
          expect(subject.minimax).to eq(-100)
        end
      end

      context 'when no possible moves' do
        let(:board) { %w( x o x
                          o o x
                          o x o ) }

        it 'returns 0' do
          expect(subject.minimax).to eq(0)
        end
      end

      context 'when one move away from win for x' do
        let(:board) { ['x', 2, 3, 4, 'x', 6, 7, 8, 9] }
        let(:turn) { 'x' }

        it 'returns 99' do
          expect(subject.minimax).to eq(99)
        end
      end

      context 'when one move away from win for o' do
        let(:board) { ['o', 'o', 3, 4, 5, 6, 7, 8, 9] }
        let(:turn) { 'o' }

        it 'returns -99' do
          expect(subject.minimax).to eq(-99)
        end
      end
    end

    describe "#best_move" do
      subject { Position.new( board, turn) }

      context "moves the best move for x" do
        let(:board) { ['x', 'x', 3, 4, 5, 6, 7, 8, 9] }
        let(:turn) { "x" }

        it "expects the best move index to be returned" do
          expect(subject.best_move).to eq(3)
        end
      end

      context "moves the best move for o" do
        let(:board) { [1, 'o', 3, 4, 5, 'x', 7, 8, 'o'] }
        let(:turn) { "o" }

        it "expects the best move index to be returned" do
          expect(subject.best_move).to eq(5)
        end
      end
    end
  end
end