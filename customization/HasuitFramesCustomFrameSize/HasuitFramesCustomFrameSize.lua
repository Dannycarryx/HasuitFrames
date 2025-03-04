


-- The point is to overwrite/change things from the main addon. You can control width/height/columns for every group size here.

-- Things in between --[[ and --]] are commented out. To uncomment/enable something you could just put a space in between -- and [[





--[[
hasuitManaBarHeight = 4
--]]



--[[
hasuitRaidFrameWidthForGroupSize = { --Might get ugly pixels unless even
    [0]=114,
    114,--1
    114,--2
    114,--3 --arena lines always get this width
    114,--4
    114,--5
    
    110,--6
    110,--7
    110,--8
    
    100,--9
    100,--10
    100,--11
    100,--12
    100,--13
    100,--14
    100,--15
    
    98,--16
    98,--17
    98,--18
    98,--19
    98,--20
    
    94,--21
    94,--22
    94,--23
    94,--24
    
    90,--25
    90,--26
    90,--27
    90,--28
    
    86,--29
    86,--30
    86,--31
    86,--32
    
    82,--33
    82,--34
    82,--35
    82,--36
    
    78,--37
    78,--38
    78,--39
    78,--40
}
--]]


--[[
hasuitRaidFrameHeightForGroupSize = {
    [0]=90,--0
    90,--1
    90,--2
    90,--3
    90,--4
    90,--5
    90,--6
    90,--7
    90,--8
    
    83,--9
    83,--10
    
    63,--11
    63,--12
    63,--13
    63,--14
    63,--15
    
    49,--16
    49,--17
    49,--18
    49,--19
    49,--20
    49,--21
    49,--22
    49,--23
    49,--24
    49,--25
    49,--26
    49,--27
    49,--28
    49,--29
    49,--30
    49,--31
    49,--32
    49,--33
    49,--34
    49,--35
    49,--36
    49,--37
    49,--38
    49,--39
    49,--40
}
--]]




--[[
hasuitRaidFrameColumnsForGroupSize = {
    [0]=1,--0
    1,--1
    1,--2
    1,--3
    1,--4
    1,--5, columns up to here do nothing atm
    
    4,--6
    4,--7
    4,--8
    
    5,--9
    5,--10
    5,--11
    5,--12
    5,--13
    5,--14
    5,--15
    5,--16
    5,--17
    5,--18
    5,--19
    5,--20
    
    6,--21
    6,--22
    6,--23
    6,--24
    
    7,--25
    7,--26
    7,--27
    7,--28
    
    8,--29
    8,--30
    8,--31
    8,--32
    
    9,--33
    9,--34
    9,--35
    9,--36
    
    10,--37
    10,--38
    10,--39
    10,--40
}
--]]




--advanced: you could also change groupUnitFrames.setSizesAndSetPoints and/or arenaUnitFrames.setSizesAndSetPoints for full control. This is untested
