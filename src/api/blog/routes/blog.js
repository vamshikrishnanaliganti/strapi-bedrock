'use strict';

module.exports = {
  routes: [
    {
      method: 'POST',
      path: '/blogs/generate',
      handler: 'blog.generate',
      config: {
        auth: false,
        policies: [],
        middlewares: []
      }
    },
    {
      method: 'GET',
      path: '/blogs',
      handler: 'blog.find',
      config: {
        auth: false,
        policies: [],
        middlewares: []
      }
    }
  ]
};
