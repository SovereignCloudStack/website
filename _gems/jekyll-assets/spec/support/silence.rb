# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

RSpec.configure do |c|
  c.before :each do
    allow(Jekyll::Assets::Logger).to receive(:colorize?).and_return(false)
    allow(Jekyll.logger.writer).to receive(:logdevice)
      .and_return(StringIO.new)
  end
end
