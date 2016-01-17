# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

creator = User.create({name: 'tank', email: 'tank7@mail.com'})

# create team
team = CreateTeamService.new(user: creator, name: '吃货').call

users = User.create([
                     {name: '掌柜', email: 'zhanggui@mail.com'},
                     {name: '大厨', email: 'dachu@mail.com'},
                     {name: '小勺', email: 'xiaoshao@mail.com'},
                     {name: '胖厨', email: 'panchu@mail.com'},
                     {name: '黑锅', email: 'heiguo@mail.com'}
                    ])

team.members << users

# create project
h_project = CreateProjectService.new(user: users[4],
                                   team: team,
                                   name: '胡吃海喝').call

project = CreateProjectService.new(user: users[0],
                                   team: team,
                                   name: '做好吃的').call
project.members << users


# create todo

CreateTodoService.new(user: users[0],
                      project: project,
                      content: '辣椒炒肉'
                      ).call

# delete todo

todo = CreateTodoService.new(user: users[1],
                             project: project,
                             content: '洗菜，洗锅，切菜'
                             ).call

DeleteTodoService.new(user: users[2],
                      todo: todo
                      ).call

# 插入其他项目的 todo

service = CreateTodoService.new(user: users[0],
                                project: h_project,
                                content: '好酒好肉伺候'
                                )

h_todo = service.call
event = service.event
todo.created_at = todo.updated_at = DateTime.now + 5.minutes
event.created_at = event.updated_at = DateTime.now + 5.minutes
todo.save
event.save



# complete todo 打乱时间

service = CreateTodoService.new(user: users[2],
                             project: project,
                             content: '烧火，配料'
                             )

todo = service.call
event = service.event

todo.created_at = todo.updated_at = DateTime.now + 10.minutes
event.created_at = event.updated_at = DateTime.now + 10.minutes
todo.save
event.save


service = CompleteTodoService.new(user: users[2],
                        todo: todo
                        )

service.call
event = service.event

event.created_at = event.updated_at = DateTime.now + 15.minutes
todo.save
event.save


service = DeleteTodoService.new(user: users[2],
                                todo: h_todo
                                )
service.call
event = service.event
event.created_at = event.updated_at = DateTime.now + 7.minutes
event.save


# assign todo

todo = CreateTodoService.new(user: users[3],
                             project: project,
                             content: '试吃'
                             ).call

AssignTodoService.new(user: users[3],
                      assigned_user: users[4],
                      todo: todo
                      ).call


# edit assign todo

todo = CreateTodoService.new(user: users[4],
                             project: project,
                             content: '掌握火候'
                             ).call


AssignTodoService.new(user: users[4],
                      assigned_user: users[1],
                      todo: todo
                      ).call


EditAssignTodoService.new(user: users[0],
                          new_assigned_user: users[3],
                          todo: todo
                          ).call

# edit todo deadlines

todo = CreateTodoService.new(user: users[0],
                             project: project,
                             content: '铺好桌子，摆好餐具'
                             ).call


AssignTodoService.new(user: users[1],
                      assigned_user: users[4],
                      todo: todo
                      ).call

deadlines = (DateTime.now + 1.day).strftime('%Y-%m-%d')
EditTodoDeadlinesService.new(user: users[1],
                          todo: todo,
                          new_deadlines: deadlines
                          ).call


deadlines = (DateTime.now + 3.day).strftime('%Y-%m-%d')
EditTodoDeadlinesService.new(user: users[2],
                          todo: todo,
                          new_deadlines: deadlines
                          ).call


# comment todo

todo = CreateTodoService.new(user: users[0],
                             project: project,
                             content: '红烧狮子头'
                             ).call


CommentTodoService.new(user: users[1],
                       todo: todo,
                       project: project,
                       content: '我先去弄头狮子'
                       ).call


# 昨天的 todo

service = CreateTodoService.new(user: users[2],
                                project: project,
                                content: '剁椒鱼头'
                                )

todo = service.call
event = service.event
todo.created_at = todo.updated_at = DateTime.now - 1.day
todo.save
event.created_at = event.updated_at = DateTime.now - 1.day
event.save


# 前天的 events

service = CreateProjectService.new(user: users[3],
                                   team: team,
                                   name: '能吃是福'
                                   )

project = service.call
event = service.event

project.created_at = project.updated_at = DateTime.now - 2.days
event.created_at = event.updated_at = DateTime.now - 2.days
project.save
event.save

service = CreateTodoService.new(user: users[3],
                                project: project,
                                content: '蒸蛋'
                                )
todo = service.call
event = service.event
todo.created_at = todo.updated_at = DateTime.now - 2.day
todo.save
event.created_at = event.updated_at = DateTime.now - 2.day
event.save
