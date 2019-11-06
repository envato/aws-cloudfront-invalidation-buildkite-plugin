#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following to get more detail on failures of stubs
# export AWS_STUB_DEBUG=/dev/tty

@test "Invalidates given distribution and 1 path" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_DISTRIBUTION_ID=test_id
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS=/something/*

  stub aws "cloudfront create-invalidation --distribution-id test_id --paths /something/* --query Invalidation.Id --output text : echo cloudfront invalidated"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "cloudfront invalidated"
  unstub aws
}

@test "Invalidates given distribution and 1 path in array" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_DISTRIBUTION_ID=test_id
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS_0=/something/*

  stub aws "cloudfront create-invalidation --distribution-id test_id --paths /something/* --query Invalidation.Id --output text : echo cloudfront invalidated"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "cloudfront invalidated"
  unstub aws
}

@test "Invalidates given distribution and 2 paths in array" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_DISTRIBUTION_ID=test_id
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS_0=/something/*
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS_1=/something-else/*

  stub aws "cloudfront create-invalidation --distribution-id test_id --paths /something/* /something-else/* --query Invalidation.Id --output text : echo cloudfront invalidated"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "cloudfront invalidated"
  unstub aws
}

@test "Doesn't attempt to invalidate if the step command fails" {
  export BUILDKITE_COMMAND_EXIT_STATUS=1
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_DISTRIBUTION_ID=test_id
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS=/something/*

  run $PWD/hooks/post-command

  assert_success
}
