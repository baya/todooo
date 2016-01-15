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
                     {name: '小勺', email: 'xiaoshao@mail.com'}
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
