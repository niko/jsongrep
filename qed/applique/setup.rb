require 'yajl/json_gem'

$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), '../../lib')

require 'jsongrepper'


require 'stringio'
 
module AE::Assert
  alias :must :assert
  
  def equals(result)
    if result.is_a? String
      # we strip off the double-blanks at the beginning of each line:
      assert == result.split("\n").map{|l| l.gsub(/^  /,'')}.join("\n")
    else
      assert == result
    end
  end
  
  def output_of
    out = StringIO.new
    $stdout = out
    yield
    return out.string.strip
  ensure
    $stdout = STDOUT
  end
end
