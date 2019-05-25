module MyModule

    # trys to log in into a profile
    #
    # @param [Hash] params form data
    # @option params [String] username Username of the user
    # @option params [string] password Password of the user
    #
    # @return [Array] containing the data of all the userinfo
    # @return [false] wrong username or password
    def login(username, password)  
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        result = db.execute("SELECT Password From users Where Username = (?)", username)
        if BCrypt::Password.new(result[0][0]).==(password)
            return true 
        else 
            return false
        end 
    end 

    # gets all post
    #
    # @param [Hash] params form data
    #
    # @return [Array] containing the data of all the post
    def all_post()
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        result = db.execute("select users.Username, post.Title, post.Postid, post.Number, post.Upvote from post INNER JOIN users on users.Id = post.Postid")
        return result
    end 

    # get one post
    #
    # @param [Hash] params form data
    # @option params [String] number The id of the post
    #
    # @return [Array] containing the data of all the post
    def text(number)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        result = db.execute("select users.Username, post.Title, post.Postid, post.Number, post.text from post WHERE post.number = ?", number)
    end 

    # get a user id
    #
    # @param [Hash] params form data
    # @option params [String] username Username of the user
    #
    # @return [Array] containing the data of all the user id 
    def get_user_id(username)
        db = SQLite3::Database.new("db/dbsave.db")
        result = db.execute("SELECT Id FROM users WHERE Username = ?", username)
        return result[0][0]
    end

    # crates a user 
    #
    # @param [Hash] params form data
    # @option params [String] username Username of the user
    # @option params [string] password Password of the user
    # @option params [string] email Email of the user
    def create_user(username,password,email)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        db.execute("INSERT INTO users (Username, Password, Mail) VALUES (?,?,?)", username, BCrypt::Password.create(password), email)
    end

    # get the information from the id 
    #
    # @param [Hash] params form data
    # @option params [String] id The id of the profile
    #
    # @return [Array] containing the data of all the profile info
    def profile(id)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        result = db.execute("SELECT Password, Id, Mail, Username From users Where Id = (?)", id)
        return result
    end 

    # uptates a profile 
    #
    # @param [Hash] params form data
    # @option params [String] username Username of the user
    # @option params [string] password Password of the user
    # @option params [string] email Email of the user
    def uptate_profile(username,mail,id)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        db.execute("UPDATE users SET Username = ?, Mail = ? WHERE Id = ?", username, mail, id)
    end 

    # uptates a post 
    #
    # @param [Hash] params form data
    # @option params [String] title  The title if the post
    # @option params [string] text The text of teh post
    # @option params [Integer] number The id of the post
    def uptate_post(title,text,number)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        db.execute("UPDATE post SET Title = ?, Text = ? WHERE Number = ?", "#{title}", "#{text}", number)
    end 

    # GET info from one post
    #
    # @param [Hash] params form data
    # @option params [Integer] number the id of the post 
    #
    # @return [Array] containing the data of all the postinfo
    def edit_post(number)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        db.execute("SELECT Text, Number, Title, Postid From post Where Number = (?)", number)
    end 

    # crates a user 
    #
    # @param [Hash] params form data
    # @option params [String] titel The title of the post
    # @option params [string] text The text of the post
    # @option params [Integer] id the id of the profile
    def new_post(title,text,id)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        db.execute("INSERT INTO post (Title, Text, Postid, Upvote) VALUES (?,?,?,?)", title, text, id, 0)
    end
    # Deletes a post
    #
    # @option params [Integer] number The id of the post
    def delete_post(number)
        db = SQLite3::Database.new("db/dbsave.db")
        db.execute("DELETE FROM post WHERE Number = ?", number)
    end

    # Deletes a user
    #
    # @option params [Integer] id the The id of the profile
    def delete_user(id)
        db = SQLite3::Database.new("db/dbsave.db")
        db.execute("DELETE FROM user WHERE Id = ?", id)
    end 

    # chgages the vote score at a post
    #
    # @param [Hash] params form data
    # @option params [Integer] votes The vote status of the user
    # @option params [Integer] upvotes the total of the votes
    # @option params [Integer] number the The id of the post
    # @option params [Integer] id the id of the profile
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

    # if the user has voted before
    #
    # @param [Hash] params form data
    # @option params [Integer] number the The id of the post
    # @option params [Integer] id the id of the profile
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

    # GET info from one post
    #
    # @param [Hash] params form data
    # @option params [Integer] number the id of the post 
    #
    # @return [Array] containing the data of all the postinfo
    def one_post(number)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        return db.execute("select users.Username, post.Title, post.Postid, post.Number, post.Text from users INNER JOIN post on users.Id = post.Postid WHERE post.Number = ?", number)
    end 

    # get the post id
    #
    # @param [Hash] params form data
    # @option params [Integer] number the id of the post 
    #
    # @return [Array] containing the data of the post id
    def postid(number)
        db = SQLite3::Database.new("db/dbsave.db")
        db.results_as_hash = true
        return db.execute("select post.Postid FROM post WHERE post.Number = ?", number)
    end 
end 
        