require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  test '#owner_preview should return the correct data' do
    project = FactoryBot.create(:project)
    user = project.user

    assert_equal({"id"=>user.id, "first_name"=>user.first_name, "last_name"=>user.last_name, "position"=>user.position}, project.owner_preview)
  end

  test '#owner_full should return the correct data' do
    project = FactoryBot.create(:project)
    user = project.user

    assert_equal({"id"=>user.id, "first_name"=>user.first_name, "last_name"=>user.last_name, "position"=>user.position, "email"=>user.email}, project.owner_full)
  end

  test '#as_json, preview = true, for_front = true' do
    project = FactoryBot.create(:project)

    user = project.user
    expected = {
        "id"=>project.id,
        "name"=>project.name,
        "description"=>project.description,
        "ownerPreview"=>{
            "id"=>user.id,
            "position"=>user.position,
            "firstName"=>user.first_name,
            "lastName"=>user.last_name
        }
    }
    assert_equal(expected, project.as_json(preview: true, for_front: true))
  end

  test '#as_json, preview = false, for_front = true' do
    project = FactoryBot.create(:project)

    user = project.user
    expected = {
        "id"=>project.id,
        "name"=>project.name,
        "description"=>project.description,
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
            "id"=>user.id,
            "email"=>user.email,
            "position"=>user.position,
            "firstName"=>user.first_name,
            "lastName"=>user.last_name
        }
    }
    assert_equal(expected, project.as_json(preview: false, for_front: true))
  end

end
