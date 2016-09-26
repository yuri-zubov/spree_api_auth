module Spree
  module Api
    module V1
      UsersController.class_eval do

      before_action :authenticate_user, :except => [:sign_up, :sign_in, :login_check]

      def sign_up

        @user = Spree::User.find_by_email(params[:user][:email])

        if @user.present?
          render "spree/api/v1/users/user_exists", :status => 400 and return
        end

        @user = Spree::User.new(user_params)
        if !@user.save
          unauthorized
          return
        end
        @user.generate_spree_api_key!
      end

      def sign_in
        @user = Spree::User.find_by_email(params[:user][:email])
        if !@user.present? || !@user.valid_password?(params[:user][:password])
          unauthorized
          return
        end
        @user.generate_spree_api_key! if @user.spree_api_key.blank?
      end

      def login_check
        @user = Spree::User.find_by_email(params[:user][:email])
        if @user.present?
          render "spree/api/v1/users/email_busy", :status => 400 and return
        else
          render "spree/api/v1/users/email_free", :status => 200 and return
        end
      end

      def get_user
        @user = Spree::User.where(spree_api_key: request.headers['X-Spree-Token'])
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      end
    end
  end
end

