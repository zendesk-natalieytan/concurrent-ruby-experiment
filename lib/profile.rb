# frozen_string_literal: true

require 'benchmark'
require 'memory_profiler'
require_relative 'pokemon_types_api_client' # Assume this is the relative path to your ApiClient class file

def profile_pokemon_types_request(method_name, rounds)
  client = PokemonTypesApiClient.new
  reports = []

  total_time = Benchmark.measure do
    rounds.times do
      report = MemoryProfiler.report do
        method = client.method(method_name)
        method.call
      end
      reports << report
    end
  end

  total_allocated_memory = reports.sum(&:total_allocated_memsize)
  total_retained_memory = reports.sum(&:total_retained_memsize)

  puts <<-TEXT
  ========== Profiling results for #{method_name} Rounds: #{rounds} ==========
  Total time taken: #{total_time.real} seconds
  Total allocated memory: #{total_allocated_memory} bytes
  Total retained memory: #{total_retained_memory} bytes
  TEXT
end

profile_pokemon_types_request('bulk_pokemon_types_with_promise', 1)
profile_pokemon_types_request('bulk_pokemon_types', 1)
profile_pokemon_types_request('bulk_pokemon_types_with_promise', 10)
profile_pokemon_types_request('bulk_pokemon_types', 10)
