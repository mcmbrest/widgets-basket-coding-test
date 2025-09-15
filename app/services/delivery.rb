# frozen_string_literal: true

  class Delivery
    class Error < StandardError; end

    def initialize(basket:, provider:)
      @basket = basket
      @provider = provider
    end

    attr_reader :basket, :provider

    def calculate
      return 0 unless provider

      delivery_provider.new(basket:).calculate
    end

    private

    def delivery_provider
      case provider
      when 'pickup'
        DeliveryProviders::Pickup
      when 'default'
        DeliveryProviders::Default
      else
        raise Error, "Unknown delivery provider: #{provider}"
      end
    end
  end
