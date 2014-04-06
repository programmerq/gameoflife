require 'spec_helper'

describe Board do
  let(:my_board_small) { Board.new([4,5]) }
  let(:my_board_medium) { Board.new([10,12]) }
  it 'creates a board of the correct size' do
    expect(my_board_small.length).to eql 5
    expect(my_board_small[0].length).to eql 4
    expect(my_board_medium.length).to eql 12
    expect(my_board_medium[0].length).to eql 10
  end
  it 'throws proper errors on bogus input' do
    expect{ Board.new('j') }.to raise_error(ArgumentError)
    expect{ Board.new(['j', 'k']) }.to raise_error(ArgumentError)
    expect{ Board.new([3, 'j']) }.to raise_error(ArgumentError)
    expect{ Board.new(['j', 4]) }.to raise_error(ArgumentError)
    expect{ Board.new }.to raise_error(ArgumentError)
  end

  let(:board_default) { Board.new([2,2]) }
  let(:board_toroidal) { Board.new([2,2], :toroidal) }
  let(:board_dead) { Board.new([2,2], :dead) }
  it 'sets the type of edge properly' do
    expect(board_default.edge).to eq :toroidal
    expect(board_toroidal.edge).to eq :toroidal
    expect(board_dead.edge).to eq :dead
    expect{ Board.new([2,2], :bogus) }.to raise_error(ArgumentError)
  end

  xit 'does not allow the edge type to change after the first turn'

  it 'is compromised of cells' do
    expect(my_board_small[2][2]).to be_instance_of Cell
  end

  xit 'takes a starting layout'

  xit 'throws an error if a starting layout is bigger than the size of the board'

end
