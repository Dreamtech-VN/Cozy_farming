--CellMasterReward.lua
--@brief	CellMasterReward的UI模块
--@date		2015/05/28
--@author	zsq
--@note		师傅奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMasterReward:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMasterReward:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置奖励和说明
function CellMasterReward:setCellMasterReward(k)
	local reward = GDatatab_morality[k].reward

	local len = math.min(4,#reward)
	for i=1,len do
		--设置奖励
    	local key = "id_"..reward[i][1]
    	local name = GDatatab_item[key].name
    	local path = GDatatab_item[key].icon
    	local num = reward[i][2]
    	local quality = GDatatab_item[key].quality
    	local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=GDatatab_item[key]}
	    local celElement,tLuaObj = CellGoodItem:createElement()
		--celElement:setScale(0.9)
		local con = GetElement(self.m_root, "conReward"..i.."_CellMasterReward", WZUIContainer)
		tLuaObj:setCellGoodItem(itemInfo,4)
        tLuaObj:setItemClickFun(self, self.onClickItem)
		con:addChild(celElement)
	end

	--设置标题
	GetElement(self.m_root, "ttfCurrent_CellMaster", WZUILabelTTF):setText(string.format(LocalStrings.MASTERINFO31,GDatatab_morality[k].level))

	--是否显示当前标识
	local masterInfo = CacheCenter:getMasterInfo()

	--是否显示已获得
	if masterInfo.moralityLevel >= GDatatab_morality[k].level then
		GetElement(self.m_root, "ttfGet_CellMaster", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root, "ttfGet_CellMaster", WZUIImage):setVisible(false)
	end

	--设置说明
	local tData = GDatatab_morality[k]
	--local info = string.format(LocalStrings.MASTERINFO1,tData.max_pupil,":"..tData.title.."",tData.buff[1][2],"",tData.buff[2][2],"",tData.buff[3][2],"",tData.pupil_buff[1][2],"",tData.pupil_buff[2][2],"",tData.pupil_buff[3][2],"")
	local info = string.format(LocalStrings.MASTERINFO1,tData.max_pupil,tData.buff[1][2],"",tData.buff[2][2],"",tData.buff[3][2],"",tData.pupil_buff[1][2],"",tData.pupil_buff[2][2],"",tData.pupil_buff[3][2],"")
	GetElement(self.m_root, "ttfInfo_CellMasterReward", WZUIFreeTextBox):setShowText(info)
end


--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function CellMasterReward:onClickItem(tItem, nTag, tData)
    WZLog("CellMasterReward:onClickItem ")

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,GetElement(WndMasterReward.m_root,"conMasterReward",WZUIContainer),1,tData, false)
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------------语言适配Begin--------------------------------------
function CellMasterReward:_adaptLanguage_en(  )
	local txt = GetElement(self.m_root,"ttfInfo_CellMasterReward",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.14,0.76))
	txt:setMaxWidth(400)
end

function CellMasterReward:_adaptLanguage_pt(  )
	local txt = GetElement(self.m_root,"ttfInfo_CellMasterReward",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.14,0.76))
	txt:setMaxWidth(400)
	GetElement(self.m_root,"ttfCurrent2_CellMaster",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.52))
end

function CellMasterReward:_adaptLanguage_vn(  )
	local txt = GetElement(self.m_root,"ttfInfo_CellMasterReward",WZUIFreeTextBox)
	txt:setScale(0.7)
	txt:setMaxWidth(500)
	GetElement(self.m_root,"ttfCurrent2_CellMaster",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35,0.85))
end

function CellMasterReward:_adaptLanguage_tr(  )
	local txt = GetElement(self.m_root,"ttfInfo_CellMasterReward",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.14,0.76))
	txt:setScale(0.85)
end

function CellMasterReward:_adaptLanguage_th(  )
	local txt = GetElement(self.m_root,"ttfInfo_CellMasterReward",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.14,0.76))
	txt:setScale(0.85)
end

function CellMasterReward:_adaptLanguage_es(  )
	local txtCurrent = GetElement(self.m_root,"ttfCurrent2_CellMaster",WZUILabelTTF)
	txtCurrent:setRelativePosition(GlobalMethod:ccp(0.32,0.52))
	local txt = GetElement(self.m_root,"ttfInfo_CellMasterReward",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.14,0.76))
	txt:setScale(0.85)
end
--------------------------------------------语言适配End----------------------------------------