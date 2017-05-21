class ProjectionsController < ApplicationController
  def index
  end

  def calculate
  	@rand_arr = Array.new(params[:num_years_saving].to_i + params[:num_years_spending].to_i) {rand}
  	@cf_arr = Array.new(params[:num_years_saving].to_i, 12*params[:monthly_saving].to_i) + Array.new(params[:num_years_spending].to_i, -12*params[:monthly_spending].to_i)
  	@years_arr = *(1..(params[:num_years_saving].to_i + params[:num_years_spending].to_i))
  	puts @years_arr.zip(@cf_arr)
  	
  end
end
