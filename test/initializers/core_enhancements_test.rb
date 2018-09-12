require 'test_helper'

class ProjectTest < ActiveSupport::TestCase


  test 'String#to_lower_camelcase' do
    string = 'first_name'
    expected = 'firstName'

    assert_equal(expected, string.to_lower_camelcase)
  end


  test 'Hash#convert_keys_to_camelcase' do
    hash = {
        'first_name' => 'test',
        'lastName' => 'test',
        'sub_hash' => {
            'sub_hash_key' => 'test',
            'sub_sub_hash' => {
                'sub_sub_hash_key' => 'test'
            }
        }
    }

    expected = {
        'firstName' => 'test',
        'lastName' => 'test',
        'subHash' => {
            'subHashKey' => 'test',
            'subSubHash' => {
                'subSubHashKey' => 'test'
            }
        }
    }

    assert_equal(expected, hash.convert_keys_to_camelcase)
  end
end