require 'thor'
require 'search'

module Clr
  class Cli < Thor
    include Thor::Actions

    default_task :clean

    FORCE_PATTERNS  = [
      /\s*binding\.pry/,
      /\s*require .pry./,
    ]
    PATTERNS        = [
      /binding\.pry/,
      /require .pry./,
    ]

    desc "clean [PATH || Dir.pwd]", "Manager your debugging markers"
    method_option :comment, :type => :boolean, :aliases => "-c", :desc => 'comment all markers'
    method_option :uncomment, :type => :boolean, :aliases => "-u", :desc => 'uncomment all markers'
    method_option :remove, :type => :boolean, :aliases => "-r", :desc => 'remove all markers'
    method_option :search, :type => :boolean, :aliases => "-s", :desc => 'search markers'
    def clean(path = Dir.pwd)
      @path = Pathname.new(path)

      search_markers    if options[:search]
      comment_markers   if options[:comment]
      uncomment_markers if options[:uncomment]
      remove_markers    if options[:remove]
    end

    private

    def search_markers
      each_entry.summary do |filepath, markers|
        say_status :found, "#{markers} markers in #{filepath}"
      end
    end

    def comment_markers
      report = each_entry do |file, regexp|
        comment_lines file, regexp, :verbose => false
      end
      
      report.summary do |filepath, markers|
        say_status :commented, "#{markers} markers in file #{filepath}"
      end
    end

    def uncomment_markers(verbose = true)
      report = each_entry do |file, regexp|
        uncomment_lines file, regexp, :verbose => false
      end

      return nil unless verbose
      report.summary do |filepath, markers|
        say_status :uncommented, "#{markers} markers in file #{filepath}"
      end    
    end

    def remove_markers
      uncomment_markers(false)

      report = each_entry(FORCE_PATTERNS) do |file, regexp|
        gsub_file file, regexp, '', :verbose => false
      end

      report.summary do |filepath, markers|
        say_status :removed, "#{markers} markers from file #{filepath}"
      end      
    end

    def files_to_visit
      unless @path.exist?
        say_status(:error, "This path not exist: #{@path}", :red)
        exit
      end

      @files_to_visit ||= if @path.file?
        Array(@path)
      else
        files = Pathname.glob(@path.join('**/*'))
        files.reject { |path| path.directory? }
      end
    end

    def each_entry(patterns = PATTERNS)
      engine = Search.new

      files_to_visit.each do |file|
        patterns.each do |pattern|
          item = engine.perform file, pattern
          yield file, pattern if block_given? && item.matches_count > 0
        end
      end
      engine
    end

  end
end