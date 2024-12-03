module Base
  def initialize(test_mode)
    @test_mode = test_mode
    load_data
  end

  def filename
    if @test_mode
      "sample.txt"
    else
      "data.txt"
    end
  end

  # Allow running the script from any working directory by building
  # the full file path relative to the class's source location.
  def file
    File.join(File.dirname(Object.const_source_location(self.class.name).first), filename)
  end
end
