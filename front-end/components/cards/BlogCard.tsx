import React from 'react'
import Link from 'next/link'
import { BlogPost } from '@/src/types/BlogPost'

interface Props {
  post: BlogPost
}

const BlogCard: React.FC<Props> = ({ post }) => {
  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <img
        src={post.image}
        alt={post.title}
        className="w-full h-48 object-cover"
      />
      <div className="p-6">
        <h3 className="text-xl font-semibold mb-2">
          <Link href={`/blog/${post.id}`}>
            <h1 className="hover:text-blue-500 transition-colors duration-200">
              {post.title}
            </h1>
          </Link>
        </h3>
        <p className="text-gray-600 text-sm mb-4">{post.excerpt}</p>
        <div className="flex items-center">
          <span className="text-gray-700 text-sm">{post.date}</span>
        </div>
      </div>
    </div>
  )
}

export default BlogCard
