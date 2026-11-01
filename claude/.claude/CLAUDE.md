## Graphify

- When a project has `graphify-out/graph.json`, start codebase questions with `graphify query "<question>"` (`graphify path "<A>" "<B>"` for relationships, `graphify explain "<concept>"` for one concept), and run `graphify update .` after changing code.

## Do only what's asked

- Questions ("why", "what does", "does it affect", "give me a way") get an answer, not code changes. Edit files only when asked to change something.
- When you notice something else worth changing, say it and ask; don't fix it on the side.
- Never commit, push or merge unless asked.

## Code style

- Don't add comments of any kind, even when the surrounding code has them: no explanations, sync notes, docstrings or `ponytail:` markers.
- Keep diffs small and match the surrounding code.
- If a file belongs in a different folder, say so.
- When something could be solved in a more dynamic way, like items being found from their folders or config instead of being listed by hand, or there's another approach worth considering, say so and ask before doing it.

## Checking work

- Check that what you changed builds or parses (compiler, `bash -n`, the tool's own config check). Don't build headless-browser tests: I check the UI myself, so tell me exactly what changed and what to look at.
- Compare against real data when a change could alter output.
- Call out anything that breaks outside the code, like renamed metrics or labels that dashboards use.

## Answers

- Lead with the answer, keep it short, and say what was verified and what wasn't.
