const { getContract, formatEther, createPublicClient, http } = require("viem");
const { celo } = require("viem/chains");
const { stableTokenABI } = require("@celo/abis");

const STABLE_TOKEN_ADDRESS = "0x765DE816845861e75A25fCA122bb6898B8B1282a";

async function checkCUSDBalance(publicClient, address) {
  let StableTokenContract = getContract({
      abi: stableTokenABI,
      address: STABLE_TOKEN_ADDRESS,
      publicClient,
  });

  let balanceInBigNumber = await StableTokenContract.read.balanceOf([
      address,
  ]);

  let balanceInWei = balanceInBigNumber.toString();

  let balanceInEthers = formatEther(balanceInWei);

  return balanceInEthers;
}

const publicClient = createPublicClient({
  chain: celo,
  transport: http(),
}); // Mainnet

let balance = await checkCUSDBalance(publicClient, address); // In Ether unit