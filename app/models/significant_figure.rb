class SignificantFigure
  private attr_reader :number

  def initialize(number)
    # TODO: Possible source of inaccurate counts
    @number = number.finite? ? number : 0
  end

  def rounded
    if number < 100
      number.floor(-1)
    else
      number.floor(-2)
    end
  end
end
