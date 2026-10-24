# SQL Best Practices

## Writing queries
- Name the columns you need instead of using `SELECT *`.
- Use short, meaningful table aliases (`c`, `o`, `od`, `p`).
- Give calculated columns readable names with `AS`.
- Put each clause on its own line and indent consistently.
- Add a comment above each query describing its purpose.
- Avoid semicolons inside comments, because some tools split statements at them.

## Grouping and filtering
- Every selected column that is not aggregated must appear in GROUP BY.
- WHERE filters rows before grouping. HAVING filters groups after aggregation.
- Use UNION ALL when duplicates are impossible or wanted, because it avoids the extra de-duplication work. Use UNION when duplicates must be removed.
- Remember that COUNT(column) skips NULLs while COUNT(*) does not.

## Data safety
- Always include WHERE with UPDATE and DELETE, and test it with a SELECT first.
- Keep schema changes in a separate script and run it only once.
- Test each query and check the result against a number you can verify, such as a total.

## Project habits
- Keep each type of query in its own file.
- Commit to Git after each finished step with a clear message.
- Never commit temporary files such as `.db-journal`.