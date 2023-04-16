import { NextPage } from 'next';
import Head from 'next/head';
import Image from 'next/image';
import { FaLaptopCode, FaMobileAlt, FaServer } from 'react-icons/fa';

const ServicesPage: NextPage = () => {
  return (
    <div className="min-h-screen flex flex-col justify-center items-center">
      <Head>
        <title>Our Services | My Website</title>
      </Head>

      <section className="my-16">
        <h1 className="text-3xl font-bold mb-4">Our Services</h1>
        <p className="text-lg">
          We offer a range of services to help you develop and grow your business.
        </p>
      </section>

      <section className="my-16">
        <div className="flex flex-col md:flex-row md:items-center space-y-4 md:space-y-0 md:space-x-8">
          <div className="flex-shrink-0">
            <FaLaptopCode className="text-4xl text-blue-500" />
          </div>
          <div className="flex-grow">
            <h2 className="text-2xl font-bold mb-4">Web Development</h2>
            <p className="text-lg">
              We develop custom web applications that are tailored to your business needs, using the latest web technologies such as React, TypeScript, Next.js, and Tailwind CSS.
            </p>
          </div>
        </div>
      </section>

      <section className="my-16">
        <div className="flex flex-col md:flex-row md:items-center space-y-4 md:space-y-0 md:space-x-8">
          <div className="flex-shrink-0">
            <FaMobileAlt className="text-4xl text-blue-500" />
          </div>
          <div className="flex-grow">
            <h2 className="text-2xl font-bold mb-4">Mobile App Development</h2>
            <p className="text-lg">
              We build mobile apps for iOS and Android that provide your customers with a seamless user experience, using tools such as React Native, TypeScript, and Tailwind CSS.
            </p>
          </div>
        </div>
      </section>

      <section className="my-16">
        <div className="flex flex-col md:flex-row md:items-center space-y-4 md:space-y-0 md:space-x-8">
          <div className="flex-shrink-0">
            <FaServer className="text-4xl text-blue-500" />
          </div>
          <div className="flex-grow">
            <h2 className="text-2xl font-bold mb-4">Backend Development</h2>
            <p className="text-lg">
              We build scalable and secure backend systems that power your web and mobile applications, using frameworks such as Node.js and databases such as PostgreSQL and MongoDB.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
};

export default ServicesPage;
