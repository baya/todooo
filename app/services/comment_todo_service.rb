class CommentTodoService

  include TodoTransaction

  ACTION = 'comment_todo'.freeze

  def initialize(data = {})
    @user    = data[:user]
    @todo    = data[:todo]
    @content = data[:content]
    @project = @todo.project
    @team    = @project.team
  end

  def call
    transaction do
      comment = create_comment
      create_event(comment)

      comment
    end
  end
  

  private

  def create_comment
    Comment.create!(user: @user,
                    todo: @todo,
                    content: @content
                   )
  end

  def create_event(comment)
    Event.create!(user:     @user,
                  action:   ACTION,
                  team:     @team,
                  source:   comment,
                  resource: @project,
                  )
  end

end
