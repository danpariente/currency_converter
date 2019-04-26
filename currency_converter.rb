#!/usr/bin/env ruby
# currency_converter.rb

class CurrencyConverter
  BASE_ABBR_AND_NAME = { "USD" => "US Dollar" }.freeze

  FULLNAME_OF = {
    "EUR" => "Euro",
    "CAD" => "Canadian Dollar",
    "CNY" => "Chinese Yuan",
    "INR" => "Indian Rupee",
    "MXN" => "Mexican Peso",
  }.freeze

  EXCHANGE_RATES = {
    "EUR" => 0.8981615044,
    "INR" => 70.1734731050,
    "CNY" => 6.7431979399,
    "MXN" => 19.0301253894,
    "CAD" => 1.3476847130,
  }

  attr_reader :base_currency, :name
  attr_accessor :output_format

  def initialize
    @base_currency, @name = BASE_ABBR_AND_NAME.flatten
    @output_format = CurrencyTextOutput.new(self)
  end

  def value(multiplier, abbr)
    multiplier * rates[abbr]
  end

  def output(multiplier: 1)
    output_format.render(multiplier)
  end

  def fullname_of
    FULLNAME_OF
  end

  def rates
    EXCHANGE_RATES
  end
end

class CurrencyTextOutput
  def initialize(converter)
    @converter = converter
  end

  def render(multiplier)
    @multiplier = multiplier
    formatted_base_currency + formatted_exchange_rates
  end

  private

  attr_accessor :multiplier

  def formatted_base_currency
    pluralized_base +
    " (#{@converter.base_currency}) = \n"
  end

  def formatted_exchange_rates
    @converter.rates.keys.map do |abbr|
      "\t" + pluralized_exchange(abbr) + "(#{abbr})"
    end.join("\n")
  end

  def pluralized_base
    pluralize(multiplier, @converter.name)
  end

  def pluralized_exchange(abbr)
    pluralize(@converter.value(multiplier, abbr), @converter.fullname_of[abbr])
  end

  def pluralize(number, term)
    "#{number} #{term}#{'s' if(number > 1)}"
  end
end

cc = CurrencyConverter.new
cc.output_format = CurrencyTextOutput.new(cc)
print cc.output(multiplier: 6100)
