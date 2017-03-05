module Setup
  class Operation < Webhook
    include CustomTitle
    include RailsAdmin::Models::Setup::OperationAdmin
    build_in_data_type.including(:resource).referenced_by(:resource, :method)

    deny :all
    allow :show, :edit, :delete

    belongs_to :resource, class_name: Setup::Resource.to_s, inverse_of: :operations

    field :description, type: String
    field :method, type: String

    parameters :parameters, :headers

    validates_presence_of :resource, :method

    def params_stack
      super.insert(-2, resource)
    end

    def scope_title
      resource && resource.custom_title
    end

    def namespace
      (resource && resource.namespace) || ''
    end

    def path
      resource && resource.path
    end

    def template_parameters
      (resource && resource.template_parameters) || []
    end

    def name
      "#{method.to_s.upcase} #{resource && resource.custom_title}"
    end

    def label
      "#{method.to_s.upcase}"
    end

    def title
      label
    end
    
  end
end
