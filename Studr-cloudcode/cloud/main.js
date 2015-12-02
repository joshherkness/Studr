
// Basic hello world function
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

// Adds a friendship between two users
// @param: from   Object id of sending user
// @param: to     Object id of target user
Parse.Cloud.define("addFriendship", function(request, response) {
  Parse.Cloud.useMasterKey();

  var fromUser = new Parse.User({id:request.params.from});
  var toUser = new Parse.User({id:request.params.to});

  var Friendship = Parse.Object.extend("Friendship");
  var friendship = new Friendship();

  friendship.set("from", fromUser);
  friendship.set("to", toUser);
  friendship.set("status", "pending");
  friendship.save(null, {
    success: function(){
      response.success("Friendship Added");
    },
    error: function(error){
      response.error("Friendship could not be added");
    }
  });
});

// Accepts a friendship
// @param: friendshipId - Object id of target
Parse.Cloud.define("acceptFriendship", function(request, response) {
  Parse.Cloud.useMasterKey();

  var Friendship = Parse.Object.extend("Friendship");
  var friendshipPointer = new Friendship();
  friendshipPointer.id = request.params.friendshipId;;
  var friendship = friendshipPointer.fetch({
    success: function(friendship){
      friendship.set("status", "accepted");
      friendship.save(null, {
        success: function(){
          response.success("Friendship Accepted");
        },
        error: function(error){
          response.error("Friendship could not be accepted");
        }
      });
    },
    error: function(error){
      response.error("Friendship could not be found");
    }
  });
});

// Retrieves a list of s for a given user
// @param: user - Object id of target user
Parse.Cloud.define("friendRequestsForUser", function(request, response) {
  Parse.Cloud.useMasterKey();

  var userPointer = new Parse.User({id:request.params.user});

  var fromQuery = new Parse.Query("FriendRequest");
  fromQuery.equalTo("from", userPointer);
  var toQuery = new Parse.Query("FriendRequest");
  toQuery.equalTo("to", userPointer);
  var query = Parse.Query.or(fromQuery, toQuery);
  query.include("to");
  query.include("from");
  query.find({
    success: function(results){
      response.success("s Found");
    },
    error: function(error){
      response.error("Group not found");
    }
  });
});

// Adds a new group
// @param: name          name of the group
// @param: description   description of the group
// @param: date          string representation of the date of the group
//                       ("2009 06 12,12:52:39")
// @param: access        access of group ("public", "private")
// @param: members       an array containing a list of user id's to add as members
Parse.Cloud.define("addGroup", function(request, response) {
  Parse.Cloud.useMasterKey();

  var name = request.params.name;
  var description = request.params.description;
  var date = new Date(request.params.date);
  var access = request.params.access;
  var members = requests.params.members;

  var Group = Parse.Object.extend("Group");
  var group = new Group();

  group.set("name", name);
  group.set("description", description);
  group.set("date", date);
  group.set("access", access);
  group.save(null, {
    success: function(){
      response.success("Group Added");
    },
    error: function(error){
      response.error("Group could not be added");
    }
  });
});

// Removes a new group
// @param: group - Object id of the target group object
Parse.Cloud.define("removeGroup", function(request, response) {
  Parse.Cloud.useMasterKey();

  var groupId = request.params.group;

  var query = new Parse.Query("Group");
  query.get(groupId, {
    success: function(group){
      group.destroy({
        success:function() {
          response.success("Group Removed");
        },
        error:function(error) {
          response.error("Group could not be removed");
        }
      });
    },
    error: function(error){
      response.error("Group not found");
    }
  });
});

Parse.Cloud.define("addFriendToFriendsRelation", function(request, response) {

    Parse.Cloud.useMasterKey();

    var friendRequestId = request.params.friendRequest;
    var query = new Parse.Query("FriendRequest");

    //get the group object
    query.get(friendRequestId, {

        success: function(friendRequest) {

            //get the user the request was from
            var fromUser = friendRequest.get("from");
            //get the user the request is to
            var toUser = friendRequest.get("to");

            var relation = fromUser.relation("friends");
            //add the user the request was to (the accepting user) to the fromUsers friends
            relation.add(toUser);

            //save the fromUser
            fromUser.save(null, {

                success: function() {

                    //saved the user, now edit the request status and save it
                    friendRequest.set("status", "accepted");
                    friendRequest.save(null, {

                        success: function() {

                            response.success("saved relation and updated friendRequest");
                        },

                        error: function(error) {

                            response.error(error);
                        }

                    });

                },

                error: function(error) {

                 response.error(error);

                }

            });

        },

        error: function(error) {

            response.error(error);

        }

    });

});
