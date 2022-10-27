import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import { BigNumber } from 'ethers';
import detectEthereumProvider from '@metamask/detect-provider';

import Nav from './Nav';
import KryptoBird from '../abis/KryptoBirdz.json';
import Cards from './Cards';

const App = () => {
  //first to detect ethereum provider 是否有metamask安裝(或其他的)
  // const web3 = new Web3(window.ethereum);
  const [address, setAddress] = useState(null);
  const [networkId, setNetworkId] = useState(null);
  // const [contractAddress, setContractAddress] = useState('');
  // const [contractAbi, setContractAbi] = useState([]);
  const [contractRead, setContractRead] = useState(null);
  const [contractSign, setContractSign] = useState(null);
  const [totalSupply, setTotalSupply] = useState([]);
  const [kryptobird, setKryptobird] = useState([]);
  const [mintfile, setmintfile] = useState('');

  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  // const [contractRead, setContractRead] = useState(null);

  // const provider = new ethers.providers.Web3Provider(window.ethereum);
  // const signer = provider.getSigner();

  const loadWeb3 = async () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    setProvider(provider);
    setSigner(signer);
    if (provider) {
      console.log('ethereum wallet connected!');
    } else {
      // no ethereum provider
      console.log('no ethereum provider detected');
    }

    // Get accounts and networkId
    const accounts = await provider.send('eth_accounts', []);
    const networkId = await provider.send('net_version', []);

    setAddress(accounts);
    setNetworkId(networkId);

    const networkData = KryptoBird.networks[networkId];

    if (networkData) {
      const contractAbi = KryptoBird.abi;
      const contractAddress = networkData.address;
      const contractRead = new ethers.Contract(contractAddress, contractAbi, provider);
      const contractSign = new ethers.Contract(contractAddress, contractAbi, signer);
      setContractRead(contractRead);
      setContractSign(contractSign);
      const gettotalsupply = await contractRead.totalSupply();

      setTotalSupply(gettotalsupply);
      // console.log(gettotalsupply);
      for (let i = 1; i <= gettotalsupply; i++) {
        const KryptoBird = await contractRead.kryptoBirdz(i - 1);
        //TODO:這邊是把kryptobird[]找到全部的nft有多少
        setKryptobird((kryptobird) => [...kryptobird, KryptoBird]);
      }
      // console.log(kryptobird);
    } else {
      window.alert('Smart Contract is not Deployed');
    }
  };

  const mint = async (kryptobirdz) => {
    try {
      const Response = await contractSign.mint(kryptobirdz);
      //TODO: 這邊是真的mint
      setKryptobird((kryptobird) => [...kryptobird, kryptobirdz]);
    } catch (error) {
      console.log(error.message);
    }
  };

  const submitHandler = (e) => {
    e.preventDefault();
    mint(mintfile);
  };

  useEffect(() => {
    loadWeb3();
  }, []);

  return (
    <>
      <Nav newaddress={address} />
      <div className="text-gray-800 w-full mx-auto text-3xl text-center mt-5">NFT MarketPlace</div>
      <form action="" onSubmit={(e) => submitHandler(e)}>
        <div className="flex flex-col justify-items-center mb-6 mt-5">
          <input
            className="w-1/3 p-2 rounded-md mx-auto border-2 border-blue-400 focus:ring-blue-500 focus:border-blue-500"
            type="text"
            value={mintfile}
            onChange={(e) => setmintfile(e.target.value)}
            placeholder="add a file location"
          ></input>
          <button
            className="w-1/6 text-white mx-auto rounded-md p-2 border-2 bg-gradient-to-r from-cyan-500 to-blue-500 my-4 active:ring-2 ring-offset-2  border-none active:ring-blue-500 duration-100"
            type="submit"
          >
            Mint
          </button>
        </div>
      </form>
      {/* <div>{console.log(kryptobird)}</div> */}
      {/* <div>{kryptobird}</div> */}
      {/* TODO: maybe grid */}
      <div className="flex flex-wrap justify-center ">
        {kryptobird.map((kb, index) => {
          return (
            <div className="drop-shadow-md mx-5" key={index}>
              <Cards pic={kb} />
            </div>
          );
        })}
      </div>
    </>
  );
};

export default App;

// https://imgbb.com/
// https://i.ibb.co/gzd9cPN/c-bird1.png
// https://i.ibb.co/94S1H6x/c-bird2.png
// https://i.ibb.co/pb0ps2N/c-bird3.png
// https://i.ibb.co/hx0v8yj/c-bird4.png
// https://i.ibb.co/ysnB0sq/k1.png
// https://i.ibb.co/3p1Yxpm/k2.png
// https://i.ibb.co/GtnZMs0/k3.png
// https://i.ibb.co/4djZHsx/k4.png
// https://i.ibb.co/zxqQWsv/k5.png
// https://i.ibb.co/hLRzgFF/k6.png
// https://i.ibb.co/gz56nSX/k7.png
