#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do 
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'
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

	f = File.open './public/users.txt', 'a'
	f.write "User: #{@user_name}, Phone: #{@phone}, Dte and time: #{@date_time}, Baber: #{@barber}, Color: #{@color}.\n"
	f.close

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