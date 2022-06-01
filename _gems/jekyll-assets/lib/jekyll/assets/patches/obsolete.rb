# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module ObsoleteFiles

        # --
        # @param [Object] args whatever Jekyll takes.
        # Gives a list of files that should be removed, unless used.
        # @return [Array<String>]
        # --
        def obsolete_files(*args)
          extras = Utils.manifest_files(site.sprockets)
          extras.concat(raw_compiles.flatten.uniq)

          super(*args).reject do |v|
            v == site.sprockets.in_dest_dir ||
            v == site.sprockets.manifest.filename ||
            extras.include?(v)
          end
        end

        def raw_compiles
          site.sprockets.raw_precompiles.map do |v|
            [v[:full_destination], v[:full_destination].dirname]
          end
        end
      end
    end
  end
end

# --
module Jekyll
  class Cleaner
    prepend Jekyll::Assets::Patches::ObsoleteFiles
  end
end
