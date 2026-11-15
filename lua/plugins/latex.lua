-- LaTeX / Markdown / Typst live preview
return {
  {
    "frabjous/knap",
    ft = { "tex", "markdown", "plaintex", "typst" },
    init = function()
      vim.g.knap_viewer = "zathura"
      vim.g.knap_settings = {
        -- LaTeX
        texoutputext = "pdf",
        textopdf = "pdflatex -interaction=nonstopmode -halt-on-error -synctex=1 %docroot%",
        -- Typst
        typstoutputext = "pdf",
        typsttopdf = "typst compile %docroot% -o %outputfile%",
      }
    end,
    keys = {
      { "<leader>kc", function() require("knap").process_once() end, desc = "Knap process once" },
      { "<leader>kp", function() require("knap").toggle_autopreviewing() end, desc = "Knap toggle auto-preview" },
      { "<leader>kj", function() require("knap").forward_jump() end, desc = "Knap forward jump" },
      { "<leader>kx", function() require("knap").close_viewer() end, desc = "Knap close viewer" },
    },
  },
}

