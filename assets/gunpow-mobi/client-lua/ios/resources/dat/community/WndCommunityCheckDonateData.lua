--WndCommunityCheckDonateData.lua
--@brief	WndCommunityCheckDonate的数据模块
--@date		2016/05/03
--@author	zsq
--@note		查看公会成员贡献

WndCommunityCheckDonate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityCheckDonate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCellList = nil
	self.m_nTag = nil
	self.m_tDataList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityCheckDonate:_unInit()
	self.m_root = nil
	self.m_tCellList = nil
	self.m_nTag = nil
	self.m_tDataList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityCheckDonate:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityCheckDonate")
	assert(element, "WndCommunityCheckDonate create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	英文包适配函数
function WndCommunityCheckDonate:_adaptLanguage_en()
	if self.m_root == nil then
		return
	end
	for i=1,3 do
		GetElement(self.m_root,"txtTab"..i,WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160,0))
		GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160,0))
		GetElement(self.m_root,"txtTab"..i,WZUILabelTTF):setScale(0.55)
		GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF):setScale(0.55)
	end

	for i=1,5 do
		GetElement(self.m_root,"txtLabel" .. i ,WZUILabelTTF):setScale(0.8)
	end
end

function WndCommunityCheckDonate:_adaptLanguage_pt(  )
	if self.m_root == nil then
		return
	end
	for i=1,3 do
		GetElement(self.m_root,"txtTab"..i,WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160,0))
		GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160,0))
		GetElement(self.m_root,"txtTab"..i,WZUILabelTTF):setScale(0.55)
		GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF):setScale(0.55)
	end

	for i=1,5 do
		GetElement(self.m_root,"txtLabel" .. i ,WZUILabelTTF):setScale(0.8)
	end
end


--@brief	泰文包适配函数
function WndCommunityCheckDonate:_adaptLanguage_th()
	if self.m_root == nil then
		return
	end
	for i=1,3 do
		GetElement(self.m_root,"txtTab"..i,WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160,0))
		GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160,0))
		GetElement(self.m_root,"txtTab"..i,WZUILabelTTF):setScale(0.55)
		GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF):setScale(0.55)
	end
end

-------------------------------------私有方法模块End----------------------------------------
