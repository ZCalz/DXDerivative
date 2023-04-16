import '@/styles/globals.css'
import type { AppProps } from 'next/app'
import {Navbar}from '../components/Navbar'
// import { WagmiConfig, createClient } from 'wagmi'
// import { getDefaultProvider } from 'ethers'


export default function App({ Component, pageProps }: AppProps) {
  // const client = createClient({
  //   autoConnect: true,
  //   provider: getDefaultProvider(1),
  //  })
  return <div className="h-screen w-full static">
   {/* <WagmiConfig client={client}> */}
   <div className="w-full h-24 shadow-2xl bg-black absolute top-0 left-0 right-0"></div>
    <Navbar />
    <Component className="z-0" {...pageProps} />
  {/* </WagmiConfig> */}
 </div>
}