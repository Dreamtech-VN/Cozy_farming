--SceneSelectActorData.lua
--@brief	SceneSelectActor的数据模块
--@date		2016-10-20
--@author	binshao
--@note		角色创建界面

SceneSelectActor = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneSelectActor:_init()
	self.m_root = nil	 	  			--场景根节点
	self.data = nil
	self.index = 1
	self.cellInfo = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneSelectActor:_unInit()
	self.m_root = nil
	self.data = nil
	self.index = 1
	self.cellInfo = nil
end

function SceneSelectActor:setActorList(playerId, name, level, title, fighting, weaponInfo,weaponId, headId, faceId, bodyId, wingId, petMessage, sex, colour, bodycolour, vipLevel)
	WZLog("---------setActorList--------------",#playerId)
	self.data = {}
	for i = 1,#playerId do
		local info = {}
		info.playerId = playerId[i]
		info.name = name[i]
		info.level = level[i]
		info.title = title[i]
		info.fighting = fighting[i]
		info.weaponInfo = json.decode(weaponInfo[i])
		info.weaponId = weaponId[i]
		info.headId = headId[i]
		info.bodyId = bodyId[i]
		info.faceId = faceId[i]
		info.wingId = wingId[i]
		if petMessage[i] and #petMessage[i] > 0 then
			info.petMessage = json.decode(petMessage[i])
		end
		info.sex = sex[i]
		info.colour = colour[i]
		info.bodycolour = bodycolour[i]
		info.vipLevel = vipLevel[i]
		table.insert(self.data,info)
	end
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneSelectActor:createElement()
	local element = WZUISystem:getInstance():createElement("SceneSelectActor")
	assert(element, "SceneSelectActor create element failed!")
	self:_init()
	return element
end

function SceneSelectActor:saveCellInfo(index,cell,tcell)
	if self.cellInfo[index] == nil then self.cellInfo[index] = {} end
	self.cellInfo[index].cell = cell
	self.cellInfo[index].tcell = tcell
	self.cellInfo[index].tag = index
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
