import React from 'react'
import ProjectShowcase from '@/components/cards/ProjectShowcase'
const index = () => {
  return (
    <div className="p-4 h-full flex flex-nowrap">
        <ProjectShowcase />
        <ProjectShowcase />
        <ProjectShowcase />
    </div>
  )
}

export default index