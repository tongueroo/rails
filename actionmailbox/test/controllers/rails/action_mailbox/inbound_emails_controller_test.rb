# frozen_string_literal: true

require "test_helper"

class Rails::Conductor::ActionMailbox::InboundEmailsControllerTest < ActionDispatch::IntegrationTest
  test "create inbound email" do
    with_rails_env("development") do
      assert_difference -> { ActionMailbox::InboundEmail.count }, +1 do
        post rails_conductor_inbound_emails_path, params: {
          mail: {
            from: "Jason Fried <jason@37signals.com>",
            to: "Replies <replies@example.com>",
            bcc: "",
            in_reply_to: "<4e6e35f5a38b4_479f13bb90078178@small-app-01.mail>",
            subject: "Discussion: Let's debate these attachments",
            body: "Let's talk about these images:",
            attachments: [fixture_file_upload("files/avatar1.jpeg"), fixture_file_upload("files/avatar2.jpeg")]
          }
        }
      end

      assert_equal 2, ActionMailbox::InboundEmail.last.mail.attachments.size
    end
  end

  private
    def with_rails_env(env)
      old_rails_env = Rails.env
      Rails.env = env
      yield
    ensure
      Rails.env = old_rails_env
    end
end
