'use strict';

const posts = [
    {
      "id": "0",
      "subreddit": "nfl",
      "title": "Is Jameis a bust?",
      "message": "I think he is dog whatchu think?",
      "date": "07/06/16",
      "comments": []
    },
    {
      "id": "1",
      "subreddit": "nfl",
      "title": "Tom Brady likes balls!!!",
      "message": "...title says it all",
      "date": "08/12/16",
      "comments": []
    },
    {
      "id": "2",
      "subreddit": "nfl",
      "title": "SEAAA---?",
      "message": "hawks :*(",
      "date": "01/31/16",
      "comments": [
        {
          "message": "Sick dude",
          "date": "08/09/16",
          "comments": [{
            "message": "be nice to him!!!!",
            "date": "08/09/16",
            "comments": []
          }]
        }
      ]
    },
    {
      "id": "3",
      "subreddit": "nfl",
      "title": "Hey guys crazy right?",
      "message": "U seen dat??",
      "date": "09/23/16",
      "comments": []
    },
    {
      "id": "4",
      "subreddit": "nfl",
      "title": "Drew Brees seen doing hot yoga",
      "message": "U seen dat??",
      "date": "09/23/16",
      "comments": []
    },
    {
      "id": "5",
      "subreddit": "food",
      "title": "How do I make mac n' cheese?",
      "message": "This shit is too hard!!",
      "date": "09/30/16",
      "comments": []
    },
    {
      "id": "6",
      "subreddit": "food",
      "title": "Ingesting expired food",
      "message": "The next Beef Wellington??",
      "date": "09/30/16",
      "comments": []
    },
    {
      "id": "7",
      "subreddit": "food",
      "title": "Uh wat",
      "message": "Who eats these days?",
      "date": "09/30/16",
      "comments": []
    }
];

exports.postsGET = function(args, res, next) {
  /**
   * parameters expected in the args:
   * subreddit (String)
  **/

  let filteredPosts;
  if (args.subreddit.value) {
    filteredPosts = posts.filter((p) => p.subreddit === args.subreddit.value);
  }

  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.end(JSON.stringify((filteredPosts || posts), null, 2));
};

exports.postsIdGET = function(args, res, next) {
  /**
   * parameters expected in the args:
  * id (String)
  **/
  if(args.id) {
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.end(JSON.stringify(posts.filter((p) => p.id === args.id.value), null, 2));
  }
  else {
    res.end(JSON.stringify([]));
  }
};

