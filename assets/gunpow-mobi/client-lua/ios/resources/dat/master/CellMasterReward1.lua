--CellMasterReward1.lua
--@brief	CellMasterReward1的UI模块
--@date		2015/05/29
--@author	zsq
--@note		徒弟奖励单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMasterReward1:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMasterReward1:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置奖励列表
function CellMasterReward1:setCellMasterReward1(k)
	local reward = GDatatab_pupil_reward[k].reward

	--设置奖励
	local len = math.min(4,#reward)
	for i=1,len do
	    local celElement,tLuaObj = CellGoodItem:createElement()
		--celElement:setScale(0.8)
		local con = GetElement(self.m_root, "con"..i.."_CellMasterReward1", WZUIContainer)

	    local key = "id_"..reward[i][1]
	    local name = GDatatab_item[key].name
	    local path = GDatatab_item[key].icon
	    local num =  reward[i][2]
	    local quality = GDatatab_item[key].quality
	    local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=GDatatab_item[key]}

		tLuaObj:setCellGoodItem(itemInfo,4)
        tLuaObj:setItemClickFun(self, self.onClickItem)
		con:addChild(celElement)
	end

	--设置领取状态
	local masterInfo = CacheCenter:getMasterInfo()
	local baishiLevel = masterInfo.baishiLevel
	if baishiLevel == 0 then baishiLevel = CacheCenter:getPlayerInfo().level end
	local imgState = GetElement(self.m_root, "imgState_CellMasterReward1", WZUIImage)
	if tonumber(baishiLevel) >= GDatatab_pupil_reward[k].level then
		imgState:setFile("ui/common/commom_icon_cgdj.png")
		imgState:setVisible(true)
	elseif CacheCenter:getPlayerInfo().level >= GDatatab_pupil_reward[k].level then
		imgState:setFile("ui/common/commom_icon_ylq.png")
		imgState:setVisible(true)
	else
		imgState:setVisible(false)
	end 

    GetElement(self.m_root, "ttfLevel_CellMasterReward1", WZUILabelTTF):setText(GDatatab_pupil_reward[k].level..LocalStrings.LEVEL1)
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function CellMasterReward1:onClickItem(tItem, nTag, tData)
    WZLog("CellMasterReward1:onClickItem ")

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,GetElement(WndMasterReward.m_root,"conDiscipleReward",WZUIContainer),1,tData, false)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------------语言适配Begin--------------------------------------
function CellMasterReward1:_adaptLanguage_en(  )
	local ttfLevel = GetElement(self.m_root,"ttfLevel_CellMasterReward1",WZUILabelTTF)
	ttfLevel:setScale(0.8)
	ttfLevel:setRelativePosition(GlobalMethod:ccp(0.02,0.5))
end

function CellMasterReward1:_adaptLanguage_pt(  )
	local ttfLevel = GetElement(self.m_root,"ttfLevel_CellMasterReward1",WZUILabelTTF)
	ttfLevel:setScale(0.8)
	ttfLevel:setRelativePosition(GlobalMethod:ccp(0.02,0.5))
end

function CellMasterReward1:_adaptLanguage_es(  )
	local ttfLevel = GetElement(self.m_root,"ttfLevel_CellMasterReward1",WZUILabelTTF)
	ttfLevel:setScale(0.8)
	ttfLevel:setRelativePosition(GlobalMethod:ccp(0.02,0.5))
end

function CellMasterReward1:_adaptLanguage_tr(  )
	local ttfLevel = GetElement(self.m_root,"ttfLevel_CellMasterReward1",WZUILabelTTF)
	ttfLevel:setScale(0.7)
	ttfLevel:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
end
-------------------------------------------语言适配End----------------------------------------