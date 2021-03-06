require 'sinatra'
require 'slim'
require 'data_mapper'

#DataMapper.setup(:default,ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/development.db")
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
class Task
	include DataMapper::Resource
	property :id, Serial
	property :name, String, :required =>true
	property :completed_at,DateTime
	belongs_to :list
end

	
class List
	include DataMapper::Resource
	property :id, Serial
	property :name,String, :required =>true
	has n, :tasks, :constraint =>:destroy
end
DataMapper.finalize

get '/' do
	@lists =List.all(:order => [:name])
	slim :index
end

post '/:id' do
	List.get(params[:id]).tasks.create params['task']
	redirect '/'
end

delete '/task/:id' do
	Task.get(params[:id]).destroy
	redirect '/'
end

put '/task/:id' do
	task=Task.get params[:id]
	task.completed_at = task.completed_at.nil? ? Time.now : nil
	task.save
	redirect '/'
end

post '/new/list' do
	List.create params['list']
	redirect '/'
end

delete '/list/:id' do
	List.get(params[:id]).destroy
	redirect '/'
end

get '/styles.css' do
	scss :styles
end