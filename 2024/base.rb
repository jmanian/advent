module Base
  SAMPLE_FILENAME = "sample.txt".freeze
  ALT_SAMPLE_FILENAME = "sample_b.txt".freeze
  DATA_FILENAME = "data.txt".freeze

  def initialize(test_mode)
    @test_mode = test_mode
    load_data
  end

  def filename
    if @test_mode
      alt_sample? ? ALT_SAMPLE_FILENAME : SAMPLE_FILENAME
    else
      DATA_FILENAME
    end
  end

  def alt_sample?
    false
  end

  # Allow running the script from any working directory by building
  # the full file path relative to the class's source location.
  def file
    File.join(File.dirname(Object.const_source_location(self.class.name).first), filename)
  end
end
