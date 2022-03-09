class UsersRequest < AppRequest
  # before do
  # end

  group do
    # before do
    # end

    action :list do
      # @user = data.users.list
      @users = [
        {id: 1, name: "Leonardo"},
        {id: 2, name: "Raphael"},
        {id: 3, name: "Michaelangelo"},
        {id: 4, name: "Donatelo"},
      ]
    end

    action :search do
      # @user = data.users.where(name: @q)
      @users = [
        {id: 1, name: "Leonardo"}
      ]
    end

    action :creating do
      @user = {name: ''}
    end

    action :create do
      # if data.users.create(@user)
      #   notify :green, "Your user has been created successfully!"
      #   request(:users, :read, @user_id).path
      # else
      #   render :creating
      # end
    end

    action :updating do
      @users = [
        {id: 1, name: "Leonardo"},
        {id: 2, name: "Raphael"},
        {id: 3, name: "Michaelangelo"},
        {id: 4, name: "Donatelo"},
      ]
    end

    action :update do
      # if data.users.update(@users)
      #   notify :green, "Your user has been edited successfully!"
      #   request(:users, :read, @user_id).path
      # else
      #   render :updating
      # end
    end

    action :clearing do
      # @users_count = 5
    end

    action :clear do
      # if data.users.clear
      #   notify :green, "Your users have been cleared successfully!"
      #   request(:users, :list).path
      # else
      #   render :clearing
      # end
    end
  end

  group do
    before do
      # @user = data.users.find(@user_id)
      @user = {id: @user_id, name: "Turtle #{@user_id}"}
    end

    action :read do
    end

    action :editing do
    end

    action :edit do
      # if data.users.edit(@user_id, @user)
      #   notify :green, "Your user has been edited successfully!"
      #   request(:users, :read, @user_id).path
      # else
      #   render :editing
      # end
    end

    action :removing do
    end

    action :remove do
      # if data.users.remove
      #   notify :green, "Your user has been removed successfully!"
      #   request(:users, :list).path
      # else
      #   render :editing
      # end
    end
  end


  # Wrappers
  # wrapper :html, :erb, <<-CODE
  wrapper <<-CODE
    <div class="actions">
        Users:
        <%= link_to 'List',   web.request.users.list.path %> |
        <%= link_to 'Search', web.request.users.search.path %> |
        <%= link_to 'Create', web.request.users.create.path %> |
        <%= link_to 'Update', web.request.users.update.path %> |
        <%= link_to 'Clear',  web.request.users.clear.path %>
    </div>
    <div class="container">
        <div class="col-4">
            <!-- content :sidebar -->
            <%= content :sidebar %>
            <!-- /content :sidebar -->
        </div>
        <div class="col-8">
            <!-- yield -->
            <%= yield %>
            <!-- /yield -->
        </div>
    </div>
  CODE


  # Contents

  content :navbar, :html, :erb, <<-CODE
    <navbar>
        Navbar:
        <%= link_to 'Bread',  web.request.root.root.path %> |
        <%= link_to 'Crumb',  web.request.root.root.path %> |
        <%= link_to 'Crummy', web.request.root.root.path %> |
        <%= link_to 'Items',  web.request.root.root.path %> |
    </navbar>
  CODE

  # Templates

  template :list, :html, :erb, <<-CODE
<!-- content :navbar -->
    <%= content :navbar %>
<!-- /content :navbar -->

<h1>Listing <%= @users.count %> Users</h1>

<table border=1>
    <thead>
        <tr>
            <th>ID</th>

            <th>Name</th>

            <th colspan="4">Actions</th>
        </tr>
    </thead>
    <tbody>
        <% @users.each do |user| %>
            <tr>
                <td><%= user[:id] %></td>

                <td><%= user[:name] %></td>

                <td><%= link_to 'Show User',   web.request.users.read(user[:id]).path %></td>
                <td><%= link_to 'Edit User',   web.request.users.edit(user[:id]).path %></td>
                <td><%= link_to 'Remove User', web.request.users.remove(user[:id]).path %></td>
            </tr>
        <% end %>
    </tbody>
</table>
  CODE

  template :search, :html, :erb, <<-CODE
      <h1>Searching Users</h1>

      <table border=1>
          <thead>
              <tr>
                  <th>ID</th>

                  <th>Name</th>

                  <th colspan="4">Actions</th>
              </tr>
          </thead>
          <tbody>
              <% @users.each do |user| %>
                  <tr>
                      <td><%= user[:id] %></td>

                      <td><%= user[:name] %></td>

                      <td><%= link_to 'Show User',   web.request.users.read(user[:id]).path %></td>
                      <td><%= link_to 'Edit User',   web.request.users.edit(user[:id]).path %></td>
                      <td><%= link_to 'Remove User', web.request.users.remove(user[:id]).path %></td>
                  </tr>
              <% end %>
          </tbody>
      </table>

      <%= link_to 'List Users',   web.request.users.list.path %>
  CODE

  template :creating, :html, :erb, <<-CODE
    <h1>Create User</h1>

    <%= form_tag web.request.users.create.path %>
        <div>
            <input type="text" name="user[name]" value="<%= @user[:name] %>">
        </div>

        <div>
            <%= link_to 'List',   web.request.users.list.path %>
            <input type="submit" value="Create">
        </div>
    <%= end_tag :form %>
  CODE

  template :updating, :html, :erb, <<-CODE
    <h1>Update Users</h1>

    <%= form_tag web.request.users.update.path %>
        <% @users.each do |user| %>
            <div>
                Name: <input type="text" name="users[<%= user[:id] %>][name]" value="<%= user[:name] %>">

            </div>
        <% end %>

        <div>
            <%= link_to 'List',   web.request.users.list.path %>
            <input type="submit" value="Update">
        </div>
    <%= end_tag :form %>
  CODE

  template :clearing, :html, :erb, <<-CODE
    <h1>Clearing Users</h1>

    <p>
        You are about to clear <% @users_count %> users.
    </p>

    <p>
        Are you sure?
    </p>

    <%= form_tag web.request.users.clear.path %>
        <div>
            <%= link_to 'List',   web.request.users.list.path %>
            <input type="submit" value="Clear">
        </div>
    <%= end_tag :form %>
  CODE

  template :read, :html, :erb, <<-CODE
    <h1>User #<%= @user[:id] %></h1>

    <table border=1>
        <thead>
            <tr>
                <th colspan="3">Actions</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th>ID</th>
                <td><%= @user[:id] %></td>
            </tr>
            <tr>
                <th>Name</th>
                <td><%= @user[:name] %></td>
            </tr>
            <tr>
                <td rowspan="4">Actions</td>
            </tr>
            <tr>
                <td><%= link_to 'Show User',   web.request.users.read(@user[:id]).path %></td>
            </tr>
            <tr>
                <td><%= link_to 'Edit User',   web.request.users.edit(@user[:id]).path %></td>
            </tr>
            <tr>
                <td><%= link_to 'Remove User', web.request.users.remove(@user[:id]).path %></td>
            </tr>
        </tbody>
    </table>
    
    <%= link_to 'List Users',   web.request.users.list.path %>
  CODE

  template :editing, :html, :erb, <<-CODE
    <h1>Edit User #<%= @user[:id] %></h1>
    
    <%= form_tag web.request.users.edit(@user[:id]).path %>
        <div>
            <input type="text" name="user[name]" value="<%= @user[:name] %>">
        </div>

        <div>
            <%= link_to 'Show User',   web.request.users.read(@user[:id]).path %>
            <input type="submit" value="Edit">
        </div>
    <%= end_tag :form %>
  CODE

  template :removing, :html, :erb, <<-CODE
    <h1>Remove User #<%= @user[:id] %></h1>
    
    <%= form_tag web.request.users.remove(@user[:id]).path %>
        <div>
            <%= link_to 'Show User',   web.request.users.read(@user[:id]).path %>
            <input type="submit" value="Remove">
        </div>
    <%= end_tag :form %>
  CODE
end
