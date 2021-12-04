#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?',[name]).length > 0
end

def seed_db db, barbers 

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end

end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do 
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS
		"Barbers"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT
		)'
	seed_db db, ['Walter White','Jessie Pinkman','Gus Fring', 'Mike Ehrman']
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end


get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end
 
post '/visit' do 
	@user_name = params[:user_name]
	@phone     = params[:phone]
	@date_time = params[:date_time]
	@barber    = params[:barber]
	@color     = params[:color]

	hh = {
		:user_name => 'Введите имя',
		:phone     => 'Введите телефон',
		:date_time => 'Введите дату и время'
	}

	@error = hh.select {|key,_|params[key] == ""}.values.join(",")

	if @error != ''
			return erb :visit
	end

	@title = 'Thank you!'
	@message = "Уважаемый #{@user_name}, мы ждём вас #{@date_time}"

	db = get_db
	db.execute 'insert into
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)
		values (?, ?, ?, ?, ?)', [@user_name, @phone, @date_time, @barber, @color]
	

	erb :welcome
end

get '/contacts' do 
	erb :contacts
end

post '/contacts' do
	@contact_email = params[:contact_email]
	@contact_message = params[:contact_message]

	f = File.open './public/contacts.txt', 'a'
	f.write "Contact: #{@contact_email}, Message: #{@contact_message}.\n"
	f.close

	@title = 'Спасибо'
	@message = 'уауа'
		erb :welcome
end

get '/showusers' do
	db = get_db
	
	@results = db.execute 'select * from Users order by id desc'

	erb :showusers
end