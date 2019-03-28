# frozen_string_literal: true

# require 'test_helper'
#
# class Api::V1::Me::MessagesControllerTest < ActionDispatch::IntegrationTest
#   include ActionCable::TestHelper
#
#   context 'create' do
#
#     context 'Not Authenticated' do
#
#       should 'render an unauthorized error' do
#         post api_v1_me_messages_url
#
#         assert_response :unauthorized
#         assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
#       end
#     end
#
#     context 'Authenticated' do
#
#       context 'conversation does not exists' do
#         setup do
#           @user = FactoryBot.create(:user)
#           @params = {
#               message: {
#                   conversation_id: 1,
#                   message: 'Test'
#               }
#           }
#         end
#
#         should 'return the currently logged in user projects' do
#           authenticate_user(@user) do |authentication_headers|
#             post api_v1_me_messages_url, headers: authentication_headers, params: @params
#           end
#
#           assert_response :success
#           expected = {"success"=>false, "errors"=>["Conversation must exist"]}
#           assert_equal(expected, JSON.parse(@response.body))
#           assert_same_elements([], @user.reload.messages)
#         end
#       end
#
#       context 'conversation exists' do
#
#         context 'user is not recipient of the conversation' do
#           setup do
#             @user = FactoryBot.create(:user)
#             @conversation = FactoryBot.create(:conversation)
#             @params = {
#                 message: {
#                     conversation_id: @conversation.id,
#                     message: 'Test'
#                 }
#             }
#           end
#
#           should 'not create a new message and return the correct error' do
#             assert_no_difference 'Message.count' do
#               authenticate_user(@user) do |authentication_headers|
#                 post api_v1_me_messages_url, headers: authentication_headers, params: @params
#               end
#             end
#
#             assert_response :success
#             expected = {"success"=>false, "errors"=>["Not recipient #{@user.email} is not a recipient of the conversation #{@conversation.id}"]}
#             assert_equal(expected, JSON.parse(@response.body))
#             assert_same_elements([], @user.reload.messages)
#           end
#         end
#
#         context 'user is recipient of the conversation' do
#           setup do
#             @user = FactoryBot.create(:user)
#             @conversation = FactoryBot.create(:conversation, recipients: [@user.email, 'other@email.com'])
#             @params = {
#                 message: {
#                     conversation_id: @conversation.id,
#                     message: 'Test'
#                 }
#             }
#           end
#
#           should 'create a new message and return the correct response' do
#             now = Time.now.utc
#
#             Timecop.freeze(now) do
#               assert_broadcast_on(ConversationChannel.compute_name(@conversation.id), newMessage: {"senderId" => @user.id, "message" => @params[:message][:message], "createdAt" => now.as_json}) do
#
#                 assert_difference 'Message.count', +1 do
#                   authenticate_user(@user) do |authentication_headers|
#                     post api_v1_me_messages_url, headers: authentication_headers, params: @params
#                   end
#                 end
#               end
#             end
#
#             assert_response :success
#
#             last_message = Message.last
#
#             expected = {"success"=>true, 'message' => {
#                 'senderId' => last_message.sender_id,
#                 'message' => last_message.message,
#                 'createdAt' => last_message.created_at.as_json
#             }}
#             assert_equal(expected, JSON.parse(@response.body))
#             assert_same_elements([last_message], @user.reload.messages)
#           end
#
#         end
#       end
#     end
#   end
# end
