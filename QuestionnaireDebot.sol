pragma ton-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

import "libraries/Debot.sol";
import "interfaces/Terminal.sol";
import "interfaces/IQuestionnaire.sol";

contract HelloDebot is Debot {

    address public qAddress;

    constructor(address _qAddress) public{
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        qAddress = _qAddress;
    }

    function setQAddress(address _qAddress) public {
        tvm.accept();
        qAddress = _qAddress;
    }

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string caption, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Questionnaire";
        version = "0.1.0";
        publisher = "MSHP";
        caption = "Student survey";
        author = "Kirill Zaynutdinov";
        support = address.makeAddrStd(0, 0x0);
        hello = "Hello, i am a Questionnaire DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = "";
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID ];
    }

    function start() public override {
        Terminal.input(tvm.functionId(dSetName), "What is your name?", false);
    }

    function dSetName(string value) public view{
        optional(uint256) pubkey = 0;
        IQuestionnaire(qAddress).setName
        {
            sign: true,
            pubkey: pubkey,
            time: uint64(block.timestamp),
            expire: 0,
            callbackId: tvm.functionId(dGetName),
            onErrorId: tvm.functionId(onError)
        }(value).extMsg;
    }

    function dGetName() public view{
        optional(uint256) none;
        IQuestionnaire(qAddress).name
        {
            sign: false,
            pubkey: none,
            time: uint64(block.timestamp),
            expire: 0,
            callbackId: tvm.functionId(greeting),
            onErrorId: tvm.functionId(onError)
        }().extMsg;
    }

    function greeting(string _name)public{
        Terminal.print(0, format("Hello {}!", _name));
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
    }
}

// deployed at 0:3be308aeed27ddcc7193d8eb719e26481824bf8f1d7782f9289a13d5a5a561fc