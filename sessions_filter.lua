function split_csv(text)
    return map_iter(string_split(text, ","), string_strip)
end

function split_csv_numeric(text)
    return map_table(map_iter(string_split(text, ","), string_strip), tonumber)
end

function extract_session_filters_from_config(text)
    local filters = {}
    
    filters.filter_locations = text:match("filter%-location:([^\n]+)")
    if filters.filter_locations then
        filters.filter_locations = split_csv(filters.filter_locations)
    end

    filters.filter_tracks = text:match("filter%-track:([^\n]+)")
    if filters.filter_tracks then
        filters.filter_tracks = split_csv(filters.filter_tracks)
    end

    filters.filter_ids = text:match("filter%-id:([^\n]+)")
    if filters.filter_ids then
        filters.filter_ids = split_csv_numeric(filters.filter_ids)
    end

    filters.exclude_tracks = text:match("exclude%-track:([^\n]+)")
    if filters.exclude_tracks then
        filters.exclude_tracks = split_csv(filters.exclude_tracks)
    end

    filters.exclude_ids = text:match("exclude%-id:([^\n]+)")
    if filters.exclude_ids then
        filters.exclude_ids = split_csv_numeric(filters.exclude_ids)
    end

    filters.exclude_closed = text:match("exclude%-closed:[ ]*true")
    if filters.exclude_closed then
        filters.exclude_closed = true
    else
        filters.exclude_closed = false
    end

    filters.include_ids = text:match("include%-id:([^\n]+)")
    if filters.include_ids then
        filters.include_ids = split_csv_numeric(filters.include_ids)
    end

    return filters
end


function id_is_in_ids_str(id, ids_str)
    for check_id in string_split(ids_str, ",") do
        if id == tonumber(check_id) then return true end
    end

    return false
end

function has_intersection(array1, array2)
    for _, v1 in ipairs(array1) do
        for _, v2 in ipairs(array2) do
            if v1 == v2 then return true end
        end
    end

    return false
end

function sessions_filter(sessions, filter)
    local filter_locations = filter.filter_locations
    local filter_tracks = filter.filter_tracks
    local filter_ids = filter.filter_ids
    local exclude_tracks = filter.exclude_tracks
    local exclude_ids = filter.exclude_ids
    local exclude_closed = filter.exclude_closed
    local include_ids = filter.include_ids

    if filter_locations then
        filter_inplace(sessions, function(session)
            return has_intersection(session.locations, filter_locations) or
                   (include_ids and array_contains(include_ids, session.id))
        end)
    end

    if filter_tracks then
        filter_inplace(sessions, function(session)
            return has_intersection(session.tracks, filter_tracks) or
                   (include_ids and array_contains(include_ids, session.id))
        end)
    end

    if filter_ids then
        filter_inplace(sessions, function(session)
            return array_contains(filter_ids, session.id) or
                   (include_ids and array_contains(include_ids, session.id))
        end)
    end

    if exclude_tracks then
        filter_inplace(sessions, function(session)
            return not has_intersection(session.tracks, exclude_tracks) or
                   (include_ids and array_contains(include_ids, session.id))
        end)
    end

    if exclude_ids then
        filter_inplace(sessions, function(session)
            return not array_contains(exclude_ids, session.id) or
                   (include_ids and array_contains(include_ids, session.id))
        end)
    end

    if exclude_closed then
        filter_inplace(sessions, function(session)
            -- This exclude does NOT consider include_ids
            return not session.is_after_finish
        end)
    end

    return sessions
end

-- Filter a table of sessions in place
-- function sessions_filter(sessions, location_str, track_str, filter_id_str,
--                          exclude_track_str, exclude_id_str, exclude_closed,
--                          include_id)
--     if location_str then
--         filter_inplace(sessions, function(session)
--             for location in string_split(location_str, ",") do
--                 if array_contains(session.locations, string_strip(location)) then
--                     return true
--                 end 
--             end

--             if include_id and id_is_in_ids_str(session.id, include_id) then
--                 return true
--             end

--             return false
--         end)
--     end

--     if track_str then
--         filter_inplace(sessions, function(session)
--             for track in string_split(track_str, ",") do
--                 if array_contains(session.tracks, string_strip(track)) then
--                     return true
--                 end
--             end

--             if include_id and id_is_in_ids_str(session.id, include_id) then
--                 return true
--             end

--             return false
--         end)
--     end

--     if filter_id_str then
--         filter_inplace(sessions, function(session)
--             for id in string_split(filter_id_str, ",") do
--                 if session.id == tonumber(id) then return true end
--             end

--             if include_id and id_is_in_ids_str(session.id, include_id) then
--                 return true
--             end

--             return false
--         end)
--     end

--     if exclude_track_str then
--         filter_inplace(sessions, function(session)
--             if include_id and id_is_in_ids_str(session.id, include_id) then
--                 return true
--             end

--             for track in string_split(exclude_track_str, ",") do
--                 if array_contains(session.tracks, string_strip(track)) then
--                     return false
--                 end
--             end

--             return true
--         end)
--     end

--     if exclude_id_str then
--         filter_inplace(sessions, function(session)
--             if include_id and id_is_in_ids_str(session.id, include_id) then
--                 return true
--             end
        
--             for id in string_split(exclude_id_str, ",") do
--                 if session.id == tonumber(id) then return false end
--             end

--             return true
--         end)
--     end

--     if exclude_closed == "true" then
--         filter_inplace(sessions, function(session)
--             return not session.is_after_finish
--         end)
--     end

--     return sessions
-- end
