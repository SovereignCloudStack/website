#!/usr/bin/env ruby
require 'fileutils'

module Jekyll
  Jekyll::Hooks.register :site, :post_write do |post|
      FileUtils.cp("_site/.well-known/security.txt", "_site/security.txt")
  end
end
