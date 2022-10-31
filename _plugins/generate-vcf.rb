#!/usr/bin/env ruby
require 'pathname'

module Jekyll
  class VCF < Document
    def initialize(document, dest)
      @data = document.data
      self.data['layout'] = "vcf"
      @renderer = Jekyll::Renderer.new(document.site, document)
      @output = self.renderer.run
      self.write(dest)
    end
    def destination(dest)
      path = Pathname.new(dest).sub_ext('.vcf')
    end
  end

  Jekyll::Hooks.register :employees, :post_write do |document|
    dest = Pathname.new(document.site.dest) + document.basename_without_ext
    vcf = VCF.new(document, dest)
  end
end
