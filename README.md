# AWS Cloudfront Invalidation Buildkite Plugin

[![tests](https://github.com/envato/aws-cloudfront-invalidation-buildkite-plugin/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/envato/aws-cloudfront-invalidation-buildkite-plugin/actions/workflows/tests.yml)
[![MIT License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

A [Buildkite plugin] that invalidates AWS Cloudfront caches.

## Example

```yml
steps:
  - plugins:
      - envato/aws-cloudfront-invalidation#v0.1.0:
          distribution-id: <cloudfront-distribution-id>
          paths:
            - <path/files/to/be/invalidated>
          debug: true
```

## Configuration

### `distribution-id`

The id of the Cloudfront distribution to create an invalidation for.

### `paths`

One or more [invalidation paths].

### `debug`

Adds the `--debug` flag to all AWS CLI commands, providing detailed output for troubleshooting.

## Development

To run the tests:

```sh
docker-compose run --rm tests
```

To run the [Buildkite Plugin Linter]:

```sh
docker-compose run --rm lint
```

[Buildkite plugin]: https://buildkite.com/docs/agent/v3/plugins
[Buildkite Plugin Linter]: https://github.com/buildkite-plugins/buildkite-plugin-linter
[invalidation paths]: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html#invalidation-specifying-objects-paths
