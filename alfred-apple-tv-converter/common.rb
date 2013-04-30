($LOAD_PATH << File.expand_path("..", __FILE__)).uniq!
require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require File.expand_path(File.join(File.dirname(__FILE__), 'bundle', 'bundler', 'setup'))
require 'yaml'
require 'alfred'
require 'shellwords'
require 'apple_tv_converter'

def check_prerequisites
  raise 'FFMPEG not found. Please install it.' unless !(`which ffmpeg` || '').empty? || File.exists?("/usr/local/bin/ffmpeg")
  raise 'RVM not found. Please install it.' unless !(`which rvm` || '').empty? || (File.exists?("/usr/local/rvm") || File.exists?(File.expand_path('~/.rvm')))
end

def with_redirected_output(file_name)
  redirect_output(File.open(File.join(cache_dir, file_name), 'w+')) { yield if block_given? }
end

def redirect_output(stream)
  orig_std_out = STDOUT.clone
  begin
    STDOUT.reopen(stream)
    yield if block_given?
  rescue => e
    begin
      puts "---| ERROR |---"
      puts "--- #{e.message}"
      e.backtrace.each { |l| puts "- #{l}" }
    rescue
    end
  ensure
    STDOUT.reopen(orig_std_out)
  end
end

def with_captured_output(process)
  return_value = nil
  reader, writer = IO.pipe
  internal_reader, internal_writer = IO.pipe

  fork do
    reader.close
    internal_reader.close

    redirect_output(writer) do
      return_value = process.call
      internal_writer.write return_value
      internal_writer.close
    end
  end

  writer.close
  internal_writer.close

  while message = reader.gets(100)
    begin
      yield message
    rescue Interrupt
      clear_status
      raise
    end
  end

  internal_reader.read
end

def write_status(status)
  File.open(File.join(cache_dir, 'status.yml'), 'w') { |f| f.puts status.to_yaml }
end

def read_status
  YAML.load_file(File.join(cache_dir, 'status.yml')) rescue { :in_progress => false }
end

def clear_status
  File.delete(File.join(cache_dir, 'status.yml')) if File.exists?(File.join(cache_dir, 'status.yml'))
end

def cleanup
  Dir[File.join(cache_dir, '*ffmpeg*')].each { |f| File.delete(f) }
  File.delete File.join(cache_dir, 'status.yml') if File.exists?(File.join(cache_dir, 'status.yml'))
end

def cache_dir
  @cache_dir ||= Alfred::Core.new.volatile_storage_path
end