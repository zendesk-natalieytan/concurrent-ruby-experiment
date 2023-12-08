# Ruby Experiment - Sequential requests vs. Concurrent requests using concurrent-ruby promises


## Results

```shell
$ bundle exec ruby lib/profile.rb
  ========== Profiling results for bulk_pokemon_types_with_promise Rounds: 1 ==========
  Total time taken: 0.4094749999931082 seconds
  Total allocated memory: 26163171 bytes
  Total retained memory: 21010742 bytes
  ========== Profiling results for bulk_pokemon_types Rounds: 1 ==========
  Total time taken: 2.4139289999729954 seconds
  Total allocated memory: 5097706 bytes
  Total retained memory: 5941 bytes
  ========== Profiling results for bulk_pokemon_types_with_promise Rounds: 10 ==========
  Total time taken: 7.820813000027556 seconds
  Total allocated memory: 51513008 bytes
  Total retained memory: 73189 bytes
  ========== Profiling results for bulk_pokemon_types Rounds: 10 ==========
  Total time taken: 27.72928899998078 seconds
  Total allocated memory: 50963019 bytes
  Total retained memory: 51680 bytes

```


## Discussion

From the profiling results for the bulk_pokemon_types_with_promise and bulk_pokemon_types methods, we can make the following observations:

### Timing

The bulk_pokemon_types_with_promise method consistently runs significantly faster than the bulk_pokemon_types method. For a single run (Rounds: 1), it's about 4.2 times faster. When run multiple times (Rounds: 10), it's about 3.7 times faster. The promise-based approach allows concurrent execution of requests, resulting in a better speed performance.

### Allocated memory

Allocated Memory: The bulk_pokemon_types_with_promise method generally consumes more memory compared to the bulk_pokemon_types method. The multiple concurrent active promises increase the memory overhead. However, running multiple rounds does not proportionally increase the memory allocation or memory retention. This suggests that garbage collection is happening effectively between the rounds.

### Retained memory

In a single run scenario (Rounds: 1), the bulk_pokemon_types_with_promise method shows considerably higher retained memory compared to the bulk_pokemon_types method. This indicates that more memory is being held up due to unresolved references from the many Promise objects in play. However, in a multi-round scenario (Rounds: 10), retained memory in bulk_pokemon_types_with_promise increases modestly compared to the bulk_pokemon_types case. Given the significantly higher memory use in a single round, it indicates that memory cleanup is more efficient across multiple rounds of execution.

## Summary

To summarize, the bulk_pokemon_types_with_promise approach provides a significant performance gain in terms of request speed at the cost of higher memory consumption and retention. The impact on memory becomes less severe when running multiple rounds of the method, suggesting that garbage collection is generally handling the cleanup efficiently over time.