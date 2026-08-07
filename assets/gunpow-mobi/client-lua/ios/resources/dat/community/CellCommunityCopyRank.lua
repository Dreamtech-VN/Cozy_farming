--CellCommunityCopyRank.lua
--@brief	CellCommunityCopyRank的UI模块
--@date		2017/11/22
--@author	zsq
--@note		公会副本伤害排名


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityCopyRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityCopyRank:onExit(element)
	self:_unInit()
end

function CellCommunityCopyRank:setData(tData) 
	self.m_tData = tData	
end

function CellCommunityCopyRank:onCheck(element) 
	WZLog("CellCommunityCopyRank:onCheck", self.m_tData.playerId)
	WndCheckOther:show(self.m_tData.playerId)	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCommunityCopyRank:onLoadData() 
	WZLog("CellCommunityCopyRank:onLoadData")
	local element = WZUISystem:getInstance():createElement("CellCommunityCopyRank")
	assert(element, "CellCommunityCopyRank element create failed!")
    self.m_root:addChild(element)
	element:setLuaObjectIndex(self)

	--{playerId=19521,rank=1,name="名字1",faceId=4308,headId=4180,headColor=0,sex=0,level=30,vipLevel=6,hurt=500,percent=10},	
	local tData = self.m_tData

	--排名前三显示图片
	local picName = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
   	GetElement(self.m_root, "imgName_CellCommunityList", WZUIImage):setVisible(false)
	if tonumber(tData.rank) ~= nil and tonumber(tData.rank) >= 1 and tonumber(tData.rank) <= 3 then
    	GetElement(self.m_root, "imgName_CellCommunityList", WZUIImage):setVisible(true)
    	GetElement(self.m_root, "imgName_CellCommunityList", WZUIImage):setFile(picName[tonumber(tData.rank)])
	end
	--排名
	GetElement(self.m_root,"txtRanking_CellCommunityMemberList",WZUILabelTTF):setText(tData.rank)
	--等级
	GetElement(self.m_root,"txtLevel_CellCommunityMemberList",WZUILabelTTF):setText(LocalStrings.LV..tData.level)
	--名字
	GetElement(self.m_root,"txtPlayerName_CellCommunityMemberList",WZUILabelTTF):setText(tData.name)
	--伤害
	GetElement(self.m_root,"txtHurt",WZUILabelTTF):setText(tData.hurt)
	--百分比
	GetElement(self.m_root,"txtPercent",WZUILabelTTF):setText(tData.percent)

	--头像
	local conHead = GetElement(self.m_root,"conHead_Cell",WZUIContainer)
	local imgHead = CellHead:show(conHead, tData.headId, tData.faceId, tData.sex, nil, GlobalMethod:ccp(0.54,0.29), tData.vipLevel, tData.headColor)
	imgHead:setScale(1.25)

	if tData.playerId == CacheCenter:getPlayerInfo().id then
		self:setGreen()
	end
end

--@brief	把底图设置成绿色
function CellCommunityCopyRank:setGreen()
	GetElement(self.m_root, "imgBtn1_CellCommunityMemberList", WZUI9Image):setFile("ui/common/common_scale9_di38.png")
	GetElement(self.m_root, "imgBtn2_CellCommunityMemberList", WZUI9Image):setFile("ui/common/common_scale9_di38.png")
end




-------------------------------------私有方法模块End----------------------------------------
