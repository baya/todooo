# -*- coding: utf-8 -*-
module TodoTransaction

  STATE  = Todo::STATE_MAP
  InvalidStateError = Class.new(StandardError)

  OP_MAP = {
    complete: '完成',
    assign:   '分配'
  }

  private

  def check_todo_state(op)
    op_name = OP_MAP.fetch(op)
    if @todo.deleted?
      raise InvalidStateError.new("不能 #{op_name} 处于删除状态的 todo")
    end
  end

  
  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

end
