require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Chattp' do
  before(:each) do
  end

  it "should respond to / GET" do
    get '/'
    last_response.should be_ok
    last_response.body.should include("First.")
  end

  it "should respond to /login GET" do
    get '/login'
    last_response.should be_ok
    last_response.body.should include("login")
  end

  it "should respond to valid /submit POST" do
    post '/submit', { :user => 'walter' }
    last_response.should be_redirect
    last_response.headers["Location"].should == '/tictactoe'
  end

  it "should respond to invalid /submit POST" do
    post '/submit', { :user => '' }
    last_response.should be_redirect
    last_response.headers["Location"].should == '/login'
  end

end

