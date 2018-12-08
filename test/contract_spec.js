// /*global contract, config, it, assert*/
/*const SimpleStorage = require('Embark/contracts/SimpleStorage');

config({
  contracts: {
    "SimpleStorage": {
      args: [100]
    }
  }
});

contract("SimpleStorage", function () {
  this.timeout(0);

  it("should set constructor value", async function () {
    let result = await SimpleStorage.methods.storedData().call();
    assert.strictEqual(parseInt(result, 10), 100);
  });

  it("set storage value", async function () {
    await SimpleStorage.methods.set(150).send();
    let result = await SimpleStorage.methods.get().call();
    assert.strictEqual(parseInt(result, 10), 150);
  });
});*/
const helper = require('Embark/contracts/helper');
//const { soliditySha3 } = require('web3-utils');

let accounts;

config ({
  contracts: {
    "helper" : {

    }
  }
}, (err, theAccounts) => {
  if (err) {
    console.log(err);
  }
  accounts = theAccounts;
  console.log("accounts")
});

contract('helper', function(){
    this.timeout(0);
    var tom = accounts[0];
    var mavis = accounts[1];
    var hx;

    before (async function() {
        hx = await helper.new()
    });
    it("helper test signing", async function() {
        
            
            let message = "13 December 2018";
                
            let hash = soliditySha3(message);
            let sig = await web3.eth.sign(mavis, hash);
            let granny = await hx.recoverSig(message, sig)
            console.log(granny);
            console.log(mavis);
            assert.equal(granny ,mavis);
        })
});
