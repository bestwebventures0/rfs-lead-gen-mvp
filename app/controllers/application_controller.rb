class ApplicationController < ActionController::Base
    http_basic_authenticate_with name: 'lordgovinda',
                                password: '@lordGovinda108',
                               if: -> { Rails.env == 'staging' }
    
    def after_sign_in_path_for(user)
        if user.kind_of? User
            if user.advisors.blank?
                thankyou_path
            else
                dashboard_advisors_path
            end
        elsif user.kind_of? AdminUser
            '/admin'
        end
    end
end
