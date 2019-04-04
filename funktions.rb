def login(username, password)
    if username == result[0]["Username"]  
        if BCrypt::Password.new(result[0]["Password"]) == password
            session[:username] = result[0]["Username"]
            email = result[0]["Mail"]
            session[:cookies] = request.cookies
            session[:Id] = result[0]["Id"]
            session[:loggedin] = true
        else 
            session[:loggedin] = false
        end 
    else 
        session[:loggedin] = false
    end 
end 