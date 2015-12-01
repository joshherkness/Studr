
// Basic hello world function
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

// Sends a friend request from one user to another
// param: from - Object id of sending user
// param: to - Object id of target user
Parse.Cloud.define("sendFriendRequest", function(request, response) {
  Parse.Cloud.useMasterKey();

  var fromUser = new Parse.User({id:request.params.from});
  var toUser = new Parse.User({id:request.params.to});

  var FriendRequest = Parse.Object.extend("FriendRequest");
  var friendRequest = new FriendRequest();

  friendRequest.set("from", fromUser);
  friendRequest.set("to", toUser);
  friendRequest.set("status", "pending");
  friendRequest.save(null, {
    success: function(response){
      response.success("Friend Request Sent");
    },
    error: function(error){
      response.error(error);
    }
  });
});

// Accepts a friend request
// param: friendRequestId - Object id of target friend request
Parse.Cloud.define("acceptFriendRequest", function(request, response) {
  Parse.Cloud.useMasterKey();

  var friendRequestPointer = new Parse.FriendRequest({id:request.params.friendRequestId});
  var friendRequest = friendRequestPointer.fetch({
    success: function(friendRequest){
      friendRequest.set("status", "accepted");
      response.success("Friend Request Accepted");
    },
    error: function(error){
      response.error(error);
    }
  });
});

// Retrieves a list of friend requests for a given user
// param: user - Object id of target user
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
      response.success("Friend Requests Found");
    },
    error: function(error){
      response.error(error);
    }
  });
});

Parse.Cloud.define("addFriendToFriendsRelation", function(request, response) {

    Parse.Cloud.useMasterKey();

    var friendRequestId = request.params.friendRequest;
    var query = new Parse.Query("FriendRequest");

    //get the friend request object
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
