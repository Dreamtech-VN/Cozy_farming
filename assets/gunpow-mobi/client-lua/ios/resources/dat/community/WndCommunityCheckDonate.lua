--WndCommunityCheckDonate.lua
--@brief	WndCommunityCheckDonate的UI模块
--@date		2016/05/03
--@author	zsq
--@note		查看公会成员贡献


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityCheckDonate:onEnter(element)
	self.m_root = element
end

--@brief    onenter函数已执行
function WndCommunityCheckDonate:onEnterTransitionDidFinish(element)
	self.m_nTag = 1
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "update", self)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityCheckDonate:onExit(element)
	self:_unInit()
end

--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
function WndCommunityCheckDonate:onTouchBegan(element, point)
	if self.m_root == nil then return end 
	local bFlag = WndPopupMenu:ifPointInMenu(point)
	if bFlag == false then WndPopupMenu:delMenu() end 
end

--@brief	关闭按钮
function WndCommunityCheckDonate:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityCheckDonate, true)
	end 
end

--@brief	点击总贡献
function WndCommunityCheckDonate:onCheck(element)
	WZLog("WndCommunityCheckDonate:onCheck1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	self.m_nTag = tag

	--刷新界面
	self:update()

	--设置标签
	for i=1,3 do
		GetElement(self.m_root,"imgTab"..i,WZUI9Image):setVisible(false)
		GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF):setVisible(false)
	end

	GetElement(self.m_root,"imgTab"..tag,WZUI9Image):setVisible(true)
	GetElement(self.m_root,"txtTab"..tag.."Sel",WZUILabelTTF):setVisible(true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function WndCommunityCheckDonate:update()
	if SceneMemberList == nil or SceneMemberList.m_tMemberList == nil then return end
	self.m_tCellList = {}
	self.m_tDataList = CopyTable(SceneMemberList.m_tMemberList)
	local freeListContainer = GetElement(self.m_root,"freeconText_Wnd",WZUIFreeListContainer)
	freeListContainer:setLoadCountPerFrame(2)
	freeListContainer:removeAll()

	for i=1,#self.m_tDataList do
		if self.m_tDataList[i].playerId == CacheCenter:getPlayerInfo().id then
			self.m_tDataList[i].first = 1
		else
			self.m_tDataList[i].first = 0
		end
	end
	if self.m_nTag == 1 then
		table.sort(self.m_tDataList,_sortCheckDonate1)
	elseif self.m_nTag == 2 then
		table.sort(self.m_tDataList,_sortCheckDonate2)
	elseif self.m_nTag == 3 then
		table.sort(self.m_tDataList,_sortCheckDonate3)
	end
	for i=1,#self.m_tDataList do
		local celElement,tCell = CellCommunityCheckDonate:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			freeListContainer:pushBack(celElement)
			tCell:setData(self.m_tDataList[i])
			self.m_tCellList[i] = tCell
		end 
	end
 	local moveElement = freeListContainer:getMoveElement()
 	moveElement:setPositionY(freeListContainer:getMinPosition().y)
end

function _sortCheckDonate1(a,b)
	if a.first ~= b.first then
		return a.first > b.first
	else
		if a.allDonate ~= b.allDonate then
			return a.allDonate > b.allDonate
		else
			return a.playerId < b.playerId
		end	
	end
end

function _sortCheckDonate2(a,b)
	if a.first ~= b.first then
		return a.first > b.first
	else
		if a.weekDonate ~= b.weekDonate then
			return a.weekDonate > b.weekDonate
		else
			return a.playerId < b.playerId
		end	
	end
end

function _sortCheckDonate3(a,b)
	if a.first ~= b.first then
		return a.first > b.first
	else
		if a.lastDonate ~= b.lastDonate then
			return a.lastDonate > b.lastDonate
		else
			return a.playerId < b.playerId
		end	
	end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin--------------------------------------
function WndCommunityCheckDonate:_adaptLanguage_tr(  )
	for i=1,3 do
		local txtTab = GetElement(self.m_root,"txtTab"..i,WZUILabelTTF)
		local txtTabSel = GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF)
		-- if i == 1 then
		-- 	txtTab:setDimensions(GlobalMethod:CCSize(150,0))
		-- 	txtTab:setScale(0.55)
		-- 	txtTabSel:setDimensions(GlobalMethod:CCSize(130,0))
		-- 	txtTabSel:setScale(0.55)
		-- else
			txtTab:setDimensions(GlobalMethod:CCSize(150,0))
			txtTab:setScale(0.55)
			txtTabSel:setDimensions(GlobalMethod:CCSize(150,0))
			txtTabSel:setScale(0.55)
		--end
	end
	local txtLabel = GetElement(self.m_root,"txtLabel5",WZUILabelTTF)
	txtLabel:setDimensions(GlobalMethod:CCSize(180,0))
	txtLabel:setScale(0.8)
end

function WndCommunityCheckDonate:_adaptLanguage_es(  )
	for i=1,2 do
		local txtTab = GetElement(self.m_root,"txtTab"..i,WZUILabelTTF)
		txtTab:setDimensions(GlobalMethod:CCSize(100,0))
		txtTab:setScale(0.7)
		local txtTabSel = GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF)
		txtTabSel:setDimensions(GlobalMethod:CCSize(100,0))
		txtTabSel:setScale(0.7)
	end
	local txtTab3 = GetElement(self.m_root,"txtTab3",WZUILabelTTF)
	txtTab3:setDimensions(GlobalMethod:CCSize(160,0))
	txtTab3:setScale(0.5)
	local txtTabSel3 = GetElement(self.m_root,"txtTab3Sel",WZUILabelTTF)
	txtTabSel3:setDimensions(GlobalMethod:CCSize(160,0))
	txtTabSel3:setScale(0.5)
	GetElement(self.m_root,"txtLabel4",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtLabel5",WZUILabelTTF):setScale(0.8)
end
---------------------------------------语言适配End---------------------------------------