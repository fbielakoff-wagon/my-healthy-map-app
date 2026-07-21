module MessagesHelper
  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      filter_html: true # strips raw HTML the AI might echo back
    )
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      no_intra_emphasis: true
    )
    markdown.render(text.to_s).html_safe
  end
end
