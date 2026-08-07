--WndProfessionRuleData.lua
--@brief	WndProfessionRule的数据模块
--@date		2019/11/14
--@author	Tianxiang_Xu
--@note		职业说明、预览、重置、转职界面

WndProfessionRule = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndProfessionRule:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil 
	self.m_nProfessionSel = nil 
	self.m_tLeftProfession = nil 		--可预览的职业
	self.m_tAllProfession = {{1, "ui/profession/zhiye_zhanshi.png"}, {2, "ui/profession/zhiye_cike.png"}, {3, "ui/profession/zhiye_fashi.png"}}
	self.m_nParamDesc = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndProfessionRule:_unInit()
	self.m_root = nil
	self.m_nType = nil 
	self.m_nProfessionSel = nil 
	self.m_tAllProfession = nil 
	self.m_tLeftProfession = nil 		--可预览的职业
	self.m_nParamDesc = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndProfessionRule:createElement()
	if WndProfessionRule.m_root ~= nil then
		WindowManager:removeWindow(WndProfessionRule.m_root, WndProfessionRule, true)
	end
	local element = WZUISystem:getInstance():createElement("WndProfessionRule")
	assert(element, "WndProfessionRule create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--@param 	nType: 1->说明；2->预览
function WndProfessionRule:showInterface(nType, desc)
	-- body
	if self.m_root == nil then 
		local wndRule = WndProfessionRule:createElement()
		if wndRule then 
			self.m_nType = nType or 1
			self.m_nParamDesc = desc
			WindowManager:addWindow(wndRule, WndProfessionRule, nil, nil, nil, true)
		end
	else
		self.m_nType = nType or 1
		self:_showContent()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	转换规则说明内容，用于区分换行
--@param    #1 desc:规则说明内容
function WndProfessionRule:_changeDesc(desc)
	if desc == nil or desc == "" then
		return
	end
	local sDesc = ""
	local txt = desc
	local fileTxt = "\\n"
	local nLen = string.len( txt )
	local txtLen = string.len( fileTxt )
	local pos = 1
	
	for i = 1 , nLen do
		local nPos = string.find( txt , fileTxt , pos )
		if nPos ~= nil then --如果还找到数据，就添加数据
			local newDesc = string.sub( txt , pos , nPos - txtLen - nLen )
			txt = string.sub( txt , nPos + txtLen )
			nLen = string.len( txt )
			if i == 1 then
				sDesc = newDesc 
			else
				sDesc = sDesc .. "\n" .. newDesc 
			end
		else	--如果找不好数据，添加最后的数据
			sDesc = sDesc .. "\n" .. txt 
			return sDesc
		end
	end
	return sDesc
	
end

--@brief 	可预览的职业
function WndProfessionRule:getCanPreviewProfession()
	-- body
	self.m_tLeftProfession = {}

	for i = 1, #self.m_tAllProfession do
		if self.m_tAllProfession[i][1] ~= WndProfession.m_nCurProfessionId then 
			table.insert(self.m_tLeftProfession, self.m_tAllProfession[i])
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
