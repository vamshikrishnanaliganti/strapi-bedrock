'use strict';

const { generateBlogPost } = require('../services/bedrock');

module.exports = {
  async generate(ctx) {
    try {
      const { topic } = ctx.request.body;

      if (!topic) {
        return ctx.badRequest('Topic is required');
      }

      // Generate content using Bedrock
      const generated = await generateBlogPost(topic);

      // Save to Strapi
      const blog = await strapi.entityService.create('api::blog.blog', {
        data: {
          title: generated.title,
          content: generated.content,
          topic: topic,
          aiGenerated: true,
          publishedAt: new Date()
        }
      });

      ctx.body = {
        success: true,
        message: 'Blog post generated successfully',
        data: blog
      };

    } catch (error) {
      ctx.internalServerError(`Error generating blog: ${error.message}`);
    }
  },

  async find(ctx) {
    const blogs = await strapi.entityService.findMany('api::blog.blog', {
      sort: { createdAt: 'desc' }
    });
    ctx.body = { data: blogs };
  }
};
