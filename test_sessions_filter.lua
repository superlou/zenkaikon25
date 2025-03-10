require "sessions_filter"

local test_sessions = {
    {
        is_after_finish = false,
        locations = { "Panel 2 (WEWCC 146B)" },
        start_ampm = "am", start_hhmm = "10:15",
        is_open = false,
        tracks = { "Panel" },
        finish_hhmm = "11:15", finish_ampm = "am",
        name = "Literature and Likeness in Bungo Stray Dogs",
        completed_fraction = 0,
        is_before_start = true,
    },
    {
        is_after_finish = false,
        locations = { "Panel 4 (WEWCC 150)" },
        start_ampm = "am", start_hhmm = "10:15",
        is_open = false,
        tracks = { "Panel" },
        finish_hhmm = "11:15", finish_ampm = "am",
        name = "Not Your Average Family: Best Non-Parent Parental Figures in Anime",
        completed_fraction = 0,
        is_before_start = true,
    },
    {
        is_after_finish = false,
        locations = { "Panel 6 (WEWCC 151B)" },
        start_ampm = "am", start_hhmm = "10:15",
        is_open = false,
        tracks = { "Panel" },
        finish_hhmm = "11:15", finish_ampm = "am",
        name = "Doll Shopping in Japan",
        completed_fraction = 0,
        is_before_start = true,
    },
    {
        is_after_finish = false,
        locations = { "Panel 1 (WEWCC 207)" },
        start_ampm = "am", start_hhmm = "10:15",
        is_open = false,
        tracks = { "Guest", "Panel" },
        finish_hhmm = "11:15", finish_ampm = "am",
        name = "Q&A with TRIGGER's President and Animators [G]",
        completed_fraction = 0,
        is_before_start = true,
    },
    {
        is_after_finish = false,
        locations = { "Panel 7 (WEWCC 152)" },
        start_ampm = "am", start_hhmm = "10:15",
        is_open = false,
        tracks = { "Guest", "Panel" },
        finish_hhmm = "11:15", finish_ampm = "am",
        name = "Shinji Aramaki on Bubblegum, Bikes, and Bungie [G]",
        completed_fraction = 0,
        is_before_start = true,
    },
    {
        is_after_finish = false,
        locations = { "Panel 5 (WEWCC 151A)" },
        start_ampm = "am", start_hhmm = "10:15",
        is_open = false,
        tracks = { "Panel" },
        finish_hhmm = "11:15", finish_ampm = "am",
        name = "Otome Games: We Love Our Cartoon Boyfriends",
        completed_fraction = 0,
        is_before_start = true,
    },
}

function test_sessions_filter_location()
    local sessions = {
        {locations={"room a"}, tracks={"video"}},
        {locations={"room b"}, tracks={"live"}},
        {locations={"room c"}, tracks={"live"}},
        {locations={"room c"}, tracks={"live"}},
        {locations={"room d", "room e"}, tracks={"live"}},
    }

    local result = sessions_filter(shallow_copy(sessions), "room a", nil)
    assert_equal(#result, 1)
    local result = sessions_filter(shallow_copy(sessions), "room b", nil)
    assert_equal(#result, 1)
    local result = sessions_filter(shallow_copy(sessions), "room c", nil)
    assert_equal(#result, 2)
    local result = sessions_filter(shallow_copy(sessions), "room b, room c", nil)
    assert_equal(#result, 3)
    local result = sessions_filter(shallow_copy(sessions), "room b, room c, room x", nil)
    assert_equal(#result, 3)
    local result = sessions_filter(shallow_copy(sessions), "room a,room b,room c,room x", nil)
    assert_equal(#result, 4)

    local result1 = sessions_filter(shallow_copy(sessions), "room d", nil)
    local result2 = sessions_filter(shallow_copy(sessions), "room e", nil)
    assert_equal_table(result1, result2)
end

function test_sessions_filter_track()
    local sessions = {
        {locations={"room a"}, tracks={"video"}},
        {locations={"room b"}, tracks={"live"}},
        {locations={"room c"}, tracks={"live"}},
        {locations={"room c"}, tracks={"live"}},
        {locations={"room d", "room e"}, tracks={"live", "video"}},
    }

    local result = sessions_filter(shallow_copy(sessions), nil, "video")
    assert_equal(#result, 2)
    local result = sessions_filter(shallow_copy(sessions), nil, "live")
    assert_equal(#result, 4)
    local result = sessions_filter(shallow_copy(sessions), nil, "live, video")
    assert_equal(#result, 5)
    local result = sessions_filter(shallow_copy(sessions), nil, "video, live")
    assert_equal(#result, 5)
end

function test_sessions_include_id()
    local sessions = {
        {id=1, locations={"room a"}, tracks={"video"}},
        {id=2, locations={"room b"}, tracks={"live"}},
        {id=3, locations={"room b"}, tracks={"live"}},
        {id=4, locations={"room c"}, tracks={"live"}},
        {id=5, locations={"room d", "room e"}, tracks={"live", "video"}},
    }

    local result = sessions_filter(
        shallow_copy(sessions),
        nil, "video", nil,
        nil, nil, nil,
        "3, 4"
    )
    assert_equal(#result, 4)

    local result = sessions_filter(
        shallow_copy(sessions),
        "room a", nil, nil,
        nil, nil, nil,
        "3, 4"
    )
    assert_equal(#result, 3)

    local result = sessions_filter(
        shallow_copy(sessions),
        nil, nil, "2, 3",
        nil, nil, nil,
        "5"
    )
    assert_equal(#result, 3)

    local result = sessions_filter(
        shallow_copy(sessions),
        nil, nil, nil,
        "video", nil, nil,
        "5"
    )
    assert_equal(#result, 4)

    local result = sessions_filter(
        shallow_copy(sessions),
        nil, nil, nil,
        nil, "1,2,3", nil,
        "3"
    )
    assert_equal(#result, 3)
end

function test_sessions_filter_multiple()
    local sessions = {
        {locations={"room a"}, tracks={"video"}},
        {locations={"room b"}, tracks={"live"}},
        {locations={"room c"}, tracks={"live"}},
        {locations={"room c"}, tracks={"live"}},
        {locations={"room d", "room e"}, tracks={"live", "video"}},
    }

    local result = sessions_filter(shallow_copy(sessions), "room a,room b", "video")
    assert_equal(#result, 1)
    local result = sessions_filter(shallow_copy(sessions), "room d", "live")
    assert_equal(#result, 1)
    local result = sessions_filter(shallow_copy(sessions), "room a, room b, room c, room d", "live")
    assert_equal(#result, 4)
    local result = sessions_filter(shallow_copy(sessions), "room a, room b, room c, room d", "live, video")
    assert_equal(#result, 5)
end

function test_sessions_filter_real_data()
    local sessions = shallow_copy(test_sessions)
    local result = sessions_filter(sessions, " Panel 7 (WEWCC 152)", nil)
    assert_equal(#result, 1)
end