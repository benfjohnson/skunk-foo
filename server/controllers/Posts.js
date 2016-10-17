'use strict';

var url = require('url');


var Posts = require('./PostsService');


module.exports.postsGET = function postsGET (req, res, next) {
  Posts.postsGET(req.swagger.params, res, next);
};

module.exports.postsIdGET = function postsIdGET (req, res, next) {
  Posts.postsIdGET(req.swagger.params, res, next);
};
