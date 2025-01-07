-- shows the last commit message when hovering a line
return {
  "f-person/git-blame.nvim",
  opts = {
    -- git-blame  does not let you change the color of the message, but you can
    -- changer its group, Float is not significant, other than the colour is a
    -- nice oranger in tokyo_night :)
    highlight_group = "Float",
  },
}
