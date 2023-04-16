import React from 'react'
import { FaGithub, FaTwitter, FaLinkedin } from 'react-icons/fa'

const Footer: React.FC = () => {
  return (
    <footer className="bg-gray-800 py-6">
      <div className="container mx-auto px-6 flex justify-between items-center">
        <div>
          <span className="text-gray-400 text-sm">
            © {new Date().getFullYear()} My Company
          </span>
        </div>
        <div className="flex items-center">
          <a
            href="https://github.com/myusername"
            target="_blank"
            rel="noopener noreferrer"
            className="text-gray-400 hover:text-gray-500 transition-colors duration-200"
          >
            <FaGithub size={20} />
          </a>
          <a
            href="https://twitter.com/myusername"
            target="_blank"
            rel="noopener noreferrer"
            className="ml-4 text-gray-400 hover:text-gray-500 transition-colors duration-200"
          >
            <FaTwitter size={20} />
          </a>
          <a
            href="https://www.linkedin.com/in/myusername"
            target="_blank"
            rel="noopener noreferrer"
            className="ml-4 text-gray-400 hover:text-gray-500 transition-colors duration-200"
          >
            <FaLinkedin size={20} />
          </a>
        </div>
      </div>
    </footer>
  )
}

export default Footer
