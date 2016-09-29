module Spree
  module Api
    module V1

      UsersController.class_eval do
        before_action :authenticate_user, :except => [:sign_up, :sign_in, :email_availability_check]

        def update_preferences
          @user = Spree::User.where(spree_api_key: request.headers['X-Spree-Token']).first
          byebug
          if @user.update_attribute(:preferences, params[:user][:preferences])
            respond_with(@user, :status => 200, :default_template => :show)
          else
            invalid_resource!(user)
          end
        end

        def update
          authorize! :update, user

          if user.update_attributes(user_params)
            respond_with(user, :status => 200, :default_template => :show)
          else
            invalid_resource!(user)
          end
        end

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

        def email_availability_check
          @user = Spree::User.find_by_email(params[:user][:email])

          unless params[:user].has_key?(:email)
            render inline: "", :status => 400 and return
          end

          if @user.present?
            render "spree/api/v1/users/email_unavailable", :status => 400 and return
          else
            render "spree/api/v1/users/email_available", :status => 200 and return
          end
        end

        def get_user
          @user = Spree::User.where(spree_api_key: request.headers['X-Spree-Token'])
        end

        def user_params
          params.require(:user).permit(:email, :password, :password_confirmation, :preferences)
        end
      end
    end
  end
end
