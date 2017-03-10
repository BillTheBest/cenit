module RailsAdmin
  module Models
    module Setup
      module SharedNameAdmin
        extend ActiveSupport::Concern

        included do
          rails_admin do
            weight 880
            navigation_label 'Administration'
            visible { User.current_super_admin? }

            fields :name, :owners, :updated_at
          end
        end

      end
    end
  end
end
