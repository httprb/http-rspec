# frozen_string_literal: true

require "spec_helper"

require "http/support/rspec_matchers"

RSpec.describe HTTP::Support::RspecMatchers do
  include described_class

  describe "have_httprb_status" do
    it "raises error if it gets unexpected argument" do
      matcher = have_httprb_status(200)

      expect(matcher.matches?("response")).to be(false)
      expect(matcher.failure_message)
        .to eq("expected a HTTP::Response object, but an instance of String was received")
    end

    it "works with description for 200 ok" do
      matcher = have_httprb_status(200)
      stub_request(:get, "https://nrk.no/").to_return(:status => 200)

      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(true)
      expect(matcher.description).to eq("respond with 200 :ok")
    end

    it "has reasonable failure message for 200 ok failure" do
      matcher = have_httprb_status(200)
      stub_request(:get, "https://nrk.no/").to_return(:status => 400)

      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(false)
      expect(matcher.failure_message)
        .to eq("expected the response to have 200 :ok but it was 400 :bad_request")
    end

    it "has reasonable description for negated 200 ok failure" do
      matcher = have_httprb_status(200)
      stub_request(:get, "https://nrk.no/").to_return(:status => 200)

      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(true)
      expect(matcher.failure_message_when_negated)
        .to eq("expected the response not to have 200 :ok but it was 200 :ok")
    end

    describe "convert symbol into code" do
      before do
        stub_request(:get, "https://nrk.no/").to_return(:status => 299)
      end

      let(:response) { HTTP.get("https://nrk.no") }

      it "raises for unknown symbol" do
        expect do
          matcher = have_httprb_status(:ruby)
          matcher.matches?(response)
        end
          .to raise_error(ArgumentError, "unknown symbol :ruby")
      end

      it "raises for wrong type" do
        expect do
          matcher = have_httprb_status("Coty")
          matcher.matches?(response)
        end
          .to raise_error(ArgumentError, "unknown expected value. Should be " \
                                         "either a Integer or a symbol")
      end

      it "can take :continue and convert in into 100" do
        matcher = have_httprb_status(:continue)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 100 :continue but/)
      end

      it "can take :switching_protocols and convert in into 101" do
        matcher = have_httprb_status(:switching_protocols)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 101 :switching_protocols but/)
      end

      it "can take :ok and convert in into 200" do
        matcher = have_httprb_status(:ok)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 200 :ok but/)
      end

      it "can take :created and convert in into 201" do
        matcher = have_httprb_status(:created)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 201 :created but/)
      end

      it "can take :non_authoritative_information and convert in into 203" do
        matcher = have_httprb_status(:non_authoritative_information)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 203 :non_authoritative_information but/)
      end

      it "can take :multi_status and convert in into 207" do
        matcher = have_httprb_status(:multi_status)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 207 :multi_status but/)
      end

      it "can take :not_found and convert in into 404" do
        matcher = have_httprb_status(:not_found)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 404 :not_found but/)
      end

      it "can take :uri_too_long and convert in into 414" do
        matcher = have_httprb_status(:uri_too_long)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 414 :uri_too_long but/)
      end

      it "can take :internal_server_error and convert in into 500" do
        matcher = have_httprb_status(:internal_server_error)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 500 :internal_server_error but/)
      end

      it "can take :gateway_timeout and convert in into 504" do
        matcher = have_httprb_status(:gateway_timeout)
        expect(matcher.matches?(response)).to be(false)
        expect(matcher.failure_message)
          .to match(/expected the response to have 504 :gateway_timeout but/)
      end
    end

    %i[success successful].each do |success_name|
      it "accepts #{success_name} for all 2xx codes" do
        matcher = have_httprb_status(success_name)

        stub_request(:get, "https://nrk.no/").to_return(:status => 200)
        response = HTTP.get("https://nrk.no")
        expect(matcher.matches?(response)).to be(true)

        stub_request(:get, "https://nrk.no/").to_return(:status => 201)
        response = HTTP.get("https://nrk.no")
        expect(matcher.matches?(response)).to be(true)

        stub_request(:get, "https://nrk.no/").to_return(:status => 210)
        response = HTTP.get("https://nrk.no")
        expect(matcher.matches?(response)).to be(true)

        stub_request(:get, "https://nrk.no/").to_return(:status => 400)
        response = HTTP.get("https://nrk.no")
        expect(matcher.matches?(response)).to be(false)

        expect(matcher.failure_message)
          .to eq("expected the response to have 200..299 code but it was 400 :bad_request")
      end
    end

    it "accepts :redirect for all 3xx codes" do
      matcher = have_httprb_status(:redirect)

      stub_request(:get, "https://nrk.no/").to_return(:status => 300)
      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(true)

      stub_request(:get, "https://nrk.no/").to_return(:status => 301)
      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(true)

      stub_request(:get, "https://nrk.no/").to_return(:status => 310)
      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(true)

      stub_request(:get, "https://nrk.no/").to_return(:status => 400)
      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(false)

      expect(matcher.failure_message)
        .to eq("expected the response to have 300..399 code but it was 400 :bad_request")
    end

    it "accepts :error for all 5xx codes" do
      matcher = have_httprb_status(:error)

      stub_request(:get, "https://nrk.no/").to_return(:status => 500)
      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(true)

      stub_request(:get, "https://nrk.no/").to_return(:status => 501)
      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(true)

      stub_request(:get, "https://nrk.no/").to_return(:status => 510)
      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(true)

      stub_request(:get, "https://nrk.no/").to_return(:status => 400)
      response = HTTP.get("https://nrk.no")
      expect(matcher.matches?(response)).to be(false)

      expect(matcher.failure_message)
        .to eq("expected the response to have 500..599 code but it was 400 :bad_request")
    end
  end
end
