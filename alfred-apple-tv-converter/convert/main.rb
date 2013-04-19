# encoding: utf-8
($LOAD_PATH << File.expand_path("..", __FILE__)).uniq!
require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'bundle', 'bundler', 'setup'))
require 'alfred'
require 'shellwords'

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback

  arguments = ARGV.join(' ').strip.split(/\$+/).map { |a| a.strip.length == 0 ? nil : a.strip }.compact

  number_of_dirs = 0
  number_of_files = 0

  arguments_command_line = []

  arguments.each do |arg|
    if File.directory?(arg)
      arguments_command_line << %Q[-d "#{Shellwords.escape arg}"]
      number_of_dirs += 1
    end
    if File.file?(arg)
      arguments_command_line << %Q["#{Shellwords.escape arg}"]
      number_of_files += 1
    end
  end

  title = "Convert "

  if (number_of_dirs + number_of_files) == 1
    title << File.basename(arguments.first)
  else
    title << "#{number_of_dirs} #{number_of_dirs > 1 ? 'directories' : 'directory'} " if number_of_dirs > 0

    if number_of_files > 0
      title << "& " if number_of_dirs > 0
      title << "#{number_of_files} #{number_of_files > 1 ? 'files' : 'file'} "
    end
  end

  if number_of_files + number_of_dirs > 0
    fb.add_item({
      :uid      => "",
      :title    => title,
      :subtitle => "Simple conversion",
      :arg      => arguments_command_line.join(' '),
      :valid    => "yes",
    })

    fb.add_item({
      :uid      => "",
      :title    => title,
      :subtitle => "Convert and get metadata from IMDB",
      :arg      => (arguments_command_line + ['--imdb']).join(' '),
      :valid    => "yes",
    })
  else
    fb.add_item({
      :uid      => "",
      :title    => "Please choose some files/directories on Finder",
      :subtitle => "You can also use Path Finder",
      :arg      => '',
      :valid    => "no",
    })
  end

  puts fb.to_xml
end