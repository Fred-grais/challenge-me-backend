require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = FactoryBot.create(:project, challenges_needed_list: ['challenge1', 'challenge2'], activity_sector_list: ['sector1', 'sector2'])
  end

  test "should get index" do
    get projects_url, as: :json
    assert_response :success

    projects = Project.all.order(id: :asc)

    expected = [
        {
            "id"=>projects[0].id,
            "name"=>projects[0].name,
            "description"=>projects[0].description,
            "ownerPreview"=>{
                "id"=>projects[0].user.id,
                "position"=>projects[0].user.position,
                "firstName"=>projects[0].user.first_name,
                "lastName"=>projects[0].user.last_name
            }
        },
        {
            "id"=>projects[1].id,
            "name"=>projects[1].name,
            "description"=>projects[1].description,
            "ownerPreview"=>{
                "id"=>projects[1].user.id,
                "position"=>projects[1].user.position,
                "firstName"=>projects[1].user.first_name,
                "lastName"=>projects[1].user.last_name
            }
        },
        {
            "id"=>projects[2].id,
            "name"=>projects[2].name,
            "description"=>projects[2].description,
            "ownerPreview"=>{
                "id"=>projects[2].user.id,
                "position"=>projects[2].user.position,
                "firstName"=>projects[2].user.first_name,
                "lastName"=>projects[2].user.last_name
            }
        }
    ]

    assert_same_elements(expected, JSON.parse(@response.body))
  end

  test "should show project" do
    get project_url(@project), as: :json
    assert_response :success

    expected = {
        "id"=>@project.id,
        "name"=>@project.name,
        "description"=>@project.description,
        "activitySectorList"=>["sector2", "sector1"],
        "challengesNeededList"=>["challenge2", "challenge1"],
        "timeline" => {
            "items" => [
                {
                    "title"=>"Title",
                    "description"=>"Description",
                    "date"=>"10/10/2018",
                    "imageUrl"=>"imageUrl"
                }
            ]
        },
        "ownerFull"=>{
            "id"=>@project.user.id,
            "position"=>@project.user.position,
            "email"=>@project.user.email,
            "firstName"=>@project.user.first_name,
            "lastName"=>@project.user.last_name
        }
    }
    assert_equal(expected, JSON.parse(@response.body))
  end

end
