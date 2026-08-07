--WndOneActivityRuleData.lua
--@brief	WndOneActivityRule的数据模块
--@date		2020/07/05
--@author	yrd
--@note		一元充活动规则

WndOneActivityRule = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndOneActivityRule:_init()
	self.m_root = nil  			--Cell的根节点
    self.m_nType = nil
    self.m_sDesc = nil
    self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndOneActivityRule:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.m_sDesc = nil
    self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndOneActivityRule:createElement()
	WZLog("WndOneActivityRule:createElement")
	local element = WZUISystem:getInstance():createElement("WndOneActivityRule")
	assert(element, "WndOneActivityRule create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
--@param 	nType:1只有文字,2带确认按钮,3"幸运码"按钮,4"往期回顾"按钮
--@param 	sTitle:标题文字
--@param 	sDesc:内容文字
function WndOneActivityRule:showInterface(nType,sTitle,sDesc)
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
    local wndOneActivityRule = WndOneActivityRule:createElement()
    if wndOneActivityRule then
        WindowManager:addWindow(wndOneActivityRule, WndOneActivityRule,nil,nil,nil,false)
    end

    self.m_nType = nType
    self.m_sTitle = sTitle
    self.m_sDesc = sDesc

    self:_initUI()
end

--@brief    获取我的幸运码协议成功
function WndOneActivityRule:getOneYuanMyLuckyCodeOk(luckyCode)
	self:_showMyCode(luckyCode)
end

--@brief    获取往期回顾协议成功
function WndOneActivityRule:getOneYuanLuckyWinRecordOk(date, playerId, nickname, headId, headColor, faceId, sex, rewardCount, itemId, itemNum, luckyCode)
	self.m_tData = {}

	itemIndex = 1
	for i=1,#date do
		local tmepData = {}
		tmepData.date = date[i]
		tmepData.playerId = playerId[i]
		tmepData.nickname = nickname[i]
		tmepData.headId = headId[i]
		tmepData.headColor = headColor[i]
		tmepData.faceId = faceId[i]
		tmepData.sex = sex[i]

		local tItem = {}
        for j=1,rewardCount[i] do
        	if itemId[itemIndex] ~= -1 then
	        	local itemInfo = GDatatab_item["id_"..itemId[itemIndex]]
	        	if itemInfo.sex == 2 or itemInfo.sex == sex[i] then
		            local t_item = {id=itemId[itemIndex],num=itemNum[itemIndex]}
		            table.insert(tItem,t_item)
		        end
		    end

	        itemIndex = itemIndex + 1
        end
		tmepData.item = tItem

		tmepData.luckyCode = luckyCode[i]
		table.insert(self.m_tData,tmepData)
	end
	table.sort(self.m_tData,function (a,b)
		return a.date>b.date
	end)
	self:_showWinnerLog()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
