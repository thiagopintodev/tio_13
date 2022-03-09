class AppRequest < Tio::WebRequest
  def link_to(text, path)
    # fragment = ' class="active"' if web.request.users.send(@action_name).path == path
    fragment = nil
    %{<a href="#{path}"#{fragment}>#{text}</a>}
  end

  def end_tag(tag)
    %{</"#{tag}">}
  end

  def form_tag(path)
    %{<form action="#{path}">}
  end

  # def form_tag_b(path, &block)
  #   %{
  #     <form action="<%= path %>">
  #       <%= yield &block %>
  #     </form>
  #   }
  # end

  # <%= form_tag_b('/users/clear.html') do %>
  #     foo
  # <% end %>

  content :sidebar, :html, :erb, <<-CODE
    <sidebar>
        Sidebar:
        <%= link_to 'Home',       web.request.root.root.path %> |
        <%= link_to 'About',      web.request.root.root.path %> |
        <%= link_to 'Contact Us', web.request.root.root.path %> |
    </sidebar>
  CODE

end
