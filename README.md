# AWS Cloudfront Invalidation Buildkite Plugin

![Build status](https://badge.buildkite.com/bc93ae8fdb633030909b9c42fc0a89a6712d4407c387209706.svg?branch=main)
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
```

## Configuration

### `distribution-id`

The id of the Cloudfront distribution to create an invalidation for.

### `paths`

One or more [invalidation paths].

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
