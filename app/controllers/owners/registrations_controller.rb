class Owners::RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:owner).permit(
      :name, :email, :password, :password_confirmation, :address1, :address2,
      :address3, :country, :county, :city, :town, :postcode, :telephone
    )
  end

  def account_update_params
    params.require(:owner).permit(
      :name, :email, :password, :password_confirmation, :current_password, :address1,
      :address2, :address3, :country, :county, :city, :town, :postcode, :telephone
    )
  end
end
