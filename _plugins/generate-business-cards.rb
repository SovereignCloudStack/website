#!/usr/bin/env ruby
require 'pathname'
require 'rqrcode'
require 'fileutils'

module Jekyll
  class BusinessCard < Document
    def initialize(document, dest)
      @data = document.data
      self.data['layout'] = "other/business_card/front"
      @renderer = Jekyll::Renderer.new(document.site, document)
      # Create QR Code
      qr = RQRCode::QRCode.new(document.site.config['url'] + "/" + document.basename_without_ext, size: 5)
      svg = qr.as_svg(
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 1,
        standalone: false,
        use_path: true
      )
      self.data['qrcode'] = svg
      @output = self.renderer.run
      self.write(dest)
    end
    def destination(dest)
      path = Pathname.new(dest) + "front.svg"
    end
  end

  Jekyll::Hooks.register :employees, :post_write do |document|
    dest = Pathname.new(document.site.dest) + document.collection.label + document.basename_without_ext
    card = BusinessCard.new(document, dest)
    # Also copy the back of the business card
    src = "_layouts/other/business_card/back.html"
    dest = Pathname.new(document.site.dest) + document.collection.label + document.basename_without_ext + "back.svg"
    FileUtils.copy(src, dest)
  end
end
