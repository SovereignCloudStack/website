# Plugin to add environment variables to the `site` object in Liquid templates

module Jekyll

  class EnvironmentVariablesGenerator < Generator

    def generate(site)
      site.config['github_sha'] = ENV['GITHUB_SHA']
      # Add other environment variables to `site.config` here...
    end

  end

end