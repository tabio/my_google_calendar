# frozen_string_literal: true

require 'my_google_calendar/version'
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

module MyGoogleCalendar
  class MyGoogleCalendarError < StandardError; end
  class InvalidDateTime < StandardError; end

  class Utility
    class << self
      def parse_datetime(str)
        raise InvalidDateTime unless str.match?(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/)

        begin
          # rfc3339形式とする
          datetime = DateTime.parse("#{str} JST")
        rescue ArgumentError
          raise InvalidDateTime
        end

        raise InvalidDateTime unless datetime.is_a?(DateTime)

        datetime
      end
    end
  end

  class MyAuth
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    SCOPE   = 'https://www.googleapis.com/auth/calendar'

    class << self
      def credentials(client_secret_file_path, token_file_path, google_user_id, code = nil)
        check_files(client_secret_file_path, token_file_path)

        client_id   = Google::Auth::ClientId.from_file(client_secret_file_path)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: token_file_path)
        authorizer  = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)

        credentials = authorizer.get_credentials(google_user_id)

        case
        when credentials.nil?
          if code.nil?
            url = authorizer.get_authorization_url(base_url: OOB_URI)
            raise "ブラウザより以下のURLを開いてtoken(code)を取得して呼び出し直して下さい\n#{url}"
          else
            authorizer.get_and_store_credentials_from_code(user_id: google_user_id, code: code, base_url: OOB_URI)
          end
        else
          credentials
        end
      rescue MultiJson::ParseError
        raise MyGoogleCalendarError, 'client secret fileの形式(json)を確認して下さい'
      rescue => e
        raise MyGoogleCalendarError, e.message
      end

      private

      def check_files(client_secret_file_path, token_file_path)
        raise MyGoogleCalendarError, 'client secret file が存在しません(https://console.cloud.google.com/apisよりDL)' unless File.exist?(client_secret_file_path)
        raise MyGoogleCalendarError, 'token file が存在しません' unless File.exist?(token_file_path)
      end
    end
  end

  class Calendar
    class << self
      def register!(credentials, calendar_id, summary, start_at, end_at, app_name = 'my_google_calendar_app')
        service = Google::Apis::CalendarV3::CalendarService.new
        service.client_options.application_name = app_name
        service.authorization = credentials

        parsed_start_at = Utility.parse_datetime(start_at)
        parsed_end_at   = Utility.parse_datetime(end_at)

        raise MyGoogleCalendarError, '開始日と終了日を確認して下さい' if parsed_start_at > parsed_end_at

        event_params = {
          summary: summary,
          start: { date_time: parsed_start_at.to_s },
          end: { date_time: parsed_end_at.to_s }
        }

        event = Google::Apis::CalendarV3::Event.new(event_params)
        res   = service.insert_event(calendar_id, event)

        raise 'APIレスポンスエラー' if res.status != 'confirmed'

        true
      rescue Google::Apis::ServerError, Google::Apis::ClientError, Google::Apis::AuthorizationError
        raise MyGoogleCalendarError, 'Google::Apis APIエラーが発生しました'
      rescue InvalidDateTime
        raise MyGoogleCalendarError, '入力された日付に誤りがあります'
      rescue => e
        raise MyGoogleCalendarError, e.message
      end
    end
  end
end
