require 'test_helper'

class Api::V1::Me::ProjectsControllerTest < ActionDispatch::IntegrationTest

  context 'index' do

    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        get api_v1_me_projects_url

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end

    end

    context 'Authenticated' do
      setup do
        @user = users(:one)
      end

      should 'return the currently logged in user projects' do
        authenticate_user(@user) do |authentication_headers|
          get api_v1_me_projects_url, headers: authentication_headers
        end

        assert_response :success
        projects = @user.projects
        expected = [
            {
                "id"=>projects[0].id,
                "name"=>projects[0].name,
                "description"=>projects[0].description,
                "ownerPreview"=>
                    {
                        "id"=>@user.id,
                        "position"=>@user.position,
                        "firstName"=>@user.first_name,
                        "lastName"=>@user.last_name,
                    }
            }
        ]
        assert_equal(expected, JSON.parse(@response.body))
      end
    end
  end

  context 'show' do
    setup do
      @user = users(:one)
      @project = FactoryBot.create(:project, user: @user)
    end

    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        get api_v1_me_project_url(@project)

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end

    end

    context 'Authenticated' do

      should 'returns the correct response' do
        authenticate_user(@user) do |authentication_headers|
          get api_v1_me_project_url(@project), headers: authentication_headers
        end

        assert_response :success
        expected = {
          "id"=>@project.id,
          "name"=>@project.name,
          "description"=>@project.description,
          "ownerFull"=>{
            "id"=>@user.id,
            "position"=>@user.position,
            "email"=>@user.email,
            "firstName"=>@user.first_name,
            "lastName"=>@user.last_name,
          }
        }
        assert_equal(expected, JSON.parse(@response.body))

      end
    end

  end

  context 'create' do

    setup do
      @user = users(:one)
      @params = {
          project: {
            name: 'Name',
            description: 'Description'
        }
      }
    end

    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        post api_v1_me_projects_url, params: @params

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end

    end

    context 'Authenticated' do

      should 'create a new project and return the correct response' do
        assert_difference('Project.count', 1) do
          authenticate_user(@user) do |authentication_headers|
            post api_v1_me_projects_url, params: @params, headers: authentication_headers
          end
        end

        assert_response :created
        project = Project.last
        expected = {
            "id"=>project.id,
            "name"=>project.name,
            "description"=>project.description,
            "ownerPreview"=>{
                "id"=>@user.id,
                "firstName"=>@user.first_name,
                "lastName"=>@user.last_name,
                "position"=>@user.position,
            }
        }
        assert_equal(expected, JSON.parse(@response.body))
      end


      context 'wrong params' do
        setup do
          @wrong_params = {
              project: {
                  name: @user.projects.last.name,
                  description: 'Description'
              }
          }
        end

        should 'not create a new project and return the correct error' do

          assert_difference('Project.count', 0) do
            authenticate_user(@user) do |authentication_headers|
              post api_v1_me_projects_url, params: @wrong_params, headers: authentication_headers
            end
          end

          assert_response :unprocessable_entity
          expected =  ["Name has already been taken"]
          assert_equal(expected, JSON.parse(@response.body))
        end
      end
    end

  end

  context 'update' do
    setup do
      @user = users(:one)
      @project = FactoryBot.create(:project, user: @user)

      @params = {
        project: {
          name: 'Updated Name',
          description: 'Updated Description'
        }
      }

    end

    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        put api_v1_me_project_url(@project), params: @params

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end

    end

    context 'Authenticated' do

      should 'update the correct project and return the correct response' do

        authenticate_user(@user) do |authentication_headers|
          put api_v1_me_project_url(@project), params: @params, headers: authentication_headers
        end

        assert_response :success
        @project.reload
        expected = {
            "id"=>@project.id,
            "name"=>@project.name,
            "description"=>@project.description,
            "ownerFull"=>{
                "id"=>@user.id,
                "position"=>@user.position,
                "email"=>@user.email,
                "firstName"=>@user.first_name,
                "lastName"=>@user.last_name,
            }
        }

        assert_equal(expected, JSON.parse(@response.body))

      end

      context 'wrong_params' do
        setup do
          @existing_project = FactoryBot.create(:project, user: @user)
          @wrong_params = {
              project: {
                  name: @existing_project.name,
                  description: 'Description'
              }
          }
        end

        should 'not update the project and return the correct error' do

          authenticate_user(@user) do |authentication_headers|
            put api_v1_me_project_url(@project), params: @wrong_params, headers: authentication_headers
          end

          assert_response :unprocessable_entity
          expected =  ["Name has already been taken"]
          assert_equal(expected, JSON.parse(@response.body))
        end

      end
    end

  end

  context 'destroy' do
    setup do
      @user = users(:one)
      @project = FactoryBot.create(:project, user: @user)
    end

    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        delete api_v1_me_project_url(@project)

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end

    end

    context 'Authenticated' do

      should 'destroy the project and return the correct response' do
        assert_difference('Project.count', -1) do
          authenticate_user(@user) do |authentication_headers|
            delete api_v1_me_project_url(@project), headers: authentication_headers
          end
        end

        assert_response :success

      end
    end
  end
end