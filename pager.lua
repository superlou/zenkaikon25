local class = require "middleclass"
local offset = require "offset"

local img_page_not_shown = resource.load_image("img_page_not_shown.png")
local img_page_active = resource.load_image("img_page_active.png")
local img_page_shown = resource.load_image("img_page_shown.png")

local Pager = class("Pager")

-- todo Don't freak out if pages is 0 or 1!

function Pager:initialize(w, pages)
    self.w = w
    self.current = 1
    self.pages = pages
    self.img_w, self.img_h = 24, 24
    self.spacing = 100
end

function Pager:draw()
    local pager_w = self.pages * self.img_w + self.spacing * (self.pages - 1)
    -- print(self.pages, self.img_w)
    -- print(pager_w)
    
    for i=1,self.pages do
        local x = (i - 1) * self.img_w + (i - 1) * self.spacing

        local img = img_page_not_shown

        if i < self.current then
            img = img_page_shown
        elseif i == self.current then
            img = img_page_active
        end

        x = x + self.w / 2 - pager_w / 2
        img:draw(x, 0, x + self.img_w, self.img_h)
    end
end

function Pager:advance()
    self.current = self.current + 1
end

return Pager