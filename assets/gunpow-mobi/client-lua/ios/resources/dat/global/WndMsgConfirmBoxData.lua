--WndMsgConfirmBoxData.lua
--@brief	WndMsgConfirmBox的数据模块
--@date		2013/12/19
--@author	xiaoyu_wu
--@note		确认取消框模块

WndMsgConfirmBox = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndMsgConfirmBox:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tMsgData = nil		--确认取消框的消息数据表
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMsgConfirmBox:_unInit()
	self.m_root = nil
	self.m_tMsgData = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndMsgConfirmBox:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "WndMsgConfirmBox table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("WndMsgConfirmBox")
	assert(element, "WndMsgConfirmBox element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置确认取消框的消息数据表
--@param	tMsg，消息数据表，定义见MsgBoxManager.lua中MsgData相关定义
--@note		设置确认取消框的消息数据表
function WndMsgConfirmBox:setMsgData(tMsg)
	self.m_tMsgData = tMsg
	self:_update()
end

--@brief	设置复选框数据
--@note		设置复选框数据
function WndMsgConfirmBox:setCheckBoxData()	
	WZLog("WndMsgConfirmBox:setCheckBoxData",Serialize(g_bShowWndMsgConfirmBox))
	-- body
	local text = self.m_tMsgData.sMsgBody
	if self.m_tMsgData.onlyAttKey then 
		text = self.m_tMsgData.onlyAttKey
	end
	if g_bShowWndMsgConfirmBox == nil then g_bShowWndMsgConfirmBox = {} end
    local bIsExist = false 
    for k,v in pairs(g_bShowWndMsgConfirmBox) do
        if v == text then 
            bIsExist = true
            break 
        end
    end
    --没有保存这次提示的句子，加入这句
    if not bIsExist then 
        table.insert(g_bShowWndMsgConfirmBox,text)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndMsgConfirmBox:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	回调给消息数据里的回调方法
--@param	nResType,响应状态，包括超时、确定、取消，具体定义参见定义参见GlobalDefine中消息组件管理相关定义部分
function WndMsgConfirmBox:_msgCallBack(nResType)
	if self.m_tMsgData == nil then
		return
	end
	local checkIndex = GetElement(self.m_root, "checkboxAtt_WndMsgConfirmBox", WZUICheckBox):getCheckIndex()
	if checkIndex == 1 then
		self:setCheckBoxData()	
	end
	if self.m_tMsgData.fCallbackFunc then
		if self.m_tMsgData.tCallbackLuaObj then
			self.m_tMsgData.fCallbackFunc(self.m_tMsgData.tCallbackLuaObj, self.m_tMsgData.nId, nResType)
		else
			self.m_tMsgData.fCallbackFunc(self.m_tMsgData.nId, nResType)
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------
