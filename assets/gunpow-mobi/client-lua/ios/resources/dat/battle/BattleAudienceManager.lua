--BattleAudienceManager.lua
--@date		2016/06/30
--@author	莫剑峰

BattleAudienceManager =
{
	m_tProtocolPool = nil,	--协议池
	m_tRecordProList = nil,	--回放协议列表
    m_tStartTime = -1,		--协议处理开始时间
    m_tCurTime = -1,		--当前协议时间
    m_tNextTime = -1,		--下一条协议时间
    m_nIndexCur = 0,		--当前Index
    m_nCount = 0,			--当前回合回放总协议数
    m_tTurnRecordList = nil,--所以已接收的回放记录列表
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始管理
function BattleAudienceManager:start()
	WZLog("BattleAudienceManager:start")
	self:_init()
end

--@brief	销毁
function BattleAudienceManager:destroy()
	WZLog("BattleAudienceManager:destroy")
	self.m_tProtocolPool = nil
	self.m_tRecordProList = nil
    self.m_tStartTime = -1
    self.m_tCurTime = -1
    self.m_tNextTime = -1
    self.m_nIndexCur = 0
    self.m_nCount = 0
    self.m_tTurnRecordList = nil
end

--@brief	注册协议
function BattleAudienceManager:regProtocol(mainId, subId, callbackFunc, dataFormat, func)
	WZLog("BattleAudienceManager:regProtocol")
	self.m_tProtocolPool[mainId..subId] = {mainId=mainId, subId=subId, callbackFunc=callbackFunc, dataFormat=dataFormat, func=func}
end

--@brief	分发协议
function BattleAudienceManager:dispatcher(info)
	local func = self.m_tProtocolPool[info.type] and self.m_tProtocolPool[info.type].func
	WZLog("BattleAudienceManager:dispatcher one", info.type, func)
	if func then
		func(ProtocolProcessorSceneBattle, unpack(info.serverRec))
	end
end

--@brief	push回合回放内容
function BattleAudienceManager:push(data)
	WZLog("BattleAudienceManager:push", Serialize(data))
	table.insert(self.m_tTurnRecordList, data)
end

--@brief	更新函数
function BattleAudienceManager:update()
	--WZLog("BattleAudienceManager:process one", self.m_nIndexCur, self.m_nCount, os.time(), self.m_tStartTime, self.m_tNextTime, self.m_tCurTime)
        
	if self.m_nIndexCur == 0 then
		if #self.m_tTurnRecordList == 0 then
			return
		else
			self.m_nCount = #(self.m_tTurnRecordList[1])
			WZLog("BattleAudienceManager:process two",self.m_nCount)
    		self.m_tRecordProList = {}
			for i, info in ipairs (self.m_tTurnRecordList[1]) do
				local protocol = self:parseString(i)
        		table.insert(self.m_tRecordProList, protocol)
        	end
			self:doProtocol()
		end
	end

	if self.m_tNextTime ~= -1 and (os.time() - self.m_tStartTime >= self.m_tNextTime - self.m_tCurTime - 1) then
        self:doProtocol()
    end

    --WZLog("BattleAudienceManager:process three", self.m_nIndexCur, self.m_nCount, os.time(), self.m_tStartTime, self.m_tNextTime, self.m_tCurTime)
        
    if self.m_nIndexCur == self.m_nCount then
    	self.m_nIndexCur = 0
    	table.remove(self.m_tTurnRecordList, 1)
    end
end

--@brief    处理
function BattleAudienceManager:doProtocol()
    self.m_nIndexCur = self.m_nIndexCur + 1
    local protocol = self:parseString(self.m_nIndexCur) --self.m_tRecordProList[self.m_nIndexCur]
    BattleAudienceManager:dispatcher(protocol)
    self.m_tStartTime = os.time()
    self.m_tCurTime = protocol.time / 1000
    self.m_tNextTime = self.m_tRecordProList[self.m_nIndexCur+1] and self.m_tRecordProList[self.m_nIndexCur+1].time / 1000 or -1
    if self.m_tRecordProList[self.m_nIndexCur+1] and self.m_tRecordProList[self.m_nIndexCur+1].type == "7014" then
    	self.m_tNextTime = self.m_tCurTime
    end
    WZLog("BattleAudienceManager:doProtocol", self.m_nIndexCur, self.m_tNextTime, self.m_tCurTime)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化Manager
function BattleAudienceManager:_init()
	self.m_tProtocolPool = {}
	self.m_tTurnRecordList = {}
end

--@brief 解析战斗记录
--@note "#" 分割参数队列  参数结构1;参数结构2;...
--@note "_" 分割参数结构  参数类型[(数组)vec,(普通)def],参数,...
function BattleAudienceManager:parseString(index)
    if not self.m_tTurnRecordList[1] or not self.m_tTurnRecordList[1][index] then
        return nil
    end
    
    local stepJson = json.decode(self.m_tTurnRecordList[1][index])

    WZLog("BattleAudienceManager:parseString_one",Serialize(stepJson))
    local step = {}
    step.type = stepJson.proType
    step.time = stepJson.time

    step.serverRec = {}
    local paramStr = stepJson.param
    if paramStr and paramStr ~= "" then
        local paramList = SplitStringWithSeparator(paramStr, "#")
        for i,v in pairs(paramList) do
            local subParamList = SplitStringWithSeparator(v,"@")
            --类型1 byte,int,short,long,boolean,string
            --类型2 bytes,ints,shorts,longs,booleans,strings
            local typeName = subParamList[1]
            local value = subParamList[2]
            if typeName == "bytes" or typeName == "ints" or typeName == "shorts" 
                or typeName == "longs" or typeName == "booleans" or typeName == "strings" then
                value = self:getParamList(subParamList)
            elseif typeName == "boolean" then
                value = subParamList[2] == "true" and true or false
                
            elseif typeName == "byte" or typeName == "int" or typeName == "short" or typeName == "long" then
                value = tonumber(subParamList[2])
            end
            step.serverRec[i] = value
        end
    end

    WZLog("BattleAudienceManager:parseString_two",Serialize(step))
    
    return step
end

function BattleAudienceManager:getParamList(list)
    local typeName = list[1]
    local paramList = {}
    for i ,v in pairs(list) do
        if v ~= typeName then
            local value = v
            if typeName == "bytes" or typeName == "ints" or typeName == "shorts" or typeName == "longs" then
                value = tonumber(v)
            elseif typeName == "booleans" then
                value = v == "true" and true or false
            end
            table.insert(paramList,value)
        end
    end

    if typeName == "bytes" or typeName == "ints" or typeName == "shorts" or typeName == "longs" then
    	paramList = TableToIntVector(paramList)
    end
    return paramList
end

-------------------------------------私有方法模块End----------------------------------------
