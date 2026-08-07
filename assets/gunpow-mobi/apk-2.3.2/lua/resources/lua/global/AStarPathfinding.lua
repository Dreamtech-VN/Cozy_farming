--AStarPathfinding.lua
--@brief	简单的A*寻路算法
--@date		2018/9/5
--@author	qixiang_xie
AStarPathfinding = 
{
	--待检查的节点
	openList = {},

	--已检查过的节点
	closeList = {},

    --不可走的
    unWaklList = {},

    --行的总数
	rowAmount = 0 ,

    --列的总数
	columnAmount = 0,
}

function AStarPathfinding:Init()
	self.openList = {}
	self.closeList = {}
	self.unWaklList = {}
	self.bStartFind = false
end

function AStarPathfinding:SetFunTable(funTable)
	self.funTable = funTable
end

--设置行列的总数
function AStarPathfinding:SetRowAndColumnAmount(rowAmount,columnAmount)
	self.rowAmount = rowAmount
	self.columnAmount = columnAmount
end

--开始点的行号、列号
--@param 	roleIndex: 角色索引
function AStarPathfinding:SetStartPoint(rowNum, columnNum, roleIndex)
	self:Init()
	self.startRowNum = rowNum
	self.startColumnNum = columnNum
	self.roleIndex = roleIndex
	local tempNode = {}
	tempNode.rowNum = rowNum
	tempNode.columnNum = columnNum
	tempNode.G = 0
	tempNode.H = 0
	tempNode.F = 0
	tempNode.walkable = true
	tempNode.parent = nil
	table.insert(self.openList,tempNode)
end

--设置查找完成的回调函数
function AStarPathfinding:SetFindFinishCallback(tableLua,tableFun)
	self.finishCallbackTable = tableLua
	self.finishCallbckFun = tableFun
end

--开始寻路
function AStarPathfinding:StartFindPath()
	if self.bStartFind then 
		LogError("AStarPathfinding:StartFindPath")
		return 
	end
	self.bStartFind = true
	--DDDScheduler:AddScheduler(1,0,0,function ()
		self:FindUnWalkableNode()
		local curNode = self.openList[1]
		table.remove(self.openList,1)
		table.insert(self.closeList,curNode)
		self:FindNodeAroundNode(curNode)

		self:SetHFValue()
		self:FindPath()
	--end)
end

--查找不可走的node
function AStarPathfinding:FindUnWalkableNode()
	for i=1,self.rowAmount do
		for j=1,self.columnAmount do
			local cellFloor = self.funTable:GetGroundInfo(i,j)
			local tempNode = {}
			tempNode.rowNum = i
	        tempNode.columnNum = j
	        tempNode.G = 0
			tempNode.H = 0
			tempNode.F = 0
			tempNode.walkable = true
			tempNode.parent = nil
			if cellFloor and cellFloor.isGoods then
				tempNode.walkable = false
			end

			if not tempNode.walkable then
				table.insert(self.unWaklList,tempNode)
			end
		end
	end
	
end

--判断一个格子是否可走
function  AStarPathfinding:Walkable(rowNum,columnNum)
	for i,v in ipairs(self.closeList) do
		if v.rowNum == rowNum and v.columnNum == columnNum then
			return false
		end
	end

	for i,v in ipairs(self.unWaklList) do
		if v.rowNum == rowNum and v.columnNum == columnNum then
			return false
		end
	end
	return true
end

--查找node的周围node
function AStarPathfinding:FindNodeAroundNode(curNode)
	local curNodeRowNum = curNode.rowNum
	local curNodeColumnNum = curNode.columnNum
	local walkable = false
	local curRowNum = 0
	local curColumnNum = 0
	for i=1,8 do
		walkable = false
		local cellFloor = nil
		if i == 1 then --右边
			curRowNum = curNodeRowNum
			curColumnNum = curNodeColumnNum+1
			cellFloor = self.funTable:GetGroundInfo(curRowNum,curColumnNum)
			if cellFloor then
				walkable = self:Walkable(curRowNum,curColumnNum)
			end
		-- elseif i == 2 then --右斜上
		-- 	curRowNum = curNodeRowNum -1
		-- 	curColumnNum = curNodeColumnNum+1
		-- 	cellFloor = self.funTable:GetGroundInfo(curRowNum,curColumnNum)
		-- 	if cellFloor then
		-- 		walkable = self:Walkable(curRowNum,curColumnNum)
		-- 	end
		-- elseif i == 3 then --右斜下
		-- 	curRowNum = curNodeRowNum +1
		-- 	curColumnNum = curNodeColumnNum+1
		-- 	cellFloor = self.funTable:GetGroundInfo(curRowNum,curColumnNum)
		-- 	if cellFloor then
		-- 		walkable = self:Walkable(curRowNum,curColumnNum)
		-- 	end
		elseif i == 4 then --正上
			curRowNum = curNodeRowNum -1
			curColumnNum = curNodeColumnNum
			cellFloor = self.funTable:GetGroundInfo(curRowNum,curColumnNum)
			if cellFloor then
				walkable = self:Walkable(curRowNum,curColumnNum)
			end
		elseif i == 5 then --正下
			curRowNum = curNodeRowNum +1
			curColumnNum = curNodeColumnNum
			cellFloor = self.funTable:GetGroundInfo(curRowNum,curColumnNum)
			if cellFloor then
				walkable = self:Walkable(curRowNum,curColumnNum)
			end
		elseif i == 6 then --左
			curRowNum = curNodeRowNum 
			curColumnNum = curNodeColumnNum -1
			cellFloor = self.funTable:GetGroundInfo(curRowNum,curColumnNum)
			if cellFloor then
				walkable = self:Walkable(curRowNum,curColumnNum)
			end
		-- elseif i == 7 then --左斜上
		-- 	curRowNum = curNodeRowNum - 1
		-- 	curColumnNum = curNodeColumnNum -1
		-- 	cellFloor = self.funTable:GetGroundInfo(curRowNum,curColumnNum)
		-- 	if cellFloor then
		-- 		walkable = self:Walkable(curRowNum,curColumnNum)
		-- 	end
		-- elseif i == 8 then --左斜下
		-- 	curRowNum = curNodeRowNum + 1
		-- 	curColumnNum = curNodeColumnNum -1
		-- 	cellFloor = self.funTable:GetGroundInfo(curRowNum,curColumnNum)
		-- 	if cellFloor then
		-- 		walkable = self:Walkable(curRowNum,curColumnNum)
		-- 	end
		end

		if walkable then
			local bExist = false
			local existNode = nil
			for i,v in ipairs(self.openList) do
				if v.rowNum == curRowNum and v.columnNum == curColumnNum then
					bExist = true
					existNode = v
				end
			end
			if not bExist then
				local tempNode = {}
				tempNode.rowNum = curRowNum
		        tempNode.columnNum = curColumnNum
		        tempNode.G = 0
				tempNode.H = 0
				tempNode.F = 0
				tempNode.walkable = true
				tempNode.parent = curNode
				self:SetGValue(tempNode)
				self:SetHFValueByNode(tempNode)
				--if bInclined then
				--	local bInsert = self:FindInclinedIsunWalk(curNode,tempNode)
				--	if bInsert then
				--		table.insert(self.openList,tempNode)
				--	end
				--else
				table.insert(self.openList,tempNode)
				--end
			else
				local GValue = self:FindDirToCurNode(curNode,existNode)
				if GValue < existNode.G then --有更优的重新设置H、F值
					existNode.parent = curNode
					self:SetHFValue(existNode)
				end
			end
		end
	end
end

--判断斜着的方格的上方或者下方是否可以斜着走（没有墙挡住可以斜着走）
function AStarPathfinding:FindInclinedIsunWalk(curNode,targetNode)
	if targetNode.rowNum == curNode.rowNum + 1 and targetNode.columnNum == curNode.columnNum+1 then --右下斜
		for i,v in ipairs(self.unWaklList) do
			if v.rowNum == curNode.rowNum and v.columnNum == curNode.columnNum + 1 then
				return false
			end
		end
	elseif targetNode.rowNum == curNode.rowNum - 1 and targetNode.columnNum == curNode.columnNum+1 then --右上斜
		for i,v in ipairs(self.unWaklList) do
			if v.rowNum == curNode.rowNum and v.columnNum == curNode.columnNum + 1 then
				return false
			end
		end
	elseif targetNode.rowNum == curNode.rowNum + 1 and targetNode.columnNum == curNode.columnNum - 1 then --左下斜
		for i,v in ipairs(self.unWaklList) do
			if v.rowNum == curNode.rowNum and v.columnNum == curNode.columnNum - 1 then
				return false
			end
		end
	elseif targetNode.rowNum == curNode.rowNum - 1 and targetNode.columnNum == curNode.columnNum - 1 then --左上斜
		for i,v in ipairs(self.unWaklList) do
			if v.rowNum == curNode.rowNum and v.columnNum == curNode.columnNum - 1 then
				return false
			end
		end
	end
	return true
end

--查找G值
function AStarPathfinding:SetGValue(node)
	local bInclined = false
	-- if node.rowNum  == node.parent.rowNum+1 and node.columnNum == node.parent.columnNum+1  then --右下斜
	-- 	node.G = node.parent.G + 14
	-- 	bInclined = true
	-- elseif node.rowNum  == node.parent.rowNum - 1 and node.columnNum == node.parent.columnNum+1 then --右上斜
	-- 	node.G =  node.parent.G + 14
	-- 	bInclined = true
	-- elseif node.rowNum  == node.parent.rowNum + 1 and node.columnNum == node.parent.columnNum - 1 then --左下斜
	-- 	node.G =  node.parent.G + 14
	-- 	bInclined = true
	-- elseif node.rowNum  == node.parent.rowNum - 1 and node.columnNum == node.parent.columnNum - 1 then --左上斜
	-- 	node.G =  node.parent.G + 14
	-- 	bInclined = true
	-- else
	node.G = node.parent.G + 10
	--end
	return bInclined
end


function AStarPathfinding:FindDirToCurNode(curNode,aroundNode)
	local addValue = nil
	local binclined = false
	-- if aroundNode.rowNum  == curNode.rowNum+1 and aroundNode.columnNum == curNode.columnNum+1  then --右下斜
	-- 	addValue = curNode.G + 14
	-- 	binclined = true
	-- elseif aroundNode.rowNum  == curNode.rowNum - 1 and aroundNode.columnNum == curNode.columnNum+1 then --右上斜
	-- 	addValue = curNode.G + 14
	-- 	binclined = true
	-- elseif aroundNode.rowNum  == curNode.rowNum + 1 and aroundNode.columnNum == curNode.columnNum - 1 then --左下斜
	-- 	addValue = curNode.G + 14
	-- 	binclined = true
	-- elseif aroundNode.rowNum  == curNode.rowNum - 1 and aroundNode.columnNum == curNode.columnNum - 1 then --左上斜
	-- 	addValue = curNode.G + 14
	-- 	binclined = true
	-- else
	addValue = curNode.G + 10
	--end
	return addValue ,binclined
end

function AStarPathfinding:SetTargetRowAndColumn(row,column)
	self.targetRow = row
	self.targetColumn = column
end

--查找H、F值
function AStarPathfinding:SetHFValue()
	for i,v in ipairs(self.openList) do
		self:SetHFValueByNode(v)
	end
end

function AStarPathfinding:SetHFValueByNode(node)
	local rowCount = math.abs(self.targetRow - node.rowNum)
	local columnCount = math.abs(self.targetColumn - node.columnNum)
	local hValue = rowCount + columnCount 
	node.H = hValue * 10 
	node.F = node.G + node.H
end

function AStarPathfinding:FindPath()
	local bContinue = true
	local indexx = nil
	while (bContinue) do 
		for i,v in ipairs(self.openList) do
			if v.rowNum == self.targetRow and v.columnNum == self.targetColumn then
				bContinue = false
				indexx = i
				break
			end
		end

		if #self.openList <= 0 then --查找完所有没有找到可通过的路径
			bContinue = false
		end

		if bContinue then
			self:FindFastNode()
		end
    end
    
    bContinue = true
    local bStart = true
    local tempTT = {}
    local parent = nil
    if indexx ~= nil then
    	while (bContinue) do
			local tempT = {}
			if bStart then
				table.insert(tempT,self.openList[indexx].rowNum)
				table.insert(tempT,self.openList[indexx].columnNum)
				table.insert(tempTT,tempT)
				parent =self.openList[indexx].parent 
				bStart = false
			else
				if parent then
					if parent.rowNum == self.startRowNum and parent.columnNum == self.startColumnNum then
						bContinue = false
					else
						table.insert(tempT,parent.rowNum)
					    table.insert(tempT,parent.columnNum)
					    table.insert(tempTT,tempT)
					    parent= parent.parent
					end
				else
					bContinue = false
				end
			end
        end
    end
    if self.finishCallbackTable and self.finishCallbckFun then
    	self.finishCallbckFun(self.finishCallbackTable,tempTT, self.roleIndex)
    end
    self.bStartFind = false
end

--查找当前节点到目标节点的最优下个节点
function AStarPathfinding:FindFastNode()
	local fastNode = nil
	local curNode = nil
	local indexx = nil
	for i,v in ipairs(self.openList) do
		if curNode == nil then
			curNode = v
			indexx = i
		end

		if v.F < curNode.F then
			curNode = v
			indexx = i
		end
	end
	table.insert(self.closeList,curNode)
	table.remove(self.openList,indexx)

	self:FindNodeAroundNode(curNode)
end

