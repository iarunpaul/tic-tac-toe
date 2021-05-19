require './lib/position'
require './lib/game'

RSpec.describe 'Tests for Class Game' do
	describe Game do
		subject {Game.new(player1, player2)}
		let(:player1) { 'player1' }
		let(:player2) { 'player2' }

		context '#initialize' do
			describe 'when Game instance instanciates' do
				it "expects the player to player1 and a default position object" do
					expect(subject.player1).to eq('player1')
					expect(subject.player2).to eq('player2')
					expect(subject.position.board).to eq(Array(1..9))
					expect(subject.position.turn).to eq('x')
				end
			end
		end

		context '#play' do
			describe 'when Game instance plays its move' do
				it "expects the position board changes and turn toggles" do
					expect(subject.play(2)).to eq(subject.position)
					expect(subject.position.board).to eq([1, 'x', 3, 4, 5, 6, 7, 8, 9])
					expect(subject.position.turn).to eq('o')
				end
			end

			describe 'when Game instance plays with invalid index' do
				it "expects the error message" do
					expect(subject.play("x")).to include('invaild entry for index')
					expect(subject.position.turn).to eq('x')
				end
			end

			# describe '#play' do
			# 	context 'when Game instance plays its move' do
			# 		# game = Game.new('player1')
			# 		# game.position.board = %w(- x - - - - - - -)
			# 		# game.position.turn = 'o'
			# 		subject.play(1).play(2)

			# 		it "expects the position board changes and turn toggles" do
			# 			expect(subject.play(1)).to eq(subject.position)
			# 			expect(subject.position).to eq([1, 'x', 3, 4, 5, 6, 7, 8, 9])
			# 			expect(subject.position.turn).to eq('o')
			# 			expect(game.play(0)).to include("invaild entry for index")
			# 		end
			# 	end

			# end
		end

		describe "#check_status" do
			subject = Game.new('player1', 'player2')

			context "when x wins" do
				subject.position = Position.new(['x', 'x', 'x', 4, 5, 6, 7, 8, 9])

				it { expect(subject.check_status).to eq(subject.player1) }
			end

			context "when o wins" do
				subject.position = Position.new(['o', 'o', 'o', 4, 5, 6, 7, 8, 9])

				it { expect(subject.check_status).to eq(subject.player2) }
			end

			context "when draw" do
				subject.position = Position.new(['o', 'o', 'x', 'x', 'x', 'o', 'o', 'o', 'x'])

				it { expect(subject.check_status).to include('draw') }
			end

			context "when game not over" do
				subject.position = Position.new(['o', 'o', 'x', 4, 5, 6, 7, 8, 9])

				it { expect(subject.check_status).to include('continue') }
			end
		end
	end
end