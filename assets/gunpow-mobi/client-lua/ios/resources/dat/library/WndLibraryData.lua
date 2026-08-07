--WndLibraryData.lua
--@brief	WndLibrary的数据模块
--@date		2016/05/06
--@author	maopeiting
--@note		图鉴

WndLibrary = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLibrary:_init()
	self.m_root = nil	 	--场景根节点
	self.data = {}			
	self.curLoadCount = 1   
	self.tabTag = 1    		--标签栏的tag值
	self.id = {}    		--缓存中有的物品的id
	self.cacheEquip = {}	--已拥有的装备
	self.cacheTool = {}		--已拥有的道具
	self.cacheMaterial = {}	--已拥有的材料
	self.cacheCloth = {}    --已拥有的时装
	self.cachePet = {}      --已拥有的宠物
	self.cacheFragment = {}  --已拥有的碎片
	self.item = {}			--物品表
	self.equip = {}			--未拥有的装备
	self.tool = {}			--未拥有的道具
	self.material = {}		--未拥有的材料
	self.cloth = {}			--未拥有的时装
	self.pet = {}           --未拥有的宠物
	self.fragment = {}      --未拥有的碎片
	
	self.preCell = nil		--上一次被点击的cell对象
	self.sex = nil			--性别

	self.head = {}			--头部
	self.emotion = {}		--表情
	self.dress = {}			--服装
	self.wing= {}			--翅膀

	self.m_tConsumers = {}  --道具-消耗物
	self.m_tBlessing = {}   --道具-祝福
	self.m_tSocialprops = {} --道具-社交

	self.m_tMaterial1 = {}        --材料-宝石
	self.m_tMaterial2 = {}        --材料-锻造
	self.m_tMaterial3 = {}      --材料-圣光
	self.m_tMaterial4 = {}      --材料-宠物
	self.m_tMaterial5 = {}      --材料-觉醒

	self.m_tPet1 = {}         --宠物-均衡型
	self.m_tPet2 = {}         --宠物-攻击型
	self.m_tPet3 = {}         --宠物-防御型
	self.m_tPet4 = {}         --宠物-生命型

	self.m_tFragment1 = {}    --碎片-道具
	self.m_tFragment2 = {}    --碎片-皮肤
	self.m_tFragment3 = {}    --碎片-时装
	self.m_tFragment4 = {}    --碎片-装备

	self.weapon = {} 		--武器
	self.ring = {}			--戒指
	self.necklace = {}		--项链
	self.treasure = {}		--宝物
	self.medal = {}			--勋章
	self.bracelet = {}		--手镯
	self.earring = {}       --耳饰
	self.deputy = {}        --副手


	self.preTag = nil		--上一次被点击的物品
	self.preTabTag = 1 		--上一次被点击的标签栏
	self.itemCout = {}		--装备物品数量表
	self.m_nodeCurType = 1  --当前查看的物品类型
	self.m_nodeCurTypeByName = nil  --当前查看的物品类型所属分类

	self.m_node = nil
	self.m_nQuality = 1   --查看的物品品质

	self.m_tCurData = nil  --当前查看的物品数据

	self.m_movePs = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLibrary:_unInit()
	self.m_root = nil
	self.data = nil
	self.curLoadCount = nil
	self.tabTag = nil     	--标签栏的tag值
	self.id = nil 			--缓存中有的物品的id
	self.cacheEquip = {}	--已拥有的装备
	self.cacheTool = {}		--已拥有的道具
	self.cacheMaterial = {}	--已拥有的材料
	self.cacheCloth = {}    --已拥有的时装
	self.cachePet = {}      --已拥有的宠物
	self.cacheFragment = {}  --已拥有的碎片
	self.item = nil			--物品表
	self.equip = nil		--未拥有的装备
	self.tool = nil			--未拥有的道具
	self.material = nil		--未拥有的材料
	self.cloth = nil		--未拥有的时装
	self.weapon = nil 		--武器
	self.ring =	nil			--戒指
	self.necklace = nil		--项链
	self.treasure = nil		--宝物
	self.medal = nil		--勋章
	self.bracelet = nil		--手镯
	self.earring = nil       --耳饰
	self.deputy = nil        --副手

	self.preCell = nil		--上一次被点击的cell对象
	self.head = {}			--头部
	self.emotion = {}		--表情
	self.dress = {}			--服装
	self.wing= {}			--翅膀
	self.sex = nil			--性别
	self.preTag = nil		--上一次被点击的物品
	self.preTabTag = nil	--上一次被点击的标签栏
	self.itemCout = nil		--装备物品数量表

	self.m_tConsumers = {}  --道具-消耗物
	self.m_tBlessing = {}   --道具-祝福
	self.m_tSocialprops = {} --道具-社交

	self.m_tMaterial1 = {}        --材料-宝石
	self.m_tMaterial2 = {}        --材料-锻造
	self.m_tMaterial3 = {}      --材料-圣光
	self.m_tMaterial4 = {}      --材料-宠物
	self.m_tMaterial5 = {}      --材料-觉醒

	self.m_tPet1 = {}         --宠物-均衡型
	self.m_tPet2 = {}         --宠物-攻击型
	self.m_tPet3 = {}         --宠物-防御型
	self.m_tPet4 = {}         --宠物-生命型

	self.m_tFragment1 = {}    --碎片-道具
	self.m_tFragment2 = {}    --碎片-皮肤
	self.m_tFragment3 = {}    --碎片-时装
	self.m_tFragment4 = {}    --碎片-装备

	self.m_nodeCurType = nil  --当前查看的物品类型
	self.m_nodeCurTypeByName = nil  --当前查看的物品类型所属分类

	self.m_node = nil
	self.m_nQuality = nil   --查看的物品品质
	self.m_tCurData = nil  --当前查看的物品数据
	self.m_movePs = nil

end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLibrary:createElement()
	local element = WZUISystem:getInstance():createElement("WndLibrary")
	assert(element, "WndLibrary create element failed!")
	self:_init()
	return element
end

--@brief   设置物品信息
function WndLibrary:initGoods()
	--获得玩家性别
	self.sex = CacheCenter:getPlayerInfo().sex
	--获得玩家拥有的物品
	local tempList = CacheCenter:getPlayerItems()
	--WZLog("----initGoods:tempList-----",Serialize(tempList))
	local item = {}		--防止物品重复表

	for k,v in pairs(tempList) do
		if v.basicInfo == nil then 
			WZLog("------------v--------",v.id)
		else
			--判断物品是否重复
			if item[v.basicInfo.id] == nil then
				local itemInfo = GDatatab_item["id_" ..v.basicInfo.id ]
				if type(itemInfo.pokedex) == "table" then
					itemInfo.owned = true
					if itemInfo.pokedex[1][1] == 1 then  --装备
						if self.data[1] == nil then
							self.data[1] = {}
						end
						itemInfo.lastTime = v.lastTime
						
						table.insert(self.data[1],itemInfo)
						table.insert(self.id,v.basicInfo.id)
					elseif itemInfo.pokedex[1][1] == 2 then  --是道具
						if self.data[2] == nil then
							self.data[2] = {}
						end
					    itemInfo.lastTime = v.lastTime
						table.insert(self.data[2],itemInfo)
						table.insert(self.id,v.basicInfo.id)  
					elseif itemInfo.pokedex[1][1] == 3 then  --时装
						if self.data[3] == nil then
							self.data[3] = {}
						end
						itemInfo.lastTime = v.lastTime
						table.insert(self.data[3],itemInfo)
						table.insert(self.id,v.basicInfo.id)
					elseif itemInfo.pokedex[1][1] == 4 then  --宠物
						if self.data[4] == nil then
							self.data[4] = {}
						end
						itemInfo.lastTime = v.lastTime
						table.insert(self.data[4],itemInfo)
						table.insert(self.id,v.basicInfo.id)
					elseif itemInfo.pokedex[1][1] == 5 then  --材料
						if self.data[5] == nil then
							self.data[5] = {}
						end
						itemInfo.lastTime = v.lastTime
						table.insert(self.data[5],itemInfo)
						table.insert(self.id,v.basicInfo.id)
					elseif itemInfo.pokedex[1][1] == 6 then --碎片
						if self.data[6] == nil then
							self.data[6] = {}
						end
						itemInfo.lastTime = v.lastTime
						table.insert(self.data[6],itemInfo)
						table.insert(self.id,v.basicInfo.id)
					end
					item[v.basicInfo.id] = true
					self.itemCout[v.basicInfo.id] = 1
				end
			else
				self.itemCout[v.basicInfo.id] = self.itemCout[v.basicInfo.id] + 1
			end
		end
	end

	--WZLog("----initGoods:item-----",Serialize(item))

	--WZLog("-----initGoods:self.id------",Serialize(self.id))
	--WZLog("-----initGoods:self.data[1]----",Serialize(self.data[1]))

	-- 获取缓存里没有的物品
	for k,v in pairs(GDatatab_item) do
		local flag = false
		for i=1,#self.id do
			if v.id == self.id[i] then
				flag = true
				break
			end
		end
		if flag == false then
			if type(v.pokedex) == "table" then
				if v.pokedex[1][1] == 1 then
					if self.data[1] == nil then
						self.data[1] = {}
					end
					table.insert(self.data[1],v)
				elseif v.pokedex[1][1] == 2 then
					if self.data[2] == nil then
						self.data[2] = {}
					end
					table.insert(self.data[2],v)
				elseif v.pokedex[1][1] == 3 then
					if self.data[3] == nil then
						self.data[3] = {}
					end
					table.insert(self.data[3],v)
				elseif v.pokedex[1][1] == 4 then
					if self.data[4] == nil then
						self.data[4] = {}
					end
					table.insert(self.data[4],v)
				elseif v.pokedex[1][1] == 5 then
					if self.data[5] == nil then
						self.data[5] = {}
					end
					table.insert(self.data[5],v)
				elseif v.pokedex[1][1] == 6 then
					if self.data[6] == nil then
						self.data[6] = {}
					end
					table.insert(self.data[6],v)
				end
			end
		end
	end

	self:updateItem()
	self:_initItem()
end

--已拥有的物品进行排序
function WndLibrary:updateItem()

	--装备
	if self.data[1] then
		for i=1,#self.id do
			for k,v in pairs(self.data[1]) do
				if v.id == self.id[i] then
					table.insert(self.cacheEquip,v)
					break
				end
			end
		end
		local temp = #self.cacheEquip + 1
		local temp2 = #self.data[1]
		for i=temp,temp2 do
			table.insert(self.equip,self.data[1][i])
		end
	end

	--道具
	if self.data[2] then
		for i=1,#self.id do
			for k,v in pairs(self.data[2]) do
				if v.id == self.id[i] then
					table.insert(self.cacheTool,v)
					break
				end
			end
		end
		local temp = #self.cacheTool + 1
		local temp2 = #self.data[2]
		for i=temp,temp2 do
			table.insert(self.tool,self.data[2][i])
		end
	end

	--时装
	if self.data[3] then
		for i=1,#self.id do
			for k,v in pairs(self.data[3]) do
				if v.id == self.id[i] then
					--flag = true
					table.insert(self.cacheCloth,v)
					break
				end
			end
		end
		local temp = #self.cacheCloth + 1
		local temp2 = #self.data[3]
		for i=temp,temp2 do
			table.insert(self.cloth,self.data[3][i])
		end
	end

	--宠物
	if self.data[4] then
		for i=1,#self.id do
			for k,v in pairs(self.data[4]) do
				if v.id == self.id[i] then
					table.insert(self.cachePet,v)
					break
				end
			end
		end
		local temp = #self.cachePet + 1
		local temp2 = #self.data[4]
		for i=temp,temp2 do
			table.insert(self.pet,self.data[4][i])
		end
	end

	--材料
	if self.data[5] then
		for i=1,#self.id do
			for k,v in pairs(self.data[5]) do
				if v.id == self.id[i] then
					table.insert(self.cacheMaterial,v)
					break
				end
			end
		end
		local temp = #self.cacheMaterial + 1
		local temp2 = #self.data[5]

		for i=temp,temp2 do
			table.insert(self.material,self.data[5][i])
		end
	end

    --碎片
	if self.data[6] then
		for i=1,#self.id do
			for k,v in pairs(self.data[6]) do
				if v.id == self.id[i] then
					table.insert(self.cacheFragment,v)
					break
				end
			end
		end
		local temp = #self.cacheFragment + 1
		local temp2 = #self.data[6]
		for i=temp,temp2 do
			table.insert(self.fragment,self.data[6][i])
		end
	end

	if #self.cacheEquip >= 2 then
		self:sortItem(self.cacheEquip)
	end
	if #self.cacheTool >= 2 then
		self:sortItem(self.cacheTool)
	end
	if #self.cacheMaterial >= 2 then
		self:sortItem(self.cacheMaterial)
	end
	if #self.cacheCloth >= 2 then
		self:sortItem(self.cacheCloth)
	end

	if #self.cachePet >= 2 then
		self:sortItem(self.cachePet)
	end

	if #self.cacheFragment >= 2 then
		self:sortItem(self.cacheFragment)
	end

	--对缓存中没有的物品进行排序
	local function sort( v1,v2 )
		
		if v1.quality == v2.quality then
			return tonumber(v1.id) > tonumber(v2.id)
		end
		return tonumber(v1.quality) > tonumber(v2.quality)
	end

	local function sortByQuality(v1,v2)
		-- body
		if v1.sub_type > v2.sub_type then
			return true
		end

		if v1.sub_type == v2.sub_type then
			if v1.quality > v2.quality then
				return true
			end
			if v1.quality == v2.quality then
				if v1.id > v2.id then
					return true
				end
			end
		end
		return false
	end

	table.sort(self.equip,sort)
	table.sort(self.tool,sort)
	table.sort(self.material,sortByQuality)
	table.sort(self.cloth,sort)
	table.sort(self.pet,sort)
	table.sort(self.fragment,sort)
end

--对缓存中已有的物品进行排序
function WndLibrary:sortItem( data )
	local function sort1(v1, v2)
		if v1.quality == v2.quality then
			return tonumber(v1.id) > tonumber(v2.id)
		end
		return tonumber(v1.quality) > tonumber(v2.quality)
	end
	table.sort(data,sort1)
end

--重新初始化物品信息
function WndLibrary:_initItem()
	--装备
	for i=1,#self.cacheEquip do
		if self.item[1] == nil then
			self.item[1] = {}
		end
		table.insert(self.item[1],self.cacheEquip[i])

		if self.cacheEquip[i].pokedex[1][2] == 1 then
			--武器
			table.insert(self.weapon,self.cacheEquip[i])
		elseif self.cacheEquip[i].pokedex[1][2] == 2 then
			--项链
			table.insert(self.necklace,self.cacheEquip[i])
		elseif self.cacheEquip[i].pokedex[1][2] == 3 then
			--戒指
			table.insert(self.ring,self.cacheEquip[i])
		elseif self.cacheEquip[i].pokedex[1][2] == 4 then
			--手镯
			table.insert(self.bracelet,self.cacheEquip[i])
		elseif self.cacheEquip[i].pokedex[1][2] == 5 then
			--宝物
			table.insert(self.treasure,self.cacheEquip[i])
		elseif self.cacheEquip[i].pokedex[1][2] == 6 then
			--勋章
			table.insert(self.medal,self.cacheEquip[i])
		elseif self.cacheEquip[i].pokedex[1][2] == 7 then
			--耳饰
			table.insert(self.earring,self.cacheEquip[i])
		elseif self.cacheEquip[i].pokedex[1][2] == 8 then
			--副手
			table.insert(self.deputy,self.cacheEquip[i])
		end
	end
	
	for i = 1,#self.equip do
		if self.item[1] == nil then
			self.item[1] ={}
		end
		table.insert(self.item[1],self.equip[i])
		if self.equip[i].pokedex[1][2] == 1 then
			--武器
			table.insert(self.weapon,self.equip[i])
		elseif self.equip[i].pokedex[1][2] == 2 then
			--项链
			table.insert(self.necklace,self.equip[i])
		elseif self.equip[i].pokedex[1][2] == 3 then
			--戒指
			table.insert(self.ring,self.equip[i])
		elseif self.equip[i].pokedex[1][2] == 4 then
			--手镯
			table.insert(self.bracelet,self.equip[i])
		elseif self.equip[i].pokedex[1][2] == 5 then
			--宝物
			table.insert(self.treasure,self.equip[i])
		elseif self.equip[i].pokedex[1][2] == 6 then
			--勋章
			table.insert(self.medal,self.equip[i])
		elseif self.equip[i].pokedex[1][2] == 7 then
			--耳饰
			table.insert(self.earring,self.equip[i])
		elseif self.equip[i].pokedex[1][2] == 8 then
			--副手
			table.insert(self.deputy,self.equip[i])
		end
	end

	--道具
	for i=1,#self.cacheTool do
		if self.item[2] == nil then
			self.item[2] = {}
		end
		table.insert(self.item[2],self.cacheTool[i])
		if self.cacheTool[i].pokedex[1][2] == 1 then
			table.insert(self.m_tConsumers,self.cacheTool[i])
		elseif self.cacheTool[i].pokedex[1][2] == 2 then
			table.insert(self.m_tBlessing,self.cacheTool[i])
		elseif self.cacheTool[i].pokedex[1][2] == 3 then
			table.insert(self.m_tSocialprops,self.cacheTool[i])
		end
	end

	for i = 1,#self.tool do
		if self.item[2] == nil then
			self.item[2] ={}
		end
		table.insert(self.item[2],self.tool[i])

		if self.tool[i].pokedex[1][2] == 1 then
			table.insert(self.m_tConsumers,self.tool[i])
		elseif self.tool[i].pokedex[1][2] == 2 then
			table.insert(self.m_tBlessing,self.tool[i])
		elseif self.tool[i].pokedex[1][2] == 3 then
			table.insert(self.m_tSocialprops,self.tool[i])
		end
	end
	
	--时装
	for i=1,#self.cacheCloth do
		if self.item[3] == nil then
			self.item[3] = {}
		end
		table.insert(self.item[3],self.cacheCloth[i])
		if self.cacheCloth[i].sub_type == 0 and self.cacheCloth[i].sex == self.sex then
			--头部
			table.insert(self.head,self.cacheCloth[i])
		elseif self.cacheCloth[i].sub_type == 1 and self.cacheCloth[i].sex == self.sex then
			--表情
			table.insert(self.emotion,self.cacheCloth[i])
		elseif self.cacheCloth[i].sub_type == 2 and self.cacheCloth[i].sex == self.sex then
			--衣服
			table.insert(self.dress,self.cacheCloth[i])
		elseif self.cacheCloth[i].sub_type == 3 then
			--翅膀
			table.insert(self.wing,self.cacheCloth[i])
		end
	end
	for i = 1,#self.cloth do
		if self.item[3] == nil then
			self.item[3] ={}
		end
		table.insert(self.item[3],self.cloth[i])

		if self.cloth[i].pokedex[1][2] == 1 and self.cloth[i].sex == self.sex then
			--头部
			table.insert(self.head,self.cloth[i])
		elseif self.cloth[i].pokedex[1][2] == 2 and self.cloth[i].sex == self.sex then
			--表情
			table.insert(self.emotion,self.cloth[i])
		elseif self.cloth[i].pokedex[1][2] == 3 and self.cloth[i].sex == self.sex then
			--衣服
			table.insert(self.dress,self.cloth[i])
		elseif self.cloth[i].pokedex[1][2] == 4 then
			--翅膀
			table.insert(self.wing,self.cloth[i])
		end
	end

	--宠物
	for i=1,#self.cachePet do
		if self.item[4] == nil then
			self.item[4] = {}
		end
		table.insert(self.item[4],self.cachePet[i])

		if self.cachePet[i].pokedex[1][2] == 1 then
			table.insert(self.m_tPet1,self.cachePet[i])
		elseif self.cachePet[i].pokedex[1][2] == 2 then
			table.insert(self.m_tPet2,self.cachePet[i])
		elseif self.cachePet[i].pokedex[1][2] == 3 then
			table.insert(self.m_tPet3,self.cachePet[i])
		elseif self.cachePet[i].pokedex[1][2] == 4 then
			table.insert(self.m_tPet4,self.cachePet[i])
		end
	end
	for i = 1,#self.pet do
		if self.item[4] == nil then
			self.item[4] ={}
		end
		table.insert(self.item[4],self.pet[i])

		if self.pet[i].pokedex[1][2] == 1 then
			table.insert(self.m_tPet1,self.pet[i])
		elseif self.pet[i].pokedex[1][2] == 2 then
			table.insert(self.m_tPet2,self.pet[i])
		elseif self.pet[i].pokedex[1][2] == 3 then
			table.insert(self.m_tPet3,self.pet[i])
		elseif self.pet[i].pokedex[1][2] == 4 then
			table.insert(self.m_tPet4,self.pet[i])
		end
	end

	--材料
	for i=1,#self.cacheMaterial do
		if self.item[5] == nil then
			self.item[5] = {}
		end
		table.insert(self.item[5],self.cacheMaterial[i])

		if self.cacheMaterial[i].pokedex[1][2] == 1 then
			table.insert(self.m_tMaterial1,self.cacheMaterial[i])
		elseif self.cacheMaterial[i].pokedex[1][2] == 2 then
			table.insert(self.m_tMaterial2,self.cacheMaterial[i])
		elseif self.cacheMaterial[i].pokedex[1][2] == 3 then
			table.insert(self.m_tMaterial3,self.cacheMaterial[i])
		elseif self.cacheMaterial[i].pokedex[1][2] == 4 then
			table.insert(self.m_tMaterial4,self.cacheMaterial[i])
		elseif self.cacheMaterial[i].pokedex[1][2] == 5 then
			table.insert(self.m_tMaterial5,self.cacheMaterial[i])
		end
	end
	for i = 1,#self.material do
		if self.item[5] == nil then
			self.item[5] ={}
		end
		table.insert(self.item[5],self.material[i])

		if self.material[i].pokedex[1][2] == 1 then
			table.insert(self.m_tMaterial1,self.material[i])
		elseif self.material[i].pokedex[1][2] == 2 then
			table.insert(self.m_tMaterial2,self.material[i])
		elseif self.material[i].pokedex[1][2] == 3 then
			table.insert(self.m_tMaterial3,self.material[i])
		elseif self.material[i].pokedex[1][2] == 4 then
			table.insert(self.m_tMaterial4,self.material[i])
		elseif self.material[i].pokedex[1][2] == 5 then
			table.insert(self.m_tMaterial5,self.material[i])
		end

	end

	--宠物
	for i=1,#self.cacheFragment do
		if self.item[6] == nil then
			self.item[6] = {}
		end
		table.insert(self.item[6],self.cacheFragment[i])

		if self.cacheFragment[i].pokedex[1][2] == 1 then
			table.insert(self.m_tFragment1,self.cacheFragment[i])
		elseif self.cacheFragment[i].pokedex[1][2] == 2 then
			table.insert(self.m_tFragment2,self.cacheFragment[i])
		elseif self.cacheFragment[i].pokedex[1][2] == 3 then
			table.insert(self.m_tFragment3,self.cacheFragment[i])
		elseif self.cacheFragment[i].pokedex[1][2] == 4 then
			table.insert(self.m_tFragment4,self.cacheFragment[i])
		end
	end
	for i = 1,#self.fragment do
		if self.item[6] == nil then
			self.item[6] ={}
		end
		table.insert(self.item[6],self.fragment[i])

		if self.fragment[i].pokedex[1][2] == 1 then
			table.insert(self.m_tFragment1,self.fragment[i])
		elseif self.fragment[i].pokedex[1][2] == 2 then
			table.insert(self.m_tFragment2,self.fragment[i])
		elseif self.fragment[i].pokedex[1][2] == 3 then
			table.insert(self.m_tFragment3,self.fragment[i])
		elseif self.fragment[i].pokedex[1][2] == 4 then
			table.insert(self.m_tFragment4,self.fragment[i])
		end
	end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--根据物品查找物品列表
function WndLibrary:_findByName(name)
	-- body
	WZLog("WndLibrary:_findByName ")
	local tempId = nil
	local itemInfo = nil
	local tempT = {}
	local itemName = nil
	local exist = nil
	
	for i,v in pairs(self.data) do
		for j,k in ipairs(v) do
			tempId = k.id
			itemName = k.name
			exist = string.find(itemName,name)
			if exist and exist > 0 then
				table.insert(tempT,k)
			end
		end
	end
	self:sortItem(tempT)
	return tempT
end

--根据物品品质和类型进行查找
function WndLibrary:_findByQualityAndType(quality,mainType,subType)
	WZLog("WndLibrary:_findByQualityAndType")
	local tempT=nil
	
	if mainType == 1 then --装备
		if subType == 1 then
			tempT = self.weapon
		elseif subType == 2 then
			tempT = self.necklace
		elseif subType == 3 then
			tempT = self.ring
		elseif subType == 4 then
			tempT = self.bracelet
		elseif subType == 5 then
			tempT = self.treasure
		elseif subType == 6 then
			tempT = self.medal
		elseif subType == 7 then
			tempT = self.earring
		elseif subType == 8 then
			tempT = self.deputy
		end
	elseif mainType == 2 then --道具
		if subType == 1 then
			tempT = self.m_tConsumers
		elseif subType == 2 then
			tempT = self.m_tBlessing
		elseif subType == 3 then
			tempT = self.m_tSocialprops
		end
	elseif mainType == 3 then --时装
		if subType == 1 then
			tempT = self.head
		elseif subType == 2 then
			tempT = self.emotion
		elseif subType == 3 then
			tempT = self.dress
		elseif subType == 4 then
			tempT = self.wing
		end
	elseif mainType == 4 then --宠物
		if subType == 1 then
			tempT = self.m_tPet1
		elseif subType == 2 then
			tempT = self.m_tPet2
		elseif subType == 3 then
			tempT = self.m_tPet3
		elseif subType == 4 then
			tempT = self.m_tPet4
		end
	elseif mainType == 5 then --材料

		if subType == 1 then
			tempT = self.m_tMaterial1
		elseif subType == 2 then
			tempT = self.m_tMaterial2
		elseif subType == 3 then
			tempT = self.m_tMaterial3
		elseif subType == 4 then
			tempT = self.m_tMaterial4
		elseif subType == 5 then
			tempT = self.m_tMaterial5
		end
	elseif mainType == 6 then --碎片
		if subType == 1 then
			tempT = self.m_tFragment1
		elseif subType == 2 then
			tempT = self.m_tFragment2
		elseif subType == 3 then
			tempT = self.m_tFragment3
		elseif subType == 4 then
			tempT = self.m_tFragment4
		end
	end

	return tempT
end

--根据物品类型显示类型列表
function WndLibrary:showTypeList(typeIndex)
	-- body
	WZLog("WndLibrary:showTypeList ",typeIndex)
	local  GetElement = GetElement

	local itemTypeList = GetElement(self.m_root,"itemTypeList_WndLibrary",WZUIFreeListContainer)
	itemTypeList:removeAll()
	local indexxx = 1
	local tempT = {LocalStrings.EQUIPMENT,LocalStrings.PROP,LocalStrings.DRESS,LocalStrings.BAG7,LocalStrings.MATERIAL,LocalStrings.FRAGMENT}
	local bOpen = false
	local count = 7
	if typeIndex == nil or  typeIndex < 1 then
		count = 6
	end
	for i=1,count do
		if not bOpen then
			local cellItemType = CreateElement("CellItemType_WndLibrary")
			cellItemType = WZUIContainer:luaTo(cellItemType)
			cellItemType:setTag(i-1)
			cellItemType:setVisible(true)

			local txtTypeName = GetElement(cellItemType,"txtTypeName_WndLibrary",WZUILabelTTF)
			txtTypeName:setText(tempT[1])
			if ProjConfig.LANGUAGE == "vn" then
				txtTypeName:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
				txtTypeName:setScale(0.8)
			elseif ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
				txtTypeName:setRelativePosition(GlobalMethod:ccp(0.57,0.5))
				txtTypeName:setScale(0.8)
			end

			table.remove(tempT,1)
			local btnType = GetElement(cellItemType,"btnType_WndLibrary",WZUIButton)
			btnType:setTag(indexxx)
			if i == typeIndex then
				btnType:setTouchEnable(false)
			else
				local imgArrow = GetElement(cellItemType,"imgArrow_WndLibrary",WZUIImage)
				imgArrow:setFlipY(true)
		    end
		    itemTypeList:pushBack(cellItemType)
		    indexxx = indexxx + 1
		else
			bOpen = false
			local node = self:_createTypeItem(typeIndex)
			node:setTag(i-1)
			itemTypeList:pushBack(node)
		end

	    if i == typeIndex then
			bOpen = true
		end
	end
	if self.m_movePs == nil then
		local minPs = itemTypeList:getMinPosition()
	    itemTypeList:getMoveElement():setPositionY(minPs.y)
	else
		local minPs = itemTypeList:getMinPosition()
		local maxPs = itemTypeList:getMaxPosition()
		if self.m_movePs.y <= minPs.y then
			itemTypeList:getMoveElement():setPositionY(minPs.y)
		elseif self.m_movePs.y >= maxPs.y then
			itemTypeList:getMoveElement():setPositionY(maxPs.y)
		else
			itemTypeList:getMoveElement():setPositionY(self.m_movePs.y)
		end
	end
end

function WndLibrary:_createTypeItem(typeId)
	-- body
	WZLog("WndLibrary:_createTypeItem ",typeId)
	local count = nil
	local con = nil
	local tempT = nil
	if typeId == 1 then
		tempT = {LocalStrings.WEAPON,LocalStrings.NECKLACE,LocalStrings.RING,LocalStrings.HANDLE_PRODUCT,LocalStrings.TREASURE,LocalStrings.DOWNLOADREWARD_BADGE,LocalStrings.NEWBAG8,LocalStrings.NEWBAG9}
	    count = #tempT
	elseif typeId == 2 then
		tempT = {LocalStrings.ITEM1,LocalStrings.ITEM2}
		count = #tempT
	elseif typeId == 3 then
		tempT = {LocalStrings.HEAD,LocalStrings.ITEM3,LocalStrings.CLOTHES,LocalStrings.WING}
	    count = #tempT
	elseif typeId == 5 then
		tempT = {LocalStrings.GEM,LocalStrings.ITEM8,LocalStrings.ASCENDING9,LocalStrings.BAG7,LocalStrings.WAKEUP_TEXT5}
	    count = #tempT
	elseif typeId == 6 then
		tempT = {LocalStrings.ITEM9,LocalStrings.ITEM10,LocalStrings.ITEM12}
	    count = #tempT
	elseif typeId == 4 then
		tempT = {LocalStrings.ITEM4,LocalStrings.ITEM5,LocalStrings.ITEM6,LocalStrings.ITEM7}
	    count = #tempT
	end

	con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(190,count*40))
	local bg =  WZUI9Image:create()
	bg:setFile("ui/common/common_shade_chushouheidi.png")
	bg:setOpacity(153)
	con:addChild(bg)
	local rePS = 1
	for i=1,count do
		local child = WZUIContainer:create()
		child:setUseAbsSize(true)
		child:setAbsContentSize(GlobalMethod:CCSize(190,40))
		child:setAnchorPoint(GlobalMethod:ccp(0.5,1))
		child:setRelativePosition(GlobalMethod:ccp(0.5,rePS))
		rePS = (count * 40 - i*40) / (count * 40)
		
		if i ~= count then
			local image = WZUIImage:create()
			image:setUseOriginSize(true)
			image:setAnchorPoint(GlobalMethod:ccp(0.5,0))
			image:setRelativePosition(GlobalMethod:ccp(0.5,0))
			image:setFile("ui/common/common_scale9_fengexian.png")
			image:setScaleX(0.9)
			child:addChild(image)
		end
		
		local btn = WZUIButton:create()
		btn:setLuaDoneFunctionName("onClickTypeItem")
		btn:setTag(i)

		if i == 1 then
			btn:setTouchEnable(false)
			self.m_node = btn
		end

		local normalElement = WZUIContainer:create()
		local label = WZUILabelTTF:create()
		label:setLabelStyleKey("C1_F20_S4_C3")
		label:setText(tempT[i])


		if ProjConfig.LANGUAGE == "pt" then
			label:setScale(0.75)
		end
		if ProjConfig.LANGUAGE == "es" then
			label:setScale(0.8)
		end

		normalElement:addChild(label)
		btn:setNormalElement(normalElement)

		local selectEle = WZUIContainer:create()
		label = WZUILabelTTF:create()
		label:setLabelStyleKey("C1_F20_S4_C3")
		label:setText(tempT[i])

		if ProjConfig.LANGUAGE == "pt" then
			label:setScale(0.75)
		end
		if ProjConfig.LANGUAGE == "es" then
			label:setScale(0.8)
		end

		selectEle:addChild(label)
		btn:setSelectElement(selectEle)

		local disEle = WZUIContainer:create()

		local disIma = WZUI9Image:create()
		disIma:setFile("ui/common/common_scale9_wbbsxz.png")
		disIma:setScaleX(0.96)
		disIma:setScaleY(0.94)
		disIma:setName("imgTypeSel_WndLibrary")
		disEle:addChild(disIma)

		label = WZUILabelTTF:create()
		label:setLabelStyleKey("C1_F20_S4_C3")
		label:setText(tempT[i])
		disEle:addChild(label)

		if ProjConfig.LANGUAGE == "pt" then
			label:setScale(0.75)
		end
		if ProjConfig.LANGUAGE == "es" then
			label:setScale(0.8)
		end

		btn:setDisableElement(disEle)
		child:addChild(btn)

		con:addChild(child)
	end

	return con
end

function WndLibrary:_findItemByQuality(quality,tData)
	WZLog("WndLibrary:_findItemByQuality")
	local tempT = {}
	for i,v in ipairs(tData) do
		if v.quality == quality then
			table.insert(tempT,v)
		end
	end
	return tempT
end

function WndLibrary:_findItemListByType()
	-- body
	WZLog("WndLibrary:_findItemListByType =",self.m_nodeCurTypeByName)
	local tabDataList = nil
	if self.m_nodeCurType == 1 then --装备
		if self.m_nodeCurTypeByName == 1 then --武器
			tabDataList = self.weapon
		elseif self.m_nodeCurTypeByName == 2 then  --项链
			tabDataList = self.necklace
	    elseif self.m_nodeCurTypeByName == 3 then --戒指
	    	tabDataList = self.ring
	    elseif self.m_nodeCurTypeByName == 4 then --护腕
	    	tabDataList = self.bracelet
	    elseif self.m_nodeCurTypeByName == 5 then --宝物
	    	tabDataList = self.treasure
	    elseif self.m_nodeCurTypeByName == 6 then --徽章
	    	tabDataList = self.medal
	    elseif self.m_nodeCurTypeByName == 7 then --耳饰
	    	tabDataList = self.earring
	    elseif self.m_nodeCurTypeByName == 8 then --副手
	    	tabDataList = self.deputy
		end
	elseif self.m_nodeCurType == 2 then --道具
		if self.m_nodeCurTypeByName == 1 then --消耗物
			tabDataList = self.m_tConsumers
	    elseif self.m_nodeCurTypeByName == 2 then --社交道具
	    	tabDataList = self.m_tSocialprops
		end
	elseif self.m_nodeCurType == 3 then --时装
		if self.m_nodeCurTypeByName == 1 then --头部
			tabDataList = self.head
		elseif self.m_nodeCurTypeByName == 2 then --脸部
			tabDataList = self.emotion
	    elseif self.m_nodeCurTypeByName == 3 then --服装
	    	tabDataList = self.dress
	    elseif self.m_nodeCurTypeByName == 4 then --翅膀
	    	tabDataList = self.wing
		end
	elseif self.m_nodeCurType == 4 then --宠物
		if self.m_nodeCurTypeByName == 1 then --均衡型
			tabDataList = self.m_tPet1
		elseif self.m_nodeCurTypeByName == 2 then --攻击型
			tabDataList = self.m_tPet2
	    elseif self.m_nodeCurTypeByName == 3 then --防御型
	    	tabDataList = self.m_tPet3
	    elseif self.m_nodeCurTypeByName == 4 then --生命型
	    	tabDataList = self.m_tPet4
		end
	elseif self.m_nodeCurType == 5 then  --材料
		if self.m_nodeCurTypeByName == 1 then --宝石
			tabDataList = self.m_tMaterial1
		elseif self.m_nodeCurTypeByName == 2 then --锻造
			tabDataList = self.m_tMaterial2
	    elseif self.m_nodeCurTypeByName == 3 then --圣光
	    	tabDataList = self.m_tMaterial3
	    elseif self.m_nodeCurTypeByName == 4 then --宠物
	    	tabDataList = self.m_tMaterial4
	    elseif self.m_nodeCurTypeByName == 5 then --觉醒
	    	tabDataList = self.m_tMaterial5
		end
	elseif self.m_nodeCurType == 6 then --碎片
		if self.m_nodeCurTypeByName == 1 then --道具碎片
			tabDataList = self.m_tFragment1
		elseif self.m_nodeCurTypeByName == 2 then --皮肤碎片
			tabDataList = self.m_tFragment2
	    -- elseif self.m_nodeCurTypeByName == 3 then --时装碎片
	    -- 	tabDataList = self.m_tFragment3
	    elseif self.m_nodeCurTypeByName == 3 then --装备碎片
	    	tabDataList = self.m_tFragment4
		end
	end

	return tabDataList
end

-------------------------------------私有方法模块End----------------------------------------
