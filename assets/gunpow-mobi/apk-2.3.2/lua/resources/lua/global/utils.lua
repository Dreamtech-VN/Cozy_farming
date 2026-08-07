--工具方法

--格式化时间
--@param	second:秒数
--@return	00:00:00  格式时间字符串
function utilsFormatTime(second) 
	local t = second

	local day = math.floor(t / 86400)
	t = t - day * 86400
	local h = math.floor(t / 3600)
	t = t - h * 3600
	if h < 10 then h = "0"..h end
	local m = math.floor(t / 60)
	t = t - m * 60
	if m < 10 then m = "0"..m end
	local s = t
	if s < 10 then s = "0"..s end

	local txtTime = h..":"..m..":"..s

	return txtTime
end

--判断某个数值是否在表中
function utilsValueInTable(value, table)
	for i=1,#table do
		if table[i] == value then
			return true
		end
	end
	return false
end

--判断某个数值是否在表的key中
function utilsValueInTableKey(value, table)
	for k,v in pairs(table) do
		if value == k then
			return true
		end
	end
	return false
end
