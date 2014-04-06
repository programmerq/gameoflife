class Board
  def initialize (size, edge=:toroidal, layout=[])
    @w, @h = size
    unless @w.kind_of? Integer and @h.kind_of? Integer
      raise ArgumentError.new 'size must be given in a [width, height] format, where width and heigh are both positive integers above 1'
    end
    @edge = edge
    unless [:dead, :toroidal].include? @edge
      raise ArgumentError.new 'edge must be one of :dead or :toroidal'
    end
    @rows = Array.new(@h) { |_| Array.new(@w) { |_| Cell.new(self, alive: false) } }
    layout.each do |x, y|
      if x.to_i > @w-1 or x.to_i > @h-1
        raise ArgumentError.new "starting cell position #{x}, #{y} is outside bounds. Board size: #{@w}, #{@h}"
      end
      self[x.to_i][y.to_i].alive=true
    end
  end
  def [](key)
    @rows[key]
  end
  def length
    @rows.length
  end
  def edge
    @edge
  end
end
