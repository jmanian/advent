module Base
  def initialize(test_mode)
    @test_mode = test_mode
    load_data
  end

  def file
    if @test_mode
      "sample.txt"
    else
      "data.txt"
    end
  end
end
