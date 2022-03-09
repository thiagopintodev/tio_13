class RootRequest < AppRequest
  before do
    @this_ivar_is_added_to_all_actions = true
  end

  group do
    before do
      @this_ivar_is_added_to_all_actions_inside_the_group = true
    end

    action :root do
      @this_ivar_is_added_to_all_actions_inside_action_root = true
    end
  end

  action :about do
    @this_ivar_is_added_to_all_actions_inside_action_about = true
  end

  # TODO: 404 errors and public files
  action :favicon do
  end

  template :favicon, ""

  # TODO: auto load views from files
  template :root, File.read("app/web/requests/root_request.template.root.html.erb")
  template :about, File.read("app/web/requests/root_request.template.root.html.erb")
end
