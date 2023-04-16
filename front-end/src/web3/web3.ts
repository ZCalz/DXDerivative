import { onboardWallets } from "../wallets/connections";
import { ethers } from "ethers";

export async function web3Signer(): Promise<ethers.JsonRpcSigner> {
  const wallets = await onboardWallets();

  const ethersProvider = new ethers.BrowserProvider(wallets[0].provider, "any");

  const signer: ethers.JsonRpcSigner = await ethersProvider.getSigner();

  // send a transaction with the ethers provider
  // const txn = await signer.sendTransaction({
  //   to: "0x",
  //   value: 100000000000000,
  // });

  // const receipt = await txn.wait();
  // console.log(receipt);

  return signer;
}
