import Head from 'next/head'
import Image from 'next/image'
import { Inter } from 'next/font/google'
import styles from '@/styles/Home.module.css'
import Hero from '../components/Hero'
import DescribeCard from '../components/cards/DescribeCard'
import { useState } from 'react'
import { FaUser, FaBuilding, FaMapMarkerAlt } from 'react-icons/fa'
import Footer from '@/components/layouts/Footer'

export default function Home() {
  return (<div className="">
      <Hero
        title="Welcome to my website"
        subtitle="Explore and discover new things"
        image="/metallic.jpg"
      />
        {/* <Hero
        title="Welcome to my website"
        subtitle="Explore and discover new things"
        image="/mountainlake.jpeg"
      /> */}
      <div className="md:flex justify-center p-10">
      <DescribeCard
        icon={FaUser}
        title="Profile"
        description="View your personal profile"
      />
      <DescribeCard
        icon={FaBuilding}
        title="Company"
        description="View your company profile"
      />
      <DescribeCard
        icon={FaMapMarkerAlt}
        title="Location"
        description="View your current location"
      />
    </div>
    <Footer />
      </div>
    // <h1 className="text-3xl font-bold underline">
    //   Hello world!
    // </h1>
  )
}