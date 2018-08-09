genesis.json文件的键说明：

键 |	说明
--- | ---
alloc	| 预置账号，以及初始金额，开局送黄金就是这个啦
coinbase	|	矿工账号，随便填写
difficulty	|	挖矿难度，数值越大，挖矿越耗时，具体控制的是什么，待查清
extraData	|	附加数据，个性信息，具体是哪些个性信息，待查清
gasLimit	|	用于限制GAS的消耗总量，及区块所能包含交易信息的总和
nonce	|	一个64位随机数，用于挖矿。注意该值与mixhash的设置必须满足以太坊黄皮书4.3.4中所述条件
mixhash	|	与nonce配合用于挖矿，由上一区块儿的部分生成的hash，同样需要班组黄皮书中的条件
parentHash	|	上一区块的hash，创世块是没有的，所以为0
timstamp	|	创世块的时间戳