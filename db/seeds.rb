# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

creator = User.create({name: 'tank', email: 'tank7@mail.com'})
teams = Team.create([{name: '吃货'}])
creator.created_teams << teams

users = User.create([
                     {name: '掌柜', email: 'zhanggui@mail.com'},
                     {name: '大厨', email: 'dachu@mail.com'},
                     {name: '小勺', email: 'xiaoshao@mail.com'},
                     {name: '胖厨', email: 'panchu@mail.com'},
                     {name: '黑锅', email: 'heiguo@mail.com'}
                    ])

team = teams.first
team.members << users

project = creator.created_projects.create(team: team, name: '做好吃的')
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


# complete todo

todo = CreateTodoService.new(user: users[2],
                             project: project,
                             content: '烧火，配料'
                             ).call

CompleteTodoService.new(user: users[2],
                        todo: todo
                        ).call


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
