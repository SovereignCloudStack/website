# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      Hook.register :asset, :after_compression, priority: 3 do |i, o, t|
        next o unless t == "application/javascript"

        env = i[:environment]
        asset = env.find_asset!(i[:filename], pipeline: :source)
        path = asset.filename.sub(env.jekyll.in_source_dir + "/", "")
        url = SrcMap.map_path(asset: asset, env: env)
        url = env.prefix_url(url)

        <<~TXT
          #{o.strip}
          //# sourceMappingURL=#{url}
          //# sourceURL=#{path}
        TXT
      end
    end
  end
end
