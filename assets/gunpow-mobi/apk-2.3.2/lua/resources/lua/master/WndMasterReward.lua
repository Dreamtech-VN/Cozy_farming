--WndMasterReward.lua
--@brief	WndMasterReward的UI模块
--@date		2015/05/27
--@author	zsq
--@note		师徒奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterReward:onEnter(element)
	self.m_root = element
	--人物形象
	self:update()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterReward:onExit(element)
	self:_unInit()
end

function WndMasterReward:onTouchBegan()
	WZLog("WndMasterReward:onTouchBegan")

end

--@brief	弹出tips
function WndMasterReward:onTip(element)
	if CacheCenter:getPlayerInfo().level < MASTERLEVEL then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local con = GetElement(self.m_root,"conMasterReward",WZUIContainer)

	local level = CacheCenter:getPlayerInfo().myMoralityLevel
	local icon = "ui/bag/bag_icon_shitu.png"
	local quality = -1
	local title1 = string.format(LocalStrings.RANK_KING_DESC11,level)
	local title2 = ""
	local attr1
	local attr2
	local attr3
	local attrVal1
	local attrVal2
	local attrVal3
	local text = [[<T C="255,227,116" S="20" P="0">   %s</T><T C="99,255,95" S="20" P="0">    +%d</T>]]

	if tostring(level) ~= "0" then
		tData = GDatatab_morality["id_"..level]
		title2 = [[<T C="255,121,31" S="20" P="0">]]..tData.title..[[</T>]]
		attr1 = ATTR_TITLE[tData.buff[1][1]]
		attr2 = ATTR_TITLE[tData.buff[2][1]]
		attr3 = ATTR_TITLE[tData.buff[3][1]]
		attrVal1 = tData.buff[1][2]
		attrVal2 = tData.buff[2][2]
		attrVal3 = tData.buff[3][2]
	else
		title = LocalStrings.TIPS9
		local tData = {icon=icon,
			title=title,
			level=nil,
			scale=0.5
			}
		WndTips:show(element,con,1,tData,GlobalMethod:ccp(280,-15))
		return
	end
	local tData = {icon=icon,
		title1=title1,
		title2=title2,
		quality=quality,
		attr1=attr1,
		attr2=attr2,
		attr3=attr3,
		attrVal1=attrVal1,
		attrVal2=attrVal2,
		attrVal3=attrVal3,
		level=level,
		text=text,
		py=0.74,
		}
	WndTips:show(element,con,8,tData,GlobalMethod:ccp(-150,-69))
end
--@brief	点击上一关按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndMasterReward:onPrev(element)
    WZLog("WndMasterReward:onPrev",self.m_nCurPageIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nCurPageIndex > 0 then
        self.m_nCurPageIndex = self.m_nCurPageIndex - 1
		self:setCurrentPageIndex(self.m_nCurPageIndex)
    else
        --提示
    end
end

--@brief	点击下一关按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndMasterReward:onNext(element)
    WZLog("WndMasterReward:onNext",self.m_nCurPageIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nCurPageIndex < GetTableLen(GDatatab_morality)-1 then
        self.m_nCurPageIndex = self.m_nCurPageIndex + 1
		self:setCurrentPageIndex(self.m_nCurPageIndex)
    else
        --提示
    end
end

--@brief	翻页时被调用的函数
--@param    nIndex:当前序号
function WndMasterReward:onPageChanged(nIndex)
    WZLog("WndMasterReward:onPageChanged", nIndex)
    self:_setCurrentPageIndex(nIndex)
    self:_updatePagination(nIndex) --更新页数标记
end

--@brief	设置当前页数
--@param    nIndex:页数
function WndMasterReward:_setCurrentPageIndex(nIndex)
    if self.m_root == nil then
        return
    end
    self.m_nCurPageIndex = nIndex
end

--@brief	设置当前显示哪页
--@param	nPageIndex,当前页数
function WndMasterReward:setCurrentPageIndex(nPageIndex)
	WZLog("WndMasterReward:setCurrentPageIndex",nPageIndex)
    if self.m_root == nil then
        return
    end
    local pgconCopy = GetElement(self.m_root, "pgconCopy_WndMasterReward", WZUIPageContainer)
    pgconCopy:setDefaultCenterPage(nPageIndex)
    self:_setCurrentPageIndex(nPageIndex)
   	self:_updatePagination(nPageIndex) --更新页数标记

end

--@brief	初始化页数标记
function WndMasterReward:_initPagination()
	WZLog("WndMasterReward:_initPagination")
    local conPagination = GetElement(self.m_root, "conPagination_WndMasterReward", WZUIContainer)
    local nOffset = 5
    local size = GetElement(self.m_root, "imgPagination_WndMasterReward"):getContentSize()
    local nX = 0
    local nY = 15
    for i = 0, GetTableLen(GDatatab_morality)-1 do
        local img = CreateElement("imgPagination_WndMasterReward")
        img:setVisible(true)
        nX = i*(size.width+nOffset)
        img:setAbsPosition(GlobalMethod:ccp(nX,nY))
        img:setName("imgPagination"..i.."_WndMasterReward")
        conPagination:addChild(img)
    end
    conPagination:setContentSize(GlobalMethod:CCSize(size.width*self.m_nPageNum + nOffset*(self.m_nPageNum-1),nY*2))
    local firstImg = GetElementWithoutAssert(conPagination, "imgPagination0_WndMasterReward", WZUIImage)
    if firstImg then
        firstImg:setFile("ui/common/common_icon_diandian2.png")
	end
end

--@brief	更新页数标记
--@param    nCurPageIndex:当前页数
function WndMasterReward:_updatePagination(nCurPageIndex)
    local conPagination = GetElement(self.m_root, "conPagination_WndMasterReward", WZUIContainer)
    for i = 0, GetTableLen(GDatatab_morality)-1 do
        local img = GetElementWithoutAssert(conPagination, "imgPagination"..i.."_WndMasterReward", WZUIImage)
        if img then
            if i == nCurPageIndex then
                img:setFile("ui/common/common_icon_diandian2.png")
            else
                img:setFile("ui/common/common_icon_diandian3.png")
            end
        end
    end
	if nCurPageIndex == 0 then
		GetElement(self.m_root,"btnPrev",WZUIButton):setVisible(false)
	else
		GetElement(self.m_root,"btnPrev",WZUIButton):setVisible(true)
	end
	if nCurPageIndex == GetTableLen(GDatatab_morality)-1 then
		GetElement(self.m_root,"btnNext",WZUIButton):setVisible(false)
	else
		GetElement(self.m_root,"btnNext",WZUIButton):setVisible(true)
	end
end
--师傅和徒弟的奖励切换
function WndMasterReward:onBtnChangeReward()
	local level = CacheCenter:getPlayerInfo().level
	if level < 35 then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT85)
		return
	end
	GetElement(self.m_root,"conMasterReward",WZUIContainer):setVisible(self.m_nShowRewardType == 1)
	GetElement(self.m_root,"conDiscipleReward",WZUIContainer):setVisible(self.m_nShowRewardType == 2)
	local txtChangeReward = GetElement(self.m_root,"txtChangeReward",WZUILabelTTF)
	--1师傅 2徒弟
	if self.m_nShowRewardType == 1 then
		txtChangeReward:setText(LocalStrings.PUPIL_REWARD)
		self:updateMasterReward()
		self.m_nShowRewardType = 2
	elseif self.m_nShowRewardType == 2 then
		txtChangeReward:setText(LocalStrings.OPTIMIZE_TEXT90)
		self:updateDiscipleReward()
		self.m_nShowRewardType = 1
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示自己人物形象
function WndMasterReward:update()
	local tData = CopyTable(CacheCenter:getPlayerInfo())
	tData.headId = 0
	tData.faceId = 0
	tData.bodyId = 0
	tData.wingId = 0
	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local attrName = {[1]="headId",[2]="faceId",[3]="bodyId",[4]="wingId"}
	local equipmentList = CacheCenter:getEquipmentList()
	local sTitle = ""
	if tData.level >= MASTERLEVEL and CacheCenter:getMasterInfo() ~= nil and CacheCenter:getMasterInfo().moralityLevel ~= nil and CacheCenter:getMasterInfo().moralityLevel > 0 then
		sTitle = "<"..GDatatab_morality["id_"..CacheCenter:getMasterInfo().moralityLevel].title..">"
	end

	for i=1,4 do
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] and equipmentList[j].isUse == true then
   				tData[attrName[i]] = equipmentList[j].id
			end
		end
	end

	local name_MasterReward = GetElement(self.m_root,"name_MasterReward",WZUILabelTTF)
	name_MasterReward:setText(sTitle)
	local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
	tData.headColor = headColor
	tData.bodyColor = bodyColor
	local conMaster = GetElement(self.m_root,"conMaster",WZUIContainer)
	local celElement1,tCell1 = CellMasterSeat:createElement()
	conMaster:addChild(celElement1)
	tCell1:setMasterSeat(tData,4)
	tCell1.m_tParentWnd = self
	local txtChangeReward = GetElement(self.m_root,"txtChangeReward",WZUILabelTTF)
	if tData.level < 35 then
		txtChangeReward:setText(LocalStrings.OPTIMIZE_TEXT90)
		self:updateDiscipleReward()
		self.m_nShowRewardType = 1
	else
		txtChangeReward:setText(LocalStrings.PUPIL_REWARD)
		self:updateMasterReward()
		self.m_nShowRewardType = 2
	end
end

--@brief	初始化师傅奖励界面
function WndMasterReward:updateMasterReward()
    if self.m_root == nil then
        return
    end
    --显示师德信息条
	GetElement(self.m_root,"conInfo_WndMasterReward",WZUIContainer):setVisible(true)
	if self.m_bInit then return end

	local tag = 0
	local key_table = {} 					    
    local pgconCopy = GetElement(self.m_root, "pgconCopy_WndMasterReward", WZUIPageContainer)
	--取出所有的键  
	for key,_ in pairs(GDatatab_morality) do  
		local numKey = tonumber(string.sub(key,4))
	    table.insert(key_table,numKey)  
	end  
	self.m_nPageNum = #key_table
	--对所有键进行排序  
	table.sort(key_table)  
	for _,key in pairs(key_table) do  
		if GDatatab_morality["id_"..key].reward ~= 0 and GDatatab_morality["id_"..key].reward ~= "0" then
	    	local eCellLevel, tCellLevel = CellMasterReward:createElement()
			eCellLevel:setTag(tag)
			local id = "id_"..key
			tCellLevel:setCellMasterReward(id)
        	pgconCopy:setPageElement(eCellLevel)
			tag = tag + 1
		end
	end
    self:_initPagination()
    
	local moralityLevel = CacheCenter:getMasterInfo().moralityLevel
	local moralityExp = CacheCenter:getMasterInfo().moralityExp
	WZLog("师德值和等级",moralityExp,moralityLevel)
	local exp = 0
	if tonumber(moralityLevel) < GetTableLen(GDatatab_morality) then
		exp = GDatatab_morality["id_"..(moralityLevel+1)].exp
	end
    --设置当前显示师德等级
	GetElement(self.m_root,"numIcon_WndMasterReward",WZUILabelAtlasFont):setText(moralityLevel)
	self:setCurrentPageIndex(moralityLevel-1)
	if tonumber(moralityLevel) == 0 then
		self:setCurrentPageIndex(0)
	end
	if CacheCenter:getPlayerInfo().level >= MASTERLEVEL and tonumber(moralityLevel) == 0 then
		GetElement(self.m_root,"numIcon_WndMasterReward",WZUILabelAtlasFont):setText(1)
	end
	--设置师德经验
	local expPer = GetElement(self.m_root, "expPer_MasterReward", WZUILabelTTF)
	expPer:setText(moralityExp.."/"..exp)
	--设置经验条
	local progrExpProgress = GetElement(self.m_root,"progrExpProgress_MasterReward",WZUIProgress)
	if tostring(exp) ~= "0" then
		local percent = tonumber(moralityExp)*100/tonumber(exp)
		progrExpProgress:setPercentage(percent)
	else
		progrExpProgress:setPercentage(0)
	end
	if tonumber(moralityLevel) == GetTableLen(GDatatab_morality) then
		expPer:setText(moralityExp.."/max")
		progrExpProgress:setPercentage(0)
	end

	GetElement(self.m_root, "conMasterReward", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conDiscipleReward", WZUIContainer):setVisible(false)

	self.m_bInit = true
end

function WndMasterReward:updatemorality(tExp,tLevel)
	-- body
	local exp = 0 
	if tLevel < GetTableLen(GDatatab_morality) then
		exp = GDatatab_morality["id_"..(tLevel+1)].exp
	end
	--师德等级
	GetElement(self.m_root,"numIcon_WndMasterReward",WZUILabelAtlasFont):setText(tLevel)
	--师德经验
	local expPer = GetElement(self.m_root, "expPer_MasterReward", WZUILabelTTF)
	expPer:setText(tExp.."/"..exp)
	--师德进度条
	--设置经验条
	local progrExpProgress = GetElement(self.m_root,"progrExpProgress_MasterReward",WZUIProgress)
	if tostring(exp) ~= "0" then
		local percent = tonumber(tExp)*100/tonumber(exp)
		progrExpProgress:setPercentage(percent)
	else
		progrExpProgress:setPercentage(0)
	end
	if tonumber(tLevel) == GetTableLen(GDatatab_morality) then
		expPer:setText(tExp.."/max")
		progrExpProgress:setPercentage(0)
	end	
end

--@brief	徒弟奖励
function WndMasterReward:updateDiscipleReward()
	if not self.m_root then return end

	--不显示师德信息条
	GetElement(self.m_root,"conInfo_WndMasterReward",WZUIContainer):setVisible(false)
    local tabCon = GetElement(self.m_root, "tbConDiscipleReward", WZUITableContainer)
	tabCon:cleanTable()

	local tag = 0
	if tabCon ~= nil then 
		local key_table = {}  
		--取出所有的键  
		for key,_ in pairs(GDatatab_pupil_reward) do  
		  table.insert(key_table,key)  
		end  
		--对所有键进行排序  
		table.sort(key_table)  
		for _,key in pairs(key_table) do  
		    local celElement,tLuaObj = CellMasterReward1:createElement()
            if celElement ~= nil then 
		     	celElement = WZUIContainer:luaTo(celElement)
                celElement:setTag(tag)
                tabCon:setCellElement(celElement)
		     	tLuaObj:setCellMasterReward1(key)
            end
			tag = tag + 1
		end
	end 

    GetElement(self.m_root, "txtRewardName_WndMasterReward", WZUILabelTTF):setText(LocalStrings.PUPIL_REWARD)

	GetElement(self.m_root, "conMasterReward", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conDiscipleReward", WZUIContainer):setVisible(true)
end



-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndMasterReward:_adaptLanguage_vn()
	GetElement(self.m_root,"txtChangeReward",WZUILabelTTF):setFontSize(18)
end

-------------------------------------语言适配End----------------------------------------