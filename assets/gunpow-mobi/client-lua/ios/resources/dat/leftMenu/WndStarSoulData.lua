--WndStarSoulData.lua
--@brief	WndStarSoul的数据模块
--@date		2015/12/16
--@author	Tianxiang_Xu
--@note		星魂系统

WndStarSoul = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndStarSoul:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nSimStarNum = nil	--单人副本的星数
	self.m_nMulStarNum = nil 	--组队副本的星数
	self.m_nTotalFighting = nil --总的战力加成
	self.m_tTotalProperty = nil --总战力属性表
	self.m_tStarSoulList = nil  --星魂表
	self.m_tStarObjList = nil   --星魂对应的表
	self.m_tStarProperty = nil  --单个星系属性表
	self.m_nCurStarIndex = nil 	--当前星系类型
	self.m_nLoadingId = nil 	--菊花Id
	self.m_nCurPageIndex = 0 	--当前页码
	self.m_nStarNum = 0 		--星系数
	self.m_nActivityStarNum = nil --已激活的星魂数
	self.m_bLoadFinish = true
	self.m_nLoadIndex = 1   	--分贞加载索引
	self.m_nLoadNum = nil 		--加载星魂的数量
	self.m_bToNextPage = nil 	--是否跳到下一个星系
	self.m_tStarSoulPosition = {
	id_1 = {{153,146},{264,219},{361,335},{492,292},{673,194},{770,332}}, --水平座
	id_2 = {{127,137},{334,181},{547,146},{716,217},{743,361},{560,441}}, --双鱼座
	id_3 = {{157,318},{321,378},{506,393},{673,336},{792,233},{644,138}}, --白羊座
	id_4 = {{170,393},{308,305},{464,351},{551,235},{670,154},{808,219}}, --金牛座
	id_5 = {{348,140},{182,236},{266,395},{490,385},{733,306},{766,130},{600,120}}, --双子座
	id_6 = {{167,388},{246,268},{366,147},{528,184},{669,228},{758,316},{627,426}}, --巨蟹座
	id_7 = {{135,151},{227,278},{401,271},{601,147},{766,224},{547,355},{605,465}}, --狮子座
	id_8 = {{145,179},{207,361},{362,335},{451,160},{562,249},{633,355},{799,357}}, --处女座
	id_9 = {{146,166},{204,356},{366,337},{452,159},{565,248},{633,356},{800,356}}, --天秤座
	id_10 = {{227,311},{167,166},{344,126},{446,201},{540,309},{689,369},{779,157}}, --天蝎座
	id_11 = {{329,112},{169,182},{249,334},{440,305},{528,203},{682,349},{796,175}}, --射手座
	id_12 = {{143,165},{300,276},{408,363},{575,435},{676,287},{747,158},{547,129}}, --魔蝎座
}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndStarSoul:_unInit()
	self.m_root = nil
	self.m_nSimStarNum = nil	--单人副本的星数
	self.m_nMulStarNum = nil 	--组队副本的星数
	self.m_nTotalFighting = nil --总的战力加成
	self.m_tTotalProperty = nil --总战力属性表
	self.m_tStarSoulList = nil  --星魂表
	self.m_tStarProperty = nil  --单个星系属性表
	self.m_nCurStarIndex = nil 	--当前星系类型
	self.m_nLoadingId = nil 	--菊花Id
	self.m_nCurPageIndex = nil  --当前页码
	self.m_tStarSoulPosition = nil
	self.m_nStarNum = nil 		--星系数
	self.m_nActivityStarNum = nil --已激活的星魂数
	self.m_bLoadFinish = nil
	self.m_tStarObjList = nil   --星魂对应的表
	self.m_nLoadIndex = nil   	--分贞加载索引
	self.m_nLoadNum = nil 		--加载星魂的数量
	self.m_bToNextPage = nil 	--是否跳到下一个星系
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndStarSoul:createElement()
	local element = WZUISystem:getInstance():createElement("WndStarSoul")
	assert(element, "WndStarSoul create element failed!")
	self:_init()
	return element
end

--@brief 	设置星魂系统数据
function WndStarSoul:setStarSoulData(idlist, fight, siglevalue, teamvalue)
	-- body
	self:_closeLoading()
	WZLog("WndStarSoul:setStarSoulData 000", idlist:size(),fight, siglevalue, teamvalue)

	self.m_nSimStarNum = siglevalue	--单人副本的星数
	self.m_nMulStarNum = teamvalue 	--组队副本的星数
	self.m_nTotalFighting = fight --总的战力加成
	self.m_nCurStarIndex = 1
	self.m_nActivityStarNum = idlist:size()

	if self.m_tStarSoulList == nil then
		self.m_tStarSoulList = {}
	end
	if self.m_tStarObjList == nil then
		self.m_tStarObjList = {}
	end

	local tTempStarSoulList = CacheCenter:getStarSoulList()
	for i = 1, #tTempStarSoulList do
		if self.m_tStarSoulList[tTempStarSoulList[i].star] == nil then
			self.m_tStarSoulList[tTempStarSoulList[i].star] = {}
		end
	--	local tTemp1 = self.m_tStarSoulPosition["id_" .. tTempStarSoulList[i].star]
	--	local tTemp = tTemp1[tTempStarSoulList[i].star_soul]
	--	tTempStarSoulList[i].absPosition = GlobalMethod:ccp(tTemp[1],tTemp[2])
		table.insert(self.m_tStarSoulList[tTempStarSoulList[i].star], tTempStarSoulList[i])
	end
	--星系排序
	for j = 1, #self.m_tStarSoulList do
		table.sort(self.m_tStarSoulList[j], sortStar)
	end
	self.m_nStarNum = #self.m_tStarSoulList
	--设置各星系中星魂状态和下一个要激活的星魂
	self:_setStarStatus(idlist:size())

	if self.m_tTotalProperty == nil then
		self.m_tTotalProperty = {}
		self.m_tTotalProperty = {{1,0},{3,0},{4,0},{5,0},{7,0}}
	end
	
	if self.m_tStarProperty == nil then 
		self.m_tStarProperty = {}
	end

	--计算某一星系加成
	--计算总战力加成
	self:_caculateTotalFighting(self.m_nActivityStarNum)

	self:_updateInfo()
    self:_loadAllPage()
--	WZLog("******************", Serialize(self.m_tStarSoulList))
end

function sortStar(a, b)
	-- body
	return a.star_soul < b.star_soul
end

--brief 	更新星魂系统数据
function WndStarSoul:updateStarSoulData(result, fight, id, siglevalue, teamvalue)
	--body
	self:_closeLoading()
	if result == 0 then return end
	WZLog("******* WndStarSoul:updateStarSoulData ******",result, fight, id, siglevalue, teamvalue)

	self.m_nSimStarNum = siglevalue	--单人副本的星数
	self.m_nMulStarNum = teamvalue 	--组队副本的星数
	self.m_nTotalFighting = fight --总的战力加成
	self.m_nActivityStarNum = self.m_nActivityStarNum + 1
	--刷新当前点，和下一个待激活点
	self:_updateCurAndNextStar()

	self:_setStarStatus(self.m_nActivityStarNum)

	--更新总战力加成
	local value = GDatatab_starsoul["id_" .. id]
	local property = value.property
	for k = 1, #self.m_tTotalProperty do
		if self.m_tTotalProperty[k][1] == property[1][1] then
			self.m_tTotalProperty[k][2] =  self.m_tTotalProperty[k][2] + property[1][2]
			break
		end
	end
	--某一星系加成更新
	--星系属性加成
	if self.m_tStarProperty[value.star] == nil then
		self.m_tStarProperty[value.star] = {{1,0},{3,0},{4,0},{5,0},{7,0}}
	end
	for k = 1, #self.m_tStarProperty[value.star] do
		if self.m_tStarProperty[value.star][k][1] == property[1][1] then
			self.m_tStarProperty[value.star][k][2] =  self.m_tStarProperty[value.star][k][2] + property[1][2]
			break
		end
	end

	self:_updateInfo()
	self:activityOKSpine()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndStarSoul:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief 	设置各星魂的状态
--@param 	idNum:已激活的Id的数量
function WndStarSoul:_setStarStatus(idNum)
	-- body
	local activeIdNum = idNum
	WZLog("****** WndStarSoul:_setStarStatus *******", activeIdNum)

	if activeIdNum == 0 then
		self.m_tStarSoulList[1][1].status = 1
		return 
	end

	local nNextStarIndex = 1

	for j = 1, #self.m_tStarSoulList do
		if activeIdNum < #self.m_tStarSoulList[j] then 
			for i = 1 , activeIdNum do
				self.m_tStarSoulList[j][i].status = 2
				nNextStarIndex = nNextStarIndex + 1
			end
			WZLog("****** WndStarSoul:_setStarStatus *******111", j, nNextStarIndex)
			self.m_tStarSoulList[j][nNextStarIndex].status = 1
			self.m_nCurStarIndex = j
			break
		elseif activeIdNum >= #self.m_tStarSoulList[j] then 
			for i = 1 , #self.m_tStarSoulList[j] do
				self.m_tStarSoulList[j][i].status = 2
			end

			activeIdNum = activeIdNum -  #self.m_tStarSoulList[j]
			self.m_nCurStarIndex = j
		end 
	end
end

--@brief 	计算星魂系统总战力
function WndStarSoul:_caculateTotalFighting(idNum)
	-- body
	local activeIdNum = idNum
	WZLog("****** WndStarSoul:_setStarStatus *******", activeIdNum)

	for j = 1, #self.m_tStarSoulList do
		if activeIdNum < #self.m_tStarSoulList[j] then 
			for i = 1 , activeIdNum do
				local property = self.m_tStarSoulList[j][i].property
				for k = 1, #self.m_tTotalProperty do
					if self.m_tTotalProperty[k][1] == property[1][1] then
						self.m_tTotalProperty[k][2] =  self.m_tTotalProperty[k][2] + property[1][2]
						break
					end
				end
				--星系属性加成
				if self.m_tStarProperty[j] == nil then
					self.m_tStarProperty[j] = {{1,0},{3,0},{4,0},{5,0},{7,0}}
				end
				for k = 1, #self.m_tStarProperty[j] do
					if self.m_tStarProperty[j][k][1] == property[1][1] then
						self.m_tStarProperty[j][k][2] =  self.m_tStarProperty[j][k][2] + property[1][2]
						break
					end
				end
			end
			break
		elseif activeIdNum >= #self.m_tStarSoulList[j] then 
			for i = 1 , #self.m_tStarSoulList[j] do
				local property = self.m_tStarSoulList[j][i].property
				for k = 1, #self.m_tTotalProperty do
					if self.m_tTotalProperty[k][1] == property[1][1] then
						self.m_tTotalProperty[k][2] =  self.m_tTotalProperty[k][2] + property[1][2]
						break
					end
				end
				--星系属性加成
				if self.m_tStarProperty[j] == nil then
					self.m_tStarProperty[j] = {{1,0},{3,0},{4,0},{5,0},{7,0}}
				end
				for k = 1, #self.m_tStarProperty[j] do
					if self.m_tStarProperty[j][k][1] == property[1][1] then
						self.m_tStarProperty[j][k][2] =  self.m_tStarProperty[j][k][2] + property[1][2]
						break
					end
				end
			end

			activeIdNum = activeIdNum -  #self.m_tStarSoulList[j]
		end 
	end
end

-------------------------------------私有方法模块End----------------------------------------
