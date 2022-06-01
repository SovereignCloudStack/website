# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Frontmatter" do
  let :asset do
    env.find_asset!("plugins/frontmatter")
  end

  describe "---" do
    it "strips frontmatter" do
      expect(asset.to_s).to(match(%r!^body\s*{!))
    end
  end
end
