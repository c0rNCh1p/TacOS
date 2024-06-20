-- Licensed under GNU General Public License v2
-- * (c) 2014, projektile
-- * (c) 2013, Luca CPZ
-- * (c) 2010, Nicolas Estibals
-- * (c) 2010-2012, Peter Hofmann

local wrequire=require('lain.helpers').wrequire
local setmetatable=setmetatable
local layout={_NAME='lain.layout'}
return setmetatable(layout, {__index=wrequire})