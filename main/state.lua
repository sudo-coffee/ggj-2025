local state = {}

-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Props | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

state.deaths = nil
state.audioFiles = {
  "audio/01.flac",
  "audio/02.flac",
  "audio/03.flac",
  "audio/04.flac",
  "audio/05.flac",
  "audio/06.flac",
  "audio/07.flac",
  "audio/08.flac",
  "audio/09.flac",
  "audio/10.flac",
  "audio/11.flac",
  "audio/12.flac",
  "audio/13.flac",
  "audio/14.flac",
  "audio/15.flac",
}

-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Methods | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function state.reset()
  state.deaths = 0
end

return state
