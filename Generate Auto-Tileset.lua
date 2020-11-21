----------------------------------------------------------------------
-- Ready META_SPRITE
----------------------------------------------------------------------
local META_SPRITE = app.activeSprite
local META_SPRITE_W = META_SPRITE.width
local META_SPRITE_H = META_SPRITE.height


----------------------------------------------------------------------
-- Check if the META_SPRITE meets the specifications
----------------------------------------------------------------------
assert(META_SPRITE_W % 4 == 0, "The width of the sprite should be an integer multiple of 4")
assert(META_SPRITE_H % 6 == 0, "The height of the sprite should be an integer multiple of 6")


----------------------------------------------------------------------
-- Compute size of tile and tile's part
----------------------------------------------------------------------
local TILE_W = META_SPRITE_W / 2
local TILE_H = META_SPRITE_H / 3
local PART_W = TILE_W / 2
local PART_H = TILE_H / 2


----------------------------------------------------------------------
-- Get user settings
----------------------------------------------------------------------
local COLS = 8
local ROWS = 6


----------------------------------------------------------------------
-- Create AUTO_SPRITE
----------------------------------------------------------------------
local AUTO_SPRITE = Sprite(META_SPRITE)
local AUTO_SPRITE_W = TILE_W * COLS
local AUTO_SPRITE_H = TILE_H * ROWS


----------------------------------------------------------------------
-- 1) The function to gather image of cel
-- 2) The image is not added repeatedly
----------------------------------------------------------------------
local function gatherImage(images, cel)
   for _, image in ipairs(images) do
      if image == cel.image then
         return
      end
   end
   table.insert(images, cel.image)
end


----------------------------------------------------------------------
-- 1) The function to gather all images of sprite
-- 2) The images are not added repeatedly
----------------------------------------------------------------------
local function gatherImages(sprite)
   local images = {}
   for _, cel in ipairs(sprite.cels) do
      gatherImage(images, cel)
   end
   return images
end


----------------------------------------------------------------------
-- 1) Get the images of META_SPRITE
-- 2) Get the images of AUTO_SPRITE
----------------------------------------------------------------------
local META_IMAGES = gatherImages(META_SPRITE)
local AUTO_IMAGES = gatherImages(AUTO_SPRITE)


----------------------------------------------------------------------
-- Clear AUTO_IMAGES
----------------------------------------------------------------------
for _, image in ipairs(AUTO_IMAGES) do
   image:clear(Color(0))
end


----------------------------------------------------------------------
-- 1) Resize AUTO_SPRITE
-- ?) It seems the AUTO_IMAGES will be replaced, so regather images
----------------------------------------------------------------------
AUTO_SPRITE:resize(AUTO_SPRITE_W, AUTO_SPRITE_H)
AUTO_IMAGES = gatherImages(AUTO_SPRITE)


----------------------------------------------------------------------
-- Resize AUTO_IMAGES to match AUTO_SPRITE
----------------------------------------------------------------------
for _, image in ipairs(AUTO_IMAGES) do
   image.cel.position = Point(0, 0)
   image:resize(AUTO_SPRITE_W, AUTO_SPRITE_H)
end


----------------------------------------------------------------------
-- 1) The META_SPRITE contains 24 parts
-- 2) The 4 parts in the upper-left corner are useless
-- 3) The item of META_PART_OFFSETS is a pixel-coordinate (x, y)
----------------------------------------------------------------------
local META_PART_OFFSETS = {}
--[[xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx]] META_PART_OFFSETS['O1'] = {PART_W*2, PART_H*0}  META_PART_OFFSETS['O2'] = {PART_W*3, PART_H*0}
--[[xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx]] META_PART_OFFSETS['O3'] = {PART_W*2, PART_H*1}  META_PART_OFFSETS['O4'] = {PART_W*3, PART_H*1}
META_PART_OFFSETS['I1'] = {PART_W*0, PART_H*2}  META_PART_OFFSETS['H1'] = {PART_W*1, PART_H*2}  META_PART_OFFSETS['H2'] = {PART_W*2, PART_H*2}  META_PART_OFFSETS['I2'] = {PART_W*3, PART_H*2}
META_PART_OFFSETS['V1'] = {PART_W*0, PART_H*3}  META_PART_OFFSETS['F1'] = {PART_W*1, PART_H*3}  META_PART_OFFSETS['F2'] = {PART_W*2, PART_H*3}  META_PART_OFFSETS['V2'] = {PART_W*3, PART_H*3}
META_PART_OFFSETS['V3'] = {PART_W*0, PART_H*4}  META_PART_OFFSETS['F3'] = {PART_W*1, PART_H*4}  META_PART_OFFSETS['F4'] = {PART_W*2, PART_H*4}  META_PART_OFFSETS['V4'] = {PART_W*3, PART_H*4}
META_PART_OFFSETS['I3'] = {PART_W*0, PART_H*5}  META_PART_OFFSETS['H3'] = {PART_W*1, PART_H*5}  META_PART_OFFSETS['H4'] = {PART_W*2, PART_H*5}  META_PART_OFFSETS['I4'] = {PART_W*3, PART_H*5}


----------------------------------------------------------------------
-- 1) Each tile contains 4 parts
-- 2) The item of AUTO_PART_OFFSETS is a pixel-coordinate (x, y)
----------------------------------------------------------------------
local AUTO_PART_OFFSETS = {
   {PART_W*0, PART_H*0}, {PART_W*1, PART_H*0},
   {PART_W*0, PART_H*1}, {PART_W*1, PART_H*1}
}


----------------------------------------------------------------------
-- 1) The AUTO_SPRITE contains 48 parts
-- 2) The first one is the same as the second one
-- 3) The item of TILES indicate which parts of the tile are composed
----------------------------------------------------------------------
local TILES = {}
TILES[1]  = {'I1','I2','I3','I4'}  TILES[2]  = {'I1','I2','I3','I4'}  TILES[3]  = {'H2','I2','H4','I4'}  TILES[4]  = {'V3','V4','I3','I4'}
TILES[5]  = {'I1','H1','I3','H3'}  TILES[6]  = {'I1','I2','V1','V2'}  TILES[7]  = {'V3','O2','I3','H3'}  TILES[8]  = {'V3','F3','I3','H3'}
TILES[9]  = {'O1','V4','H4','I4'}  TILES[10] = {'F4','V4','H4','I4'}  TILES[11] = {'H2','I2','O3','V2'}  TILES[12] = {'H2','I2','F2','V2'}
TILES[13] = {'I1','H1','V1','O4'}  TILES[14] = {'I1','H1','V1','F1'}  TILES[15] = {'H2','H1','H4','H3'}  TILES[16] = {'V3','V4','V1','V2'}
TILES[17] = {'O1','O2','H4','H3'}  TILES[18] = {'F4','O2','H4','H3'}  TILES[19] = {'O1','F3','H4','H3'}  TILES[20] = {'F4','F3','H4','H3'}
TILES[21] = {'O1','V4','O3','V2'}  TILES[22] = {'O1','V4','F2','V2'}  TILES[23] = {'F4','V4','O3','V2'}  TILES[24] = {'F4','V4','F2','V2'}
TILES[25] = {'H2','H1','O3','O4'}  TILES[26] = {'H2','H1','O3','F1'}  TILES[27] = {'H2','H1','F2','O4'}  TILES[28] = {'H2','H1','F2','F1'}
TILES[29] = {'V3','O2','V1','O4'}  TILES[30] = {'V3','F3','V1','O4'}  TILES[31] = {'V3','O2','V1','F1'}  TILES[32] = {'V3','F3','V1','F1'}
TILES[33] = {'O1','O2','O3','O4'}  TILES[34] = {'F1','O2','O3','O4'}  TILES[35] = {'O1','F2','O3','O4'}  TILES[36] = {'F1','F2','O3','O4'}
TILES[37] = {'O1','O2','O3','F4'}  TILES[38] = {'F1','O2','O3','F4'}  TILES[39] = {'O1','F2','O3','F4'}  TILES[40] = {'F1','F2','O3','F4'}
TILES[41] = {'O1','O2','F3','O4'}  TILES[42] = {'F1','O2','F3','O4'}  TILES[43] = {'O1','F2','F3','O4'}  TILES[44] = {'F1','F2','F3','O4'}
TILES[45] = {'O1','O2','F3','F4'}  TILES[46] = {'F1','O2','F3','F4'}  TILES[47] = {'O1','F2','F3','F4'}  TILES[48] = {'F1','F2','F3','F4'}


----------------------------------------------------------------------
-- 1) Draw AUTO_IMAGES, one meta-image to one auto-image
-- 2) Performance key
----------------------------------------------------------------------
local layer = 0
local frame = 0
local autoImage = nil
local autoTileX = 0
local autoTileY = 0
local autoPartX = 0
local autoPartY = 0
local metaPartX = 0
local metaPartY = 0
local metaPartRect = Rectangle(0, 0, PART_W, PART_H)

for _, metaImage in ipairs(META_IMAGES) do
   layer = metaImage.cel.layer.stackIndex
   frame = metaImage.cel.frame.frameNumber
   autoImage = AUTO_SPRITE.layers[layer]:cel(frame).image
   for index, metaParts in ipairs(TILES) do
      index = index - 1
      autoTileX = index % 8 * TILE_W
      autoTileY = index // 8 * TILE_H
      for no, autoPartOffset in ipairs(AUTO_PART_OFFSETS) do
         metaPartX = META_PART_OFFSETS[metaParts[no]][1]
         metaPartY = META_PART_OFFSETS[metaParts[no]][2]
         metaPartRect.x = metaPartX - metaImage.cel.bounds.x
         metaPartRect.y = metaPartY - metaImage.cel.bounds.y
         autoPartX = autoTileX + autoPartOffset[1] - metaPartRect.x
         autoPartY = autoTileY + autoPartOffset[2] - metaPartRect.y
         for it in metaImage:pixels(metaPartRect) do
            autoImage:drawPixel(autoPartX+it.x, autoPartY+it.y, it())
         end
      end
   end
end