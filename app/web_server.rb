class WebServer < Tio::WebServer
  domain 'tio.com'

  requests do
    request :root do
      route '', :root
      route 'about', :about
      route 'contact_us', :contact_us
      route 'favicon', :favicon
    end

    request :users do
      route '/users', :list
      route '/users/search', :search
      route '/users/create', :creating, :create
      route '/users/update', :updating, :update
      route '/users/clear',  :clearing, :clear
      route '/users/@user_id',        :read
      route '/users/@user_id/edit',   :editing,  :edit
      route '/users/@user_id/remove', :removing, :remove
    end

    # request :schools do
    #   route '/schools', :list
    #   route '/schools/search', :search
    #   route '/schools/create', :creating, :create
    #   route '/schools/update', :updating, :update
    #   route '/schools/clear',  :clearing, :clear
    #   route '/schools/@school_id',        :read
    #   route '/schools/@school_id/edit',   :editing,  :edit
    #   route '/schools/@school_id/remove', :removing, :remove
    # end

    # TODO: prefix
    # request :school_teachers do
    #   route '/schools/@school_id/teachers', :list
    #   route '/schools/@school_id/teachers/search', :search
    #   route '/schools/@school_id/teachers/create', :creating, :create
    #   route '/schools/@school_id/teachers/update', :updating, :update
    #   route '/schools/@school_id/teachers/clear',  :clearing, :clear
    #   route '/schools/@school_id/teachers/@teacher_id',        :read
    #   route '/schools/@school_id/teachers/@teacher_id/edit',   :editing,  :edit
    #   route '/schools/@school_id/teachers/@teacher_id/remove', :removing, :remove
    # end

    # request :school_classrooms do
    #   route '/schools/@school_id/classrooms', :list
    #   route '/schools/@school_id/classrooms/search', :search
    #   route '/schools/@school_id/classrooms/create', :creating, :create
    #   route '/schools/@school_id/classrooms/update', :updating, :update
    #   route '/schools/@school_id/classrooms/clear',  :clearing, :clear
    #   route '/schools/@school_id/classrooms/@classroom_id',        :read
    #   route '/schools/@school_id/classrooms/@classroom_id/edit',   :editing,  :edit
    #   route '/schools/@school_id/classrooms/@classroom_id/remove', :removing, :remove
    # end
  end
end
