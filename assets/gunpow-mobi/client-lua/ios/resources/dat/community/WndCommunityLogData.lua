--WndCommunityLogData.lua
--@brief	WndCommunityLog的数据模块
--@date		2015/04/28
--@author	zsq
--@note		公会日志

WndCommunityLog = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityLog:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil
	self.username1 = nil
	self.operator1 = nil
	self.action1 = nil
	self.level1 = nil
	self.createTime1 = nil
	self.username2 = nil
	self.costType2 = nil
	self.cost2 = nil
	self.reward2 = nil
	self.createTime2 = nil

	self.pageNumber = 1
	self.totalNumber = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityLog:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.username1 = nil
	self.operator1 = nil
	self.action1 = nil
	self.level1 = nil
	self.createTime1 = nil
	self.username2 = nil
	self.costType2 = nil
	self.cost2 = nil
	self.reward2 = nil
	self.createTime2 = nil

	self.pageNumber = nil
	self.totalNumber = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityLog:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityLog")
	assert(element, "WndCommunityLog create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	保存捐献日志
function WndCommunityLog:setDonateLog(username, costType, cost, reward, createTime)
	WZLog("WndCommunityLog:setDonateLog",Serialize(username),Serialize(costType),Serialize(cost))
	self.username2 = username
	self.costType2 = costType
	self.cost2 = cost
	self.reward2 = reward
	self.createTime2 = createTime

	self.pageNumber = 1
	self.totalNumber = math.ceil(#self.username2/20)

	self:showDonateLog()
end

--@brief	保存操作日志
function WndCommunityLog:setOperateLog(username, operator, action, level, createTime)
	self.username1 = username
	self.operator1 = operator
	self.action1 = action
	self.level1 = level
	self.createTime1 = createTime

	self.pageNumber = 1
	self.totalNumber = math.ceil(#self.username1/20)

	self:showLog()
end

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndCommunityLog:_getUpPage()
	if self.pageNumber > 1 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndCommunityLog:_getDownPage()
	if self.pageNumber < self.totalNumber then
		return true
	else
		return false
	end
end


-------------------------------------私有方法模块End----------------------------------------
--@brief	英文包适配函数
function WndCommunityLog:_adaptLanguage_en()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtAllSel_WndEquip",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtArmsSel_WndEquip",WZUILabelTTF):setScale(0.5)
end

function WndCommunityLog:_adaptLanguage_pt(  )
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtAllSel_WndEquip",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtArmsSel_WndEquip",WZUILabelTTF):setScale(0.7)
end

--@brief	泰文包适配函数
function WndCommunityLog:_adaptLanguage_th()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtAllSel_WndEquip",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtArmsSel_WndEquip",WZUILabelTTF):setScale(0.5)
end
