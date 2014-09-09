module ApplicationHelper

  def markdown(text)
    render_options = {filter_html: true}
    renderer = Redcarpet::Render::HTML.new(render_options)

    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new( renderer, extensions)

    redcarpet.render(text).html_safe

  end
end
