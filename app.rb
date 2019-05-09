require 'sinatra'
require 'sqlite3'
require 'slim'
require 'byebug'
require 'bcrypt'
require_relative 'model.rb'
enable:sessions
include MyModule

# Display Landing Page
#
get('/') do
    slim(:index)
end 

# Displays a create post page
#
# @param [Integer] :id, the ID of the article
# @see Model#get_article
get('/post/new') do
    if session[:loggedin] == true
        slim(:post_new)
    else
        redirect('/not_loggin')
    end 
end

# display when a user is not logged in
#
get('/not_loggin') do 
    slim(:not_loggin)
end 

# Displays a single profile welcomepage
#
# @session [Integer] :id, the ID of the article
#
# @see Model#profile
get('/login/:id') do
    if session[:loggedin] == true
        id = session[0][:Id]
        result = profile()
        slim(:loginid, locals:{users:result})
    else 
        redirect('/not_loggin')
    end 
end 

# Display a edit from for a profile
#
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

# Updates an existing post and redirects to '/post/number'
#
# @param [Integer] number, The ID of the post
# @param [String] title, The new title of the post
# @param [String] text, The new content of the post
#
# @see Model#update_post
post('/post/:number/edit') do
    uptate_post(params["title"],params["text"],params["number"])
    redirect("/post/#{params["number"]}")
end 

# Display a edit from for a post
#
# @params [Interger] number, The ID of the post
#
# @see model#edit_post
get('/post/:number/edit') do
    result = edit_post(params["number"])
    slim(:post_edit, locals:{users: result})
end

# display a post from a signgle profile
#
# @params [interger] postid, The ID of the poster
#
# @see model#one_post
get('/post/:postid') do
    if session[:loggedin] == true 
        result = one_post(params["postid"])
        slim(:post_one, locals:{posts: result})
    else 
        redirect('/')
    end 
end

# Displays a login form
#
get('/profile/login') do 
    if session[:loggedin] == true 
        redirect("/profile/#{session[:Id]}")
    else
        slim(:login)
    end 
end 

# Attempts login and updates the session
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see Model#login
# @see model#get_user_id
post('/profile/login') do 
    if login(params["username"], params["password"]) == true
        session[:Id] = get_user_id(params["username"])
        redirect("/profile/#{session[:Id]}")
    else
        session[:loggedin] = false
        redirect('/no_access')
    end    
end

# Displays an error message
#
get('/no_access') do 
    slim(:no_access)
end 

# Displays a register form to profiles
#
get('/profile/new') do
    slim(:create_user)
end

# Creates a new profile and redirects to '/profile/login'
#
# @param [String] password, The password of the user
# @param [String] password1, The password corection of ucer
# @param [string] username, the new user username
#
# @see Model#create_article
post('/create') do
    if params["password"] == params["password1"]
        create_user(params["username"], params["password"], params["email"])
        redirect('/profile/login')
    else
        redirect('/profile/new')
    end
end

# Creates a new post and redirects to '/post/all'
#
# @param [String] title, The title of the article
# @param [String] text, The content of the article
#
# @see Model#new_post
post('/post/new') do
    new_post(params["title"],params["text"])
    redirect('/post/all')
end

# Deletes an existing post and redirects to '/post/all'
#
# @param [Integer] :id, The ID of the article
# @param [String] title, The new title of the article
# @param [String] content, The new content of the article
#
# @see Model#delete_article






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
