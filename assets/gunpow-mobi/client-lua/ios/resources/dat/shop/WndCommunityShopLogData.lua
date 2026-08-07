--WndCommunityShopLogData.lua
--@brief	WndCommunityShopLog的数据模块
--@date		2017/02/16
--@author	qixiang
--@note		公会商店日志

WndCommunityShopLog = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityShopLog:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_logType = nil
	self.m_createTime = nil
	self.m_objId = nil 
	self.m_objName = nil 
	self.m_itemId = nil
	self.m_itemNum = nil

	self.m_nCurLogType = 0

	self.m_tStorageLog = nil --存储日志
	self.m_tCommunityShopLog = nil  --公会商店日志

	self.m_callbackLua = nil
	self.m_callbackFun = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityShopLog:_unInit()
	self.m_root = nil
	self.m_logType = nil
	self.m_createTime = nil
	self.m_objId = nil 
	self.m_objName = nil 
	self.m_itemId = nil
	self.m_itemNum = nil
	self.m_nCurLogType = nil

	self.m_tStorageLog = nil --存储日志
	self.m_tCommunityShopLog = nil  --公会商店日志

	self.m_callbackLua = nil
	self.m_callbackFun = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityShopLog:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityShopLog")
	assert(element, "WndCommunityShopLog create element failed!")
	self:_init()
	return element
end

function WndCommunityShopLog:show(callbackLua,callbackFun)
	-- body
	WZLog("WndCommunityShopLog:show")
	local wndCommunityShopLog = self:createElement()
	WindowManager:addWindow(wndCommunityShopLog,self,nil,true,nil,true)

	self.m_callbackLua = callbackLua
	self.m_callbackFun = callbackFun
end

-- logType : 0存储日志，1购买日志
-- createTime : 事件发生时间
-- objId : 对象ID
-- objName : 对象名称（BOSS的传空值）
-- itemId : 物品id
-- itemNum : 物品数量
function WndCommunityShopLog:setLogInfo(logType, createTime, objId, objName, itemId, itemNum)
	WZLog("WndCommunityShopLog:setLogInfo")
	if not self.m_root  then return end
	self.m_logType = logType
	self.m_createTime = createTime
	self.m_objId = objId 
	self.m_objName = objName 
	self.m_itemId = itemId
	self.m_itemNum = itemNum

    self.m_tStorageLog = {}
	self.m_tCommunityShopLog = {}
	for i,v in ipairs(logType) do
		if v == 0 then --存储日志
			local temp = {}
			table.insert(temp,createTime[i])
			table.insert(temp,objId[i])
			table.insert(temp,objName[i])
			table.insert(temp,itemId[i])
			table.insert(temp,itemNum[i])
			table.insert(self.m_tStorageLog,temp)
		elseif v == 1 then --公会商店日志
			local temp = {}
			table.insert(temp,createTime[i])
			table.insert(temp,objId[i])
			table.insert(temp,objName[i])
			table.insert(temp,itemId[i])
			table.insert(temp,itemNum[i])
			table.insert(self.m_tCommunityShopLog,temp)
		end
	end

	self:updateLog()

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
