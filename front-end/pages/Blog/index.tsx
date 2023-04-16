import React, { useState, useEffect } from 'react'
import Blog from '@/components/layouts/Blog'
import { BlogPost } from '@/src/types/BlogPost'
import blogs from "@/src/exampleData/blogpost.json";


const BlogPage = () => {
  // const [blogPosts, setBlogPosts] = useState([]);

  // useEffect(() => {
  //   fetchBlogPosts();
  // }, [blogPosts]);

  // const fetchBlogPosts = async () => {
  //   const response = await fetch("/api/blog");
  //   const data = await response.json();
  //   setBlogPosts(data.posts);
  // }
  // fetchBlogPosts()
  return (
    <Blog posts={blogs.posts} />
  )
}

export default BlogPage