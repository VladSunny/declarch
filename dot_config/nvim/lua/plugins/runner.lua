return {
  "CRAG666/code_runner.nvim",
  config = function()
    require("code_runner").setup({
      filetype = {
        -- Настройка компиляции для C++ с олимпиадными флагами
        cpp = {
          "cd $dir &&",
          "g++ -O2 -Wall -std=c++20 $fileName -o $fileBase &&",
          "$dir/$fileBase",
        },
      },
    })

    -- Назначаем удобную горячую клавишу (например, <leader>r — Space + r)
    vim.keymap.set("n", "<leader>r", ":RunCode<CR>", { desc = "Run C++ Code", silent = true })
  end,
}
