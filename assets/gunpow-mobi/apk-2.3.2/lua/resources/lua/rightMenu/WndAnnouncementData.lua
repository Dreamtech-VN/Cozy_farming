--WndAnnouncementData.lua
--@brief	WndAnnouncement的数据模块
--@date		2015/04/23
--@author	weidong_wu
--@note		游戏公告页面

WndAnnouncement = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAnnouncement:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tAnnounceList = nil 
	self.m_nLoadingId = 0 
	self.m_nCurrentPage = 1 			--当前页数
	self.m_eleCurSelNode = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAnnouncement:_unInit()
	self.m_root = nil
	self.m_tAnnounceList = nil
	self.m_nLoadingId = 0
	self.m_nCurrentPage = 1 			--当前页数
	self.m_eleCurSelNode = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAnnouncement:createElement()
	local element = WZUISystem:getInstance():createElement("WndAnnouncement")
    assert(element, "WndAnnouncement create element failed!")
    self:_init()
    return element
end


--@brief 接收公告内容
function WndAnnouncement:GetAnnouncementOk( title ,content )
	self.m_tAnnounceList = {}
	for i=1,#title do
		self.m_tAnnounceList[i] = {}
		self.m_tAnnounceList[i].theme = title[i] 
		self.m_tAnnounceList[i].content = content[i]
	end
	self.m_eleCurSelNode = nil
	if  #self.m_tAnnounceList > 0 then 
		local tbContainer = GetElement(self.m_root,"tbContainer_WndAnnouncement",WZUITableContainer)
		tbContainer:cleanTable()
		for i,v in ipairs(self.m_tAnnounceList) do
			local cellNode = WZUISystem:getInstance():createElement("btn_WndAnnouncement")
			cellNode:setTag(i-1)
			cellNode:setVisible(true)
			tbContainer:setCellElement(cellNode)
			local cbNorTxt = GetElement(cellNode,"cbNorTxt_WndAnnouncement",WZUILabelTTF)
			local cbSelTxt = GetElement(cellNode,"cbSelTxt_WndAnnouncement",WZUILabelTTF)
			local cbDisTxt = GetElement(cellNode,"cbDisTxt_WndAnnouncement",WZUILabelTTF)
			cbNorTxt:setText(self.m_tAnnounceList[i].theme)
			cbSelTxt:setText(self.m_tAnnounceList[i].theme)
			cbDisTxt:setText(self.m_tAnnounceList[i].theme)
			if i == 1 then
				cellNode:setTouchEnable(false)
				self.m_eleCurSelNode =cellNode
			end
		end
		self:_setMessagInfo()
	end 
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndAnnouncement:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
