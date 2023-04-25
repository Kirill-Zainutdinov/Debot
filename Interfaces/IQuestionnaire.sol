pragma ever-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

interface IQuestionnaire {
    function setName (string) external;
    function name()external returns(string);
}