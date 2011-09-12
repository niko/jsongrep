require 'ostruct'
require 'rubygems'
require 'yajl'
require 'slop'

class JsonGrepper
  attr_accessor :data
  
  def initialize(json)
    @json     = json.strip
  end
  
  def data
    return @data = false if !@json || @json.empty?
    return @data unless @data.nil?
    @data = OpenStruct.new(Yajl::Parser.parse @json, :symbolize_keys => true)
  rescue Yajl::ParseError => e
    puts "JSON parsing error: #{e.message}" unless @silent
    @data = false
  end
  
  def random_sampling(random_sampling)
    return self if !random_sampling
    @json = rand(random_sampling) == 0 && @json
    self
  end
  
  def grep(grep)
    return self if !grep
    @json = @json.include?(grep) && @json
    self
  end
  
  def condition(condition)
    return self if data == false
    return self unless condition
    @data = false unless data.instance_eval(condition)
    self
  end
  
  def print(*fields)
    fields = [*fields].flatten.compact
    if fields == [:none]
      $stdout.print '.'
      return self
    end
    return self if data == false
    return (puts(@json) ; self) if (@json && (fields == [:all] || fields.empty?))
    return self unless data
    puts fields.map{ |field| "#{field}: #{data.send(field).inspect}" }.join('  ')
    self
  end
  
  def summarize(*fields)
    fields = [*fields].flatten.compact
    return self if fields.empty?
    return self if data == false
    fields.each do |field|
      value = data.send(field)
      self.class.sums[field] ||= {}
      self.class.sums[field][value] ||= 0
      self.class.sums[field][value] += 1
    end
  end
  
  class << self
    attr_writer :sums
    def sums
      @sums ||= {}
    end
    def reset_sums!
      @sums = {}
    end
    def summarize(random_sampling=nil)
      random_sampling ||= 1
      
      sums.each do |field, occurences|
        total = 0
        puts "\nSummary for #{field}:"
        puts "[#]       [#{field}]"
        occurences = occurences.sort_by{|k,v| k} rescue occurences
        occurences.each do |value,number|
          number *= random_sampling
          puts "#{number}#{' '*(10-number.to_s.size)}#{value}"
          total += number
        end
        puts "#{total}#{' '*(10-total.to_s.size)}total"
      end
    end
  end
end

# jsongrep -c 'self.d = (s = duration.to_i/(60*60)) > 0 && "#{s} h" || (m = duration.to_i/60) > 0 && "#{m} m" || "#{duration} s"' -f d,duration  ~/listeners.log

# JsonGrepper.new('{"duration":"1"}').grep(nil).condition('self.d = (s = duration.to_i/(60*60)) > 0 && "#{s} h" || (m = duration.to_i/60) > 0 && "#{m} m" || "#{duration} s"').print('d').summarize('d')