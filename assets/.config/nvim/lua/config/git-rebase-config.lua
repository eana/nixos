-- Define custom mappings for gitrebase filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitrebase",
  callback = function()
    local map = vim.api.nvim_buf_set_keymap
    local opts = { noremap = true, silent = true }
    local actions = {
      r = "reword",
      e = "edit",
      s = "squash",
      f = "fixup",
      b = "break",
      d = "drop",
      p = "pick",
    }
    for key, action in pairs(actions) do
      map(0, "n", key, ":s/^\\v(reword|edit|squash|fixup|break|drop|pick)/" .. action .. "/<CR>:nohlsearch<CR>", opts)
    end
  end,
})

-- Function to add comments after the commit list
local function append_rebase_help_after_commits()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local insert_line = #lines -- Default to end of file
  for i, line in ipairs(lines) do
    if line == "" then -- Find first blank line
      insert_line = i
      break
    end
  end

  -- Add shortcuts if not already present
  if not vim.tbl_contains(lines, "# Shortcuts:") then
    vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, {
      "#",
      "# Shortcuts:",
      "#   r  -> reword (change the commit message)",
      "#   e  -> edit   (stop to edit the commit)",
      "#   s  -> squash (combine this commit with the previous one and edit the message)",
      "#   f  -> fixup  (combine this commit with the previous one without editing message)",
      "#   b  -> break  (stop here and allow manual modifications)",
      "#   d  -> drop   (remove the commit entirely)",
      "#   p  -> pick   (keep the commit as is)",
      "#",
    })
  end
end

-- Attach the function to gitrebase filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitrebase",
  callback = append_rebase_help_after_commits,
})
