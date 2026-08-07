--WndPhantomData.lua
--@brief	WndPhantom的数据模块
--@date		2017/04/25
--@author	zsq
--@note		幻化主界面

WndPhantom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPhantom:_init()
	self.m_root = nil	 	  			--场景根节点
	self.conPlayer = nil
	self.m_tSelectedCell = nil
	self.m_tCards = nil
	self.m_bShowAll = true
	self.m_nTab = 1
	self.showId = nil
	self.conPosition3 = nil
	self.m_tCellDressSuit = nil 		--多套时装的cell
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPhantom:_unInit()
	self.m_root = nil
	self.conPlayer = nil
	self.m_tSelectedCell = nil
	self.m_tCards = nil
	self.m_bShowAll = nil
	self.m_nTab = nil
	self.showId = nil
	self.conPosition3 = nil
	self.m_tCellDressSuit = nil 		--多套时装的cell
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPhantom:createElement()
	if WndPhantom.m_root ~= nil then
		WindowManager:removeWindow(WndPhantom.m_root, WndPhantom, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPhantom")
	assert(element, "WndPhantom create element failed!")
	self:_init()
	return element
end

--@brief    更新多套时装数据
function WndPhantom:updateDressSuitData(nType)
    -- body
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
    	self.m_tCellDressSuit:changeDressSuitOK()
    else
    	self.m_tCellDressSuit:setSuitData()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPhantom:setData(shapeId, remainTime, useShapeId, show, shapeLeve, shapeExp)
	self.useShapeId = useShapeId
	self.show = show
	self.shapeLeve = shapeLeve
	self.shapeExp = shapeExp

	CacheCenter:getPlayerInfo().shapeId = useShapeId
	CacheCenter:getPlayerInfo().shapeLevel = shapeLeve

	self.m_tDataList = {}

	for i=1,#shapeId do
		local tempList = {}
		tempList.shapeId = shapeId[i]
		tempList.remainTime = remainTime[i]
		table.insert(self.m_tDataList,tempList)
	end

	WZLog("WndPhantom:setData", Serialize(self.m_tDataList))
	self:_update()
	self:showPlayer()
end

function WndPhantom:showUseCard() 
		WZLog("WndPhantom:showUseCard")
	GetElement(self.m_root,"conUseCard",WZUIContainer):setVisible(true)

	local tData = self.m_tSelectedCell.m_tData
	--获得皮肤对应的体验卡id
	local cards = {}
	for i=0,999 do
		local tItem = GDatatab_item["id_"..(8000+i)]
		--if tItem == nil then break end
		if tItem ~= nil and tItem.property[1][1] == tData.id and CacheCenter:getPlayerItemCountById(tItem.id) > 0 then
			table.insert(cards, tItem)
		end
	end
	--按体验时间从小到大排序
	function sortC(a,b)
		if a.property[1][2] ~= b.property[1][2] then
			return a.property[1][2] < b.property[1][2]
		else
			return a.id < b.id
		end
	end

	table.sort(cards, sortC)
	self.m_tCards = cards

	for i=1,4 do
		GetElement(self.m_root,"conCard"..i,WZUIContainer):setVisible(false)
	end
	for i=1,#cards do
		local tData = CacheCenter:getPlayerItemById(cards[i].id)
		GetElement(self.m_root,"conCard"..i,WZUIContainer):setVisible(true)
		GetElement(self.m_root,"cardNum"..i,WZUILabelTTF):setText(tData.lastNum..LocalStrings.Expand)
		GetElement(self.m_root,"cardTime"..i,WZUILabelTTF):setText(string.format(LocalStrings.PHANTOM18,tData.basicInfo.property[1][2]/60/24))
	end

	local container = GetElement(self.m_root,"conUseCard",WZUIContainer)
	if container:getChildByTag(60) then container:removeChildByTag(60,true) end

	local imgBg = WZUI9Image:create()
	imgBg:setFile("ui/common/common_scale9_di24.png")
	imgBg:setRelativePosition(ccp(0.5,0.5))
	imgBg:setAnchorPoint(ccp(0.5,0.5))
	local con = WZUIContainer:create()
	con:setUseAbsCoordinate(true)
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(308,64*#cards))
	con:setAnchorPoint(ccp(0,0))
	con:setRelativePosition(ccp(0.5,0))
	con:addChild(imgBg)
	--con:setAbsPosition(ccp(maxWidth/2,labStartY/2))
	GetElement(self.m_root,"conUseCard",WZUIContainer):addChild(con,0,60)
end

function WndPhantom:closeCard() 
	GetElement(self.m_root,"conUseCard",WZUIContainer):setVisible(false)
end

function WndPhantom:useCard(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = tonumber(element:getTag())
	WZLog("WndPhantom:useCard",tag)
	WZLog("WndPhantom:useCard",tag,self.m_tCards)
	WZLog("WndPhantom:useCard",tag,self.m_tCards[tag].id)
	if self.m_tCards ~= nil and self.m_tCards[tag] ~= nil then
		local itemId = self.m_tCards[tag].id
		local tData = CacheCenter:getPlayerItemById(itemId)
		WndPhantom.show = 1
		ProtocolProcessorPhantom:send_SHAPE_UseItem(tData.playerItemId )
	end
	GetElement(self.m_root,"conUseCard",WZUIContainer):setVisible(false)
end

--@brief	体验时间计时器
function WndPhantom:init()
	if self.m_nScheduleId == nil then self.m_nScheduleId = 0 end
	if self.m_nScheduleId > 0 then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nScheduleId)
		self.m_nScheduleId = 0
	end 
	self.m_nScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WndPhantom.onCountdown, 1, false)
end

--@brief	体验时间计时器
function WndPhantom:onCountdown()
	--if WndPhantom.m_nLeftTime == nil then return end
	if WndPhantom.m_tDataList == nil then return end
	if WndPhantom.m_tSelectedCell == nil then return end
	if WndPhantom.m_tSelectedCell.m_tData == nil then return end
	--WZLog("WndPhantom:onCountdown",Serialize(WndPhantom.m_tDataList))
	--有皮肤到期时，重新请求数据
	for i=1,#WndPhantom.m_tDataList do
		if WndPhantom.m_tDataList[i].remainTime > 0 then
			WndPhantom.m_tDataList[i].remainTime = WndPhantom.m_tDataList[i].remainTime - 1
		end
		if WndPhantom.m_tDataList[i].remainTime == 0 and SceneBattle.m_root == nil and SceneBattleLoading.m_root == nil then
			ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo()
			WndPhantom.m_tDataList[i].remainTime = WndPhantom.m_tDataList[i].remainTime - 100
			CacheCenter:getPlayerInfo().shapeId = 0
			CacheCenter:getPlayerInfo().shapeLevel = 0
			break
		end
	end
	WndPhantom:setTimer()
end

function WndPhantom:setTimer() 
	if WndPhantom.m_tDataList == nil then return end
	if WndPhantom.m_tSelectedCell == nil then return end
	if WndPhantom.m_tSelectedCell.m_tData == nil then return end

	GetElement(self.m_root,"ttfMonster",WZUILabelTTF):setVisible(true)

	local leftSec = 0
	--显示剩余时间
	for i=1,#WndPhantom.m_tDataList do
		if WndPhantom.m_tDataList[i].shapeId == WndPhantom.m_tSelectedCell.m_tData.id then
			leftSec = WndPhantom.m_tDataList[i].remainTime
			break
		end
	end
	if WndPhantom.m_root ~= nil then
		if leftSec > 86400 then
			local day = math.ceil(leftSec/86400)
			GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setVisible(true)
			GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setText(LocalStrings.PHANTOM19..day..LocalStrings.DAY)
		elseif leftSec > 0 then
			GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setVisible(true)
			GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setText(LocalStrings.PHANTOM19.. returnToTimeFormat(leftSec))
		elseif leftSec == -1 then
			GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setVisible(false)

			GetElement(self.m_root,"ttfMonster",WZUILabelTTF):setVisible(true)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
