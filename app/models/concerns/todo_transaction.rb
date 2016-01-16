module TodoTransaction

  STATE  = Todo::STATE_MAP
  InvalidStateError = Class.new(StandardError)

  private
  
  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

end
