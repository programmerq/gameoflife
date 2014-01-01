require 'spec_helper'

describe Cell do
  let (:cell1) { Cell.new() }
  it 'creates a cell instance' do
    expect(cell1.alive?).to eq(true)
  end
end
