def login(username, password)  
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    result = db.execute("SELECT Password From users Where Username = (?)", username)
    if BCrypt::Password.new(result[0][0]).==(password)
        session[:username] = username
        session[:cookies] = request.cookies
        session[:loggedin] = true
        return true 
    else 
        session[:loggedin] = false
        return false
    end 
end 

def all_post()
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    result = db.execute("select users.Username, post.Title, post.Postid, post.Number from post INNER JOIN users on users.Id = post.Postid")
    return result
end 

def text(number)
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    result = db.execute("select users.Username, post.Title, post.Postid, post.Number, post.text from post WHERE post.number = ?", number)
end 

def get_user_id(username)
    db = SQLite3::Database.new("db/dbsave.db")
    result = db.execute("SELECT Id FROM users WHERE Username = ?", username)
    return result[0][0]
end

def create_user(username,password,email)
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    p password
    db.execute("INSERT INTO users (Username, Password, Mail) VALUES (?,?,?)", username, BCrypt::Password.create(password), email)
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
    db.execute("UPDATE users SET Username = ?, Mail = ? WHERE Id = ?", username, mail, session[:Id])
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

def new_post(title,text)
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
    db.execute("INSERT INTO post (Title, Text, Postid, Upvote) VALUES (?,?,?,?)", title, text, session[:Id], 0)
end

def delete_post(number)
    db = SQLite3::Database.new("db/dbsave.db")
    db.execute("DELETE FROM post WHERE Number = ?", number)
end

def delete_user(id)
    db = SQLite3::Database.new("db/dbsave.db")
    db.execute("DELETE FROM user WHERE Id = ?", id)
end 

def postsid()
    db = SQLite3::Database.new("db/dbsave.db")
    db.results_as_hash = true
end 