class ActiveRecordModel
  class << self
    attr_reader :table_name
  end

  attr_accessor :id, :name
end
