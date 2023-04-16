import React from 'react'
import { IconType } from 'react-icons/lib'
import { FiChevronRight } from 'react-icons/fi'

interface Props {
  icon: IconType
  title: string
  description: string
}

const DescribeCard: React.FC<Props> = ({ icon: Icon, title, description }) => {
  return (
    <div className="bg-white rounded-lg shadow-md p-6 px-10 mx-10 flex-col justify-center text-center items-center object-center">
      <div className="rounded-full bg-gray-100 p-3 flex justify-center w-50">
        <Icon className="text-gray-500" size={52} />
      </div>
      <div className="flex-col text-center">
        <h2 className="text-lg font-bold">{title}</h2>
        <p className="text-gray-500">{description}</p>
      </div>
      {/* <div className="flex-grow"></div> */}
      {/* <FiChevronRight className="text-gray-400" size={20} /> */}
    </div>
  )
}

export default DescribeCard