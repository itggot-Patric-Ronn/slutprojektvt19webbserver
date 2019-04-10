def login(username, password)  
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    result = db.execute("SELECT Password, Mail, Username From users Where Username = (?)", params["username"])
    if BCrypt::Password.new(result[0]["Password"]) == password
        session[:username] = result[0]["Username"]
        email = result[0]["Mail"]
        session[:cookies] = request.cookies
        session[:Id] = result[0]["Id"]
        session[:loggedin] = true
    else 
        session[:loggedin] = false
    end 
end 

def all_post()
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    result = db.execute("select users.Username, post.Title, post.Postid, post.Number, post.Text from post INNER JOIN users on users.Id = post.Postid")
    return result
end 

def get_user_id(username)
    db = SQLite3::Database.new("db/dbsave.db")
    user_id = db.execute("SELECT users.user_id FROM users WHERE users.username = ?", username) 
    return user_id
end

def create_user(username,password,email)
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    db.execute("INSERT INTO users (Username, Password, Mail) VALUES (?,?,?)",username,BCrypt::Password.create(password),email)
end

def profile()
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    result = db.execute("SELECT Password, Id, Mail, Username From users Where Id = (?)", session[:Id])
    return result
end 

def uptate_profile(username,mail)
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    db.execute("UPDATE users SET Username = ?, Mail = ? WHERE Id = ?",params["Username"],params["Mail"], session[:Id])
end 

def uptate_post(title,content,number)
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    db.execute("UPDATE post SET (Title,Text) VALUES (?,?) WHERE Number = ?",title, text, number)
end 

def edit_post(number)
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    result = db.execute("SELECT Text, Number From post Where Number = (?)", number)
    return result
end 

def new_post(title,content)
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    db.execute("INSERT INTO posts (Title, Text, Id, Upvote) VALUES (?,?,?,?,?)", title, text, session[:Id], 0)
end

def delete_post(number)
    db = SQLite3::Database.new("db/dbsave.db")
    db.execute("DELETE FROM post WHERE Number = ?", number)
end

def delete_user(Id)
    db = SQLite3::Database.new("db/dbsave.db")
    db.execute("DELETE FROM user WHERE Id = ?", Id)
end 

def postsid()
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
end 