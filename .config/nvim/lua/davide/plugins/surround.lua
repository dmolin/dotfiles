return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  config = true,

  -- ys plus motion to specify what to surround
  -- to remove the surround text, use "ds" + what we want to remove
  -- to change the surround text, use "cs" + existing char + new surround character
}
