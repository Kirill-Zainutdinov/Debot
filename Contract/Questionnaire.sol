pragma ever-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

contract Questionnaire{

    string public name;

    constructor() {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function setName(string _name)external{
        tvm.accept();
        name = _name;
    }
}

// deployed at 0:68915500557966f202d8966b259a30d063f91c30d07f30d0a41a3e7d80a69331