# Ruby Experiment - Sequential requests vs. Concurrent requests using concurrent-ruby promises


## Results

```shell
$ bundle exec ruby lib/profile.rb
  ========== Profiling results for bulk_pokemon_types_with_promise Rounds: 1 ==========
  Total time taken: 0.40917699999408796 seconds
  Total allocated memory: 26171440 bytes
  Total retained memory: 21014479 bytes
  ========== Profiling results for bulk_pokemon_types Rounds: 1 ==========
  Total time taken: 2.3772309999912977 seconds
  Total allocated memory: 5096774 bytes
  Total retained memory: 5955 bytes
  ========== Profiling results for bulk_pokemon_types_with_promise Rounds: 10 ==========
  Total time taken: 9.522317999973893 seconds
  Total allocated memory: 51585448 bytes
  Total retained memory: 110492 bytes
  ========== Profiling results for bulk_pokemon_types Rounds: 10 ==========
  Total time taken: 33.59279199998127 seconds
  Total allocated memory: 50963804 bytes
  Total retained memory: 51520 bytes
```

## Discussion

From the updated profiling results for the `bulk_pokemon_types_with_promise` and `bulk_pokemon_types` methods, we can make the following observations:

### Timing

The `bulk_pokemon_types_with_promise` method consistently runs significantly faster than the `bulk_pokemon_types` method. For a single run (Rounds: 1), it's around 5.8 times faster. When run multiple times (Rounds: 10), it's about 3.5 times faster. The promise-based approach allows concurrent execution of requests, resulting in better speed performance.

### Allocated memory

The `bulk_pokemon_types_with_promise` method generally consumes more memory compared to the `bulk_pokemon_types` method. The multiple concurrent active futures increase the memory overhead. However, running multiple rounds doesn't proportionally increase memory allocation or memory retention. This suggests that garbage collection is happening effectively between the rounds.

### Retained memory

In a single run scenario (Rounds: 1), the `bulk_pokemon_types_with_promise` method shows considerably higher retained memory compared to the `bulk_pokemon_types` method. This indicates that more memory is being held up due to unresolved references from the many Future objects in play. However, in a multi-round scenario (Rounds: 10), the retained memory in `bulk_pokemon_types_with_promise` increases modestly compared to the `bulk_pokemon_types` case. Given the significantly higher memory use in a single round, it indicates that memory cleanup is more efficient across multiple rounds of execution.

## Summary

To summarize, the `bulk_pokemon_types_with_promise` approach provides a significant performance gain in terms of request speed at the cost of higher memory consumption and retention. The impact on memory becomes less severe when running multiple rounds of the method, suggesting that garbage collection is generally handling the cleanup efficiently over time. These results reaffirm the trade-off between concurrency and memory usage. If the request latency or volume is high, using concurrent futures can provide a substantial performance benefit.
