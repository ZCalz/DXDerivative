import { NextPage } from 'next';
import Head from 'next/head';
import Image from 'next/image';
import Link from 'next/link';
import { FaEnvelope, FaGithub, FaLinkedin, FaTwitter } from 'react-icons/fa';

const About: NextPage = () => {
  return (
    <div className="min-h-screen flex flex-col justify-center items-center">
      <Head>
        <title>About Me | My Website</title>
      </Head>

      <section className="my-16">
        <h1 className="text-3xl font-bold mb-4">About Me</h1>
        <p className="text-lg">
          Hi, I'm John! I'm a web developer with experience in React, TypeScript, Next.js, and Tailwind CSS.
        </p>
      </section>

      <section className="my-16">
        <h2 className="text-2xl font-bold mb-4">Contact</h2>
        <ul className="flex flex-col space-y-4">
          <li>
            <FaEnvelope className="inline-block mr-2" />
            <a href="mailto:john@example.com">john@example.com</a>
          </li>
        </ul>
      </section>

      <section className="my-16">
        <h2 className="text-2xl font-bold mb-4">Social Media</h2>
        <ul className="flex flex-row space-x-4">
          <li>
            <Link href="https://twitter.com/johndoe">
              <h1>
                <FaTwitter className="inline-block" />
              </h1>
            </Link>
          </li>
          <li>
            <Link href="https://github.com/johndoe">
              <h1>
                <FaGithub className="inline-block" />
              </h1>
            </Link>
          </li>
          <li>
            <Link href="https://www.linkedin.com/in/johndoe/">
              <h1>
                <FaLinkedin className="inline-block" />
              </h1>
            </Link>
          </li>
        </ul>
      </section>
    </div>
  );
};

export default About;