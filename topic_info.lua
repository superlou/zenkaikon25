require "color_util"
local class = require "middleclass"
local Topic = require "topic"
require "text_util"
local tw = require "tween"
local Heading = require "heading"
local offset = require "offset"

local InfoTopic = class("InfoTopic", Topic)

function InfoTopic:initialize(player, w, h, style, duration, heading, text, media)
    Topic.initialize(self, player, w, h, style, duration)
    self.text = text
    self.text_color = {hex2rgb(self.style.text.color)}
    self.font_size = 40

    self:use_background_media(media, style.player_bg_mask)

    self.style = style
    self.margin = self.style.margin
    self.content_w = self.w - self.margin[2] - self.margin[4]
    self.lines = wrap_text(self.text, self.style.text.font, self.font_size, self.content_w)
    self.bg_alpha = 0
    self.text_alpha = 0
    self.y_offset = 0

    self.heading = Heading(heading, style.heading)

    tw:tween(self, "bg_alpha", 0, 1, 0.5)
    tw:tween(self, "text_alpha", 0, 1, 0.5)
    tw:tween(self, "y_offset", 20, 0, 0.5)

    tw:timer(self.duration):on_done(function()
        self.heading:start_exit()
        tw:tween(self, "text_alpha", 1, 0, 0.5)
    end):then_after(0.5, function()
        if not self:next_topic_has_bg() then tw:tween(self, "bg_alpha", 1, 0, 0.5) end
        self:set_exiting()
    end):then_after(0.5, function()
        self:set_done()
    end)
end

function InfoTopic:draw()
    local r, g, b = unpack(self.text_color)
    self:draw_background_media(self.bg_alpha)

    offset(self.w / 2, self.style.heading_y, function()
        self.heading:draw()
    end)

    for i, line in ipairs(self.lines) do
        self.style.text.font:write(
            self.margin[4], i * self.font_size * 1.5 - self.y_offset + self.style.message_y,
            line, self.font_size,
            r, g, b, self.text_alpha
        )
    end
end

return InfoTopic