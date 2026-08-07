--CellCommunityTaskReward.lua
--@brief	CellCommunityTaskReward的UI模块
--@date		2016/06/17
--@author	zsq
--@note		公会任务奖励Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityTaskReward:onEnter(element)
	self.m_root = element
	self:update()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityTaskReward:onExit(element)
	self:_unInit()
end

function CellCommunityTaskReward:setData(tData)
	self:update(tData)	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCommunityTaskReward:update(tData)
	if tData == nil then return end
	--显示职位
	GetElement(self.m_root,"txtPosition",WZUILabelTTF):setText(COMMUNITY_POSITION[tData.job])
	--显示奖励
	local lenth = math.min(4,#tData.reward)
	for i=1,lenth do
		local con = GetElement(self.m_root,"conItem"..i.."_CellCommunityTaskReward",WZUIContainer)
		local itemData = GDatatab_item["id_"..tData.reward[i][1]]
        local itemInfo = {name=itemData.name,icon=itemData.icon,lastNum=tData.reward[i][2],quality=itemData.quality,basicInfo=CopyTable(itemData)}
		--格子不够,创建格子
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo,2)
			tCell:setItemClickFun(self,self.onItemClick)
			con:addChild(celElement)
		end
	end
end

function CellCommunityTaskReward:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndItemInfo:showInfo(tCell.m_root,WndCommunityTask.m_root,1,tData,false)	
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellCommunityTaskReward:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtPosition",WZUILabelTTF):setScale(0.8)
end

function CellCommunityTaskReward:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtPosition",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End--------------------------------------------
