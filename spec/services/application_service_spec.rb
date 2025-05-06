# spec/services/application_service_spec.rb
require 'rails_helper'

RSpec.describe ApplicationService do
  let(:dummy_service) do
    Class.new(ApplicationService) do
      def call
        success("Success payload")
      end
    end
  end

  describe "Response struct" do
    it "returns true for success? when success is true" do
      response = ApplicationService::Response.new(true, "payload", nil)
      expect(response.success?).to be true
      expect(response.failure?).to be false
    end

    it "returns true for failure? when success is false" do
      response = ApplicationService::Response.new(false, nil, "error")
      expect(response.success?).to be false
      expect(response.failure?).to be true
    end
  end

  describe ".call" do
    it "calls the service and returns a success response" do
      result = dummy_service.call
      expect(result.success?).to be true
      expect(result.payload).to eq("Success payload")
    end

    it "handles exceptions and returns a failure response" do
      failing_service = Class.new(ApplicationService) do
        def call
          raise StandardError, "Something went wrong"
        end
      end

      result = failing_service.call
      expect(result.success?).to be false
      expect(result.error).to be_a(StandardError)
      expect(result.error.message).to eq("Something went wrong")
    end
  end

  describe ".call!" do
    it "raises an exception when propagate is true" do
      failing_service = Class.new(ApplicationService) do
        def call
          raise StandardError, "Something went wrong"
        end
      end

      expect { failing_service.call! }.to raise_error(StandardError, "Something went wrong")
    end
  end

  describe "#success" do
    it "returns a success response with the given payload" do
      service = dummy_service.new
      response = service.success("Test payload")
      expect(response.success?).to be true
      expect(response.payload).to eq("Test payload")
    end
  end

  describe "#failure" do
    it "returns a failure response when propagate is false" do
      service = dummy_service.new(false)
      exception = StandardError.new("Test error")
      response = service.failure(exception)
      expect(response.success?).to be false
      expect(response.error).to eq(exception)
    end

    it "raises an exception when propagate is true" do
      service = dummy_service.new(true)
      exception = StandardError.new("Test error")
      expect { service.failure(exception) }.to raise_error(StandardError, "Test error")
    end
  end
end
