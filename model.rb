module MyModule
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
        result = db.execute("select users.Username, post.Title, post.Postid, post.Number, post.Upvote from post INNER JOIN users on users.Id = post.Postid")
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

    def uptate_post(title,text,number)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        db.execute("UPDATE post SET Title = ?, Text = ? WHERE Number = ?", "#{title}", "#{text}", number)
    end 

    def edit_post(number)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        db.execute("SELECT Text, Number, Title From post Where Number = (?)", number)
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

    def vote_change1(number, id, votes, upvotes)
        db = SQLite3::Database.new("db/dbsave.db")
        if vote(number, id) == true
            db.execute("UPDATE vote SET Votes = ? WHERE Number = ? AND Id = ?", votes, number, id)
        else
            db.execute("INSERT INTO vote (Number, Id, Votes) VALUES (?,?,?)", number, id, votes)
        end
        upvote = db.execute("SELECT post.upvote FROM post WHERE post.Number = ?", number)[0][0].to_i
        db.execute("UPDATE post SET upvote = ? WHERE Number = ?", upvote + upvotes, number)
    end

    def vote(number, id)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        voted = db.execute("SELECT vote.Number, vote.Id, vote.Votes FROM vote WHERE Id = ? AND Number = ?", id, number) 
        if voted.length == 0
            return true
        else
            return value = voted[0]["votes"].to_i
        end
    end

    def one_post(postid)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        return db.execute("select users.Username, post.Title, post.Postid, post.Number, post.Text from users INNER JOIN post on users.Id = post.Postid WHERE post.Number = ?", postid)
    end 
end 