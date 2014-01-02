require 'spec_helper'

describe Cell do
  let (:myboard) { double('brd', :neighbors => [double(Cell)]) }
  let (:cell1) { Cell.new(myboard) }
  let (:cell2) { Cell.new(myboard, alive: false) }
  let (:neighbor_possibilities) { [
      [Cell.new(myboard, alive: true), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false)],
      [Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false)],
      [Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false)],
      [Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false)],
      [Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false)],
      [Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: false), Cell.new(myboard, alive: false)],
      [Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: false)],
      [Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true), Cell.new(myboard, alive: true)],
  ] }

  it '.alive?' do
    expect(cell1.alive?).to eq(true)
    expect(cell2.alive?).to eq(false)
    #cell2.alive = true
    #expect(cell2.alive?).to eq(true)
  end
  
  it 'finds its neighbors' do
    expect(myboard).to receive('neighbors').with(cell1)
    cell1.get_neighbors
  end

  context 'with an already live cell' do
    it '.calculate_next_state' do
      allow(cell1).to receive(:get_neighbors).and_return(*neighbor_possibilities)
      expect(cell1.calculate_next_state).to eq(false)
      expect(cell1.calculate_next_state).to eq(true)
      expect(cell1.calculate_next_state).to eq(true)
      expect(cell1.calculate_next_state).to eq(false)
      expect(cell1.calculate_next_state).to eq(false)
      expect(cell1.calculate_next_state).to eq(false)
      expect(cell1.calculate_next_state).to eq(false)
      expect(cell1.calculate_next_state).to eq(false)
    end
  end
  context 'with an already deade cell' do
    it '.calculate_next_state' do
      allow(cell2).to receive(:get_neighbors).and_return(*neighbor_possibilities)
      expect(cell2.calculate_next_state).to eq(false)
      expect(cell2.calculate_next_state).to eq(false)
      expect(cell2.calculate_next_state).to eq(true)
      expect(cell2.calculate_next_state).to eq(false)
      expect(cell2.calculate_next_state).to eq(false)
      expect(cell2.calculate_next_state).to eq(false)
      expect(cell2.calculate_next_state).to eq(false)
      expect(cell2.calculate_next_state).to eq(false)
    end
  end

end
