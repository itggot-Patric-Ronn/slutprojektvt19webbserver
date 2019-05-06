require 'sinatra'
require 'sqlite3'
require 'slim'
require 'byebug'
require 'bcrypt'
require_relative 'funktions.rb'
enable:sessions

get('/') do
    slim(:index)
end 

get('/post/new') do
    if session[:loggedin] == true
        slim(:post_new)
    else
        redirect('/not_loggin')
    end 
end

get('/not_loggin') do 
    slim(:not_loggin)
end 

get('/login/:id') do
    if session[:loggedin] == true
        id = session[0][:Id]
        result = profile()
        slim(:loginid, locals:{users:result})
    else 
        redirect('/not_loggin')
    end 
end 

get('/profile/:id/edit') do
    if session[:loggedin] = true
        result = profile()
        slim(:profile_edit, locals:{users: result})
    else 
        redirect('/')
    end
end

post('/profile/:id/uptate') do
    uptate_profile(params["Username"],params["Mail"])
    redirect("/profile/#{session[:Id]}")
end

get('/post/all') do
    result = all_post()
    slim(:post_all, locals:{posts: result})
end  

get('post/:number') do
    result = text(post[":number"])
    slim(:text, locals:{posts: result})
end

post('/post/:number/edit') do
    uptate_post(params["title"],params["text"],params["number"])
    redirect("/post/#{params["number"]}")
end 

get('/post/:number/edit') do
    result = edit_post(params["number"])
    slim(:post_edit, locals:{users: result})
end

get('/post/:postid') do
    if session[:loggedin] == true 
        result = one_post(params["postid"])
        p result
        p one_post(params["postid"])
        slim(:post_one, locals:{posts: result})
    else 
        redirect('/')
    end 
end

get('/profile/login') do 
    if session[:loggedin] == true 
        redirect("/profile/#{session[:Id]}")
    else
        slim(:login)
    end 
end 

post('/profile/login') do 
    if login(params["username"], params["password"]) == true
        session[:Id] = get_user_id(params["username"])
        redirect("/profile/#{session[:Id]}")
    else
        session[:loggedin] = false
        redirect('/no_access')
    end    
end

get('/no_access') do 
    slim(:no_access)
end 

get('/profile/new') do
    slim(:create_user)
end

post('/create') do
    if params["password"] == params["password1"]
        create_user(params["username"], params["password"], params["email"])
        redirect('/profile/login')
    else
        redirect('/profile/new')
    end
end

post('/post/new') do
    new_post(params["title"],params["text"])
    redirect('/post/all')
end

post('/post/:number/delete') do
    delete_post(params["number"])
    redirect('/post/all')
end

post('/profile/:id/delete') do
    delete_user(params["id"])
    redirect('/')
end

get('/profile/:id') do
    if session[:loggedin] == true 
        slim(:profile)
    else 
        redirect('/not_loggin')
    end 
end 

get('/uvote/:id') do
    vote_value = vote(params["id"], session[:Id])
    if vote_value == -1
        vote_change1(params["id"], session[:Id], 1, 2)
    elsif session[:loggedin] == true
        vote_change1(params["id"], session[:Id], 1, 1)
    end
    redirect('/post/all')
end

get('/dvote/:id') do
    vote_value = vote(params["id"], session[:Id])
    if vote_value == 1
        vote_change1(params["id"], session[:Id], -1, -2)
    elsif session[:loggedin] == true
        vote_change1(params["id"], session[:Id], -1, -1)
    end
    redirect('/post/all')
end

get('/logout') do
    session.clear
    redirect('/')
end
