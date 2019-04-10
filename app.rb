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
                if session[logged_in] = true
                    id = session[0][:Id]
                    result = profile()
                    slim(:loginid, locals:{users:result})
                else 
                    redirect('/')
            end 

            get('/profile/:id/edit') do
                if session[logged_in] = true
                    result = profile()
                    slim(:profile_edit, locals:{users: result})
                else 
                    redirect('/')
            end

            post('/profile/:id/uptate') do
                uptate_profile(params["Username"],params["Mail"])
                redirect("/profile/#{session[:Id]}")
            end

            get('/post/all') do
                result = all_post()
                slim(:post_all, locals:{posts: result})
            end  

            post('/post/:number/edit') do
                uptate_post(params["title"],params["text"],params["number"])
                redirect("/post/#{session[:Postid]}")
            end 

            get('/post/:number/edit') do
                result = edit_post(params["number"])
                slim(:post_edit, locals:{users: result})
            end

        get('/post/:postid') do
            db = SQLite3::Database.new("db/dbsave.db")
            db.results_as_hash = true
            session[:Postid] = params["postid"]
            postid = params["postid"]
            result = db.execute("select users.Username, post.Postid, post.Number, post.Text from users INNER JOIN post on users.Id = post.Postid WHERE users.Id = ?", postid)    
            slim(:post_one, locals:{posts: result})
        end 

            get('/profile/login') do 
                if session[:loggedin] == true 
                    redirect("/profile/#{session[:Id]}")
                else
                    slim(:login)
                end 
            end 

            get('/profile/:id') do
                slim(:profile)
            end 

            post('/profile/login') do 
                if login(params["username"], params["password"]) == true
                    session[:Id] = get_user_id(params["username"])
                    session[:loggedin] = true
                    session[:username] = params["username"]
                    redirect('/profile/#{result[0]["Id"]}')
                else
                    session[:logged_in] = false
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
                create_user(params["username"], params["password"], params["email"])
                redirect('/profile/login')
            end

            post('/post/new') do
                new_post(params["title"],params["content"])
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