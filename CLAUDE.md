# Up-to-date-information
When choosing packages, libraries, etc. make sure to check online to ensure:
- packages are actively maintained
- they represent the current best practice for the problem being solved

# Safety
- Do not install packages at a system-level scope, you can ask the user to authorise this, but do NOT do this automatically
- When changing the architecture of a project/system, present the reasoning and tradeoffs to the user and ask for them to confirm a desired direction, don't just decide to blow everything up

# Style
- Make sure files have a newline at the end (but not multiple)
- Only add comments where the logic is not self-evident, and keep them to 1 or 2 lines at most
  - Don't describe the business logic reason for a change, that goes in commits/PRs
