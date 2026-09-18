return {
  {
    "CRAG666/code_runner.nvim",

    config = function()
      require("code_runner").setup({
        filetype = {
          cpp = {
            "cd $dir &&",
            "g++ -std=c++23 -Wall -Wextra -O2 $fileName -o $fileNameWithoutExt &&",
            "$dir/$fileNameWithoutExt",
          },

          python = {
            "cd $dir &&",
            "uv run $fileName",
          },
        },

        mode = "term",
        focus = true,
        startinsert = true,
      })
    end,

    keys = {
      {
        "<leader>r",
        "<cmd>RunFile<cr>",
        desc = "Run current file",
      },
    },
  },
}