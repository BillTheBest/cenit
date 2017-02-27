module RailsAdmin
  module Config
    Model.class_eval do

      register_instance_option :public_access? do
        Ability::CROSSING_MODELS_WITH_ORIGIN.include?(abstract_model.model) rescue false
      end

      Actions.all.each do |action|
        instance_eval "register_instance_option(:#{action.key}_template_name) { :#{action.key} }"
        instance_eval "register_instance_option(:#{action.key}_link_icon) { nil }"
      end

      register_instance_option :template_name do
        if (action = bindings[:action])
          send("#{action.key}_template_name")
        end
      end

      register_instance_option :show_in_dashboard do
        true
      end

      register_instance_option :label_navigation do
        label_plural
      end

      def contextualized_label(context = nil)
        label
      end

      def contextualized_label_plural(context = nil)
        label_plural
      end

      register_instance_option :extra_associations do
        []
      end
      register_instance_option :wizard_steps do
        {}
      end

      register_instance_option :current_step do
        0
      end
    end
  end
end
