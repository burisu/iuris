class ToolsController < BackendController

  # Lists tools
  def index
  end

  def partition
    if params[:amount] and params[:amount].to_s.strip.size <= 12
      @amount = params[:amount].gsub(/\,/, '.').to_f
      decimals = @amount.to_s.gsub(/(^0*|0*$)/, '').split('.')[1].size rescue 0
      magnitude = 10 ** decimals
      integers = (@amount * magnitude).to_i
      partitions = []
      for x in 1..Math.sqrt(integers.to_f).ceil
        y = integers.to_f/x.to_f
        if (y.ceil == y)
          partitions << [x.to_i, y.to_f/magnitude]
        end
      end
      @partitions = (partitions + partitions.collect{|a| [(a[1]*magnitude).to_i, a[0].to_f/magnitude]}.reverse).uniq
    end
  end

  def delays
    params[:date] = params[:date].to_date rescue Date.today
    if deadline = params[:date].to_date
      dir = (params[:dir] == "since" ? 1 : -1)        
      if dir > 0
        deadline = deadline.next_year(params[:years].to_i)
        deadline = deadline.next_month(params[:months].to_i)
        deadline = deadline.next_day(params[:days].to_i)
      else
        deadline = deadline.prev_year(params[:years].to_i)
        deadline = deadline.prev_month(params[:months].to_i)
        deadline = deadline.prev_day(params[:days].to_i)
      end
      if request.xhr?
        render :partial => "deadline", :locals => {:deadline => deadline }
      else
        @deadline = deadline
      end
    end
  end

end
