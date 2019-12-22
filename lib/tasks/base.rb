class Tasks::Base
  def self.rescue_execute
    execute
  rescue => e
    ExceptionNotifier.notify_exception(e, :env => Rails.env, :data => {:message => "error"})
  end

  def self.execute
    raise 'need override!!'
  end
end