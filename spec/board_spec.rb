require 'spec_helper'

describe Board do
  let(:my_board_small) { Board.new([4, 5]) }
  let(:my_board_medium) { Board.new([10, 12]) }
  it 'creates a board of the correct size' do
    expect(my_board_small.length).to eql 5
    expect(my_board_small[0].length).to eql 4
    expect(my_board_medium.length).to eql 12
    expect(my_board_medium[0].length).to eql 10
  end

  it 'throws proper errors on bogus input' do
    expect { Board.new('j') }.to raise_error(ArgumentError)
    expect { Board.new(['j', 'k']) }.to raise_error(ArgumentError)
    expect { Board.new([3, 'j']) }.to raise_error(ArgumentError)
    expect { Board.new(['j', 4]) }.to raise_error(ArgumentError)
    expect { Board.new }.to raise_error(ArgumentError)
  end

  let(:board_default) { Board.new([2, 2]) }
  let(:board_toroidal) { Board.new([2, 2], :toroidal) }
  let(:board_dead) { Board.new([2, 2], :dead) }
  it 'sets the type of edge properly' do
    expect(board_default.edge).to eq :toroidal
    expect(board_toroidal.edge).to eq :toroidal
    expect(board_dead.edge).to eq :dead
    expect { Board.new([2, 2], :bogus) }.to raise_error(ArgumentError)
  end

  it 'is compromised of cells' do
    expect(my_board_small[2][2]).to be_instance_of Cell
  end

  let(:board_layout) { Board.new([4, 4], :toroidal, [[0, 0], [0, 3], [2, 3]]) }
  it 'takes a starting layout' do
    expect(board_layout[0][0].alive?).to be_true
    expect(board_layout[0][1].alive?).to be_false
    expect(board_layout[0][3].alive?).to be_true
    expect(board_layout[2][3].alive?).to be_true
  end

  it 'throws an error if a starting layout is bigger than the size of the board' do
    expect { Board.new([2,2], :toroidal, [9,9])}.to raise_error(ArgumentError)
    expect { Board.new([2,20], :toroidal, [3,2])}.to raise_error(ArgumentError)
    expect { Board.new([2,20], :toroidal, [1,25])}.to raise_error(ArgumentError)
  end

end
