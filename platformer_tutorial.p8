pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--variables
function _init()
	player={
		sp=1,
		x=59,
		y=59,
		w=8,
		h=8,
		flp=false,
		dx=0,
		dy=0,
		max_dx=2,
		max_dy=3,
		acc=0.5,
		boost=4,
		anim=0,
		running=false,
		jumping=false,
		falling=false,
		sliding=false,
		landed=false,
	}
	
	gravity=0.3
	friction=0.85
	
	--simple camera
	cam_x=0
end


-->8
--update and draw
function _update()
	player_update()
	player_animate()
	
	--simple camera
	cam_x=player.x
	camera(cam_x,0)
end

function _draw()
	cls()
	map(0,0)
	spr(player.sp,player.x,player.y,1,1,player.flp)
end
-->8
--collisions

function collide_map(obj,aim,flag)
	--obj=table needs x,y,w,h
	
	local x=obj.x local y=obj.y
	local w=obj.w local h=obj.h
	
	local x1=0 local y1=0
	local x2=0 local y2=0
	
	if aim=="left" then
		x1=x-1 			y1=y
		x2=x   			y2=y+h-1
	
	elseif aim=="right" then
		x1=x+w+1 			y1=y
		x2=x+w   			y2=y+h-1
	
	elseif aim=="up" then
		x1=x+2				y1=y-1
		x2=x+w-3		y2=y
		
	elseif aim=="down" then
		x1=x+2						y1=y+h
		x2=x+w+3				y2=y+h
	end
	
	--pixels to tiles
	x1/=8				y1/=8
	x2/=8				y2/=8
	
	if fget(mget(x1,y1), flag)
	or fget(mget(x1,y2), flag)
	or fget(mget(x2,y1), flag)
	or fget(mget(x2,y2), flag) then
			return true
	else return false
	end
end
-->8
--player

function player_update()
	--physics
	player.dy+=gravity
	player.dx*=friction
	
	--controls
	if btn(⬅️) then
		player.dx-=player.acc
		player.running=true
		player.flp=true
	end
	if btn(➡️) then
		player.dx+=player.acc
		player.running=true
		player.flp=false
	end
	
	--slide
	if player.running
	and not btn(⬅️)
	and not btn(➡️)
	and not player.falling
	and not player.jumping then
		player.running=false
		player.sliding=true
	end
	
	--jump
	if btnp(❎)
	and player.landed then
		player.dy-=player.boost
		player.landed=false
	end
	
	
	--check collision up and down
	if player.dy>0 then
			player.falling=true
			player.landed=false
			player.jumping=false
			
				
			if collide_map(player,"down",0) then
				player.landed=true
				player.falling=false
				player.dy=0
				player.y-=(player.y+player.h)%8
			end
	elseif player.dy<0 then
			player.jumping=true
			if collide_map(player,"up",1) then
				player.dy=0
			end
	end
	
	-- check collision left and right
	if player.dx<0 then
				if collide_map(player,"left",1) then
							player.dx=0
				end
	elseif player.dx>0 then
				if collide_map(player,"right",1) then
							player.dx=0
				end
	end
	
	
	-- stop sliding
	if player.sliding then
				if abs(player.dx)<.2
				or player.running then
						player.dx=0
						player.sliding=false
				end
	end
	
	player.x+=player.dx
	player.y+=player.dy
end

function player_animate()
		if player.jumping then
				player.sp=7
		elseif player.falling then
				player.sp=8
		elseif player.sliding then
				player.sp=9
		elseif player.running then
				if time()-player.anim>.1 then
						player.anim=time()
						player.sp+=1
						if player.sp>6 then
								player.sp=3
				end
		end
		else -- player idle
				if time()-player.anim>.3 then
						player.anim=time()
						player.sp+=1
						if player.sp>2 then
								player.sp=1
						end
				end
		end
end
__gfx__
0000000000444440004444400004444400044444000444440004444400044444b004444400000000000000000000000000000000000000000000000000000000
0000000000bbbbb000bbbbb00bbbbbbb0b0bbbbb0bbbbbbb0b0bbbbb00bbbbbb0bbbbbbb04444400000000000000000000000000000000000000000000000000
007007000bf71f100bf71f10b00ff71fb0bff71fb00ff71fb0bff71f0b0ff71f000ff71f0bbbbb00000000000000000000000000000000000000000000000000
000770000bfffff00bfffef0000ffffe000ffffe000ffffe000ffffeb00ffffe000ffffebf71f100000000000000000000000000000000000000000000000000
00077000000bb00000bbbb000fbbb0000fbbb0000fbbb0000fbbb00000bbb0000000bb00bfffef00000000000000000000000000000000000000000000000000
0070070000bbbb000f0bb0f0000bb000000bb000000bb000000bb0000f0bb0000000bb0000bbbbf0000000000000000000000000000000000000000000000000
000000000f0b30f0000b30000bb0300000b300000330b000003b0000003b000000000b300f0bb300000000000000000000000000000000000000000000000000
0000000000b0030000b003000000300000b300000000b000003b000003b00000000000b00000bb33000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00bbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000
3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3b0bbbbbbb3bbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000
3bbb3bbbbbbb344bb3bbbb34bbbbbb33bbb34b43bbbbb334433bbbbb000000000000000000000000000000000000000000000000000000000000000000000000
33b343b3b3b343b433bbbbb4bbbbb344bb344b44bbbbb3344433b3bb000000000000000000000000000000000000000000000000000000000000000000000000
4434443434b3443443bb343433b3344433444bb4bbbb34444d444bbb000000000000000000000000000000000000000000000000000000000000000000000000
4944444444b3444443b344444334494444494b34bb33449444443bbb000000000000000000000000000000000000000000000000000000000000000000000000
444f44444f3444944434d449444d44444f444344bb44444444f44bbb000000000000000000000000000000000000000000000000000000000000000000000000
444444444444444444444444f444444444444444444d44444444444b000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444f44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f44444444444d44444224444f447444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444664444444444f42e24444447744000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444d664449444444444224444476444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444dd64444444444444444447764444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49444dd44f44444444d4444444744494000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444444444944444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444444a444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333334444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb3bbbb3bb33bb9999499994994499000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb3bbbbbbbbbbbb9994999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333334444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3bbb3bbbbbbbbbb9499949999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3bb33bbbb3b3bbb9499449999494999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333334444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bb300000000000049940000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bb300003bb3000049940000499400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bb300003bb3000049940000499400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0033b300003333000044940000444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bb300003bb3000049940000499400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bb300003bb3000049940000499400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bb300003bb3000049940000499400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003b3300003bb3000049440000499400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bb300003bb3000049940000499400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303030303000000000000000000030303030000020000000000000000000101010100000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
7070555555555555555555555555555500000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070555555555555555555555555555500000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070555555555555555555555555555500000000000000000000000000000000000000616161000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070555555555555555555555555555500000000000000000000000000000000000000000070007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070555555555555555555555555555500000000000000000000000000000000000000000070007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070555555555555555555555555555500000000000000000000000000000000000000000061616100000000000000000062616161000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070555555555555555555555555555500000000000000000000000000000000000000000070007000000000000000000062630000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070555555555555555555625555555500000000000000000000000000000000000000000070007000000000000000000063000000000060000000000060600000000000000000000000000000000000000000000000000000000000000000000061610000000000000000000000000000000000000000000000000000000000
7070555555606055555555735555555500000000000000000000000000000000000000000070007000000000000000000000000000000000000000606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000045434343440000000000
7070000060607100000063626263000000000000000000000000000000000000000000000061616100000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000006161610000000000000000000061610000000000000000000000000000004552505151530000000000
7070000070717100000000727200000000000000000000000000000000000000000000000070007000000000000000000000000000000000600000000000000000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005050515153530000000000
7070000045434600000000727200000000000000000000000000000000006060000000000070007000000000000060600000000000000060600000000000606000000061616100000000616100006060000000006100000000000000000060600000000000000000000000000000606000000000000000000000000000006060
7070004551535146000000727200000000000000000000000000000000007170000000000061616100000000000071700000000000006060000000000000717000000000000000000000000000007170000000000000000000000000000071700000000000000000000000000000717000000000000000000000000000007170
4041425051515151424041424142414400000000000000000000000000007170000000000070007000000000000071700000000000606000000000000000717000000000000000000000000000007170000000000000000000000000000071700000000000000000000000000000717000000000000000000000000000007170
5351515151525153515251535153515342414244424342434443414342444243424142444243424344434143424442434241424442434243444341434244424342414244424342434443414342444243424142444243424344434143424442434241424442434243444341434244424342414244424342434443414342444243
5051525151515150515150515152515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151
