# Projection Management with Make

This Makefile provides commands to manage projections of specific subsystem 
in big projects. For example in rails you might have 25 files spread across 
the whole app related to microsoft integration. 

This approach allows you to collect symlinks to relevant files in a folder (we call it **projection**).

You can open this projection in separate editor, modify any files

The tool also let's you clean up projections, list files associated with specific projection. 
And of course you can have as many projections as you want.




## Commands:

1. Create a Projection

   `make projection <keyword>`

   This command will:
   - Create a directory for the keyword in ../projections/<keyword>/
   - Find all files in the project related to the integration
   - Create symlinks to these files in the projection directory

2. Clean a Projection

   `make clean-projection <keyword>`

   This command will:
   - Remove all symlinks in the projection directory
   - Leave any regular files untouched
   - Provide a warning if regular files are present

3. Force Clean a Projection

   `make clean-projection! <keyword>`

   This command will:
   - Ask for confirmation before proceeding
   - Remove the entire projection directory and all its contents
   - Use with caution as this action is irreversible

4. List Files for a Projection

   `make list-files <keyword>`

   This command will display a list of all files in the project that are
   related to the specified keyword.

## Notes:

- The projections are created in the ../projections/ directory relative to the
  Makefile location.
- Files in node_modules, .git, tmp, and log directories are excluded from
  projections.
- The commands are case-insensitive for the keyword.

## Examples:

Create a projection for invoice:
`make projection invoice`

Clean up Slack projection:
`make clean-projection slack`

Force clean Snipe-IT projection:
`make clean-projection! snipe-it`

List files related to Google Workspace:
`make list-files google-workspace`

Remember to use these commands responsibly, especially the clean-projection!
command which can delete files permanently.
