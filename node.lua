gl.setup(1920, 1080)
-- require("test_runner")()
local Heading = require "heading"
require "color_util"
require "draw_util"
require "json_util"
require "glass"
local Ticker = require "ticker"
local Clock = require "clock"
local offset = require "offset"
local json = require "json"
local TopicPlayer = require "topic_player"
local tw = require "tween"
local ServiceIndicator = require "service_indicator"

local sidebar_bg = resource.load_image "img_sidebar_bg.png"
local main_bg = resource.load_image "img_main_bg2.png"
local inset_bg = resource.load_image "img_inset_bg.png"
local ticker_left_crop = resource.load_image "img_ticker_left_crop_qr.png"
local ticker_right_crop = resource.load_image "img_ticker_right_crop.png"
local ticker_right_triangle = resource.load_image "img_ticker_right_triangle.png"

local ticker_height = 116
local ticker = Ticker:new(0, HEIGHT - ticker_height, WIDTH, ticker_height)
local clock = Clock:new(200, 96)
local service_indicator = ServiceIndicator()

local style = require "style"
local topic_sidebar = TopicPlayer(640, 964, style["sidebar_style"])
local topic_main = TopicPlayer(1280, 964, style["main_style"])
local topic_inset = TopicPlayer(600, 200, style["inset_style"])

util.data_mapper {
    ["clock/update"] = function(data)
        data = json.decode(data)
        clock:update(data.hh_mm, data.am_pm, data.month, data.date)
    end;
    ["guidebook/update"] = function(data)
        data = json.decode(data)
        service_indicator:update(data.updating, data.checks, data.desc)
    end;
}

json_watch("config.json", function(config)
    ticker:set_speed(config.ticker_speed)
    ticker:set_msgs_from_config(config)
    topic_sidebar:set_topics_from_config(config["sidebar_topic_player"])
    topic_main:set_topics_from_config(config["main_topic_player"])
    topic_inset:set_topics_from_config(config["inset_topic_player"])
end)

local t = 0

function node.render()
    t = t + 1 / 60
    tw:update(1 / 60)

    gl.clear(1, 1, 1, 1)

    sidebar_bg:draw(0, 0, 640, 946)

    offset(0, 0, function()
        topic_sidebar:draw()
    end)

    main_bg:draw(640, 0, 1920, 964)

    offset(640, 0, function()
        topic_main:draw()
    end)

    offset(10, 735, function() 
        inset_bg:draw(0, 0, 620, 224)
    end)

    offset(20, 745, function()
        topic_inset:draw()
    end)

    ticker:draw()

    ticker_left_crop:draw(-12, 932, -12 + 235, 932 + 160)
    -- ticker_right_crop:draw(1644, 964, 1644 + 276, 964 + 116)
    draw_image_xywh(ticker_right_crop, 1692, 964, 228, 116)

    -- gl.pushMatrix()
    -- gl.translate(1723 + 89/2, 970 + 87/2)
    -- gl.rotate(18 * math.sin(2 * 3.141 * 0.1 * t), 0, 0, 1)
    -- ticker_right_triangle:draw(-89/2, -89/2, 89/2, 87/2)
    -- gl.popMatrix()

    offset(1710, 972, function()
        clock:draw()
    end)

    offset(10, 978, function()
        service_indicator:draw()
    end)
end
