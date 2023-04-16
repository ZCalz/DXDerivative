import Onboard, { WalletState } from "@web3-onboard/core";
import enrkypt from "@web3-onboard/enkrypt";
import injectedModule from "@web3-onboard/injected-wallets";

export async function enkryptConnect() {
  const enrkyptModule = enrkypt();

  const onboard = Onboard({
    // ... other Onboard options
    wallets: [
      enrkyptModule,
      //... other wallets
    ],
    chains: [{ id: 1 }, { id: 5 }],
  });

  const connectedWallets = await onboard.connectWallet();
  console.log(connectedWallets);
}

export async function onboardWallets(): Promise<WalletState[]> {
  const MAINNET_RPC_URL = "https://mainnet.infura.io/v3/<INFURA_KEY>";

  const injected = injectedModule();

  const onboard = Onboard({
    wallets: [injected],
    chains: [
      {
        id: "0x1",
        token: "ETH",
        label: "Ethereum Mainnet",
        rpcUrl: MAINNET_RPC_URL,
      },
    ],
  });

  const wallets: WalletState[] = await onboard.connectWallet();

  if (wallets[0]) {
    return wallets;
  } else {
    throw new Error("No wallets connected. Please connect a wallet.");
  }
}
