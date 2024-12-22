local font_hdg = resource.load_font "font_Poppins-Regular.ttf"
local font_hdg_bold = resource.load_font "font_Poppins-BlackItalic.ttf"
local font_body = resource.load_font "font_QuattrocentoSans-Regular.ttf"
local font_body_bold = resource.load_font "font_QuattrocentoSans-Bold.ttf"

local COLOR_OTAKON_PRIMARY = "0070ce"
local COLOR_OTAKON_AFFAIR = "8253a2"

local sidebar_style = {
    heading = {
        style = "underline",
        font = font_hdg,
        font_size = 64,
        text_color = COLOR_OTAKON_AFFAIR,
        shadow_color = COLOR_OTAKON_AFFAIR,
        padding = 50,
    },
    text = {
        font = font_body,
        font_bold = font_body_bold,
        color = "ffffff",
    },
    margin = {70, 50, 70, 50},
    heading_y = 80,
    message_y = 160,
    session_list = {
        item_bg_img = resource.create_colored_texture(0, 0, 0, 1.0),
        compact = true
    },
    session_brief = {
        item_bg_img = resource.create_colored_texture(0, 0, 0, 1.0)
    }
}

local main_style = {
    heading = {
        style = "box",
        font = font_hdg,
        text_color = "d6edff",
        font_size = 64,
        padding = 50,
        bg_color = COLOR_OTAKON_PRIMARY,
        shadow_color = "00294b",
    },
    text = {
        font = font_body,
        font_bold = font_body_bold,
        color = "ffffff",
    },
    player_bg_mask = nil,
    margin = {70, 50, 70, 50},
    heading_y = 80,
    message_y = 160,
    session_list = {
        item_bg_img = resource.load_image("img_event_row_bg.png"),
        compact = false
    },
    session_brief = {
        item_bg_img = nil
    }
}

local inset_style = {
    heading = {
        style = "underline",
        font = font_hdg,
        font_size = 64,
        text_color = COLOR_OTAKON_AFFAIR,
        shadow_color = COLOR_OTAKON_AFFAIR,
        padding = 50,
    },
    text = {
        font = font_body,
        font_bold = font_body_bold,
        color = "ffffff",
    },
    margin = {70, 50, 70, 50},
    heading_y = 80,
    message_y = 160,
    session_list = {
        item_bg_img = resource.create_colored_texture(0, 0, 0, 1.0),
        compact = true
    },
    session_brief = {
        item_bg_img = resource.create_colored_texture(0, 0, 0, 1.0)
    }
}

return {
    sidebar_style = sidebar_style,
    main_style = main_style,
    inset_style = inset_style,
}
