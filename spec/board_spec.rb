require 'spec_helper'

describe Board do
  let (:my_board_small) { Board.new([4,5]) }
  it 'creates a board of the correct size' do
    expect(my_board_small.length).to eql 5
    expect(my_board_small[0].length).to eql 4
  end
end
