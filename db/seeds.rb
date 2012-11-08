# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = ComponentType.create(name: "建築本體")
  ComponentType.create(name: "材料", parent: c)
  cc = ComponentType.create(name: "窗戶", parent: c)
    ComponentType.create(name: "固定式", parent: cc)
    ComponentType.create(name: "推開式", parent: cc)
    ComponentType.create(name: "滑動式", parent: cc)
  ComponentType.create(name: "天窗", parent: c)
  ComponentType.create(name: "門", parent: c)
  ComponentType.create(name: "牆", parent: c)
  ComponentType.create(name: "地板", parent: c)

c = ComponentType.create(name: "照明")
  ComponentType.create(name: "LED", parent: c)
  ComponentType.create(name: "日光燈", parent: c)

c = ComponentType.create(name: "空調")
  ComponentType.create(name: "風扇Fan", parent: c)
  ComponentType.create(name: "幫浦 pump", parent: c)
  ComponentType.create(name: "鍋爐 boiler", parent: c)
  ComponentType.create(name: "冰水機 chiller", parent: c)
  ComponentType.create(name: "熱交換器 heat exchanger", parent: c)

c = ComponentType.create(name: "再生能源")
  ComponentType.create(name: "太陽光電/熱", parent: c)
  ComponentType.create(name: "熱泵", parent: c)

ComponentType.create(name: "其他")
