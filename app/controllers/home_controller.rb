# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @cryptocurrencies = Cryptocurrency.all
    respond_to do |format|
       format.html
       format.json { render json: @cryptocurrencies }
       format.csv { send_data Cryptocurrency.to_csv, filename: "cryptocurrencies-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv"}
     end
  end

  def calculate
    annual_profit_usd
    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream
    end
  end

  private

  def calculator_params
    params.permit(:investment_value, :cryptocurrency_id)
  end

  def annual_profit_usd
    @annual_profit_usd ||= annual_profit_crypto * cryptocurrency.rate
  end

  def annual_profit_crypto
    @annual_profit_crypto ||= crypto_value * ((1 + ((cryptocurrency.monthly_rate.to_f / 100) / 12)) ** 12)
  end

  def crypto_value
    @crypto_value ||= calculator_params[:investment_value].to_i / cryptocurrency.rate
  end

  def cryptocurrency
    @cryptocurrency ||= Cryptocurrency.find(calculator_params[:cryptocurrency_id])
  end
end
