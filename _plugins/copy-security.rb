#!/usr/bin/env ruby
require 'fileutils'

module Jekyll
  Jekyll::Hooks.register :site, :post_write do |site|
      src = File.join(site.dest, ".well-known/security.txt")
      dest = File.join(site.dest, "security.txt")
      puts "Copy " + src + " to " + dest
      FileUtils.copy(src, dest)
  end
end