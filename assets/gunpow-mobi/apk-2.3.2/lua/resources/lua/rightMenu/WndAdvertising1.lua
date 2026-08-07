--WndAdvertising1.lua
--@brief	WndAdvertising1的UI模块
--@date		2016/09/12
--@author	zsq
--@note		登录广告


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAdvertising1:onEnter(element)
	self.m_root = element
end

function WndAdvertising1:onEnterTransitionDidFinish(element)
	self.m_root:setVisible(true)
	self.m_nCurPage = 0
	self:update()
	self.m_root:enableSchedule("turnPage", 3)
end

function WndAdvertising1:turnPage()
	local adMessage = CacheCenter:getAdMessage()
    local pgconCopy = GetElement(self.m_root, "pgCon_WndAdvertising1", WZUIPageContainer)
	self.m_nCurPage = pgconCopy:getCurrentPageIndex()
	self.m_nCurPage = self.m_nCurPage + 1
	self.m_nCurPage = self.m_nCurPage % #adMessage
	pgconCopy:setDefaultCenterPage(self.m_nCurPage)
	WZLog("gdskljfkljklk",CacheCenter:getGameParam().isAd,type(CacheCenter:getGameParam().isAd))
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAdvertising1:onExit(element)
	self:_unInit()
end

--@brief	跳转
function WndAdvertising1:onJump()
	WZLog("WndAdvertising1:onJump", self.m_nJumpId, tostring(ProjConfig:getChannelId()))
	if tonumber(self.m_nJumpId) == 222 then
		if tostring(ProjConfig:getChannelId()) ~= "53" and tostring(ProjConfig:getChannelId()) ~= "75" and tostring(ProjConfig:getChannelId()) ~= "275" and tostring(ProjConfig:getChannelId()) ~= "68" then
			JumpByUIId(self.m_nJumpId)
		end
	else
		JumpByUIId(self.m_nJumpId)
	end
end

function WndAdvertising1:update()
	if self.m_root == nil then return end
    local pgconCopy = GetElement(self.m_root, "pgCon_WndAdvertising1", WZUIPageContainer)
	pgconCopy:removeAll()
    pgconCopy:setMoveActionFinishCallback("onPageChanged")
	--每帧加载一页
	self.m_nCurAddPage = 0
	pgconCopy:enableSchedule("_addPage",0)
end

--@brief	每帧加载一页
function WndAdvertising1:_addPage()
    local pgconCopy = GetElement(self.m_root, "pgCon_WndAdvertising1", WZUIPageContainer)
	local adMessage = CacheCenter:getAdMessage()
	if self.m_nCurAddPage >= #adMessage then
		pgconCopy:disableSchedule()
		return
	end
	if self.m_nCurAddPage < #adMessage then
		local celElement,tCell = CellAdvertising:createElement()
		if celElement ~= nil and tCell ~= nil then 
			WZLog("填充页面1",self.m_nCurAddPage)
			celElement = WZUIContainer:luaTo(celElement)
			local downURL = adMessage[self.m_nCurAddPage + 1].imgUrl
			local jumpTo = adMessage[self.m_nCurAddPage + 1].params
			local ad_type = adMessage[self.m_nCurAddPage + 1].ad_type
			tCell:setData(downURL, jumpTo, self.m_nCurAddPage, ad_type)
			pgconCopy:setPageElement(self.m_nCurAddPage,celElement)
			self.m_nCurAddPage = self.m_nCurAddPage + 1
		end 
		if i == 1 then
			pgconCopy:disableSchedule()
		end
	end
	pgconCopy:setDefaultCenterPage(0)
end

--@brief	翻页时被调用的函数
function WndAdvertising1:onPageChanged()

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------

