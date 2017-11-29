class Users::RegistrationsController < Devise::RegistrationsController
  layout :resolve_layout

  private
  def resolve_layout
    case action_name
      when "edit", "update"
        "application"
      else
        "devise_layout"
    end
  end
end