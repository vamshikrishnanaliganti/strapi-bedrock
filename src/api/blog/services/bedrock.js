'use strict';

const { BedrockRuntimeClient, InvokeModelCommand } = require('@aws-sdk/client-bedrock-runtime');

const client = new BedrockRuntimeClient({
  region: process.env.AWS_REGION || 'us-east-1',
});

const generateBlogPost = async (topic) => {
  const prompt = `Write a detailed, engaging blog post about "${topic}". 
  The blog post should include:
  - A catchy title
  - An introduction
  - 3-4 main sections with headings
  - A conclusion
  - Be approximately 800-1000 words
  
  Format the response as JSON with this structure:
  {
    "title": "Blog post title",
    "content": "Full blog post content in markdown format"
  }`;

  const payload = {
    anthropic_version: 'bedrock-2023-05-31',
    max_tokens: 2000,
    messages: [
      {
        role: 'user',
        content: prompt
      }
    ]
  };

  const command = new InvokeModelCommand({
    modelId: 'anthropic.claude-3-sonnet-20240229-v1:0',
    contentType: 'application/json',
    accept: 'application/json',
    body: JSON.stringify(payload)
  });

  const response = await client.send(command);
  const responseBody = JSON.parse(Buffer.from(response.body).toString('utf8'));
  const text = responseBody.content[0].text;

  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (jsonMatch) {
    return JSON.parse(jsonMatch[0]);
  }

  return {
    title: `Blog post about ${topic}`,
    content: text
  };
};

module.exports = { generateBlogPost };
