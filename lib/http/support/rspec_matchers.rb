# frozen_string_literal: true

require "http"

module HTTP
  module Support
    module RspecMatches
      extend RSpec::Matchers::DSL

      STATUS_CODE_TO_SYMBOL = HTTP::Response::Status::REASONS
                              .transform_values do
        _1.gsub(/[- ]/, "_")
          .downcase.gsub(/[^a-z_]/, "")
          .to_sym
      end
      STATUS_SYMBOL_TO_CODE = STATUS_CODE_TO_SYMBOL.invert

      matcher :have_httprb_status do |_expected| # rubocop:disable Metrics/BlockLength
        def expected_code
          case expected
          when Integer then expected
          when :success, :successful then 200..299
          when :redirect then 300..399
          when :error then 500..599
          when Symbol
            STATUS_SYMBOL_TO_CODE.fetch(expected) { raise ArgumentError, "unknown symbol #{expected.inspect}" }
          else
            raise ArgumentError, "unknown expected value. Should be either a Integer or a symbol"
          end
        end

        match do |actual|
          @actual = actual

          return false if invalid_response_type_message

          case expected_code
          when Integer
            expected_code == actual.status.code
          when Range
            expected_code.cover?(actual.status.code)
          else
            raise "Unknown expected code #{expected_code}. Please report this as an issue"
          end
        end

        def invalid_response_type_message
          return if @actual.is_a? HTTP::Response

          "expected a HTTP::Response object, but an instance of " \
            "#{@actual.class} was received"
        end

        def status_code_to_name(code)
          STATUS_CODE_TO_SYMBOL.fetch(code, "unkown name")
        end

        def expected_type
          case expected_code
          when Range then "#{expected_code} code"
          else
            "#{expected_code} #{status_code_to_name(expected_code).inspect}"
          end
        end

        def actual_type
          "#{actual.status.code} #{status_code_to_name(actual.status.code).inspect}"
        end

        description do
          "respond with #{expected_type}"
        end

        def failure_message
          invalid_response_type_message ||
            "expected the response to have #{expected_type} but it was #{actual_type}"
        end

        def failure_message_when_negated
          invalid_response_type_message ||
            "expected the response not to have #{expected_type} but it was #{actual_type}"
        end
      end
    end
  end
end
