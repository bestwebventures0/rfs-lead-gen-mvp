module SvgHelper
    SVGFileNotFoundError = Class.new(StandardError)

    def inline_svg_tag(path, options = {})
        path = Rails.root.join("app/assets/images/#{path}.svg")
        File.exist?(path) || raise(SVGFileNotFoundError, "SVG image file does not exist: #{path}")
        svg_file_content = File.binread(path)

        if options.any?
        doc = Nokogiri::XML::Document.parse(svg_file_content)
        svg = doc.at_css("svg")
        svg["height"] = options[:height] if options[:height]
        svg["width"] = options[:width] if options[:width]
        svg["class"] = options[:class] if options[:class]
        svg_file_content = doc.to_html.strip
        end

        raw svg_file_content
    end
end
