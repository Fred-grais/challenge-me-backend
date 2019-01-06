require 'test_helper'

class Api::V1::Me::MessagesControllerTest < ActionDispatch::IntegrationTest

  context 'index' do

    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        get api_v1_me_conversations_url

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end
    end


    context 'Authenticated' do

      context 'conversation exists' do
        setup do
          @user = FactoryBot.create(:user)
          @convs = FactoryBot.create_list(:conversation_with_message, 3)

          @convs.each do |conv|
            conv.update(recipients: conv.recipients <<  @user.email)
          end
        end

        should 'return the currently logged in user conversations' do
          authenticate_user(@user) do |authentication_headers|
            get api_v1_me_conversations_url, headers: authentication_headers
          end

          assert_response :success

          message1 = @convs[0].messages.first
          message2 = @convs[1].messages.first
          message3 = @convs[2].messages.first
          expected = [{
            "id"=>@convs[0].id,
            "expandedRecipients"=> @convs[0].expanded_recipients.each(&:convert_keys_to_camelcase),
            "lastMessagePreview"=>message1.message
          },
          {
            "id"=>@convs[1].id,
            "expandedRecipients"=>@convs[1].expanded_recipients.each(&:convert_keys_to_camelcase),
            "lastMessagePreview"=>message2.message
          },
          {
            "id"=>@convs[2].id,
            "expandedRecipients"=>@convs[2].expanded_recipients.each(&:convert_keys_to_camelcase),
            "lastMessagePreview"=>message3.message
          }]

          assert_equal(HashDiff.diff(expected, JSON.parse(@response.body)), [])
        end
      end
    end
  end

  context 'show' do

    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        @conv = FactoryBot.create(:conversation_with_message)
        get api_v1_me_conversation_url(@conv.id)

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end
    end

    context 'Authenticated' do

      setup do
        @user = FactoryBot.create(:user)
        @conv = FactoryBot.create(:conversation_with_messages)

        @conv.recipients << @user.email
        @conv.save
      end

      should 'return the conversation json' do

        authenticate_user(@user) do |authentication_headers|
          get api_v1_me_conversation_url(@conv.id), headers: authentication_headers
        end

        assert_response :success

        conv_messages = @conv.messages.order(:created_at)
        response = JSON.parse(@response.body)

        assert_same_elements(['id', 'expandedRecipients', 'displayedMessages'], response.keys)

        expanded_recipients = @conv.expanded_recipients.as_json
        expanded_recipients.each(&:convert_keys_to_camelcase)

        assert_equal(@conv.id, response['id'])
        assert_same_elements( expanded_recipients, response['expandedRecipients'])
        assert_equal(
            [
                   {"senderId"=>conv_messages.first.sender_id, "message"=>conv_messages.first.message, "createdAt"=>conv_messages.first.created_at.as_json},
                   {"senderId"=>conv_messages.second.sender_id, "message"=>conv_messages.second.message, "createdAt"=>conv_messages.second.created_at.as_json},
                   {"senderId"=>conv_messages.third.sender_id, "message"=>conv_messages.third.message, "createdAt"=>conv_messages.third.created_at.as_json},
            ],
            response['displayedMessages']
        )
      end
    end
  end

  context 'create' do

    setup do
      @recipient = FactoryBot.create(:user)

      @params = {
          conversation: {
              recipients: [@recipient.email],
              message: 'first message'
          }
      }
    end
    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        post api_v1_me_conversations_url(@params)

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end
    end

    context 'Authenticated' do

      setup do
        @user = FactoryBot.create(:user)
      end

      should 'create a new conversation' do
        assert_difference 'Conversation.count', +1 do
          authenticate_user(@user) do |authentication_headers|
            post api_v1_me_conversations_url(@params), headers: authentication_headers
          end
        end

        assert_response :success

        conversation = Conversation.last
        expected = {
          "success"=>true,
          "preview"=>
            {
              "id"=>conversation.id,
              "expandedRecipients"=> conversation.expanded_recipients.each(&:convert_keys_to_camelcase),
              "lastMessagePreview"=>conversation.last_message_preview,
            },
          "full"=>
            {
              "id"=>conversation.id,
              "expandedRecipients"=> conversation.expanded_recipients.each(&:convert_keys_to_camelcase),
              "displayedMessages"=> conversation.displayed_messages.each(&:convert_keys_to_camelcase).as_json
            }
        }
        assert_equal([], HashDiff.diff(expected, JSON.parse(@response.body)))
      end

      should 'should not create a new conversation' do
        @user.conversations.create(recipients: [@recipient.email])

        assert_no_difference 'Conversation.count' do
          authenticate_user(@user) do |authentication_headers|
            post api_v1_me_conversations_url(@params), headers: authentication_headers
          end
        end

        assert_response :unprocessable_entity
        assert_equal({"success"=>false, "errors"=>["recipients"]}, JSON.parse(@response.body))
      end

      should 'expects the correct params' do
        authenticate_user(@user) do |authentication_headers|
          post api_v1_me_conversations_url({}), headers: authentication_headers
        end

        assert_response :unprocessable_entity
        assert_equal({"success"=>false, "errors"=>["param is missing or the value is empty: conversation"]}, JSON.parse(@response.body))

      end
    end

  end
end