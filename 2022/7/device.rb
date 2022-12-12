module Common
  attr_reader :files

  def initialize
    dir_hash = proc { |hash, key| hash[key] = Hash.new(&dir_hash) }
    @files = Hash.new(&dir_hash)
    current_dir = []

    File.foreach('input.txt', chomp: true) do |line|
      if line.start_with?('$')
        command = line.sub('$ ', '')

        case command
        when 'cd /'
          current_dir = []
        when 'cd ..'
          current_dir.pop
        when /^cd /
          dir = command.split(' ').last
          current_dir.push(dir)
        end
      else
        unless line.start_with?('dir')
          size, filename = line.split(' ')
          size = size.to_i
          dir = current_dir.empty? ? files : files.dig(*current_dir)
          dir[filename] = size
        end
      end
    end
  end

  def dir_size(dir)
    size = dir.sum do |_, val|
      case val
      when Hash
        dir_size(val)
      when Integer
        val
      end
    end

    post_process_dir_size(size)
    size
  end
end

class A
  include Common

  def run
    @total = 0
    dir_size(files)
    @total
  end

  def post_process_dir_size(size)
    @total += size if size <= 100_000
  end
end

class B
  include Common

  def run
    @sizes = []
    total_used = dir_size(files)
    amount_to_delete = total_used - 40_000_000

    @sizes.min_by do |size|
      size >= amount_to_delete ? size : Float::INFINITY
    end
  end

  def post_process_dir_size(size)
    @sizes << size
  end
end

pp A.new.run
pp B.new.run
# 1908462
# 3979145
