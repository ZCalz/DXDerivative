import React from 'react'

interface Props {
  title: string
  subtitle: string
  image: string
}

const Hero: React.FC<Props> = ({ title, subtitle, image }) => {
  return (
    <div className="relative bg-gray-800">
       <div className="absolute top-0 left-0 right-0 h-12 shadow-2xl bg-black z-10 backdrop-blur-sm backdrop-filter bg-opacity-10"></div>
      <div className="absolute inset-0">
        <img
          className="w-full h-full object-cover opacity-50"
          src={image}
          alt=""
        />
        <div className="absolute inset-0 bg-black opacity-50"></div>
      </div>
      <div className="relative z-10 flex flex-col items-center justify-center h-screen max-w-7xl mx-auto">
        <h1 className="text-4xl font-bold text-white">{title}</h1>
        <p className="mt-4 text-xl text-white">{subtitle}</p>
      </div>
      <div className="absolute bottom-0 left-0 right-0 h-6 shadow-2xl bg-black z-10 backdrop-blur-sm backdrop-filter bg-opacity-10"></div>
    </div>
  )
}

export default Hero