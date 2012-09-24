module Clr
  class Search
    attr_reader :results

    class Item < Struct.new(:filepath, :pattern, :matches)
      def matches_count
        matches.count
      end
    end

    def initialize
      @results = Array.new
    end

    def perform(file, pattern)
      text    = file.binread
      matches = text.scan(pattern)
      item    = Item.new(file, pattern, matches)
      results.push(item).last
    end

    def summary
      results.group_by(&:filepath).each do |filepath, collection|
        # number of markers in file
        occurrences = collection.map(&:matches_count).inject(0,:+)

        yield filepath, occurrences, collection if occurrences > 0
      end
    end
  end
end