class ProjectionsController < ApplicationController
  def index
  end

  def calculate
  	# Convert Params to variables
  	rf = params[:rf].to_f
  	ret = params[:exp_ann_ret].to_f
  	vol = params[:exp_ann_vol].to_f
  	ny_sav = params[:num_years_saving].to_i
  	ny_sp = params[:num_years_spending].to_i
  	i_sav = params[:ini_saving].to_i
  	m_sav = params[:monthly_saving].to_i
  	m_sp = params[:monthly_spending].to_i
  	ns = params[:num_sim].to_i
  	y = Time.new.year

  	# generate an array with years
  	@years_arr = *(y..(y + ny_sav + ny_sp))

  	# generate the savings array / spending array
  	@sav_arr = [i_sav] + Array.new(ny_sav, 12 * m_sav) + Array.new(ny_sp, 0)
  	@sp_arr = [0] + Array.new(ny_sav, 0) + Array.new(ny_sp, - 12 * m_sp)

  	# generate the capital accumulation invested to the risk-free rate
  	@cap_acc_rf = Array.new(1 + ny_sav + ny_sp, 0)
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
	  	@cap_acc_inv = Array.new(1 + ny_sav + ny_sp, 0)
	  	@cap_acc_inv[0] = @sav_arr[0] + @sp_arr[0]
	  	@sim_arr_pos[0] = @sim_arr_pos[0] + 1
	  	for i in 1..(ny_sav + ny_sp)
	  		@cap_acc_inv[i] = (@cap_acc_inv[i-1] + @sav_arr[i] + @sp_arr[i]) * (1 + ((@cap_acc_inv[i-1] + @sav_arr[i] + @sp_arr[i]) > 0 ? @rnd_ret[i]/100 : 0))
	  		@sim_arr_pos[i] = @sim_arr_pos[i] + (@cap_acc_inv[i] > 0 ? 1 : 0)
	  	end
	  	@sim_arr[s] = @cap_acc_inv
	  end

	  @cap_acc_sim_avg = Array.new(1 + ny_sav + ny_sp, 0)
	  @cap_acc_sim_stdv = Array.new(1 + ny_sav + ny_sp, 0)
  	@cap_acc_sim_dwn = Array.new(1 + ny_sav + ny_sp, 0)
  	@cap_acc_sim_up = Array.new(1 + ny_sav + ny_sp, 0)
  	coef = 1.645
  	for i in 0..(ny_sav + ny_sp)
  		@cap_acc_sim_avg[i] = @sim_arr.transpose[i].mean
  		@cap_acc_sim_stdv[i] = @sim_arr.transpose[i].stdev
  		@cap_acc_sim_dwn[i] = @cap_acc_sim_avg[i] - coef * @cap_acc_sim_stdv[i]
  		@cap_acc_sim_up[i] = @cap_acc_sim_avg[i] + coef * @cap_acc_sim_stdv[i]
  		@sim_arr_pos[i] = @sim_arr_pos[i] / ns
  	end
  		  puts @sim_arr_pos  	
  end
end
