module EventsHelper

  def show_missing_partial(e)
    e.message[0..(e.message.index(',') - 1)]
  end
  
end
