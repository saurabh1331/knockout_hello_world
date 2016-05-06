require 'rubygems'
require 'data_mapper'
require 'dm-mysql-adapter'
require 'sinatra'
require 'haml'

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, "mysql://root:root@localhost/test_dynamic")

DataMapper::Property.auto_validation(false)
DataMapper::Property.required(false)


class Leader
	include DataMapper::Resource
	property :id, Serial
	property :lname, String
	has n, :intern, :constraint => :destroy
end

class Intern
	include DataMapper::Resource
	property :id, 	Serial
	property :name, String, :required => true
	property :college, String
	property :joined_at, String
#	property :lname, String
	belongs_to :leader
end



DataMapper.auto_migrate!

DataMapper.finalize

['Gaurav','David'].each do |name|
Leader.create(:lname => name)	
end

[['Saurabh',1,'21-5-2013'], ['Pooja',1,'21-5-2013'], ['nikhil',2,'21-5-2013'], ['bhavya',2,'21-5-2013']].each do |name|
Intern.create(:name => name[0], :college => 'MNIT' , :leader_id=>name[1],:joined_at=>name[2])
end

get "/" do
haml :kohaml
end 

get "/interns" do
@interns = Intern.all
@interns.to_json
end

post "/getleaderid" do
	begin
		@g1 = Leader.first(:lname=>params[:data]).id
		@g1.to_json
	rescue NameError
		g2 = params[:name];
		"#{g2} is not a project leader"
	end
end

get "/save" do
	begin
		@s1 = Intern.create(:name=>params[:name],:college=>params[:college],:joined_at=>params[:joined_at],:leader_id=>params[:leader_id])
		@s2 = Intern.first(:name=>params[:name]).id
		@s2.to_json
	rescue NameError
		"error in saving"	
	end 
end

get "/del" do
	begin
		@d1 = Intern.first(:name=>params[:name]).destroy
	rescue NameError
		"error in deleting"
	end
end
 
