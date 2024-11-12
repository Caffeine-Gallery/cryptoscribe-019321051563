import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

import Time "mo:base/Time";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";

actor {
    // Post type definition
    public type Post = {
        id: Nat;
        title: Text;
        body: Text;
        author: Text;
        timestamp: Int;
    };

    // Stable variable to store posts
    stable var posts : [Post] = [];
    stable var nextId : Nat = 0;

    // Create a new post
    public shared func createPost(title: Text, body: Text, author: Text) : async Post {
        let post : Post = {
            id = nextId;
            title = title;
            body = body;
            author = author;
            timestamp = Time.now();
        };

        nextId += 1;
        
        // Create a buffer from the stable array
        let postsBuffer = Buffer.fromArray<Post>(posts);
        postsBuffer.add(post);
        posts := Buffer.toArray(postsBuffer);
        
        return post;
    };

    // Get all posts in reverse chronological order
    public query func getPosts() : async [Post] {
        Array.tabulate<Post>(posts.size(), func (i) {
            posts[posts.size() - 1 - i];
        });
    };
}
