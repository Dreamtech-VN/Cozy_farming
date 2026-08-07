--ProtocolProcessorBase.lua
--@brief	协议处理基类
--@date  	2013/12/05
--@author 	SuYuan
--@note 	协议处理基类，所有的协议处理类都必须继承该类


ProtocolProcessorBase =
{
	m_tProcessorList = nil,
	m_tProcessorListAuto = {},
}


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	new方法
--@param 	无 
--@return	#1:构造的新对象
--@note		构造一个新的ProtocolProcessorBase对象并返回
function ProtocolProcessorBase:new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	tNewObj.m_tProcessorList = {}
	return tNewObj
end

--@brief	注册协议回调函数
--@param 	nMainId:主协议号
--@param 	nSubId:子协议号
--@param 	sCallbackFunc:协议回调函数
--@param 	sDataFormat:数据格式
--@return	无
--@note		为nMainId与nSubId所对应的协议绑定一个回调函数，并说明数据格式
function ProtocolProcessorBase:regProtocolCallbackFunction(nMainId, nSubId, sCallbackFunc, sDataFormat, tFunction)
	if  WBattleGlobal:getCurrent():isReplayGame() then
		BattleMsgReplayGameRecord:regProtocol(nMainId, nSubId, sCallbackFunc, sDataFormat, tFunction)
		return
	end
	if not NetManager:isConnected() then
		--return
	end
	if type(self.m_tProcessorList)~="table" then
		self.m_tProcessorList = {}
	end
	local k = self:_makeKey(nMainId, nSubId, sCallbackFunc, sDataFormat)

	--添加loading管理
	ProtocolProcessorBase:addProcessorListAuto(k,nMainId,nSubId,sDataFormat)
	
	if nil == self.m_tProcessorList[k] then
		self.m_tProcessorList[k] = k
		Protocol:reg(nMainId, nSubId, sCallbackFunc, sDataFormat)		
	end

	--观战
	if SceneBattle and SceneBattle.m_root and WBattleGlobal:getCurrent():isAudience() then
		BattleAudienceManager:regProtocol(nMainId, nSubId, sCallbackFunc, sDataFormat, tFunction)
	end
end

--@brief	反注册协议回调函数
--@param 	nMainId:主协议号
--@param 	nSubId:子协议号
--@param 	sCallbackFunc:协议回调函数
--@param 	sDataFormat:数据格式
--@return	无
--@note		反注册协议回调函数
function ProtocolProcessorBase:unregProtocolCallbackFunction(nMainId, nSubId, sCallbackFunc, sDataFormat)
	if not NetManager:isConnected() then
		--return
	end
	if type(self.m_tProcessorList)~="table" then
		return
	end
	local k = self:_makeKey(nMainId, nSubId, sCallbackFunc, sDataFormat)
	if self.m_tProcessorList[k] ~= nil then
		Protocol:unreg(nMainId, nSubId, sCallbackFunc, sDataFormat)
		
		self.m_tProcessorList[k] = nil
	end

	--移除loading管理
	ProtocolProcessorBase:removeProcessorListAuto(k,nMainId,nSubId)
end

--@brief	清空协议回调函数
--@param 	无
--@return	无
--@note		反注册所有的协议回调函数
function ProtocolProcessorBase:clearReg()
	if type(self.m_tProcessorList)~="table" then
		return
	end
	for k, v in pairs(self.m_tProcessorList) do
		if k~=nil and v~=nil then
			local l = SplitStringWithSeparator(v, "-")
			Protocol:unreg(l[1], l[2], l[3], l[4])

			--移除loading管理
			ProtocolProcessorBase:removeProcessorListAuto(k, l[1], l[2])
		end
	end
	
	self.m_tProcessorList = nil
end


--@brief 自动管理loading注册
function ProtocolProcessorBase:addProcessorListAuto(key,nMainId, nSubId,sDataFormat)
	if Protocol:isAutoLoadingMsgBox(nMainId, nSubId) then
		if nil == ProtocolProcessorBase.m_tProcessorListAuto[key] then
			ProtocolProcessorBase.m_tProcessorListAuto[key] = 0
		end
		ProtocolProcessorBase.m_tProcessorListAuto[key] = ProtocolProcessorBase.m_tProcessorListAuto[key] + 1
		Protocol:reg(nMainId, nSubId,"MsgBoxManager:protocolCallBack",sDataFormat)
	end
end

--@brief 自动管理loading移除
function ProtocolProcessorBase:removeProcessorListAuto(key,nMainId, nSubId)
	if Protocol:isAutoLoadingMsgBox(nMainId, nSubId) then
		if ProtocolProcessorBase.m_tProcessorListAuto and ProtocolProcessorBase.m_tProcessorListAuto[key] then
			ProtocolProcessorBase.m_tProcessorListAuto[key] = ProtocolProcessorBase.m_tProcessorListAuto[key] - 1
			if ProtocolProcessorBase.m_tProcessorListAuto[key] == 0 then
				Protocol:unreg(nMainId, nSubId,"MsgBoxManager:protocolCallBack",sDataFormat)
				ProtocolProcessorBase.m_tProcessorListAuto[key] = nil
			end
		end
	end
end
-------------------------------------公有方法模块End--------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	返回key值
--@param 	nMainId:主协议号
--@param 	nSubId:子协议号
--@param 	sCallbackFunc:协议回调函数
--@param 	sDataFormat:数据格式
--@return	#1:nMainId, nSubId, sCallbackFunc, sDataFormat以字符串形式组成的key
--@note		返回nMainId, nSubId, sCallbackFunc, sDataFormat以字符串形式组成的key值
function ProtocolProcessorBase:_makeKey(nMainId, nSubId, sCallbackFunc, sDataFormat)
	return tostring(nMainId).."-"..tostring(nSubId).."-"..tostring(sCallbackFunc).."-"..tostring(sDataFormat)
end

function ProtocolProcessorBase:_makeKeyAuto(nMainId, nSubId, sCallbackFunc, sDataFormat)
	return tostring(nMainId).."-"..tostring(nSubId).."-"..tostring(sCallbackFunc).."-"..tostring(sDataFormat)
end

-------------------------------------私有方法模块End--------------------------------------



