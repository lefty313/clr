# require 'pry'
# binding.pry
class Foo
  def foo
    # [1,2,3].each { binding.pry }
  end

  def bar
    [1,2,3].each do |n|
      # binding.pry
    end
  end
end
# binding.pry