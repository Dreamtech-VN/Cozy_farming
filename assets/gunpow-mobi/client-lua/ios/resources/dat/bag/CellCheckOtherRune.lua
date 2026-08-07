--CellCheckOtherRune.lua
--@brief	CellCheckOtherRune的UI模块
--@date		2018/01/23
--@author	zsq
--@note		符文信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOtherRune:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOtherRune:onExit(element)
	self:_unInit()
end

function CellCheckOtherRune:setData(tData)
	self.m_tDataList = tData
	self:update()
end

function CellCheckOtherRune:onClick(element)
	WZLog("CellCheckOtherRune:onClick", element:getTag())
	local tag = element:getTag()
	local tData = {}
	if self.m_tDataList[tag] == nil then return end 
	local tItem = GDatatab_item["id_"..self.m_tDataList[tag].item_id]
	tData.icon = tItem.icon
	tData.name = tItem.name
	local property = tItem.property
	for i=1,3 do
		if property[i] ~= nil then
			tData["attr"..i] = property[i][1]
			tData["attrTitle"..i] = ATTR_TITLE[property[i][1]]
			tData["attrVal"..i] = property[i][2]
		end
	end
	WndTips:show(element,WndCheckOther.m_root,47,tData,GlobalMethod:ccp(0,0))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCheckOtherRune:update()
	WZLog("CellCheckOtherRune:update", Serialize(self.m_tDataList))

	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_lv.png"}

	for j=1,6 do
    	local cell = self.m_root
		GetElement(cell,"num"..j,WZUILabelTTF):setText("")

		local index = j
		if self.m_tDataList[index] ~= nil then
			local tData = GDatatab_item["id_"..self.m_tDataList[index].item_id]
			GetElement(cell,"black"..j,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
			GetElement(cell,"quality"..j,WZUI9Image):setFile(qualityPic[tData.quality])
			GetElement(cell,"num"..j,WZUILabelTTF):setText("x"..self.m_tDataList[index].item_num)
			GetElement(cell,"icon"..j,WZUIImage):setFile(tData.icon)
			GetElement(cell,"icon"..j.."Sel",WZUIImage):setFile(tData.icon)
			local btn = GetElement(cell,"btn"..j,WZUIButton)
			btn:setTouchEnable(true)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellCheckOtherRune:_adaptLanguage_tr( )
	local txtTitle = GetElement(self.m_root,"txtTitle_CellCheckOtherRune",WZUILabelTTF)
	txtTitle:setScale(0.8)
	txtTitle:setRelativePosition(GlobalMethod:ccp(0.01,0.8))
end
-------------------------------------语言适配End----------------------------------------