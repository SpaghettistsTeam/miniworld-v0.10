
DIR_NEG_X = 0
DIR_POS_X = 1
DIR_NEG_Z = 2
DIR_POS_Z = 3
DIR_NEG_Y = 4
DIR_POS_Y = 5

function NeighborBlock(x, y, z, dir)
	if dir==DIR_NEG_X then return x-1,y,z
	elseif dir==DIR_POS_X then return x+1,y,z
	elseif dir==DIR_NEG_Z then return x,y,z-1
	elseif dir==DIR_POS_Z then return x,y,z+1
	elseif dir==DIR_NEG_Y then return x,y-1,z
	else return x,y+1,z end
end

function ReverseDirection(dir)
	if dir==DIR_NEG_X then return DIR_POS_X
	elseif dir==DIR_POS_X then return DIR_NEG_X
	elseif dir==DIR_NEG_Z then return DIR_POS_Z
	elseif dir==DIR_POS_Z then return DIR_NEG_Z
	elseif dir==DIR_NEG_Y then return DIR_POS_Y
	else return DIR_NEG_Y end
end

function LeftOnPlaceDir(nx,ny,nz, placedir)
	if placedir == DIR_NEG_X then
		return nx,ny,nz+1
	elseif placedir == DIR_POS_X then
		return nx,ny,nz-1
	elseif placedir == DIR_NEG_Z then
		return nx-1,ny,nz
	else
		return nx+1,ny,nz
	end
end

function RightOnPlaceDir(nx,ny,nz)
	if placedir == DIR_NEG_X then
		return nx,ny,nz-1
	elseif placedir == DIR_POS_X then
		return nx,ny,nz+1
	elseif placedir == DIR_NEG_Z then
		return nx+1,ny,nz
	else
		return nx-1,ny,nz
	end
end

--扔骰子, x/100
function RollPoint(x)
	return math.random() <= (x/100)
end

function GenRandomFloat()
	return math.random()
end

--放一个巨型蘑菇
BigMushroom_Data_Top = {4, 2, 7, 0, 12, 1, 5, 3, 6};
BigMushroom_Data_Negx = {8, -1, 9, 8, -1, 9, 4, 0, 5};
BigMushroom_Data_Posx = {11, -1, 10, 11, -1, 10, 7, 1, 6};
BigMushroom_Data_Negz = {8, -1, 11, 8, -1, 11, 4, 2, 7};
BigMushroom_Data_Posz = {9, -1, 10, 9, -1, 10, 5, 3, 6};

function PlaceBigMushroomBlock(x, y, z, id, data)
	if CurWorld:getBlockID(x,y,z) == 0 then
		CurWorld:setBlockAll(x,y,z,id,data)
	end
end

function CheckBigMushroomSpace(ox, oy, oz, height)
	for i=1, height, 1 do
		if CurWorld:getBlockID(ox,oy+i,oz) > 0 then return false end
	end
	return true
end

function PlaceBigMushroom(ox, oy, oz, height, leaf, leaf_center, stem)

	if not CheckBigMushroomSpace(ox,oy,oz,height) then return end

	--place stem
	for i=0, height-2, 1 do
		CurWorld:setBlockAll(ox, oy+i, oz, stem, 0)
	end

	--place top leaf
	for z=-1, 1, 1 do
		for x=-1, 1, 1 do
			if x==0 and z==0 then
				PlaceBigMushroomBlock(ox,oy+height-1,oz, leaf_center, DIR_POS_Y)
			else
				bdata = BigMushroom_Data_Top[(z+1)*3+x+1+1]
				PlaceBigMushroomBlock(ox+x, oy+height-1, oz+z, leaf, bdata)
			end
		end
	end

	--place negx, posx side
	for y=-1, 1, 1 do
		newy = oy+height-3+y
		for z=-1, 1, 1 do
			if y<=0 and z==0 then
				PlaceBigMushroomBlock(ox-2, newy, oz, leaf_center, DIR_NEG_X)
				PlaceBigMushroomBlock(ox+2, newy, oz, leaf_center, DIR_POS_X)
			else
				bdata = BigMushroom_Data_Negx[(y+1)*3+z+1+1]
				PlaceBigMushroomBlock(ox-2, newy, oz+z, leaf, bdata)

				bdata = BigMushroom_Data_Posx[(y+1)*3+z+1+1]
				PlaceBigMushroomBlock(ox+2, newy, oz+z, leaf, bdata)
			end
		end
	end

	--place negz, posz side
	for y=-1, 1, 1 do
		newy = oy+height-3+y
		for x=-1, 1, 1 do
			if y<=0 and x==0 then
				PlaceBigMushroomBlock(ox, newy, oz-2, leaf_center, DIR_NEG_Z)
				PlaceBigMushroomBlock(ox, newy, oz+2, leaf_center, DIR_POS_Z)
			else			
				bdata = BigMushroom_Data_Negz[(y+1)*3+x+1+1]
				PlaceBigMushroomBlock(ox+x, newy, oz-2, leaf, bdata)

				bdata = BigMushroom_Data_Posz[(y+1)*3+x+1+1]
				PlaceBigMushroomBlock(ox+x, newy, oz+2, leaf, bdata)
			end
		end
	end
end


BigMushroomBrown_Top = 
{
	{-1, 4, 2, 2, 2, 7, -1},
	{0,  8, 8, 8, 8, 8,  1},
	{0,  8, 8, 8, 8, 8,  1},
	{0,  8, 8, 8, 8, 8,  1},
	{0,  8, 8, 8, 8, 8,  1},
	{0,  8, 8, 8, 8, 8,  1},
	{-1, 5, 3, 3, 3, 6, -1}
}
function PlaceBigMushroomBrown(ox, oy, oz, height, leaf, leaf_center, stem)

	if not CheckBigMushroomSpace(ox,oy,oz,height) then return end

	--place stem
	for i=0, height-2, 1 do
		CurWorld:setBlockAll(ox, oy+i, oz, stem, 0)
	end

	--place top leaf
	for z=-3, 3, 1 do
		for x=-3, 3, 1 do
			bdata = BigMushroomBrown_Top[z+4][x+4]
			if bdata == 8 then
				PlaceBigMushroomBlock(ox+x, oy+height-1, oz+z, leaf_center, DIR_POS_Y)
			elseif bdata >= 0 then
				PlaceBigMushroomBlock(ox+x, oy+height-1, oz+z, leaf, bdata)
			end
		end
	end
end
