local TreeSitter = require("refactoring.treesitter.treesitter")
local Version = require("refactoring.version")

local Nodes = require("refactoring.treesitter.nodes")
local FieldNode = Nodes.FieldNode
local StringNode = Nodes.StringNode
local TakeFirstNode = Nodes.TakeFirstNode
local QueryNode = Nodes.QueryNode

local Cpp = {}

function Cpp.new(bufnr, ft)
    return TreeSitter:new({
        version = Version:new(
            TreeSitter.version_flags.Scopes,
            TreeSitter.version_flags.Indents,
            TreeSitter.version_flags.Locals
        ),
        filetype = ft,
        bufnr = bufnr,
        scope_names = {
            translation_unit = "program",
            function_definition = "function",
            class_specifier = "class",
        },
        block_scope = {
            function_definition = true,
            compound_statement = true,
        },
        variable_scope = {
            declaration = true,
        },
        indent_scopes = {
            function_definition = true,
            class_specifier = true,
            if_statement = true,
            for_statement = true,
            while_statement = true,
            do_statement = true,
        },
        debug_paths = {
            class_specifier = FieldNode("name"),
            function_definition = TakeFirstNode(
                QueryNode(
                    "(function_declarator (field_identifier) @tmp_capture)"
                ),
                QueryNode(
                    "(function_declarator (qualified_identifier) @tmp_capture)"
                ),
                QueryNode(
                    "(function_declarator (destructor_name) @tmp_capture)"
                ),
                QueryNode("(function_declarator (identifier) @tmp_capture)"),
                StringNode("function")
            ),

            if_statement = StringNode("if"),
            for_statement = StringNode("for"),
            while_statement = StringNode("while"),
            do_statement = StringNode("do"),
        },
    }, bufnr)
end

return Cpp
