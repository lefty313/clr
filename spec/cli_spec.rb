require 'spec_helper'
require 'clr/cli'

describe Clr::Cli do
  context "-s" do
    it 'should exit unless path exist' do
      expect { command 'clean', 'file.not_exist', '-s' }.to raise_error SystemExit
    end

    it 'should find all markers in file' do
      in_temp_dir do
        copy_fixture
        result = command 'clean', 'app.rb', '-s'
        result.should =~ /found.* 5 markers in app.rb/
      end
    end

    it 'should find all markers in dir' do
      in_temp_dir do
        copy_fixture
        result = command 'clean','nested', '-s'
        result.should =~ /found.* 1 markers in nested\/deep\/foo\.rb/
      end
    end

    it 'should find all markers in current directory' do
      in_temp_dir do
        copy_fixture
        result = command 'clean','-s'
        result.should =~ /found.* 1 markers in .*nested\/deep\/foo\.rb/
        result.should =~ /found.* 5 markers in .*app.rb/
        result.lines.should have(2).items
      end
    end
  end

  context "-c" do
    it 'should comment markers in file' do
      in_temp_dir do
        copy_fixture
        result = command 'clean', 'app.rb','-c'

        File.read('app.rb').should == pattern_file('commented/app.rb')
        result.should =~ /commented.* 5 markers in file app.rb/
      end
    end
  end

  context "-u" do
    it 'should uncomment markers in file' do
      in_temp_dir do
        copy_fixture
        command 'clean', 'app.rb','-c'
        result = command 'clean', 'app.rb','-u'

        File.read('app.rb').should == pattern_file('uncommented/app.rb')
        result.should =~ /uncommented.* 5 markers in file app.rb/
      end
    end
  end

  context "-r" do
    it 'should remove markers from file' do
      in_temp_dir do
        copy_fixture
        result = command 'clean', 'app.rb', '-r'
        
        File.read('app.rb').should == pattern_file('removed/app.rb')
        result.should =~ /removed.* 5 markers from file app.rb/
      end
    end 
  end

end

def command(*args)
  capture(:stdout) { subject.class.start(args) }
end

def fixture
  root = Pathname.new(__FILE__)
  root.dirname.join('fixtures/app/.')
end

def pattern_file(path)
  root = Pathname.new(__FILE__)
  file = root.dirname.join("fixtures/pattern/#{path}")
  file.read
end

def copy_fixture
  FileUtils.cp_r fixture, Dir.pwd
end
