class ProjectionsController < ApplicationController
  
  before_action :confirm_logged_in

  def inputs
  end

  def create
    session[:rf] = params[:rf]
    session[:exp_ann_ret] = params[:exp_ann_ret]
    session[:exp_ann_vol] = params[:exp_ann_vol]
    session[:num_years_saving] = params[:num_years_saving]
    session[:num_years_spending] = params[:num_years_spending]
    session[:ini_saving] = params[:ini_saving]
    session[:yearly_saving] = params[:yearly_saving]
    session[:yearly_spending] = params[:yearly_spending]
    session[:num_sim] = params[:num_sim]
    redirect_to(projections_calculate_path) 
  end

  def calculate
  	# Convert Params to variables
  	rf = session[:rf].to_f
  	ret = session[:exp_ann_ret].to_f
  	vol = session[:exp_ann_vol].to_f
  	ny_sav = session[:num_years_saving].to_i
  	ny_sp = session[:num_years_spending].to_i
  	i_sav = session[:ini_saving].to_f
  	y_sav = session[:yearly_saving].to_f
  	y_sp = session[:yearly_spending].to_f
  	ns = session[:num_sim].to_i
  	y = Time.new.year

  	# generate an array with years
  	@years_arr = *(y..(y + ny_sav + ny_sp))

  	# generate the savings array / spending array
  	@sav_arr = [i_sav] + Array.new(ny_sav, y_sav) + Array.new(ny_sp, 0)
  	@sp_arr = [0] + Array.new(ny_sav, 0) + Array.new(ny_sp, - y_sp)

  	# generate the capital accumulation invested to the risk-free rate
  	@cap_acc_rf = Array.new(1 + ny_sav + ny_sp, 0.0)
  	@cap_acc_rf[0] = @sav_arr[0] + @sp_arr[0]
  	for i in 1..(ny_sav + ny_sp)
  		@cap_acc_rf[i] = (@cap_acc_rf[i-1] + @sav_arr[i] + @sp_arr[i]) * (1 + rf/100)
  	end

  	@sim_arr = Array.new(ns)
  	@sim_arr_pos = Array.new(1 + ny_sav + ny_sp, 0.0)

  	for s in 0..ns-1
	  	# generate random returns normally distributed
	  	@rnd_ret = [0] + Array.new(ny_sav + ny_sp) {Distribution::Normal.p_value(rand) * vol + ret}
	  	# generate the capital accumulation invested to the random returns
	  	@cap_acc_inv = Array.new(1 + ny_sav + ny_sp, 0.0)
	  	@cap_acc_inv[0] = @sav_arr[0] + @sp_arr[0]
	  	@sim_arr_pos[0] = @sim_arr_pos[0] + 1
	  	for i in 1..(ny_sav + ny_sp)
	  		@cap_acc_inv[i] = @cap_acc_inv[i-1] * (1 + (@cap_acc_inv[i-1] > 0 ? @rnd_ret[i]/100 : 0)) + @sav_arr[i] + @sp_arr[i]
	  		@sim_arr_pos[i] = @sim_arr_pos[i] + (@cap_acc_inv[i] > 0 ? 1 : 0)
	  	end
	  	@sim_arr[s] = @cap_acc_inv
	  end

	  @cap_acc_sim_avg = Array.new(1 + ny_sav + ny_sp, 0.0)
	  @cap_acc_sim_stdv = Array.new(1 + ny_sav + ny_sp, 0.0)
  	@cap_acc_sim_dwn = Array.new(1 + ny_sav + ny_sp, 0.0)
  	@cap_acc_sim_up = Array.new(1 + ny_sav + ny_sp, 0.0)
  	coef = 1.645
  	for i in 0..(ny_sav + ny_sp)
      stats = DescriptiveStatistics::Stats.new(@sim_arr.transpose[i])
  		@cap_acc_sim_avg[i] = stats.mean.to_i
  		@cap_acc_sim_stdv[i] = stats.standard_deviation.to_i
  		@cap_acc_sim_dwn[i] = stats.value_from_percentile(5).to_i#@cap_acc_sim_avg[i] - coef * @cap_acc_sim_stdv[i]
  		@cap_acc_sim_up[i] = stats.value_from_percentile(95).to_i#@cap_acc_sim_avg[i] + coef * @cap_acc_sim_stdv[i]
  		@sim_arr_pos[i] = @sim_arr_pos[i] / ns
  	end

    @sims2chart =[{name: "sim1", data: @years_arr.zip(@sim_arr[0])}]
    for i in 1..[ns-1,19].min
      @sims2chart=@sims2chart.insert(0,{name: "sim"+(i+1).to_s, data: @years_arr.zip(@sim_arr[i])})
    end

  end
end
