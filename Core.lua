--[[-------------------------------------------------------------------------
--
--  Core Model
--  内核模块
--
--  功能:一些常用,可重复使用的公共函数
--
-------------------------------------------------------------------------]]--

--[[-------------------------------------------------------------------------
--  从消息获取物品ID和链接:如CHAT_MSG_LOOT:Util.lua
-------------------------------------------------------------------------]]--
function Tinom.GetItemInfoFromHyperlink(link)
	local strippedItemLink, itemID = link:match("|Hitem:((%d+).-)|h");
	if itemID then
		return tonumber(itemID), strippedItemLink;
	end
end

function Tinom.SliderValueFloor( value )
	assert(value);

	value = math.floor(value * 100 + 0.5) / 100;
	if (value ~= 0) then
		value = math.max(0.5, value);
	end
	return value;
end

function Tinom.CheckNameInTable(checkTable,checkName)
	assert(checkName and checkTable)

	index = strsub(checkName,1,3)
	if checkTable[index] then
	  for _,v in pairs(checkTable[index]) do
		if checkName == v then
		  return true;
		end
	  end
	end
	return false;
end

function Tinom.OldToNewTable(oldTable, newTable)
	for k,v in next, oldTable do
		Tinom.AddAuthorToTable(v,newTable)
	end
end

function Tinom.AddAuthorToTable(tableList, author)
	assert(author and tableList)

	index = strsub(author,1,3)
	if not tableList[index] then
		tableList[index] = {};
	end
	table.insert(tableList[index],author)
end

function Tinom.TextToTable( textIn )
	assert( textIn )

	local tableOut = {};
	for author in string.gmatch(textIn,"%S+") do
		local index = strsub(author,1,3)
		if not tableOut[index] then
			tableOut[index] = {};
		end
		for i,v in ipairs(tableOut[index]) do
			if author == v then
				table.remove(tableOut[index],i)
			end
		end
		
		table.insert(tableOut[index],author)
	end
	return tableOut;
end

function Tinom.TableToText( tableIn )
	assert(tableIn)

	local textOut = "";
	local num = 0;
	for k,vlist in pairs(tableIn) do
		textOut = textOut..table.concat(vlist,"\n").."\n";
		num = num + #vlist;
	end
	return textOut, num;
end

function Tinom.IsMe(nameIn)
	if nameIn == UnitName("player") then
		return true;
	end
	return false;
end