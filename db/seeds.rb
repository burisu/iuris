# -*- coding: undecided -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
PublicationNature.create!(:name => 'Fiche pratique', :title_format => 'Fiche pratique "[TITLE]"')
PublicationNature.create!(:name => 'Article', :title_format => 'Article "[TITLE]" de [SOURCE]')

Label.create!(:name => 'T.V.A.')
Label.create!(:name => 'Préemption')
Label.create!(:name => 'Bail')
Label.create!(:name => 'Fermage')
Label.create!(:name => 'EARL')
Label.create!(:name => 'SARL')
Label.create!(:name => 'SCEA')

Parameter.create!(:name => 'site.name', :nature => "string", :string_value => "Iuris")
Parameter.create!(:name => 'site.slogan', :nature => "string", :string_value => "Iur is Iuris")
