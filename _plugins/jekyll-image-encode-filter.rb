module Jekyll::ImageEncodeFilter
  def base64(input)
    require 'base64'
    base64_image = ''
    if(File.exist?(input))
      base64_image =
        File.open(input, "rb") do |file|
          Base64.strict_encode64(file.read)
        end
    end
    "#{base64_image}"
  end
end

Liquid::Template.register_filter(Jekyll::ImageEncodeFilter)
