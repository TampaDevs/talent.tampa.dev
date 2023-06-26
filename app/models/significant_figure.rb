class SignificantFigure
  private attr_reader :number

  def initialize(number)
    # TODO: Possible source of inaccurate counts
    @number = number.finite? ? number : 0
  end

  def rounded
    if number < 100
      if number < 10
        number.floor
      else
        number.floor(-1)
      end
    else
      number.floor(-2)
    end
  end
end
