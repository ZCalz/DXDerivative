import React from 'react'
import { BlogPost } from '@/src/types/BlogPost'
import BlogCard from '../cards/BlogCard'

interface Props {
  posts: BlogPost[]
}

const Blog: React.FC<Props> = ({ posts }) => {
  return (
    <section className="container mx-auto py-12">
      <h2 className="text-3xl font-bold mb-6">Latest Blog Posts</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {posts.map(post => (
          <BlogCard key={post.id} post={post} />
        ))}
      </div>
    </section>
  )
}

export default Blog
