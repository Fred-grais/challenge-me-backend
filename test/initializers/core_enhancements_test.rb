# frozen_string_literal: true

require "test_helper"

class CoreEnhancementsTest < ActiveSupport::TestCase
  test "String#to_lower_camelcase" do
    string = "first_name"
    expected = "firstName"

    assert_equal(expected, string.to_lower_camelcase)
  end


  test "Hash#convert_keys_to_camelcase" do
    hash = {
        "first_name" => "test",
        "lastName" => "test",
        "sub_hash" => {
            "sub_hash_key" => "test",
            "sub_sub_hash" => {
                "sub_sub_hash_key" => "test"
            }
        },
        "sub_array" => [
            {
                "sub_array_hash_key" => "test"
            }
        ]
    }

    expected = {
        "firstName" => "test",
        "lastName" => "test",
        "subHash" => {
            "subHashKey" => "test",
            "subSubHash" => {
                "subSubHashKey" => "test"
            }
        },
        "subArray" => [
            {
                "subArrayHashKey" => "test"
            }
        ]
    }

    assert_equal(expected, hash.convert_keys_to_camelcase)
  end

  test "Hash#convert_keys_to_underscore" do
    hash = {
      person: {
        name: "Francesco",
        age:  22,
        role: "admin"
      },
      testUnderscore: {
        nestedUnderscore: {
          underScoreTest: 1
        }
      },
      testUnderscoreArray: [
        {
          nestedUnderscoreHash: {
            underscoreTest: 1
          }
        }
      ]
    }

    expected = {
        "person" => {
            "name" => "Francesco",
            "age" => 22,
            "role" => "admin"
        },
        "test_underscore" => {
            "nested_underscore" => {
                "under_score_test" => 1
            }
        },
        "test_underscore_array" => [
            {
                "nested_underscore_hash" => {
                    "underscore_test" => 1
                }
            }
        ]
    }

    assert_equal(expected, hash.convert_keys_to_underscore)
  end

  test "ActionController::Parameters#convert_keys_to_underscore" do
    params = ActionController::Parameters.new(
      person: {
          name: "Francesco",
          age:  22,
          role: "admin"
      },
      testUnderscore: {
          nestedUnderscore: {
              underScoreTest: 1
          }
      }
                                              )

    expected = {
        "person" => {
          "name" => "Francesco",
          "age" => 22,
          "role" => "admin"
        },
        "test_underscore" => {
          "nested_underscore" => {
            "under_score_test" => 1
          }
        }
    }

    assert_equal(expected, params.convert_keys_to_underscore)
  end
end
