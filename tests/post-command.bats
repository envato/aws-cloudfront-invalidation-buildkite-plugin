#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following to get more detail on failures of stubs
# export AWS_STUB_DEBUG=/dev/tty

@test "Invalidates given distribution and 1 path" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_DISTRIBUTION_ID=test_id
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS=/something/*

  stub aws \
    "sts get-caller-identity : echo checking creds" \
    "cloudfront create-invalidation --distribution-id test_id --paths /something/* --query Invalidation.Id --output text : echo cloudfront invalidated"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "cloudfront invalidated"
  unstub aws
}

@test "Invalidates given distribution and 1 path in array" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_DISTRIBUTION_ID=test_id
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS_0=/something/*

  stub aws \
    "sts get-caller-identity : echo checking creds" \
    "cloudfront create-invalidation --distribution-id test_id --paths /something/* --query Invalidation.Id --output text : echo cloudfront invalidated"

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

  stub aws \
    "sts get-caller-identity : echo checking creds" \
    "cloudfront create-invalidation --distribution-id test_id --paths /something/* /something-else/* --query Invalidation.Id --output text : echo cloudfront invalidated"

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

@test "Retries when insuccessfully submitting a validation request" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_DISTRIBUTION_ID=test_id
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS_0=/something/*
  export BUILDKITE_PLUGIN_AWS_CLOUDFRONT_INVALIDATION_PATHS_1=/something-else/*

  stub aws \
    "sts get-caller-identity : echo checking creds" \
    "cloudfront create-invalidation --distribution-id test_id --paths /something/* /something-else/* --query Invalidation.Id --output text : return 1" \
    "cloudfront create-invalidation --distribution-id test_id --paths /something/* /something-else/* --query Invalidation.Id --output text : echo cloudfront invalidated"
  stub sleep "15 : echo sleeping"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "sleeping"
  assert_output --partial "cloudfront invalidated"
  unstub aws
  unstub sleep
}

@test "Stops executing if a credential problem is detected" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0

  stub aws "sts get-caller-identity : return 1"

  run $PWD/hooks/post-command

  assert_failure
}
