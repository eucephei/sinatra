require "rubygems"
require "sinatra"

configure do
  enable :sessions
end

helpers do

  def authorized?
    !session[:user].nil?
  end

  def authorize!
    redirect '/login' unless authorized?
  end

  def logout!
    if session[:user]
      session[:user] = nil  
      session[:time] = nil
      session[:pages] = 0
      session[:math] = 0
    end
  end
  
  def page_viewed
  	session[:pages] ||= 0
  	session[:pages] += 1
  end
    
end

before do
  page_viewed
end

get '/' do
  unless authorized?
   	"Please <a href='/login'>Login</a> First."
  else
  	redirect '/tictactoe'
  end
end

get '/login' do
  if authorized?
    redirect '/math'
  else
    erb :login
  end
end

post '/submit' do
    case user = params[:user].to_s
    when /\w+/
      session[:user] = user
      session[:time] = Time.now.to_i
      redirect "/tictactoe"
    when /\W*/
      @error = "Illegal character used"
      redirect "/login"
    else
      halt 401, "Unexpected Authentication Response: #{authenticated}"
    end
end

get '/math' do
  authorize!
  session[:math] ||= 0
  erb :math
end

post '/math' do
  begin
   session[:error] = nil
   session[:equation] = params['equation'].to_s
   raise if session[:equation] =~ /\s+/
   session[:equation_eval] = eval session[:equation]
   session[:math] += 1
  rescue SyntaxError => e
   session[:equation_eval] = nil
   session[:error] = "bad equation."   
  rescue
   session[:equation_eval] = nil
   session[:error] = "bad equation."      
  ensure
   redirect '/math'
  end
end

get '/tictactoe' do
  authorize!
  erb :tictactoe
end

post '/tictactoe' do
  erb :tictactoe
end

get '/date' do
  authorize!
  erb :date
end

get '/news' do
  authorize!
  erb :news
end

get '/stats' do
  authorize!
  erb :stats
end

get '/pict' do
  authorize!
  erb :pict
end

get '/logout' do
  logout!
  redirect '/'
end