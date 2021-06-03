# PostgresBenchmarkLocationStorage
Benchmarking different methods of storing location data (json) into Postgres 12

# Methods
1. Store json as string inside a jsonb array
2. Store as object in jsonb array
3. Break object out into separate columns in another table. Using 'insert'
4. Updating an existing tables Text[]

# Usage
Install docker

```
make run
Then run the queries in benchmark_queries.sql
```

# TODO
The median seems to be calculated incorrectly.